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

namespace {
	// Helper for local unique_ptr managing OpenSSL objects
	// Use a more flexible deleter type to handle both void(*)() and int(*)() functions
	template <typename T, typename Deleter = void (*)(T*)>
	using OpenSSLPtr = std::unique_ptr<T, Deleter>;

	// BIO_free returns int, so we need a wrapper or cast if we used the strict template.
	// But using the Deleter template parameter defaults to void(*)(T*) which works for BN_free.
	// For BIO_free we can pass the specific type.
}

RSAManager::RSAManager(Logger &logger) :
	logger(logger) {
	n.reset(BN_new());
	d.reset(BN_new());
	mont_ctx.reset(BN_MONT_CTX_new());

	if (!n || !d || !mont_ctx) {
		throw std::runtime_error("Failed to allocate OpenSSL BIGNUM/Context structures (BN_new/BN_MONT_CTX_new returned null).");
	}
}

// Destructor is defaulted in header

RSAManager &RSAManager::getInstance() {
	return inject<RSAManager>();
}

void RSAManager::start(const std::string &filename) {
	// Standard CipSoft RSA Key (p and q primes)
	const char* p = "14299623962416399520070177382898895550795403345466153217470516082934737582776038882967213386204600674145392845853859217990626450972452084065728686565928113";
	const char* q = "7630979195970404721891201847792002125535401292779123937207447574596692788513647179235335529307251350570728407373705564708871762033017096809910315212884101";

	try {
		if (!loadPEM(filename)) {
			logger.error("File {} not found or valid... Setting standard rsa key\n", filename);
			setKey(p, q);
		}
	} catch (const std::exception &e) {
		logger.error("Loading RSA Key from {} failed with error: {}\n", filename, e.what());
		logger.error("Switching to a default key...");
		setKey(p, q);
	}
}

void RSAManager::setKey(const char* pString, const char* qString, int base /* = 10*/) {
	// RAII Context
	OpenSSLPtr<BN_CTX> ctx(BN_CTX_new(), BN_CTX_free);
	if (!ctx) {
		throw std::runtime_error("Failed to allocate BN_CTX in setKey");
	}

	// Helper to check OpenSSL success returns (1 = success, 0 = failure)
	auto check = [](int result, const char* msg) {
		if (result == 0) {
			throw std::runtime_error(msg);
		}
	};

	// Use raw pointers for parsing to let OpenSSL allocate/manage them,
	// then transfer ownership to RAII wrappers immediately.
	BIGNUM* p_raw = nullptr;
	BIGNUM* q_raw = nullptr;

	try {
		// Parse p and q
		if (base == 10) {
			check(BN_dec2bn(&p_raw, pString), "Failed to parse p (decimal)");
			check(BN_dec2bn(&q_raw, qString), "Failed to parse q (decimal)");
		} else {
			check(BN_hex2bn(&p_raw, pString), "Failed to parse p (hex)");
			check(BN_hex2bn(&q_raw, qString), "Failed to parse q (hex)");
		}
	} catch (...) {
		// If parsing fails mid-way, we must free what was allocated
		if (p_raw) {
			BN_free(p_raw);
		}
		if (q_raw) {
			BN_free(q_raw);
		}
		throw;
	}

	// Transfer to smart pointers
	OpenSSLPtr<BIGNUM> p(p_raw, BN_free);
	OpenSSLPtr<BIGNUM> q(q_raw, BN_free);

	// Other variables can be allocated normally
	auto make_bn = []() {
		BIGNUM* ptr = BN_new();
		if (!ptr) {
			throw std::bad_alloc();
		}
		return OpenSSLPtr<BIGNUM>(ptr, BN_free);
	};

	auto e = make_bn();
	auto phi = make_bn();

	// e = 65537
	check(BN_set_word(e.get(), 65537), "BN_set_word failed");

	// n = p * q
	check(BN_mul(n.get(), p.get(), q.get(), ctx.get()), "BN_mul (n=p*q) failed");

	// phi = (p - 1)(q - 1)
	check(BN_sub_word(p.get(), 1), "BN_sub_word (p-1) failed");
	check(BN_sub_word(q.get(), 1), "BN_sub_word (q-1) failed");
	check(BN_mul(phi.get(), p.get(), q.get(), ctx.get()), "BN_mul (phi) failed");

	// d = e^-1 mod phi
	if (!BN_mod_inverse(d.get(), e.get(), phi.get(), ctx.get())) {
		throw std::runtime_error("BN_mod_inverse failed");
	}

	// Pre-compute Montgomery context for n
	if (!BN_MONT_CTX_set(mont_ctx.get(), n.get(), ctx.get())) {
		throw std::runtime_error("BN_MONT_CTX_set failed");
	}
}

