/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "security/rsa.hpp"

#include "lib/di/container.hpp"

RSAManager::RSAManager(Logger &logger) :
	logger(logger) {
	n = BN_new();
	d = BN_new();
	mont_ctx = BN_MONT_CTX_new();
}

RSAManager::~RSAManager() {
	if (n) {
		BN_free(n);
	}
	if (d) {
		BN_free(d);
	}
	if (mont_ctx) {
		BN_MONT_CTX_free(mont_ctx);
	}
}

RSAManager &RSAManager::getInstance() {
	return inject<RSAManager>();
}

void RSAManager::start() {
	// Standard CipSoft RSA Key (p and q primes)
	const char* p = "14299623962416399520070177382898895550795403345466153217470516082934737582776038882967213386204600674145392845853859217990626450972452084065728686565928113";
	const char* q = "7630979195970404721891201847792002125535401292779123937207447574596692788513647179235335529307251350570728407373705564708871762033017096809910315212884101";

	try {
		if (!loadPEM("key.pem")) {
			logger.error("File key.pem not found or valid... Setting standard rsa key\n");
			setKey(p, q);
		}
	} catch (const std::exception &e) {
		logger.error("Loading RSA Key from key.pem failed with error: {}\n", e.what());
		logger.error("Switching to a default key...");
		setKey(p, q);
	}
}

void RSAManager::setKey(const char* pString, const char* qString, int base /* = 10*/) {
	BN_CTX* ctx = BN_CTX_new();
	BIGNUM* p = BN_new();
	BIGNUM* q = BN_new();
	BIGNUM* e = BN_new();
	BIGNUM* p_minus_1 = BN_new();
	BIGNUM* q_minus_1 = BN_new();
	BIGNUM* phi = BN_new();

	// Parse p and q
	if (base == 10) {
		BN_dec2bn(&p, pString);
		BN_dec2bn(&q, qString);
	} else {
		BN_hex2bn(&p, pString);
		BN_hex2bn(&q, qString);
	}

	// e = 65537
	BN_set_word(e, 65537);

	// n = p * q
	BN_mul(n, p, q, ctx);

	// phi = (p - 1)(q - 1)
	BN_sub_word(p, 1); // p = p - 1
	BN_sub_word(q, 1); // q = q - 1
	BN_mul(phi, p, q, ctx);

	// d = e^-1 mod phi
	BN_mod_inverse(d, e, phi, ctx);

	// Pre-compute Montgomery context for n
	BN_MONT_CTX_set(mont_ctx, n, ctx);

	BN_free(p);
	BN_free(q);
	BN_free(e);
	BN_free(p_minus_1);
	BN_free(q_minus_1);
	BN_free(phi);
	BN_CTX_free(ctx);
}

void RSAManager::decrypt(char* msg) const {
	// Thread-local memory pool: initialized once per thread, reused forever.
	// Zero allocation cost after first run.
	static thread_local BN_CTX* ctx = BN_CTX_new();

	BN_CTX_start(ctx);

	// Get temporary variables from the pool (no malloc)
	BIGNUM* c = BN_CTX_get(ctx);
	BIGNUM* m = BN_CTX_get(ctx);

	// Convert raw bytes (128 bytes) to BIGNUM
	// OpenSSL BN_bin2bn expects big-endian. Tibia protocol sends 128 bytes.
	// We assume msg is a pointer to the 128 bytes buffer.
	BN_bin2bn(reinterpret_cast<const unsigned char*>(msg), 128, c);

	// Optimized: Use Montgomery Multiplication
	BN_mod_exp_mont(m, c, d, n, ctx, mont_ctx);

	// Convert back to bytes
	// The result 'm' needs to be exported to the 'msg' buffer.
	// Note: BN_bn2bin exports only the significant bytes (no leading zeros).
	// We must pad it to 128 bytes.

	int num_bytes = BN_num_bytes(m);
	int padding = 128 - num_bytes;

	if (padding < 0) {
		// Should not happen if modulus is 1024 bits
		padding = 0;
	}

	// Zero out padding
	if (padding > 0) {
		std::memset(msg, 0, padding);
	}

	// Write key bytes
	BN_bn2bin(m, reinterpret_cast<unsigned char*>(msg) + padding);

	// Release variables back to the pool (no free)
	BN_CTX_end(ctx);
}

bool RSAManager::loadPEM(const std::string &filename) {
	// OpenSSL native PEM reading
	FILE* fp = fopen(filename.c_str(), "r");
	if (!fp) {
		return false;
	}

	// Read generic private key (handles RSA headers, PKCS#1, PKCS#8)
	// We use standard RSA structure helper
	::RSA* rsa_key = PEM_read_RSAPrivateKey(fp, nullptr, nullptr, nullptr);
	fclose(fp);

	if (!rsa_key) {
		unsigned long err = ERR_get_error();
		logger.error("OpenSSL PEM read error: {}", ERR_error_string(err, nullptr));
		return false;
	}

	const BIGNUM *rn, *re, *rd;
	RSA_get0_key(rsa_key, &rn, &re, &rd);

	if (rn && rd) {
		BN_copy(n, rn);
		BN_copy(d, rd);

		// Pre-compute Montgomery context for loaded key
		BN_CTX* ctx = BN_CTX_new();
		BN_MONT_CTX_set(mont_ctx, n, ctx);
		BN_CTX_free(ctx);

		RSA_free(rsa_key);
		return true;
	}

	RSA_free(rsa_key);
	logger.error("PEM file did not contain a valid RSA private key (missing n or d).");
	return false;
}
