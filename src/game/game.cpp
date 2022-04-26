/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include <fstream>
#include "utils/pugicast.h"

#include "lua/creature/actions.h"
#include "items/bed.h"
#include "creatures/creature.h"
#include "lua/creature/creatureevent.h"
#include "database/databasetasks.h"
#include "lua/creature/events.h"
#include "game/game.h"
#include "lua/global/globalevent.h"
#include "io/iologindata.h"
#include "io/iomarket.h"
#include "items/items.h"
#include "lua/scripts/lua_environment.hpp"
#include "creatures/monsters/monster.h"
#include "lua/creature/movement.h"
#include "game/scheduling/scheduler.h"
#include "server/server.h"
#include "creatures/combat/spells.h"
#include "lua/creature/talkaction.h"
#include "items/weapons/weapons.h"
#include "lua/scripts/scripts.h"
#include "lua/modules/modules.h"
#include "creatures/players/imbuements/imbuements.h"
#include "creatures/players/account/account.hpp"
#include "creatures/npcs/npc.h"
#include "creatures/npcs/npcs.h"
#include "server/network/webhook/webhook.h"
#include "protobuf/appearances.pb.h"

Game::Game()
{
	offlineTrainingWindow.choices.emplace_back("Sword Fighting and Shielding", SKILL_SWORD);
	offlineTrainingWindow.choices.emplace_back("Axe Fighting and Shielding", SKILL_AXE);
	offlineTrainingWindow.choices.emplace_back("Club Fighting and Shielding", SKILL_CLUB);
	offlineTrainingWindow.choices.emplace_back("Distance Fighting and Shielding", SKILL_DISTANCE);
	offlineTrainingWindow.choices.emplace_back("Magic Level and Shielding", SKILL_MAGLEVEL);
	offlineTrainingWindow.buttons.emplace_back("Okay", 1);
	offlineTrainingWindow.buttons.emplace_back("Cancel", 0);
	offlineTrainingWindow.defaultEscapeButton = 1;
	offlineTrainingWindow.defaultEnterButton = 0;
	offlineTrainingWindow.priority = true;
}

Game::~Game()
{
	for (const auto& it : guilds) {
		delete it.second;
	}

	for (const auto& it : CharmList) {
		delete it;
	}
}

void Game::loadBoostedCreature()
{
	Database& db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT * FROM `boosted_creature`";
	DBResult_ptr result = db.storeQuery(query.str());

	if (!result) {
		SPDLOG_WARN("[Game::loadBoostedCreature] - "
                    "Failed to detect boosted creature database. (CODE 01)");
		return;
	}

	uint16_t date = result->getNumber<uint16_t>("date");
	std::string name = "";
	time_t now = time(0);
	tm *ltm = localtime(&now);
	uint8_t today = ltm->tm_mday;
	if (date == today) {
		name = result->getString("boostname");
	} else {
		uint16_t oldrace = result->getNumber<uint16_t>("raceid");
		std::map<uint16_t, std::string> monsterlist = getBestiaryList();
		uint16_t newrace = 0;
		uint8_t k = 1;
		while (newrace == 0 || newrace == oldrace) {
			uint16_t random = normal_random(0, monsterlist.size());
			for (auto it : monsterlist) {
				if (k == random) {
					newrace = it.first;
					name = it.second;
				}
				k++;
			}
		}

		const MonsterType* monsterType = g_monsters().getMonsterTypeByRaceId(newrace);

		query.str(std::string());
		query << "UPDATE `boosted_creature` SET ";
		query << "`date` = '" << ltm->tm_mday << "',";
		query << "`boostname` = " << db.escapeString(name) << ",";

		if (monsterType) {
			query << "`looktype` = " << static_cast<int>(monsterType->info.outfit.lookType) << ",";
			query << "`lookfeet` = " << static_cast<int>(monsterType->info.outfit.lookFeet) << ",";
			query << "`looklegs` = " << static_cast<int>(monsterType->info.outfit.lookLegs) << ",";
			query << "`lookhead` = " << static_cast<int>(monsterType->info.outfit.lookHead) << ",";
			query << "`lookbody` = " << static_cast<int>(monsterType->info.outfit.lookBody) << ",";
			query << "`lookaddons` = " << static_cast<int>(monsterType->info.outfit.lookAddons) << ",";
			query << "`lookmount` = " << static_cast<int>(monsterType->info.outfit.lookMount) << ",";
		}

		query << "`raceid` = '" << newrace << "'";

		if (!db.executeQuery(query.str())) {
			SPDLOG_WARN("[Game::loadBoostedCreature] - "
                        "Failed to detect boosted creature database. (CODE 02)");
			return;
		}
	}
	setBoostedName(name);
	SPDLOG_INFO("Boosted creature: {}", name);
}

void Game::start(ServiceManager* manager)
{
	serviceManager = manager;

	time_t now = time(0);
	const tm* tms = localtime(&now);
	int minutes = tms->tm_min;
	lightHour = (minutes * LIGHT_DAY_LENGTH) / 60;

	g_scheduler().addEvent(createSchedulerTask(EVENT_LIGHTINTERVAL_MS, std::bind(&Game::checkLight, this)));
	g_scheduler().addEvent(createSchedulerTask(EVENT_CREATURE_THINK_INTERVAL, std::bind(&Game::checkCreatures, this, 0)));
	g_scheduler().addEvent(createSchedulerTask(EVENT_IMBUEMENT_INTERVAL, std::bind(&Game::checkImbuements, this)));
}

GameState_t Game::getGameState() const
{
	return gameState;
}

void Game::setWorldType(WorldType_t type)
{
	worldType = type;
}

bool Game::loadScheduleEventFromXml()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/events.xml");
	if (!result) {
		printXMLError("Error - Game::loadScheduleEventFromXml", "data/XML/events.xml", result);
		return false;
	}

		int16_t daysNow;
		time_t t = time(NULL);
		tm* timePtr = localtime(&t);
		int16_t daysMath = ((timePtr->tm_year + 1900) * 365) + ((timePtr->tm_mon + 1) * 30) + (timePtr->tm_mday);

	for (auto schedNode : doc.child("events").children()) {
		std::string ss_d;
		std::stringstream ss;

		pugi::xml_attribute attr;
		if ((attr = schedNode.attribute("name"))) {
			ss_d = attr.as_string();
			ss << "> " << ss_d << " event";
		}

		int year;
		int day;
		int month;

		if (!(attr = schedNode.attribute("enddate"))) {
			continue;
		} else {
			ss_d = attr.as_string();
			sscanf(ss_d.c_str(), "%d/%d/%d", &month, &day, &year);
			daysNow = ((year * 365) + (month * 30) + day);
			if (daysMath > daysNow) {
				continue;
			}
		}

		if (!(attr = schedNode.attribute("startdate"))) {
			continue;
		} else {
			ss_d = attr.as_string();
			sscanf(ss_d.c_str(), "%d/%d/%d", &month, &day, &year);
			daysNow = ((year * 365) + (month * 30) + day);
			if (daysMath < daysNow) {
				continue;
			}
		}

		if ((attr = schedNode.attribute("script")) && !(g_scripts().loadEventSchedulerScripts(attr.as_string()))) {
			SPDLOG_WARN("Can not load the file '{}' on '/events/scripts/scheduler/'",
			attr.as_string());
			return false;
		}

		for (auto schedENode : schedNode.children()) {
			if ((schedENode.attribute("exprate"))) {
				uint16_t exprate = pugi::cast<uint16_t>(schedENode.attribute("exprate").value());
				g_game().setExpSchedule(exprate);
				ss << " exp: " << (exprate - 100) << "%";
			}

			if ((schedENode.attribute("lootrate"))) {
				uint16_t lootrate = pugi::cast<uint16_t>(schedENode.attribute("lootrate").value());
				g_game().setLootSchedule(lootrate);
				ss << ", loot: " << (lootrate - 100) << "%";
			}

			if ((schedENode.attribute("spawnrate"))) {
				uint32_t spawnrate = pugi::cast<uint32_t>(schedENode.attribute("spawnrate").value());
				g_game().setSpawnMonsterSchedule(spawnrate);
				ss << ", spawn: "  << (spawnrate - 100) << "%";
			}

			if ((schedENode.attribute("skillrate"))) {
				uint16_t skillrate = pugi::cast<uint16_t>(schedENode.attribute("skillrate").value());
				g_game().setSkillSchedule(skillrate);
				ss << ", skill: " << (skillrate - 100) << "%";
			}
		}
		SPDLOG_INFO(ss.str());
	}
	return true;
}

void Game::setGameState(GameState_t newState)
{
	if (gameState == GAME_STATE_SHUTDOWN) {
		return; //this cannot be stopped
	}

	if (gameState == newState) {
		return;
	}

	gameState = newState;
	switch (newState) {
		case GAME_STATE_INIT: {
			loadItemsPrice();

			groups.load();
			g_chat().load();

			// Load monsters and npcs stored by the "loadFromXML" function
			map.spawnsMonster.startup();
			map.spawnsNpc.startup();

			// Load monsters and npcs custom stored by the "loadFromXML" function
			map.spawnsMonsterCustom.startup();
			map.spawnsNpcCustom.startup();

			raids.loadFromXml();
			raids.startup();

			mounts.loadFromXml();

			if (!g_configManager().getBoolean(STOREMODULES)) {
				gameStore.loadFromXml();
				gameStore.startup();
			}

			loadMotdNum();
			loadPlayersRecord();

			g_globalEvents().startup();
			break;
		}

		case GAME_STATE_SHUTDOWN: {
			g_globalEvents().execute(GLOBALEVENT_SHUTDOWN);

			//kick all players that are still online
			auto it = players.begin();
			while (it != players.end()) {
				it->second->removePlayer(true);
				it = players.begin();
			}

			saveMotdNum();
			saveGameState();

			g_dispatcher().addTask(
				createTask(std::bind(&Game::shutdown, this)));

			g_scheduler().stop();
			g_databaseTasks().stop();
			g_dispatcher().stop();
			break;
		}

		case GAME_STATE_CLOSED: {
			/* kick all players without the CanAlwaysLogin flag */
			auto it = players.begin();
			while (it != players.end()) {
				if (!it->second->hasFlag(PlayerFlag_CanAlwaysLogin)) {
					it->second->removePlayer(true);
					it = players.begin();
				} else {
					++it;
				}
			}

			saveGameState();
			break;
		}

		default:
			break;
	}
}

void Game::onPressHotkeyEquip(uint32_t playerId, uint16_t itemId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Item* item;
	const ItemType& itemType = Item::items[itemId];

	if (itemType.id == 0) {
		return;
	}

	bool removed = false;
	ReturnValue ret = RETURNVALUE_NOERROR;

	if (itemType.weaponType == WEAPON_AMMO) {
		Thing* quiverThing = player->getThing(CONST_SLOT_RIGHT);
		Thing* backpackThing = player->getThing(CONST_SLOT_BACKPACK);
		if (quiverThing && backpackThing) {
			Item* quiver = quiverThing->getItem();
			Item* backpack = backpackThing->getItem();
			if (quiver && quiver->isQuiver() && backpack) {
				item = findItemOfType(backpack->getContainer(), itemType.id);
				if (item) {
					ret = internalMoveItem(item->getParent(), quiver->getContainer(), 0, item, item->getItemCount(), nullptr);
				}
				else {
					ret = RETURNVALUE_NOTPOSSIBLE;
				}
			}
			else {
				ret = RETURNVALUE_NOTPOSSIBLE;
			}
		}
	} else {
		item = findItemOfType(player, itemType.id);

		if (!item) {
			item = findItemOfType(player, itemType.transformEquipTo);
			if (!item) {
				item = findItemOfType(player, itemType.transformDeEquipTo);
			}
			if (!item) {
				player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
				return;
			}
		}

		const ItemType& newitemType = Item::items[item->getID()];

		if (newitemType.id == 0) {
			return;
		}

		int32_t slotP = newitemType.slotPosition;
		if (itemType.weaponType == WEAPON_SHIELD || itemType.type == ITEM_TYPE_QUIVER) {
			slotP = CONST_SLOT_RIGHT;
		}
		else if (hasBitSet(SLOTP_HEAD, slotP)) {
			slotP = CONST_SLOT_HEAD;
		}
		else if (hasBitSet(SLOTP_RING, slotP)) {
			slotP = CONST_SLOT_RING;
		}
		else if (hasBitSet(SLOTP_NECKLACE, slotP)) {
			slotP = CONST_SLOT_NECKLACE;
		}
		else if (hasBitSet(SLOTP_ARMOR, slotP)) {
			slotP = CONST_SLOT_ARMOR;
		}
		else if (hasBitSet(SLOTP_LEGS, slotP)) {
			slotP = CONST_SLOT_LEGS;
		}
		else if (hasBitSet(SLOTP_FEET, slotP)) {
			slotP = CONST_SLOT_FEET;
		}
		else if (hasBitSet(SLOTP_AMMO, slotP)) {
			slotP = CONST_SLOT_AMMO;
		}
		else if (hasBitSet(SLOTP_LEFT, slotP) && !hasBitSet(SLOTP_TWO_HAND, slotP)) {
			slotP = CONST_SLOT_LEFT;
		}

		if (hasBitSet(SLOTP_TWO_HAND, slotP)) {
			Thing* leftthing = player->getThing(CONST_SLOT_LEFT);
			if (leftthing) {
				Item* slotLeft_item = leftthing->getItem();
				if (slotLeft_item) {
					if (slotLeft_item->getID() == item->getID()) {
						removed = true;
					}
					ret = internalMoveItem(slotLeft_item->getParent(), player, 0, slotLeft_item, slotLeft_item->getItemCount(), nullptr);
				}
			}
			Thing* rightthing = player->getThing(CONST_SLOT_RIGHT);
			if (rightthing) {
				Item* slotRight_Item = rightthing->getItem();
				if (slotRight_Item) {
					if (newitemType.weaponType != WEAPON_DISTANCE || !slotRight_Item->isQuiver())
						ret = internalMoveItem(slotRight_Item->getParent(), player, 0, slotRight_Item, slotRight_Item->getItemCount(), nullptr);
				}
				else {
					return;
				}
			}
			if (!removed) {
				ret = internalMoveItem(item->getParent(), player, CONST_SLOT_LEFT, item, item->getItemCount(), nullptr);
			}
		}
		else if (hasBitSet(SLOTP_RING, slotP)) {
			Thing* ringthing = player->getThing(CONST_SLOT_RING);
			if (ringthing) {
				Item* slotRing_Item = ringthing->getItem();
				if (slotRing_Item) {
					ret = internalMoveItem(slotRing_Item->getParent(), player, 0, slotRing_Item, slotRing_Item->getItemCount(), nullptr);
					if (slotRing_Item->getID() == item->getID()) {
						removed = true;
					}
				}
				else {
					return;
				}
			}
			if (!removed) {
				ret = internalMoveItem(item->getParent(), player, CONST_SLOT_RING, item, item->getItemCount(), nullptr);
			}
		}
		else if (slotP == CONST_SLOT_RIGHT) {
			Thing* rightthing = player->getThing(CONST_SLOT_RIGHT);
			if (rightthing) {
				Item* slotRight_Item = rightthing->getItem();
				if (slotRight_Item) {
					if (slotRight_Item->getID() == item->getID()) {
						removed = true;
					}
					ret = internalMoveItem(slotRight_Item->getParent(), player, 0, slotRight_Item, slotRight_Item->getItemCount(), nullptr);
				}
				else {
					return;
				}
			}
			Thing* leftthing = player->getThing(CONST_SLOT_LEFT);
			if (leftthing) {
				Item* slotLeft_item = leftthing->getItem();
				if (slotLeft_item) {
					ItemType& it = Item::items.getItemType(slotLeft_item->getID());
					if (hasBitSet(SLOTP_TWO_HAND, it.slotPosition)) {
						if (newitemType.type != ITEM_TYPE_QUIVER || slotLeft_item->getWeaponType() != WEAPON_DISTANCE)
							ret = internalMoveItem(slotLeft_item->getParent(), player, 0, slotLeft_item, slotLeft_item->getItemCount(), nullptr);
					}
				}
				else {
					return;
				}
			}
			if (!removed) {
				ret = internalMoveItem(item->getParent(), player, slotP, item, item->getItemCount(), nullptr);
			}
		}
		else if (slotP) {
			if (newitemType.stackable) {
				Thing* ammothing = player->getThing(slotP);
				if (ammothing) {
					Item* ammoItem = ammothing->getItem();
					if (ammoItem) {
						ObjectCategory_t category = getObjectCategory(ammoItem);
						if (ammoItem->getID() == item->getID()) {
							if (item->getDuration() > 0 ||
								ammoItem->getItemCount() == 100 ||
								ammoItem->getItemCount() == player->getItemTypeCount(ammoItem->getID())) {
								ret = internalQuickLootItem(player, ammoItem, category);
								if (ret != RETURNVALUE_NOERROR) {
									ret = internalMoveItem(ammoItem->getParent(), player, 0, ammoItem, ammoItem->getItemCount(), nullptr);
								}
								if (ret != RETURNVALUE_NOERROR) {
									player->sendCancelMessage(ret);
								}
								return;
							}
						}
						else {
							ret = internalQuickLootItem(player, ammoItem, category);
							if (ret != RETURNVALUE_NOERROR) {
								ret = internalMoveItem(ammoItem->getParent(), player, 0, ammoItem, ammoItem->getItemCount(), nullptr);
							}
						}
					}
					else {
						return;
					}
				}
				ReturnValue ret2 = player->queryAdd(slotP, *item, item->getItemCount(), 0);
				if (ret2 != RETURNVALUE_NOERROR) {
					player->sendCancelMessage(ret2);
					return;
				}
				if (item->getItemCount() < 100 &&
					item->getItemCount() < player->getItemTypeCount(item->getID(), -1) &&
					item->getDuration() <= 0) {
					uint16_t count = 0;
					while (player->getItemTypeCount(item->getID())) {
						if (count == 100) {
							break;
						}
						Container* mainBP = player->getInventoryItem(CONST_SLOT_BACKPACK)->getContainer();
						Item* _item = findItemOfType(mainBP, item->getID());

						if (!_item) {
							break;
						}

						if (_item->getItemCount() > 100 - count) {
							internalRemoveItem(_item, 100 - count);
							count = 100;
						}
						else {
							count = count + _item->getItemCount();
							internalRemoveItem(_item, _item->getItemCount());
						}
					}
					Item* newSlotitem = Item::CreateItem(item->getID(), count);
					internalAddItem(player, newSlotitem, slotP, FLAG_NOLIMIT);
					return;
				}
				else {
					ret = internalMoveItem(item->getParent(), player, slotP, item, item->getItemCount(), nullptr);
				}
			}
			else {
				Thing* slotthing = player->getThing(slotP);
				if (slotthing) {
					Item* slotItem = slotthing->getItem();
					if (slotItem) {
						ret = internalMoveItem(slotItem->getParent(), player, 0, slotItem, slotItem->getItemCount(), nullptr);
						if (slotItem->getID() == item->getID()) {
							removed = true;
						}
					}
					else {
						return;
					}
				}
				if (!removed) {
					ret = internalMoveItem(item->getParent(), player, slotP, item, item->getItemCount(), nullptr);
				}
			}
		}
	}

	if (ret != RETURNVALUE_NOERROR) {
		player->sendCancelMessage(ret);
	}
	return;
}

void Game::saveGameState()
{
	if (gameState == GAME_STATE_NORMAL) {
		setGameState(GAME_STATE_MAINTAIN);
	}

	SPDLOG_INFO("Saving server...");

	for (const auto& it : players) {
		it.second->loginPosition = it.second->getPosition();
		IOLoginData::savePlayer(it.second);
	}

	for (const auto& it : guilds) {
		IOGuild::saveGuild(it.second);
	}

	Map::save();

	g_databaseTasks().flush();

	if (gameState == GAME_STATE_MAINTAIN) {
		setGameState(GAME_STATE_NORMAL);
	}
}

bool Game::loadItemsPrice()
{
	itemsSaleCount = 0;
	std::ostringstream query, query2;
	query << "SELECT DISTINCT `itemtype` FROM `market_offers`;";

	Database& db = Database::getInstance();
	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return false;
	}

	do {
		query2.str(std::string());
		uint16_t itemId = result->getNumber<uint16_t>("itemtype");
		query2 << "SELECT `price` FROM `market_offers` WHERE `itemtype` = " << itemId << " ORDER BY `price` DESC LIMIT 1";
		DBResult_ptr resultQuery2 = db.storeQuery(query2.str());
		if (resultQuery2) {
			itemsPriceMap[itemId] = resultQuery2->getNumber<uint32_t>("price");
			itemsSaleCount++;
		}

	} while (result->next());


	return true;
}

bool Game::loadMainMap(const std::string& filename)
{
	Monster::despawnRange = g_configManager().getNumber(DEFAULT_DESPAWNRANGE);
	Monster::despawnRadius = g_configManager().getNumber(DEFAULT_DESPAWNRADIUS);
	return map.loadMap("data/world/" + filename + ".otbm", true, true, true, true);
}

bool Game::loadCustomMap(const std::string& filename)
{
	Monster::despawnRange = g_configManager().getNumber(DEFAULT_DESPAWNRANGE);
	Monster::despawnRadius = g_configManager().getNumber(DEFAULT_DESPAWNRADIUS);
	return map.loadMapCustom("data/world/custom/" + filename + ".otbm", true, true, true);
}

void Game::loadMap(const std::string& path)
{
	map.loadMap(path);
}

Cylinder* Game::internalGetCylinder(Player* player, const Position& pos) const
{
	if (pos.x != 0xFFFF) {
		return map.getTile(pos);
	}

	//container
	if (pos.y & 0x40) {
		uint8_t from_cid = pos.y & 0x0F;
		return player->getContainerByID(from_cid);
	}

	//inventory
	return player;
}

Thing* Game::internalGetThing(Player* player, const Position& pos, int32_t index, uint32_t itemId, StackPosType_t type) const
{
	if (pos.x != 0xFFFF) {
		Tile* tile = map.getTile(pos);
		if (!tile) {
			return nullptr;
		}

		Thing* thing;
		switch (type) {
			case STACKPOS_LOOK: {
				return tile->getTopVisibleThing(player);
			}

			case STACKPOS_MOVE: {
				Item* item = tile->getTopDownItem();
				if (item && item->isMoveable()) {
					thing = item;
				} else {
					thing = tile->getTopVisibleCreature(player);
				}
				break;
			}

			case STACKPOS_USEITEM: {
				thing = tile->getUseItem(index);
				break;
			}

			case STACKPOS_TOPDOWN_ITEM: {
				thing = tile->getTopDownItem();
				break;
			}

			case STACKPOS_USETARGET: {
				thing = tile->getTopVisibleCreature(player);
				if (!thing) {
					thing = tile->getUseItem(index);
				}
				break;
			}

			case STACKPOS_FIND_THING: {
				thing = tile->getUseItem(index);
				if (!thing) {
					thing = tile->getDoorItem();
				}

				if (!thing) {
					thing = tile->getTopDownItem();
				}

				break;
			}

			default: {
				thing = nullptr;
				break;
			}
		}

		if (player && tile->hasFlag(TILESTATE_SUPPORTS_HANGABLE)) {
			//do extra checks here if the thing is accessable
			if (thing && thing->getItem()) {
				if (tile->hasProperty(CONST_PROP_ISVERTICAL)) {
					if (player->getPosition().x + 1 == tile->getPosition().x && thing->getItem()->isHangable()) {
						thing = nullptr;
					}
				} else { // horizontal
					if (player->getPosition().y + 1 == tile->getPosition().y && thing->getItem()->isHangable()) {
						thing = nullptr;
					}
				}
			}
		}
		return thing;
	}

	//container
	if (pos.y & 0x40) {
		uint8_t fromCid = pos.y & 0x0F;

		Container* parentContainer = player->getContainerByID(fromCid);
		if (!parentContainer) {
			return nullptr;
		}

		if (parentContainer->getID() == ITEM_BROWSEFIELD) {
			Tile* tile = parentContainer->getTile();
			if (tile && tile->hasFlag(TILESTATE_SUPPORTS_HANGABLE)) {
				if (tile->hasProperty(CONST_PROP_ISVERTICAL)) {
					if (player->getPosition().x + 1 == tile->getPosition().x) {
						return nullptr;
					}
				} else { // horizontal
					if (player->getPosition().y + 1 == tile->getPosition().y) {
						return nullptr;
					}
				}
			}
		}

		uint8_t slot = pos.z;
		return parentContainer->getItemByIndex(player->getContainerIndex(fromCid) + slot);
	} else if (pos.y == 0 && pos.z == 0) {
		const ItemType& it = Item::items[itemId];
		if (it.id == 0) {
			return nullptr;
		}

		int32_t subType;
		if (it.isFluidContainer()) {
			subType = index;
		} else {
			subType = -1;
		}

		return findItemOfType(player, it.id, true, subType);
	}

	//inventory
	Slots_t slot = static_cast<Slots_t>(pos.y);
	return player->getInventoryItem(slot);
}

void Game::internalGetPosition(Item* item, Position& pos, uint8_t& stackpos)
{
	pos.x = 0;
	pos.y = 0;
	pos.z = 0;
	stackpos = 0;

	Cylinder* topParent = item->getTopParent();
	if (topParent) {
		if (Player* player = dynamic_cast<Player*>(topParent)) {
			pos.x = 0xFFFF;

			Container* container = dynamic_cast<Container*>(item->getParent());
			if (container) {
				pos.y = static_cast<uint16_t>(0x40) | static_cast<uint16_t>(player->getContainerID(container));
				pos.z = container->getThingIndex(item);
				stackpos = pos.z;
			} else {
				pos.y = player->getThingIndex(item);
				stackpos = pos.y;
			}
		} else if (Tile* tile = topParent->getTile()) {
			pos = tile->getPosition();
			stackpos = tile->getThingIndex(item);
		}
	}
}

Creature* Game::getCreatureByID(uint32_t id)
{
	if (id <= Player::playerAutoID) {
		return getPlayerByID(id);
	} else if (id <= Monster::monsterAutoID) {
		return getMonsterByID(id);
	} else if (id <= Npc::npcAutoID) {
		return getNpcByID(id);
	}
	return nullptr;
}

Monster* Game::getMonsterByID(uint32_t id)
{
	if (id == 0) {
		return nullptr;
	}

	auto it = monsters.find(id);
	if (it == monsters.end()) {
		return nullptr;
	}
	return it->second;
}

Npc* Game::getNpcByID(uint32_t id)
{
	if (id == 0) {
		return nullptr;
	}

	auto it = npcs.find(id);
	if (it == npcs.end()) {
		return nullptr;
	}
	return it->second;
}

Player* Game::getPlayerByID(uint32_t id)
{
	auto playerMap = players.find(id);
	if (playerMap != players.end()) {
		return playerMap->second;
	}

	return nullptr;
}

Creature* Game::getCreatureByName(const std::string& s)
{
	if (s.empty()) {
		return nullptr;
	}

	const std::string& lowerCaseName = asLowerCaseString(s);

	auto m_it = mappedPlayerNames.find(lowerCaseName);
	if (m_it != mappedPlayerNames.end()) {
		return m_it->second;
	}

	for (const auto& it : npcs) {
		if (lowerCaseName == asLowerCaseString(it.second->getName())) {
			return it.second;
		}
	}

	for (const auto& it : monsters) {
		if (lowerCaseName == asLowerCaseString(it.second->getName())) {
			return it.second;
		}
	}
	return nullptr;
}

Npc* Game::getNpcByName(const std::string& s)
{
	if (s.empty()) {
		return nullptr;
	}

	const char* npcName = s.c_str();
	for (const auto& it : npcs) {
		if (strcasecmp(npcName, it.second->getName().c_str()) == 0) {
			return it.second;
		}
	}
	return nullptr;
}

Player* Game::getPlayerByName(const std::string& s)
{
	if (s.empty()) {
		return nullptr;
	}

	auto it = mappedPlayerNames.find(asLowerCaseString(s));
	if (it == mappedPlayerNames.end()) {
		return nullptr;
	}
	return it->second;
}

Player* Game::getPlayerByGUID(const uint32_t& guid)
{
	if (guid == 0) {
		return nullptr;
	}

	for (const auto& it : players) {
		if (guid == it.second->getGUID()) {
			return it.second;
		}
	}
	return nullptr;
}

ReturnValue Game::getPlayerByNameWildcard(const std::string& s, Player*& player)
{
	size_t strlen = s.length();
	if (strlen == 0 || strlen > 20) {
		return RETURNVALUE_PLAYERWITHTHISNAMEISNOTONLINE;
	}

	if (s.back() == '~') {
		const std::string& query = asLowerCaseString(s.substr(0, strlen - 1));
		std::string result;
		ReturnValue ret = wildcardTree.findOne(query, result);
		if (ret != RETURNVALUE_NOERROR) {
			return ret;
		}

		player = getPlayerByName(result);
	} else {
		player = getPlayerByName(s);
	}

	if (!player) {
		return RETURNVALUE_PLAYERWITHTHISNAMEISNOTONLINE;
	}

	return RETURNVALUE_NOERROR;
}

Player* Game::getPlayerByAccount(uint32_t acc)
{
	for (const auto& it : players) {
		if (it.second->getAccount() == acc) {
			return it.second;
		}
	}
	return nullptr;
}

bool Game::internalPlaceCreature(Creature* creature, const Position& pos, bool extendedPos /*=false*/, bool forced /*= false*/, bool creatureCheck /*= false*/)
{
	if (creature->getParent() != nullptr) {
		return false;
	}

	if (!map.placeCreature(pos, creature, extendedPos, forced)) {
		return false;
	}

	creature->incrementReferenceCounter();
	creature->setID();
	creature->addList();

	if (creatureCheck) {
		addCreatureCheck(creature);
		creature->onPlacedCreature();
	}

	return true;
}

bool Game::placeCreature(Creature* creature, const Position& pos, bool extendedPos /*=false*/, bool forced /*= false*/)
{
	if (!internalPlaceCreature(creature, pos, extendedPos, forced)) {
		return false;
	}

	SpectatorHashSet spectators;
	map.getSpectators(spectators, creature->getPosition(), true);
	for (Creature* spectator : spectators) {
		if (Player* tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendCreatureAppear(creature, creature->getPosition(), true);
		}
	}

	for (Creature* spectator : spectators) {
		spectator->onCreatureAppear(creature, true);
	}

	creature->getParent()->postAddNotification(creature, nullptr, 0);

	addCreatureCheck(creature);
	creature->onPlacedCreature();
	return true;
}

bool Game::removeCreature(Creature* creature, bool isLogout/* = true*/)
{
	if (creature->isRemoved()) {
		return false;
	}

	Tile* tile = creature->getTile();

	std::vector<int32_t> oldStackPosVector;

	SpectatorHashSet spectators;
	map.getSpectators(spectators, tile->getPosition(), true);
	for (Creature* spectator : spectators) {
		if (Player* player = spectator->getPlayer()) {
			oldStackPosVector.push_back(player->canSeeCreature(creature) ? tile->getStackposOfCreature(player, creature) : -1);
		}
	}

	tile->removeCreature(creature);

	const Position& tilePosition = tile->getPosition();

	//send to client
	size_t i = 0;
	for (Creature* spectator : spectators) {
		if (Player* player = spectator->getPlayer()) {
			player->sendRemoveTileThing(tilePosition, oldStackPosVector[i++]);
		}
	}

	//event method
	for (Creature* spectator : spectators) {
		spectator->onRemoveCreature(creature, isLogout);
	}

  if (creature->getMaster() && !creature->getMaster()->isRemoved()) {
    creature->setMaster(nullptr);
  }

	creature->getParent()->postRemoveNotification(creature, nullptr, 0);

	creature->removeList();
	creature->setRemoved();
	ReleaseCreature(creature);

	removeCreatureCheck(creature);

	for (Creature* summon : creature->summons) {
		summon->setSkillLoss(false);
		removeCreature(summon);
	}

	if (creature->getPlayer() && isLogout) {
		auto it = teamFinderMap.find(creature->getPlayer()->getGUID());
		if (it != teamFinderMap.end()) {
			teamFinderMap.erase(it);
		}
	}

	return true;
}

void Game::executeDeath(uint32_t creatureId)
{
	Creature* creature = getCreatureByID(creatureId);
	if (creature && !creature->isRemoved()) {
		creature->onDeath();
	}
}

void Game::playerTeleport(uint32_t playerId, const Position& newPosition) {
  Player* player = getPlayerByID(playerId);
  if (!player || !player->hasCustomFlag(PlayerCustomFlag_CanMapClickTeleport)) {
    return;
  }

  ReturnValue returnValue = g_game().internalTeleport(player, newPosition, false);
  if (returnValue != RETURNVALUE_NOERROR) {
    player->sendCancelMessage(returnValue);
  }
}

void Game::playerInspectItem(Player* player, const Position& pos) {
	Thing* thing = internalGetThing(player, pos, 0, 0, STACKPOS_TOPDOWN_ITEM);
	if (!thing) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Item* item = thing->getItem();
	if (!item) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	player->sendItemInspection(item->getID(), static_cast<uint8_t>(item->getItemCount()), item, false);
}

void Game::playerInspectItem(Player* player, uint16_t itemId, uint8_t itemCount, bool cyclopedia) {
	player->sendItemInspection(itemId, itemCount, nullptr, cyclopedia);
}

FILELOADER_ERRORS Game::loadAppearanceProtobuf(const std::string& file)
{
	using namespace Canary::protobuf::appearances;

	std::fstream fileStream(file, std::ios::in | std::ios::binary);
	if (!fileStream.is_open()) {
		SPDLOG_ERROR("[Game::loadAppearanceProtobuf] - Failed to load {}, file cannot be oppened", file);
		fileStream.close();
		return ERROR_NOT_OPEN;
	}

	// Verify that the version of the library that we linked against is
	// compatible with the version of the headers we compiled against.
	GOOGLE_PROTOBUF_VERIFY_VERSION;
	appearances = Appearances();
	if (!appearances.ParseFromIstream(&fileStream)) {
		SPDLOG_ERROR("[Game::loadAppearanceProtobuf] - Failed to parse binary file {}, file is invalid", file);
		fileStream.close();
		return ERROR_NOT_OPEN;
	}

	// Parsing all items into ItemType
	Item::items.loadFromProtobuf();

	// Only iterate other objects if necessary
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS)) {
		// Registering distance effects
		for (uint32_t it = 0; it < appearances.effect_size(); it++) {
			registeredMagicEffects.push_back(static_cast<uint8_t>(appearances.effect(it).id()));
		}

		// Registering missile effects
		for (uint32_t it = 0; it < appearances.missile_size(); it++) {
			registeredDistanceEffects.push_back(static_cast<uint8_t>(appearances.missile(it).id()));
		}

		// Registering outfits
		for (uint32_t it = 0; it < appearances.outfit_size(); it++) {
			registeredLookTypes.push_back(static_cast<uint16_t>(appearances.outfit(it).id()));
		}
	}

	fileStream.close();

	// Disposing allocated objects.
	google::protobuf::ShutdownProtobufLibrary();

	return ERROR_NONE;
}