void RSAManager::decrypt(char* msg) const {
	// Thread-local BN_CTX. Using unique_ptr with custom deleter.
	// Initialized once per thread.
	static thread_local OpenSSLPtr<BN_CTX> ctx(BN_CTX_new(), BN_CTX_free);

	if (!ctx) {
		// Try to recover if previous alloc failed (unlikely for thread_local static but safe)
		ctx.reset(BN_CTX_new());
		if (!ctx) {
			logger.error("RSAManager::decrypt: Failed to allocate thread-local BN_CTX");
			return;
		}
	}

	BN_CTX_start(ctx.get());

	// Ensure we clean up the stack frame in BN_CTX
	// Simple RAII for BN_CTX_start/end
	struct BNCTXFrame {
		BN_CTX* c;
		explicit BNCTXFrame(BN_CTX* c) :
			c(c) { }
		~BNCTXFrame() {
			BN_CTX_end(c);
		}
	} frame(ctx.get());

	BIGNUM* c = BN_CTX_get(ctx.get());
	BIGNUM* m = BN_CTX_get(ctx.get());

	if (!c || !m) {
		logger.error("RSAManager::decrypt: BN_CTX_get failed (stack exhausted?)");
		return;
	}

	// Convert raw bytes (128 bytes) to BIGNUM
	if (!BN_bin2bn(reinterpret_cast<const unsigned char*>(msg), 128, c)) {
		logger.error("RSAManager::decrypt: BN_bin2bn failed");
		return;
	}

	// Montgomery Exponentiation: m = c^d mod n
	if (!BN_mod_exp_mont(m, c, d.get(), n.get(), ctx.get(), mont_ctx.get())) {
		unsigned long err = ERR_get_error();
		logger.error("RSAManager::decrypt: BN_mod_exp_mont failed: {}", ERR_error_string(err, nullptr));
		return;
	}

	// Convert back to bytes
	int num_bytes = BN_num_bytes(m);
	int padding = 128 - num_bytes;

	if (padding < 0) {
		logger.error("RSAManager::decrypt: Decrypted data length ({}) exceeds buffer (128)", num_bytes);
		return;
	}

	// Zero out padding
	if (padding > 0) {
		std::memset(msg, 0, padding);
	}

	// Write key bytes
	if (BN_bn2bin(m, reinterpret_cast<unsigned char*>(msg) + padding) != num_bytes) {
		logger.error("RSAManager::decrypt: BN_bn2bin size mismatch");
	}
}

bool RSAManager::loadPEM(const std::string &filename) {
	// BIO_free returns int so we specify the deleter type explicitly
	OpenSSLPtr<BIO, int (*)(BIO*)> bio(BIO_new_file(filename.c_str(), "r"), BIO_free);
	if (!bio) {
		// Not necessarily an error if file doesn't exist, we fallback
		return false;
	}

	OpenSSLPtr<EVP_PKEY> pkey(
		PEM_read_bio_PrivateKey(bio.get(), nullptr, nullptr, nullptr),
		EVP_PKEY_free
	);

	if (!pkey) {
		unsigned long err = ERR_get_error();
		logger.error("RSAManager::loadPEM: OpenSSL PEM read error: {}", ERR_error_string(err, nullptr));
		return false;
	}

	BIGNUM* n_raw = nullptr;
	BIGNUM* d_raw = nullptr;

	// OpenSSL 3.0+ way to get parameters
	// If this fails (e.g. key type is not RSA), we error out.
	if (!EVP_PKEY_get_bn_param(pkey.get(), "n", &n_raw) || !EVP_PKEY_get_bn_param(pkey.get(), "d", &d_raw)) {
		logger.error("RSAManager::loadPEM: Failed to extract 'n' or 'd' from private key (is it RSA?)");
		// Note: EVP_PKEY_get_bn_param allocates new BIGNUMs if successful
		if (n_raw) {
			BN_free(n_raw);
		}
		if (d_raw) {
			BN_free(d_raw);
		}
		return false;
	}

	// Extract to temporaries first to ensure atomicity
	// We use OpenSSLPtr (local type) for temporary management
	OpenSSLPtr<BIGNUM> n_temp(n_raw, BN_free);
	OpenSSLPtr<BIGNUM> d_temp(d_raw, BN_free);

	// Re-compute Montgomery Context use n_temp
	OpenSSLPtr<BN_CTX> ctx(BN_CTX_new(), BN_CTX_free);
	if (!ctx || !BN_MONT_CTX_set(mont_ctx.get(), n_temp.get(), ctx.get())) {
		logger.error("RSAManager::loadPEM: Failed to setup Montgomery Context");
		return false;
	}

	// Commit all changes atomically
	// Transfer ownership from local OpenSSLPtr (void deleter) to member BnPtr (BNDeleter)
	n.reset(n_temp.release());
	d.reset(d_temp.release());

	return true;
}
