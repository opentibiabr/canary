/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "io/fileloader.hpp"

#include "creatures/creatures_definitions.hpp"

namespace OTB {
	constexpr Identifier wildcard = { { '\0', '\0', '\0', '\0' } };

	Loader::Loader(const std::string &fileName, const Identifier &acceptedIdentifier) :
		fileContents(fileName) {
		constexpr auto minimalSize = sizeof(Identifier) + sizeof(Node::START) + sizeof(Node::type) + sizeof(Node::END);
		if (fileContents.size() <= minimalSize) {
			throw InvalidOTBFormat {};
		}

		Identifier fileIdentifier;
		std::copy(fileContents.begin(), fileContents.begin() + fileIdentifier.size(), fileIdentifier.begin());
		if (fileIdentifier != acceptedIdentifier && fileIdentifier != wildcard) {
			throw InvalidOTBFormat {};
		}
	}

	using NodeStack = std::stack<Node*, std::vector<Node*>>;
	static Node &getCurrentNode(const NodeStack &nodeStack) {
		if (nodeStack.empty()) {
			throw InvalidOTBFormat {};
		}
		return *nodeStack.top();
	}

	const Node &Loader::parseTree() {
		auto it = fileContents.begin() + sizeof(Identifier);
		if (static_cast<uint8_t>(*it) != Node::START) {
			throw InvalidOTBFormat {};
		}
		root.type = *(++it);
		root.propsBegin = ++it;
		NodeStack parseStack;
		parseStack.push(&root);

		for (; it != fileContents.end(); ++it) {
			switch (static_cast<uint8_t>(*it)) {
				case Node::START: {
					auto &currentNode = getCurrentNode(parseStack);
					if (currentNode.children.empty()) {
						currentNode.propsEnd = it;
					}
					currentNode.children.emplace_back();
					auto &child = currentNode.children.back();
					if (++it == fileContents.end()) {
						throw InvalidOTBFormat {};
					}
					child.type = *it;
					child.propsBegin = it + sizeof(Node::type);
					parseStack.push(&child);
					break;
				}
				case Node::END: {
					auto &currentNode = getCurrentNode(parseStack);
					if (currentNode.children.empty()) {
						currentNode.propsEnd = it;
					}
					parseStack.pop();
					break;
				}
				case Node::ESCAPE: {
					if (++it == fileContents.end()) {
						throw InvalidOTBFormat {};
					}
					break;
				}
				default: {
					break;
				}
			}
		}
		if (!parseStack.empty()) {
			throw InvalidOTBFormat {};
		}

		return root;
	}

	bool Loader::getProps(const Node &node, PropStream &props) {
		auto size = std::distance(node.propsBegin, node.propsEnd);
		if (size == 0) {
			return false;
		}

		std::vector<uint8_t> propBuffer;
		propBuffer.reserve(size);
		bool lastEscaped = false;

		std::for_each(node.propsBegin, node.propsEnd, [&propBuffer, &lastEscaped](const char &byte) {
			if (lastEscaped) {
				lastEscaped = false;
			} else if (byte == Node::ESCAPE) {
				lastEscaped = true;
				return;
			}
			propBuffer.push_back(static_cast<uint8_t>(byte));
		});

		props.init(propBuffer);
		return true;
	}
} // namespace OTB

namespace InternalPropStream {
	template <typename T>
	bool read(T &ret, std::vector<uint8_t> &buffer, size_t &pos, size_t size) {
		size_t bytesNeeded = sizeof(T);
		if (size < bytesNeeded) {
			return false;
		}

		memcpy(&ret, buffer.data() + pos, bytesNeeded);
		pos += bytesNeeded;
		return true;
	}
} // namespace InternalPropStream

PropStream::PropStream(const std::vector<uint8_t> &attributes) :
	buffer(attributes), pos(0) { }

void PropStream::init(const std::vector<uint8_t> &attributes) {
	if (attributes.empty()) {
		g_logger().error("PropStream::init: attributes is empty.");
		return;
	}

	buffer = attributes;
	pos = 0;
}

size_t PropStream::size() const {
	return buffer.size() - pos;
}

bool PropStream::readU8(uint8_t &value) {
	return InternalPropStream::read(value, buffer, pos, size());
}
bool PropStream::readU16(uint16_t &value) {
	return InternalPropStream::read(value, buffer, pos, size());
}
bool PropStream::readU32(uint32_t &value) {
	return InternalPropStream::read(value, buffer, pos, size());
}
bool PropStream::readU64(uint64_t &value) {
	return InternalPropStream::read(value, buffer, pos, size());
}
bool PropStream::readI8(int8_t &value) {
	return InternalPropStream::read(value, buffer, pos, size());
}
bool PropStream::readI16(int16_t &value) {
	return InternalPropStream::read(value, buffer, pos, size());
}
bool PropStream::readI32(int32_t &value) {
	return InternalPropStream::read(value, buffer, pos, size());
}
bool PropStream::readI64(int64_t &value) {
	return InternalPropStream::read(value, buffer, pos, size());
}
bool PropStream::readDouble(double &value) {
	return InternalPropStream::read(value, buffer, pos, size());
}
bool PropStream::readFloat(float &value) {
	return InternalPropStream::read(value, buffer, pos, size());
}
bool PropStream::readBool(bool &value) {
	return InternalPropStream::read(value, buffer, pos, size());
}

bool PropStream::readIntervalInfo(IntervalInfo &info) {
	return InternalPropStream::read(info, buffer, pos, size());
}

bool PropStream::readOutfit(Outfit_t &outfit) {
	return InternalPropStream::read(outfit, buffer, pos, size());
}

bool PropStream::readString(std::string &ret) {
	uint16_t strLen;
	if (!readU16(strLen)) {
		return false;
	}

	if (size() < strLen) {
		return false;
	}

	ret.assign(reinterpret_cast<char*>(buffer.data() + pos), strLen);
	pos += strLen;
	return true;
}

bool PropStream::skip(size_t n) {
	if (size() < n) {
		return false;
	}

	pos += n;
	return true;
}
