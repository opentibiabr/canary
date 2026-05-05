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

#include <mbedtls/bignum.h>
#include <mbedtls/ctr_drbg.h>
#include <mbedtls/entropy.h>
#include <mbedtls/error.h>
#include <mbedtls/pk.h>
#include <mbedtls/rsa.h>
#include <mbedtls/version.h>

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <cstddef>
	#include <cstring>
	#include <memory>
	#include <mutex>
	#include <stdexcept>
	#include <string>
	#include <utility>
#endif

namespace {
	constexpr size_t RsaBlockSize = 128;
	constexpr std::array<unsigned char, 10> RsaPersonalization = { 'c', 'a', 'n', 'a', 'r', 'y', '-', 'r', 's', 'a' };

	class MbedTlsRsaError final : public std::runtime_error {
	public:
		using std::runtime_error::runtime_error;
	};

	std::string getMbedTlsError(int result, const char* message) {
		std::array<char, 256> error {};
		mbedtls_strerror(result, error.data(), error.size());
		return fmt::format("{}: {} ({})", message, error.data(), result);
	}

	void checkMbedTls(int result, const char* message) {
		if (result != 0) {
			throw MbedTlsRsaError(getMbedTlsError(result, message));
		}
	}

	void initRsa(mbedtls_rsa_context &rsa) {
#if MBEDTLS_VERSION_NUMBER >= 0x03000000
		mbedtls_rsa_init(&rsa);
#else
		mbedtls_rsa_init(&rsa, MBEDTLS_RSA_PKCS_V15, 0);
#endif
	}

	int setRsaPadding(mbedtls_rsa_context &rsa) {
#if MBEDTLS_VERSION_NUMBER >= 0x03000000
		return mbedtls_rsa_set_padding(&rsa, MBEDTLS_RSA_PKCS_V15, MBEDTLS_MD_NONE);
#else
		return 0;
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

		[[nodiscard]] mbedtls_mpi* get() {
			return &mpi;
		}

		[[nodiscard]] const mbedtls_mpi* get() const {
			return &mpi;
		}

	private:
		mbedtls_mpi mpi;
	};

	class MbedTlsPk {
	public:
		MbedTlsPk() {
			mbedtls_pk_init(&pk);
		}

		~MbedTlsPk() {
			mbedtls_pk_free(&pk);
		}

		MbedTlsPk(const MbedTlsPk &) = delete;
		void operator=(const MbedTlsPk &) = delete;

		[[nodiscard]] mbedtls_pk_context* get() {
			return &pk;
		}

	private:
		mbedtls_pk_context pk;
	};

	class MbedTlsRsa {
	public:
		MbedTlsRsa() {
			initRsa(rsa);

			try {
				checkMbedTls(setRsaPadding(rsa), "mbedtls_rsa_set_padding failed");
			} catch (...) {
				mbedtls_rsa_free(&rsa);
				throw;
			}
		}

		~MbedTlsRsa() {
			mbedtls_rsa_free(&rsa);
		}

		MbedTlsRsa(const MbedTlsRsa &) = delete;
		void operator=(const MbedTlsRsa &) = delete;

		[[nodiscard]] mbedtls_rsa_context* get() {
			return &rsa;
		}

	private:
		mbedtls_rsa_context rsa;
	};

	class MbedTlsRawRsaKey {
	public:
		MbedTlsRawRsaKey() {
			initRsa(rsa);

			try {
				checkMbedTls(setRsaPadding(rsa), "mbedtls_rsa_set_padding failed");
			} catch (...) {
				mbedtls_rsa_free(&rsa);
				throw;
			}
		}

		~MbedTlsRawRsaKey() {
			mbedtls_rsa_free(&rsa);
		}

		MbedTlsRawRsaKey(const MbedTlsRawRsaKey &) = delete;
		void operator=(const MbedTlsRawRsaKey &) = delete;

		void loadFrom(const mbedtls_rsa_context &source) {
			if (mbedtls_rsa_get_len(&source) != RsaBlockSize) {
				throw MbedTlsRsaError("RSA key must be 128 bytes");
			}

			checkMbedTls(mbedtls_rsa_copy(&rsa, &source), "mbedtls_rsa_copy failed");
			checkMbedTls(setRsaPadding(rsa), "mbedtls_rsa_set_padding failed");
		}

