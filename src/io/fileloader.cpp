/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "io/fileloader.h"

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
		propBuffer.resize(size);
		bool lastEscaped = false;

		auto escapedPropEnd = std::copy_if(node.propsBegin, node.propsEnd, propBuffer.begin(), [&lastEscaped](const char &byte) {
			lastEscaped = byte == static_cast<char>(Node::ESCAPE) && !lastEscaped;
			return !lastEscaped;
		});
		props.init(&propBuffer[0], std::distance(propBuffer.begin(), escapedPropEnd));
		return true;
	}
} // namespace OTB

uint32_t FileStream::tell() const {
	return m_pos;
}

void FileStream::seek(uint32_t pos) {
	if (pos > m_data.size())
		throw std::runtime_error("seek failed");
	m_pos = pos;
}

void FileStream::skip(uint32_t len) {
	seek(tell() + len);
}

uint32_t FileStream::size() const {
	return m_data.size();
}

template <typename T>
bool FileStream::read(T &ret, bool escape) {
	const auto size = sizeof(T);

	if (m_pos + size > m_data.size())
		throw std::runtime_error("read failed");

	if (escape) {
		uint8_t arr[size];
		for (int_fast8_t i = -1; ++i < size;) {
			if (m_data[m_pos] == OTB::Node::ESCAPE)
				++m_pos;

			arr[i] = m_data[m_pos];
			++m_pos;
		}

		memcpy(&ret, &arr[0], size);
	} else {
		memcpy(&ret, &m_data[m_pos], size);
		m_pos += size;
	}

	return true;
}

uint8_t FileStream::getU8() {
	uint8_t v = 0;

	if (m_pos + 1 > m_data.size())
		throw std::runtime_error("read failed");

	// Fast Escape Val
	if (m_nodes > 0 && m_data[m_pos] == OTB::Node::ESCAPE)
		++m_pos;

	v = m_data[m_pos++];

	return v;
}

uint16_t FileStream::getU16() {
	uint16_t v = 0;
	read(v, m_nodes > 0);
	return v;
}

uint32_t FileStream::getU32() {
	uint32_t v = 0;
	read(v, m_nodes > 0);
	return v;
}

uint64_t FileStream::getU64() {
	uint64_t v = 0;
	read(v, m_nodes > 0);
	return v;
}

std::string FileStream::getString() {
	std::string str;
	if (const uint16_t len = getU16(); len > 0 && len < 8192) {
		char buffer[8192];

		if (m_pos + len > m_data.size()) {
			throw std::runtime_error("[FileStream::getString] - Read failed");
			return {};
		}

		str = { (char*)&m_data[m_pos], len };
		m_pos += len;
	} else if (len != 0)
		throw std::runtime_error("[FileStream::getString] - Read failed because string is too big");
	return str;
}

void FileStream::back(uint32_t pos) {
	m_pos -= pos;
}

bool FileStream::isProp(uint8_t prop, bool toNext) {
	if (getU8() == prop) {
		if (!toNext)
			back();
		return true;
	}

	back();
	return false;
}

bool FileStream::startNode(uint8_t type) {
	if (getU8() == OTB::Node::START) {
		if (type == 0 || getU8() == type) {
			++m_nodes;
			return true;
		}

		back();
	}

	back();
	return false;
}

bool FileStream::endNode() {
	if (getU8() == OTB::Node::END) {
		--m_nodes;
		return true;
	}

	back();
	return false;
}
