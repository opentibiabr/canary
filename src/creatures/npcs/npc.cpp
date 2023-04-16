/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/npcs/npc.h"
#include "creatures/npcs/npcs.h"
#include "declarations.hpp"
#include "game/game.h"
#include "lua/callbacks/creaturecallback.h"

int32_t Npc::despawnRange;
int32_t Npc::despawnRadius;

uint32_t Npc::npcAutoID = 0x80000000;

Npc* Npc::createNpc(const std::string &name) {
	NpcType* npcType = g_npcs().getNpcType(name);
	if (!npcType) {
		return nullptr;
	}
	return new Npc(npcType);
}

Npc::Npc(NpcType* npcType) :
	Creature(),
	strDescription(npcType->nameDescription),
	npcType(npcType) {
	defaultOutfit = npcType->info.outfit;
	currentOutfit = npcType->info.outfit;
	float multiplier = g_configManager().getFloat(RATE_NPC_HEALTH);
	health = npcType->info.health * multiplier;
	healthMax = npcType->info.healthMax * multiplier;
	baseSpeed = npcType->info.baseSpeed;
	internalLight = npcType->info.light;
	floorChange = npcType->info.floorChange;

	// register creature events
	for (const std::string &scriptName : npcType->info.scripts) {
		if (!registerCreatureEvent(scriptName)) {
			SPDLOG_WARN("Unknown event name: {}", scriptName);
		}
	}
}

Npc::~Npc() {
}

void Npc::addList() {
	g_game().addNpc(this);
}

void Npc::removeList() {
	g_game().removeNpc(this);
}

bool Npc::canInteract(const Position &pos) const {
	if (pos.z != getPosition().z) {
		return false;
	}
	return Creature::canSee(getPosition(), pos, 4, 4);
}

void Npc::onCreatureAppear(Creature* creature, bool isLogin) {
	Creature::onCreatureAppear(creature, isLogin);

	if (auto player = creature->getPlayer()) {
		onPlayerAppear(player);
	}

	// onCreatureAppear(self, creature)
	CreatureCallback callback = CreatureCallback(npcType->info.scriptInterface, this);
	if (callback.startScriptInterface(npcType->info.creatureAppearEvent)) {
		callback.pushSpecificCreature(this);
		callback.pushCreature(creature);
	}

	if (callback.persistLuaState()) {
		return;
	}
}

void Npc::onRemoveCreature(Creature* creature, bool isLogout) {
	Creature::onRemoveCreature(creature, isLogout);

	// onCreatureDisappear(self, creature)
	CreatureCallback callback = CreatureCallback(npcType->info.scriptInterface, this);
	if (callback.startScriptInterface(npcType->info.creatureDisappearEvent)) {
		callback.pushSpecificCreature(this);
		callback.pushCreature(creature);
	}

	if (callback.persistLuaState()) {
		return;
	}

	if (auto player = creature->getPlayer()) {
		onPlayerDisappear(player);
	}

	if (spawnNpc) {
		spawnNpc->startSpawnNpcCheck();
	}

	shopPlayerSet.clear();
}

void Npc::onCreatureMove(Creature* creature, const Tile* newTile, const Position &newPos, const Tile* oldTile, const Position &oldPos, bool teleport) {
	Creature::onCreatureMove(creature, newTile, newPos, oldTile, oldPos, teleport);

	// onCreatureMove(self, creature, oldPosition, newPosition)
	CreatureCallback callback = CreatureCallback(npcType->info.scriptInterface, this);
	if (callback.startScriptInterface(npcType->info.creatureMoveEvent)) {
		callback.pushSpecificCreature(this);
		callback.pushCreature(creature);
		callback.pushPosition(oldPos);
		callback.pushPosition(newPos);
	}

	if (callback.persistLuaState()) {
		return;
	}

	if (creature == this && !canInteract(oldPos)) {
		resetPlayerInteractions();
		closeAllShopWindows();
	}

	if (auto player = creature->getPlayer()) {
		handlePlayerMove(player, newPos);
	}
}

