/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/websocket/websocket_utils.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <array>
	#include <cctype>
	#include <cstring>
#endif

namespace websocket_utils {
	namespace {
		constexpr std::string_view WEBSOCKET_GUID = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
		constexpr uint8_t OPCODE_CONTINUATION = 0x0;
		constexpr uint8_t OPCODE_TEXT = 0x1;
		constexpr uint8_t OPCODE_BINARY = 0x2;
		constexpr uint8_t OPCODE_CLOSE = 0x8;
		constexpr uint8_t OPCODE_PING = 0x9;
		constexpr uint8_t OPCODE_PONG = 0xA;

		[[nodiscard]] constexpr uint32_t rotl32(uint32_t value, uint32_t shift) {
			return (value << shift) | (value >> (32 - shift));
		}

		void processSHA1MessageBlock(const uint8_t* messageBlock, uint32_t* H) {
			uint32_t W[80];
			for (int i = 0; i < 16; ++i) {
				W[i] = (messageBlock[i * 4] << 24) | (messageBlock[i * 4 + 1] << 16)
					| (messageBlock[i * 4 + 2] << 8) | messageBlock[i * 4 + 3];
			}
			for (int i = 16; i < 80; ++i) {
				W[i] = rotl32(W[i - 3] ^ W[i - 8] ^ W[i - 14] ^ W[i - 16], 1);
			}

			uint32_t A = H[0];
			uint32_t B = H[1];
			uint32_t C = H[2];
			uint32_t D = H[3];
			uint32_t E = H[4];

			for (int i = 0; i < 80; ++i) {
				uint32_t f;
				uint32_t k;
				if (i < 20) {
					f = (B & C) | ((~B) & D);
					k = 0x5A827999;
				} else if (i < 40) {
					f = B ^ C ^ D;
					k = 0x6ED9EBA1;
				} else if (i < 60) {
					f = (B & C) | (B & D) | (C & D);
					k = 0x8F1BBCDC;
				} else {
					f = B ^ C ^ D;
					k = 0xCA62C1D6;
				}

				const uint32_t temp = rotl32(A, 5) + f + E + k + W[i];
				E = D;
				D = C;
				C = rotl32(B, 30);
				B = A;
				A = temp;
			}

			H[0] += A;
			H[1] += B;
			H[2] += C;
			H[3] += D;
			H[4] += E;
		}

		[[nodiscard]] std::array<uint8_t, 20> sha1Raw(std::string_view input) {
			uint32_t H[] = {
				0x67452301,
				0xEFCDAB89,
				0x98BADCFE,
				0x10325476,
				0xC3D2E1F0
			};

			uint8_t messageBlock[64];
			size_t index = 0;
			uint32_t lengthLow = 0;
			uint32_t lengthHigh = 0;

			for (const char ch : input) {
				messageBlock[index++] = static_cast<uint8_t>(ch);
				lengthLow += 8;
				if (lengthLow == 0) {
					++lengthHigh;
				}
				if (index == 64) {
					processSHA1MessageBlock(messageBlock, H);
					index = 0;
				}
			}

			messageBlock[index++] = 0x80;
			if (index > 56) {
				while (index < 64) {
					messageBlock[index++] = 0;
				}
				processSHA1MessageBlock(messageBlock, H);
				index = 0;
			}
			while (index < 56) {
				messageBlock[index++] = 0;
			}

			messageBlock[56] = static_cast<uint8_t>(lengthHigh >> 24);
			messageBlock[57] = static_cast<uint8_t>(lengthHigh >> 16);
			messageBlock[58] = static_cast<uint8_t>(lengthHigh >> 8);
			messageBlock[59] = static_cast<uint8_t>(lengthHigh);
			messageBlock[60] = static_cast<uint8_t>(lengthLow >> 24);
			messageBlock[61] = static_cast<uint8_t>(lengthLow >> 16);
			messageBlock[62] = static_cast<uint8_t>(lengthLow >> 8);
			messageBlock[63] = static_cast<uint8_t>(lengthLow);
			processSHA1MessageBlock(messageBlock, H);

			std::array<uint8_t, 20> hash {};
			for (size_t i = 0; i < hash.size(); ++i) {
				hash[i] = static_cast<uint8_t>(H[i >> 2] >> (((3 - (i & 3)) << 3)));
			}
			return hash;
		}