		[[nodiscard]] int decrypt(const unsigned char* input, unsigned char* output, mbedtls_ctr_drbg_context &ctrDrbg) {
			return mbedtls_rsa_private(&rsa, mbedtls_ctr_drbg_random, &ctrDrbg, input, output);
		}

	private:
		mbedtls_rsa_context rsa;
	};
}

class MbedTlsRsaBackend final : public RsaBackend {
public:
	explicit MbedTlsRsaBackend(Logger &logger) :
		logger(logger) {
		mbedtls_entropy_init(&entropy);
		mbedtls_ctr_drbg_init(&ctrDrbg);

		try {
			checkMbedTls(
				mbedtls_ctr_drbg_seed(&ctrDrbg, mbedtls_entropy_func, &entropy, RsaPersonalization.data(), RsaPersonalization.size()),
				"mbedtls_ctr_drbg_seed failed"
			);
		} catch (...) {
			mbedtls_ctr_drbg_free(&ctrDrbg);
			mbedtls_entropy_free(&entropy);
			throw;
		}
	}

	~MbedTlsRsaBackend() override {
		mbedtls_ctr_drbg_free(&ctrDrbg);
		mbedtls_entropy_free(&entropy);
	}

	bool loadPEM(const std::string &filename) override {
		MbedTlsPk newPk;

		{
			std::scoped_lock lock(mutex);
			if (parseKeyFile(*newPk.get(), filename, ctrDrbg) != 0) {
				return false;
			}
		}

		if (!mbedtls_pk_can_do(newPk.get(), MBEDTLS_PK_RSA)) {
			return false;
		}

		const mbedtls_rsa_context* rsaFromPk = mbedtls_pk_rsa(*newPk.get());
		MbedTlsRsa newRsa;
		if (mbedtls_rsa_copy(newRsa.get(), rsaFromPk) != 0) {
			return false;
		}

		if (mbedtls_rsa_get_len(newRsa.get()) != RsaBlockSize) {
			return false;
		}

		try {
			auto newKey = std::make_shared<MbedTlsRawRsaKey>();
			newKey->loadFrom(*newRsa.get());
			setActiveKey(std::move(newKey));
		} catch (const MbedTlsRsaError &) {
			return false;
		}

		return true;
	}

	void setKey(const char* pString, const char* qString, int base) override {
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

		MbedTlsRsa newRsa;
		checkMbedTls(mbedtls_rsa_import(newRsa.get(), n.get(), p.get(), q.get(), d.get(), e.get()), "mbedtls_rsa_import failed");
		checkMbedTls(mbedtls_rsa_complete(newRsa.get()), "mbedtls_rsa_complete failed");
		checkMbedTls(mbedtls_rsa_check_privkey(newRsa.get()), "mbedtls_rsa_check_privkey failed");

		if (mbedtls_rsa_get_len(newRsa.get()) != RsaBlockSize) {
			throw MbedTlsRsaError("RSA key must be 128 bytes");
		}

		auto newKey = std::make_shared<MbedTlsRawRsaKey>();
		newKey->loadFrom(*newRsa.get());
		setActiveKey(std::move(newKey));
	}

	void decrypt(char* msg) const override {
		std::scoped_lock lock(mutex);
		if (!activeKey) {
			return;
		}

		std::array<unsigned char, RsaBlockSize> out {};
		const auto result = activeKey->decrypt(reinterpret_cast<const unsigned char*>(msg), out.data(), ctrDrbg);
		if (result != 0) {
			logger.error("RSAManager::decrypt: {}", getMbedTlsError(result, "MbedTLS raw RSA decrypt failed"));
			return;
		}

		std::memcpy(msg, out.data(), RsaBlockSize);
	}

private:
	void setActiveKey(std::shared_ptr<MbedTlsRawRsaKey> newKey) {
		std::scoped_lock lock(mutex);
		activeKey = std::move(newKey);
	}

	Logger &logger;
	mbedtls_entropy_context entropy;
	mutable mbedtls_ctr_drbg_context ctrDrbg;
	std::shared_ptr<MbedTlsRawRsaKey> activeKey;
	mutable std::mutex mutex;
};

std::unique_ptr<RsaBackend> createMbedTlsRsaBackend(Logger &logger) {
	return std::make_unique<MbedTlsRsaBackend>(logger);
}