void Npc::manageIdle() {
	if (creatureCheck && playerSpectators.empty()) {
		Game::removeCreatureCheck(this);
	} else if (!creatureCheck) {
		g_game().addCreatureCheck(this);
	}
}

void Npc::onPlayerAppear(Player* player) {
	if (player->hasFlag(PlayerFlags_t::IgnoredByNpcs) || playerSpectators.contains(player)) {
		return;
	}
	playerSpectators.insert(player);
	manageIdle();
}

void Npc::onPlayerDisappear(Player* player) {
	removePlayerInteraction(player);
	if (!player->hasFlag(PlayerFlags_t::IgnoredByNpcs) && playerSpectators.contains(player)) {
		playerSpectators.erase(player);
		manageIdle();
	}
}

void Npc::onCreatureSay(Creature* creature, SpeakClasses type, const std::string &text) {
	Creature::onCreatureSay(creature, type, text);

	if (!creature->getPlayer()) {
		return;
	}

	// onCreatureSay(self, creature, type, message)
	CreatureCallback callback = CreatureCallback(npcType->info.scriptInterface, this);
	if (callback.startScriptInterface(npcType->info.creatureSayEvent)) {
		callback.pushSpecificCreature(this);
		callback.pushCreature(creature);
		callback.pushNumber(type);
		callback.pushString(text);
	}

	if (callback.persistLuaState()) {
		return;
	}
}

void Npc::onThinkSound(uint32_t interval) {
	if (npcType->info.soundSpeedTicks == 0) {
		return;
	}

	soundTicks += interval;
	if (soundTicks >= npcType->info.soundSpeedTicks) {
		soundTicks = 0;

		if (!npcType->info.soundVector.empty() && (npcType->info.soundChance >= static_cast<uint32_t>(uniform_random(1, 100)))) {
			auto index = uniform_random(0, npcType->info.soundVector.size() - 1);
			auto convertedSafe = toSafeNumber<uint16_t>(__FUNCTION__, index);
			g_game().sendSingleSoundEffect(this->getPosition(), npcType->info.soundVector[convertedSafe], this);
		}
	}
}

void Npc::onThink(uint32_t interval) {
	Creature::onThink(interval);

	// onThink(self, interval)
	CreatureCallback callback = CreatureCallback(npcType->info.scriptInterface, this);
	if (callback.startScriptInterface(npcType->info.thinkEvent)) {
		callback.pushSpecificCreature(this);
		callback.pushNumber(interval);
	}

	if (callback.persistLuaState()) {
		return;
	}

	if (!npcType->canSpawn(position)) {
		g_game().removeCreature(this);
	}

	if (!isInSpawnRange(position)) {
		g_game().internalTeleport(this, masterPos);
		resetPlayerInteractions();
		closeAllShopWindows();
	}

	if (!playerSpectators.empty()) {
		onThinkYell(interval);
		onThinkWalk(interval);
		onThinkSound(interval);
	}
}

