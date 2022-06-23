/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "otpch.h"

#include "creatures/players/grouping/groups.h"

#include "utils/tools.h"

const phmap::flat_hash_map<std::string, PlayerFlags> ParsePlayerFlagMap = {
	{"cannotusecombat", PlayerFlag_CannotUseCombat},
	{"cannotattackplayer", PlayerFlag_CannotAttackPlayer},
	{"cannotattackmonster", PlayerFlag_CannotAttackMonster},
	{"cannotbeattacked", PlayerFlag_CannotBeAttacked},
	{"canconvinceall", PlayerFlag_CanConvinceAll},
	{"cansummonall", PlayerFlag_CanSummonAll},
	{"canillusionall", PlayerFlag_CanIllusionAll},
	{"cansenseinvisibility", PlayerFlag_CanSenseInvisibility},
	{"ignoredbymonsters", PlayerFlag_IgnoredByMonsters},
	{"notgaininfight", PlayerFlag_NotGainInFight},
	{"hasinfinitemana", PlayerFlag_HasInfiniteMana},
	{"hasinfinitesoul", PlayerFlag_HasInfiniteSoul},
	{"hasnoexhaustion", PlayerFlag_HasNoExhaustion},
	{"cannotusespells", PlayerFlag_CannotUseSpells},
	{"cannotpickupitem", PlayerFlag_CannotPickupItem},
	{"canalwayslogin", PlayerFlag_CanAlwaysLogin},
	{"canbroadcast", PlayerFlag_CanBroadcast},
	{"canedithouses", PlayerFlag_CanEditHouses},
	{"cannotbebanned", PlayerFlag_CannotBeBanned},
	{"cannotbepushed", PlayerFlag_CannotBePushed},
	{"hasinfinitecapacity", PlayerFlag_HasInfiniteCapacity},
	{"canpushallcreatures", PlayerFlag_CanPushAllCreatures},
	{"cantalkredprivate", PlayerFlag_CanTalkRedPrivate},
	{"cantalkredchannel", PlayerFlag_CanTalkRedChannel},
	{"talkorangehelpchannel", PlayerFlag_TalkOrangeHelpChannel},
	{"notgainexperience", PlayerFlag_NotGainExperience},
	{"notgainmana", PlayerFlag_NotGainMana},
	{"notgainhealth", PlayerFlag_NotGainHealth},
	{"notgainskill", PlayerFlag_NotGainSkill},
	{"setmaxspeed", PlayerFlag_SetMaxSpeed},
	{"specialvip", PlayerFlag_SpecialVIP},
	{"notgenerateloot", PlayerFlag_NotGenerateLoot},
	{"cantalkredchannelanonymous", PlayerFlag_CanTalkRedChannelAnonymous},
	{"ignoreprotectionzone", PlayerFlag_IgnoreProtectionZone},
	{"ignorespellcheck", PlayerFlag_IgnoreSpellCheck},
	{"ignoreweaponcheck", PlayerFlag_IgnoreWeaponCheck},
	{"cannotbemuted", PlayerFlag_CannotBeMuted},
	{"isalwayspremium", PlayerFlag_IsAlwaysPremium}
};

const phmap::flat_hash_map<std::string, PlayerCustomFlags> ParsePlayerCustomFlagMap = {
	{"canmapclickteleport", PlayerCustomFlag_CanMapClickTeleport},
	{"ignoredbynpcs", PlayerCustomFlag_IgnoredByNpcs}
};

bool Groups::load()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/groups.xml");
	if (!result) {
		printXMLError("Error - Groups::load", "data/XML/groups.xml", result);
		return false;
	}

	for (auto groupNode : doc.child("groups").children()) {
		Group group;
		group.id = static_cast<uint16_t>(groupNode.attribute("id").as_uint());
		group.name = groupNode.attribute("name").as_string();
		group.access = groupNode.attribute("access").as_bool();
		group.maxDepotItems = groupNode.attribute("maxdepotitems").as_uint();
		group.maxVipEntries = groupNode.attribute("maxvipentries").as_uint();
		group.flags = static_cast<uint64_t>(groupNode.attribute("flags").as_uint());
		if (pugi::xml_node node = groupNode.child("flags")) {
			for (auto flagNode : node.children()) {
				pugi::xml_attribute attr = flagNode.first_attribute();
				if (!attr || (attr && !attr.as_bool())) {
					continue;
				}

				auto parseFlag = ParsePlayerFlagMap.find(attr.name());
				if (parseFlag != ParsePlayerFlagMap.end()) {
					group.flags |= parseFlag->second;
				}
			}
		}
		group.customflags = static_cast<uint64_t>(groupNode.attribute("customflags").as_uint());

		if (pugi::xml_node node = groupNode.child("customflags")) {
			for (auto customflagNode : node.children()) {
				pugi::xml_attribute attr = customflagNode.first_attribute();
				if (!attr || (attr && !attr.as_bool())) {
					continue;
				}

				auto parseCustomFlag = ParsePlayerCustomFlagMap.find(attr.name());
				if (parseCustomFlag != ParsePlayerCustomFlagMap.end()) {
					group.customflags |= parseCustomFlag->second;
				}
			}
		}

		groups.push_back(group);
	}
	groups.shrink_to_fit();
	return true;
}

Group* Groups::getGroup(uint16_t id)
{
	for (Group& group : groups) {
		if (group.id == id) {
			return &group;
		}
	}
	return nullptr;
}
