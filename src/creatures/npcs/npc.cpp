/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/npcs/npc.hpp"

#include "config/configmanager.hpp"
#include "creatures/creature.hpp"
#include "creatures/npcs/npcs.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "lib/metrics/metrics.hpp"
#include "lua/callbacks/creaturecallback.hpp"
#include "lua/global/shared_object.hpp"
#include "map/spectators.hpp"

int32_t Npc::despawnRange;
int32_t Npc::despawnRadius;

uint32_t Npc::npcAutoID = 0x80000000;

std::shared_ptr<Npc> Npc::createNpc(const std::string &name) {
	const auto &npcType = g_npcs().getNpcType(name);
	if (!npcType) {
		return nullptr;
	}
	return std::make_shared<Npc>(npcType);
}

Npc::Npc(const std::shared_ptr<NpcType> &npcType) :
	Creature(),
	strDescription(npcType->nameDescription),
	npcType(npcType) {
	defaultOutfit = npcType->info.outfit;
	currentOutfit = npcType->info.outfit;
	const float multiplier = g_configManager().getFloat(RATE_NPC_HEALTH);
	health = npcType->info.health * multiplier;
	healthMax = npcType->info.healthMax * multiplier;
	baseSpeed = npcType->info.baseSpeed;
	internalLight = npcType->info.light;
	floorChange = npcType->info.floorChange;

	// register creature events
	for (const std::string &scriptName : npcType->info.scripts) {
		if (!registerCreatureEvent(scriptName)) {
			g_logger().warn("Unknown event name: {}", scriptName);
		}
	}
}

Npc &Npc::getInstance() {
	return inject<Npc>();
}

std::shared_ptr<Npc> Npc::getNpc() {
	return static_self_cast<Npc>();
}

std::shared_ptr<const Npc> Npc::getNpc() const {
	return static_self_cast<Npc>();
}

void Npc::setID() {
	if (id == 0) {
		id = npcAutoID++;
	}
}

void Npc::addList() {
	g_game().addNpc(static_self_cast<Npc>());
}

const std::string &Npc::getName() const {
	return npcType->name;
}

// Real npc name, set on npc creation "createNpcType(typeName)"
const std::string &Npc::getTypeName() const {
	return npcType->typeName;
}

const std::string &Npc::getNameDescription() const {
	return npcType->nameDescription;
}

std::string Npc::getDescription(int32_t) {
	return strDescription + '.';
}

void Npc::setName(std::string newName) const {
	npcType->name = std::move(newName);
}

const std::string &Npc::getLowerName() const {
	return npcType->m_lowerName;
}

CreatureType_t Npc::getType() const {
	return CREATURETYPE_NPC;
}

const Position &Npc::getMasterPos() const {
	return masterPos;
}

void Npc::setMasterPos(Position pos) {
	masterPos = pos;
}

uint8_t Npc::getSpeechBubble() const {
	return npcType->info.speechBubble;
}

void Npc::setSpeechBubble(const uint8_t bubble) const {
	npcType->info.speechBubble = bubble;
}

uint16_t Npc::getCurrency() const {
	return npcType->info.currencyId;
}

void Npc::setCurrency(uint16_t currency) {
	npcType->info.currencyId = currency;
}

const std::vector<ShopBlock> &Npc::getShopItemVector(uint32_t playerGUID) const {
	if (playerGUID != 0) {
		auto it = shopPlayers.find(playerGUID);
		if (it != shopPlayers.end() && !it->second.empty()) {
			return it->second;
		}
	}

	return npcType->info.shopItemVector;
}

bool Npc::isPushable() {
	return npcType->info.pushable;
}

bool Npc::isAttackable() const {
	return false;
}

void Npc::removeList() {
	g_game().removeNpc(static_self_cast<Npc>());
}

bool Npc::canInteract(const Position &pos, uint32_t range /* = 4 */) {
	if (pos.z != getPosition().z) {
		return false;
	}
	return Creature::canSee(getPosition(), pos, range, range);
}

bool Npc::canSeeInvisibility() const {
	return true;
}

