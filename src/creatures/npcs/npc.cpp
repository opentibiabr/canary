/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
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
#include "map/spectators.hpp"
#include "utils/batch_update.hpp"

int32_t Npc::despawnRange;
int32_t Npc::despawnRadius;

uint32_t Npc::npcAutoID = 0x80000000;

namespace {
	constexpr uint32_t kShoppingBagPrice = 20;
	constexpr uint32_t kShoppingBagSlots = 20;

	bool isBackpackSlotUnavailable(const std::shared_ptr<Player> &player, uint16_t itemId, bool ignore) {
		if (ignore || player->getFreeBackpackSlots() != 0) {
			return false;
		}

		if (player->getInventoryItem(CONST_SLOT_BACKPACK)) {
			return true;
		}

		const auto &itemType = Item::items[itemId];
		return !itemType.isContainer() || !(itemType.slotPosition & SLOTP_BACKPACK);
	}

	double calculateSlotsNeeded(const ItemType &itemType, uint16_t amount, bool inBackpacks) {
		if (itemType.stackable) {
			const auto stackSlots = std::ceil(static_cast<double>(amount) / itemType.stackSize);
			return inBackpacks ? std::ceil(stackSlots / kShoppingBagSlots) : stackSlots;
		}

		return inBackpacks ? std::ceil(static_cast<double>(amount) / kShoppingBagSlots) : static_cast<double>(amount);
	}

	bool exceedsTileLimit(const std::shared_ptr<Player> &player, const ItemType &itemType, uint16_t amount, bool inBackpacks, bool ignore) {
		if (!ignore) {
			return false;
		}

		const std::shared_ptr<Tile> &tile = player->getTile();
		if (!tile) {
			return false;
		}

		const auto slotsNeeded = calculateSlotsNeeded(itemType, amount, inBackpacks);
		const auto* itemList = tile->getItemList();
		const auto itemCount = itemList ? static_cast<double>(itemList->size()) : 0.0;
		return (itemCount + (slotsNeeded - player->getFreeBackpackSlots())) > 30;
	}

	uint32_t calculateBagsCost(const ItemType &itemType, uint16_t amount, bool inBackpacks) {
		if (!inBackpacks) {
			return 0;
		}

		const auto slotsNeeded = calculateSlotsNeeded(itemType, amount, true);
		return kShoppingBagPrice * static_cast<uint32_t>(slotsNeeded);
	}

	bool hasInsufficientFunds(const std::shared_ptr<Player> &player, uint16_t itemId, const std::string &npcName, uint16_t currency, uint32_t totalCost, uint32_t bagsCost) {
		if (currency == ITEM_GOLD_COIN) {
			if ((player->getMoney() + player->getBankBalance()) < totalCost) {
				g_logger().error("[Npc::onPlayerBuyItem (getMoney)] - Player {} have a problem for buy item {} on shop for npc {}", player->getName(), itemId, npcName);
				g_logger().debug("[Information] Player {} tried to buy item {} on shop for npc {}, at position {}", player->getName(), itemId, npcName, player->getPosition().toString());
				g_metrics().addCounter("balance_decrease", totalCost, { { "player", player->getName() }, { "context", "npc_purchase" } });
				return true;
			}
			return false;
		}

		const auto* cylinder = static_cast<const Cylinder*>(player.get());
		if (cylinder->getItemTypeCount(currency) < totalCost || ((player->getMoney() + player->getBankBalance()) < bagsCost)) {
			g_logger().error("[Npc::onPlayerBuyItem (getItemTypeCount)] - Player {} have a problem for buy item {} on shop for npc {}", player->getName(), itemId, npcName);
			g_logger().debug("[Information] Player {} tried to buy item {} on shop for npc {}, at position {}", player->getName(), itemId, npcName, player->getPosition().toString());
			return true;
		}

		return false;
	}

	bool addCustomCurrencyItems(const std::shared_ptr<Player> &player, uint16_t currency, uint64_t totalCost, const std::string &npcName, const char* createErrorContext, const char* addErrorContext) {
		constexpr auto kMaxStack = static_cast<uint64_t>(std::numeric_limits<uint16_t>::max());
		uint64_t remainingCost = totalCost;
		while (remainingCost > 0) {
			const auto stackSize = static_cast<uint16_t>(std::min<uint64_t>(remainingCost, kMaxStack));
			const auto &newItem = Item::CreateItem(currency, stackSize);
			if (!newItem) {
				g_logger().error("{} - Failed to create custom currency item {} for npc {}", createErrorContext, currency, npcName);
				return false;
			}

			const auto returnValue = g_game().internalPlayerAddItem(player, newItem, true);
			if (returnValue != RETURNVALUE_NOERROR) {
				g_logger().error("{} - Player: {} have a problem with custom currency, for add item: {} on shop for npc: {}, error code: {}", addErrorContext, player->getName(), newItem->getID(), npcName, getReturnMessage(returnValue));
				return false;
			}

			remainingCost -= stackSize;
		}

		return true;
	}