void Game::playerMoveThing(uint32_t playerId, const Position& fromPos,
                           uint16_t itemId, uint8_t fromStackPos, const Position& toPos, uint8_t count)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	uint8_t fromIndex = 0;
	if (fromPos.x == 0xFFFF) {
		if (fromPos.y & 0x40) {
			fromIndex = fromPos.z;
		} else {
			fromIndex = static_cast<uint8_t>(fromPos.y);
		}
	} else {
		fromIndex = fromStackPos;
	}

	Thing* thing = internalGetThing(player, fromPos, fromIndex, 0, STACKPOS_MOVE);
	if (!thing) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	if (Creature* movingCreature = thing->getCreature()) {
		Tile* tile = map.getTile(toPos);
		if (!tile) {
			player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return;
		}

		if (Position::areInRange<1, 1, 0>(movingCreature->getPosition(),
                                          player->getPosition())) {
			SchedulerTask* task = createSchedulerTask(
                                  g_configManager().getNumber(PUSH_DELAY),
                                  std::bind(&Game::playerMoveCreatureByID, this,
                                  player->getID(), movingCreature->getID(),
                                  movingCreature->getPosition(), tile->getPosition()));
			player->setNextActionPushTask(task);
		} else {
			playerMoveCreature(player, movingCreature, movingCreature->getPosition(), tile);
		}
	} else if (thing->getItem()) {
		Cylinder* toCylinder = internalGetCylinder(player, toPos);
		if (!toCylinder) {
			player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return;
		}

		playerMoveItem(player, fromPos, itemId, fromStackPos, toPos, count, thing->getItem(), toCylinder);
	}
}

void Game::playerMoveCreatureByID(uint32_t playerId, uint32_t movingCreatureId, const Position& movingCreatureOrigPos, const Position& toPos)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Creature* movingCreature = getCreatureByID(movingCreatureId);
	if (!movingCreature) {
		return;
	}

	Tile* toTile = map.getTile(toPos);
	if (!toTile) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	playerMoveCreature(player, movingCreature, movingCreatureOrigPos, toTile);
}

void Game::playerMoveCreature(Player* player, Creature* movingCreature, const Position& movingCreatureOrigPos, Tile* toTile)
{
	if (!player->canDoAction()) {
		uint32_t delay = 600;
		SchedulerTask* task = createSchedulerTask(delay, std::bind(&Game::playerMoveCreatureByID,
			this, player->getID(), movingCreature->getID(), movingCreatureOrigPos, toTile->getPosition()));

		player->setNextActionPushTask(task);
		return;
	}

	player->setNextActionTask(nullptr);

	if (!Position::areInRange<1, 1, 0>(movingCreatureOrigPos, player->getPosition())) {
		//need to walk to the creature first before moving it
		std::forward_list<Direction> listDir;
		if (player->getPathTo(movingCreatureOrigPos, listDir, 0, 1, true, true)) {
			g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk,
											this, player->getID(), listDir)));

			SchedulerTask* task = createSchedulerTask(600, std::bind(&Game::playerMoveCreatureByID, this,
				player->getID(), movingCreature->getID(), movingCreatureOrigPos, toTile->getPosition()));

			player->pushEvent(true);
			player->setNextActionPushTask(task);
		} else {
			player->sendCancelMessage(RETURNVALUE_THEREISNOWAY);
		}
		return;
	}

	player->pushEvent(false);
	const Monster* monster = movingCreature->getMonster();
	bool isFamiliar = false;
	if (monster) {
		isFamiliar = monster->isFamiliar();
	}

	if (!isFamiliar && ((!movingCreature->isPushable() && !player->hasFlag(PlayerFlag_CanPushAllCreatures)) ||
				(movingCreature->isInGhostMode() && !player->isAccessPlayer()))) {
		player->sendCancelMessage(RETURNVALUE_NOTMOVEABLE);
		return;
	}

	//check throw distance
	const Position& movingCreaturePos = movingCreature->getPosition();
	const Position& toPos = toTile->getPosition();
	if ((Position::getDistanceX(movingCreaturePos, toPos) > movingCreature->getThrowRange()) || (Position::getDistanceY(movingCreaturePos, toPos) > movingCreature->getThrowRange()) || (Position::getDistanceZ(movingCreaturePos, toPos) * 4 > movingCreature->getThrowRange())) {
		player->sendCancelMessage(RETURNVALUE_DESTINATIONOUTOFREACH);
		return;
	}

	if (player != movingCreature) {
		if (toTile->hasFlag(TILESTATE_BLOCKPATH)) {
			player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
			return;
		} else if ((movingCreature->getZone() == ZONE_PROTECTION && !toTile->hasFlag(TILESTATE_PROTECTIONZONE)) || (movingCreature->getZone() == ZONE_NOPVP && !toTile->hasFlag(TILESTATE_NOPVPZONE))) {
			player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return;
		} else {
			if (CreatureVector* tileCreatures = toTile->getCreatures()) {
				for (Creature* tileCreature : *tileCreatures) {
					if (!tileCreature->isInGhostMode()) {
						player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
						return;
					}
				}
			}

			Npc* movingNpc = movingCreature->getNpc();
			if (movingNpc && movingNpc->canSee(toPos)) {
				player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
				return;
			}
		}

		movingCreature->setLastPosition(movingCreature->getPosition());
	}

	if (!g_events().eventPlayerOnMoveCreature(player, movingCreature, movingCreaturePos, toPos)) {
		return;
	}

	ReturnValue ret = internalMoveCreature(*movingCreature, *toTile);
	if (ret != RETURNVALUE_NOERROR) {
		player->sendCancelMessage(ret);
	}
	player->setLastPosition(player->getPosition());
}

ReturnValue Game::internalMoveCreature(Creature* creature, Direction direction, uint32_t flags /*= 0*/)
{
	creature->setLastPosition(creature->getPosition());
	const Position& currentPos = creature->getPosition();
	Position destPos = getNextPosition(direction, currentPos);
	Player* player = creature->getPlayer();

	bool diagonalMovement = (direction & DIRECTION_DIAGONAL_MASK) != 0;
	if (player && !diagonalMovement) {
		//try go up
		if (currentPos.z != 8 && creature->getTile()->hasHeight(3)) {
			Tile* tmpTile = map.getTile(currentPos.x, currentPos.y, currentPos.getZ() - 1);
			if (tmpTile == nullptr || (tmpTile->getGround() == nullptr && !tmpTile->hasFlag(TILESTATE_BLOCKSOLID))) {
				tmpTile = map.getTile(destPos.x, destPos.y, destPos.getZ() - 1);
				if (tmpTile && tmpTile->getGround() && !tmpTile->hasFlag(TILESTATE_BLOCKSOLID)) {
					flags |= FLAG_IGNOREBLOCKITEM | FLAG_IGNOREBLOCKCREATURE;

					if (!tmpTile->hasFlag(TILESTATE_FLOORCHANGE)) {
						player->setDirection(direction);
						destPos.z--;
					}
				}
			}
		}

		//try go down
		if (currentPos.z != 7 && currentPos.z == destPos.z) {
			Tile* tmpTile = map.getTile(destPos.x, destPos.y, destPos.z);
			if (tmpTile == nullptr || (tmpTile->getGround() == nullptr && !tmpTile->hasFlag(TILESTATE_BLOCKSOLID))) {
				tmpTile = map.getTile(destPos.x, destPos.y, destPos.z + 1);
				if (tmpTile && tmpTile->hasHeight(3)) {
					flags |= FLAG_IGNOREBLOCKITEM | FLAG_IGNOREBLOCKCREATURE;
					player->setDirection(direction);
					destPos.z++;
				}
			}
		}
	}

	Tile* toTile = map.getTile(destPos);
	if (!toTile) {
		return RETURNVALUE_NOTPOSSIBLE;
	}
	return internalMoveCreature(*creature, *toTile, flags);
}

ReturnValue Game::internalMoveCreature(Creature& creature, Tile& toTile, uint32_t flags /*= 0*/)
{
	if (creature.hasCondition(CONDITION_ROOTED)) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	//check if we can move the creature to the destination
	ReturnValue ret = toTile.queryAdd(0, creature, 1, flags);
	if (ret != RETURNVALUE_NOERROR) {
		return ret;
	}

	map.moveCreature(creature, toTile);
	if (creature.getParent() != &toTile) {
		return RETURNVALUE_NOERROR;
	}

	int32_t index = 0;
	Item* toItem = nullptr;
	Tile* subCylinder = nullptr;
	Tile* toCylinder = &toTile;
	Tile* fromCylinder = nullptr;
	uint32_t n = 0;

	while ((subCylinder = toCylinder->queryDestination(index, creature, &toItem, flags)) != toCylinder) {
		map.moveCreature(creature, *subCylinder);

		if (creature.getParent() != subCylinder) {
			//could happen if a script move the creature
			fromCylinder = nullptr;
			break;
		}

		fromCylinder = toCylinder;
		toCylinder = subCylinder;
		flags = 0;

		//to prevent infinite loop
		if (++n >= MAP_MAX_LAYERS) {
			break;
		}
	}

	if (fromCylinder) {
		const Position& fromPosition = fromCylinder->getPosition();
		const Position& toPosition = toCylinder->getPosition();
		if (fromPosition.z != toPosition.z && (fromPosition.x != toPosition.x || fromPosition.y != toPosition.y)) {
			Direction dir = getDirectionTo(fromPosition, toPosition);
			if ((dir & DIRECTION_DIAGONAL_MASK) == 0) {
				internalCreatureTurn(&creature, dir);
			}
		}
	}

	return RETURNVALUE_NOERROR;
}

void Game::playerMoveItemByPlayerID(uint32_t playerId, const Position& fromPos, uint16_t itemId, uint8_t fromStackPos, const Position& toPos, uint8_t count)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}
	playerMoveItem(player, fromPos, itemId, fromStackPos, toPos, count, nullptr, nullptr);
}

void Game::playerMoveItem(Player* player, const Position& fromPos,
                           uint16_t itemId, uint8_t fromStackPos, const Position& toPos, uint8_t count, Item* item, Cylinder* toCylinder)
{
	if (!player->canDoAction()) {
		uint32_t delay = player->getNextActionTime();
		SchedulerTask* task = createSchedulerTask(delay, std::bind(&Game::playerMoveItemByPlayerID, this,
                              player->getID(), fromPos, itemId, fromStackPos, toPos, count));
		player->setNextActionTask(task);
		return;
	}

	player->setNextActionTask(nullptr);

	if (item == nullptr) {
		uint8_t fromIndex = 0;
		if (fromPos.x == 0xFFFF) {
			if (fromPos.y & 0x40) {
				fromIndex = fromPos.z;
			} else {
				fromIndex = static_cast<uint8_t>(fromPos.y);
			}
		} else {
			fromIndex = fromStackPos;
		}

		Thing* thing = internalGetThing(player, fromPos, fromIndex, 0, STACKPOS_MOVE);
		if (!thing || !thing->getItem()) {
			player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return;
		}

		item = thing->getItem();
	}

	if (item->getID() != itemId) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Cylinder* fromCylinder = internalGetCylinder(player, fromPos);
	if (fromCylinder == nullptr) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	if (toCylinder == nullptr) {
		toCylinder = internalGetCylinder(player, toPos);
		if (toCylinder == nullptr) {
			player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return;
		}
	}

	if (!item->isPushable() || item->hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
		player->sendCancelMessage(RETURNVALUE_NOTMOVEABLE);
		return;
	}

	const Position& playerPos = player->getPosition();
	const Position& mapFromPos = fromCylinder->getTile()->getPosition();
	if (playerPos.z != mapFromPos.z) {
		player->sendCancelMessage(playerPos.z > mapFromPos.z ? RETURNVALUE_FIRSTGOUPSTAIRS : RETURNVALUE_FIRSTGODOWNSTAIRS);
		return;
	}

	if (!Position::areInRange<1, 1>(playerPos, mapFromPos)) {
		//need to walk to the item first before using it
		std::forward_list<Direction> listDir;
		if (player->getPathTo(item->getPosition(), listDir, 0, 1, true, true)) {
			g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk,
											this, player->getID(), listDir)));

			SchedulerTask* task = createSchedulerTask(400,
                                  std::bind(&Game::playerMoveItemByPlayerID, this,
                                  player->getID(), fromPos, itemId,
                                  fromStackPos, toPos, count));
			player->setNextWalkActionTask(task);
		} else {
			player->sendCancelMessage(RETURNVALUE_THEREISNOWAY);
		}
		return;
	}

	const Tile* toCylinderTile = toCylinder->getTile();
	const Position& mapToPos = toCylinderTile->getPosition();

	//hangable item specific code
	if (item->isHangable() && toCylinderTile->hasFlag(TILESTATE_SUPPORTS_HANGABLE)) {
		//destination supports hangable objects so need to move there first
		bool vertical = toCylinderTile->hasProperty(CONST_PROP_ISVERTICAL);
		if (vertical) {
			if (playerPos.x + 1 == mapToPos.x) {
				player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
				return;
			}
		} else { // horizontal
			if (playerPos.y + 1 == mapToPos.y) {
				player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
				return;
			}
		}

		if (!Position::areInRange<1, 1, 0>(playerPos, mapToPos)) {
			Position walkPos = mapToPos;
			if (vertical) {
				walkPos.x++;
			} else {
				walkPos.y++;
			}

			Position itemPos = fromPos;
			uint8_t itemStackPos = fromStackPos;

			if (fromPos.x != 0xFFFF && Position::areInRange<1, 1>(mapFromPos, playerPos)
					&& !Position::areInRange<1, 1, 0>(mapFromPos, walkPos)) {
				//need to pickup the item first
				Item* moveItem = nullptr;

				ReturnValue ret = internalMoveItem(fromCylinder, player, INDEX_WHEREEVER, item, count, &moveItem);
				if (ret != RETURNVALUE_NOERROR) {
					player->sendCancelMessage(ret);
					return;
				}

				//changing the position since its now in the inventory of the player
				internalGetPosition(moveItem, itemPos, itemStackPos);
			}

			std::forward_list<Direction> listDir;
			if (player->getPathTo(walkPos, listDir, 0, 0, true, true)) {
				g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk,
												this, player->getID(), listDir)));

				SchedulerTask* task = createSchedulerTask(400,
                                      std::bind(&Game::playerMoveItemByPlayerID,
                                      this, player->getID(), itemPos, itemId,
                                      itemStackPos, toPos, count));
				player->setNextWalkActionTask(task);
			} else {
				player->sendCancelMessage(RETURNVALUE_THEREISNOWAY);
			}
			return;
		}
	}

	if ((Position::getDistanceX(playerPos, mapToPos) > item->getThrowRange()) ||
			(Position::getDistanceY(playerPos, mapToPos) > item->getThrowRange()) ||
			(Position::getDistanceZ(mapFromPos, mapToPos) * 4 > item->getThrowRange())) {
		player->sendCancelMessage(RETURNVALUE_DESTINATIONOUTOFREACH);
		return;
	}

	if (toCylinder->getContainer() != NULL &&
		toCylinder->getItem()->getID() == ITEM_LOCKER &&
		toPos.getZ() == ITEM_SUPPLY_STASH_INDEX) {
		player->stowItem(item, count, false);
			return;
	}

	if (!canThrowObjectTo(mapFromPos, mapToPos)) {
		player->sendCancelMessage(RETURNVALUE_CANNOTTHROW);
		return;
	}

	if (!g_events().eventPlayerOnMoveItem(player, item, count, fromPos, toPos, fromCylinder, toCylinder)) {
		return;
	}

	uint8_t toIndex = 0;
	if (toPos.x == 0xFFFF) {
		if (toPos.y & 0x40) {
			toIndex = toPos.z;
		} else {
			toIndex = static_cast<uint8_t>(toPos.y);
		}
	}

	if (item->isWrapable()){
		HouseTile* toHouseTile = dynamic_cast<HouseTile*>(map.getTile(mapToPos));
		HouseTile* fromHouseTile = dynamic_cast<HouseTile*>(map.getTile(mapFromPos));
		if (fromHouseTile && (!toHouseTile || toHouseTile->getHouse()->getId() != fromHouseTile->getHouse()->getId())) {
			player->sendCancelMessage("You can't move this item outside a house.");
				return;
		}
	}
	ReturnValue ret = internalMoveItem(fromCylinder, toCylinder, toIndex, item, count, nullptr, 0, player);
	if (ret != RETURNVALUE_NOERROR) {
		player->sendCancelMessage(ret);
	}	else if (toCylinder->getContainer()
		&& fromCylinder->getContainer()
		&& fromCylinder->getContainer()->countsToLootAnalyzerBalance()
		&& toCylinder->getContainer()->getTopParent() == player) {
		player->sendLootStats(item, count);
	}
	player->cancelPush();

	g_events().eventPlayerOnItemMoved(player, item, count, fromPos, toPos, fromCylinder, toCylinder);
}

ReturnValue Game::internalMoveItem(Cylinder* fromCylinder,
                                  Cylinder* toCylinder, int32_t index,
                                  Item* item, uint32_t count, Item** internalMoveItem,
                                  uint32_t flags /*= 0*/, Creature* actor/*=nullptr*/,
                                  Item* tradeItem/* = nullptr*/)
{
	Tile* fromTile = fromCylinder->getTile();
	if (fromTile) {
		auto it = browseFields.find(fromTile);
		if (it != browseFields.end() && it->second == fromCylinder) {
			fromCylinder = fromTile;
		}
	}

	Item* toItem = nullptr;

	Cylinder* subCylinder;
	int floorN = 0;

	while ((subCylinder = toCylinder->queryDestination(index, *item, &toItem, flags)) != toCylinder) {
		toCylinder = subCylinder;
		flags = 0;

		//to prevent infinite loop
		if (++floorN >= MAP_MAX_LAYERS) {
			break;
		}
	}

	//destination is the same as the source?
	if (item == toItem) {
		return RETURNVALUE_NOERROR; //silently ignore move
	}

	// 'Move up' stackable items fix
	//  Cip's client never sends the count of stackables when using "Move up" menu option
	if (item->isStackable() && count == 255 && fromCylinder->getParent() == toCylinder) {
		count = item->getItemCount();
	}

	//check if we can add this item
	ReturnValue ret = toCylinder->queryAdd(index, *item, count, flags, actor);
	if (ret == RETURNVALUE_NEEDEXCHANGE) {
		//check if we can add it to source cylinder
		ret = fromCylinder->queryAdd(fromCylinder->getThingIndex(item), *toItem, toItem->getItemCount(), 0);
		if (ret == RETURNVALUE_NOERROR) {
			//check how much we can move
			uint32_t maxExchangeQueryCount = 0;
			ReturnValue retExchangeMaxCount = fromCylinder->queryMaxCount(INDEX_WHEREEVER, *toItem, toItem->getItemCount(), maxExchangeQueryCount, 0);

			if (retExchangeMaxCount != RETURNVALUE_NOERROR && maxExchangeQueryCount == 0) {
				return retExchangeMaxCount;
			}

			if (toCylinder->queryRemove(*toItem, toItem->getItemCount(), flags, actor) == RETURNVALUE_NOERROR) {
				int32_t oldToItemIndex = toCylinder->getThingIndex(toItem);
				toCylinder->removeThing(toItem, toItem->getItemCount());
				fromCylinder->addThing(toItem);

				if (oldToItemIndex != -1) {
					toCylinder->postRemoveNotification(toItem, fromCylinder, oldToItemIndex);
				}

				int32_t newToItemIndex = fromCylinder->getThingIndex(toItem);
				if (newToItemIndex != -1) {
					fromCylinder->postAddNotification(toItem, toCylinder, newToItemIndex);
				}

				ret = toCylinder->queryAdd(index, *item, count, flags);
				toItem = nullptr;
			}
		}
	}

	if (ret != RETURNVALUE_NOERROR) {
		return ret;
	}

	//check how much we can move
	uint32_t maxQueryCount = 0;
	ReturnValue retMaxCount = toCylinder->queryMaxCount(index, *item, count, maxQueryCount, flags);
	if (retMaxCount != RETURNVALUE_NOERROR && maxQueryCount == 0) {
		return retMaxCount;
	}

	uint32_t m;
	if (item->isStackable()) {
		m = std::min<uint32_t>(count, maxQueryCount);
	} else {
		m = maxQueryCount;
	}

	Item* moveItem = item;
	//check if we can remove this item
	ret = fromCylinder->queryRemove(*item, m, flags, actor);
	if (ret != RETURNVALUE_NOERROR) {
		return ret;
	}

	if (tradeItem) {
		if (toCylinder->getItem() == tradeItem) {
			return RETURNVALUE_NOTENOUGHROOM;
		}

		Cylinder* tmpCylinder = toCylinder->getParent();
		while (tmpCylinder) {
			if (tmpCylinder->getItem() == tradeItem) {
				return RETURNVALUE_NOTENOUGHROOM;
			}

			tmpCylinder = tmpCylinder->getParent();
		}
	}

	//remove the item
	int32_t itemIndex = fromCylinder->getThingIndex(item);
	Item* updateItem = nullptr;
	fromCylinder->removeThing(item, m);

	//update item(s)
	if (item->isStackable()) {
		uint32_t n;

		if (toItem && item->equals(toItem)) {
			n = std::min<uint32_t>(100 - toItem->getItemCount(), m);
			toCylinder->updateThing(toItem, toItem->getID(), toItem->getItemCount() + n);
			updateItem = toItem;
		} else {
			n = 0;
		}

		int32_t newCount = m - n;
		if (newCount > 0) {
			moveItem = item->clone();
			moveItem->setItemCount(newCount);
		} else {
			moveItem = nullptr;
		}

		if (item->isRemoved()) {
			item->stopDecaying();
			ReleaseItem(item);
		}
	}

	//add item
	if (moveItem /*m - n > 0*/) {
		toCylinder->addThing(index, moveItem);
	}

	if (itemIndex != -1) {
		fromCylinder->postRemoveNotification(item, toCylinder, itemIndex);
	}

	if (moveItem) {
		int32_t moveItemIndex = toCylinder->getThingIndex(moveItem);
		if (moveItemIndex != -1) {
			toCylinder->postAddNotification(moveItem, fromCylinder, moveItemIndex);
		}
		moveItem->startDecaying();
	}

	if (updateItem) {
		int32_t updateItemIndex = toCylinder->getThingIndex(updateItem);
		if (updateItemIndex != -1) {
			toCylinder->postAddNotification(updateItem, fromCylinder, updateItemIndex);
		}
		updateItem->startDecaying();
	}

	if (internalMoveItem) {
		if (moveItem) {
			*internalMoveItem = moveItem;
		} else {
			*internalMoveItem = item;
		}
	}

	Item* quiver = toCylinder->getItem();
	if (quiver && quiver->isQuiver() 
               && quiver->getHoldingPlayer()
               && quiver->getHoldingPlayer()->getThing(CONST_SLOT_RIGHT) == quiver) {
		quiver->getHoldingPlayer()->sendInventoryItem(CONST_SLOT_RIGHT, quiver);
	} else {
		quiver = fromCylinder->getItem();
		if (quiver && quiver->isQuiver()
                   && quiver->getHoldingPlayer()
                   && quiver->getHoldingPlayer()->getThing(CONST_SLOT_RIGHT) == quiver) {
			quiver->getHoldingPlayer()->sendInventoryItem(CONST_SLOT_RIGHT, quiver);
		}
	}

	//we could not move all, inform the player
	if (item->isStackable() && maxQueryCount < count) {
		return retMaxCount;
	}

	// looting analyser from this point forward
	if (fromCylinder && actor && toCylinder) {
		if (!fromCylinder->getContainer() || !actor->getPlayer() || !toCylinder->getContainer()) {
			return ret;
		}

		if (const Player* player = actor->getPlayer()) {
			const ItemType& it = Item::items[fromCylinder->getItem()->getID()];
			if (it.id <= 0) {
				return ret;
			}

			if (it.isCorpse && toCylinder->getContainer()->getTopParent() == player && item->getIsLootTrackeable()) {
				player->sendLootStats(item, static_cast<uint8_t>(item->getItemCount()));
			}
		}
	}

	return ret;
}

ReturnValue Game::internalAddItem(Cylinder* toCylinder, Item* item,
                                  int32_t index /*= INDEX_WHEREEVER*/,
                                  uint32_t flags/* = 0*/, bool test/* = false*/)
{
	uint32_t remainderCount = 0;
	return internalAddItem(toCylinder, item, index, flags, test, remainderCount);
}

ReturnValue Game::internalAddItem(Cylinder* toCylinder, Item* item, int32_t index,
                                  uint32_t flags, bool test, uint32_t& remainderCount)
{
	if (toCylinder == nullptr || item == nullptr) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	Cylinder* destCylinder = toCylinder;
	Item* toItem = nullptr;
	toCylinder = toCylinder->queryDestination(index, *item, &toItem, flags);

	//check if we can add this item
	ReturnValue ret = toCylinder->queryAdd(index, *item, item->getItemCount(), flags);
	if (ret != RETURNVALUE_NOERROR) {
		return ret;
	}

	/*
	Check if we can move add the whole amount, we do this by checking against the original cylinder,
	since the queryDestination can return a cylinder that might only hold a part of the full amount.
	*/
	uint32_t maxQueryCount = 0;
	ret = destCylinder->queryMaxCount(INDEX_WHEREEVER, *item, item->getItemCount(), maxQueryCount, flags);

	if (ret != RETURNVALUE_NOERROR && toCylinder->getItem() && toCylinder->getItem()->getID() != ITEM_REWARD_CONTAINER) {
		return ret;
	}

	if (test) {
		return RETURNVALUE_NOERROR;
	}

	if (item->isStackable() && item->equals(toItem)) {
		uint32_t m = std::min<uint32_t>(item->getItemCount(), maxQueryCount);
		uint32_t n = std::min<uint32_t>(100 - toItem->getItemCount(), m);

		toCylinder->updateThing(toItem, toItem->getID(), toItem->getItemCount() + n);

		int32_t count = m - n;
		if (count > 0) {
			if (item->getItemCount() != count) {
				Item* remainderItem = item->clone();
				remainderItem->setItemCount(count);
				if (internalAddItem(destCylinder, remainderItem, INDEX_WHEREEVER, flags, false) != RETURNVALUE_NOERROR) {
					ReleaseItem(remainderItem);
					remainderCount = count;
				}
			} else {
				toCylinder->addThing(index, item);

				int32_t itemIndex = toCylinder->getThingIndex(item);
				if (itemIndex != -1) {
					toCylinder->postAddNotification(item, nullptr, itemIndex);
				}
			}
		} else {
			//fully merged with toItem, item will be destroyed
			item->onRemoved();
			ReleaseItem(item);

			int32_t itemIndex = toCylinder->getThingIndex(toItem);
			if (itemIndex != -1) {
				toCylinder->postAddNotification(toItem, nullptr, itemIndex);
			}
		}
	} else {
		toCylinder->addThing(index, item);

		int32_t itemIndex = toCylinder->getThingIndex(item);
		if (itemIndex != -1) {
			toCylinder->postAddNotification(item, nullptr, itemIndex);
		}
	}

	Item* quiver = toCylinder->getItem();
	if (quiver && quiver->isQuiver()
               && quiver->getHoldingPlayer()
               && quiver->getHoldingPlayer()->getThing(CONST_SLOT_RIGHT) == quiver) {
		quiver->getHoldingPlayer()->sendInventoryItem(CONST_SLOT_RIGHT, quiver);
	}

	return RETURNVALUE_NOERROR;
}

ReturnValue Game::internalRemoveItem(Item* item, int32_t count /*= -1*/, bool test /*= false*/, uint32_t flags /*= 0*/)
{
	Cylinder* cylinder = item->getParent();
	if (cylinder == nullptr) {
		return RETURNVALUE_NOTPOSSIBLE;
	}
	Tile* fromTile = cylinder->getTile();
	if (fromTile) {
		auto it = browseFields.find(fromTile);
		if (it != browseFields.end() && it->second == cylinder) {
			cylinder = fromTile;
		}
	}
	if (count == -1) {
		count = item->getItemCount();
	}
	//check if we can remove this item
	ReturnValue ret = cylinder->queryRemove(*item, count, flags | FLAG_IGNORENOTMOVEABLE);
	if (ret != RETURNVALUE_NOERROR) {
		return ret;
	}
	if (!item->canRemove()) {
		return RETURNVALUE_NOTPOSSIBLE;
	}
	if (!test) {
		int32_t index = cylinder->getThingIndex(item);
		//remove the item
		cylinder->removeThing(item, count);

		if (item->isRemoved()) {
			item->onRemoved();
			item->stopDecaying();
			ReleaseItem(item);
		}

		cylinder->postRemoveNotification(item, nullptr, index);
	}

	Item* quiver = cylinder->getItem();
	if (quiver && quiver->isQuiver()
               && quiver->getHoldingPlayer()
               && quiver->getHoldingPlayer()->getThing(CONST_SLOT_RIGHT) == quiver) {
		quiver->getHoldingPlayer()->sendInventoryItem(CONST_SLOT_RIGHT, quiver);
	}

	return RETURNVALUE_NOERROR;
}

