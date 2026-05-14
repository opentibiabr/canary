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
#include "security/rsa_backend.hpp"

RSAManager::RSAManager(Logger &logger) :
	logger(logger),
	backend(createMbedTlsRsaBackend(logger)) {
}

RSAManager::~RSAManager() = default;

RSAManager &RSAManager::getInstance() {
	return inject<RSAManager>();
}

void RSAManager::start(const std::string &filename) {
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

void RSAManager::setKey(const char* pString, const char* qString, int base) {
	backend->setKey(pString, qString, base);
}

void RSAManager::decrypt(char* msg) const {
	backend->decrypt(msg);
}

bool RSAManager::loadPEM(const std::string &filename) {
	return backend->loadPEM(filename);
}
