/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "io/fileloader.hpp"

namespace OTB {
	constexpr Identifier wildcard = { { '\0', '\0', '\0', '\0' } };

	Loader::Loader(const std::string &fileName, const Identifier &acceptedIdentifier) :
		fileContents(fileName) {
		constexpr auto minimalSize = sizeof(Identifier) + sizeof(Node::START) + sizeof(Node::type) + sizeof(Node::END);
		if (fileContents.size() <= minimalSize) {
			throw InvalidOTBFormat {};
		}

		Identifier fileIdentifier;

		std::ranges::copy(fileContents | std::views::take(fileIdentifier.size()), fileIdentifier.begin());

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