ReturnValue Game::internalPlayerAddItem(Player* player, Item* item, bool dropOnMap /*= true*/, Slots_t slot /*= CONST_SLOT_WHEREEVER*/)
{
	uint32_t remainderCount = 0;
	ReturnValue ret = internalAddItem(player, item, static_cast<int32_t>(slot), 0, false, remainderCount);
	if (remainderCount != 0) {
		Item* remainderItem = Item::CreateItem(item->getID(), remainderCount);
		ReturnValue remaindRet = internalAddItem(player->getTile(), remainderItem, INDEX_WHEREEVER, FLAG_NOLIMIT);
		if (remaindRet != RETURNVALUE_NOERROR) {
			ReleaseItem(remainderItem);
			player->sendLootStats(item, static_cast<uint8_t>(item->getItemCount()));
		}
	}

	if (ret != RETURNVALUE_NOERROR && dropOnMap) {
		ret = internalAddItem(player->getTile(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
	}

	return ret;
}

Item* Game::findItemOfType(Cylinder* cylinder, uint16_t itemId,
                           bool depthSearch /*= true*/, int32_t subType /*= -1*/) const
{
	if (cylinder == nullptr) {
		return nullptr;
	}

	std::vector<Container*> containers;
	for (size_t i = cylinder->getFirstIndex(), j = cylinder->getLastIndex(); i < j; ++i) {
		Thing* thing = cylinder->getThing(i);
		if (!thing) {
			continue;
		}

		Item* item = thing->getItem();
		if (!item) {
			continue;
		}

		if (item->getID() == itemId && (subType == -1 || subType == item->getSubType())) {
			return item;
		}

		if (depthSearch) {
			Container* container = item->getContainer();
			if (container) {
				containers.push_back(container);
			}
		}
	}

	size_t i = 0;
	while (i < containers.size()) {
		Container* container = containers[i++];
		for (Item* item : container->getItemList()) {
			if (item->getID() == itemId && (subType == -1 || subType == item->getSubType())) {
				return item;
			}

			Container* subContainer = item->getContainer();
			if (subContainer) {
				containers.push_back(subContainer);
			}
		}
	}
	return nullptr;
}

bool Game::removeMoney(Cylinder* cylinder, uint64_t money, uint32_t flags /*= 0*/, bool useBalance /*= false*/)
{
	if (cylinder == nullptr) {
		return false;
	}
	if (money == 0) {
		return true;
	}
	std::vector<Container*> containers;
	std::multimap<uint32_t, Item*> moneyMap;
	uint64_t moneyCount = 0;
	for (size_t i = cylinder->getFirstIndex(), j = cylinder->getLastIndex(); i < j; ++i) {
		Thing* thing = cylinder->getThing(i);
		if (!thing) {
			continue;
		}
		Item* item = thing->getItem();
		if (!item) {
			continue;
		}
		Container* container = item->getContainer();
		if (container) {
			containers.push_back(container);
		} else {
			const uint32_t worth = item->getWorth();
			if (worth != 0) {
				moneyCount += worth;
				moneyMap.emplace(worth, item);
			}
		}
	}
	size_t i = 0;
	while (i < containers.size()) {
		Container* container = containers[i++];
		for (Item* item : container->getItemList()) {
			Container* tmpContainer = item->getContainer();
			if (tmpContainer) {
				containers.push_back(tmpContainer);
			} else {
				const uint32_t worth = item->getWorth();
				if (worth != 0) {
					moneyCount += worth;
					moneyMap.emplace(worth, item);
				}
			}
		}
	}

	Player* player = useBalance ? dynamic_cast<Player*>(cylinder) : nullptr;
	uint64_t balance = 0;
	if (useBalance && player) {
		balance = player->getBankBalance();
	}

	if (moneyCount + balance < money) {
		return false;
	}

	for (const auto& moneyEntry : moneyMap) {
		Item* item = moneyEntry.second;
		if (moneyEntry.first < money) {
			internalRemoveItem(item);
			money -= moneyEntry.first;
		} else if (moneyEntry.first > money) {
			const uint32_t worth = moneyEntry.first / item->getItemCount();
			const uint32_t removeCount = std::ceil(money / static_cast<double>(worth));
			addMoney(cylinder, (worth * removeCount) - money, flags);
			internalRemoveItem(item, removeCount);
			return true;
		} else {
			internalRemoveItem(item);
			return true;
		}
	}

	if (useBalance && player && player->getBankBalance() >= money) {
		player->setBankBalance(player->getBankBalance() - money);
	}

	return true;
}

void Game::addMoney(Cylinder* cylinder, uint64_t money, uint32_t flags /*= 0*/)
{
	if (money == 0) {
		return;
	}

	uint32_t crystalCoins = money / 10000;
	money -= crystalCoins * 10000;
	while (crystalCoins > 0) {
		const uint16_t count = std::min<uint32_t>(100, crystalCoins);

		Item* remaindItem = Item::CreateItem(ITEM_CRYSTAL_COIN, count);

		ReturnValue ret = internalAddItem(cylinder, remaindItem, INDEX_WHEREEVER, flags);
		if (ret != RETURNVALUE_NOERROR) {
			internalAddItem(cylinder->getTile(), remaindItem, INDEX_WHEREEVER, FLAG_NOLIMIT);
		}

		crystalCoins -= count;
	}

	uint16_t platinumCoins = money / 100;
	if (platinumCoins != 0) {
		Item* remaindItem = Item::CreateItem(ITEM_PLATINUM_COIN, platinumCoins);

		ReturnValue ret = internalAddItem(cylinder, remaindItem, INDEX_WHEREEVER, flags);
		if (ret != RETURNVALUE_NOERROR) {
			internalAddItem(cylinder->getTile(), remaindItem, INDEX_WHEREEVER, FLAG_NOLIMIT);
		}

		money -= platinumCoins * 100;
	}

	if (money != 0) {
		Item* remaindItem = Item::CreateItem(ITEM_GOLD_COIN, money);

		ReturnValue ret = internalAddItem(cylinder, remaindItem, INDEX_WHEREEVER, flags);
		if (ret != RETURNVALUE_NOERROR) {
			internalAddItem(cylinder->getTile(), remaindItem, INDEX_WHEREEVER, FLAG_NOLIMIT);
		}
	}
}

Item* Game::transformItem(Item* item, uint16_t newId, int32_t newCount /*= -1*/)
{
	if (item->getID() == newId && (newCount == -1 || (newCount == item->getSubType() && newCount != 0))) { //chargeless item placed on map = infinite
		return item;
	}

	Cylinder* cylinder = item->getParent();
	if (cylinder == nullptr) {
		return nullptr;
	}

	Tile* fromTile = cylinder->getTile();
	if (fromTile) {
		auto it = browseFields.find(fromTile);
		if (it != browseFields.end() && it->second == cylinder) {
			cylinder = fromTile;
		}
	}

	int32_t itemIndex = cylinder->getThingIndex(item);
	if (itemIndex == -1) {
		return item;
	}

	if (!item->canTransform()) {
		return item;
	}

	const ItemType& newType = Item::items[newId];
	if (newType.id == 0) {
		return item;
	}

	const ItemType& curType = Item::items[item->getID()];
	if (item->isAlwaysOnTop() != (newType.alwaysOnTopOrder != 0)) {
		//This only occurs when you transform items on tiles from a downItem to a topItem (or vice versa)
		//Remove the old, and add the new
		cylinder->removeThing(item, item->getItemCount());
		cylinder->postRemoveNotification(item, cylinder, itemIndex);

		item->setID(newId);
		if (newCount != -1) {
			item->setSubType(newCount);
		}
		cylinder->addThing(item);

		Cylinder* newParent = item->getParent();
		if (newParent == nullptr) {
			item->stopDecaying();
			ReleaseItem(item);
			return nullptr;
		}

		newParent->postAddNotification(item, cylinder, newParent->getThingIndex(item));
		item->startDecaying();

		return item;
	}

	if (curType.type == newType.type) {
		//Both items has the same type so we can safely change id/subtype
		if (newCount == 0 && (item->isStackable() || item->hasAttribute(ITEM_ATTRIBUTE_CHARGES))) {
			if (item->isStackable()) {
				internalRemoveItem(item);
				return nullptr;
			} else {
				int32_t newItemId = newId;
				if (curType.id == newType.id) {
					newItemId = curType.decayTo;
				}

				if (newItemId < 0) {
					internalRemoveItem(item);
					return nullptr;
				} else if (newItemId != newId) {
					//Replacing the the old item with the new while maintaining the old position
					Item* newItem = Item::CreateItem(newItemId, 1);
					if (newItem == nullptr) {
						return nullptr;
					}

					cylinder->replaceThing(itemIndex, newItem);
					cylinder->postAddNotification(newItem, cylinder, itemIndex);

					item->setParent(nullptr);
					cylinder->postRemoveNotification(item, cylinder, itemIndex);
					item->stopDecaying();
					ReleaseItem(item);
					newItem->startDecaying();

					return newItem;
				} else {
					return transformItem(item, newItemId);
				}
			}
		} else {
			cylinder->postRemoveNotification(item, cylinder, itemIndex);
			uint16_t itemId = item->getID();
			int32_t count = item->getSubType();

			if (curType.id != newType.id) {
				if (newType.group != curType.group) {
					item->setDefaultSubtype();
				}

				itemId = newId;
			}

			if (newCount != -1 && newType.hasSubType()) {
				count = newCount;
			}

			cylinder->updateThing(item, itemId, count);
			cylinder->postAddNotification(item, cylinder, itemIndex);

			Item* quiver = cylinder->getItem();
			if (quiver && quiver->isQuiver()
                       && quiver->getHoldingPlayer()
                       && quiver->getHoldingPlayer()->getThing(CONST_SLOT_RIGHT) == quiver) {
				quiver->getHoldingPlayer()->sendInventoryItem(CONST_SLOT_RIGHT, quiver);
			}
			item->startDecaying();

			return item;
		}
	}

	Item* quiver = cylinder->getItem();
	if (quiver && quiver->isQuiver()
               && quiver->getHoldingPlayer()
               && quiver->getHoldingPlayer()->getThing(CONST_SLOT_RIGHT) == quiver) {
		quiver->getHoldingPlayer()->sendInventoryItem(CONST_SLOT_RIGHT, quiver);
	}

	//Replacing the the old item with the new while maintaining the old position
	Item* newItem;
	if (newCount == -1) {
		newItem = Item::CreateItem(newId);
	} else {
		newItem = Item::CreateItem(newId, newCount);
	}

	if (newItem == nullptr) {
		return nullptr;
	}

	cylinder->replaceThing(itemIndex, newItem);
	cylinder->postAddNotification(newItem, cylinder, itemIndex);

	item->setParent(nullptr);
	cylinder->postRemoveNotification(item, cylinder, itemIndex);
	item->stopDecaying();
	ReleaseItem(item);
	newItem->startDecaying();

	return newItem;
}

ReturnValue Game::internalTeleport(Thing* thing, const Position& newPos, bool pushMove/* = true*/, uint32_t flags /*= 0*/)
{
	if (newPos == thing->getPosition()) {
		return RETURNVALUE_NOERROR;
	} else if (thing->isRemoved()) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	Tile* toTile = map.getTile(newPos);
	if (!toTile) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (Creature* creature = thing->getCreature()) {
		ReturnValue ret = toTile->queryAdd(0, *creature, 1, FLAG_NOLIMIT);
		if (ret != RETURNVALUE_NOERROR) {
			return ret;
		}

		map.moveCreature(*creature, *toTile, !pushMove);
		return RETURNVALUE_NOERROR;
	} else if (Item* item = thing->getItem()) {
		return internalMoveItem(item->getParent(), toTile, INDEX_WHEREEVER, item, item->getItemCount(), nullptr, flags);
	}
	return RETURNVALUE_NOTPOSSIBLE;
}

void Game::internalQuickLootCorpse(Player* player, Container* corpse)
{
	if (!player || !corpse) {
		return;
	}

	std::vector<Item*> itemList;
	bool ignoreListItems = (player->quickLootFilter == QUICKLOOTFILTER_SKIPPEDLOOT);

	bool missedAnyGold = false;
	bool missedAnyItem = false;

	for (ContainerIterator it = corpse->iterator(); it.hasNext(); it.advance()) {
		Item* item = *it;
		bool listed = player->isQuickLootListedItem(item);
		if ((listed && ignoreListItems) || (!listed && !ignoreListItems)) {
			if (item->getWorth() != 0) {
				missedAnyGold = true;
			} else {
				missedAnyItem = true;
			}
			continue;
		}

		itemList.push_back(item);
	}

	bool shouldNotifyCapacity = false;
	ObjectCategory_t shouldNotifyNotEnoughRoom = OBJECTCATEGORY_NONE;

	uint32_t totalLootedGold = 0;
	uint32_t totalLootedItems = 0;
	for (Item* item : itemList) {
		uint32_t worth = item->getWorth();
		uint16_t baseCount = item->getItemCount();
		ObjectCategory_t category = getObjectCategory(item);

		ReturnValue ret = internalQuickLootItem(player, item, category);
		if (ret == RETURNVALUE_NOTENOUGHCAPACITY) {
			shouldNotifyCapacity = true;
		} else if (ret == RETURNVALUE_CONTAINERNOTENOUGHROOM) {
			shouldNotifyNotEnoughRoom = category;
		}

		bool success = ret == RETURNVALUE_NOERROR;
		if (worth != 0) {
			missedAnyGold = missedAnyGold || !success;
			if (success) {
				player->sendLootStats(item, baseCount);
				totalLootedGold += worth;
			} else {
				// item is not completely moved
				totalLootedGold += worth - item->getWorth();
			}
		} else {
			missedAnyItem = missedAnyItem || !success;
			if (success || item->getItemCount() != baseCount) {
				totalLootedItems++;
				player->sendLootStats(item, item->getItemCount());
			}
		}
	}

	std::stringstream ss;
	if (totalLootedGold != 0 || missedAnyGold || totalLootedItems != 0 || missedAnyItem) {
		bool lootedAllGold = totalLootedGold != 0 && !missedAnyGold;
		bool lootedAllItems = totalLootedItems != 0 && !missedAnyItem;
		if (lootedAllGold) {
			if (totalLootedItems != 0 || missedAnyItem) {
				ss << "You looted the complete " << totalLootedGold << " gold";

				if (lootedAllItems) {
					ss << " and all dropped items";
				} else if (totalLootedItems != 0) {
					ss << ", but you only looted some of the items";
				} else if (missedAnyItem) {
					ss << " but none of the dropped items";
				}
			} else {
				ss << "You looted " << totalLootedGold << " gold";
			}
		} else if (lootedAllItems) {
			if (totalLootedItems == 1) {
				ss << "You looted 1 item";
			} else if (totalLootedGold != 0 || missedAnyGold) {
				ss << "You looted all of the dropped items";
			} else {
				ss << "You looted all items";
			}

			if (totalLootedGold != 0) {
				ss << ", but you only looted " << totalLootedGold << " of the dropped gold";
			} else if (missedAnyGold) {
				ss << " but none of the dropped gold";
			}
		} else if (totalLootedGold != 0) {
			ss << "You only looted " << totalLootedGold << " of the dropped gold";
			if (totalLootedItems != 0) {
				ss << " and some of the dropped items";
			} else if (missedAnyItem) {
				ss << " but none of the dropped items";
			}
		} else if (totalLootedItems != 0) {
			ss << "You looted some of the dropped items";
			if (missedAnyGold) {
				ss << " but none of the dropped gold";
			}
		} else if (missedAnyGold) {
			ss << "You looted none of the dropped gold";
			if (missedAnyItem) {
				ss << " and none of the items";
			}
		} else if (missedAnyItem) {
			ss << "You looted none of the dropped items";
		}
	} else {
		ss << "No loot";
	}

	ss << ".";
	player->sendTextMessage(MESSAGE_LOOT, ss.str());

	if (shouldNotifyCapacity) {
		ss.str(std::string());
		ss << "Attention! The loot you are trying to pick up is too heavy for you to carry.";
	} else if (shouldNotifyNotEnoughRoom != OBJECTCATEGORY_NONE) {
		ss.str(std::string());
		ss << "Attention! The container assigned to category " << getObjectCategoryName(shouldNotifyNotEnoughRoom) << " is full.";
	} else {
		return;
	}

	if (player->lastQuickLootNotification + 15000 < OTSYS_TIME()) {
		player->sendTextMessage(MESSAGE_GAME_HIGHLIGHT, ss.str());
	} else {
		player->sendTextMessage(MESSAGE_EVENT_ADVANCE, ss.str());
	}

	player->lastQuickLootNotification = OTSYS_TIME();
}

ReturnValue Game::internalQuickLootItem(Player* player, Item* item, ObjectCategory_t category /* = OBJECTCATEGORY_DEFAULT*/)
{
  if (!player || !item) {
    return RETURNVALUE_NOTPOSSIBLE;
  }

	bool fallbackConsumed = false;
	uint16_t baseId = 0;

	Container* lootContainer = player->getLootContainer(category);
	if (!lootContainer) {
    	if (player->quickLootFallbackToMainContainer) {
    		Item* fallbackItem = player->getInventoryItem(CONST_SLOT_BACKPACK);

      	if (fallbackItem) {
        	Container* mainBackpack = fallbackItem->getContainer();
        	if (mainBackpack && !fallbackConsumed) {
          		player->setLootContainer(OBJECTCATEGORY_DEFAULT, mainBackpack);
          		player->sendInventoryItem(CONST_SLOT_BACKPACK, player->getInventoryItem(CONST_SLOT_BACKPACK));
        	}
      	}

			lootContainer = fallbackItem ? fallbackItem->getContainer() : nullptr;
			fallbackConsumed = true;
		} else {
			return RETURNVALUE_NOTPOSSIBLE;
		}
	} else {
		baseId = lootContainer->getID();
	}

	if (!lootContainer) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	Container* lastSubContainer = nullptr;
	uint32_t remainderCount = item->getItemCount();
	ContainerIterator it = lootContainer->iterator();

	ReturnValue ret;
	do {
		Item* moveItem = nullptr;
		if (item->getParent()) { // Stash retrive dont have parent cylinder.
		ret = internalMoveItem(item->getParent(), lootContainer, INDEX_WHEREEVER, item, item->getItemCount(), &moveItem, 0, player);
		} else {
		ret = internalAddItem(lootContainer, item, INDEX_WHEREEVER);
		}
		if (moveItem) {
			remainderCount -= moveItem->getItemCount();
		}

		if (ret != RETURNVALUE_CONTAINERNOTENOUGHROOM) {
			break;
		}

		// search for a sub container
		bool obtainedNewContainer = false;
		while (it.hasNext()) {
			Item* cur = *it;
			Container* subContainer = cur ? cur->getContainer() : nullptr;
			it.advance();

			if (subContainer) {
				lastSubContainer = subContainer;
				lootContainer = subContainer;
				obtainedNewContainer = true;
				break;
			}
		}

		// a hack to fix last empty sub-container
		if (!obtainedNewContainer && lastSubContainer && lastSubContainer->size() > 0) {
			Item* cur = lastSubContainer->getItemByIndex(lastSubContainer->size() - 1);
			Container* subContainer = cur ? cur->getContainer() : nullptr;

			if (subContainer) {
				lootContainer = subContainer;
				obtainedNewContainer = true;
			}

			lastSubContainer = nullptr;
		}

		// consumed all sub-container & there is simply no more containers to iterate over.
		// check if fallback should be used and if not, then break
		bool quickFallback = (player->quickLootFallbackToMainContainer);
		bool noFallback = fallbackConsumed || !quickFallback;
		if (noFallback && (!lootContainer || !obtainedNewContainer)) {
			break;
		} else if (!lootContainer || !obtainedNewContainer) {
			Item* fallbackItem = player->getInventoryItem(CONST_SLOT_BACKPACK);
			if (!fallbackItem || !fallbackItem->getContainer()) {
				break;
			}

			lootContainer = fallbackItem->getContainer();
			it = lootContainer->iterator();

			fallbackConsumed = true;
		}
	} while (remainderCount != 0);
	return ret;
}

ObjectCategory_t Game::getObjectCategory(const Item* item)
{
	ObjectCategory_t category = OBJECTCATEGORY_DEFAULT;
  if (!item) {
    return OBJECTCATEGORY_NONE;
  }

	const ItemType& it = Item::items[item->getID()];
	if (item->getWorth() != 0) {
		category = OBJECTCATEGORY_GOLD;
	} else if (it.weaponType != WEAPON_NONE) {
		switch (it.weaponType) {
			case WEAPON_SWORD:
				category = OBJECTCATEGORY_SWORDS;
				break;
			case WEAPON_CLUB:
				category = OBJECTCATEGORY_CLUBS;
				break;
			case WEAPON_AXE:
				category = OBJECTCATEGORY_AXES;
				break;
			case WEAPON_SHIELD:
				category = OBJECTCATEGORY_SHIELDS;
				break;
			case WEAPON_DISTANCE:
				category = OBJECTCATEGORY_DISTANCEWEAPONS;
				break;
			case WEAPON_WAND:
				category = OBJECTCATEGORY_WANDS;
				break;
			case WEAPON_AMMO:
				category = OBJECTCATEGORY_AMMO;
				break;
			default:
				break;
		}
	} else if (it.slotPosition != SLOTP_HAND) { // if it's a weapon/shield should have been parsed earlier
		if ((it.slotPosition & SLOTP_HEAD) != 0) {
			category = OBJECTCATEGORY_HELMETS;
		} else if ((it.slotPosition & SLOTP_NECKLACE) != 0) {
			category = OBJECTCATEGORY_NECKLACES;
		} else if ((it.slotPosition & SLOTP_BACKPACK) != 0) {
			category = OBJECTCATEGORY_CONTAINERS;
		} else if ((it.slotPosition & SLOTP_ARMOR) != 0) {
			category = OBJECTCATEGORY_ARMORS;
		} else if ((it.slotPosition & SLOTP_LEGS) != 0) {
			category = OBJECTCATEGORY_LEGS;
		} else if ((it.slotPosition & SLOTP_FEET) != 0) {
			category = OBJECTCATEGORY_BOOTS;
		} else if ((it.slotPosition & SLOTP_RING) != 0) {
			category = OBJECTCATEGORY_RINGS;
		}
	} else if (it.type == ITEM_TYPE_RUNE) {
		category = OBJECTCATEGORY_RUNES;
	} else if (it.type == ITEM_TYPE_CREATUREPRODUCT) {
		category = OBJECTCATEGORY_CREATUREPRODUCTS;
	} else if (it.type == ITEM_TYPE_FOOD) {
		category = OBJECTCATEGORY_FOOD;
	} else if (it.type == ITEM_TYPE_VALUABLE) {
		category = OBJECTCATEGORY_VALUABLES;
	} else if (it.type == ITEM_TYPE_POTION) {
		category = OBJECTCATEGORY_POTIONS;
	} else {
		category = OBJECTCATEGORY_OTHERS;
	}

	return category;
}

uint64_t Game::getItemMarketPrice(std::map<uint16_t, uint32_t> const &itemMap, bool buyPrice) const
{
	uint64_t total = 0;
	for (const auto& it : itemMap) {
		if (it.first == ITEM_GOLD_COIN) {
			total += it.second;
		} else if (it.first == ITEM_PLATINUM_COIN) {
			total += 100 * it.second;
		} else if (it.first == ITEM_CRYSTAL_COIN) {
			total += 10000 * it.second;
		} else {
			auto marketIt = itemsPriceMap.find(it.first);
			if (marketIt != itemsPriceMap.end()) {
				total += (*marketIt).second * it.second;
			} else {
				const ItemType& iType = Item::items[it.first];
				total += (buyPrice ? iType.buyPrice : iType.sellPrice) * it.second;
			}
		}
	}

	return total;
}

Item* searchForItem(Container* container, uint16_t itemId)
{
	for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
		if ((*it)->getID() == itemId) {
			return *it;
		}
	}

	return nullptr;
}

Slots_t getSlotType(const ItemType& it)
{
	Slots_t slot = CONST_SLOT_RIGHT;
	if (it.weaponType != WeaponType_t::WEAPON_SHIELD) {
		int32_t slotPosition = it.slotPosition;

		if (slotPosition & SLOTP_HEAD) {
			slot = CONST_SLOT_HEAD;
		} else if (slotPosition & SLOTP_NECKLACE) {
			slot = CONST_SLOT_NECKLACE;
		} else if (slotPosition & SLOTP_ARMOR) {
			slot = CONST_SLOT_ARMOR;
		} else if (slotPosition & SLOTP_LEGS) {
			slot = CONST_SLOT_LEGS;
		} else if (slotPosition & SLOTP_FEET) {
			slot = CONST_SLOT_FEET ;
		} else if (slotPosition & SLOTP_RING) {
			slot = CONST_SLOT_RING;
		} else if (slotPosition & SLOTP_AMMO) {
			slot = CONST_SLOT_AMMO;
		} else if (slotPosition & SLOTP_TWO_HAND || slotPosition & SLOTP_LEFT) {
			slot = CONST_SLOT_LEFT;
		}
	}

	return slot;
}

//Implementation of player invoked events
void Game::playerEquipItem(uint32_t playerId, uint16_t itemId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Item* item = player->getInventoryItem(CONST_SLOT_BACKPACK);
	if (!item) {
		return;
	}

	Container* backpack = item->getContainer();
	if (!backpack) {
		return;
	}

	const ItemType& it = Item::items[itemId];
	Slots_t slot = getSlotType(it);

	Item* slotItem = player->getInventoryItem(slot);
	Item* equipItem = searchForItem(backpack, it.id);
	if (slotItem && slotItem->getID() == it.id && (!it.stackable || slotItem->getItemCount() == 100 || !equipItem)) {
		internalMoveItem(slotItem->getParent(), player, CONST_SLOT_WHEREEVER, slotItem, slotItem->getItemCount(), nullptr);
	} else if (equipItem) {
		internalMoveItem(equipItem->getParent(), player, slot, equipItem, equipItem->getItemCount(), nullptr);
	}
}

void Game::playerMove(uint32_t playerId, Direction direction)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->resetIdleTime();
	player->setNextWalkActionTask(nullptr);
	player->cancelPush();

	player->startAutoWalk(std::forward_list<Direction> { direction });
}

bool Game::playerBroadcastMessage(Player* player, const std::string& text) const
{
	if (!player->hasFlag(PlayerFlag_CanBroadcast)) {
		return false;
	}

	SPDLOG_INFO("{} broadcasted: {}", player->getName(), text);

	for (const auto& it : players) {
		it.second->sendPrivateMessage(player, TALKTYPE_BROADCAST, text);
	}

	return true;
}

void Game::playerCreatePrivateChannel(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player || !player->isPremium()) {
		return;
	}

	ChatChannel* channel = g_chat().createChannel(*player, CHANNEL_PRIVATE);
	if (!channel || !channel->addUser(*player)) {
		return;
	}

	player->sendCreatePrivateChannel(channel->getId(), channel->getName());
}

void Game::playerChannelInvite(uint32_t playerId, const std::string& name)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	PrivateChatChannel* channel = g_chat().getPrivateChannel(*player);
	if (!channel) {
		return;
	}

	Player* invitePlayer = getPlayerByName(name);
	if (!invitePlayer) {
		return;
	}

	if (player == invitePlayer) {
		return;
	}

	channel->invitePlayer(*player, *invitePlayer);
}

void Game::playerChannelExclude(uint32_t playerId, const std::string& name)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	PrivateChatChannel* channel = g_chat().getPrivateChannel(*player);
	if (!channel) {
		return;
	}

	Player* excludePlayer = getPlayerByName(name);
	if (!excludePlayer) {
		return;
	}

	if (player == excludePlayer) {
		return;
	}

	channel->excludePlayer(*player, *excludePlayer);
}

void Game::playerRequestChannels(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->sendChannelsDialog();
}

void Game::playerOpenChannel(uint32_t playerId, uint16_t channelId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	const ChatChannel* channel = g_chat().addUserToChannel(*player, channelId);
	if (!channel) {
		return;
	}

	const InvitedMap* invitedUsers = channel->getInvitedUsers();
	const UsersMap* users;
	if (!channel->isPublicChannel()) {
		users = &channel->getUsers();
	} else {
		users = nullptr;
	}

	player->sendChannel(channel->getId(), channel->getName(), users, invitedUsers);
}

void Game::playerCloseChannel(uint32_t playerId, uint16_t channelId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	g_chat().removeUserFromChannel(*player, channelId);
}

void Game::playerOpenPrivateChannel(uint32_t playerId, std::string& receiver)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!IOLoginData::formatPlayerName(receiver)) {
		player->sendCancelMessage("A player with this name does not exist.");
		return;
	}

	if (player->getName() == receiver) {
		player->sendCancelMessage("You cannot set up a private message channel with yourself.");
		return;
	}

	player->sendOpenPrivateChannel(receiver);
}

void Game::playerCloseNpcChannel(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	SpectatorHashSet spectators;
	map.getSpectators(spectators, player->getPosition());
	for (Creature* spectator : spectators) {
		if (Npc* npc = spectator->getNpc()) {
			npc->onPlayerCloseChannel(player);
		}
	}
}

void Game::playerReceivePing(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->receivePing();
}

void Game::playerReceivePingBack(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->sendPingBack();
}

void Game::playerAutoWalk(uint32_t playerId, const std::forward_list<Direction>& listDir)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->resetIdleTime();
	player->setNextWalkTask(nullptr);
	player->startAutoWalk(listDir);
}

void Game::playerStopAutoWalk(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->stopWalk();
}

void Game::playerUseItemEx(uint32_t playerId, const Position& fromPos, uint8_t fromStackPos, uint16_t fromItemId,
                           const Position& toPos, uint8_t toStackPos, uint16_t toItemId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	bool isHotkey = (fromPos.x == 0xFFFF && fromPos.y == 0 && fromPos.z == 0);
	if (isHotkey && !g_configManager().getBoolean(AIMBOT_HOTKEY_ENABLED)) {
		return;
	}

	Thing* thing = internalGetThing(player, fromPos, fromStackPos, fromItemId, STACKPOS_FIND_THING);
	if (!thing) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Item* item = thing->getItem();
	if (!item || !item->isMultiUse() || item->getID() != fromItemId) {
		player->sendCancelMessage(RETURNVALUE_CANNOTUSETHISOBJECT);
		return;
	}

	Position walkToPos = fromPos;
	ReturnValue ret = g_actions().canUse(player, fromPos);
	if (ret == RETURNVALUE_NOERROR) {
		ret = g_actions().canUse(player, toPos, item);
		if (ret == RETURNVALUE_TOOFARAWAY) {
			walkToPos = toPos;
		}
	}

	const ItemType& it = Item::items[item->getID()];
	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		if (player->walkExhausted()) {
			player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
			return;
		}
	}

	if (ret != RETURNVALUE_NOERROR) {
		if (ret == RETURNVALUE_TOOFARAWAY) {
			Position itemPos = fromPos;
			uint8_t itemStackPos = fromStackPos;

			if (fromPos.x != 0xFFFF && toPos.x != 0xFFFF && Position::areInRange<1, 1, 0>(fromPos, player->getPosition()) &&
					!Position::areInRange<1, 1, 0>(fromPos, toPos)) {
				Item* moveItem = nullptr;

				ret = internalMoveItem(item->getParent(), player, INDEX_WHEREEVER, item, item->getItemCount(), &moveItem);
				if (ret != RETURNVALUE_NOERROR) {
					player->sendCancelMessage(ret);
					return;
				}

				//changing the position since its now in the inventory of the player
				internalGetPosition(moveItem, itemPos, itemStackPos);
			}

			std::forward_list<Direction> listDir;
			if (player->getPathTo(walkToPos, listDir, 0, 1, true, true)) {
				g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk, this, player->getID(), listDir)));

				SchedulerTask* task = createSchedulerTask(400,
                                      std::bind(&Game::playerUseItemEx, this,
                                      playerId, itemPos, itemStackPos, fromItemId,
                                      toPos, toStackPos, toItemId));
				if (it.isRune() || it.type == ITEM_TYPE_POTION) {
					player->setNextPotionActionTask(task);
				} else {
					player->setNextWalkActionTask(task);
				}
			} else {
				player->sendCancelMessage(RETURNVALUE_THEREISNOWAY);
			}
			return;
		}

		player->sendCancelMessage(ret);
		return;
	}

	bool canDoAction = player->canDoAction();
	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		canDoAction = player->canDoPotionAction();
	}

	if (!canDoAction) {
		uint32_t delay = player->getNextActionTime();
		if (it.isRune() || it.type == ITEM_TYPE_POTION) {
			delay = player->getNextPotionActionTime();
		}
		SchedulerTask* task = createSchedulerTask(delay, std::bind(&Game::playerUseItemEx, this,
                              playerId, fromPos, fromStackPos, fromItemId, toPos, toStackPos, toItemId));
		if (it.isRune() || it.type == ITEM_TYPE_POTION) {
			player->setNextPotionActionTask(task);
		} else {
			player->setNextActionTask(task);
		}
		return;
	}

	player->resetIdleTime();
	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		player->setNextPotionActionTask(nullptr);
	} else {
		player->setNextActionTask(nullptr);
	}

	g_actions().useItemEx(player, fromPos, toPos, toStackPos, item, isHotkey);
}

void Game::playerUseItem(uint32_t playerId, const Position& pos, uint8_t stackPos,
                         uint8_t index, uint16_t itemId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	bool isHotkey = (pos.x == 0xFFFF && pos.y == 0 && pos.z == 0);
	if (isHotkey && !g_configManager().getBoolean(AIMBOT_HOTKEY_ENABLED)) {
		return;
	}

	Thing* thing = internalGetThing(player, pos, stackPos, itemId, STACKPOS_FIND_THING);
	if (!thing) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Item* item = thing->getItem();
	if (!item || item->isMultiUse() || item->getID() != itemId) {
		player->sendCancelMessage(RETURNVALUE_CANNOTUSETHISOBJECT);
		return;
	}

	const ItemType& it = Item::items[item->getID()];
	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		if (player->walkExhausted()) {
			player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
			return;
		}
	}

	ReturnValue ret = g_actions().canUse(player, pos);
	if (ret != RETURNVALUE_NOERROR) {
		if (ret == RETURNVALUE_TOOFARAWAY) {
			std::forward_list<Direction> listDir;
			if (player->getPathTo(pos, listDir, 0, 1, true, true)) {
				g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk,
												this, player->getID(), listDir)));

				SchedulerTask* task = createSchedulerTask(400,
                                      std::bind(&Game::playerUseItem, this,
                                      playerId, pos, stackPos, index, itemId));
				if (it.isRune() || it.type == ITEM_TYPE_POTION) {
					player->setNextPotionActionTask(task);
				} else {
					player->setNextWalkActionTask(task);
				}
				return;
			}

			ret = RETURNVALUE_THEREISNOWAY;
		}

		player->sendCancelMessage(ret);
		return;
	}

	bool canDoAction = player->canDoAction();
	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		canDoAction = player->canDoPotionAction();
	}

	if (!canDoAction) {
		uint32_t delay = player->getNextActionTime();
		if (it.isRune() || it.type == ITEM_TYPE_POTION) {
			delay = player->getNextPotionActionTime();
		}
		SchedulerTask* task = createSchedulerTask(delay, std::bind(&Game::playerUseItem, this,
                              playerId, pos, stackPos, index, itemId));
		if (it.isRune() || it.type == ITEM_TYPE_POTION) {
			player->setNextPotionActionTask(task);
		} else {
			player->setNextActionTask(task);
		}
		return;
	}

	player->resetIdleTime();
	player->setNextActionTask(nullptr);

	g_actions().useItem(player, pos, index, item, isHotkey);
}

void Game::playerUseWithCreature(uint32_t playerId, const Position& fromPos, uint8_t fromStackPos, uint32_t creatureId, uint16_t itemId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Creature* creature = getCreatureByID(creatureId);
	if (!creature) {
		return;
	}

	if (!Position::areInRange<7, 5, 0>(creature->getPosition(), player->getPosition())) {
		return;
	}

	bool isHotkey = (fromPos.x == 0xFFFF && fromPos.y == 0 && fromPos.z == 0);
	if (!g_configManager().getBoolean(AIMBOT_HOTKEY_ENABLED)) {
		if (creature->getPlayer() || isHotkey) {
			player->sendCancelMessage(RETURNVALUE_DIRECTPLAYERSHOOT);
			return;
		}
	}

	Thing* thing = internalGetThing(player, fromPos, fromStackPos, itemId, STACKPOS_FIND_THING);
	if (!thing) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Item* item = thing->getItem();
	if (!item || !item->isMultiUse() || item->getID() != itemId) {
		player->sendCancelMessage(RETURNVALUE_CANNOTUSETHISOBJECT);
		return;
	}

	const ItemType& it = Item::items[item->getID()];
	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		if (player->walkExhausted()) {
			player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
			return;
		}
	}
	Position toPos = creature->getPosition();
	Position walkToPos = fromPos;
	ReturnValue ret = g_actions().canUse(player, fromPos);
	if (ret == RETURNVALUE_NOERROR) {
		ret = g_actions().canUse(player, toPos, item);
		if (ret == RETURNVALUE_TOOFARAWAY) {
			walkToPos = toPos;
		}
	}

	if (ret != RETURNVALUE_NOERROR) {
		if (ret == RETURNVALUE_TOOFARAWAY) {
			Position itemPos = fromPos;
			uint8_t itemStackPos = fromStackPos;

			if (fromPos.x != 0xFFFF && Position::areInRange<1, 1, 0>(fromPos, player->getPosition()) && !Position::areInRange<1, 1, 0>(fromPos, toPos)) {
				Item* moveItem = nullptr;
				ret = internalMoveItem(item->getParent(), player, INDEX_WHEREEVER, item, item->getItemCount(), &moveItem);
				if (ret != RETURNVALUE_NOERROR) {
					player->sendCancelMessage(ret);
					return;
				}

				//changing the position since its now in the inventory of the player
				internalGetPosition(moveItem, itemPos, itemStackPos);
			}

			std::forward_list<Direction> listDir;
			if (player->getPathTo(walkToPos, listDir, 0, 1, true, true)) {
				g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk,
												this, player->getID(), listDir)));

				SchedulerTask* task = createSchedulerTask(400,
                                      std::bind(&Game::playerUseWithCreature, this,
                                      playerId, itemPos, itemStackPos,
                                      creatureId, itemId));
				if (it.isRune() || it.type == ITEM_TYPE_POTION) {
					player->setNextPotionActionTask(task);
				} else {
					player->setNextWalkActionTask(task);
				}
			} else {
				player->sendCancelMessage(RETURNVALUE_THEREISNOWAY);
			}
			return;
		}

		player->sendCancelMessage(ret);
		return;
	}

	bool canDoAction = player->canDoAction();
	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		canDoAction = player->canDoPotionAction();
	}

	if (!canDoAction) {
		uint32_t delay = player->getNextActionTime();
		if (it.isRune() || it.type == ITEM_TYPE_POTION) {
			delay = player->getNextPotionActionTime();
		}
		SchedulerTask* task = createSchedulerTask(delay, std::bind(&Game::playerUseWithCreature, this,
                              playerId, fromPos, fromStackPos, creatureId, itemId));

		if (it.isRune() || it.type == ITEM_TYPE_POTION) {
			player->setNextPotionActionTask(task);
		} else {
			player->setNextActionTask(task);
		}
		return;
	}

	player->resetIdleTime();
	if (it.isRune() || it.type == ITEM_TYPE_POTION) {
		player->setNextPotionActionTask(nullptr);
	} else {
		player->setNextActionTask(nullptr);
	}

	g_actions().useItemEx(player, fromPos, creature->getPosition(), creature->getParent()->getThingIndex(creature), item, isHotkey, creature);
}

void Game::playerCloseContainer(uint32_t playerId, uint8_t cid)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->closeContainer(cid);
	player->sendCloseContainer(cid);
}