void Npc::onPlayerBuyItem(Player* player, uint16_t itemId, uint8_t subType, uint16_t amount, bool ignore, bool inBackpacks) {
	if (player == nullptr) {
		SPDLOG_ERROR("[Npc::onPlayerBuyItem] - Player is nullptr");
		return;
	}

	// Check if the player not have empty slots
	if (!ignore && player->getFreeBackpackSlots() == 0) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
		return;
	}

	uint32_t shoppingBagPrice = 20;
	uint32_t shoppingBagSlots = 20;
	const ItemType &itemType = Item::items[itemId];
	if (const Tile* tile = ignore ? player->getTile() : nullptr; tile) {
		double slotsNedeed = 0;
		if (itemType.stackable) {
			slotsNedeed = inBackpacks ? std::ceil(std::ceil(static_cast<double>(amount) / 100) / shoppingBagSlots) : std::ceil(static_cast<double>(amount) / 100);
		} else {
			slotsNedeed = inBackpacks ? std::ceil(static_cast<double>(amount) / shoppingBagSlots) : static_cast<double>(amount);
		}

		if ((static_cast<double>(tile->getItemList()->size()) + (slotsNedeed - player->getFreeBackpackSlots())) > 30) {
			player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
			return;
		}
	}

	uint32_t buyPrice = 0;
	const std::vector<ShopBlock> &shopVector = getShopItemVector();
	for (ShopBlock shopBlock : shopVector) {
		if (itemType.id == shopBlock.itemId && shopBlock.itemBuyPrice != 0) {
			buyPrice = shopBlock.itemBuyPrice;
		}
	}

	uint32_t totalCost = buyPrice * amount;
	uint32_t bagsCost = 0;
	if (inBackpacks && itemType.stackable) {
		bagsCost = shoppingBagPrice * static_cast<uint32_t>(std::ceil(std::ceil(static_cast<double>(amount) / 100) / shoppingBagSlots));
	} else if (inBackpacks && !itemType.stackable) {
		bagsCost = shoppingBagPrice * static_cast<uint32_t>(std::ceil(static_cast<double>(amount) / shoppingBagSlots));
	}

	if (getCurrency() == ITEM_GOLD_COIN && (player->getMoney() + player->getBankBalance()) < totalCost) {
		SPDLOG_ERROR("[Npc::onPlayerBuyItem (getMoney)] - Player {} have a problem for buy item {} on shop for npc {}", player->getName(), itemId, getName());
		SPDLOG_DEBUG("[Information] Player {} tried to buy item {} on shop for npc {}, at position {}", player->getName(), itemId, getName(), player->getPosition().toString());
		return;
	} else if (getCurrency() != ITEM_GOLD_COIN && (player->getItemTypeCount(getCurrency()) < totalCost || ((player->getMoney() + player->getBankBalance()) < bagsCost))) {
		SPDLOG_ERROR("[Npc::onPlayerBuyItem (getItemTypeCount)] - Player {} have a problem for buy item {} on shop for npc {}", player->getName(), itemId, getName());
		SPDLOG_DEBUG("[Information] Player {} tried to buy item {} on shop for npc {}, at position {}", player->getName(), itemId, getName(), player->getPosition().toString());
		return;
	}

	// npc:onBuyItem(player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	CreatureCallback callback = CreatureCallback(npcType->info.scriptInterface, this);
	if (callback.startScriptInterface(npcType->info.playerBuyEvent)) {
		callback.pushSpecificCreature(this);
		callback.pushCreature(player);
		callback.pushNumber(itemId);
		callback.pushNumber(subType);
		callback.pushNumber(amount);
		callback.pushBoolean(ignore);
		callback.pushBoolean(inBackpacks);
		callback.pushNumber(totalCost);
	}

	if (callback.persistLuaState()) {
		return;
	}
}