	uint32_t getSellPriceForItem(const std::vector<ShopBlock> &shopVector, uint16_t itemId) {
		for (const ShopBlock &shopBlock : shopVector) {
			if (itemId == shopBlock.itemId && shopBlock.itemSellPrice != 0) {
				return shopBlock.itemSellPrice;
			}
		}

		return 0;
	}

	uint32_t removeItemsFromLootPouch(const std::shared_ptr<Container> &lootPouch, uint16_t itemId, uint32_t amount, BatchUpdate* batchUpdate) {
		if (!lootPouch || amount == 0) {
			return 0;
		}

		if (batchUpdate) {
			const auto addResult = batchUpdate->add(lootPouch);
			(void)addResult;
		}

		uint32_t removed = 0;
		uint32_t toRemove = amount;
		for (size_t i = lootPouch->size(); i-- > 0 && toRemove > 0;) {
			const auto &list = lootPouch->getItemList();
			const auto &item = list[i];
			if (!item || item->getID() != itemId || item->getTier() > 0 || item->hasImbuements()) {
				continue;
			}

			const auto removeCount = std::min<uint32_t>(toRemove, static_cast<uint32_t>(item->getItemAmount()));
			lootPouch->removeItemByIndex(i, removeCount);

			toRemove -= removeCount;
			removed += removeCount;
		}

		return removed;
	}

	uint32_t removeItemsFromInventory(const std::shared_ptr<Player> &player, uint16_t itemId, bool ignore, uint32_t amount, BatchUpdate* batchUpdate, const std::string &npcName) {
		auto inventoryItems = player->getInventoryItemsFromId(itemId, ignore);
		uint32_t removed = 0;
		uint32_t toRemove = amount;
		for (const auto &item : inventoryItems) {
			if (toRemove == 0) {
				break;
			}

			if (!item || item->getTier() > 0 || item->hasImbuements()) {
				continue;
			}

			const auto &itemParent = item->getParent();
			auto container = itemParent ? itemParent->getContainer() : nullptr;
			if (batchUpdate && container) {
				const auto addResult = batchUpdate->add(container);
				(void)addResult;
			}

			const auto removeCount = std::min<uint16_t>(toRemove, item->getItemCount());
			if (player->removeItem(item, removeCount) != RETURNVALUE_NOERROR) {
				g_logger().error("[Npc::onPlayerSellItem] - Player {} have a problem for sell item {} on shop for npc {}", player->getName(), item->getID(), npcName);
				continue;
			}

			toRemove -= removeCount;
			removed += removeCount;
		}

		return removed;
	}

	void applyGoldSaleProceeds(const std::shared_ptr<Player> &player, uint64_t totalCost, bool notifyBankTransfer) {
		if (g_configManager().getBoolean(AUTOBANK)) {
			player->setBankBalance(player->getBankBalance() + totalCost);
			if (notifyBankTransfer) {
				player->sendTextMessage(MESSAGE_EVENT_ADVANCE, fmt::format("{} gold coins transferred to your bank.", totalCost));
			}
		} else {
			g_game().addMoney(player, totalCost);
		}
		g_metrics().addCounter("balance_increase", totalCost, { { "player", player->getName() }, { "context", "npc_sale" } });
	}

	bool applyCustomSaleProceeds(const std::shared_ptr<Player> &player, uint16_t currency, uint64_t totalCost, const std::string &npcName, const char* createErrorContext, const char* addErrorContext, const char* errorContext, const char* failureMessage) {
		if (addCustomCurrencyItems(player, currency, totalCost, npcName, createErrorContext, addErrorContext)) {
			return true;
		}

		g_logger().error(
			"{} - Failed to add custom currency {} (amount {}) to player {}. Sale aborted.",
			errorContext,
			currency,
			totalCost,
			player->getName()
		);

		player->sendTextMessage(MESSAGE_EVENT_ADVANCE, failureMessage);
		return false;
	}