RespawnType Npc::getRespawnType() const {
	return npcType->info.respawnType;
}

void Npc::setSpawnNpc(const std::shared_ptr<SpawnNpc> &newSpawn) {
	spawnNpc = newSpawn;
}

bool Npc::isInteractingWithPlayer(uint32_t playerId) {
	if (playerInteractions.empty()) {
		return false;
	}

	if (!playerInteractions.contains(playerId)) {
		return false;
	}
	return true;
}

bool Npc::isPlayerInteractingOnTopic(uint32_t playerId, uint16_t topicId) {
	if (playerInteractions.empty()) {
		return false;
	}

	auto it = playerInteractions.find(playerId);
	if (it == playerInteractions.end()) {
		return false;
	}
	return it->second == topicId;
}

void Npc::onCreatureAppear(const std::shared_ptr<Creature> &creature, bool isLogin) {
	Creature::onCreatureAppear(creature, isLogin);

	if (const auto &player = creature->getPlayer()) {
		onPlayerAppear(player);
	}

	// onCreatureAppear(self, creature)
	auto callback = CreatureCallback(npcType->info.scriptInterface, getNpc());
	if (callback.startScriptInterface(npcType->info.creatureAppearEvent)) {
		callback.pushSpecificCreature(static_self_cast<Npc>());
		callback.pushCreature(creature);
	}

	if (callback.persistLuaState()) {
		return;
	}
}

void Npc::onRemoveCreature(const std::shared_ptr<Creature> &creature, bool isLogout) {
	Creature::onRemoveCreature(creature, isLogout);

	// onCreatureDisappear(self, creature)
	auto callback = CreatureCallback(npcType->info.scriptInterface, getNpc());
	if (callback.startScriptInterface(npcType->info.creatureDisappearEvent)) {
		callback.pushSpecificCreature(static_self_cast<Npc>());
		callback.pushCreature(creature);
	}

	if (callback.persistLuaState()) {
		return;
	}

	if (const auto &player = creature->getPlayer()) {
		removeShopPlayer(player->getGUID());
		onPlayerDisappear(player);
	}

	if (spawnNpc) {
		spawnNpc->startSpawnNpcCheck();
	}
}

void Npc::onCreatureMove(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &newTile, const Position &newPos, const std::shared_ptr<Tile> &oldTile, const Position &oldPos, bool teleport) {
	Creature::onCreatureMove(creature, newTile, newPos, oldTile, oldPos, teleport);

	// onCreatureMove(self, creature, oldPosition, newPosition)
	auto callback = CreatureCallback(npcType->info.scriptInterface, getNpc());
	if (callback.startScriptInterface(npcType->info.creatureMoveEvent)) {
		callback.pushSpecificCreature(static_self_cast<Npc>());
		callback.pushCreature(creature);
		callback.pushPosition(oldPos);
		callback.pushPosition(newPos);
	}

	if (callback.persistLuaState()) {
		return;
	}

	if (creature == getNpc() && !canInteract(oldPos)) {
		resetPlayerInteractions();
		closeAllShopWindows();
	}

	if (const auto &player = creature->getPlayer()) {
		handlePlayerMove(player, newPos);
	}
}

void Npc::manageIdle() {
	if (creatureCheck && playerSpectators.empty()) {
		Game::removeCreatureCheck(static_self_cast<Npc>());
	} else if (!creatureCheck) {
		g_game().addCreatureCheck(static_self_cast<Npc>());
	}
}

void Npc::onPlayerAppear(const std::shared_ptr<Player> &player) {
	if (player->hasFlag(PlayerFlags_t::IgnoredByNpcs) || playerSpectators.contains(player)) {
		return;
	}
	playerSpectators.emplace(player);
	manageIdle();
}

void Npc::onPlayerDisappear(const std::shared_ptr<Player> &player) {
	removePlayerInteraction(player);
	if (!player->hasFlag(PlayerFlags_t::IgnoredByNpcs) && playerSpectators.contains(player)) {
		playerSpectators.erase(player);
		manageIdle();
	}
}