void Npc::onPlayerSellItem(Player* player, uint16_t itemId, uint8_t subType, uint16_t amount, bool ignore) {
	if (!player) {
		return;
	}

	uint32_t sellPrice = 0;
	const ItemType &itemType = Item::items[itemId];
	const std::vector<ShopBlock> &shopVector = getShopItemVector();
	for (ShopBlock shopBlock : shopVector) {
		if (itemType.id == shopBlock.itemId && shopBlock.itemSellPrice != 0) {
			sellPrice = shopBlock.itemSellPrice;
		}
	}

	auto toRemove = amount;
	for (auto inventoryItems = player->getInventoryItemsFromId(itemId, ignore); auto item : inventoryItems) {
		if (!item || item->getTier() > 0 || item->hasImbuements()) {
			continue;
		}

		auto removeCount = std::min<uint16_t>(toRemove, item->getItemCount());

		if (g_game().internalRemoveItem(item, removeCount) != RETURNVALUE_NOERROR) {
			SPDLOG_ERROR("[Npc::onPlayerSellItem] - Player {} have a problem for sell item {} on shop for npc {}", player->getName(), item->getID(), getName());
			continue;
		}

		toRemove -= removeCount;
		if (toRemove == 0) {
			break;
		}
	}

	if (toRemove != 0) {
		SPDLOG_ERROR("[Npc::onPlayerSellItem] - Problem while removing items from player {} amount {} of items with id {} on shop for npc {}, the payment will be made based on amount of removed items.", player->getName(), toRemove, itemId, getName());
	}

	auto totalRemoved = amount - toRemove;
	auto totalCost = static_cast<uint64_t>(sellPrice * totalRemoved);
	g_game().addMoney(player, totalCost);

	// npc:onSellItem(player, itemId, subType, amount, ignore, itemName, totalCost)
	CreatureCallback callback = CreatureCallback(npcType->info.scriptInterface, this);
	if (callback.startScriptInterface(npcType->info.playerSellEvent)) {
		callback.pushSpecificCreature(this);
		callback.pushCreature(player);
		callback.pushNumber(itemType.id);
		callback.pushNumber(subType);
		callback.pushNumber(totalRemoved);
		callback.pushBoolean(ignore);
		callback.pushString(itemType.name);
		callback.pushNumber(totalCost);
	}

	if (callback.persistLuaState()) {
		return;
	}
}

void Npc::onPlayerCheckItem(Player* player, uint16_t itemId, uint8_t subType) {
	if (!player) {
		return;
	}

	const ItemType &itemType = Item::items[itemId];
	// onPlayerCheckItem(self, player, itemId, subType)
	CreatureCallback callback = CreatureCallback(npcType->info.scriptInterface, this);
	if (callback.startScriptInterface(npcType->info.playerLookEvent)) {
		callback.pushSpecificCreature(this);
		callback.pushCreature(player);
		callback.pushNumber(itemId);
		callback.pushNumber(subType);
	}

	if (callback.persistLuaState()) {
		return;
	}
}

void Npc::onPlayerCloseChannel(Creature* creature) {
	Player* player = creature->getPlayer();
	if (!player) {
		return;
	}

	// onPlayerCloseChannel(npc, player)
	CreatureCallback callback = CreatureCallback(npcType->info.scriptInterface, this);
	if (callback.startScriptInterface(npcType->info.playerCloseChannel)) {
		callback.pushSpecificCreature(this);
		callback.pushCreature(player);
	}

	if (callback.persistLuaState()) {
		return;
	}

	removePlayerInteraction(player);
}

void Npc::onThinkYell(uint32_t interval) {
	if (npcType->info.yellSpeedTicks == 0) {
		return;
	}

	yellTicks += interval;
	if (yellTicks >= npcType->info.yellSpeedTicks) {
		yellTicks = 0;

		if (!npcType->info.voiceVector.empty() && (npcType->info.yellChance >= static_cast<uint32_t>(uniform_random(1, 100)))) {
			auto index = uniform_random(0, static_cast<int64_t>(npcType->info.voiceVector.size() - 1));
			auto convertedSafe = toSafeNumber<uint16_t>(__FUNCTION__, index);
			const voiceBlock_t &vb = npcType->info.voiceVector[convertedSafe];

			if (vb.yellText) {
				g_game().internalCreatureSay(this, TALKTYPE_YELL, vb.text, false);
			} else {
				g_game().internalCreatureSay(this, TALKTYPE_SAY, vb.text, false);
			}
		}
	}
}

void Npc::onThinkWalk(uint32_t interval) {
	if (npcType->info.walkInterval == 0 || baseSpeed == 0) {
		return;
	}

	// If talking, no walking
	if (playerInteractions.size() > 0) {
		walkTicks = 0;
		eventWalk = 0;
		return;
	}

	walkTicks += interval;
	if (walkTicks < npcType->info.walkInterval) {
		return;
	}

	if (Direction newDirection;
		getRandomStep(newDirection)) {
		listWalkDir.push_front(newDirection);
		addEventWalk();
	}

	walkTicks = 0;
}

