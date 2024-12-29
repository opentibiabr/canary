/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "security/rsa.hpp"

#include "lib/di/container.hpp"

RSA::RSA(Logger &logger) :
	logger(logger) {
	mpz_init(n);
	mpz_init2(d, 1024);
}

RSA::~RSA() {
	mpz_clear(n);
	mpz_clear(d);
}

RSA &RSA::getInstance() {
	return inject<RSA>();
}

void RSA::start() {
	const auto p("14299623962416399520070177382898895550795403345466153217470516082934737582776038882967213386204600674145392845853859217990626450972452084065728686565928113");
	const auto q("7630979195970404721891201847792002125535401292779123937207447574596692788513647179235335529307251350570728407373705564708871762033017096809910315212884101");
	try {
		if (!loadPEM("key.pem")) {
			// file doesn't exist - switch to base10-hardcoded keys
			logger.error("File key.pem not found or have problem on loading... Setting standard rsa key\n");
			setKey(p, q);
		}
	} catch (const std::system_error &e) {
		logger.error("Loading RSA Key from key.pem failed with error: {}\n", e.what());
		logger.error("Switching to a default key...");
		setKey(p, q);
	}
}

void RSA::setKey(const char* pString, const char* qString, int base /* = 10*/) {
	mpz_t p;
	mpz_t q;
	mpz_t e;
	mpz_init2(p, 1024);
	mpz_init2(q, 1024);
	mpz_init(e);

	mpz_set_str(p, pString, base);
	mpz_set_str(q, qString, base);

	// e = 65537
	mpz_set_ui(e, 65537);

	// n = p * q
	mpz_mul(n, p, q);

	// d = e^-1 mod (p - 1)(q - 1)
	mpz_t p_1;
	mpz_t q_1;
	mpz_t pq_1;
	mpz_init2(p_1, 1024);
	mpz_init2(q_1, 1024);
	mpz_init2(pq_1, 1024);

	mpz_sub_ui(p_1, p, 1);
	mpz_sub_ui(q_1, q, 1);

	// pq_1 = (p -1)(q - 1)
	mpz_mul(pq_1, p_1, q_1);

	// d = e^-1 mod (p - 1)(q - 1)
	mpz_invert(d, e, pq_1);

	mpz_clear(p_1);
	mpz_clear(q_1);
	mpz_clear(pq_1);

	mpz_clear(p);
	mpz_clear(q);
	mpz_clear(e);
}

void RSA::decrypt(char* msg) const {
	mpz_t c;
	mpz_t m;
	mpz_init2(c, 1024);
	mpz_init2(m, 1024);

	mpz_import(c, 128, 1, 1, 0, 0, msg);

	// m = c^d mod n
	mpz_powm(m, c, d, n);

	const size_t count = (mpz_sizeinbase(m, 2) + 7) / 8;
	std::fill(msg, msg + (128 - count), 0);

	mpz_export(msg + (128 - count), nullptr, 1, 1, 0, 0, m);

	mpz_clear(c);
	mpz_clear(m);
}

std::string RSA::base64Decrypt(const std::string &input) const {
	auto posOfCharacter = [](const uint8_t chr) -> uint16_t {
		if (chr >= 'A' && chr <= 'Z') {
			return chr - 'A';
		}
		if (chr >= 'a' && chr <= 'z') {
			return chr - 'a' + ('Z' - 'A') + 1;
		}
		if (chr >= '0' && chr <= '9') {
			return chr - '0' + ('Z' - 'A') + ('z' - 'a') + 2;
		}
		if (chr == '+' || chr == '-') {
			return 62;
		}
		if (chr == '/' || chr == '_') {
			return 63;
		}
		g_logger().error("[RSA::base64Decrypt] - Invalid base6409");
		return 0;
	};

	if (input.empty()) {
		return {};
	}

	const size_t length = input.length();
	size_t pos = 0;

	std::string output;
	output.reserve(length / 4 * 3);
	while (pos < length) {
		const uint16_t pos1 = posOfCharacter(input[pos + 1]);
		output.push_back(static_cast<std::string::value_type>(((posOfCharacter(input[pos])) << 2) + ((pos1 & 0x30) >> 4)));
		if (input[pos + 2] != '=' && input[pos + 2] != '.') {
			const uint16_t pos2 = posOfCharacter(input[pos + 2]);
			output.push_back(static_cast<std::string::value_type>(((pos1 & 0x0f) << 4) + ((pos2 & 0x3c) >> 2)));
			if (input[pos + 3] != '=' && input[pos + 3] != '.') {
				output.push_back(static_cast<std::string::value_type>(((pos2 & 0x03) << 6) + posOfCharacter(input[pos + 3])));
			}
		}

		pos += 4;
	}

	return output;
}

static const std::string header_old = "-----BEGIN RSA PRIVATE KEY-----";
static const std::string footer_old = "-----END RSA PRIVATE KEY-----";
static const std::string header_new = "-----BEGIN PRIVATE KEY-----";
static const std::string footer_new = "-----END PRIVATE KEY-----";

enum {
	CRYPT_RSA_ASN1_SEQUENCE = 48,
	CRYPT_RSA_ASN1_INTEGER = 2,
	CRYPT_RSA_ASN1_OBJECT = 6,
	CRYPT_RSA_ASN1_BITSTRING = 3
};

