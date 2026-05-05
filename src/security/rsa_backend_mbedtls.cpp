/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "security/rsa_backend.hpp"

#include "lib/logging/logger.hpp"

#include <mbedtls/ctr_drbg.h>
#include <mbedtls/entropy.h>
#include <mbedtls/pk.h>
#include <mbedtls/rsa.h>
#include <mbedtls/version.h>

namespace {
	constexpr size_t RsaBlockSize = 128;

	void initRsa(mbedtls_rsa_context &rsa) {
#if MBEDTLS_VERSION_NUMBER >= 0x03000000
		mbedtls_rsa_init(&rsa);
		mbedtls_rsa_set_padding(&rsa, MBEDTLS_RSA_PKCS_V15, MBEDTLS_MD_NONE);
#else
		mbedtls_rsa_init(&rsa, MBEDTLS_RSA_PKCS_V15, 0);
#endif
	}

	int parseKeyFile(mbedtls_pk_context &pk, const std::string &filename, mbedtls_ctr_drbg_context &ctrDrbg) {
#if MBEDTLS_VERSION_NUMBER >= 0x03000000
		return mbedtls_pk_parse_keyfile(&pk, filename.c_str(), nullptr, mbedtls_ctr_drbg_random, &ctrDrbg);
#else
		return mbedtls_pk_parse_keyfile(&pk, filename.c_str(), nullptr);
#endif
	}

	class MbedTlsMpi {
	public:
		MbedTlsMpi() {
			mbedtls_mpi_init(&mpi);
		}

		~MbedTlsMpi() {
			mbedtls_mpi_free(&mpi);
		}

		MbedTlsMpi(const MbedTlsMpi &) = delete;
		void operator=(const MbedTlsMpi &) = delete;

		mbedtls_mpi* get() {
			return &mpi;
		}

	private:
		mbedtls_mpi mpi;
	};

	void checkMbedTls(int result, const char* message) {
		if (result != 0) {
			throw std::runtime_error(message);
		}
	}
}

class MbedTlsRsaBackend final : public RsaBackend {
public:
	explicit MbedTlsRsaBackend(Logger &logger) :
		logger(logger) {
		mbedtls_pk_init(&pk);
		initRsa(rsa);
		mbedtls_entropy_init(&entropy);
		mbedtls_ctr_drbg_init(&ctrDrbg);

		const char* pers = "canary-rsa";
		checkMbedTls(
			mbedtls_ctr_drbg_seed(&ctrDrbg, mbedtls_entropy_func, &entropy, reinterpret_cast<const unsigned char*>(pers), std::strlen(pers)),
			"mbedtls_ctr_drbg_seed failed"
		);
	}

	~MbedTlsRsaBackend() override {
		mbedtls_ctr_drbg_free(&ctrDrbg);
		mbedtls_entropy_free(&entropy);
		mbedtls_rsa_free(&rsa);
		mbedtls_pk_free(&pk);
	}

	bool loadPEM(const std::string &filename) override {
		std::scoped_lock lock(mutex);
		mbedtls_pk_free(&pk);
		mbedtls_pk_init(&pk);

		if (parseKeyFile(pk, filename, ctrDrbg) != 0) {
			return false;
		}

		if (!mbedtls_pk_can_do(&pk, MBEDTLS_PK_RSA)) {
			return false;
		}

		const mbedtls_rsa_context* rsaFromPk = mbedtls_pk_rsa(pk);
		mbedtls_rsa_free(&rsa);
		initRsa(rsa);
		if (mbedtls_rsa_copy(&rsa, rsaFromPk) != 0) {
			return false;
		}

		return mbedtls_rsa_get_len(&rsa) == RsaBlockSize;
	}

	void setKey(const char* pString, const char* qString, int base) override {
		std::scoped_lock lock(mutex);
		MbedTlsMpi p;
		MbedTlsMpi q;
		MbedTlsMpi n;
		MbedTlsMpi phi;
		MbedTlsMpi e;
		MbedTlsMpi d;
		MbedTlsMpi p1;
		MbedTlsMpi q1;

		checkMbedTls(mbedtls_mpi_read_string(p.get(), base, pString), "mbedtls_mpi_read_string failed");
		checkMbedTls(mbedtls_mpi_read_string(q.get(), base, qString), "mbedtls_mpi_read_string failed");
		checkMbedTls(mbedtls_mpi_mul_mpi(n.get(), p.get(), q.get()), "mbedtls_mpi_mul_mpi failed");
		checkMbedTls(mbedtls_mpi_sub_int(p1.get(), p.get(), 1), "mbedtls_mpi_sub_int failed");
		checkMbedTls(mbedtls_mpi_sub_int(q1.get(), q.get(), 1), "mbedtls_mpi_sub_int failed");
		checkMbedTls(mbedtls_mpi_mul_mpi(phi.get(), p1.get(), q1.get()), "mbedtls_mpi_mul_mpi failed");
		checkMbedTls(mbedtls_mpi_lset(e.get(), 65537), "mbedtls_mpi_lset failed");
		checkMbedTls(mbedtls_mpi_inv_mod(d.get(), e.get(), phi.get()), "mbedtls_mpi_inv_mod failed");

		mbedtls_rsa_free(&rsa);
		initRsa(rsa);
		checkMbedTls(mbedtls_rsa_import(&rsa, n.get(), p.get(), q.get(), d.get(), e.get()), "mbedtls_rsa_import failed");
		checkMbedTls(mbedtls_rsa_complete(&rsa), "mbedtls_rsa_complete failed");
		checkMbedTls(mbedtls_rsa_check_privkey(&rsa), "mbedtls_rsa_check_privkey failed");
	}

	void decrypt(char* msg) const override {
		std::scoped_lock lock(mutex);
		std::array<unsigned char, RsaBlockSize> out {};
		if (mbedtls_rsa_get_len(&rsa) != RsaBlockSize) {
			return;
		}

		if (mbedtls_rsa_private(&rsa, mbedtls_ctr_drbg_random, const_cast<mbedtls_ctr_drbg_context*>(&ctrDrbg), reinterpret_cast<const unsigned char*>(msg), out.data()) != 0) {
			logger.error("RSAManager::decrypt: mbedtls_rsa_private failed");
			return;
		}

		std::memcpy(msg, out.data(), RsaBlockSize);
	}

private:
	Logger &logger;
	mbedtls_pk_context pk;
	mutable mbedtls_rsa_context rsa;
	mbedtls_entropy_context entropy;
	mutable mbedtls_ctr_drbg_context ctrDrbg;
	mutable std::mutex mutex;
};

std::unique_ptr<RsaBackend> createMbedTlsRsaBackend(Logger &logger) {
	return std::make_unique<MbedTlsRsaBackend>(logger);
}
