/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "declarations.hpp"

class WildcardTreeNode {
public:
	explicit WildcardTreeNode(bool initBreakpoint) :
		breakpoint(initBreakpoint) { }
	WildcardTreeNode(WildcardTreeNode &&other) = default;

	// non-copyable
	WildcardTreeNode(const WildcardTreeNode &) = delete;
	WildcardTreeNode &operator=(const WildcardTreeNode &) = delete;

	WildcardTreeNode* getChild(char ch);
	const WildcardTreeNode* getChild(char ch) const;
	WildcardTreeNode* addChild(char ch, bool breakpoint);

	void insert(const std::string &str);
	void remove(const std::string &str);

	ReturnValue findOne(const std::string &query, std::string &result) const;

private:
	std::map<char, WildcardTreeNode> children;
	bool breakpoint;
};