uint16_t RSA::decodeLength(char*&pos) const {
	std::array<uint8_t, 4> buffer = { 0 };
	uint16_t length = static_cast<uint8_t>(*pos++);
	if (length & 0x80) {
		uint8_t numLengthBytes = length & 0x7F;
		if (numLengthBytes > 4) {
			g_logger().error("[RSA::decodeLength] - Invalid 'length'");
			return 0;
		}
		// Adjust the copy destination to ensure it doesn't overflow
		auto destIt = buffer.begin() + (4 - numLengthBytes);
		if (destIt < buffer.begin() || destIt + numLengthBytes > buffer.end()) {
			g_logger().error("[RSA::decodeLength] - Invalid copy range");
			return 0;
		}
		// Copy 'numLengthBytes' bytes from 'pos' into 'buffer'
		std::copy_n(pos, numLengthBytes, destIt);
		pos += numLengthBytes;
		// Reconstruct 'length' from 'buffer' (big-endian)
		uint32_t tempLength = 0;
		for (size_t i = 0; i < numLengthBytes; ++i) {
			tempLength = (tempLength << 8) | buffer[4 - numLengthBytes + i];
		}
		if (tempLength > UINT16_MAX) {
			g_logger().error("[RSA::decodeLength] - Length too large");
			return 0;
		}
		length = static_cast<uint16_t>(tempLength);
	}
	return length;
}

void RSA::readHexString(char*&pos, uint16_t length, std::string &output) const {
	output.reserve(static_cast<size_t>(length) * 2);
	for (uint16_t i = 0; i < length; ++i) {
		const auto hex = static_cast<uint8_t>(*pos++);
		output.push_back("0123456789ABCDEF"[(hex >> 4) & 15]);
		output.push_back("0123456789ABCDEF"[hex & 15]);
	}
}

bool RSA::loadPEM(const std::string &filename) {
	std::ifstream file { filename };
	if (!file.is_open()) {
		return false;
	}

	std::string key;
	std::string pString;
	std::string qString;
	for (std::string line; std::getline(file, line); key.append(line))
		;

	if (key.compare(0, header_old.size(), header_old) == 0) {
		if (key.compare(key.size() - footer_old.size(), footer_old.size(), footer_old) != 0) {
			g_logger().error("[RSA::loadPEM] - Missing RSA private key footer");
			return false;
		}

		key = base64Decrypt(key.substr(header_old.size(), key.size() - header_old.size() - footer_old.size()));
	} else if (key.compare(0, header_new.size(), header_new) == 0) {
		if (key.compare(key.size() - footer_new.size(), footer_new.size(), footer_new) != 0) {
			g_logger().error("[RSA::loadPEM] - Missing RSA private key footer");
			return false;
		}

		key = base64Decrypt(key.substr(header_new.size(), key.size() - header_new.size() - footer_new.size()));
	} else {
		g_logger().error("[RSA::loadPEM] - Missing RSA private key header");
		return false;
	}

	char* pos = &key[0];
	if (static_cast<uint8_t>(*pos++) != CRYPT_RSA_ASN1_SEQUENCE) {
		g_logger().error("[RSA::loadPEM] - Invalid unsupported RSA key");
		return false;
	}

	uint16_t length = decodeLength(pos);
	if (length != key.length() - std::distance(&key[0], pos)) {
		g_logger().error("[RSA::loadPEM] - Invalid unsupported RSA key");
		return false;
	}

	auto tag = static_cast<uint8_t>(*pos++);
	if (tag == CRYPT_RSA_ASN1_INTEGER && static_cast<uint8_t>(*(pos + 0)) == 0x01 && static_cast<uint8_t>(*(pos + 1)) == 0x00 && static_cast<uint8_t>(*(pos + 2)) == 0x30) {
		pos += 3;
		tag = CRYPT_RSA_ASN1_SEQUENCE;
	}

	if (tag == CRYPT_RSA_ASN1_SEQUENCE) {
		pos += decodeLength(pos);
		tag = static_cast<uint8_t>(*pos++);
		decodeLength(pos);
		if (tag == CRYPT_RSA_ASN1_BITSTRING) {
			++pos;
		}
		if (static_cast<uint8_t>(*pos++) != CRYPT_RSA_ASN1_SEQUENCE) {
			g_logger().error("[RSA::loadPEM] - Invalid unsupported RSA key");
			return false;
		}

		length = decodeLength(pos);
		if (length != key.length() - std::distance(&key[0], pos)) {
			g_logger().error("[RSA::loadPEM] - Invalid unsupported RSA key");
			return false;
		}

		tag = static_cast<uint8_t>(*pos++);
	}

	if (tag != CRYPT_RSA_ASN1_INTEGER) {
		g_logger().error("[RSA::loadPEM] - Invalid unsupported RSA key");
		return false;
	}

	length = decodeLength(pos);
	pos += length;
	if (length != 1 || static_cast<uint8_t>(*pos) > 2) {
		// public key - we don't have any interest in it
		g_logger().error("[RSA::loadPEM] - Invalid unsupported RSA key");
		return false;
	}

	tag = static_cast<uint8_t>(*pos++);
	if (tag != CRYPT_RSA_ASN1_INTEGER) {
		g_logger().error("[RSA::loadPEM] - Invalid unsupported RSA key");
		return false;
	}

	length = decodeLength(pos);
	pos += length + 1; // Modulus - we don't care
	length = decodeLength(pos);
	pos += length + 1; // Public Exponent - we don't care
	length = decodeLength(pos);
	pos += length + 1; // Private Exponent - we don't care
	length = decodeLength(pos);
	readHexString(pos, length, pString);
	++pos;
	length = decodeLength(pos);
	readHexString(pos, length, qString);
	++pos;
	length = decodeLength(pos);
	pos += length + 1; // Prime Exponent P - we don't care
	length = decodeLength(pos);
	pos += length + 1; // Prime Exponent Q - we don't care
	length = decodeLength(pos);
	pos += length + 1; // Coefficient - we don't care
	++pos;

	setKey(pString.c_str(), qString.c_str(), 16);
	return true;
}