	bool applySaleProceedsForLoot(const std::shared_ptr<Player> &player, uint16_t currency, uint64_t totalCost, const std::string &npcName) {
		if (!totalCost) {
			return true;
		}

		if (currency == ITEM_GOLD_COIN) {
			applyGoldSaleProceeds(player, totalCost, false);
			return true;
		}

		return applyCustomSaleProceeds(
			player,
			currency,
			totalCost,
			npcName,
			"[Npc::onPlayerSellAllLoot]",
			"[Npc::onPlayerSellItem]",
			"[Npc::onPlayerSellAllLoot]",
			"An error occurred while completing the sale of your loot. No items were exchanged."
		);
	}

	bool applySaleProceedsForItem(const std::shared_ptr<Player> &player, uint16_t currency, uint64_t totalCost, const std::string &npcName, const SellItemContext &context) {
		if (!totalCost) {
			return true;
		}

		if (currency == ITEM_GOLD_COIN) {
			if (context.totalPrice) {
				*context.totalPrice += totalCost;
			}
			applyGoldSaleProceeds(player, totalCost, !context.lootPouch);
			return true;
		}

		return applyCustomSaleProceeds(
			player,
			currency,
			totalCost,
			npcName,
			"[Npc::onPlayerSellItem]",
			"[Npc::onPlayerSellItem]",
			"[Npc::onPlayerSellItem]",
			"An error occurred while completing the sale. Your items were not exchanged."
		);
	}