void Game::playerMoveUpContainer(uint32_t playerId, uint8_t cid)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Container* container = player->getContainerByID(cid);
	if (!container) {
		return;
	}

	Container* parentContainer = dynamic_cast<Container*>(container->getRealParent());
	if (!parentContainer) {
		Tile* tile = container->getTile();
		if (!tile) {
			return;
		}

		if (!g_events().eventPlayerOnBrowseField(player, tile->getPosition())) {
			return;
		}

		auto it = browseFields.find(tile);
		if (it == browseFields.end()) {
			parentContainer = new Container(tile);
			parentContainer->incrementReferenceCounter();
			browseFields[tile] = parentContainer;
			g_scheduler().addEvent(createSchedulerTask(30000, std::bind(&Game::decreaseBrowseFieldRef, this, tile->getPosition())));
		} else {
			parentContainer = it->second;
		}
	}

	if (parentContainer->hasPagination() && parentContainer->hasParent()) {
		uint16_t indexContainer = std::floor(parentContainer->getThingIndex(container) / parentContainer->capacity()) * parentContainer->capacity();
		player->addContainer(cid, parentContainer);

		player->setContainerIndex(cid, indexContainer);
		player->sendContainer(cid, parentContainer, parentContainer->hasParent(), indexContainer);
	} else {
		player->addContainer(cid, parentContainer);
		player->sendContainer(cid, parentContainer, parentContainer->hasParent(), player->getContainerIndex(cid));
	}
}

void Game::playerUpdateContainer(uint32_t playerId, uint8_t cid)
{
	Player* player = getPlayerByGUID(playerId);
	if (!player) {
		return;
	}

	Container* container = player->getContainerByID(cid);
	if (!container) {
		return;
	}

	player->sendContainer(cid, container, container->hasParent(), player->getContainerIndex(cid));
}

void Game::playerRotateItem(uint32_t playerId, const Position& pos, uint8_t stackPos, const uint16_t itemId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Thing* thing = internalGetThing(player, pos, stackPos, 0, STACKPOS_TOPDOWN_ITEM);
	if (!thing) {
		return;
	}

	Item* item = thing->getItem();
	if (!item || item->getID() != itemId || !item->isRotatable() || item->hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	if (pos.x != 0xFFFF && !Position::areInRange<1, 1, 0>(pos, player->getPosition())) {
		std::forward_list<Direction> listDir;
		if (player->getPathTo(pos, listDir, 0, 1, true, true)) {
			g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk,
											this, player->getID(), listDir)));

			SchedulerTask* task = createSchedulerTask(400, std::bind(&Game::playerRotateItem, this,
                                  playerId, pos, stackPos, itemId));
			player->setNextWalkActionTask(task);
		} else {
			player->sendCancelMessage(RETURNVALUE_THEREISNOWAY);
		}
		return;
	}

	uint16_t newId = Item::items[item->getID()].rotateTo;
	if (newId != 0) {
		transformItem(item, newId);
	}
}

void Game::playerConfigureShowOffSocket(uint32_t playerId, const Position& pos, uint8_t stackPos, const uint16_t itemId)
{
	Player* player = getPlayerByID(playerId);
	if (!player || pos.x == 0xFFFF) {
		return;
	}

	Thing* thing = internalGetThing(player, pos, stackPos, 0, STACKPOS_TOPDOWN_ITEM);
	if (!thing) {
		return;
	}

	Item* item = thing->getItem();
	if (!item || item->getID() != itemId || !item->isPodium() || item->hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	if (!Position::areInRange<1, 1, 0>(pos, player->getPosition())) {
		std::forward_list<Direction> listDir;
		if (player->getPathTo(pos, listDir, 0, 1, true, false)) {
			g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk, this, player->getID(), listDir)));
			SchedulerTask* task = createSchedulerTask(400,
                                  std::bind(&Game::playerBrowseField,
                                  this, playerId, pos));
			player->setNextWalkActionTask(task);

		} else {
			player->sendCancelMessage(RETURNVALUE_THEREISNOWAY);
		}
		return;
	}

	player->sendPodiumWindow(item, pos, itemId, stackPos);
}

void Game::playerSetShowOffSocket(uint32_t playerId, Outfit_t& outfit, const Position& pos, uint8_t stackPos, const uint16_t itemId, uint8_t podiumVisible, uint8_t direction)
{
	Player* player = getPlayerByID(playerId);
	if (!player || pos.x == 0xFFFF) {
		return;
	}

	Thing* thing = internalGetThing(player, pos, stackPos, 0, STACKPOS_TOPDOWN_ITEM);
	if (!thing) {
		return;
	}

	Item* item = thing->getItem();
	if (!item || item->getID() != itemId || !item->isPodium() || item->hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Tile* tile = dynamic_cast<Tile*>(item->getParent());
	if (!tile) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	if (!Position::areInRange<1, 1, 0>(pos, player->getPosition())) {
		std::forward_list<Direction> listDir;
		if (player->getPathTo(pos, listDir, 0, 1, true, false)) {
			g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk, this, player->getID(), listDir)));
			SchedulerTask* task = createSchedulerTask(400,
                                  std::bind(&Game::playerBrowseField,
                                  this, playerId, pos));
			player->setNextWalkActionTask(task);
		} else {
			player->sendCancelMessage(RETURNVALUE_THEREISNOWAY);
		}
		return;
	}

	if (!player->canWear(outfit.lookType, outfit.lookAddons)) {
		outfit.lookType = 0;
		outfit.lookAddons = 0;
	}

	Mount* mount = mounts.getMountByClientID(outfit.lookMount);
	if (!mount || !player->hasMount(mount)) {
		outfit.lookMount = 0;
	}

	std::string key; // Too lazy to fix it :) let's just use temporary key variable
	if (outfit.lookType != 0) {
		key = "LookType"; item->setCustomAttribute(key, static_cast<int64_t>(outfit.lookType));
		key = "LookHead"; item->setCustomAttribute(key, static_cast<int64_t>(outfit.lookHead));
		key = "LookBody"; item->setCustomAttribute(key, static_cast<int64_t>(outfit.lookBody));
		key = "LookLegs"; item->setCustomAttribute(key, static_cast<int64_t>(outfit.lookLegs));
		key = "LookFeet"; item->setCustomAttribute(key, static_cast<int64_t>(outfit.lookFeet));
		key = "LookAddons"; item->setCustomAttribute(key, static_cast<int64_t>(outfit.lookAddons));
	} else {
		item->removeCustomAttribute("LookType");
	}

	if (outfit.lookMount != 0) {
		key = "LookMount"; item->setCustomAttribute(key, static_cast<int64_t>(outfit.lookMount));
		key = "LookMountHead"; item->setCustomAttribute(key, static_cast<int64_t>(outfit.lookMountHead));
		key = "LookMountBody"; item->setCustomAttribute(key, static_cast<int64_t>(outfit.lookMountBody));
		key = "LookMountLegs"; item->setCustomAttribute(key, static_cast<int64_t>(outfit.lookMountLegs));
		key = "LookMountFeet"; item->setCustomAttribute(key, static_cast<int64_t>(outfit.lookMountFeet));
	} else {
		item->removeCustomAttribute("LookMount");
	}

	key = "PodiumVisible"; item->setCustomAttribute(key, static_cast<int64_t>(podiumVisible));
	key = "LookDirection"; item->setCustomAttribute(key, static_cast<int64_t>(direction));

	SpectatorHashSet spectators;
	g_game().map.getSpectators(spectators, pos, true);

	// send to client
	for (Creature* spectator : spectators) {
		if (Player* tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendUpdateTileItem(tile, pos, item);
		}
	}
}

void Game::playerWrapableItem(uint32_t playerId, const Position& pos, uint8_t stackPos, const uint16_t itemId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	House* house = map.houses.getHouseByPlayerId(player->getGUID());
	if (!house) {
		player->sendCancelMessage("You don't own a house, you need own a house to use this.");
		return;
	}

	Thing* thing = internalGetThing(player, pos, stackPos, 0, STACKPOS_TOPDOWN_ITEM);
	if (!thing) {
		return;
	}

	Item* item = thing->getItem();
	Tile* tile = map.getTile(item->getPosition());
	HouseTile* houseTile = dynamic_cast<HouseTile*>(tile);
	if (!tile->hasFlag(TILESTATE_PROTECTIONZONE) || !houseTile) {
		player->sendCancelMessage("You may construct this only inside a house.");
		return;
	}
	if (houseTile->getHouse() != house) {
		player->sendCancelMessage("Only owners can wrap/unwrap inside a house.");
			return;
	}

	if (!item || item->getID() != itemId || item->hasAttribute(ITEM_ATTRIBUTE_UNIQUEID) || (!item->isWrapable() && item->getID() != ITEM_DECORATION_KIT)) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	if (pos.x != 0xFFFF && !Position::areInRange<1, 1, 0>(pos, player->getPosition())) {
		std::forward_list<Direction> listDir;
		if (player->getPathTo(pos, listDir, 0, 1, true, true)) {
			g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk,
				this, player->getID(), listDir)));

			SchedulerTask* task = createSchedulerTask(400, std::bind(&Game::playerWrapableItem, this,
				playerId, pos, stackPos, itemId));
			player->setNextWalkActionTask(task);
		} else {
			player->sendCancelMessage(RETURNVALUE_THEREISNOWAY);
		}
		return;
	}

	const Container* container = item->getContainer();
	if (container && container->getItemHoldingCount() > 0) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	if ((item->getHoldingPlayer() && item->getID() == ITEM_DECORATION_KIT) || (tile->hasFlag(TILESTATE_IMMOVABLEBLOCKSOLID) && !item->hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID))) {
		player->sendCancelMessage("You can only wrap/unwrap in the floor.");
		return;
	}

	std::string itemName = item->getName();
	const ItemAttributes::CustomAttribute* attr = item->getCustomAttribute("unWrapId");
	uint16_t unWrapId = 0;
	if (attr != nullptr) {
		uint32_t tmp = static_cast<uint32_t>(boost::get<int64_t>(attr->value));
		unWrapId = (uint16_t)tmp;
	}

	// Prevent to wrap a filled bath tube
	if (item->getID() == ITEM_FILLED_BATH_TUBE) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	if (item->isWrapable() && item->getID() != ITEM_DECORATION_KIT) {
		uint16_t hiddenCharges = 0;
		if (isCaskItem(item->getID())) {
			hiddenCharges = item->getSubType();
		}
		uint16_t oldItemID = item->getID();
		addMagicEffect(item->getPosition(), CONST_ME_POFF);
		Item* newItem = transformItem(item, ITEM_DECORATION_KIT);
		ItemAttributes::CustomAttribute val;
		val.set<int64_t>(oldItemID);
		std::string key = "unWrapId";
		newItem->setCustomAttribute(key, val);
		item->setSpecialDescription("Unwrap it in your own house to create a <" + itemName + ">.");
		if (hiddenCharges > 0) {
			item->setDate(hiddenCharges);
		}
		newItem->startDecaying();
	}
	else if (item->getID() == ITEM_DECORATION_KIT && unWrapId != 0) {
		uint16_t hiddenCharges = item->getDate();
		Item* newItem = transformItem(item, unWrapId);
		if (newItem) {
			if (hiddenCharges > 0 && isCaskItem(unWrapId)) {
				newItem->setSubType(hiddenCharges);
			}
			addMagicEffect(pos, CONST_ME_POFF);
			newItem->removeCustomAttribute("unWrapId");
			newItem->removeAttribute(ITEM_ATTRIBUTE_DESCRIPTION);
			newItem->startDecaying();
		}
	}
}

void Game::playerWriteItem(uint32_t playerId, uint32_t windowTextId, const std::string& text)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	uint16_t maxTextLength = 0;
	uint32_t internalWindowTextId = 0;

	Item* writeItem = player->getWriteItem(internalWindowTextId, maxTextLength);
	if (text.length() > maxTextLength || windowTextId != internalWindowTextId) {
		return;
	}

	if (!writeItem || writeItem->isRemoved()) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Cylinder* topParent = writeItem->getTopParent();

	Player* owner = dynamic_cast<Player*>(topParent);
	if (owner && owner != player) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	if (!Position::areInRange<1, 1, 0>(writeItem->getPosition(), player->getPosition())) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	for (auto creatureEvent : player->getCreatureEvents(CREATURE_EVENT_TEXTEDIT)) {
		if (!creatureEvent->executeTextEdit(player, writeItem, text)) {
			player->setWriteItem(nullptr);
			return;
		}
	}

	if (!text.empty()) {
		if (writeItem->getText() != text) {
			writeItem->setText(text);
			writeItem->setWriter(player->getName());
			writeItem->setDate(time(nullptr));
		}
	} else {
		writeItem->resetText();
		writeItem->resetWriter();
		writeItem->resetDate();
	}

	uint16_t newId = Item::items[writeItem->getID()].writeOnceItemId;
	if (newId != 0) {
		transformItem(writeItem, newId);
	}

	player->setWriteItem(nullptr);
}

void Game::playerBrowseField(uint32_t playerId, const Position& pos)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	const Position& playerPos = player->getPosition();
	if (playerPos.z != pos.z) {
		player->sendCancelMessage(playerPos.z > pos.z ? RETURNVALUE_FIRSTGOUPSTAIRS : RETURNVALUE_FIRSTGODOWNSTAIRS);
		return;
	}

	if (!Position::areInRange<1, 1>(playerPos, pos)) {
		std::forward_list<Direction> listDir;
		if (player->getPathTo(pos, listDir, 0, 1, true, true)) {
			g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk,
											this, player->getID(), listDir)));
			SchedulerTask* task = createSchedulerTask(400,
                                  std::bind(&Game::playerBrowseField,
                                  this, playerId, pos));
			player->setNextWalkActionTask(task);
		} else {
			player->sendCancelMessage(RETURNVALUE_THEREISNOWAY);
		}
		return;
	}

	Tile* tile = map.getTile(pos);
	if (!tile) {
		return;
	}

	if (!g_events().eventPlayerOnBrowseField(player, pos)) {
		return;
	}

	Container* container;

	auto it = browseFields.find(tile);
	if (it == browseFields.end()) {
		container = new Container(tile);
		container->incrementReferenceCounter();
		browseFields[tile] = container;
		g_scheduler().addEvent(createSchedulerTask(30000, std::bind(&Game::decreaseBrowseFieldRef, this, tile->getPosition())));
	} else {
		container = it->second;
	}

	uint8_t dummyContainerId = 0xF - ((pos.x % 3) * 3 + (pos.y % 3));
	Container* openContainer = player->getContainerByID(dummyContainerId);
	if (openContainer) {
		player->onCloseContainer(openContainer);
		player->closeContainer(dummyContainerId);
	} else {
		player->addContainer(dummyContainerId, container);
		player->sendContainer(dummyContainerId, container, false, 0);
	}
}

void Game::playerStowItem(uint32_t playerId, const Position& pos, uint16_t itemId, uint8_t stackpos, uint8_t count, bool allItems)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!player->isPremium()) {
		player->sendCancelMessage(RETURNVALUE_YOUNEEDPREMIUMACCOUNT);
		return;
	}

	Thing* thing = internalGetThing(player, pos, stackpos, 0, STACKPOS_TOPDOWN_ITEM);
	if (!thing)
		return;

	Item* item = thing->getItem();
	if (!item || item->getID() != itemId || item->getItemCount() < count) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	if (pos.x != 0xFFFF && !Position::areInRange<1, 1, 0>(pos, player->getPosition())) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}
	player->stowItem(item, count, allItems);
}

void Game::playerStashWithdraw(uint32_t playerId, uint16_t itemId, uint32_t count, uint8_t)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (player->hasFlag(PlayerFlag_CannotPickupItem)) {
		return;
	}

	const ItemType& it = Item::items[itemId];
	if (it.id == 0 || count == 0) {
		return;
	}

	uint16_t freeSlots = player->getFreeBackpackSlots();
	Container* stashContainer = player->getLootContainer(OBJECTCATEGORY_STASHRETRIEVE);
	if (stashContainer && !(player->quickLootFallbackToMainContainer)) {
		freeSlots = stashContainer->getFreeSlots();
	}

	if (freeSlots == 0) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
		return;
	}

	if (player->getFreeCapacity() < 100) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHCAPACITY);
		return;
	}

	int32_t NDSlots = ((freeSlots) - (count < 100 ? 1 : (count / 100)));
	uint32_t SlotsWith = count;
	uint32_t noSlotsWith = 0;

	if (NDSlots <= 0) {
		SlotsWith = (freeSlots * 100);
		noSlotsWith = (count - SlotsWith);
	}

	uint32_t capWith = count;
	uint32_t noCapWith = 0;
	if (player->getFreeCapacity() < (count * it.weight)) {
		capWith = (player->getFreeCapacity() / it.weight);
		noCapWith = (count - capWith);
	}

	std::stringstream ss;
	uint32_t WithdrawCount = (SlotsWith > capWith ? capWith : SlotsWith);
	uint32_t NoWithdrawCount = (noSlotsWith < noCapWith ? noCapWith : noSlotsWith);
	const char * NoWithdrawMsg = (noSlotsWith < noCapWith ? "capacity" : "slots");

	if (WithdrawCount != count) {
		ss << "Retrieved " << WithdrawCount << "x " << it.name << ".\n";
		ss << NoWithdrawCount << "x are impossible to retrieve due to insufficient inventory " << NoWithdrawMsg << ".";
	} else {
		ss << "Retrieved " << WithdrawCount << "x " << it.name << '.';
	}

	player->sendTextMessage(MESSAGE_STATUS, ss.str());

	if (player->withdrawItem(itemId, WithdrawCount)) {
		player->addItemFromStash(it.id, WithdrawCount);
	} else {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
	}
}

void Game::playerSeekInContainer(uint32_t playerId, uint8_t containerId, uint16_t index)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Container* container = player->getContainerByID(containerId);
	if (!container || !container->hasPagination()) {
		return;
	}

	if ((index % container->capacity()) != 0 || index >= container->size()) {
		return;
	}

	player->setContainerIndex(containerId, index);
	player->sendContainer(containerId, container, container->hasParent(), index);
}

void Game::playerUpdateHouseWindow(uint32_t playerId, uint8_t listId, uint32_t windowTextId, const std::string& text)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	uint32_t internalWindowTextId;
	uint32_t internalListId;

	House* house = player->getEditHouse(internalWindowTextId, internalListId);
	if (house && house->canEditAccessList(internalListId, player) && internalWindowTextId == windowTextId && listId == 0) {
		house->setAccessList(internalListId, text);
	}

	player->setEditHouse(nullptr);
}

void Game::playerRequestTrade(uint32_t playerId, const Position& pos, uint8_t stackPos,
                              uint32_t tradePlayerId, uint16_t itemId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Player* tradePartner = getPlayerByID(tradePlayerId);
	if (!tradePartner || tradePartner == player) {
		player->sendTextMessage(MESSAGE_FAILURE, "Sorry, not possible.");
		return;
	}

	if (!Position::areInRange<2, 2, 0>(tradePartner->getPosition(), player->getPosition())) {
		std::ostringstream ss;
		ss << tradePartner->getName() << " tells you to move closer.";
		player->sendTextMessage(MESSAGE_TRADE, ss.str());
		return;
	}

	if (!canThrowObjectTo(tradePartner->getPosition(), player->getPosition())) {
		player->sendCancelMessage(RETURNVALUE_CREATUREISNOTREACHABLE);
		return;
	}

	Thing* tradeThing = internalGetThing(player, pos, stackPos, 0, STACKPOS_TOPDOWN_ITEM);
	if (!tradeThing) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Item* tradeItem = tradeThing->getItem();
	if (tradeItem->getID() != itemId || !tradeItem->isPickupable() || tradeItem->hasAttribute(ITEM_ATTRIBUTE_UNIQUEID)) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

  if (g_configManager().getBoolean(ONLY_INVITED_CAN_MOVE_HOUSE_ITEMS)) {
		if (HouseTile* houseTile = dynamic_cast<HouseTile*>(tradeItem->getTile())) {
			House* house = houseTile->getHouse();
			if (house && !house->isInvited(player)) {
				player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
				return;
			}
		}
	}

	const Position& playerPosition = player->getPosition();
	const Position& tradeItemPosition = tradeItem->getPosition();
	if (playerPosition.z != tradeItemPosition.z) {
		player->sendCancelMessage(playerPosition.z > tradeItemPosition.z ? RETURNVALUE_FIRSTGOUPSTAIRS : RETURNVALUE_FIRSTGODOWNSTAIRS);
		return;
	}

	if (!Position::areInRange<1, 1>(tradeItemPosition, playerPosition)) {
		std::forward_list<Direction> listDir;
		if (player->getPathTo(pos, listDir, 0, 1, true, true)) {
			g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk,
											this, player->getID(), listDir)));

			SchedulerTask* task = createSchedulerTask(400, std::bind(&Game::playerRequestTrade, this,
                                  playerId, pos, stackPos, tradePlayerId, itemId));
			player->setNextWalkActionTask(task);
		} else {
			player->sendCancelMessage(RETURNVALUE_THEREISNOWAY);
		}
		return;
	}

	Container* tradeItemContainer = tradeItem->getContainer();
	if (tradeItemContainer) {
		for (const auto& it : tradeItems) {
			Item* item = it.first;
			if (tradeItem == item) {
				player->sendTextMessage(MESSAGE_TRADE, "This item is already being traded.");
				return;
			}

			if (tradeItemContainer->isHoldingItem(item)) {
				player->sendTextMessage(MESSAGE_TRADE, "This item is already being traded.");
				return;
			}

			Container* container = item->getContainer();
			if (container && container->isHoldingItem(tradeItem)) {
				player->sendTextMessage(MESSAGE_TRADE, "This item is already being traded.");
				return;
			}
		}
	} else {
		for (const auto& it : tradeItems) {
			Item* item = it.first;
			if (tradeItem == item) {
				player->sendTextMessage(MESSAGE_TRADE, "This item is already being traded.");
				return;
			}

			Container* container = item->getContainer();
			if (container && container->isHoldingItem(tradeItem)) {
				player->sendTextMessage(MESSAGE_TRADE, "This item is already being traded.");
				return;
			}
		}
	}

	Container* tradeContainer = tradeItem->getContainer();
	if (tradeContainer && tradeContainer->getItemHoldingCount() + 1 > 100) {
		player->sendTextMessage(MESSAGE_TRADE, "You can not trade more than 100 items.");
		return;
	}

	if (!g_events().eventPlayerOnTradeRequest(player, tradePartner, tradeItem)) {
		return;
	}

	internalStartTrade(player, tradePartner, tradeItem);
}

bool Game::internalStartTrade(Player* player, Player* tradePartner, Item* tradeItem)
{
	if (player->tradeState != TRADE_NONE && !(player->tradeState == TRADE_ACKNOWLEDGE && player->tradePartner == tradePartner)) {
		player->sendCancelMessage(RETURNVALUE_YOUAREALREADYTRADING);
		return false;
	} else if (tradePartner->tradeState != TRADE_NONE && tradePartner->tradePartner != player) {
		player->sendCancelMessage(RETURNVALUE_THISPLAYERISALREADYTRADING);
		return false;
	}

	player->tradePartner = tradePartner;
	player->tradeItem = tradeItem;
	player->tradeState = TRADE_INITIATED;
	tradeItem->incrementReferenceCounter();
	tradeItems[tradeItem] = player->getID();

	player->sendTradeItemRequest(player->getName(), tradeItem, true);

	if (tradePartner->tradeState == TRADE_NONE) {
		std::ostringstream ss;
		ss << player->getName() << " wants to trade with you.";
		tradePartner->sendTextMessage(MESSAGE_TRANSACTION, ss.str());
		tradePartner->tradeState = TRADE_ACKNOWLEDGE;
		tradePartner->tradePartner = player;
	} else {
		Item* counterOfferItem = tradePartner->tradeItem;
		player->sendTradeItemRequest(tradePartner->getName(), counterOfferItem, false);
		tradePartner->sendTradeItemRequest(player->getName(), tradeItem, false);
	}

	return true;
}

void Game::playerAcceptTrade(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!(player->getTradeState() == TRADE_ACKNOWLEDGE || player->getTradeState() == TRADE_INITIATED)) {
		return;
	}

	Player* tradePartner = player->tradePartner;
	if (!tradePartner) {
		return;
	}

	if (!canThrowObjectTo(tradePartner->getPosition(), player->getPosition())) {
		player->sendCancelMessage(RETURNVALUE_CREATUREISNOTREACHABLE);
		return;
	}

	player->setTradeState(TRADE_ACCEPT);

	if (tradePartner->getTradeState() == TRADE_ACCEPT) {
		Item* tradeItem1 = player->tradeItem;
		Item* tradeItem2 = tradePartner->tradeItem;

		if (!g_events().eventPlayerOnTradeAccept(player, tradePartner, tradeItem1, tradeItem2)) {
			internalCloseTrade(player);
			return;
		}

		player->setTradeState(TRADE_TRANSFER);
		tradePartner->setTradeState(TRADE_TRANSFER);

		auto it = tradeItems.find(tradeItem1);
		if (it != tradeItems.end()) {
			ReleaseItem(it->first);
			tradeItems.erase(it);
		}

		it = tradeItems.find(tradeItem2);
		if (it != tradeItems.end()) {
			ReleaseItem(it->first);
			tradeItems.erase(it);
		}

		bool isSuccess = false;

		ReturnValue ret1 = internalAddItem(tradePartner, tradeItem1, INDEX_WHEREEVER, 0, true);
		ReturnValue ret2 = internalAddItem(player, tradeItem2, INDEX_WHEREEVER, 0, true);
		if (ret1 == RETURNVALUE_NOERROR && ret2 == RETURNVALUE_NOERROR) {
			ret1 = internalRemoveItem(tradeItem1, tradeItem1->getItemCount(), true);
			ret2 = internalRemoveItem(tradeItem2, tradeItem2->getItemCount(), true);
			if (ret1 == RETURNVALUE_NOERROR && ret2 == RETURNVALUE_NOERROR) {
				Cylinder* cylinder1 = tradeItem1->getParent();
				Cylinder* cylinder2 = tradeItem2->getParent();

				uint32_t count1 = tradeItem1->getItemCount();
				uint32_t count2 = tradeItem2->getItemCount();

				ret1 = internalMoveItem(cylinder1, tradePartner, INDEX_WHEREEVER, tradeItem1, count1, nullptr, FLAG_IGNOREAUTOSTACK, nullptr, tradeItem2);
				if (ret1 == RETURNVALUE_NOERROR) {
					internalMoveItem(cylinder2, player, INDEX_WHEREEVER, tradeItem2, count2, nullptr, FLAG_IGNOREAUTOSTACK);

					tradeItem1->onTradeEvent(ON_TRADE_TRANSFER, tradePartner);
					tradeItem2->onTradeEvent(ON_TRADE_TRANSFER, player);

					isSuccess = true;
				}
			}
		}

		if (!isSuccess) {
			std::string errorDescription;

			if (tradePartner->tradeItem) {
				errorDescription = getTradeErrorDescription(ret1, tradeItem1);
				tradePartner->sendTextMessage(MESSAGE_TRANSACTION, errorDescription);
				tradePartner->tradeItem->onTradeEvent(ON_TRADE_CANCEL, tradePartner);
			}

			if (player->tradeItem) {
				errorDescription = getTradeErrorDescription(ret2, tradeItem2);
				player->sendTextMessage(MESSAGE_TRANSACTION, errorDescription);
				player->tradeItem->onTradeEvent(ON_TRADE_CANCEL, player);
			}
		}

		player->setTradeState(TRADE_NONE);
		player->tradeItem = nullptr;
		player->tradePartner = nullptr;
		player->sendTradeClose();

		tradePartner->setTradeState(TRADE_NONE);
		tradePartner->tradeItem = nullptr;
		tradePartner->tradePartner = nullptr;
		tradePartner->sendTradeClose();
	}
}

std::string Game::getTradeErrorDescription(ReturnValue ret, Item* item)
{
	if (item) {
		if (ret == RETURNVALUE_NOTENOUGHCAPACITY) {
			std::ostringstream ss;
			ss << "You do not have enough capacity to carry";

			if (item->isStackable() && item->getItemCount() > 1) {
				ss << " these objects.";
			} else {
				ss << " this object.";
			}

			ss << std::endl << ' ' << item->getWeightDescription();
			return ss.str();
		} else if (ret == RETURNVALUE_NOTENOUGHROOM || ret == RETURNVALUE_CONTAINERNOTENOUGHROOM) {
			std::ostringstream ss;
			ss << "You do not have enough room to carry";

			if (item->isStackable() && item->getItemCount() > 1) {
				ss << " these objects.";
			} else {
				ss << " this object.";
			}

			return ss.str();
		}
	}
	return "Trade could not be completed.";
}

void Game::playerLookInTrade(uint32_t playerId, bool lookAtCounterOffer, uint8_t index)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Player* tradePartner = player->tradePartner;
	if (!tradePartner) {
		return;
	}

	Item* tradeItem;
	if (lookAtCounterOffer) {
		tradeItem = tradePartner->getTradeItem();
	} else {
		tradeItem = player->getTradeItem();
	}

	if (!tradeItem) {
		return;
	}

	const Position& playerPosition = player->getPosition();
	const Position& tradeItemPosition = tradeItem->getPosition();

	int32_t lookDistance = std::max<int32_t>(
                            Position::getDistanceX(playerPosition, tradeItemPosition),
                            Position::getDistanceY(playerPosition, tradeItemPosition));
	if (index == 0) {
		g_events().eventPlayerOnLookInTrade(player, tradePartner, tradeItem, lookDistance);
		return;
	}

	Container* tradeContainer = tradeItem->getContainer();
	if (!tradeContainer) {
		return;
	}

	std::vector<const Container*> containers {tradeContainer};
	size_t i = 0;
	while (i < containers.size()) {
		const Container* container = containers[i++];
		for (Item* item : container->getItemList()) {
			Container* tmpContainer = item->getContainer();
			if (tmpContainer) {
				containers.push_back(tmpContainer);
			}

			if (--index == 0) {
				g_events().eventPlayerOnLookInTrade(player, tradePartner, item, lookDistance);
				return;
			}
		}
	}
}

void Game::playerCloseTrade(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	internalCloseTrade(player);
}

void Game::internalCloseTrade(Player* player)
{
	Player* tradePartner = player->tradePartner;
	if ((tradePartner && tradePartner->getTradeState() == TRADE_TRANSFER) || player->getTradeState() == TRADE_TRANSFER) {
		return;
	}

	if (player->getTradeItem()) {
		auto it = tradeItems.find(player->getTradeItem());
		if (it != tradeItems.end()) {
			ReleaseItem(it->first);
			tradeItems.erase(it);
		}

		player->tradeItem->onTradeEvent(ON_TRADE_CANCEL, player);
		player->tradeItem = nullptr;
	}

	player->setTradeState(TRADE_NONE);
	player->tradePartner = nullptr;

	player->sendTextMessage(MESSAGE_FAILURE, "Trade cancelled.");
	player->sendTradeClose();

	if (tradePartner) {
		if (tradePartner->getTradeItem()) {
			auto it = tradeItems.find(tradePartner->getTradeItem());
			if (it != tradeItems.end()) {
				ReleaseItem(it->first);
				tradeItems.erase(it);
			}

			tradePartner->tradeItem->onTradeEvent(ON_TRADE_CANCEL, tradePartner);
			tradePartner->tradeItem = nullptr;
		}

		tradePartner->setTradeState(TRADE_NONE);
		tradePartner->tradePartner = nullptr;

		tradePartner->sendTextMessage(MESSAGE_FAILURE, "Trade cancelled.");
		tradePartner->sendTradeClose();
	}
}

void Game::playerBuyItem(uint32_t playerId, uint16_t itemId, uint8_t count, uint8_t amount,
                              bool ignoreCap/* = false*/, bool inBackpacks/* = false*/)
{
	if (amount == 0 || amount > 100) {
		return;
	}

	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Npc* merchant = player->getShopOwner();
	if (!merchant) {
		return;
	}

	const ItemType& it = Item::items[itemId];
	if (it.id == 0) {
		return;
	}

	if (!player->hasShopItemForSale(it.id, count)) {
		return;
	}

	merchant->onPlayerBuyItem(player, it.id, count, amount, ignoreCap, inBackpacks);
}

void Game::playerSellItem(uint32_t playerId, uint16_t itemId, uint8_t count, uint8_t amount, bool ignoreEquipped)
{
	if (amount == 0 || amount > 100) {
		return;
	}

	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Npc* merchant = player->getShopOwner();
	if (!merchant) {
		return;
	}

	const ItemType& it = Item::items[itemId];
	if (it.id == 0) {
		return;
	}

	merchant->onPlayerSellItem(player, it.id, count, amount, ignoreEquipped);
}

void Game::playerCloseShop(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->closeShopWindow();
}

void Game::playerLookInShop(uint32_t playerId, uint16_t itemId, uint8_t count)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Npc* merchant = player->getShopOwner();
	if (!merchant) {
		return;
	}

	const ItemType& it = Item::items[itemId];
	if (it.id == 0) {
		return;
	}

	if (!g_events().eventPlayerOnLookInShop(player, &it, count)) {
		SPDLOG_ERROR("Game::playerLookInShop - Lua event callback is wrong");
		return;
	}

	std::ostringstream ss;
	ss << "You see " << Item::getDescription(it, 1, nullptr, count);
	player->sendTextMessage(MESSAGE_LOOK, ss.str());
	merchant->onPlayerCheckItem(player, it.id, count);
}

void Game::playerLookAt(uint32_t playerId, const Position& pos, uint8_t stackPos)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Thing* thing = internalGetThing(player, pos, stackPos, 0, STACKPOS_LOOK);
	if (!thing) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Position thingPos = thing->getPosition();
	if (!player->canSee(thingPos)) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Position playerPos = player->getPosition();

	int32_t lookDistance;
	if (thing != player) {
		lookDistance = std::max<int32_t>(Position::getDistanceX(playerPos, thingPos), Position::getDistanceY(playerPos, thingPos));
		if (playerPos.z != thingPos.z) {
			lookDistance += 15;
		}
	} else {
		lookDistance = -1;
	}

	// Parse onLook from event player
	g_events().eventPlayerOnLook(player, pos, thing, stackPos, lookDistance);
}

void Game::playerLookInBattleList(uint32_t playerId, uint32_t creatureId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Creature* creature = getCreatureByID(creatureId);
	if (!creature) {
		return;
	}

	if (!player->canSeeCreature(creature)) {
		return;
	}

	const Position& creaturePos = creature->getPosition();
	if (!player->canSee(creaturePos)) {
		return;
	}

	int32_t lookDistance;
	if (creature != player) {
		const Position& playerPos = player->getPosition();
		lookDistance = std::max<int32_t>(Position::getDistanceX(playerPos, creaturePos), Position::getDistanceY(playerPos, creaturePos));
		if (playerPos.z != creaturePos.z) {
			lookDistance += 15;
		}
	} else {
		lookDistance = -1;
	}

	g_events().eventPlayerOnLookInBattleList(player, creature, lookDistance);
}