void Npc::onCreatureSay(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text) {
	Creature::onCreatureSay(creature, type, text);

	if (!creature->getPlayer()) {
		return;
	}

	// onCreatureSay(self, creature, type, message)
	auto callback = CreatureCallback(npcType->info.scriptInterface, getNpc());
	if (callback.startScriptInterface(npcType->info.creatureSayEvent)) {
		callback.pushSpecificCreature(static_self_cast<Npc>());
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
			const auto index = uniform_random(0, npcType->info.soundVector.size() - 1);
			g_game().sendSingleSoundEffect(static_self_cast<Npc>()->getPosition(), npcType->info.soundVector[index], getNpc());
		}
	}
}

void Npc::onThink(uint32_t interval) {
	Creature::onThink(interval);

	// onThink(self, interval)
	auto callback = CreatureCallback(npcType->info.scriptInterface, getNpc());
	if (callback.startScriptInterface(npcType->info.thinkEvent)) {
		callback.pushSpecificCreature(static_self_cast<Npc>());
		callback.pushNumber(interval);
	}

	if (callback.persistLuaState()) {
		return;
	}

	if (!npcType->canSpawn(position)) {
		g_game().removeCreature(static_self_cast<Npc>());
	}

	if (!isInSpawnRange(position)) {
		g_game().internalTeleport(static_self_cast<Npc>(), masterPos);
		resetPlayerInteractions();
		closeAllShopWindows();
	}

	if (!playerSpectators.empty()) {
		onThinkYell(interval);
		onThinkWalk(interval);
		onThinkSound(interval);
	}
}