	void sendSaleLetterIfNeeded(const std::shared_ptr<Player> &player, BatchUpdate &batching, const std::string &log, uint64_t totalPrice, const std::string &npcName) {
		if (totalPrice == 0 || log.empty()) {
			return;
		}

		const auto &storeInbox = player->getStoreInbox();
		if (!storeInbox) {
			g_logger().error("[Npc::onPlayerSellAllLoot] - Store inbox is nullptr for player {} when sending sale letter (npc: {})", player->getName(), npcName);
			return;
		}

		const auto addResult = batching.add(storeInbox);
		(void)addResult;

		auto letter = Item::CreateItem(ITEM_LETTER_STAMPED);
		if (!letter) {
			return;
		}

		letter->setAttribute(ItemAttribute_t::WRITER, fmt::format("Npc Seller: {}", npcName));
		letter->setAttribute(ItemAttribute_t::DATE, getTimeNow());
		letter->setAttribute(ItemAttribute_t::TEXT, log);
		const auto returnValue = g_game().internalAddItem(storeInbox, letter, INDEX_WHEREEVER, FLAG_NOLIMIT);
		if (returnValue != RETURNVALUE_NOERROR) {
			g_logger().error("[Npc::onPlayerSellAllLoot] - Failed to add sale letter for player {} to store inbox (npc: {}), error: {}", player->getName(), npcName, getReturnMessage(returnValue));
			player->sendTextMessage(MESSAGE_EVENT_ADVANCE, getReturnMessage(returnValue));
		}
	}
}

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
	if (isBackpackSlotUnavailable(player, itemId, ignore)) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
		return;
	}

	const auto &itemType = Item::items[itemId];
	if (exceedsTileLimit(player, itemType, amount, inBackpacks, ignore)) {
		player->sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
		return;
	}

	uint32_t buyPrice = 0;
	const auto &shopVector = getShopItemVector(player->getGUID());
	for (const ShopBlock &shopBlock : shopVector) {
		if (itemType.id == shopBlock.itemId && shopBlock.itemBuyPrice != 0) {
			buyPrice = shopBlock.itemBuyPrice;
		}
	}

	const uint32_t totalCost = buyPrice * amount;
	const uint32_t bagsCost = calculateBagsCost(itemType, amount, inBackpacks);
	if (hasInsufficientFunds(player, itemId, getName(), getCurrency(), totalCost, bagsCost)) {
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

void Npc::onPlayerSellItem(const std::shared_ptr<Player> &player, uint16_t itemId, uint8_t subType, uint32_t amount, bool ignore) {
	uint64_t totalPrice = 0;
	onPlayerSellItem(player, itemId, subType, amount, ignore, SellItemContext(totalPrice));
}

void Npc::onPlayerSellAllLoot(const std::shared_ptr<Player> &player, bool ignore, uint64_t &totalPrice) {
	if (!player) {
		return;
	}

	const auto &lootPouch = player->getLootPouch();
	if (!lootPouch) {
		return;
	}

	struct LootSaleData {
		uint32_t price = 0;
		uint32_t amount = 0;
	};

	const auto &shopVector = getShopItemVector(player->getGUID());
	phmap::flat_hash_map<uint16_t, LootSaleData> saleData;
	saleData.reserve(shopVector.size());
	for (const ShopBlock &shopBlock : shopVector) {
		if (shopBlock.itemSellPrice == 0) {
			continue;
		}

		auto &data = saleData[shopBlock.itemId];
		data.price = shopBlock.itemSellPrice;
	}

	BatchUpdate batching(player);
	if (!saleData.empty()) {
		const auto addResult = batching.add(lootPouch);
		(void)addResult;
	}

	for (size_t index = lootPouch->size(); index > 0;) {
		--index;

		const auto &list = lootPouch->getItemList();
		if (index >= list.size()) {
			continue;
		}

		const auto &item = list[index];
		if (!item) {
			continue;
		}

		const auto it = saleData.find(item->getID());
		if (it == saleData.end()) {
			continue;
		}

		if (item->getTier() > 0 || item->hasImbuements()) {
			continue;
		}

		const auto removeCount = static_cast<uint32_t>(item->getItemAmount());
		if (removeCount == 0) {
			continue;
		}

		lootPouch->removeItemByIndex(index, removeCount);
		it->second.amount += removeCount;
	}

	std::string log;
	log.reserve(saleData.size() * 64); // Median of 64 bytes per line
	uint32_t totalItemsSold = 0;
	for (auto &[itemId, data] : saleData) {
		if (data.amount == 0) {
			continue;
		}

		const auto totalCost = static_cast<uint64_t>(data.price) * data.amount;
		if (!totalCost) {
			continue;
		}

		totalPrice += totalCost;

		if (!applySaleProceedsForLoot(player, getCurrency(), totalCost, getName())) {
			return;
		}

		const auto &itemName = Item::items.getItemType(itemId).name;
		log += fmt::format("Sold {}x {} for {} gold.\n", data.amount, itemName, totalCost);
		totalItemsSold += data.amount;
	}

	std::string finalMessage;
	if (totalPrice == 0) {
		const auto &appendResult = finalMessage.append("You have no items in your loot pouch.");
		(void)appendResult;
	} else {
		finalMessage = fmt::format("You sold {} item{} from your loot pouch for {} gold. A letter with the full list has been sent to your store inbox.", totalItemsSold, (totalItemsSold == 1 ? "" : "s"), totalPrice);
	}

	player->sendTextMessage(MESSAGE_TRANSACTION, finalMessage);
	g_logger().debug("Npc::onPlayerSellItem Finished npc sell items");

	sendSaleLetterIfNeeded(player, batching, log, totalPrice, getName());
}

void Npc::onPlayerSellItem(const std::shared_ptr<Player> &player, uint16_t itemId, uint8_t subType, uint32_t amount, bool ignore, const SellItemContext &context) {
	if (!player) {
		return;
	}

	if (itemId == ITEM_GOLD_POUCH && context.lootPouch == nullptr) {
		uint64_t totalPrice = 0;
		auto &totalPriceRef = context.totalPrice ? *context.totalPrice : totalPrice;
		onPlayerSellAllLoot(player, ignore, totalPriceRef);
		return;
	}

	const auto &itemType = Item::items[itemId];
	const auto &shopVector = getShopItemVector(player->getGUID());
	const auto sellPrice = getSellPriceForItem(shopVector, itemType.id);
	if (sellPrice == 0) {
		return;
	}

	const auto removed = context.lootPouch
		? removeItemsFromLootPouch(context.lootPouch, itemId, amount, context.batchUpdate)
		: removeItemsFromInventory(player, itemId, ignore, amount, context.batchUpdate, getName());

	if (removed == 0) {
		if (!context.lootPouch) {
			player->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no items to sell.");
		}
		return;
	}

	auto totalCost = static_cast<uint64_t>(sellPrice) * removed;

	if (!applySaleProceedsForItem(player, getCurrency(), totalCost, getName(), context)) {
		return;
	}

	if (context.lootPouch) {
		return;
	}

	// npc:onSellItem(player, itemId, subType, amount, ignore, itemName, totalCost)
	auto callback = CreatureCallback(npcType->info.scriptInterface, getNpc());
	if (callback.startScriptInterface(npcType->info.playerSellEvent)) {
		callback.pushSpecificCreature(static_self_cast<Npc>());
		callback.pushCreature(player);
		callback.pushNumber(itemType.id);
		callback.pushNumber(subType);
		callback.pushNumber(removed);
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
	}

	if (!shopPlayers.empty()) {
		shopPlayers.clear();
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