void Game::playerQuickLoot(uint32_t playerId, const Position& pos, uint16_t itemId, uint8_t stackPos, Item* defaultItem, bool lootAllCorpses, bool autoLoot)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!player->canDoAction()) {
		uint32_t delay = player->getNextActionTime();
		SchedulerTask* task = createSchedulerTask(delay, std::bind(
                              &Game::playerQuickLoot,
                              this, player->getID(), pos,
                              itemId, stackPos, defaultItem, lootAllCorpses, autoLoot));
		player->setNextActionTask(task);
		return;
	}

	if (!autoLoot && pos.x != 0xffff) {
		if (!Position::areInRange<1, 1, 0>(pos, player->getPosition())) {
			//need to walk to the corpse first before looting it
			std::forward_list<Direction> listDir;
			if (player->getPathTo(pos, listDir, 0, 1, true, true)) {
				g_dispatcher().addTask(createTask(std::bind(&Game::playerAutoWalk, this, player->getID(), listDir)));
				SchedulerTask* task = createSchedulerTask(0, std::bind(
                                      &Game::playerQuickLoot,
                                      this, player->getID(), pos,
                                      itemId, stackPos, defaultItem, lootAllCorpses, autoLoot));
				player->setNextWalkActionTask(task);
			} else {
				player->sendCancelMessage(RETURNVALUE_THEREISNOWAY);
			}

			return;
		}
	} else if (!player->isPremium()) {
		player->sendCancelMessage("You must be premium.");
		return;
	}

	player->setNextActionTask(nullptr);

	Item* item = nullptr;
	if (!defaultItem) {
		Thing* thing = internalGetThing(player, pos, stackPos, itemId, STACKPOS_FIND_THING);
		if (!thing) {
			player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return;
		}

		item = thing->getItem();
	} else {
		item = defaultItem;
	}

	if (!item || !item->getParent()) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Container* corpse = nullptr;
	if (pos.x == 0xffff) {
		corpse = item->getParent()->getContainer();
		if (corpse && corpse->getID() == ITEM_BROWSEFIELD) {
			corpse = item->getContainer();
			browseField = true;
		}
	} else {
		corpse = item->getContainer();
	}

	if (!corpse || corpse->hasAttribute(ITEM_ATTRIBUTE_UNIQUEID) || corpse->hasAttribute(ITEM_ATTRIBUTE_ACTIONID)) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	if (!corpse->isRewardCorpse()) {
		uint32_t corpseOwner = corpse->getCorpseOwner();
		if (corpseOwner != 0 && !player->canOpenCorpse(corpseOwner)) {
			player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return;
		}
	}

	if (pos.x == 0xffff && !browseField) {
		uint32_t worth = item->getWorth();
		ObjectCategory_t category = getObjectCategory(item);
		ReturnValue ret = internalQuickLootItem(player, item, category);

		std::stringstream ss;
		if (ret == RETURNVALUE_NOTENOUGHCAPACITY) {
			ss << "Attention! The loot you are trying to pick up is too heavy for you to carry.";
		} else if (ret == RETURNVALUE_CONTAINERNOTENOUGHROOM) {
			ss << "Attention! The container for " << getObjectCategoryName(category) << " is full.";
		} else {
			if (ret == RETURNVALUE_NOERROR) {
				player->sendLootStats(item, item->getItemCount());
				ss << "You looted ";
			} else {
				ss << "You could not loot ";
			}

			if (worth != 0) {
				ss << worth << " gold.";
			} else {
				ss << "1 item.";
			}

			player->sendTextMessage(MESSAGE_LOOT, ss.str());
			return;
		}

		if (player->lastQuickLootNotification + 15000 < OTSYS_TIME()) {
			player->sendTextMessage(MESSAGE_GAME_HIGHLIGHT, ss.str());
		} else {
			player->sendTextMessage(MESSAGE_EVENT_ADVANCE, ss.str());
		}

		player->lastQuickLootNotification = OTSYS_TIME();
	} else {
		if (corpse->isRewardCorpse()) {
			g_actions().useItem(player, pos, 0, corpse, false);
		} else {
			if (!lootAllCorpses) {
				internalQuickLootCorpse(player, corpse);
			} else {
				playerLootAllCorpses(player, pos, lootAllCorpses);
			}
		}
	}

	return;
}

void Game::playerLootAllCorpses(Player* player, const Position& pos, bool lootAllCorpses) {
	if (lootAllCorpses) {
		Tile *tile = g_game().map.getTile(pos.x, pos.y, pos.z);
		if (!tile) {
			player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return;
		}

		const TileItemVector *itemVector = tile->getItemList();
		uint16_t corpses = 0;
		for (Item *tileItem: *itemVector) {
			if (!tileItem) {
				continue;
			}

			Container *tileCorpse = tileItem->getContainer();
			if (!tileCorpse || !tileCorpse->isCorpse() || tileCorpse->hasAttribute(ITEM_ATTRIBUTE_UNIQUEID) || tileCorpse->hasAttribute(ITEM_ATTRIBUTE_ACTIONID)) {
				continue;
			}

			if (!tileCorpse->isRewardCorpse()
			&& tileCorpse->getCorpseOwner() != 0
			&& !player->canOpenCorpse(tileCorpse->getCorpseOwner()))
			{
				player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
				SPDLOG_DEBUG("Player {} cannot loot corpse from id {} in position {}", player->getName(), tileItem->getID(), tileItem->getPosition());
				continue;
			}

			corpses++;
			internalQuickLootCorpse(player, tileCorpse);
			if (corpses >= 30) {
				break;
			}
		}

		if (corpses > 0) {
			if (corpses > 1) {
				std::stringstream string;
				string << "You looted " << corpses << " corpses.";
				player->sendTextMessage(MESSAGE_LOOT, string.str());
			}

			return;
		}
	}

	browseField = false;
}

void Game::playerSetLootContainer(uint32_t playerId, ObjectCategory_t category, const Position& pos, uint16_t itemId, uint8_t stackPos)
{
	Player* player = getPlayerByID(playerId);
	if (!player || pos.x != 0xffff) {
		return;
	}

	Thing* thing = internalGetThing(player, pos, stackPos, itemId, STACKPOS_USEITEM);
	if (!thing) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Container* container = thing->getContainer();
	if (!container || (container->getID() == ITEM_GOLD_POUCH && category != OBJECTCATEGORY_GOLD)) {
		player->sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	if (container->getHoldingPlayer() != player) {
		player->sendCancelMessage("You must be holding the container to set it as a loot container.");
		return;
	}

	Container* previousContainer = player->setLootContainer(category, container);
	player->sendLootContainers();

	Cylinder* parent = container->getParent();
	if (parent) {
		parent->updateThing(container, container->getID(), container->getItemCount());
	}

	if (previousContainer != nullptr) {
		parent = previousContainer->getParent();
		if (parent) {
			parent->updateThing(previousContainer, previousContainer->getID(), previousContainer->getItemCount());
		}
	}
}

void Game::playerClearLootContainer(uint32_t playerId, ObjectCategory_t category)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Container* previousContainer = player->setLootContainer(category, nullptr);
	player->sendLootContainers();

	if (previousContainer != nullptr) {
		Cylinder* parent = previousContainer->getParent();
		if (parent) {
			parent->updateThing(previousContainer, previousContainer->getID(), previousContainer->getItemCount());
		}
	}
}

void Game::playerOpenLootContainer(uint32_t playerId, ObjectCategory_t category)
{
  Player* player = getPlayerByID(playerId);
  if (!player) {
    return;
  }

  Container* container = player->getLootContainer(category);
  if (!container) {
    return;
  }

  player->sendContainer(static_cast<uint8_t>(container->getID()), container, container->hasParent(), 0);
}


void Game::playerSetQuickLootFallback(uint32_t playerId, bool fallback)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->quickLootFallbackToMainContainer = fallback;
}

void Game::playerQuickLootBlackWhitelist(uint32_t playerId, QuickLootFilter_t filter, const std::vector<uint16_t> itemIds)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->quickLootFilter = filter;
	player->quickLootListItemIds = itemIds;
}

void Game::playerRequestLockFind(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	std::map<uint16_t, uint16_t> itemMap;
	uint16_t count = 0;
	DepotLocker* depotLocker = player->getDepotLocker(player->getLastDepotId());
	if (!depotLocker) {
		return;
	}

	for (Item* locker : depotLocker->getItemList()) {
		Container* c = locker->getContainer();
		if (c && c->empty()) {
			continue;
		}

		if (c) {
			for (ContainerIterator it = c->iterator(); it.hasNext(); it.advance()) {
				auto itt = itemMap.find((*it)->getID());
				if (itt == itemMap.end()) {
					itemMap[(*it)->getID()] = Item::countByType((*it), -1);
					count++;
				} else {
					itemMap[(*it)->getID()] += Item::countByType((*it), -1);
				}
			}
		}
	}

	player->sendLockerItems(itemMap, count);
	return;
}

void Game::playerCancelAttackAndFollow(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	playerSetAttackedCreature(playerId, 0);
	playerFollowCreature(playerId, 0);
	player->stopWalk();
}

void Game::playerSetAttackedCreature(uint32_t playerId, uint32_t creatureId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (player->getAttackedCreature() && creatureId == 0) {
		player->setAttackedCreature(nullptr);
		player->sendCancelTarget();
		return;
	}

	Creature* attackCreature = getCreatureByID(creatureId);
	if (!attackCreature) {
		player->setAttackedCreature(nullptr);
		player->sendCancelTarget();
		return;
	}

	ReturnValue ret = Combat::canTargetCreature(player, attackCreature);
	if (ret != RETURNVALUE_NOERROR) {
		player->sendCancelMessage(ret);
		player->sendCancelTarget();
		player->setAttackedCreature(nullptr);
		return;
	}

	player->setAttackedCreature(attackCreature);
	g_dispatcher().addTask(createTask(std::bind(&Game::updateCreatureWalk, this, player->getID())));
}

void Game::playerFollowCreature(uint32_t playerId, uint32_t creatureId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->setAttackedCreature(nullptr);
	g_dispatcher().addTask(createTask(std::bind(&Game::updateCreatureWalk, this, player->getID())));
	player->setFollowCreature(getCreatureByID(creatureId));
}

void Game::playerSetFightModes(uint32_t playerId, FightMode_t fightMode, bool chaseMode, bool secureMode)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->setFightMode(fightMode);
	player->setChaseMode(chaseMode);
	player->setSecureMode(secureMode);
}

void Game::playerRequestAddVip(uint32_t playerId, const std::string& name)
{
	if (name.length() > 25) {
		return;
	}

	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Player* vipPlayer = getPlayerByName(name);
	if (!vipPlayer) {
		uint32_t guid;
		bool specialVip;
		std::string formattedName = name;
		if (!IOLoginData::getGuidByNameEx(guid, specialVip, formattedName)) {
			player->sendTextMessage(MESSAGE_FAILURE, "A player with this name does not exist.");
			return;
		}

		if (specialVip && !player->hasFlag(PlayerFlag_SpecialVIP)) {
			player->sendTextMessage(MESSAGE_FAILURE, "You can not add this player.");
			return;
		}

		player->addVIP(guid, formattedName, VIPSTATUS_OFFLINE);
	} else {
		if (vipPlayer->hasFlag(PlayerFlag_SpecialVIP) && !player->hasFlag(PlayerFlag_SpecialVIP)) {
			player->sendTextMessage(MESSAGE_FAILURE, "You can not add this player.");
			return;
		}

		if (!vipPlayer->isInGhostMode() || player->isAccessPlayer()) {
			player->addVIP(vipPlayer->getGUID(), vipPlayer->getName(), vipPlayer->statusVipList);
		} else {
			player->addVIP(vipPlayer->getGUID(), vipPlayer->getName(), VIPSTATUS_OFFLINE);
		}
	}
}

void Game::playerRequestRemoveVip(uint32_t playerId, uint32_t guid)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->removeVIP(guid);
}

void Game::playerRequestEditVip(uint32_t playerId, uint32_t guid, const std::string& description, uint32_t icon, bool notify)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->editVIP(guid, description, icon, notify);
}

void Game::playerApplyImbuement(uint32_t playerId, uint16_t imbuementid, uint8_t slot, bool protectionCharm)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!player->hasImbuingItem()) {
		return;
	}

	Imbuement* imbuement = g_imbuements().getImbuement(imbuementid);
	if (!imbuement) {
		return;
	}

	Item* item = player->imbuingItem;
	if (!item) {
		return;
	}

	if (item->getTopParent() != player) {
		SPDLOG_ERROR("[Game::playerApplyImbuement] - An error occurred while player with name {} try to apply imbuement", player->getName());
		player->sendImbuementResult("An error has occurred, reopen the imbuement window. If the problem persists, contact your administrator.");
		return;
	}

	player->onApplyImbuement(imbuement, item, slot, protectionCharm);
}

void Game::playerClearImbuement(uint32_t playerid, uint8_t slot)
{
	Player* player = getPlayerByID(playerid);
	if (!player)
	{
		return;
	}

	if (!player->hasImbuingItem ())
	{
		return;
	}

	Item* item = player->imbuingItem;
	if (!item)
	{
		return;
	}

	player->onClearImbuement(item, slot);
}

void Game::playerCloseImbuementWindow(uint32_t playerid)
{
	Player* player = getPlayerByID(playerid);
	if (!player)
	{
		return;
	}

	player->setImbuingItem(nullptr);
	return;
}

void Game::playerTurn(uint32_t playerId, Direction dir)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!g_events().eventPlayerOnTurn(player, dir)) {
		return;
	}

	player->resetIdleTime();
	internalCreatureTurn(player, dir);
}

void Game::playerRequestOutfit(uint32_t playerId)
{
	if (!g_configManager().getBoolean(ALLOW_CHANGEOUTFIT)) {
		return;
	}

	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->sendOutfitWindow();
}

void Game::playerToggleMount(uint32_t playerId, bool mount)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->toggleMount(mount);
}

void Game::playerChangeOutfit(uint32_t playerId, Outfit_t outfit)
{
	if (!g_configManager().getBoolean(ALLOW_CHANGEOUTFIT)) {
		return;
	}

	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	const Outfit* playerOutfit = Outfits::getInstance().getOutfitByLookType(player->getSex(), outfit.lookType);
	if (!playerOutfit) {
		outfit.lookMount = 0;
	}

	if (outfit.lookMount != 0) {
		Mount* mount = mounts.getMountByClientID(outfit.lookMount);
		if (!mount) {
			return;
		}

		if (!player->hasMount(mount)) {
			return;
		}

		if (player->isMounted()) {
			Mount* prevMount = mounts.getMountByID(player->getCurrentMount());
			if (prevMount) {
				changeSpeed(player, mount->speed - prevMount->speed);
			}

			player->setCurrentMount(mount->id);
		} else {
			player->setCurrentMount(mount->id);
			outfit.lookMount = 0;
		}
	} else if (player->isMounted()) {
		player->dismount();
	}

	if (player->canWear(outfit.lookType, outfit.lookAddons)) {
		player->defaultOutfit = outfit;

		if (player->hasCondition(CONDITION_OUTFIT)) {
			return;
		}

		internalCreatureChangeOutfit(player, outfit);
	}
}

void Game::playerShowQuestLog(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	g_events().eventPlayerOnRequestQuestLog(player);
}

void Game::playerShowQuestLine(uint32_t playerId, uint16_t questId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	g_events().eventPlayerOnRequestQuestLine(player, questId);
}

void Game::playerSay(uint32_t playerId, uint16_t channelId, SpeakClasses type,
                    const std::string& receiver, const std::string& text)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->resetIdleTime();

	if (playerSaySpell(player, type, text)) {
		return;
	}

	uint32_t muteTime = player->isMuted();
	if (muteTime > 0) {
		std::ostringstream ss;
		ss << "You are still muted for " << muteTime << " seconds.";
		player->sendTextMessage(MESSAGE_FAILURE, ss.str());
		return;
	}


	if (!text.empty() && text.front() == '/' && player->isAccessPlayer()) {
		return;
	}

	if (type != TALKTYPE_PRIVATE_PN) {
		player->removeMessageBuffer();
	}

	switch (type) {
		case TALKTYPE_SAY:
			internalCreatureSay(player, TALKTYPE_SAY, text, false);
			break;

		case TALKTYPE_WHISPER:
			playerWhisper(player, text);
			break;

		case TALKTYPE_YELL:
			playerYell(player, text);
			break;

		case TALKTYPE_PRIVATE_TO:
		case TALKTYPE_PRIVATE_RED_TO:
			playerSpeakTo(player, type, receiver, text);
			break;

		case TALKTYPE_CHANNEL_O:
		case TALKTYPE_CHANNEL_Y:
		case TALKTYPE_CHANNEL_R1:
			g_chat().talkToChannel(*player, type, text, channelId);
			break;

		case TALKTYPE_PRIVATE_PN:
			playerSpeakToNpc(player, text);
			break;

		case TALKTYPE_BROADCAST:
			playerBroadcastMessage(player, text);
			break;

		default:
			break;
	}
}

bool Game::playerSaySpell(Player* player, SpeakClasses type, const std::string& text)
{
	if (player->walkExhausted()) {
		return true;
	}

	std::string words = text;
	TalkActionResult_t result = g_talkActions().playerSaySpell(player, type, words);
	if (result == TALKACTION_BREAK) {
		return true;
	}

	result = g_spells().playerSaySpell(player, words);
	if (result == TALKACTION_BREAK) {
		if (!g_configManager().getBoolean(PUSH_WHEN_ATTACKING)) {
			player->cancelPush();
		}

		if (!g_configManager().getBoolean(EMOTE_SPELLS)) {
			return internalCreatureSay(player, TALKTYPE_SPELL_USE, words, false);
		} else {
			return internalCreatureSay(player, TALKTYPE_MONSTER_SAY, words, false);
		}

	} else if (result == TALKACTION_FAILED) {
		return true;
	}

	return false;
}

void Game::playerWhisper(Player* player, const std::string& text)
{
	SpectatorHashSet spectators;
	map.getSpectators(spectators, player->getPosition(), false, false,
                 Map::maxClientViewportX, Map::maxClientViewportX,
                 Map::maxClientViewportY, Map::maxClientViewportY);

	//send to client
	for (Creature* spectator : spectators) {
		if (Player* spectatorPlayer = spectator->getPlayer()) {
			if (!Position::areInRange<1, 1>(player->getPosition(), spectatorPlayer->getPosition())) {
				spectatorPlayer->sendCreatureSay(player, TALKTYPE_WHISPER, "pspsps");
			} else {
				spectatorPlayer->sendCreatureSay(player, TALKTYPE_WHISPER, text);
			}
		}
	}

	//event method
	for (Creature* spectator : spectators) {
		spectator->onCreatureSay(player, TALKTYPE_WHISPER, text);
	}
}

bool Game::playerYell(Player* player, const std::string& text)
{
	if (player->getLevel() == 1) {
		player->sendTextMessage(MESSAGE_FAILURE, "You may not yell as long as you are on level 1.");
		return false;
	}

	if (player->hasCondition(CONDITION_YELLTICKS)) {
		player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
		return false;
	}

	if (player->getAccountType() < account::AccountType::ACCOUNT_TYPE_GAMEMASTER) {
		Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_YELLTICKS, 30000, 0);
		player->addCondition(condition);
	}

	internalCreatureSay(player, TALKTYPE_YELL, asUpperCaseString(text), false);
	return true;
}

bool Game::playerSpeakTo(Player* player, SpeakClasses type, const std::string& receiver,
                         const std::string& text)
{
	Player* toPlayer = getPlayerByName(receiver);
	if (!toPlayer) {
		player->sendTextMessage(MESSAGE_FAILURE, "A player with this name is not online.");
		return false;
	}

	if (type == TALKTYPE_PRIVATE_RED_TO && (player->hasFlag(PlayerFlag_CanTalkRedPrivate) || player->getAccountType() >= account::AccountType::ACCOUNT_TYPE_GAMEMASTER)) {
		type = TALKTYPE_PRIVATE_RED_FROM;
	} else {
		type = TALKTYPE_PRIVATE_FROM;
	}

	toPlayer->sendPrivateMessage(player, type, text);
	toPlayer->onCreatureSay(player, type, text);

	if (toPlayer->isInGhostMode() && !player->isAccessPlayer()) {
		player->sendTextMessage(MESSAGE_FAILURE, "A player with this name is not online.");
	} else {
		std::ostringstream ss;
		ss << "Message sent to " << toPlayer->getName() << '.';
		player->sendTextMessage(MESSAGE_FAILURE, ss.str());
	}
	return true;
}

void Game::playerSpeakToNpc(Player* player, const std::string& text)
{
	SpectatorHashSet spectators;
	map.getSpectators(spectators, player->getPosition());
	for (Creature* spectator : spectators) {
		if (spectator->getNpc()) {
			spectator->onCreatureSay(player, TALKTYPE_PRIVATE_PN, text);
		}
	}
}

//--
bool Game::canThrowObjectTo(const Position& fromPos, const Position& toPos, bool checkLineOfSight /*= true*/,
							int32_t rangex /*= Map::maxClientViewportX*/, int32_t rangey /*= Map::maxClientViewportY*/) const
{
	return map.canThrowObjectTo(fromPos, toPos, checkLineOfSight, rangex, rangey);
}

bool Game::isSightClear(const Position& fromPos, const Position& toPos, bool floorCheck) const
{
	return map.isSightClear(fromPos, toPos, floorCheck);
}

bool Game::internalCreatureTurn(Creature* creature, Direction dir)
{
	if (creature->getDirection() == dir) {
		return false;
	}

	if (Player* player = creature->getPlayer()) {
		player->cancelPush();
	}
	creature->setDirection(dir);

	// Send to client
	SpectatorHashSet spectators;
	map.getSpectators(spectators, creature->getPosition(), true, true);
	for (Creature* spectator : spectators) {
		Player* tmpPlayer = spectator->getPlayer();
		if(!tmpPlayer) {
			continue;
		}
		tmpPlayer->sendCreatureTurn(creature);
	}
	return true;
}

bool Game::internalCreatureSay(Creature* creature, SpeakClasses type, const std::string& text,
                               bool ghostMode, SpectatorHashSet* spectatorsPtr/* = nullptr*/, const Position* pos/* = nullptr*/)
{
	if (text.empty()) {
		return false;
	}

	if (!pos) {
		pos = &creature->getPosition();
	}

	SpectatorHashSet spectators;

	if (!spectatorsPtr || spectatorsPtr->empty()) {
		// This somewhat complex construct ensures that the cached SpectatorHashSet
		// is used if available and if it can be used, else a local vector is
		// used (hopefully the compiler will optimize away the construction of
		// the temporary when it's not used).
		if (type != TALKTYPE_YELL && type != TALKTYPE_MONSTER_YELL) {
			map.getSpectators(spectators, *pos, false, false,
                           Map::maxClientViewportX, Map::maxClientViewportX,
                           Map::maxClientViewportY, Map::maxClientViewportY);
		} else {
			map.getSpectators(spectators, *pos, true, false, 18, 18, 14, 14);
		}
	} else {
		spectators = (*spectatorsPtr);
	}

	//send to client
	for (Creature* spectator : spectators) {
		if (Player* tmpPlayer = spectator->getPlayer()) {
			if (!ghostMode || tmpPlayer->canSeeCreature(creature)) {
				tmpPlayer->sendCreatureSay(creature, type, text, pos);
			}
		}
	}

	//event method
	for (Creature* spectator : spectators) {
		spectator->onCreatureSay(creature, type, text);
		if (creature != spectator) {
			g_events().eventCreatureOnHear(spectator, creature, text, type);
		}
	}
	return true;
}

void Game::checkCreatureWalk(uint32_t creatureId)
{
	Creature* creature = getCreatureByID(creatureId);
	if (creature && creature->getHealth() > 0) {
		creature->onCreatureWalk();
		cleanup();
	}
}

void Game::updateCreatureWalk(uint32_t creatureId)
{
	Creature* creature = getCreatureByID(creatureId);
	if (creature && creature->getHealth() > 0) {
		creature->goToFollowCreature();
	}
}

void Game::checkCreatureAttack(uint32_t creatureId)
{
	Creature* creature = getCreatureByID(creatureId);
	if (creature && creature->getHealth() > 0) {
		creature->onAttacking(0);
	}
}

void Game::addCreatureCheck(Creature* creature)
{
	creature->creatureCheck = true;

	if (creature->inCheckCreaturesVector) {
		// already in a vector
		return;
	}

	creature->inCheckCreaturesVector = true;
	checkCreatureLists[uniform_random(0, EVENT_CREATURECOUNT - 1)].push_back(creature);
	creature->incrementReferenceCounter();
}

void Game::removeCreatureCheck(Creature* creature)
{
	if (creature->inCheckCreaturesVector) {
		creature->creatureCheck = false;
	}
}

void Game::checkCreatures(size_t index)
{
	g_scheduler().addEvent(createSchedulerTask(EVENT_CHECK_CREATURE_INTERVAL, std::bind(&Game::checkCreatures, this, (index + 1) % EVENT_CREATURECOUNT)));

	auto& checkCreatureList = checkCreatureLists[index];
	size_t it = 0, end = checkCreatureList.size();
	while (it < end) {
		Creature* creature = checkCreatureList[it];
		if (creature && creature->creatureCheck) {
			if (creature->getHealth() > 0) {
				creature->onThink(EVENT_CREATURE_THINK_INTERVAL);
				creature->onAttacking(EVENT_CREATURE_THINK_INTERVAL);
				creature->executeConditions(EVENT_CREATURE_THINK_INTERVAL);
			} else {
				creature->onDeath();
			}
			++it;
		} else {
			creature->inCheckCreaturesVector = false;
			ReleaseCreature(creature);

			checkCreatureList[it] = checkCreatureList.back();
			checkCreatureList.pop_back();
			--end;
		}
	}
	cleanup();
}

void Game::changeSpeed(Creature* creature, int32_t varSpeedDelta)
{
	int32_t varSpeed = creature->getSpeed() - creature->getBaseSpeed();
	varSpeed += varSpeedDelta;

	creature->setSpeed(varSpeed);

	//send to clients
	SpectatorHashSet spectators;
	map.getSpectators(spectators, creature->getPosition(), false, true);
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->sendChangeSpeed(creature, creature->getStepSpeed());
	}
}

void Game::internalCreatureChangeOutfit(Creature* creature, const Outfit_t& outfit)
{
	if (!g_events().eventCreatureOnChangeOutfit(creature, outfit)) {
		return;
	}

	creature->setCurrentOutfit(outfit);

	if (creature->isInvisible()) {
		return;
	}

	//send to clients
	SpectatorHashSet spectators;
	map.getSpectators(spectators, creature->getPosition(), true, true);
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->sendCreatureChangeOutfit(creature, outfit);
	}
}

void Game::internalCreatureChangeVisible(Creature* creature, bool visible)
{
	//send to clients
	SpectatorHashSet spectators;
	map.getSpectators(spectators, creature->getPosition(), true, true);
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->sendCreatureChangeVisible(creature, visible);
	}
}

void Game::changeLight(const Creature* creature)
{
	//send to clients
	SpectatorHashSet spectators;
	map.getSpectators(spectators, creature->getPosition(), true, true);
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->sendCreatureLight(creature);
	}
}

void Game::updateCreatureIcon(const Creature* creature)
{
	//send to clients
	SpectatorHashSet spectators;
	map.getSpectators(spectators, creature->getPosition(), true, true);
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->sendCreatureIcon(creature);
	}
}

bool Game::combatBlockHit(CombatDamage& damage, Creature* attacker, Creature* target, bool checkDefense, bool checkArmor, bool field)
{
	if (damage.primary.type == COMBAT_NONE && damage.secondary.type == COMBAT_NONE) {
		return true;
	}

	if (target->getPlayer() && target->isInGhostMode()) {
		return true;
	}

	if (damage.primary.value > 0) {
		return false;
	}

	static const auto sendBlockEffect = [this](BlockType_t blockType, CombatType_t combatType, const Position& targetPos) {
		if (blockType == BLOCK_DEFENSE) {
			addMagicEffect(targetPos, CONST_ME_POFF);
		} else if (blockType == BLOCK_ARMOR) {
			addMagicEffect(targetPos, CONST_ME_BLOCKHIT);
		} else if (blockType == BLOCK_IMMUNITY) {
			uint8_t hitEffect = 0;
			switch (combatType) {
				case COMBAT_UNDEFINEDDAMAGE: {
					return;
				}
				case COMBAT_ENERGYDAMAGE:
				case COMBAT_FIREDAMAGE:
				case COMBAT_PHYSICALDAMAGE:
				case COMBAT_ICEDAMAGE:
				case COMBAT_DEATHDAMAGE: {
					hitEffect = CONST_ME_BLOCKHIT;
					break;
				}
				case COMBAT_EARTHDAMAGE: {
					hitEffect = CONST_ME_GREEN_RINGS;
					break;
				}
				case COMBAT_HOLYDAMAGE: {
					hitEffect = CONST_ME_HOLYDAMAGE;
					break;
				}
				default: {
					hitEffect = CONST_ME_POFF;
					break;
				}
			}
			addMagicEffect(targetPos, hitEffect);
		}
	};

	bool canHeal = false;
		CombatDamage damageHeal;
		damageHeal.primary.type = COMBAT_HEALING;

	bool canReflect = false;
		CombatDamage damageReflected;

	BlockType_t primaryBlockType, secondaryBlockType;
	if (damage.primary.type != COMBAT_NONE) {
		// Damage reflection primary
		if (attacker && target->getMonster()) {
			uint32_t primaryReflect = target->getMonster()->getReflectValue(damage.primary.type);
			if (primaryReflect > 0) {
				damageReflected.primary.type = damage.primary.type;
				damageReflected.primary.value = std::ceil((damage.primary.value) * (primaryReflect / 100.));
				damageReflected.extension = true;
				damageReflected.exString = "(damage reflection)";
				canReflect = true;
			}
		}
		damage.primary.value = -damage.primary.value;
		// Damage healing primary
		if (attacker && target->getMonster()) {
			uint32_t primaryHealing = target->getMonster()->getHealingCombatValue(damage.primary.type);
			if (primaryHealing > 0) {
				damageHeal.primary.value = std::ceil((damage.primary.value) * (primaryHealing / 100.));
				canHeal = true;
			}
		}
		primaryBlockType = target->blockHit(attacker, damage.primary.type, damage.primary.value, checkDefense, checkArmor, field);

		damage.primary.value = -damage.primary.value;
		sendBlockEffect(primaryBlockType, damage.primary.type, target->getPosition());
	} else {
		primaryBlockType = BLOCK_NONE;
	}

	if (damage.secondary.type != COMBAT_NONE) {
		// Damage reflection secondary
		if (attacker && target->getMonster()) {
			uint32_t secondaryReflect = target->getMonster()->getReflectValue(damage.secondary.type);
			if (secondaryReflect > 0) {
				if (!canReflect) {
					damageReflected.primary.type = damage.secondary.type;
					damageReflected.primary.value = std::ceil((damage.secondary.value) * (secondaryReflect / 100.));
					damageReflected.extension = true;
					damageReflected.exString = "(damage reflection)";
					canReflect = true;
				} else {
					damageReflected.secondary.type = damage.secondary.type;
					damageReflected.secondary.value = std::ceil((damage.secondary.value) * (secondaryReflect / 100.));
				}
			}
		}
		damage.secondary.value = -damage.secondary.value;
		// Damage healing secondary
		if (attacker && target->getMonster()) {
			uint32_t secondaryHealing = target->getMonster()->getHealingCombatValue(damage.secondary.type);
			if (secondaryHealing > 0) {;
				damageHeal.primary.value += std::ceil((damage.secondary.value) * (secondaryHealing / 100.));
				canHeal = true;
			}
		}
		secondaryBlockType = target->blockHit(attacker, damage.secondary.type, damage.secondary.value, false, false, field);

		damage.secondary.value = -damage.secondary.value;
		sendBlockEffect(secondaryBlockType, damage.secondary.type, target->getPosition());
	} else {
		secondaryBlockType = BLOCK_NONE;
	}
	if (canReflect) {
		combatChangeHealth(target, attacker, damageReflected, false);
	}
	if (canHeal) {
		combatChangeHealth(nullptr, target, damageHeal);
	}
	return (primaryBlockType != BLOCK_NONE) && (secondaryBlockType != BLOCK_NONE);
}

void Game::combatGetTypeInfo(CombatType_t combatType, Creature* target, TextColor_t& color, uint8_t& effect)
{
	switch (combatType) {
		case COMBAT_PHYSICALDAMAGE: {
			Item* splash = nullptr;
			switch (target->getRace()) {
				case RACE_VENOM:
					color = TEXTCOLOR_LIGHTGREEN;
					effect = CONST_ME_HITBYPOISON;
					splash = Item::CreateItem(ITEM_SMALLSPLASH, FLUID_SLIME);
					break;
				case RACE_BLOOD:
					color = TEXTCOLOR_RED;
					effect = CONST_ME_DRAWBLOOD;
					if (const Tile* tile = target->getTile()) {
						if (!tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
							splash = Item::CreateItem(ITEM_SMALLSPLASH, FLUID_BLOOD);
						}
					}
					break;
				case RACE_INK:
					color = TEXTCOLOR_LIGHTGREY;
					effect = CONST_ME_HITAREA;
					splash = Item::CreateItem(ITEM_SMALLSPLASH, FLUID_INK);
					break;
				case RACE_UNDEAD:
					color = TEXTCOLOR_LIGHTGREY;
					effect = CONST_ME_HITAREA;
					break;
				case RACE_FIRE:
					color = TEXTCOLOR_ORANGE;
					effect = CONST_ME_DRAWBLOOD;
					break;
				case RACE_ENERGY:
					color = TEXTCOLOR_PURPLE;
					effect = CONST_ME_ENERGYHIT;
					break;
				default:
					color = TEXTCOLOR_NONE;
					effect = CONST_ME_NONE;
					break;
			}

			if (splash) {
				internalAddItem(target->getTile(), splash, INDEX_WHEREEVER, FLAG_NOLIMIT);
				splash->startDecaying();
			}

			break;
		}

		case COMBAT_ENERGYDAMAGE: {
			color = TEXTCOLOR_PURPLE;
			effect = CONST_ME_ENERGYHIT;
			break;
		}

		case COMBAT_EARTHDAMAGE: {
			color = TEXTCOLOR_LIGHTGREEN;
			effect = CONST_ME_GREEN_RINGS;
			break;
		}

		case COMBAT_DROWNDAMAGE: {
			color = TEXTCOLOR_LIGHTBLUE;
			effect = CONST_ME_LOSEENERGY;
			break;
		}
		case COMBAT_FIREDAMAGE: {
			color = TEXTCOLOR_ORANGE;
			effect = CONST_ME_HITBYFIRE;
			break;
		}
		case COMBAT_ICEDAMAGE: {
			color = TEXTCOLOR_SKYBLUE;
			effect = CONST_ME_ICEATTACK;
			break;
		}
		case COMBAT_HOLYDAMAGE: {
			color = TEXTCOLOR_YELLOW;
			effect = CONST_ME_HOLYDAMAGE;
			break;
		}
		case COMBAT_DEATHDAMAGE: {
			color = TEXTCOLOR_DARKRED;
			effect = CONST_ME_SMALLCLOUDS;
			break;
		}
		case COMBAT_LIFEDRAIN: {
			color = TEXTCOLOR_RED;
			effect = CONST_ME_MAGIC_RED;
			break;
		}
		default: {
			color = TEXTCOLOR_NONE;
			effect = CONST_ME_NONE;
			break;
		}
	}
}