void Npc::onCreatureWalk() {
	Creature::onCreatureWalk();
	phmap::erase_if(playerSpectators, [this](const auto &creature) { return !this->canSee(creature->getPosition()); });
}

void Npc::onPlacedCreature() {
	loadPlayerSpectators();
}

void Npc::loadPlayerSpectators() {
	SpectatorHashSet spec;
	g_game().map.getSpectators(spec, position, true, true);
	for (auto creature : spec) {
		if (creature->getPlayer() || creature->getPlayer()->hasFlag(PlayerFlags_t::IgnoredByNpcs)) {
			playerSpectators.insert(creature);
		}
	}
}

bool Npc::isInSpawnRange(const Position &pos) const {
	if (!spawnNpc) {
		return true;
	}

	if (Npc::despawnRadius == 0) {
		return true;
	}

	if (!SpawnsNpc::isInZone(masterPos, Npc::despawnRadius, pos)) {
		return false;
	}

	if (Npc::despawnRange == 0) {
		return true;
	}

	if (Position::getDistanceZ(pos, masterPos) > Npc::despawnRange) {
		return false;
	}

	return true;
}

void Npc::setPlayerInteraction(uint32_t playerId, uint16_t topicId /*= 0*/) {
	Creature* creature = g_game().getCreatureByID(playerId);
	if (!creature) {
		return;
	}

	turnToCreature(creature);

	playerInteractions[playerId] = topicId;
}

void Npc::removePlayerInteraction(Player* player) {
	if (playerInteractions.contains(player->getID())) {
		playerInteractions.erase(player->getID());
		player->closeShopWindow(true);
	}
}

void Npc::resetPlayerInteractions() {
	playerInteractions.clear();
}

bool Npc::canWalkTo(const Position &fromPos, Direction dir) const {
	if (npcType->info.walkRadius == 0) {
		return false;
	}

	Position toPos = getNextPosition(dir, fromPos);
	if (!SpawnsNpc::isInZone(masterPos, npcType->info.walkRadius, toPos)) {
		return false;
	}

	const Tile* toTile = g_game().map.getTile(toPos);
	if (!toTile || toTile->queryAdd(0, *this, 1, 0) != RETURNVALUE_NOERROR) {
		return false;
	}

	if (!floorChange && (toTile->hasFlag(TILESTATE_FLOORCHANGE) || toTile->getTeleportItem())) {
		return false;
	}

	if (!ignoreHeight && toTile->hasHeight(1)) {
		return false;
	}

	return true;
}

bool Npc::getNextStep(Direction &nextDirection, uint32_t &flags) {
	return Creature::getNextStep(nextDirection, flags);
}

bool Npc::getRandomStep(Direction &moveDirection) const {
	static std::vector<Direction> directionvector {
		Direction::DIRECTION_NORTH,
		Direction::DIRECTION_WEST,
		Direction::DIRECTION_EAST,
		Direction::DIRECTION_SOUTH
	};
	std::ranges::shuffle(directionvector, getRandomGenerator());

	for (const Position &creaturePos = getPosition();
		 Direction direction : directionvector) {
		if (canWalkTo(creaturePos, direction)) {
			moveDirection = direction;
			return true;
		}
	}
	return false;
}

void Npc::addShopPlayer(Player* player) {
	shopPlayerSet.insert(player);
}

void Npc::removeShopPlayer(Player* player) {
	if (player) {
		shopPlayerSet.erase(player);
	}
}

void Npc::closeAllShopWindows() {
	for (auto shopPlayer : shopPlayerSet) {
		if (shopPlayer) {
			shopPlayer->closeShopWindow();
		}
	}
	shopPlayerSet.clear();
}

void Npc::handlePlayerMove(Player* player, const Position &newPos) {
	if (!canInteract(newPos)) {
		removePlayerInteraction(player);
	}
	if (canSee(newPos)) {
		onPlayerAppear(player);
	} else {
		onPlayerDisappear(player);
	}
}