void Npc::onPlayerBuyItem(const std::shared_ptr<Player> &player, uint16_t itemId, uint8_t subType, uint16_t amount, bool ignore, bool inBackpacks) {
	if (player == nullptr) {
		g_logger().error("[Npc::onPlayerBuyItem] - Player is nullptr");
		return;
	}

	// Check if the player not have empty slots or the item is not a container
	if (!ignore && (player->getFreeBackpackSlots() == 0 && (player->getInventoryItem(CONST_SLOT_BACKPACK) || (!Item::items[itemId].isContainer() || !(Item::items[itemId].slotPosition & SLOTP_BACKPACK))))) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
		return;
	}

	constexpr uint32_t shoppingBagPrice = 20;
	constexpr uint32_t shoppingBagSlots = 20;
	const ItemType &itemType = Item::items[itemId];
	if (const std::shared_ptr<Tile> &tile = ignore ? player->getTile() : nullptr; tile) {
		double slotsNedeed;
		if (itemType.stackable) {
			slotsNedeed = inBackpacks ? std::ceil(std::ceil(static_cast<double>(amount) / itemType.stackSize) / shoppingBagSlots) : std::ceil(static_cast<double>(amount) / itemType.stackSize);
		} else {
			slotsNedeed = inBackpacks ? std::ceil(static_cast<double>(amount) / shoppingBagSlots) : static_cast<double>(amount);
		}

		if ((static_cast<double>(tile->getItemList()->size()) + (slotsNedeed - player->getFreeBackpackSlots())) > 30) {
			player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
			return;
		}
	}

	uint32_t buyPrice = 0;
	const auto &shopVector = getShopItemVector(player->getGUID());
	for (const ShopBlock &shopBlock : shopVector) {
		if (itemType.id == shopBlock.itemId && shopBlock.itemBuyPrice != 0) {
			buyPrice = shopBlock.itemBuyPrice;
		}
	}

	const uint32_t totalCost = buyPrice * amount;
	uint32_t bagsCost = 0;
	if (inBackpacks && itemType.stackable) {
		bagsCost = shoppingBagPrice * static_cast<uint32_t>(std::ceil(std::ceil(static_cast<double>(amount) / itemType.stackSize) / shoppingBagSlots));
	} else if (inBackpacks && !itemType.stackable) {
		bagsCost = shoppingBagPrice * static_cast<uint32_t>(std::ceil(static_cast<double>(amount) / shoppingBagSlots));
	}

	if (getCurrency() == ITEM_GOLD_COIN && (player->getMoney() + player->getBankBalance()) < totalCost) {
		g_logger().error("[Npc::onPlayerBuyItem (getMoney)] - Player {} have a problem for buy item {} on shop for npc {}", player->getName(), itemId, getName());
		g_logger().debug("[Information] Player {} tried to buy item {} on shop for npc {}, at position {}", player->getName(), itemId, getName(), player->getPosition().toString());
		g_metrics().addCounter("balance_decrease", totalCost, { { "player", player->getName() }, { "context", "npc_purchase" } });
		return;
	} else if (getCurrency() != ITEM_GOLD_COIN && (player->getItemTypeCount(getCurrency()) < totalCost || ((player->getMoney() + player->getBankBalance()) < bagsCost))) {
		g_logger().error("[Npc::onPlayerBuyItem (getItemTypeCount)] - Player {} have a problem for buy item {} on shop for npc {}", player->getName(), itemId, getName());
		g_logger().debug("[Information] Player {} tried to buy item {} on shop for npc {}, at position {}", player->getName(), itemId, getName(), player->getPosition().toString());
		return;
	}

	// npc:onBuyItem(player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	auto callback = CreatureCallback(npcType->info.scriptInterface, getNpc());
	if (callback.startScriptInterface(npcType->info.playerBuyEvent)) {
		callback.pushSpecificCreature(static_self_cast<Npc>());
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

void Npc::onPlayerSellItem(const std::shared_ptr<Player> &player, uint16_t itemId, uint8_t subType, uint16_t amount, bool ignore) {
	uint64_t totalPrice = 0;
	onPlayerSellItem(player, itemId, subType, amount, ignore, totalPrice);
}

void Npc::onPlayerSellAllLoot(uint32_t playerId, uint16_t itemId, bool ignore, uint64_t totalPrice) {
	const auto &player = g_game().getPlayerByID(playerId);
	if (!player) {
		return;
	}
	if (itemId == ITEM_GOLD_POUCH) {
		const auto &container = player->getLootPouch();
		if (!container) {
			return;
		}
		bool hasMore = false;
		uint64_t toSellCount = 0;
		phmap::flat_hash_map<uint16_t, uint16_t> toSell;
		for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
			if (toSellCount >= 500) {
				hasMore = true;
				break;
			}
			const auto &item = *it;
			if (!item) {
				continue;
			}
			toSell[item->getID()] += item->getItemAmount();
			if (item->isStackable()) {
				toSellCount++;
			} else {
				toSellCount += item->getItemAmount();
			}
		}
		for (const auto &[m_itemId, amount] : toSell) {
			onPlayerSellItem(player, m_itemId, 0, amount, ignore, totalPrice, container);
		}
		auto ss = std::stringstream();
		if (totalPrice == 0) {
			ss << "You have no items in your loot pouch.";
			player->sendTextMessage(MESSAGE_TRANSACTION, ss.str());
			return;
		}
		if (hasMore) {
			g_dispatcher().scheduleEvent(
				SCHEDULER_MINTICKS, [this, playerId = player->getID(), itemId, ignore, totalPrice] { onPlayerSellAllLoot(playerId, itemId, ignore, totalPrice); }, __FUNCTION__
			);
			return;
		}
		ss << "You sold all of the items from your loot pouch for ";
		ss << totalPrice << " gold.";
		player->sendTextMessage(MESSAGE_TRANSACTION, ss.str());
		player->openPlayerContainers();
	}
}