bool Game::combatChangeHealth(Creature* attacker, Creature* target, CombatDamage& damage, bool isEvent /*= false*/)
{
	using namespace std;
	const Position& targetPos = target->getPosition();
	if (damage.primary.value > 0) {
		if (target->getHealth() <= 0) {
			return false;
		}

		Player* attackerPlayer;
		if (attacker) {
			attackerPlayer = attacker->getPlayer();
		} else {
			attackerPlayer = nullptr;
		}

		Player* targetPlayer = target->getPlayer();
		if (attackerPlayer && targetPlayer && attackerPlayer->getSkull() == SKULL_BLACK && attackerPlayer->getSkullClient(targetPlayer) == SKULL_NONE) {
			return false;
		}

		if (damage.origin != ORIGIN_NONE) {
			const auto& events = target->getCreatureEvents(CREATURE_EVENT_HEALTHCHANGE);
			if (!events.empty()) {
				for (CreatureEvent* creatureEvent : events) {
					creatureEvent->executeHealthChange(target, attacker, damage);
				}
				damage.origin = ORIGIN_NONE;
				return combatChangeHealth(attacker, target, damage);
			}
		}

		int32_t realHealthChange = target->getHealth();
		target->gainHealth(attacker, damage.primary.value);
		realHealthChange = target->getHealth() - realHealthChange;

		if (realHealthChange > 0 && !target->isInGhostMode()) {
			if (targetPlayer) {
				targetPlayer->updateImpactTracker(COMBAT_HEALING, realHealthChange);
			}

			// Party hunt analyzer
			if (Party* party = attackerPlayer ? attackerPlayer->getParty() : nullptr) {
				party->addPlayerHealing(attackerPlayer, realHealthChange);
			}

			std::stringstream ss;

			ss << realHealthChange << (realHealthChange != 1 ? " hitpoints." : " hitpoint.");
			std::string damageString = ss.str();

			std::string spectatorMessage;

			TextMessage message;
			message.position = targetPos;
			message.primary.value = realHealthChange;
			message.primary.color = TEXTCOLOR_PASTELRED;

			SpectatorHashSet spectators;
			map.getSpectators(spectators, targetPos, false, true);
			for (Creature* spectator : spectators) {
				Player* tmpPlayer = spectator->getPlayer();

				if(!tmpPlayer)
				{
					continue;
				}
				
				if (tmpPlayer == attackerPlayer && attackerPlayer != targetPlayer) {
					ss.str({});
					ss << "You heal " << target->getNameDescription() << " for " << damageString;
					message.type = MESSAGE_HEALED;
					message.text = ss.str();
				} else if (tmpPlayer == targetPlayer) {
					ss.str({});
					if (!attacker) {
						ss << "You were healed";
					} else if (targetPlayer == attackerPlayer) {
						ss << "You heal yourself";
					} else {
						ss << "You were healed by " << attacker->getNameDescription();
					}
					ss << " for " << damageString;
					message.type = MESSAGE_HEALED;
					message.text = ss.str();
				} else {
					if (spectatorMessage.empty()) {
						ss.str({});
						if (!attacker) {
							ss << ucfirst(target->getNameDescription()) << " was healed";
						} else {
							ss << ucfirst(attacker->getNameDescription()) << " healed ";
							if (attacker == target) {
								ss << (targetPlayer ? (targetPlayer->getSex() == PLAYERSEX_FEMALE ? "herself" : "himself") : "itself");
							} else {
								ss << target->getNameDescription();
							}
						}
						ss << " for " << damageString;
						spectatorMessage = ss.str();
					}
					message.type = MESSAGE_HEALED_OTHERS;
					message.text = spectatorMessage;
				}
				tmpPlayer->sendTextMessage(message);
			}
		}
	} else {
		if (!target->isAttackable()) {
			if (!target->isInGhostMode()) {
				addMagicEffect(targetPos, CONST_ME_POFF);
			}
			return true;
		}

		Player* attackerPlayer;
		if (attacker) {
			attackerPlayer = attacker->getPlayer();
		} else {
			attackerPlayer = nullptr;
		}

		Player* targetPlayer = target->getPlayer();
		if (attackerPlayer && targetPlayer && attackerPlayer->getSkull() == SKULL_BLACK && attackerPlayer->getSkullClient(targetPlayer) == SKULL_NONE) {
			return false;
		}

		damage.primary.value = std::abs(damage.primary.value);
		damage.secondary.value = std::abs(damage.secondary.value);

		Monster* targetMonster;
		if (target && target->getMonster()) {
			targetMonster = target->getMonster();
		} else {
			targetMonster = nullptr;
		}

		const Monster* attackerMonster;
		if (attacker && attacker->getMonster()) {
			attackerMonster = attacker->getMonster();
		} else {
			attackerMonster = nullptr;
		}

		if (attackerPlayer && targetMonster) {
			const PreySlot* slot = attackerPlayer->getPreyWithMonster(targetMonster->getRaceId());
			if (slot && slot->isOccupied() && slot->bonus == PreyBonus_Damage && slot->bonusTimeLeft > 0) {
				damage.primary.value += static_cast<int32_t>(std::ceil((damage.primary.value * slot->bonusPercentage) / 100));
				damage.secondary.value += static_cast<int32_t>(std::ceil((damage.secondary.value * slot->bonusPercentage) / 100));
			}
		} else if (attackerMonster && targetPlayer) {
			const PreySlot* slot = targetPlayer->getPreyWithMonster(attackerMonster->getRaceId());
			if (slot && slot->isOccupied() && slot->bonus == PreyBonus_Defense && slot->bonusTimeLeft > 0) {
				damage.primary.value -= static_cast<int32_t>(std::ceil((damage.primary.value * slot->bonusPercentage) / 100));
				damage.secondary.value -= static_cast<int32_t>(std::ceil((damage.secondary.value * slot->bonusPercentage) / 100));
			}
		}

		TextMessage message;
		message.position = targetPos;

		if (!isEvent) {
			g_events().eventCreatureOnDrainHealth(target, attacker, damage.primary.type, damage.primary.value, damage.secondary.type, damage.secondary.value, message.primary.color, message.secondary.color);
		}
		if (damage.origin != ORIGIN_NONE && attacker && damage.primary.type != COMBAT_HEALING) {
			damage.primary.value *= attacker->getBuff(BUFF_DAMAGEDEALT) / 100.;
			damage.secondary.value *= attacker->getBuff(BUFF_DAMAGEDEALT) / 100.;
		}
		if (damage.origin != ORIGIN_NONE && target && damage.primary.type != COMBAT_HEALING) {
			damage.primary.value *= target->getBuff(BUFF_DAMAGERECEIVED) / 100.;
			damage.secondary.value *= target->getBuff(BUFF_DAMAGERECEIVED) / 100.;
		}
		int32_t healthChange = damage.primary.value + damage.secondary.value;
		if (healthChange == 0) {
			return true;
		}

		SpectatorHashSet spectators;
		map.getSpectators(spectators, targetPos, true, true);

		if (damage.critical) {
			addMagicEffect(spectators, targetPos, CONST_ME_CRITICAL_DAMAGE);
		}

		if (!damage.extension && attackerMonster && targetPlayer) {
			// Charm rune (target as player)
			if (charmRune_t activeCharm = g_iobestiary().getCharmFromTarget(targetPlayer, g_monsters().getMonsterTypeByRaceId(attackerMonster->getRaceId()));
				activeCharm != CHARM_NONE && activeCharm != CHARM_CLEANSE) {
				if (Charm* charm = g_iobestiary().getBestiaryCharm(activeCharm);
					charm->type == CHARM_DEFENSIVE && charm->chance > normal_random(0, 100) && 
					g_iobestiary().parseCharmCombat(charm, targetPlayer, attacker, (damage.primary.value + damage.secondary.value))) {
					return false; // Dodge charm
				}
			}
		}

		if (target->hasCondition(CONDITION_MANASHIELD) && damage.primary.type != COMBAT_UNDEFINEDDAMAGE) {
			int32_t manaDamage = std::min<int32_t>(target->getMana(), healthChange);
			uint16_t manaShield = target->getManaShield();
			if (manaShield > 0) {
				if (manaShield > manaDamage) {
					target->setManaShield(manaShield - manaDamage);
					manaShield = manaShield - manaDamage;
				} else {
					manaDamage = manaShield;
					target->removeCondition(CONDITION_MANASHIELD);
					manaShield  = 0;
				}
			}
			if (manaDamage != 0) {
				if (damage.origin != ORIGIN_NONE) {
					const auto& events = target->getCreatureEvents(CREATURE_EVENT_MANACHANGE);
					if (!events.empty()) {
						for (CreatureEvent* creatureEvent : events) {
							creatureEvent->executeManaChange(target, attacker, damage);
						}
						healthChange = damage.primary.value + damage.secondary.value;
						if (healthChange == 0) {
							return true;
						}
						manaDamage = std::min<int32_t>(target->getMana(), healthChange);
					}
				}

				target->drainMana(attacker, manaDamage);

				if(target->getMana() == 0 && manaShield > 0) {
					target->removeCondition(CONDITION_MANASHIELD);
				}

				addMagicEffect(spectators, targetPos, CONST_ME_LOSEENERGY);

				std::stringstream ss;

				std::string damageString = std::to_string(manaDamage);

				std::string spectatorMessage;

				message.primary.value = manaDamage;
				message.primary.color = TEXTCOLOR_BLUE;

				for (Creature* spectator : spectators) {
					if (!spectator) {
						continue;
					}

					Player* tmpPlayer = spectator->getPlayer();
					if (!tmpPlayer) {
						continue;
					}

					if (tmpPlayer->getPosition().z != targetPos.z) {
						continue;
					}

					if (tmpPlayer == attackerPlayer && attackerPlayer != targetPlayer) {
						ss.str({});
						ss << ucfirst(target->getNameDescription()) << " loses " << damageString + " mana due to your attack.";
						message.type = MESSAGE_DAMAGE_DEALT;
						message.text = ss.str();
					} else if (tmpPlayer == targetPlayer) {
						ss.str({});
						ss << "You lose " << damageString << " mana";
						if (!attacker) {
							ss << '.';
						} else if (targetPlayer == attackerPlayer) {
							ss << " due to your own attack.";
						} else {
							ss << " due to an attack by " << attacker->getNameDescription() << '.';
						}
						message.type = MESSAGE_DAMAGE_RECEIVED;
						message.text = ss.str();
					} else {
						if (spectatorMessage.empty()) {
							ss.str({});
							ss << ucfirst(target->getNameDescription()) << " loses " << damageString + " mana";
							if (attacker) {
								ss << " due to ";
								if (attacker == target) {
									ss << (targetPlayer ? (targetPlayer->getSex() == PLAYERSEX_FEMALE ? "her own attack" : "his own attack") : "its own attack");
								} else {
									ss << "an attack by " << attacker->getNameDescription();
								}
							}
							ss << '.';
							spectatorMessage = ss.str();
						}
						message.type = MESSAGE_DAMAGE_OTHERS;
						message.text = spectatorMessage;
					}
					tmpPlayer->sendTextMessage(message);
				}

				damage.primary.value -= manaDamage;
				if (damage.primary.value < 0) {
					damage.secondary.value = std::max<int32_t>(0, damage.secondary.value + damage.primary.value);
					damage.primary.value = 0;
				}
			}
		}

		int32_t realDamage = damage.primary.value + damage.secondary.value;
		if (realDamage == 0) {
			return true;
		}

		if (damage.origin != ORIGIN_NONE) {
			const auto& events = target->getCreatureEvents(CREATURE_EVENT_HEALTHCHANGE);
			if (!events.empty()) {
				for (CreatureEvent* creatureEvent : events) {
					creatureEvent->executeHealthChange(target, attacker, damage);
				}
				damage.origin = ORIGIN_NONE;
				return combatChangeHealth(attacker, target, damage);
			}
		}

		int32_t targetHealth = target->getHealth();
		if (damage.primary.value >= targetHealth) {
			damage.primary.value = targetHealth;
			damage.secondary.value = 0;
		} else if (damage.secondary.value) {
			damage.secondary.value = std::min<int32_t>(damage.secondary.value, targetHealth - damage.primary.value);
		}

		realDamage = damage.primary.value + damage.secondary.value;
		if (realDamage == 0) {
			return true;
		} else if (realDamage >= targetHealth) {
			for (CreatureEvent* creatureEvent : target->getCreatureEvents(CREATURE_EVENT_PREPAREDEATH)) {
				if (!creatureEvent->executeOnPrepareDeath(target, attacker)) {
					return false;
				}
			}
		}

		target->drainHealth(attacker, realDamage);
		if (realDamage > 0 && targetMonster) {
			if (attackerPlayer && attackerPlayer->getPlayer()) {
				attackerPlayer->updateImpactTracker(damage.secondary.type, damage.secondary.value);
			}

			if (targetMonster->israndomStepping()) {
				targetMonster->setIgnoreFieldDamage(true);
				targetMonster->updateMapCache();
			}
		}

		// Using real damage
		if (attackerPlayer) {
			//life leech
			uint16_t lifeChance = attackerPlayer->getSkillLevel(SKILL_LIFE_LEECH_CHANCE);
			uint16_t lifeSkill = attackerPlayer->getSkillLevel(SKILL_LIFE_LEECH_AMOUNT);
			if (normal_random(0, 100) < lifeChance) {
				// Vampiric charm rune
				if (targetMonster) {
					if (uint16_t playerCharmRaceidVamp = attackerPlayer->parseRacebyCharm(CHARM_VAMP, false, 0); 
						playerCharmRaceidVamp != 0 && playerCharmRaceidVamp == targetMonster->getRaceId()) {
						if (const Charm* lifec = g_iobestiary().getBestiaryCharm(CHARM_VAMP)) {
							lifeSkill += lifec->percent;
						}
					}
				}
				CombatParams tmpParams;
				CombatDamage tmpDamage;

				int affected = damage.affected;
				tmpDamage.origin = ORIGIN_SPELL;
				tmpDamage.primary.type = COMBAT_HEALING;
				tmpDamage.primary.value = std::round(realDamage * (lifeSkill / 100.) * (0.2 * affected + 0.9)) / affected;

				Combat::doCombatHealth(nullptr, attackerPlayer, tmpDamage, tmpParams);
			}

			//mana leech
			uint16_t manaChance = attackerPlayer->getSkillLevel(SKILL_MANA_LEECH_CHANCE);
      		uint16_t manaSkill = attackerPlayer->getSkillLevel(SKILL_MANA_LEECH_AMOUNT);
			if (normal_random(0, 100) < manaChance) {
				// Void charm rune
				if (targetMonster) {
					if (uint16_t playerCharmRaceidVoid = attackerPlayer->parseRacebyCharm(CHARM_VOID, false, 0);
						playerCharmRaceidVoid != 0 && playerCharmRaceidVoid == targetMonster->getRace()) {
						if (const Charm* voidc = g_iobestiary().getBestiaryCharm(CHARM_VOID)) {
							manaSkill += voidc->percent;
						}
					}
				}
				CombatParams tmpParams;
				CombatDamage tmpDamage;

				int affected = damage.affected;
				tmpDamage.origin = ORIGIN_SPELL;
				tmpDamage.primary.type = COMBAT_MANADRAIN;
				tmpDamage.primary.value = std::round(realDamage * (manaSkill / 100.) * (0.1 * affected + 0.9)) / affected;

				Combat::doCombatMana(nullptr, attackerPlayer, tmpDamage, tmpParams);
			}

			// Charm rune (attacker as player)
			if (!damage.extension && targetMonster) {
				if (charmRune_t activeCharm = g_iobestiary().getCharmFromTarget(attackerPlayer, g_monsters().getMonsterTypeByRaceId(targetMonster->getRaceId()));
					activeCharm != CHARM_NONE) {
					if (Charm* charm = g_iobestiary().getBestiaryCharm(activeCharm);
						charm->type == CHARM_OFFENSIVE && (charm->chance >= normal_random(0, 100))) {
						g_iobestiary().parseCharmCombat(charm, attackerPlayer, target, realDamage);
					}
				}
			}

			// Party hunt analyzer
			if (Party* party = attackerPlayer->getParty()) {
				/* Damage on primary type */
				if (damage.primary.value != 0) {
					party->addPlayerDamage(attackerPlayer, damage.primary.value);
				}
				/* Damage on secondary type */
				if (damage.secondary.value != 0) {
					party->addPlayerDamage(attackerPlayer, damage.secondary.value);
				}
			}
		}

		if (spectators.empty()) {
			map.getSpectators(spectators, targetPos, true, true);
		}

		addCreatureHealth(spectators, target);

		message.primary.value = damage.primary.value;
		message.secondary.value = damage.secondary.value;

		uint8_t hitEffect;
		if (message.primary.value) {
			combatGetTypeInfo(damage.primary.type, target, message.primary.color, hitEffect);
			if (hitEffect != CONST_ME_NONE) {
				addMagicEffect(spectators, targetPos, hitEffect);
			}
		}

		if (message.secondary.value) {
			combatGetTypeInfo(damage.secondary.type, target, message.secondary.color, hitEffect);
			if (hitEffect != CONST_ME_NONE) {
				addMagicEffect(spectators, targetPos, hitEffect);
			}
		}

		if (message.primary.color != TEXTCOLOR_NONE || message.secondary.color != TEXTCOLOR_NONE) {
			if (attackerPlayer) {
				attackerPlayer->updateImpactTracker(damage.primary.type, damage.primary.value);
				if (damage.secondary.type != COMBAT_NONE) {
					attackerPlayer->updateImpactTracker(damage.secondary.type, damage.secondary.value);
				}
			}
			if (targetPlayer) {
				std::string cause = "(other)";
				if (attacker) {
					cause = attacker->getName();
				}

				targetPlayer->updateInputAnalyzer(damage.primary.type, damage.primary.value, cause);
				if (attackerPlayer) {
					if (damage.secondary.type != COMBAT_NONE) {
						attackerPlayer->updateInputAnalyzer(damage.secondary.type, damage.secondary.value, cause);
					}
				}
			}
			std::stringstream ss;

			ss << realDamage << (realDamage != 1 ? " hitpoints" : " hitpoint");
			std::string damageString = ss.str();

			std::string spectatorMessage;

			for (Creature* spectator : spectators) {
				Player* tmpPlayer = spectator->getPlayer();
				if (tmpPlayer->getPosition().z != targetPos.z) {
					continue;
				}

				if (tmpPlayer == attackerPlayer && attackerPlayer != targetPlayer) {
					ss.str({});
					ss << ucfirst(target->getNameDescription()) << " loses " << damageString << " due to your attack.";
					if (damage.extension) {
						ss << " " << damage.exString;
					}
					message.type = MESSAGE_DAMAGE_DEALT;
					message.text = ss.str();
				} else if (tmpPlayer == targetPlayer) {
					ss.str({});
					ss << "You lose " << damageString;
					if (!attacker) {
						ss << '.';
					} else if (targetPlayer == attackerPlayer) {
						ss << " due to your own attack.";
					} else {
						ss << " due to an attack by " << attacker->getNameDescription() << '.';
					}
					if (damage.extension) {
						ss << " " << damage.exString;
					}
					message.type = MESSAGE_DAMAGE_RECEIVED;
					message.text = ss.str();
				} else {
					message.type = MESSAGE_DAMAGE_OTHERS;

					if (spectatorMessage.empty()) {
						ss.str({});
						ss << ucfirst(target->getNameDescription()) << " loses " << damageString;
						if (attacker) {
							ss << " due to ";
							if (attacker == target) {
								if (targetPlayer) {
									ss << (targetPlayer->getSex() == PLAYERSEX_FEMALE ? "her own attack" : "his own attack");
								} else {
									ss << "its own attack";
								}
							} else {
								ss << "an attack by " << attacker->getNameDescription();
							}
						}
						ss << '.';
						if (damage.extension) {
							ss << " " << damage.exString;
						}
						spectatorMessage = ss.str();
					}

					message.text = spectatorMessage;
				}
				tmpPlayer->sendTextMessage(message);
			}
		}
	}

	return true;
}

bool Game::combatChangeMana(Creature* attacker, Creature* target, CombatDamage& damage)
{
	const Position& targetPos = target->getPosition();
	int32_t manaChange = damage.primary.value + damage.secondary.value;
	if (manaChange > 0) {
		Player* attackerPlayer;
		if (attacker) {
			attackerPlayer = attacker->getPlayer();
		} else {
			attackerPlayer = nullptr;
		}

		Player* targetPlayer = target->getPlayer();
		if (attackerPlayer && targetPlayer && attackerPlayer->getSkull() == SKULL_BLACK && attackerPlayer->getSkullClient(targetPlayer) == SKULL_NONE) {
			return false;
		}

		if (damage.origin != ORIGIN_NONE) {
			const auto& events = target->getCreatureEvents(CREATURE_EVENT_MANACHANGE);
			if (!events.empty()) {
				for (CreatureEvent* creatureEvent : events) {
					creatureEvent->executeManaChange(target, attacker, damage);
				}
				damage.origin = ORIGIN_NONE;
				return combatChangeMana(attacker, target, damage);
			}
		}

		int32_t realManaChange = target->getMana();
		target->changeMana(manaChange);
		realManaChange = target->getMana() - realManaChange;

		if (realManaChange > 0 && !target->isInGhostMode()) {
			std::string damageString = std::to_string(realManaChange) + " mana.";

			std::string spectatorMessage;
			if (!attacker) {
				spectatorMessage += ucfirst(target->getNameDescription());
				spectatorMessage += " was restored for " + damageString;
			} else {
				spectatorMessage += ucfirst(attacker->getNameDescription());
				spectatorMessage += " restored ";
				if (attacker == target) {
					spectatorMessage += (targetPlayer ? (targetPlayer->getSex() == PLAYERSEX_FEMALE ? "herself" : "himself") : "itself");
				} else {
					spectatorMessage += target->getNameDescription();
				}
				spectatorMessage += " for " + damageString;
			}

			TextMessage message;
			message.position = targetPos;
			message.primary.value = realManaChange;
			message.primary.color = TEXTCOLOR_MAYABLUE;

			SpectatorHashSet spectators;
			map.getSpectators(spectators, targetPos, false, true);
			for (Creature* spectator : spectators) {
				Player* tmpPlayer = spectator->getPlayer();

				if(!tmpPlayer)
				{
					continue;
				}

				if (tmpPlayer == attackerPlayer && attackerPlayer != targetPlayer) {
					message.type = MESSAGE_HEALED;
					message.text = "You restored " + target->getNameDescription() + " for " + damageString;
				} else if (tmpPlayer == targetPlayer) {
					message.type = MESSAGE_HEALED;
					if (!attacker) {
						message.text = "You were restored for " + damageString;
					} else if (targetPlayer == attackerPlayer) {
						message.text = "You restore yourself for " + damageString;
					} else {
						message.text = "You were restored by " + attacker->getNameDescription() + " for " + damageString;
					}
				} else {
					message.type = MESSAGE_HEALED_OTHERS;
					message.text = spectatorMessage;
				}
				tmpPlayer->sendTextMessage(message);
			}
		}
	} else {
		if (!target->isAttackable()) {
			if (!target->isInGhostMode()) {
				addMagicEffect(targetPos, CONST_ME_POFF);
			}
			return false;
		}

		Player* attackerPlayer;
		if (attacker) {
			attackerPlayer = attacker->getPlayer();
		} else {
			attackerPlayer = nullptr;
		}

		Player* targetPlayer = target->getPlayer();
		if (attackerPlayer && targetPlayer && attackerPlayer->getSkull() == SKULL_BLACK && attackerPlayer->getSkullClient(targetPlayer) == SKULL_NONE) {
			return false;
		}

		int32_t manaLoss = std::min<int32_t>(target->getMana(), -manaChange);
		BlockType_t blockType = target->blockHit(attacker, COMBAT_MANADRAIN, manaLoss);
		if (blockType != BLOCK_NONE) {
			addMagicEffect(targetPos, CONST_ME_POFF);
			return false;
		}

		if (manaLoss <= 0) {
			return true;
		}

		if (damage.origin != ORIGIN_NONE) {
			const auto& events = target->getCreatureEvents(CREATURE_EVENT_MANACHANGE);
			if (!events.empty()) {
				for (CreatureEvent* creatureEvent : events) {
					creatureEvent->executeManaChange(target, attacker, damage);
				}
				damage.origin = ORIGIN_NONE;
				return combatChangeMana(attacker, target, damage);
			}
		}

		if (targetPlayer && attacker && attacker->getMonster()) {
			//Charm rune (target as player)
			MonsterType* mType = g_monsters().getMonsterType(attacker->getName());
			if (mType) {
				charmRune_t activeCharm = g_iobestiary().getCharmFromTarget(targetPlayer, mType);
				if (activeCharm != CHARM_NONE && activeCharm != CHARM_CLEANSE) {
					Charm* charm = g_iobestiary().getBestiaryCharm(activeCharm);
					if (charm && charm->type == CHARM_DEFENSIVE && (charm->chance > normal_random(0, 100))) {
						if (g_iobestiary().parseCharmCombat(charm, targetPlayer, attacker, manaChange)) {
							return false; // Dodge charm
						}
					}
				}
			}
		}

		target->drainMana(attacker, manaLoss);

		std::stringstream ss;

		std::string damageString = std::to_string(manaLoss);

		std::string spectatorMessage;

		TextMessage message;
		message.position = targetPos;
		message.primary.value = manaLoss;
		message.primary.color = TEXTCOLOR_BLUE;

		SpectatorHashSet spectators;
		map.getSpectators(spectators, targetPos, false, true);
		for (Creature* spectator : spectators) {
			Player* tmpPlayer = spectator->getPlayer();

			if(!tmpPlayer)
			{
				continue;
			}

			if (tmpPlayer == attackerPlayer && attackerPlayer != targetPlayer) {
				ss.str({});
				ss << ucfirst(target->getNameDescription()) << " loses " << damageString << " mana due to your attack.";
				message.type = MESSAGE_DAMAGE_DEALT;
				message.text = ss.str();
			} else if (tmpPlayer == targetPlayer) {
				ss.str({});
				ss << "You lose " << damageString << " mana";
				if (!attacker) {
					ss << '.';
				} else if (targetPlayer == attackerPlayer) {
					ss << " due to your own attack.";
				} else {
					ss << " mana due to an attack by " << attacker->getNameDescription() << '.';
				}
				message.type = MESSAGE_DAMAGE_RECEIVED;
				message.text = ss.str();
			} else {
				if (spectatorMessage.empty()) {
					ss.str({});
					ss << ucfirst(target->getNameDescription()) << " loses " << damageString << " mana";
					if (attacker) {
						ss << " due to ";
						if (attacker == target) {
							ss << (targetPlayer ? (targetPlayer->getSex() == PLAYERSEX_FEMALE ? "her own attack" : "his own attack") : "its own attack");
						} else {
							ss << "an attack by " << attacker->getNameDescription();
						}
					}
					ss << '.';
					spectatorMessage = ss.str();
				}
				message.type = MESSAGE_DAMAGE_OTHERS;
				message.text = spectatorMessage;
			}
			tmpPlayer->sendTextMessage(message);
		}
	}

	return true;
}

void Game::addCreatureHealth(const Creature* target)
{
	SpectatorHashSet spectators;
	map.getSpectators(spectators, target->getPosition(), true, true);
	addCreatureHealth(spectators, target);
}

void Game::addCreatureHealth(const SpectatorHashSet& spectators, const Creature* target)
{
	uint8_t healthPercent = std::ceil((static_cast<double>(target->getHealth()) / std::max<int32_t>(target->getMaxHealth(), 1)) * 100);
	if (const Player* targetPlayer = target->getPlayer()) {
		if (Party* party = targetPlayer->getParty()) {
			party->updatePlayerHealth(targetPlayer, target, healthPercent);
		}
	} else if (const Creature* master = target->getMaster()) {
		if (const Player* masterPlayer = master->getPlayer()) {
			if (Party* party = masterPlayer->getParty()) {
				party->updatePlayerHealth(masterPlayer, target, healthPercent);
			}
		}
	}
	for (Creature* spectator : spectators) {
		if (Player* tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendCreatureHealth(target);
		}
	}
}

void Game::addPlayerMana(const Player* target)
{
	if (Party* party = target->getParty()) {
		uint8_t manaPercent = std::ceil((static_cast<double>(target->getMana()) / std::max<int32_t>(target->getMaxMana(), 1)) * 100);
		party->updatePlayerMana(target, manaPercent);
	}
}

void Game::addPlayerVocation(const Player* target)
{
	if (Party* party = target->getParty()) {
		party->updatePlayerVocation(target);
	}

	SpectatorHashSet spectators;
	map.getSpectators(spectators, target->getPosition(), true, true);

	for (Creature* spectator : spectators) {
		if (Player* tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendPlayerVocation(target);
		}
	}
}

void Game::addMagicEffect(const Position& pos, uint8_t effect)
{
	SpectatorHashSet spectators;
	map.getSpectators(spectators, pos, true, true);
	addMagicEffect(spectators, pos, effect);
}

void Game::addMagicEffect(const SpectatorHashSet& spectators, const Position& pos, uint8_t effect)
{
	for (Creature* spectator : spectators) {
		if (Player* tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendMagicEffect(pos, effect);
		}
	}
}

void Game::addDistanceEffect(const Position& fromPos, const Position& toPos, uint8_t effect)
{
	SpectatorHashSet spectators;
	map.getSpectators(spectators, fromPos, false, true);
	map.getSpectators(spectators, toPos, false, true);
	addDistanceEffect(spectators, fromPos, toPos, effect);
}

void Game::addDistanceEffect(const SpectatorHashSet& spectators, const Position& fromPos, const Position& toPos, uint8_t effect)
{
	for (Creature* spectator : spectators) {
		if (Player* tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendDistanceShoot(fromPos, toPos, effect);
		}
	}
}

void Game::checkImbuements()
{
	g_scheduler().addEvent(createSchedulerTask(EVENT_IMBUEMENT_INTERVAL, std::bind(&Game::checkImbuements, this)));

	std::vector<uint32_t> toErase;

	for (const auto& [key, value] : playersActiveImbuements) {
		Player* player = getPlayerByID(key);
		if (!player) {
			toErase.push_back(key);
			continue;
		}

		player->updateInventoryImbuement();
	}

	for (uint32_t playerId : toErase) {
		setPlayerActiveImbuements(playerId, 0);
	}

}

void Game::checkLight()
{
	g_scheduler().addEvent(createSchedulerTask(EVENT_LIGHTINTERVAL_MS, std::bind(&Game::checkLight, this)));

	lightHour += lightHourDelta;

	if (lightHour > LIGHT_DAY_LENGTH) {
		lightHour -= LIGHT_DAY_LENGTH;
	}

	if (std::abs(lightHour - SUNRISE) < 2 * lightHourDelta) {
		lightState = LIGHT_STATE_SUNRISE;
	} else if (std::abs(lightHour - SUNSET) < 2 * lightHourDelta) {
		lightState = LIGHT_STATE_SUNSET;
	}

	int32_t newLightLevel = lightLevel;
	bool lightChange = false;

	switch (lightState) {
		case LIGHT_STATE_SUNRISE: {
			newLightLevel += (LIGHT_LEVEL_DAY - LIGHT_LEVEL_NIGHT) / 30;
			lightChange = true;
			break;
		}
		case LIGHT_STATE_SUNSET: {
			newLightLevel -= (LIGHT_LEVEL_DAY - LIGHT_LEVEL_NIGHT) / 30;
			lightChange = true;
			break;
		}
		default:
			break;
	}

	if (newLightLevel <= LIGHT_LEVEL_NIGHT) {
		lightLevel = LIGHT_LEVEL_NIGHT;
		lightState = LIGHT_STATE_NIGHT;
	} else if (newLightLevel >= LIGHT_LEVEL_DAY) {
		lightLevel = LIGHT_LEVEL_DAY;
		lightState = LIGHT_STATE_DAY;
	} else {
		lightLevel = newLightLevel;
	}

	LightInfo lightInfo = getWorldLightInfo();

	if (lightChange) {
		for (const auto& it : players) {
			it.second->sendWorldLight(lightInfo);
      it.second->sendTibiaTime(lightHour);
		}
	} else {
		for (const auto& it : players) {
			it.second->sendTibiaTime(lightHour);
    }
	}
  if (currentLightState != lightState) {
		currentLightState = lightState;
		for (auto& [key, it] : g_globalEvents().getEventMap(GLOBALEVENT_PERIODCHANGE)) {
			it.executePeriodChange(lightState, lightInfo);
		}
	}
}

LightInfo Game::getWorldLightInfo() const
{
	return {lightLevel, 0xD7};
}

bool Game::gameIsDay()
{
	if (lightHour >= (6 * 60) && lightHour <= (18 * 60)) {
		isDay = true;
	} else {
		isDay = false;
	}

	return isDay;
}

void Game::dieSafely(std::string errorMsg /* = "" */)
{
	SPDLOG_ERROR(errorMsg);
	shutdown();
}

void Game::shutdown()
{
	std::string url = g_configManager().getString(DISCORD_WEBHOOK_URL);
	webhook_send_message("Server is shutting down", "Shutting down...", WEBHOOK_COLOR_OFFLINE, url);

	SPDLOG_INFO("Shutting down...");

	g_scheduler().shutdown();
	g_databaseTasks().shutdown();
	g_dispatcher().shutdown();
	map.spawnsMonster.clear();
	map.spawnsNpc.clear();
	raids.clear();

	cleanup();

	if (serviceManager) {
		serviceManager->stop();
	}

	ConnectionManager::getInstance().closeAll();

	SPDLOG_INFO("Done!");
}

