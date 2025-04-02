/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/player/party_functions.hpp"

#include "creatures/players/grouping/party.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void PartyFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Party", "", PartyFunctions::luaPartyCreate);
	Lua::registerMetaMethod(L, "Party", "__eq", Lua::luaUserdataCompare);
	Lua::registerMethod(L, "Party", "disband", PartyFunctions::luaPartyDisband);
	Lua::registerMethod(L, "Party", "getLeader", PartyFunctions::luaPartyGetLeader);
	Lua::registerMethod(L, "Party", "setLeader", PartyFunctions::luaPartySetLeader);
	Lua::registerMethod(L, "Party", "getMembers", PartyFunctions::luaPartyGetMembers);
	Lua::registerMethod(L, "Party", "getMemberCount", PartyFunctions::luaPartyGetMemberCount);
	Lua::registerMethod(L, "Party", "getInvitees", PartyFunctions::luaPartyGetInvitees);
	Lua::registerMethod(L, "Party", "getInviteeCount", PartyFunctions::luaPartyGetInviteeCount);
	Lua::registerMethod(L, "Party", "getUniqueVocationsCount", PartyFunctions::luaPartyGetUniqueVocationsCount);
	Lua::registerMethod(L, "Party", "addInvite", PartyFunctions::luaPartyAddInvite);
	Lua::registerMethod(L, "Party", "removeInvite", PartyFunctions::luaPartyRemoveInvite);
	Lua::registerMethod(L, "Party", "addMember", PartyFunctions::luaPartyAddMember);
	Lua::registerMethod(L, "Party", "removeMember", PartyFunctions::luaPartyRemoveMember);
	Lua::registerMethod(L, "Party", "isSharedExperienceActive", PartyFunctions::luaPartyIsSharedExperienceActive);
	Lua::registerMethod(L, "Party", "isSharedExperienceEnabled", PartyFunctions::luaPartyIsSharedExperienceEnabled);
	Lua::registerMethod(L, "Party", "shareExperience", PartyFunctions::luaPartyShareExperience);
	Lua::registerMethod(L, "Party", "setSharedExperience", PartyFunctions::luaPartySetSharedExperience);
}

int32_t PartyFunctions::luaPartyCreate(lua_State* L) {
	// Party(userdata)
	const auto &player = Lua::getUserdataShared<Player>(L, 2, "Player");
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	auto party = player->getParty();
	if (!party) {
		party = Party::create(player);
		g_game().updatePlayerShield(player);
		player->sendCreatureSkull(player);
		Lua::pushUserdata<Party>(L, party);
		Lua::setMetatable(L, -1, "Party");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyDisband(lua_State* L) {
	// party:disband()
	auto* partyPtr = Lua::getRawUserDataShared<Party>(L, 1);
	if (partyPtr && *partyPtr) {
		std::shared_ptr<Party> &party = *partyPtr;
		party->disband();
		party = nullptr;
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyGetLeader(lua_State* L) {
	// party:getLeader()
	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (!party) {
		lua_pushnil(L);
		return 1;
	}

	const auto &leader = party->getLeader();
	if (leader) {
		Lua::pushUserdata<Player>(L, leader);
		Lua::setMetatable(L, -1, "Player");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartySetLeader(lua_State* L) {
	// party:setLeader(player)
	const auto &player = Lua::getPlayer(L, 2);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party) {
		Lua::pushBoolean(L, party->passPartyLeadership(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyGetMembers(lua_State* L) {
	// party:getMembers()
	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (!party) {
		lua_pushnil(L);
		return 1;
	}

	int index = 0;
	lua_createtable(L, party->getMemberCount(), 0);
	for (const auto &player : party->getMembers()) {
		Lua::pushUserdata<Player>(L, player);
		Lua::setMetatable(L, -1, "Player");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int PartyFunctions::luaPartyGetMemberCount(lua_State* L) {
	// party:getMemberCount()
	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party) {
		lua_pushnumber(L, party->getMemberCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyGetInvitees(lua_State* L) {
	// party:getInvitees()
	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party) {
		lua_createtable(L, party->getInvitationCount(), 0);

		int index = 0;
		for (const auto &player : party->getInvitees()) {
			Lua::pushUserdata<Player>(L, player);
			Lua::setMetatable(L, -1, "Player");
			lua_rawseti(L, -2, ++index);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyGetInviteeCount(lua_State* L) {
	// party:getInviteeCount()
	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party) {
		lua_pushnumber(L, party->getInvitationCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyGetUniqueVocationsCount(lua_State* L) {
	// party:getUniqueVocationsCount()
	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party) {
		lua_pushnumber(L, party->getUniqueVocationsCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyAddInvite(lua_State* L) {
	// party:addInvite(player)
	const auto &player = Lua::getPlayer(L, 2);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party && player) {
		Lua::pushBoolean(L, party->invitePlayer(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyRemoveInvite(lua_State* L) {
	// party:removeInvite(player)
	const auto &player = Lua::getPlayer(L, 2);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party && player) {
		Lua::pushBoolean(L, party->removeInvite(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyAddMember(lua_State* L) {
	// party:addMember(player)
	const auto &player = Lua::getPlayer(L, 2);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party && player) {
		Lua::pushBoolean(L, party->joinParty(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyRemoveMember(lua_State* L) {
	// party:removeMember(player)
	const auto &player = Lua::getPlayer(L, 2);
	if (!player) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
		return 1;
	}

	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party && player) {
		Lua::pushBoolean(L, party->leaveParty(player));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyIsSharedExperienceActive(lua_State* L) {
	// party:isSharedExperienceActive()
	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party) {
		Lua::pushBoolean(L, party->isSharedExperienceActive());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyIsSharedExperienceEnabled(lua_State* L) {
	// party:isSharedExperienceEnabled()
	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party) {
		Lua::pushBoolean(L, party->isSharedExperienceEnabled());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartyShareExperience(lua_State* L) {
	// party:shareExperience(experience)
	const uint64_t experience = Lua::getNumber<uint64_t>(L, 2);
	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party) {
		party->shareExperience(experience);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int PartyFunctions::luaPartySetSharedExperience(lua_State* L) {
	// party:setSharedExperience(active)
	const bool active = Lua::getBoolean(L, 2);
	const auto &party = Lua::getUserdataShared<Party>(L, 1, "Party");
	if (party) {
		Lua::pushBoolean(L, party->setSharedExperience(party->getLeader(), active));
	} else {
		lua_pushnil(L);
	}
	return 1;
}