		[[nodiscard]] std::string base64Encode(const uint8_t* data, size_t length) {
			static constexpr char kChars[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
			std::string out;
			out.reserve(((length + 2) / 3) * 4);
			for (size_t i = 0; i < length; i += 3) {
				const uint32_t b0 = data[i];
				const uint32_t b1 = (i + 1 < length) ? data[i + 1] : 0;
				const uint32_t b2 = (i + 2 < length) ? data[i + 2] : 0;
				const uint32_t triple = (b0 << 16) | (b1 << 8) | b2;
				out.push_back(kChars[(triple >> 18) & 0x3F]);
				out.push_back(kChars[(triple >> 12) & 0x3F]);
				out.push_back((i + 1 < length) ? kChars[(triple >> 6) & 0x3F] : '=');
				out.push_back((i + 2 < length) ? kChars[triple & 0x3F] : '=');
			}
			return out;
		}

		[[nodiscard]] std::string_view trim(std::string_view value) {
			while (!value.empty() && std::isspace(static_cast<unsigned char>(value.front()))) {
				value.remove_prefix(1);
			}
			while (!value.empty() && std::isspace(static_cast<unsigned char>(value.back()))) {
				value.remove_suffix(1);
			}
			return value;
		}

		[[nodiscard]] std::string toLower(std::string_view value) {
			std::string out(value);
			std::ranges::transform(out, out.begin(), [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
			return out;
		}
	} // namespace

	std::string computeAcceptKey(std::string_view clientKey) {
		std::string material;
		material.reserve(clientKey.size() + WEBSOCKET_GUID.size());
		material.append(clientKey);
		material.append(WEBSOCKET_GUID);
		const auto digest = sha1Raw(material);
		return base64Encode(digest.data(), digest.size());
	}

	bool parseUpgradeRequest(std::string_view request, std::string &outClientKey, std::string &outPath) {
		outClientKey.clear();
		outPath.clear();

		const auto headerEnd = request.find("\r\n\r\n");
		if (headerEnd == std::string_view::npos) {
			return false;
		}

		const auto headers = request.substr(0, headerEnd);
		size_t lineStart = 0;
		bool isGet = false;
		bool upgradeWebsocket = false;
		bool connectionUpgrade = false;
		std::string_view version;

		while (lineStart <= headers.size()) {
			const auto lineEnd = headers.find("\r\n", lineStart);
			const auto line = headers.substr(lineStart, (lineEnd == std::string_view::npos ? headers.size() : lineEnd) - lineStart);
			if (lineStart == 0) {
				// GET /path HTTP/1.1
				if (!line.starts_with("GET ")) {
					return false;
				}
				isGet = true;
				const auto pathStart = 4;
				const auto pathEnd = line.find(' ', pathStart);
				if (pathEnd == std::string_view::npos) {
					return false;
				}
				outPath = std::string(line.substr(pathStart, pathEnd - pathStart));
			} else if (!line.empty()) {
				const auto colon = line.find(':');
				if (colon != std::string_view::npos) {
					const auto name = toLower(trim(line.substr(0, colon)));
					const auto value = trim(line.substr(colon + 1));
					if (name == "upgrade") {
						upgradeWebsocket = toLower(value) == "websocket";
					} else if (name == "connection") {
						const auto lower = toLower(value);
						connectionUpgrade = lower.find("upgrade") != std::string::npos;
					} else if (name == "sec-websocket-key") {
						outClientKey = std::string(value);
					} else if (name == "sec-websocket-version") {
						version = value;
					}
				}
			}

			if (lineEnd == std::string_view::npos) {
				break;
			}
			lineStart = lineEnd + 2;
		}

		return isGet && upgradeWebsocket && connectionUpgrade && !outClientKey.empty() && version == "13";
	}

	std::string buildUpgradeResponse(std::string_view acceptKey) {
		std::string response;
		response.reserve(128 + acceptKey.size());
		response.append("HTTP/1.1 101 Switching Protocols\r\n");
		response.append("Upgrade: websocket\r\n");
		response.append("Connection: Upgrade\r\n");
		response.append("Sec-WebSocket-Accept: ");
		response.append(acceptKey);
		response.append("\r\n\r\n");
		return response;
	}

	std::vector<uint8_t> buildFrame(uint8_t opcode, const uint8_t* payload, size_t payloadLength) {
		std::vector<uint8_t> frame;
		frame.push_back(static_cast<uint8_t>(0x80 | (opcode & 0x0F)));

		if (payloadLength < 126) {
			frame.push_back(static_cast<uint8_t>(payloadLength));
		} else if (payloadLength <= 0xFFFF) {
			frame.push_back(126);
			frame.push_back(static_cast<uint8_t>((payloadLength >> 8) & 0xFF));
			frame.push_back(static_cast<uint8_t>(payloadLength & 0xFF));
		} else {
			frame.push_back(127);
			for (int shift = 56; shift >= 0; shift -= 8) {
				frame.push_back(static_cast<uint8_t>((static_cast<uint64_t>(payloadLength) >> shift) & 0xFF));
			}
		}

		if (payload && payloadLength > 0) {
			frame.insert(frame.end(), payload, payload + payloadLength);
		}
		return frame;
	}

	DecodedFrame decodeFrame(const uint8_t* data, size_t size) {
		DecodedFrame decoded;
		if (size < 2) {
			return decoded;
		}

		const uint8_t first = data[0];
		const uint8_t second = data[1];
		const bool fin = (first & 0x80) != 0;
		const uint8_t opcode = first & 0x0F;
		const bool masked = (second & 0x80) != 0;
		uint64_t payloadLength = second & 0x7F;
		size_t headerSize = 2;

		if (payloadLength == 126) {
			if (size < 4) {
				return decoded;
			}
			payloadLength = (static_cast<uint64_t>(data[2]) << 8) | data[3];
			headerSize = 4;
		} else if (payloadLength == 127) {
			if (size < 10) {
				return decoded;
			}
			payloadLength = 0;
			for (int i = 0; i < 8; ++i) {
				payloadLength = (payloadLength << 8) | data[2 + i];
			}
			headerSize = 10;
		}

		if (!masked) {
			// Client frames must be masked.
			decoded.result = FrameResult::Error;
			return decoded;
		}

		const size_t maskOffset = headerSize;
		headerSize += 4;
		if (size < headerSize + payloadLength) {
			return decoded;
		}

		if (!fin && opcode != OPCODE_CONTINUATION) {
			// Fragmented non-continuation start: we only accept complete binary frames.
			decoded.result = FrameResult::Error;
			return decoded;
		}

		decoded.payload.resize(static_cast<size_t>(payloadLength));
		const uint8_t* mask = data + maskOffset;
		const uint8_t* payload = data + headerSize;
		for (size_t i = 0; i < payloadLength; ++i) {
			decoded.payload[i] = payload[i] ^ mask[i % 4];
		}
		decoded.consumedBytes = headerSize + static_cast<size_t>(payloadLength);

		switch (opcode) {
			case OPCODE_BINARY:
				decoded.result = FrameResult::Binary;
				break;
			case OPCODE_TEXT:
				decoded.result = FrameResult::Error;
				break;
			case OPCODE_PING:
				decoded.result = FrameResult::Ping;
				break;
			case OPCODE_PONG:
				decoded.result = FrameResult::Pong;
				break;
			case OPCODE_CLOSE:
				decoded.result = FrameResult::Close;
				break;
			default:
				decoded.result = FrameResult::Error;
				break;
		}
		return decoded;
	}
}