void Game::cleanup()
{
	//free memory
	for (auto creature : ToReleaseCreatures) {
		creature->decrementReferenceCounter();
	}
	ToReleaseCreatures.clear();

	for (auto item : ToReleaseItems) {
		item->decrementReferenceCounter();
	}
	ToReleaseItems.clear();
}

void Game::ReleaseCreature(Creature* creature)
{
	ToReleaseCreatures.push_back(creature);
}

void Game::ReleaseItem(Item* item)
{
	ToReleaseItems.push_back(item);
}

void Game::addBestiaryList(uint16_t raceid, std::string name)
{
	auto it = BestiaryList.find(raceid);
	if (it != BestiaryList.end()) {
		return;
	}

	BestiaryList.insert(std::pair<uint16_t, std::string>(raceid, name));
}

void Game::broadcastMessage(const std::string& text, MessageClasses type) const
{
	SPDLOG_INFO("Broadcasted message: {}", text);
	for (const auto& it : players) {
		it.second->sendTextMessage(type, text);
	}
}

void Game::updateCreatureWalkthrough(const Creature* creature)
{
	//send to clients
	SpectatorHashSet spectators;
	map.getSpectators(spectators, creature->getPosition(), true, true);
	for (Creature* spectator : spectators) {
		Player* tmpPlayer = spectator->getPlayer();
		tmpPlayer->sendCreatureWalkthrough(creature, tmpPlayer->canWalkthroughEx(creature));
	}
}

void Game::updateCreatureSkull(const Creature* creature)
{
	if (getWorldType() != WORLD_TYPE_PVP) {
		return;
	}

	SpectatorHashSet spectators;
	map.getSpectators(spectators, creature->getPosition(), true, true);
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->sendCreatureSkull(creature);
	}
}

void Game::updatePlayerShield(Player* player)
{
	SpectatorHashSet spectators;
	map.getSpectators(spectators, player->getPosition(), true, true);
	for (Creature* spectator : spectators) {
		spectator->getPlayer()->sendCreatureShield(player);
	}
}

void Game::updateCreatureType(Creature* creature)
{
	if (!creature) {
		return;
	}

	const Player* masterPlayer = nullptr;
	CreatureType_t creatureType = creature->getType();
	if (creatureType == CREATURETYPE_MONSTER) {
		const Creature* master = creature->getMaster();
		if (master) {
			masterPlayer = master->getPlayer();
			if (masterPlayer) {
				creatureType = CREATURETYPE_SUMMON_OTHERS;
			}
		}
	}
	if (creature->isHealthHidden()) {
		creatureType = CREATURETYPE_HIDDEN;
	}

	//send to clients
	SpectatorHashSet spectators;
	map.getSpectators(spectators, creature->getPosition(), true, true);
	if (creatureType == CREATURETYPE_SUMMON_OTHERS) {
		for (Creature* spectator : spectators) {
			Player* player = spectator->getPlayer();
			if (masterPlayer == player) {
				player->sendCreatureType(creature, CREATURETYPE_SUMMON_PLAYER);
			} else {
				player->sendCreatureType(creature, creatureType);
			}
		}
	} else {
		for (Creature* spectator : spectators) {
			spectator->getPlayer()->sendCreatureType(creature, creatureType);
		}
	}
}

void Game::updatePremium(account::Account& account)
{
bool save = false;
	time_t timeNow = time(nullptr);
	uint32_t rem_days = 0;
	time_t last_day;
	account.GetPremiumRemaningDays(&rem_days);
	account.GetPremiumLastDay(&last_day);
	std::string email;
	if (rem_days != 0) {
		if (last_day == 0) {
			account.SetPremiumLastDay(timeNow);
			save = true;
		} else {
			uint32_t days = (timeNow - last_day) / 86400;
			if (days > 0) {
				if (days >= rem_days) {
					if(!account.SetPremiumRemaningDays(0) || !account.SetPremiumLastDay(0)) {
						account.GetEmail(&email);
						SPDLOG_ERROR("Failed to set account premium days, account email: {}",
							email);
					}
				} else {
					account.SetPremiumRemaningDays((rem_days - days));
					time_t remainder = (timeNow - last_day) % 86400;
					account.SetPremiumLastDay(timeNow - remainder);
				}

				save = true;
			}
		}
	}
	else if (last_day != 0) {
		account.SetPremiumLastDay(0);
		save = true;
	}

	if (save && !account.SaveAccountDB()) {
		account.GetEmail(&email);
		SPDLOG_ERROR("Failed to save account: {}", email);
	}
}

void Game::loadMotdNum()
{
	Database& db = Database::getInstance();

	DBResult_ptr result = db.storeQuery("SELECT `value` FROM `server_config` WHERE `config` = 'motd_num'");
	if (result) {
		motdNum = result->getNumber<uint32_t>("value");
	} else {
		db.executeQuery("INSERT INTO `server_config` (`config`, `value`) VALUES ('motd_num', '0')");
	}

	result = db.storeQuery("SELECT `value` FROM `server_config` WHERE `config` = 'motd_hash'");
	if (result) {
		motdHash = result->getString("value");
		if (motdHash != transformToSHA1(g_configManager().getString(MOTD))) {
			++motdNum;
		}
	} else {
		db.executeQuery("INSERT INTO `server_config` (`config`, `value`) VALUES ('motd_hash', '')");
	}
}

void Game::saveMotdNum() const
{
	Database& db = Database::getInstance();

	std::ostringstream query;
	query << "UPDATE `server_config` SET `value` = '" << motdNum << "' WHERE `config` = 'motd_num'";
	db.executeQuery(query.str());

	query.str(std::string());
	query << "UPDATE `server_config` SET `value` = '" << transformToSHA1(g_configManager().getString(MOTD)) << "' WHERE `config` = 'motd_hash'";
	db.executeQuery(query.str());
}

void Game::checkPlayersRecord()
{
	const size_t playersOnline = getPlayersOnline();
	if (playersOnline > playersRecord) {
		uint32_t previousRecord = playersRecord;
		playersRecord = playersOnline;

		for (auto& [key, it] : g_globalEvents().getEventMap(GLOBALEVENT_RECORD)) {
			it.executeRecord(playersRecord, previousRecord);
		}
		updatePlayersRecord();
	}
}

void Game::updatePlayersRecord() const
{
	Database& db = Database::getInstance();

	std::ostringstream query;
	query << "UPDATE `server_config` SET `value` = '" << playersRecord << "' WHERE `config` = 'players_record'";
	db.executeQuery(query.str());
}

void Game::loadPlayersRecord()
{
	Database& db = Database::getInstance();

	DBResult_ptr result = db.storeQuery("SELECT `value` FROM `server_config` WHERE `config` = 'players_record'");
	if (result) {
		playersRecord = result->getNumber<uint32_t>("value");
	} else {
		db.executeQuery("INSERT INTO `server_config` (`config`, `value`) VALUES ('players_record', '0')");
	}
}

void Game::playerInviteToParty(uint32_t playerId, uint32_t invitedId)
{
	//Prevent crafted packets from inviting urself to a party (using OTClient)
	if (playerId == invitedId) {
		return;
	}

	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Player* invitedPlayer = getPlayerByID(invitedId);
	if (!invitedPlayer || invitedPlayer->isInviting(player)) {
		return;
	}

	if (invitedPlayer->getParty()) {
		std::ostringstream ss;
		ss << invitedPlayer->getName() << " is already in a party.";
		player->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, ss.str());
		return;
	}

	Party* party = player->getParty();
	if (!party) {
		party = new Party(player);
	} else if (party->getLeader() != player) {
		return;
	}

	party->invitePlayer(*invitedPlayer);
}

void Game::playerJoinParty(uint32_t playerId, uint32_t leaderId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Player* leader = getPlayerByID(leaderId);
	if (!leader || !leader->isInviting(player)) {
		return;
	}

	Party* party = leader->getParty();
	if (!party || party->getLeader() != leader) {
		return;
	}

	if (player->getParty()) {
		player->sendTextMessage(MESSAGE_PARTY_MANAGEMENT, "You are already in a party.");
		return;
	}

	party->joinParty(*player);
}

void Game::playerRevokePartyInvitation(uint32_t playerId, uint32_t invitedId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Party* party = player->getParty();
	if (!party || party->getLeader() != player) {
		return;
	}

	Player* invitedPlayer = getPlayerByID(invitedId);
	if (!invitedPlayer || !player->isInviting(invitedPlayer)) {
		return;
	}

	party->revokeInvitation(*invitedPlayer);
}

void Game::playerPassPartyLeadership(uint32_t playerId, uint32_t newLeaderId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Party* party = player->getParty();
	if (!party || party->getLeader() != player) {
		return;
	}

	Player* newLeader = getPlayerByID(newLeaderId);
	if (!newLeader || !player->isPartner(newLeader)) {
		return;
	}

	party->passPartyLeadership(newLeader);
}

void Game::playerLeaveParty(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Party* party = player->getParty();
	if (!party || player->hasCondition(CONDITION_INFIGHT)) {
		return;
	}

	party->leaveParty(player);
}

void Game::playerEnableSharedPartyExperience(uint32_t playerId, bool sharedExpActive)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Party* party = player->getParty();
	Tile* playerTile = player->getTile();
	if (!party || (player->hasCondition(CONDITION_INFIGHT) && playerTile && !playerTile->hasFlag(TILESTATE_PROTECTIONZONE))) {
		return;
	}

	party->setSharedExperience(player, sharedExpActive);
}

void Game::sendGuildMotd(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Guild* guild = player->getGuild();
	if (guild) {
		player->sendChannelMessage("Message of the Day", guild->getMotd(), TALKTYPE_CHANNEL_R1, CHANNEL_GUILD);
	}
}

void Game::kickPlayer(uint32_t playerId, bool displayEffect)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->removePlayer(displayEffect);
}

void Game::playerCyclopediaCharacterInfo(Player* player, uint32_t characterID, CyclopediaCharacterInfoType_t characterInfoType, uint16_t entriesPerPage, uint16_t page) {
	uint32_t playerGUID = player->getGUID();
  if (characterID != playerGUID) {
		//For now allow viewing only our character since we don't have tournaments supported
		player->sendCyclopediaCharacterNoData(characterInfoType, 2);
		return;
	}

	switch (characterInfoType) {
	case CYCLOPEDIA_CHARACTERINFO_BASEINFORMATION: player->sendCyclopediaCharacterBaseInformation(); break;
	case CYCLOPEDIA_CHARACTERINFO_GENERALSTATS: player->sendCyclopediaCharacterGeneralStats(); break;
	case CYCLOPEDIA_CHARACTERINFO_COMBATSTATS: player->sendCyclopediaCharacterCombatStats(); break;
  case CYCLOPEDIA_CHARACTERINFO_RECENTDEATHS: {
    std::ostringstream query;
    uint32_t offset = static_cast<uint32_t>(page - 1) * entriesPerPage;
			query << "SELECT `time`, `level`, `killed_by`, `mostdamage_by`, (select count(*) FROM `player_deaths` WHERE `player_id` = " << playerGUID << ") as `entries` FROM `player_deaths` WHERE `player_id` = " << playerGUID << " ORDER BY `time` DESC LIMIT " << offset << ", " << entriesPerPage;

			uint32_t playerID = player->getID();
			std::function<void(DBResult_ptr, bool)> callback = [playerID, page, entriesPerPage](DBResult_ptr result, bool) {
				Player* player = g_game().getPlayerByID(playerID);
				if (!player) {
					return;
				}

				player->resetAsyncOngoingTask(PlayerAsyncTask_RecentDeaths);
				if (!result) {
					player->sendCyclopediaCharacterRecentDeaths(0, 0, {});
					return;
				}

				uint32_t pages = result->getNumber<uint32_t>("entries");
				pages += entriesPerPage - 1;
				pages /= entriesPerPage;

				std::vector<RecentDeathEntry> entries;
				entries.reserve(result->countResults());
				do {
					std::string cause1 = result->getString("killed_by");
					std::string cause2 = result->getString("mostdamage_by");

					std::ostringstream cause;
					cause << "Died at Level " << result->getNumber<uint32_t>("level") << " by";
					if (!cause1.empty()) {
						const char& character = cause1.front();
						if (character == 'a' || character == 'e' || character == 'i' || character == 'o' || character == 'u') {
							cause << " an ";
						} else {
							cause << " a ";
						}
						cause << cause1;
					}

					if (!cause2.empty()) {
						if (!cause1.empty()) {
							cause << " and ";
						}

						const char& character = cause2.front();
						if (character == 'a' || character == 'e' || character == 'i' || character == 'o' || character == 'u') {
							cause << " an ";
						} else {
							cause << " a ";
						}
						cause << cause2;
					}
					cause << '.';
					entries.emplace_back(std::move(cause.str()), result->getNumber<uint32_t>("time"));
				} while (result->next());
				player->sendCyclopediaCharacterRecentDeaths(page, static_cast<uint16_t>(pages), entries);
			};
			g_databaseTasks().addTask(query.str(), callback, true);
			player->addAsyncOngoingTask(PlayerAsyncTask_RecentDeaths);
			break;
	}
	case CYCLOPEDIA_CHARACTERINFO_RECENTPVPKILLS: {
			// TODO: add guildwar, assists and arena kills
			Database& db = Database::getInstance();
			const std::string& escapedName = db.escapeString(player->getName());
			std::ostringstream query;
			uint32_t offset = static_cast<uint32_t>(page - 1) * entriesPerPage;
			query << "SELECT `d`.`time`, `d`.`killed_by`, `d`.`mostdamage_by`, `d`.`unjustified`, `d`.`mostdamage_unjustified`, `p`.`name`, (select count(*) FROM `player_deaths` WHERE ((`killed_by` = " << escapedName << " AND `is_player` = 1) OR (`mostdamage_by` = " << escapedName << " AND `mostdamage_is_player` = 1))) as `entries` FROM `player_deaths` AS `d` INNER JOIN `players` AS `p` ON `d`.`player_id` = `p`.`id` WHERE ((`d`.`killed_by` = " << escapedName << " AND `d`.`is_player` = 1) OR (`d`.`mostdamage_by` = " << escapedName << " AND `d`.`mostdamage_is_player` = 1)) ORDER BY `time` DESC LIMIT " << offset << ", " << entriesPerPage;

			uint32_t playerID = player->getID();
			std::function<void(DBResult_ptr, bool)> callback = [playerID, page, entriesPerPage](DBResult_ptr result, bool) {
				Player* player = g_game().getPlayerByID(playerID);
				if (!player) {
					return;
				}

				player->resetAsyncOngoingTask(PlayerAsyncTask_RecentPvPKills);
				if (!result) {
					player->sendCyclopediaCharacterRecentPvPKills(0, 0, {});
					return;
				}

				uint32_t pages = result->getNumber<uint32_t>("entries");
				pages += entriesPerPage - 1;
				pages /= entriesPerPage;

				std::vector<RecentPvPKillEntry> entries;
				entries.reserve(result->countResults());
				do {
					std::string cause1 = result->getString("killed_by");
					std::string cause2 = result->getString("mostdamage_by");
					std::string name = result->getString("name");

					uint8_t status = CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_JUSTIFIED;
					if (player->getName() == cause1) {
						if (result->getNumber<uint32_t>("unjustified") == 1) {
							status = CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_UNJUSTIFIED;
						}
					} else if (player->getName() == cause2) {
						if (result->getNumber<uint32_t>("mostdamage_unjustified") == 1) {
							status = CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_UNJUSTIFIED;
						}
					}

					std::ostringstream description;
					description << "Killed " << name << '.';
					entries.emplace_back(std::move(description.str()), result->getNumber<uint32_t>("time"), status);
				} while (result->next());
				player->sendCyclopediaCharacterRecentPvPKills(page, static_cast<uint16_t>(pages), entries);
			};
			g_databaseTasks().addTask(query.str(), callback, true);
			player->addAsyncOngoingTask(PlayerAsyncTask_RecentPvPKills);
			break;
	}
	case CYCLOPEDIA_CHARACTERINFO_ACHIEVEMENTS: player->sendCyclopediaCharacterAchievements(); break;
	case CYCLOPEDIA_CHARACTERINFO_ITEMSUMMARY: player->sendCyclopediaCharacterItemSummary(); break;
	case CYCLOPEDIA_CHARACTERINFO_OUTFITSMOUNTS: player->sendCyclopediaCharacterOutfitsMounts(); break;
	case CYCLOPEDIA_CHARACTERINFO_STORESUMMARY: player->sendCyclopediaCharacterStoreSummary(); break;
	case CYCLOPEDIA_CHARACTERINFO_INSPECTION: player->sendCyclopediaCharacterInspection(); break;
	case CYCLOPEDIA_CHARACTERINFO_BADGES: player->sendCyclopediaCharacterBadges(); break;
	case CYCLOPEDIA_CHARACTERINFO_TITLES: player->sendCyclopediaCharacterTitles(); break;
  default: player->sendCyclopediaCharacterNoData(characterInfoType, 1); break;
	}
}

void Game::playerHighscores(Player* player, HighscoreType_t type, uint8_t category, uint32_t vocation, const std::string&, uint16_t page, uint8_t entriesPerPage)
{
	if (player->hasAsyncOngoingTask(PlayerAsyncTask_Highscore)) {
		return;
	}

	std::string categoryName;
	switch (category) {
		case HIGHSCORE_CATEGORY_FIST_FIGHTING: categoryName = "skill_fist"; break;
		case HIGHSCORE_CATEGORY_CLUB_FIGHTING: categoryName = "skill_club"; break;
		case HIGHSCORE_CATEGORY_SWORD_FIGHTING: categoryName = "skill_sword"; break;
		case HIGHSCORE_CATEGORY_AXE_FIGHTING: categoryName = "skill_axe"; break;
		case HIGHSCORE_CATEGORY_DISTANCE_FIGHTING: categoryName = "skill_dist"; break;
		case HIGHSCORE_CATEGORY_SHIELDING: categoryName = "skill_shielding"; break;
		case HIGHSCORE_CATEGORY_FISHING: categoryName = "skill_fishing"; break;
		case HIGHSCORE_CATEGORY_MAGIC_LEVEL: categoryName = "maglevel"; break;
		default: {
			category = HIGHSCORE_CATEGORY_EXPERIENCE;
			categoryName = "experience";
			break;
		}
	}

	std::ostringstream query;
	if (type == HIGHSCORE_GETENTRIES) {
		uint32_t startPage = (static_cast<uint32_t>(page - 1) * static_cast<uint32_t>(entriesPerPage));
		uint32_t endPage = startPage + static_cast<uint32_t>(entriesPerPage);
		query << "SELECT *, @row AS `entries`, " << page << " AS `page` FROM (SELECT *, (@row := @row + 1) AS `rn` FROM (SELECT `id`, `name`, `level`, `vocation`, `" << categoryName << "` AS `points`, @curRank := IF(@prevRank = `" << categoryName << "`, @curRank, IF(@prevRank := `" << categoryName << "`, @curRank + 1, @curRank + 1)) AS `rank` FROM `players` `p`, (SELECT @curRank := 0, @prevRank := NULL, @row := 0) `r` WHERE `group_id` < " << static_cast<int>(account::GROUP_TYPE_GAMEMASTER) << " ORDER BY `" << categoryName << "` DESC) `t`";
		if (vocation != 0xFFFFFFFF) {
			bool firstVocation = true;

			const auto& vocationsMap = g_vocations().getVocations();
			for (const auto& it : vocationsMap) {
				const Vocation& voc = it.second;
				if (voc.getFromVocation() == vocation) {
					if (firstVocation) {
						query << " WHERE `vocation` = " << voc.getId();
						firstVocation = false;
					} else {
						query << " OR `vocation` = " << voc.getId();
					}
				}
			}
		}
		query << ") `T` WHERE `rn` > " << startPage << " AND `rn` <= " << endPage;
	} else if (type == HIGHSCORE_OURRANK) {
		std::string entriesStr = std::to_string(entriesPerPage);
		query << "SELECT *, @row AS `entries`, (@ourRow DIV " << entriesStr << ") + 1 AS `page` FROM (SELECT *, (@row := @row + 1) AS `rn`, @ourRow := IF(`id` = " << player->getGUID() << ", @row - 1, @ourRow) AS `rw` FROM (SELECT `id`, `name`, `level`, `vocation`, `" << categoryName << "` AS `points`, @curRank := IF(@prevRank = `" << categoryName << "`, @curRank, IF(@prevRank := `" << categoryName << "`, @curRank + 1, @curRank + 1)) AS `rank` FROM `players` `p`, (SELECT @curRank := 0, @prevRank := NULL, @row := 0, @ourRow := 0) `r` WHERE `group_id` < " << static_cast<int>(account::GROUP_TYPE_GAMEMASTER) << " ORDER BY `" << categoryName << "` DESC) `t`";
		if (vocation != 0xFFFFFFFF) {
			bool firstVocation = true;

			const auto& vocationsMap = g_vocations().getVocations();
			for (const auto& it : vocationsMap) {
				const Vocation& voc = it.second;
				if (voc.getFromVocation() == vocation) {
					if (firstVocation) {
						query << " WHERE `vocation` = " << voc.getId();
						firstVocation = false;
					} else {
						query << " OR `vocation` = " << voc.getId();
					}
				}
			}
		}
		query << ") `T` WHERE `rn` > ((@ourRow DIV " << entriesStr << ") * " << entriesStr << ") AND `rn` <= (((@ourRow DIV " << entriesStr << ") * " << entriesStr << ") + " << entriesStr << ")";
	}

	uint32_t playerID = player->getID();
	std::function<void(DBResult_ptr, bool)> callback = [playerID, category, vocation, entriesPerPage](DBResult_ptr result, bool) {
		Player* player = g_game().getPlayerByID(playerID);
		if (!player) {
			return;
		}

		player->resetAsyncOngoingTask(PlayerAsyncTask_Highscore);
		if (!result) {
			player->sendHighscoresNoData();
			return;
		}

		uint16_t page = result->getNumber<uint16_t>("page");
		uint32_t pages = result->getNumber<uint32_t>("entries");
		pages += entriesPerPage - 1;
		pages /= entriesPerPage;

		std::vector<HighscoreCharacter> characters;
		characters.reserve(result->countResults());
		do {
			uint8_t characterVocation;
			const Vocation* voc = g_vocations().getVocation(result->getNumber<uint16_t>("vocation"));
			if (voc) {
				characterVocation = voc->getClientId();
			} else {
				characterVocation = 0;
			}
			characters.emplace_back(std::move(result->getString("name")), result->getNumber<uint64_t>("points"), result->getNumber<uint32_t>("id"), result->getNumber<uint32_t>("rank"), result->getNumber<uint16_t>("level"), characterVocation);
		} while (result->next());
		player->sendHighscores(characters, category, vocation, page, static_cast<uint16_t>(pages));
	};
	g_databaseTasks().addTask(query.str(), callback, true);
	player->addAsyncOngoingTask(PlayerAsyncTask_Highscore);
}

void Game::playerTournamentLeaderboard(uint32_t playerId, uint8_t leaderboardType) {
	Player* player = getPlayerByID(playerId);
	if (!player || leaderboardType > 1) {
		return;
	}

	player->sendTournamentLeaderboard();
}

void Game::playerReportRuleViolationReport(uint32_t playerId, const std::string& targetName, uint8_t reportType, uint8_t reportReason, const std::string& comment, const std::string& translation)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	g_events().eventPlayerOnReportRuleViolation(player, targetName, reportType, reportReason, comment, translation);
}

void Game::playerReportBug(uint32_t playerId, const std::string& message, const Position& position, uint8_t category)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	g_events().eventPlayerOnReportBug(player, message, position, category);
}

void Game::playerDebugAssert(uint32_t playerId, const std::string& assertLine, const std::string& date, const std::string& description, const std::string& comment)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	// TODO: move debug assertions to database
	FILE* file = fopen("client_assertions.txt", "a");
	if (file) {
		fprintf(file, "----- %s - %s (%s) -----\n", formatDate(time(nullptr)).c_str(), player->getName().c_str(), convertIPToString(player->getIP()).c_str());
		fprintf(file, "%s\n%s\n%s\n%s\n", assertLine.c_str(), date.c_str(), description.c_str(), comment.c_str());
		fclose(file);
	}
}

void Game::playerPreyAction(uint32_t playerId, uint8_t slot, uint8_t action, uint8_t option, int8_t index, uint16_t raceId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	g_ioprey().ParsePreyAction(player, static_cast<PreySlot_t>(slot), static_cast<PreyAction_t>(action), static_cast<PreyOption_t>(option), index, raceId);
}

void Game::playerTaskHuntingAction(uint32_t playerId, uint8_t slot, uint8_t action, bool upgrade, uint16_t raceId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	g_ioprey().ParseTaskHuntingAction(player, static_cast<PreySlot_t>(slot), static_cast<PreyTaskAction_t>(action), upgrade, raceId);
}

void Game::playerNpcGreet(uint32_t playerId, uint32_t npcId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	Npc* npc = getNpcByID(npcId);
	if (!npc) {
		return;
	}

	SpectatorHashSet spectators;
	spectators.insert(npc);
	map.getSpectators(spectators, player->getPosition(), true, true);
	internalCreatureSay(player, TALKTYPE_SAY, "hi", false, &spectators);
	spectators.clear();
	spectators.insert(npc);
	if (npc->getSpeechBubble() == SPEECHBUBBLE_TRADE) {
		internalCreatureSay(player, TALKTYPE_PRIVATE_PN, "trade", false, &spectators);
	} else {
		internalCreatureSay(player, TALKTYPE_PRIVATE_PN, "sail", false, &spectators);
	}
}

void Game::playerLeaveMarket(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	player->setInMarket(false);
}

void Game::playerBrowseMarket(uint32_t playerId, uint16_t itemId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!player->isInMarket()) {
		return;
	}

	const ItemType& it = Item::items[itemId];
	if (it.id == 0) {
		return;
	}

	if (it.wareId == 0) {
		return;
	}

	const MarketOfferList& buyOffers = IOMarket::getActiveOffers(MARKETACTION_BUY, it.id);
	const MarketOfferList& sellOffers = IOMarket::getActiveOffers(MARKETACTION_SELL, it.id);
	player->sendMarketBrowseItem(it.id, buyOffers, sellOffers);
	player->sendMarketDetail(it.id);
}

void Game::playerBrowseMarketOwnOffers(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!player->isInMarket()) {
		return;
	}

	const MarketOfferList& buyOffers = IOMarket::getOwnOffers(MARKETACTION_BUY, player->getGUID());
	const MarketOfferList& sellOffers = IOMarket::getOwnOffers(MARKETACTION_SELL, player->getGUID());
	player->sendMarketBrowseOwnOffers(buyOffers, sellOffers);
}

void Game::playerBrowseMarketOwnHistory(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!player->isInMarket()) {
		return;
	}

	const HistoryMarketOfferList& buyOffers = IOMarket::getOwnHistory(MARKETACTION_BUY, player->getGUID());
	const HistoryMarketOfferList& sellOffers = IOMarket::getOwnHistory(MARKETACTION_SELL, player->getGUID());
	player->sendMarketBrowseOwnHistory(buyOffers, sellOffers);
}

void Game::playerCreateMarketOffer(uint32_t playerId, uint8_t type, uint16_t itemId, uint16_t amount, uint32_t price, bool anonymous)
{
	// 64000 is size of the client limitation (uint16_t)
	if (amount == 0 || amount > 64000) {
		return;
	}

	if (price == 0 || price > 999999999) {
		return;
	}

	if (type != MARKETACTION_BUY && type != MARKETACTION_SELL) {
		return;
	}

	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!player->isInMarket()) {
		return;
	}

	// Check market exhausted
	if (player->isMarketExhausted()) {
		player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return;
	}

	if (g_configManager().getBoolean(MARKET_PREMIUM) && !player->isPremium()) {
		player->sendTextMessage(MESSAGE_MARKET, "Only premium accounts may create offers for that object.");
		return;
	}

	const ItemType& itt = Item::items[itemId];
	if (itt.id == 0 || itt.wareId == 0) {
		return;
	}

	const ItemType& it = Item::items[itt.wareId];
	if (it.id == 0 || it.wareId == 0) {
		return;
	}

	if (!it.stackable && amount > 2000) {
		return;
	}

	const uint32_t maxOfferCount = g_configManager().getNumber(MAX_MARKET_OFFERS_AT_A_TIME_PER_PLAYER);
	if (maxOfferCount != 0 && IOMarket::getPlayerOfferCount(player->getGUID()) >= maxOfferCount) {
		return;
	}

	uint64_t calcFee = (price / 100.) * amount;
	uint32_t minFee = std::min<uint32_t>(100000, calcFee);
	uint32_t fee = std::max<uint32_t>(20, minFee);

	if (type == MARKETACTION_SELL) {

		if (fee > (player->getBankBalance() + player->getMoney())) {
			return;
		}

		DepotLocker* depotLocker = player->getDepotLocker(player->getLastDepotId());
		if (!depotLocker) {
			return;
		}

		if (it.id == ITEM_STORE_COIN) {
			account::Account account(player->getAccount());
			account.LoadAccountDB();
			uint32_t coins;
			account.GetCoins(&coins);

			if (amount > coins) {
				return;
			}

			account.RemoveCoins(static_cast<uint32_t>(amount));
		} else {
			uint16_t stashminus = player->getStashItemCount(it.wareId);
			amount = (amount - (amount > stashminus ? stashminus : amount));

			std::forward_list<Item *> itemList = getMarketItemList(it.wareId, amount, depotLocker);
			if (itemList.empty() && amount > 0) {
				return;
			}

			if (stashminus > 0) {
				player->withdrawItem(it.wareId, (amount > stashminus ? stashminus : amount));
			}

			uint16_t tmpAmount = amount;
			for (Item *item : itemList) {
				if (!it.stackable) {
					internalRemoveItem(item);
					continue;
				}

				uint16_t removeCount = std::min<uint16_t>(tmpAmount, item->getItemCount());
				tmpAmount -= removeCount;
				internalRemoveItem(item, removeCount);
			}
		}

		g_game().removeMoney(player, fee, 0, true);
	} else {

		uint64_t totalPrice = price * amount;
		totalPrice += fee;
		if (totalPrice > (player->getMoney() + player->getBankBalance())) {
			return;
		}

		g_game().removeMoney(player, totalPrice, 0, true);
	}

	IOMarket::createOffer(player->getGUID(), static_cast<MarketAction_t>(type), it.id, amount, price, anonymous);

	auto ColorItem = itemsPriceMap.find(it.id);
	if (ColorItem == itemsPriceMap.end()) {
		itemsPriceMap[it.id] = price;
		itemsSaleCount++;
	} else if (ColorItem->second < price) {
		itemsPriceMap[it.id] = price;
	}

	// Send market window again for update stats
	player->sendMarketEnter(player->getLastDepotId());
	const MarketOfferList& buyOffers = IOMarket::getActiveOffers(MARKETACTION_BUY, it.id);
	const MarketOfferList& sellOffers = IOMarket::getActiveOffers(MARKETACTION_SELL, it.id);
	player->sendMarketBrowseItem(it.id, buyOffers, sellOffers);

	// Exhausted for create offert in the market
	player->updateMarketExhausted();
}

void Game::playerCancelMarketOffer(uint32_t playerId, uint32_t timestamp, uint16_t counter)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!player->isInMarket()) {
		return;
	}

	// Check market exhausted
	if (player->isMarketExhausted()) {
		player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return;
	}

	MarketOfferEx offer = IOMarket::getOfferByCounter(timestamp, counter);
	if (offer.id == 0 || offer.playerId != player->getGUID()) {
		return;
	}

	if (offer.type == MARKETACTION_BUY) {
		player->setBankBalance( player->getBankBalance() + static_cast<uint64_t>(offer.price) * offer.amount);
		// Send market window again for update stats
		player->sendMarketEnter(player->getLastDepotId());
	} else {
		const ItemType& it = Item::items[offer.itemId];
		if (it.id == 0) {
			return;
		}

		if (it.id == ITEM_STORE_COIN) {
			account::Account account;
			account.LoadAccountDB(player->getAccount());
			account.AddCoins(offer.amount);
		} else if (it.stackable) {
			uint16_t tmpAmount = offer.amount;
			while (tmpAmount > 0) {
				int32_t stackCount = std::min<int32_t>(100, tmpAmount);
				Item* item = Item::CreateItem(it.id, stackCount);
				if (internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT) != RETURNVALUE_NOERROR) {
					delete item;
					break;
				}

				tmpAmount -= stackCount;
			}
		} else {
			int32_t subType;
			if (it.charges != 0) {
				subType = it.charges;
			} else {
				subType = -1;
			}

			for (uint16_t i = 0; i < offer.amount; ++i) {
				Item* item = Item::CreateItem(it.id, subType);
				if (internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT) != RETURNVALUE_NOERROR) {
					delete item;
					break;
				}
			}
		}
	}

	IOMarket::moveOfferToHistory(offer.id, OFFERSTATE_CANCELLED);
	offer.amount = 0;
	offer.timestamp += g_configManager().getNumber(MARKET_OFFER_DURATION);
	player->sendMarketCancelOffer(offer);
	// Send market window again for update stats
	player->sendMarketEnter(player->getLastDepotId());
	// Exhausted for cancel offer in the market
	player->updateMarketExhausted();
}