void Npc::onPlayerSellItem(const std::shared_ptr<Player> &player, uint16_t itemId, uint8_t subType, uint16_t amount, bool ignore, uint64_t &totalPrice, const std::shared_ptr<Cylinder> &parent /*= nullptr*/) {
	if (!player) {
		return;
	}
	if (itemId == ITEM_GOLD_POUCH) {
		g_dispatcher().scheduleEvent(
			SCHEDULER_MINTICKS, [this, playerId = player->getID(), itemId, ignore] { onPlayerSellAllLoot(playerId, itemId, ignore, 0); }, __FUNCTION__
		);
		return;
	}

	uint32_t sellPrice = 0;
	const ItemType &itemType = Item::items[itemId];
	const auto &shopVector = getShopItemVector(player->getGUID());
	for (const ShopBlock &shopBlock : shopVector) {
		if (itemType.id == shopBlock.itemId && shopBlock.itemSellPrice != 0) {
			sellPrice = shopBlock.itemSellPrice;
		}
	}
	if (sellPrice == 0) {
		return;
	}

	auto toRemove = amount;
	for (const auto &item : player->getInventoryItemsFromId(itemId, ignore)) {
		if (!item || item->getTier() > 0 || item->hasImbuements()) {
			continue;
		}

		if (const auto &container = item->getContainer()) {
			if (container->size() > 0) {
				player->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must empty the container before selling it.");
				continue;
			}
		}

		if (parent && item->getParent() != parent) {
			continue;
		}

		if (!item->hasMarketAttributes()) {
			continue;
		}

		auto removeCount = std::min<uint16_t>(toRemove, item->getItemCount());

		if (g_game().internalRemoveItem(item, removeCount) != RETURNVALUE_NOERROR) {
			g_logger().error("[Npc::onPlayerSellItem] - Player {} have a problem for sell item {} on shop for npc {}", player->getName(), item->getID(), getName());
			continue;
		}

		toRemove -= removeCount;
		if (toRemove == 0) {
			break;
		}
	}

	auto totalRemoved = amount - toRemove;
	if (totalRemoved == 0) {
		return;
	}

	auto totalCost = static_cast<uint64_t>(sellPrice * totalRemoved);
	g_logger().debug("[Npc::onPlayerSellItem] - Removing items from player {} amount {} of items with id {} on shop for npc {}", player->getName(), toRemove, itemId, getName());
	if (totalRemoved > 0 && totalCost > 0) {
		if (getCurrency() == ITEM_GOLD_COIN) {
			totalPrice += totalCost;
			if (g_configManager().getBoolean(AUTOBANK)) {
				player->setBankBalance(player->getBankBalance() + totalCost);
			} else {
				g_game().addMoney(player, totalCost);
			}
			g_metrics().addCounter("balance_increase", totalCost, { { "player", player->getName() }, { "context", "npc_sale" } });
		} else {
			const auto &newItem = Item::CreateItem(getCurrency(), totalCost);
			if (newItem) {
				g_game().internalPlayerAddItem(player, newItem, true);
			}
		}
	}

	// npc:onSellItem(player, itemId, subType, amount, ignore, itemName, totalCost)
	auto callback = CreatureCallback(npcType->info.scriptInterface, getNpc());
	if (callback.startScriptInterface(npcType->info.playerSellEvent)) {
		callback.pushSpecificCreature(static_self_cast<Npc>());
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

void Npc::onPlayerCheckItem(const std::shared_ptr<Player> &player, uint16_t itemId, uint8_t subType) {
	if (!player) {
		return;
	}

	// onPlayerCheckItem(self, player, itemId, subType)
	auto callback = CreatureCallback(npcType->info.scriptInterface, getNpc());
	if (callback.startScriptInterface(npcType->info.playerLookEvent)) {
		callback.pushSpecificCreature(static_self_cast<Npc>());
		callback.pushCreature(player);
		callback.pushNumber(itemId);
		callback.pushNumber(subType);
	}

	if (callback.persistLuaState()) {
		return;
	}
}

void Npc::onPlayerCloseChannel(const std::shared_ptr<Creature> &creature) {
	const auto &player = creature->getPlayer();
	if (!player) {
		return;
	}

	// onPlayerCloseChannel(npc, player)
	auto callback = CreatureCallback(npcType->info.scriptInterface, getNpc());
	if (callback.startScriptInterface(npcType->info.playerCloseChannel)) {
		callback.pushSpecificCreature(static_self_cast<Npc>());
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
			const uint32_t index = uniform_random(0, npcType->info.voiceVector.size() - 1);
			const auto &[text, yellText] = npcType->info.voiceVector[index];

			if (yellText) {
				g_game().internalCreatureSay(static_self_cast<Npc>(), TALKTYPE_YELL, text, false);
			} else {
				g_game().internalCreatureSay(static_self_cast<Npc>(), TALKTYPE_SAY, text, false);
			}
		}
	}
}

void Npc::onThinkWalk(uint32_t interval) {
	if (npcType->info.walkInterval == 0 || baseSpeed == 0) {
		return;
	}

	// If talking, no walking
	if (!playerInteractions.empty()) {
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
		listWalkDir.emplace_back(newDirection);
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
	const auto &spec = Spectators().find<Player>(position, true);
	for (const auto &creature : spec) {
		if (!creature->getPlayer()->hasFlag(PlayerFlags_t::IgnoredByNpcs)) {
			playerSpectators.emplace(creature->getPlayer());
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
	const auto &creature = g_game().getCreatureByID(playerId);
	if (!creature) {
		return;
	}

	if (playerInteractionsOrder.empty() || std::ranges::find(playerInteractionsOrder, playerId) == playerInteractionsOrder.end()) {
		playerInteractionsOrder.emplace_back(playerId);
		turnToCreature(creature);
	}

	playerInteractions[playerId] = topicId;
}

void Npc::removePlayerInteraction(const std::shared_ptr<Player> &player) {
	auto view = std::ranges::remove(playerInteractionsOrder, player->getID());
	playerInteractionsOrder.erase(view.begin(), view.end());
	if (playerInteractions.contains(player->getID())) {
		playerInteractions.erase(player->getID());
		player->closeShopWindow();
	}

	if (!playerInteractionsOrder.empty()) {
		if (const auto &creature = g_game().getCreatureByID(playerInteractionsOrder.back())) {
			turnToCreature(creature);
		}
	}
}

void Npc::resetPlayerInteractions() {
	playerInteractions.clear();
}

bool Npc::canWalkTo(const Position &fromPos, Direction dir) {
	if (npcType->info.walkRadius == 0) {
		return false;
	}

	const Position toPos = getNextPosition(dir, fromPos);
	if (!SpawnsNpc::isInZone(masterPos, npcType->info.walkRadius, toPos)) {
		return false;
	}

	const auto &toTile = g_game().map.getTile(toPos);
	if (!toTile || toTile->queryAdd(0, getNpc(), 1, 0) != RETURNVALUE_NOERROR) {
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

bool Npc::getRandomStep(Direction &moveDirection) {
	static std::vector<Direction> directionvector {
		Direction::DIRECTION_NORTH,
		Direction::DIRECTION_WEST,
		Direction::DIRECTION_EAST,
		Direction::DIRECTION_SOUTH
	};
	std::ranges::shuffle(directionvector, getRandomGenerator());

	for (const Position &creaturePos = getPosition();
	     const Direction &direction : directionvector) {
		if (canWalkTo(creaturePos, direction)) {
			moveDirection = direction;
			return true;
		}
	}
	return false;
}

void Npc::setNormalCreatureLight() {
	internalLight = npcType->info.light;
}

bool Npc::isShopPlayer(uint32_t playerGUID) const {
	return shopPlayers.contains(playerGUID);
}

void Npc::addShopPlayer(uint32_t playerGUID, const std::vector<ShopBlock> &shopItems) {
	shopPlayers.try_emplace(playerGUID, shopItems);
}

void Npc::removeShopPlayer(uint32_t playerGUID) {
	shopPlayers.erase(playerGUID);
}

void Npc::closeAllShopWindows() {
	for (auto it = shopPlayers.begin(); it != shopPlayers.end();) {
		const auto &player = g_game().getPlayerByGUID(it->first);
		if (player) {
			player->closeShopWindow();
		}
		it = shopPlayers.erase(it);
	}
}

void Npc::handlePlayerMove(const std::shared_ptr<Player> &player, const Position &newPos) {
	if (!canInteract(newPos)) {
		onPlayerCloseChannel(player);
	} else if (canInteract(newPos) && !playerInteractionsOrder.empty() && playerInteractionsOrder.back() == player->getID()) {
		turnToCreature(player);
	}

	if (canSee(newPos)) {
		onPlayerAppear(player);
	} else {
		onPlayerDisappear(player);
	}
}
