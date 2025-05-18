/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "utils/wildcardtree.hpp"

std::shared_ptr<WildcardTreeNode> WildcardTreeNode::getChild(char ch) {
	const auto it = children.find(ch);
	if (it == children.end()) {
		return nullptr;
	}
	return it->second;
}

std::shared_ptr<WildcardTreeNode> WildcardTreeNode::getChild(char ch) const {
	const auto it = children.find(ch);
	if (it == children.end()) {
		return nullptr;
	}
	return it->second;
}

std::shared_ptr<WildcardTreeNode> WildcardTreeNode::addChild(char ch, bool breakp) {
	auto child = getChild(ch);
	if (child) {
		if (breakp && !child->breakpoint) {
			child->breakpoint = true;
		}
	} else {
		const auto [fst, snd] = children.emplace(std::piecewise_construct, std::forward_as_tuple(ch), std::forward_as_tuple(std::make_shared<WildcardTreeNode>(breakp)));
		child = fst->second;
	}
	return child;
}

void WildcardTreeNode::insert(const std::string &str) {
	auto cur = static_self_cast<WildcardTreeNode>();

	const size_t length = str.length() - 1;
	for (size_t pos = 0; pos < length; ++pos) {
		cur = cur->addChild(str[pos], false);
	}

	cur->addChild(str[length], true);
}

void WildcardTreeNode::remove(const std::string &str) {
	auto cur = static_self_cast<WildcardTreeNode>();

	std::stack<std::shared_ptr<WildcardTreeNode>> path;
	path.push(cur);
	size_t len = str.length();
	for (size_t pos = 0; pos < len; ++pos) {
		cur = cur->getChild(str[pos]);
		if (!cur) {
			return;
		}
		path.push(cur);
	}

	cur->breakpoint = false;

	do {
		cur = path.top();
		path.pop();

		if (!cur->children.empty() || cur->breakpoint || path.empty()) {
			break;
		}

		cur = path.top();

		auto it = cur->children.find(str[--len]);
		if (it != cur->children.end()) {
			cur->children.erase(it);
		}
	} while (true);
}

ReturnValue WildcardTreeNode::findOne(const std::string &query, std::string &result) const {
	auto cur = static_self_cast<const WildcardTreeNode>();
	for (const char &pos : query) {
		cur = cur->getChild(pos);
		if (!cur) {
			return RETURNVALUE_PLAYERWITHTHISNAMEISNOTONLINE;
		}
	}

	result = query;

	do {
		const size_t size = cur->children.size();
		if (size == 0) {
			return RETURNVALUE_NOERROR;
		} else if (size > 1 || cur->breakpoint) {
			return RETURNVALUE_NAMEISTOOAMBIGUOUS;
		}

		const auto it = cur->children.begin();
		result += it->first;
		cur = it->second;
	} while (true);
}
