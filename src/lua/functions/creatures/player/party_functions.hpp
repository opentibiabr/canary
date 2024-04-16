/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class PartyFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "Party", "", PartyFunctions::luaPartyCreate);
		registerMetaMethod(L, "Party", "__eq", PartyFunctions::luaUserdataCompare);
		registerMethod(L, "Party", "disband", PartyFunctions::luaPartyDisband);
		registerMethod(L, "Party", "getLeader", PartyFunctions::luaPartyGetLeader);
		registerMethod(L, "Party", "setLeader", PartyFunctions::luaPartySetLeader);
		registerMethod(L, "Party", "getMembers", PartyFunctions::luaPartyGetMembers);
		registerMethod(L, "Party", "getMemberCount", PartyFunctions::luaPartyGetMemberCount);
		registerMethod(L, "Party", "getInvitees", PartyFunctions::luaPartyGetInvitees);
		registerMethod(L, "Party", "getInviteeCount", PartyFunctions::luaPartyGetInviteeCount);
		registerMethod(L, "Party", "addInvite", PartyFunctions::luaPartyAddInvite);
		registerMethod(L, "Party", "removeInvite", PartyFunctions::luaPartyRemoveInvite);
		registerMethod(L, "Party", "addMember", PartyFunctions::luaPartyAddMember);
		registerMethod(L, "Party", "removeMember", PartyFunctions::luaPartyRemoveMember);
		registerMethod(L, "Party", "isSharedExperienceActive", PartyFunctions::luaPartyIsSharedExperienceActive);
		registerMethod(L, "Party", "isSharedExperienceEnabled", PartyFunctions::luaPartyIsSharedExperienceEnabled);
		registerMethod(L, "Party", "shareExperience", PartyFunctions::luaPartyShareExperience);
		registerMethod(L, "Party", "setSharedExperience", PartyFunctions::luaPartySetSharedExperience);
	}

private:
	static int luaPartyCreate(lua_State* L);
	static int luaPartyDisband(lua_State* L);
	static int luaPartyGetLeader(lua_State* L);
	static int luaPartySetLeader(lua_State* L);
	static int luaPartyGetMembers(lua_State* L);
	static int luaPartyGetMemberCount(lua_State* L);
	static int luaPartyGetInvitees(lua_State* L);
	static int luaPartyGetInviteeCount(lua_State* L);
	static int luaPartyAddInvite(lua_State* L);
	static int luaPartyRemoveInvite(lua_State* L);
	static int luaPartyAddMember(lua_State* L);
	static int luaPartyRemoveMember(lua_State* L);
	static int luaPartyIsSharedExperienceActive(lua_State* L);
	static int luaPartyIsSharedExperienceEnabled(lua_State* L);
	static int luaPartyShareExperience(lua_State* L);
	static int luaPartySetSharedExperience(lua_State* L);
};
