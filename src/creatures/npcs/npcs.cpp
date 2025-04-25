/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/npcs/npcs.hpp"

#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "lua/scripts/luascript.hpp"
#include "lua/scripts/scripts.hpp"
#include "lib/di/container.hpp"

NpcType::NpcType(const std::string &initName) :
	name(initName), m_lowerName(asLowerCaseString(initName)), typeName(initName), nameDescription(initName) {};

bool NpcType::canSpawn(const Position &pos) const {
	bool canSpawn = true;
	const bool isDay = g_game().gameIsDay();

	if ((isDay && info.respawnType.period == RESPAWNPERIOD_NIGHT) || (!isDay && info.respawnType.period == RESPAWNPERIOD_DAY)) {
		// It will ignore day and night if underground
		canSpawn = (pos.z > MAP_INIT_SURFACE_LAYER && info.respawnType.underground);
	}

	return canSpawn;
}

bool NpcType::loadCallback(LuaScriptInterface* scriptInterface) {
	const int32_t id = scriptInterface->getEvent();
	if (id == -1) {
		g_logger().warn("[NpcType::loadCallback] - Event not found");
		return false;
	}

	info.scriptInterface = scriptInterface;
	switch (info.eventType) {
		case NPCS_EVENT_THINK:
			info.thinkEvent = id;
			break;
		case NPCS_EVENT_APPEAR:
			info.creatureAppearEvent = id;
			break;
		case NPCS_EVENT_DISAPPEAR:
			info.creatureDisappearEvent = id;
			break;
		case NPCS_EVENT_MOVE:
			info.creatureMoveEvent = id;
			break;
		case NPCS_EVENT_SAY:
			info.creatureSayEvent = id;
			break;
		case NPCS_EVENT_PLAYER_BUY:
			info.playerBuyEvent = id;
			break;
		case NPCS_EVENT_PLAYER_SELL:
			info.playerSellEvent = id;
			break;
		case NPCS_EVENT_PLAYER_CHECK_ITEM:
			info.playerLookEvent = id;
			break;
		case NPCS_EVENT_PLAYER_CLOSE_CHANNEL:
			info.playerCloseChannel = id;
			break;
		default:
			break;
	}

	return true;
}

void NpcType::loadShop(const std::shared_ptr<NpcType> &npcType, ShopBlock shopBlock) {
	ItemType &iType = Item::items.getItemType(shopBlock.itemId);

	// Registering item prices globaly.
	if (shopBlock.itemSellPrice > iType.sellPrice) {
		iType.sellPrice = shopBlock.itemSellPrice;
	}
	if (shopBlock.itemBuyPrice > iType.buyPrice) {
		iType.buyPrice = shopBlock.itemBuyPrice;
	}

	// Check if the item already exists in the shop vector and ignore it
	if (std::ranges::any_of(npcType->info.shopItemVector, [&shopBlock](const auto &shopIterator) {
			return shopIterator == shopBlock;
		})) {
		return;
	}

	if (shopBlock.childShop.empty()) {
		const bool &isContainer = iType.isContainer();
		if (isContainer) {
			for (const ShopBlock &child : shopBlock.childShop) {
				shopBlock.childShop.push_back(child);
			}
		}
	}
	npcType->info.shopItemVector.emplace_back(shopBlock);

	info.speechBubble = SPEECHBUBBLE_TRADE;
}

bool Npcs::load(bool loadLibs /* = true*/, bool loadNpcs /* = true*/, bool reloading /* = false*/) const {
	if (loadLibs) {
		const auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
		return g_luaEnvironment().loadFile(coreFolder + "/npclib/load.lua", "load.lua") == 0;
	}
	if (loadNpcs) {
		const auto datapackFolder = g_configManager().getString(DATA_DIRECTORY);
		return g_scripts().loadScripts(datapackFolder + "/npc", false, reloading);
	}
	return false;
}

bool Npcs::reload() {
	// Load the "npclib" folder
	if (load(true, false, true)) {
		// Load the npcs scripts folder
		if (!load(false, true, true)) {
			return false;
		}

		npcs.clear();
		scriptInterface.reset();
		g_game().resetNpcs();
		return true;
	}
	return false;
}

Npcs &Npcs::getInstance() {
	return inject<Npcs>();
}

std::shared_ptr<NpcType> Npcs::getNpcType(const std::string &name, bool create /* = false*/) {
	const std::string key = asLowerCaseString(name);
	auto it = npcs.find(key);

	if (it != npcs.end()) {
		return it->second;
	}

	return create ? npcs[key] = std::make_shared<NpcType>(name) : nullptr;
}