void Game::playerAcceptMarketOffer(uint32_t playerId, uint32_t timestamp, uint16_t counter, uint16_t amount)
{
	// Limit of 64k of items to create offer
	if (amount == 0 || amount > 64000) {
		return;
	}

	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!player->isInMarket()) {
		return;
	}

	// Check market exhausted
	if (player->isMarketExhausted()) {
		player->sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
		g_game().addMagicEffect(player->getPosition(), CONST_ME_POFF);
		return;
	}

	MarketOfferEx offer = IOMarket::getOfferByCounter(timestamp, counter);
	if (offer.id == 0) {
		return;
	}

	if (amount > offer.amount) {
		return;
	}

	const ItemType& it = Item::items[offer.itemId];
	if (it.id == 0) {
		return;
	}

	uint64_t totalPrice = offer.price * amount;

	// The player has an offer to by something and someone is going to sell to item type
	// so the market action is 'buy' as who created the offer is buying.
	if (offer.type == MARKETACTION_BUY) {
		DepotLocker* depotLocker = player->getDepotLocker(player->getLastDepotId());
		if (!depotLocker) {
			return;
		}

		Player* buyerPlayer = getPlayerByGUID(offer.playerId);
		if (!buyerPlayer) {
			buyerPlayer = new Player(nullptr);
			if (!IOLoginData::loadPlayerById(buyerPlayer, offer.playerId)) {
				delete buyerPlayer;
				return;
			}
		}

		if (player == buyerPlayer || player->getAccount() == buyerPlayer->getAccount()) {
			player->sendTextMessage(MESSAGE_MARKET, "You cannot accept your own offer.");
			return;
		}

		if (it.id == ITEM_STORE_COIN) {
			account::Account account;
			account.LoadAccountDB(player->getAccount());
			uint32_t coins;
			account.GetCoins(&coins);
			if (amount > coins) {
				return;
			}

			account.RemoveCoins(amount);
			account.RegisterCoinsTransaction(account::COIN_REMOVE, amount,
											 "Sold on Market");
		} else {
			uint16_t stashminus = player->getStashItemCount(it.wareId);
			amount = (amount - (amount > stashminus ? stashminus : amount));
			std::forward_list<Item*> itemList = getMarketItemList(it.wareId, amount, depotLocker);
			if (itemList.empty() && amount > 0) {
				return;
			}

			if (stashminus > 0) {
				player->withdrawItem(it.wareId, (amount > stashminus ? stashminus : amount));
			}

			if (it.stackable) {
				uint16_t tmpAmount = amount;
				for (Item* item : itemList) {
					if (!item) {
						continue;
					}
					uint16_t removeCount = std::min<uint16_t>(tmpAmount, item->getItemCount());
					tmpAmount -= removeCount;
					internalRemoveItem(item, removeCount);

					if (tmpAmount == 0) {
						break;
					}
				}
			} else {
				for (Item* item : itemList) {
					if (!item) {
						continue;
					}
					internalRemoveItem(item);
				}
			}
		}
		player->setBankBalance(player->getBankBalance() + totalPrice);

		if (it.id == ITEM_STORE_COIN) {
			account::Account account;
			account.LoadAccountDB(buyerPlayer->getAccount());
			account.AddCoins(amount);
			account.RegisterCoinsTransaction(account::COIN_ADD, amount,
											 "Purchased on Market");
		}
		else if (it.stackable)
		{
			uint16_t tmpAmount = amount;
			while (tmpAmount > 0) {
				uint16_t stackCount = std::min<uint16_t>(100, tmpAmount);
				Item* item = Item::CreateItem(it.id, stackCount);
				if (internalAddItem(buyerPlayer->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT) != RETURNVALUE_NOERROR) {
					delete item;
					break;
				}

				tmpAmount -= stackCount;
			}
		}
		else
		{
			int32_t subType;
			if (it.charges != 0) {
				subType = it.charges;
			} else {
				subType = -1;
			}

			for (uint16_t i = 0; i < amount; ++i) {
				Item* item = Item::CreateItem(it.id, subType);
				if (internalAddItem(buyerPlayer->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT) != RETURNVALUE_NOERROR) {
					delete item;
					break;
				}
			}
		}

		if (buyerPlayer->isOffline()) {
			IOLoginData::savePlayer(buyerPlayer);
			delete buyerPlayer;
		}
	} else if (offer.type == MARKETACTION_SELL) {

		Player *sellerPlayer = getPlayerByGUID(offer.playerId);
		if (!sellerPlayer) {
			sellerPlayer = new Player(nullptr);
			if (!IOLoginData::loadPlayerById(sellerPlayer, offer.playerId)) {
				delete sellerPlayer;
				return;
			}
		}

		if (player == sellerPlayer || player->getAccount() == sellerPlayer->getAccount()) {
			player->sendTextMessage(MESSAGE_MARKET, "You cannot accept your own offer.");
			return;
		}

		if (totalPrice > (player->getBankBalance() + player->getMoney())) {
			return;
		}

		// Have enough money on the bank
		if(totalPrice <= player->getBankBalance())
		{
			player->setBankBalance(player->getBankBalance() - totalPrice);
		}
		else
		{
			uint64_t remainsPrice = 0;
			remainsPrice = totalPrice - player->getBankBalance();
			player->setBankBalance(0);
			g_game().removeMoney(player, remainsPrice);
		}

		if (it.id == ITEM_STORE_COIN) {
			account::Account account;
			account.LoadAccountDB(player->getAccount());
			account.AddCoins(amount);
			account.RegisterCoinsTransaction(account::COIN_ADD, amount,
											 "Purchased on Market");
		} else if (it.stackable) {
			uint16_t tmpAmount = amount;
			while (tmpAmount > 0) {
				uint16_t stackCount = std::min<uint16_t>(100, tmpAmount);
				Item* item = Item::CreateItem(it.id, stackCount);
				if (internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT) != RETURNVALUE_NOERROR) {
					delete item;
					break;
				}

				tmpAmount -= stackCount;
			}
		} else {
			int32_t subType;
			if (it.charges != 0) {
				subType = it.charges;
			} else {
				subType = -1;
			}

			for (uint16_t i = 0; i < amount; ++i) {
				Item* item = Item::CreateItem(it.id, subType);
				if (internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT) != RETURNVALUE_NOERROR) {
					delete item;
					break;
				}
			}
		}

		sellerPlayer->setBankBalance(sellerPlayer->getBankBalance() + totalPrice);
		if (it.id == ITEM_STORE_COIN) {
			account::Account account;
			account.LoadAccountDB(sellerPlayer->getAccount());
			account.RegisterCoinsTransaction(account::COIN_REMOVE, amount,
											"Sold on Market");
		}

		if (it.id != ITEM_STORE_COIN) {
			player->onReceiveMail();
		}

		if (sellerPlayer->isOffline()) {
			IOLoginData::savePlayer(sellerPlayer);
			delete sellerPlayer;
		}
	}

	const int32_t marketOfferDuration = g_configManager().getNumber(MARKET_OFFER_DURATION);

	IOMarket::appendHistory(player->getGUID(), (offer.type == MARKETACTION_BUY ? MARKETACTION_SELL : MARKETACTION_BUY), offer.itemId, amount, offer.price, time(nullptr), OFFERSTATE_ACCEPTEDEX);

	IOMarket::appendHistory(offer.playerId, offer.type, offer.itemId, amount, offer.price, time(nullptr), OFFERSTATE_ACCEPTED);

	offer.amount -= amount;

	if (offer.amount == 0) {
		IOMarket::deleteOffer(offer.id);
	} else {
		IOMarket::acceptOffer(offer.id, amount);
	}

	// Send market window again for update stats
	player->sendMarketEnter(player->getLastDepotId());
	offer.timestamp += marketOfferDuration;
	player->sendMarketAcceptOffer(offer);
	// Exhausted for accept offer in the market
	player->updateMarketExhausted();
}

void Game::playerStoreOpen(uint32_t playerId, uint8_t serviceType)
{
	Player* player = getPlayerByID(playerId);
	if (player) {
		player->sendOpenStore(serviceType);
	}
}

void Game::playerShowStoreCategoryOffers(uint32_t playerId, StoreCategory* category)
{
	Player* player = getPlayerByID(playerId);
	if (player) {
		player->sendShowStoreCategoryOffers(category);
	}
}

void Game::playerBuyStoreOffer(uint32_t playerId, uint32_t offerId,
                               uint8_t productType,
                               const std::string & additionalInfo /* ="" */ ) {
	Player * player = getPlayerByID(playerId);
	if (player) {
		const BaseOffer * offer = gameStore.getOfferByOfferId(offerId);

		if (offer == nullptr || offer -> type == DISABLED) {
			player -> sendStoreError(STORE_ERROR_NETWORK, "The offer is either fake or corrupt.");
			return;
		}

		account::Account account;
		account.LoadAccountDB(player -> getAccount());
		uint32_t coins;
		account.GetCoins( & coins);
		if (coins < offer -> price) // player doesnt have enough coins
		{
			player -> sendStoreError(STORE_ERROR_PURCHASE, "You don't have enough coins");
			return;
		}

		std::stringstream message;
		if (offer -> type == ITEM || offer -> type == STACKABLE_ITEM || offer -> type == WRAP_ITEM) {
			const ItemOffer * tmp = (ItemOffer * ) offer;

			message << "You have purchased " << tmp -> count << "x " << offer -> name << " for " << offer -> price << " coins.";

			Thing * thing = player -> getThing(CONST_SLOT_STORE_INBOX);
			if (thing == nullptr) {
				player -> sendStoreError(STORE_ERROR_NETWORK, "We cannot locate your store inbox, try again after relog and if this error persists, contact the system administrator.");
				return;
			}

			Container * inbox = thing -> getItem() -> getContainer(); // TODO: Not the right way to get the storeInbox
			if (!inbox) {
				player -> sendStoreError(STORE_ERROR_NETWORK, "We cannot locate your store inbox, try again after relog and if this error persists, contact the system administrator.");
				return;
			}

			uint32_t freeSlots = inbox -> capacity() - inbox -> size();
			uint32_t requiredSlots = (tmp -> type == ITEM || tmp -> type == WRAP_ITEM) ? tmp -> count : (tmp -> count % 100) ? (uint32_t)(tmp -> count / 100) + 1 : (uint32_t) tmp -> count / 100;
			uint32_t capNeeded = (tmp -> type == WRAP_ITEM) ? 0 : Item::items[tmp -> productId].weight * tmp -> count;
			if (freeSlots < requiredSlots) {
				player -> sendStoreError(STORE_ERROR_PURCHASE, "Insuficient free slots in your store inbox.");
				return;
			} else if (player -> getFreeCapacity() < capNeeded) {
				player -> sendStoreError(STORE_ERROR_PURCHASE, "Not enough cap to carry.");
				return;
			} else {
				uint16_t pendingCount = tmp -> count;
				uint8_t packSize = (offer -> type == STACKABLE_ITEM) ? 100 : 1;
				account.LoadAccountDB(player -> getAccount());
				account.RemoveCoins(offer -> price);
				account.RegisterCoinsTransaction(account::COIN_REMOVE, offer -> price,
					offer -> name);
				while (pendingCount > 0) {
					Item * item;

					if (offer -> type == WRAP_ITEM) {
						item = Item::CreateItem(ITEM_DECORATION_KIT, std::min < uint16_t > (packSize, pendingCount));
						item->setActionId(tmp->productId);
						item->setSpecialDescription("Unwrap it in your own house to create a <" + Item::items[tmp->productId].name + ">.");
					} else {
						item = Item::CreateItem(tmp -> productId, std::min < uint16_t > (packSize, pendingCount));
					}

					if (internalAddItem(inbox, item, INDEX_WHEREEVER, FLAG_NOLIMIT) != RETURNVALUE_NOERROR) {
						delete item;
						player -> sendStoreError(STORE_ERROR_PURCHASE, "We couldn't deliver all the items.\nOnly the delivered ones were charged from you account");
						account.AddCoins((offer -> price * (tmp -> count - pendingCount) / tmp -> count));
						account.RegisterCoinsTransaction(account::COIN_REMOVE,
							offer -> price + (offer -> price * (tmp -> count - pendingCount)) / tmp -> count,
							offer -> name);
						return;
					}
					pendingCount -= std::min < uint16_t > (pendingCount, packSize);
				}

				account.GetCoins( & coins);
				player -> sendStorePurchaseSuccessful(message.str(), coins);
				return;
			}
		} else if (offer -> type == OUTFIT || offer -> type == OUTFIT_ADDON) {
			const OutfitOffer * outfitOffer = (OutfitOffer * ) offer;

			uint16_t looktype = (player -> getSex() == PLAYERSEX_MALE) ? outfitOffer -> maleLookType : outfitOffer -> femaleLookType;
			uint8_t addons = outfitOffer -> addonNumber;

			if (!player -> canWear(looktype, addons)) {
				player -> addOutfit(looktype, addons);
				account.LoadAccountDB(player -> getAccount());
				account.RemoveCoins(offer -> price);
				account.RegisterCoinsTransaction(account::COIN_REMOVE, offer -> price,
					offer -> name);
				message << "You've successfully bought the " << outfitOffer -> name << ".";
				account.GetCoins( & coins);
				player -> sendStorePurchaseSuccessful(message.str(), coins);
				return;
			} else {
				player -> sendStoreError(STORE_ERROR_NETWORK, "This outfit seems not to suit you well, we are sorry for that!");
				return;
			}
		} else if (offer -> type == MOUNT) {
			const MountOffer * mntOffer = (MountOffer * ) offer;
			const Mount * mount = mounts.getMountByID(mntOffer -> mountId);
			if (player -> hasMount(mount)) {
				player -> sendStoreError(STORE_ERROR_PURCHASE, "You arealdy own this mount.");
				return;
			} else {
				account.LoadAccountDB(player -> getAccount());
				account.RemoveCoins(mntOffer -> price);
				if (!player -> tameMount(mount -> id)) {
					account.AddCoins(mntOffer -> price);
					player -> sendStoreError(STORE_ERROR_PURCHASE, "An error ocurred processing your purchase. Try again later.");
					return;
				} else {
					account.RegisterCoinsTransaction(account::COIN_REMOVE, offer -> price,
						offer -> name);
					message << "You've successfully bought the " << mount -> name << " Mount.";
					account.GetCoins( & coins);
					player -> sendStorePurchaseSuccessful(message.str(), coins);
					return;
				}
			}
		} else if (offer -> type == NAMECHANGE) {
			if (productType == SIMPLE) { // client didn't sent the new name yet, request additionalInfo
				player -> sendStoreRequestAdditionalInfo(offer -> id, ADDITIONALINFO);
				return;
			} else {
				Database & db = Database::getInstance();
				std::ostringstream query;
				std::string newName = additionalInfo;
				trimString(newName);

				query << "SELECT `id` FROM `players` WHERE `name`=" << db.escapeString(newName);
				if (db.storeQuery(query.str())) { // name already in use
					message << "This name is already in use.";
					player -> sendStoreError(STORE_ERROR_PURCHASE, message.str());
					return;
				} else {
					query.str("");
					toLowerCaseString(newName);

					std::string responseMessage;
					NameEval_t nameValidation = validateName(newName);

					switch (nameValidation) {
					case INVALID_LENGTH:
						responseMessage = "Your new name must be more than 3 and less than 14 characters long.";
						break;
					case INVALID_TOKEN_LENGTH:
						responseMessage = "Every words of your new name must be at least 2 characters long.";
						break;
					case INVALID_FORBIDDEN:
						responseMessage = "You're using forbidden words in your new name.";
						break;
					case INVALID_CHARACTER:
						responseMessage = "Your new name contains invalid characters.";
						break;
					case INVALID:
						responseMessage = "Your new name is invalid.";
						break;
					case VALID:
						responseMessage = "You have successfully changed you name, you must relog to see changes.";
						break;
					}

					if (nameValidation != VALID) { // invalid name typed
						player -> sendStoreError(STORE_ERROR_PURCHASE, responseMessage);
						return;
					} else { // valid name so far

						// check if it's an NPC or Monster name.

						if (g_monsters().getMonsterType(newName)) {
							responseMessage = "Your new name cannot be a monster's name.";
							player -> sendStoreError(STORE_ERROR_PURCHASE, responseMessage);
							return;
						} else if (g_npcs().getNpcType(newName)) {
							responseMessage = "Your new name cannot be an NPC's name.";
							player -> sendStoreError(STORE_ERROR_PURCHASE, responseMessage);
							return;
						} else {
							capitalizeWords(newName);

							query << "UPDATE `players` SET `name` = " << db.escapeString(newName) << " WHERE `id` = " <<
								player -> getGUID();
							if (db.executeQuery(query.str())) {
								account.LoadAccountDB(player -> getAccount());
								account.RemoveCoins(offer -> price);
								account.RegisterCoinsTransaction(account::COIN_REMOVE,
									offer -> price, offer -> name);
								account.GetCoins( & coins);
								message << "You have successfully changed you name, you must relog to see the changes.";
								player -> sendStorePurchaseSuccessful(message.str(), coins);
								return;
							} else {
								message << "An error ocurred processing your request, no changes were made.";
								player -> sendStoreError(STORE_ERROR_PURCHASE, message.str());
								return;
							}
						}
					}
				}
			}
		} else if (offer -> type == SEXCHANGE) {
			PlayerSex_t playerSex = player -> getSex();
			Outfit_t playerOutfit = player -> getCurrentOutfit();

			message << "Your character is now ";

			for (auto outfit: player -> outfits) { // adding all outfits of the oposite sex.
				const Outfit * opositeSexOutfit = Outfits::getInstance().getOpositeSexOutfitByLookType(playerSex, outfit.lookType);

				if (opositeSexOutfit) {
					player -> addOutfit(opositeSexOutfit -> lookType, 0); // since addons could have different recipes, we can't add automatically
				}
			}

			if (playerSex == PLAYERSEX_FEMALE) {
				player -> setSex(PLAYERSEX_MALE);
				playerOutfit.lookType = 128; // default citizen
				playerOutfit.lookAddons = 0;

				message << "male.";
			} else { //player is male
				player -> setSex(PLAYERSEX_FEMALE);
				playerOutfit.lookType = 136; // default citizen
				playerOutfit.lookAddons = 0;
				message << "female.";
			}
			playerChangeOutfit(player -> getID(), playerOutfit);
			// TODO: add the other sex equivalent outfits player already have in the current sex.
			account.LoadAccountDB(player -> getAccount());
			account.RemoveCoins(offer -> price);
			account.RegisterCoinsTransaction(account::COIN_REMOVE, offer -> price,
				offer -> name);
			account.GetCoins( & coins);
			player -> sendStorePurchaseSuccessful(message.str(), coins);
			return;
		} else if (offer -> type == PROMOTION) {
			if (player -> isPremium() && !player -> isPromoted()) {
				uint16_t promotedId = g_vocations().getPromotedVocation(player -> getVocation() -> getId());

				if (promotedId == VOCATION_NONE || promotedId == player -> getVocation() -> getId()) {
					player -> sendStoreError(STORE_ERROR_PURCHASE, "Your character cannot be promoted.");
					return;
				} else {
					account.LoadAccountDB(player -> getAccount());
					account.RemoveCoins(offer -> price);
					account.RegisterCoinsTransaction(account::COIN_REMOVE,
						offer -> price, offer -> name);
					account.GetCoins( & coins);
					player -> setVocation(promotedId);
					player -> addStorageValue(STORAGEVALUE_PROMOTION, 1);
					message << "You've been promoted! Relog to see the changes.";
					player -> sendStorePurchaseSuccessful(message.str(), coins);
					return;
				}
			} else {
				player -> sendStoreError(STORE_ERROR_PURCHASE, "Your character cannot be promoted.");
				return;
			}
		} else if (offer -> type == PREMIUM_TIME) {
			PremiumTimeOffer * premiumTimeOffer = (PremiumTimeOffer * ) offer;
			account.LoadAccountDB(player -> getAccount());
			account.RemoveCoins(offer -> price);
			account.RegisterCoinsTransaction(account::COIN_REMOVE, offer -> price,
				offer -> name);
			account.GetCoins( & coins);
			player -> setPremiumDays(player -> premiumDays + premiumTimeOffer -> days);
			IOLoginData::addPremiumDays(player -> getAccount(), premiumTimeOffer -> days);
			message << "You've successfully bought " << premiumTimeOffer -> days << " days of premium time.";
			player -> sendStorePurchaseSuccessful(message.str(), coins);
			return;
		} else if (offer -> type == TELEPORT) {
			TeleportOffer * tpOffer = (TeleportOffer * ) offer;
			if (player -> canLogout()) {
				Position toPosition;
				Position fromPosition = player -> getPosition();
				if (tpOffer -> position.x == 0 || tpOffer -> position.y == 0 || tpOffer -> position.z == 0) { //temple teleport
					toPosition = player -> getTemplePosition();
				} else {
					toPosition = tpOffer -> position;
				}

				ReturnValue returnValue = internalTeleport(player, toPosition, false);
				if (returnValue != RETURNVALUE_NOERROR) {
					player -> sendStoreError(STORE_ERROR_PURCHASE, "Your character cannot be teleported there at the moment.");
					return;
				} else {
					account.LoadAccountDB(player -> getAccount());
					account.RemoveCoins(offer -> price);
					account.RegisterCoinsTransaction(account::COIN_REMOVE, offer -> price,
						offer -> name);
					account.GetCoins( & coins);
					addMagicEffect(fromPosition, CONST_ME_POFF);
					addMagicEffect(toPosition, CONST_ME_TELEPORT);
					player -> sendStorePurchaseSuccessful("You've successfully been teleported.", coins);
					return;
				}
			} else {
				player -> sendStoreError(STORE_ERROR_PURCHASE, "Your character has some teleportation block at the moment and cannot be teleported.");
				return;
			}
		} else if (offer -> type == BLESSING) {
			BlessingOffer * blessingOffer = (BlessingOffer * ) offer;

			uint8_t blessingsToAdd = 0;
			for (uint8_t bless: blessingOffer -> blessings) {
				if (player -> hasBlessing(bless)) { // player already has this bless
					message << "Your character already has ";
					message << ((blessingOffer -> blessings.size() > 1) ? "one or more of these blessings." : "this bless.");

					player -> sendStoreError(STORE_ERROR_PURCHASE, message.str());
					return;
				}
				blessingsToAdd = bless;
			}
			account.LoadAccountDB(player -> getAccount());
			account.RemoveCoins(offer -> price);
			account.RegisterCoinsTransaction(account::COIN_REMOVE, offer -> price,
				offer -> name);
			account.GetCoins( & coins);
			player -> addBlessing(blessingsToAdd, 1);
			message << "You've successfully bought the " << offer -> name << ".";
			player -> sendStorePurchaseSuccessful(message.str(), coins);
			return;
		} else {
			// TODO: BOOST_XP and BOOST_STAMINA (the support systems are not yet implemented)
			player -> sendStoreError(STORE_ERROR_INFORMATION, "JLCVP: NOT YET IMPLEMENTED!");
			return;
		}
	}
}

void Game::playerCoinTransfer(uint32_t playerId,
                              const std::string & receiverName, uint32_t amount) {
	Player * sender = getPlayerByID(playerId);
	Player * receiver = getPlayerByName(receiverName);
	std::stringstream message;
	if (!sender) {
		return;
	} else if (!receiver) {
		message << "Player \"" << receiverName << "\" doesn't exist.";
		sender -> sendStoreError(STORE_ERROR_TRANSFER, message.str());
		return;
	} else {

		account::Account sender_account;
		sender_account.LoadAccountDB(sender -> getAccount());
		account::Account receiver_account;
		receiver_account.LoadAccountDB(receiver -> getAccount());
		uint32_t sender_coins;
		sender_account.GetCoins( & sender_coins);

		if (sender -> getAccount() == receiver -> getAccount()) { // sender and receiver are the same
			message << "You cannot send coins to your own account.";
			sender -> sendStoreError(STORE_ERROR_TRANSFER, message.str());
			return;
		} else if (sender_coins < amount) {
			message << "You don't have enough funds to transfer these coins.";
			sender -> sendStoreError(STORE_ERROR_TRANSFER, message.str());
			return;
		} else {

			sender_account.RemoveCoins(amount);
			receiver_account.AddCoins(amount);
			message << "Transfered to " << receiverName;
			sender_account.RegisterCoinsTransaction(account::COIN_REMOVE, amount,
				message.str());

			message.str("");
			message << "Received from" << sender -> name;
			receiver_account.RegisterCoinsTransaction(account::COIN_REMOVE,
				amount, message.str());

			sender_account.GetCoins( & sender_coins);
			message.str("");
			message << "You have successfully transfered " << amount << " coins to " << receiverName << ".";
			sender -> sendStorePurchaseSuccessful(message.str(), sender_coins);
			if (receiver && !receiver -> isOffline()) {
				receiver -> sendCoinBalance();
			}
		}
	}
}

void Game::playerStoreTransactionHistory(uint32_t playerId, uint32_t page)
{
	Player* player = getPlayerByID(playerId);
	if (player) {
		HistoryStoreOfferList list = IOGameStore::getHistoryEntries(player->getAccount(),page);
		if (!list.empty()) {
			player->sendStoreTrasactionHistory(list, page, GameStore::HISTORY_ENTRIES_PER_PAGE);
		} else {
			player->sendStoreError(STORE_ERROR_HISTORY, "You don't have any entries yet.");
		}
	}
}

void Game::parsePlayerExtendedOpcode(uint32_t playerId, uint8_t opcode, const std::string& buffer)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	for (CreatureEvent* creatureEvent : player->getCreatureEvents(CREATURE_EVENT_EXTENDED_OPCODE)) {
		creatureEvent->executeExtendedOpcode(player, opcode, buffer);
	}
}

std::forward_list<Item*> Game::getMarketItemList(uint16_t wareId, uint16_t sufficientCount, DepotLocker* depotLocker)
{
	std::forward_list<Item*> itemList;
	uint16_t count = 0;

	std::list<Container*> containers {depotLocker};
	do {
		Container* container = containers.front();
		containers.pop_front();

		for (Item* item : container->getItemList()) {
			Container* c = item->getContainer();
			if (c && !c->empty()) {
				containers.push_back(c);
				continue;
			}

			const ItemType& itemType = Item::items[item->getID()];
			if (itemType.wareId != wareId) {
				continue;
			}

			if (c && (!itemType.isContainer() || c->capacity() != itemType.maxItems)) {
				continue;
			}

			if (!item->hasMarketAttributes()) {
				continue;
			}

			itemList.push_front(item);

			count += Item::countByType(item, -1);
			if (count >= sufficientCount) {
				return itemList;
			}
		}
	} while (!containers.empty());
	return std::forward_list<Item*>();
}

void Game::forceRemoveCondition(uint32_t creatureId, ConditionType_t conditionType, ConditionId_t conditionId)
{
	Creature* creature = getCreatureByID(creatureId);
	if (!creature) {
		return;
	}

	creature->removeCondition(conditionType, conditionId, true);
}

void Game::sendOfflineTrainingDialog(Player* player)
{
	if (!player) {
		return;
	}

	if (!player->hasModalWindowOpen(offlineTrainingWindow.id)) {
		player->sendModalWindow(offlineTrainingWindow);
	}
}

void Game::playerAnswerModalWindow(uint32_t playerId, uint32_t modalWindowId, uint8_t button, uint8_t choice)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	if (!player->hasModalWindowOpen(modalWindowId)) {
		return;
	}

	player->onModalWindowHandled(modalWindowId);

	// offline training, hardcoded
	if (modalWindowId == std::numeric_limits<uint32_t>::max()) {
		if (button == 1) {
			if (choice == SKILL_SWORD || choice == SKILL_AXE || choice == SKILL_CLUB || choice == SKILL_DISTANCE || choice == SKILL_MAGLEVEL) {
				BedItem* bedItem = player->getBedItem();
				if (bedItem && bedItem->sleep(player)) {
					player->setOfflineTrainingSkill(choice);
					return;
				}
			}
		} else {
			player->sendTextMessage(MESSAGE_EVENT_ADVANCE, "Offline training aborted.");
		}

		player->setBedItem(nullptr);
	} else {
		for (auto creatureEvent : player->getCreatureEvents(CREATURE_EVENT_MODALWINDOW)) {
			creatureEvent->executeModalWindow(player, modalWindowId, button, choice);
		}
	}
}

void Game::updatePlayerSaleItems(uint32_t playerId)
{
	Player* player = getPlayerByID(playerId);
	if (!player) {
		return;
	}

	std::map<uint32_t, uint32_t> tempInventoryMap;
	player->getAllItemTypeCountAndSubtype(tempInventoryMap);

	player->sendSaleItemList(tempInventoryMap);
	player->setScheduledSaleUpdate(false);
}

void Game::addPlayer(Player* player)
{
	const std::string& lowercase_name = asLowerCaseString(player->getName());
	mappedPlayerNames[lowercase_name] = player;
	wildcardTree.insert(lowercase_name);
	players[player->getID()] = player;
}

void Game::removePlayer(Player* player)
{
	const std::string& lowercase_name = asLowerCaseString(player->getName());
	mappedPlayerNames.erase(lowercase_name);
	wildcardTree.remove(lowercase_name);
	players.erase(player->getID());
}

void Game::addNpc(Npc* npc)
{
	npcs[npc->getID()] = npc;
}

void Game::removeNpc(Npc* npc)
{
	npcs.erase(npc->getID());
}

void Game::addMonster(Monster* monster)
{
	monsters[monster->getID()] = monster;
}

void Game::removeMonster(Monster* monster)
{
	monsters.erase(monster->getID());
}

Guild* Game::getGuild(uint32_t id) const
{
	auto it = guilds.find(id);
	if (it == guilds.end()) {
		return nullptr;
	}
	return it->second;
}

void Game::addGuild(Guild* guild)
{
  if (!guild) {
    return;
  }
	guilds[guild->getId()] = guild;
}

void Game::removeGuild(uint32_t guildId)
{
  auto it = guilds.find(guildId);
  if (it != guilds.end()) {
    IOGuild::saveGuild(it->second);
  }
	guilds.erase(guildId);
}

void Game::decreaseBrowseFieldRef(const Position& pos)
{
	Tile* tile = map.getTile(pos.x, pos.y, pos.z);
	if (!tile) {
		return;
	}

	auto it = browseFields.find(tile);
	if (it != browseFields.end()) {
		it->second->decrementReferenceCounter();
	}
}

void Game::internalRemoveItems(std::vector<Item*> itemList, uint32_t amount, bool stackable)
{
	if (stackable) {
		for (Item* item : itemList) {
			if (item->getItemCount() > amount) {
				internalRemoveItem(item, amount);
				break;
			} else {
				amount -= item->getItemCount();
				internalRemoveItem(item);
			}
		}
	} else {
		for (Item* item : itemList) {
			internalRemoveItem(item);
		}
	}
}

BedItem* Game::getBedBySleeper(uint32_t guid) const
{
	auto it = bedSleepersMap.find(guid);
	if (it == bedSleepersMap.end()) {
		return nullptr;
	}
	return it->second;
}

void Game::setBedSleeper(BedItem* bed, uint32_t guid)
{
	bedSleepersMap[guid] = bed;
}

void Game::removeBedSleeper(uint32_t guid)
{
	auto it = bedSleepersMap.find(guid);
	if (it != bedSleepersMap.end()) {
		bedSleepersMap.erase(it);
	}
}

Item* Game::getUniqueItem(uint16_t uniqueId)
{
	auto it = uniqueItems.find(uniqueId);
	if (it == uniqueItems.end()) {
		return nullptr;
	}
	return it->second;
}

bool Game::addUniqueItem(uint16_t uniqueId, Item* item)
{
	auto result = uniqueItems.emplace(uniqueId, item);
	if (!result.second) {
		SPDLOG_WARN("Duplicate unique id: {}", uniqueId);
	}
	return result.second;
}

void Game::removeUniqueItem(uint16_t uniqueId)
{
	auto it = uniqueItems.find(uniqueId);
	if (it != uniqueItems.end()) {
		uniqueItems.erase(it);
	}
}

bool Game::reload(ReloadTypes_t reloadType)
{
	switch (reloadType) {
		case RELOAD_TYPE_MONSTERS: {
			g_scripts().loadScripts("monster", false, true);
			return true;
		}
		case RELOAD_TYPE_NPCS: {
			// Reset informations from npc interface
			g_npc().reset();
			// Reload npc scripts
			g_scripts().loadScripts("npc", false, true);
			// Reload npclib
			g_luaEnvironment.loadFile("data/npclib/load.lua");
			return true;
		}
		case RELOAD_TYPE_CHAT: return g_chat().load();
		case RELOAD_TYPE_CONFIG: return g_configManager().reload();
		case RELOAD_TYPE_EVENTS: return g_events().loadFromXml();
		case RELOAD_TYPE_ITEMS: return Item::items.reload();
		case RELOAD_TYPE_MODULES: return g_modules().reload();
		case RELOAD_TYPE_MOUNTS: return mounts.reload();
		case RELOAD_TYPE_IMBUEMENTS: return g_imbuements().reload();
		case RELOAD_TYPE_RAIDS: return raids.reload() && raids.startup();

		case RELOAD_TYPE_SCRIPTS: {
			// commented out stuff is TODO, once we approach further in revscriptsys
			g_actions().clear(true);
			g_creatureEvents().clear(true);
			g_moveEvents().clear(true);
			g_talkActions().clear(true);
			g_globalEvents().clear(true);
			g_weapons().clear(true);
			g_weapons().loadDefaults();
			g_spells().clear(true);
			// Reset informations from npc interface
			g_npc().reset();
			g_scripts().loadScripts("scripts", false, true);
			// lean up the monsters interface, ensuring that after reloading the scripts there is no use of any deallocated memory
			g_scripts().loadScripts("monster", false, true);
			// Reload npc scripts
			g_scripts().loadScripts("npc", false, true);
			// Reload npclib
			g_luaEnvironment.loadFile("data/npclib/load.lua");
			return true;
		}

		default: {

			g_configManager().reload();
			raids.reload() && raids.startup();
			Item::items.reload();
			g_weapons().clear(true);
			g_weapons().loadDefaults();
			mounts.reload();
			g_events().loadFromXml();
			g_chat().load();
			g_actions().clear(true);
			g_creatureEvents().clear(true);
			g_moveEvents().clear(true);
			g_talkActions().clear(true);
			g_globalEvents().clear(true);
			g_spells().clear(true);
			g_scripts().loadScripts("scripts", false, true);
		}
	}
	return true;
}

bool Game::itemidHasMoveevent(uint32_t itemid)
{
	return g_moveEvents().isRegistered(itemid);
}

bool Game::hasEffect(uint8_t effectId) {
	for (uint8_t i = CONST_ME_NONE; i <= CONST_ME_LAST; i++) {
		MagicEffectClasses effect = static_cast<MagicEffectClasses>(i);
		if (effect == effectId) {
			return true;
		}
	}
	return false;
}

bool Game::hasDistanceEffect(uint8_t effectId) {
	for (uint8_t i = CONST_ANI_NONE; i <= CONST_ANI_LAST; i++) {
		ShootType_t effect = static_cast<ShootType_t>(i);
		if (effect == effectId) {
			return true;
		}
	}
	return false;
}

void Game::createLuaItemsOnMap() {
	for (auto const [position, itemId] : mapLuaItemsStored) {
		Item* item = Item::CreateItem(itemId, 1);
		if (!item) {
			SPDLOG_WARN("[Game::createLuaItemsOnMap] - Cannot create item with id {}", itemId);
			continue;
		}

		if (position.x != 0) {
			Tile* tile = g_game().map.getTile(position);
			if (!tile) {
				SPDLOG_WARN("[Game::createLuaItemsOnMap] - Tile is wrong or not found position: {}", position.toString());
				delete item;
				continue;
			}

			// If the item already exists on the map, then ignore it and send warning
			if (g_game().findItemOfType(tile, itemId, false, -1)) {
				SPDLOG_WARN("[Game::createLuaItemsOnMap] - Cannot create item with id {} on position {}, item already exists", itemId, position.toString());
				continue;
			}

			g_game().internalAddItem(tile, item, INDEX_WHEREEVER, FLAG_NOLIMIT);
		}
	}
}
