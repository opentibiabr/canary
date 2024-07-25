/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/combat/combat.hpp"
#include "creatures/interactions/chat.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "creatures/players/achievement/player_achievement.hpp"
#include "creatures/players/cyclopedia/player_badge.hpp"
#include "creatures/players/cyclopedia/player_cyclopedia.hpp"
#include "creatures/players/cyclopedia/player_title.hpp"
#include "creatures/players/storages/storages.hpp"
#include "game/game.hpp"
#include "game/modal_window/modal_window.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/scheduling/task.hpp"
#include "game/scheduling/save_manager.hpp"
#include "grouping/familiars.hpp"
#include "lua/creature/creatureevent.hpp"
#include "lua/creature/events.hpp"
#include "lua/callbacks/event_callback.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "lua/creature/movement.hpp"
#include "io/iologindata.hpp"
#include "items/bed.hpp"
#include "items/weapons/weapons.hpp"
#include "core.hpp"
#include "map/spectators.hpp"
#include "lib/metrics/metrics.hpp"
#include "enums/object_category.hpp"
#include "enums/account_errors.hpp"
#include "enums/account_type.hpp"
#include "enums/account_group_type.hpp"

MuteCountMap Player::muteCountMap;

Player::Player(ProtocolGame_ptr p) :
	Creature(),
	lastPing(OTSYS_TIME()),
	lastPong(lastPing),
	inbox(std::make_shared<Inbox>(ITEM_INBOX)),
	client(std::move(p)) {
	m_playerVIP = std::make_unique<PlayerVIP>(*this);
	m_wheelPlayer = std::make_unique<PlayerWheel>(*this);
	m_playerAchievement = std::make_unique<PlayerAchievement>(*this);
	m_playerBadge = std::make_unique<PlayerBadge>(*this);
	m_playerCyclopedia = std::make_unique<PlayerCyclopedia>(*this);
	m_playerTitle = std::make_unique<PlayerTitle>(*this);
}

Player::~Player() {
	for (const std::shared_ptr<Item> &item : inventory) {
		if (item) {
			item->resetParent();
			item->stopDecaying();
		}
	}

	for (const auto &it : depotLockerMap) {
		it.second->removeInbox(inbox);
		it.second->stopDecaying();
	}

	inbox->stopDecaying();

	setWriteItem(nullptr);
	setEditHouse(nullptr);
	logged = false;
}

bool Player::setVocation(uint16_t vocId) {
	const auto &voc = g_vocations().getVocation(vocId);
	if (!voc) {
		return false;
	}
	vocation = voc;

	updateRegeneration();
	g_game().addPlayerVocation(static_self_cast<Player>());
	return true;
}

bool Player::isPushable() {
	if (hasFlag(PlayerFlags_t::CannotBePushed)) {
		return false;
	}
	return Creature::isPushable();
}

std::shared_ptr<Task> Player::createPlayerTask(uint32_t delay, std::function<void(void)> f, std::string context) {
	return std::make_shared<Task>(std::move(f), std::move(context), delay);
}

uint32_t Player::playerFirstID = 0x10000000;
uint32_t Player::playerLastID = 0x50000000;
uint32_t Player::getFirstID() {
	return playerFirstID;
}
uint32_t Player::getLastID() {
	return playerLastID;
}

void Player::setID() {
	// guid = player id from database
	if (id == 0 && guid != 0) {
		id = getFirstID() + guid;
		if (id == std::numeric_limits<uint32_t>::max()) {
			g_logger().error("[{}] Player {} has max 'id' value of uint32_t", __FUNCTION__, getName());
		}
	}
}

std::string Player::getDescription(int32_t lookDistance) {
	std::ostringstream s;
	std::string subjectPronoun = getSubjectPronoun();
	capitalizeWords(subjectPronoun);
	auto playerTitle = title()->getCurrentTitle() == 0 ? "" : (", " + title()->getCurrentTitleName());

	if (lookDistance == -1) {
		s << "yourself" << playerTitle << ".";

		if (group->access) {
			s << " You are " << group->name << '.';
		} else if (vocation->getId() != VOCATION_NONE) {
			s << " You are " << vocation->getVocDescription() << '.';
		} else {
			s << " You have no vocation.";
		}

		if (!loyaltyTitle.empty()) {
			s << " You are a " << loyaltyTitle << ".";
		}

		if (isVip()) {
			s << " You are VIP.";
		}
	} else {
		s << name;
		if (!group->access) {
			s << " (Level " << level << ')';
		}

		s << playerTitle << ". " << subjectPronoun;

		if (group->access) {
			s << " " << getSubjectVerb() << " " << group->name << '.';
		} else if (vocation->getId() != VOCATION_NONE) {
			s << " " << getSubjectVerb() << " " << vocation->getVocDescription() << '.';
		} else {
			s << " has no vocation.";
		}

		if (!loyaltyTitle.empty()) {
			std::string article = "a";
			if (loyaltyTitle[0] == 'A' || loyaltyTitle[0] == 'E' || loyaltyTitle[0] == 'I' || loyaltyTitle[0] == 'O' || loyaltyTitle[0] == 'U') {
				article = "an";
			}
			s << " " << subjectPronoun << " " << getSubjectVerb() << " " << article << " " << loyaltyTitle << ".";
		}

		if (isVip()) {
			s << " " << subjectPronoun << " " << getSubjectVerb() << " VIP.";
		}
	}

	if (m_party) {
		if (lookDistance == -1) {
			s << " Your party has ";
		} else {
			s << " " << subjectPronoun << " " << getSubjectVerb() << " in a party with ";
		}

		size_t memberCount = m_party->getMemberCount() + 1;
		if (memberCount == 1) {
			s << "1 member and ";
		} else {
			s << memberCount << " members and ";
		}

		size_t invitationCount = m_party->getInvitationCount();
		if (invitationCount == 1) {
			s << "1 pending invitation.";
		} else {
			s << invitationCount << " pending invitations.";
		}
	}

	if (guild && guildRank) {
		size_t memberCount = guild->getMemberCount();
		if (memberCount >= 1000) {
			s << "";
			return s.str();
		}

		if (lookDistance == -1) {
			s << " You are ";
		} else {
			s << " " << subjectPronoun << " " << getSubjectVerb() << " ";
		}

		s << guildRank->name << " of the " << guild->getName();
		if (!guildNick.empty()) {
			s << " (" << guildNick << ')';
		}

		if (memberCount == 1) {
			s << ", which has 1 member, " << guild->getMembersOnline().size() << " of them online.";
		} else {
			s << ", which has " << memberCount << " members, " << guild->getMembersOnline().size() << " of them online.";
		}
	}
	return s.str();
}

std::shared_ptr<Item> Player::getInventoryItem(Slots_t slot) const {
	if (slot < CONST_SLOT_FIRST || slot > CONST_SLOT_LAST) {
		return nullptr;
	}
	return inventory[slot];
}

bool Player::isSuppress(ConditionType_t conditionType, bool attackerPlayer) const {
	auto minDelay = g_configManager().getNumber(MIN_DELAY_BETWEEN_CONDITIONS, __FUNCTION__);
	if (IsConditionSuppressible(conditionType) && checkLastConditionTimeWithin(conditionType, minDelay)) {
		return true;
	}

	return m_conditionSuppressions[static_cast<size_t>(conditionType)];
}

void Player::addConditionSuppressions(const std::array<ConditionType_t, ConditionType_t::CONDITION_COUNT> &addConditions) {
	for (const auto &conditionType : addConditions) {
		m_conditionSuppressions[static_cast<size_t>(conditionType)] = true;
	}
}

void Player::removeConditionSuppressions() {
	m_conditionSuppressions.reset();
}

std::shared_ptr<Item> Player::getWeapon(Slots_t slot, bool ignoreAmmo) const {
	std::shared_ptr<Item> item = inventory[slot];
	if (!item) {
		return nullptr;
	}

	WeaponType_t weaponType = item->getWeaponType();
	if (weaponType == WEAPON_NONE || weaponType == WEAPON_SHIELD || weaponType == WEAPON_AMMO) {
		return nullptr;
	}

	if (!ignoreAmmo && (weaponType == WEAPON_DISTANCE || weaponType == WEAPON_MISSILE)) {
		const ItemType &it = Item::items[item->getID()];
		if (it.ammoType != AMMO_NONE) {
			item = getQuiverAmmoOfType(it);
		}
	}

	return item;
}

bool Player::hasQuiverEquipped() const {
	std::shared_ptr<Item> quiver = inventory[CONST_SLOT_RIGHT];
	return quiver && quiver->isQuiver() && quiver->getContainer();
}

bool Player::hasWeaponDistanceEquipped() const {
	std::shared_ptr<Item> item = inventory[CONST_SLOT_LEFT];
	return item && item->getWeaponType() == WEAPON_DISTANCE;
}

std::shared_ptr<Item> Player::getQuiverAmmoOfType(const ItemType &it) const {
	if (!hasQuiverEquipped()) {
		return nullptr;
	}

	std::shared_ptr<Item> quiver = inventory[CONST_SLOT_RIGHT];
	for (std::shared_ptr<Container> container = quiver->getContainer();
	     auto ammoItem : container->getItemList()) {
		if (ammoItem->getAmmoType() == it.ammoType) {
			if (level >= Item::items[ammoItem->getID()].minReqLevel) {
				return ammoItem;
			}
		}
	}
	return nullptr;
}

std::shared_ptr<Item> Player::getWeapon(bool ignoreAmmo /* = false*/) const {
	std::shared_ptr<Item> item = getWeapon(CONST_SLOT_LEFT, ignoreAmmo);
	if (item) {
		return item;
	}

	item = getWeapon(CONST_SLOT_RIGHT, ignoreAmmo);
	if (item) {
		return item;
	}
	return nullptr;
}

WeaponType_t Player::getWeaponType() const {
	std::shared_ptr<Item> item = getWeapon();
	if (!item) {
		return WEAPON_NONE;
	}
	return item->getWeaponType();
}

int32_t Player::getWeaponSkill(std::shared_ptr<Item> item) const {
	if (!item) {
		return getSkillLevel(SKILL_FIST);
	}

	int32_t attackSkill;

	WeaponType_t weaponType = item->getWeaponType();
	switch (weaponType) {
		case WEAPON_SWORD: {
			attackSkill = getSkillLevel(SKILL_SWORD);
			break;
		}

		case WEAPON_CLUB: {
			attackSkill = getSkillLevel(SKILL_CLUB);
			break;
		}

		case WEAPON_AXE: {
			attackSkill = getSkillLevel(SKILL_AXE);
			break;
		}

		case WEAPON_MISSILE:
		case WEAPON_DISTANCE: {
			attackSkill = getSkillLevel(SKILL_DISTANCE);
			break;
		}

		default: {
			attackSkill = 0;
			break;
		}
	}
	return attackSkill;
}

int32_t Player::getArmor() const {
	int32_t armor = 0;

	static const Slots_t armorSlots[] = { CONST_SLOT_HEAD, CONST_SLOT_NECKLACE, CONST_SLOT_ARMOR, CONST_SLOT_LEGS, CONST_SLOT_FEET, CONST_SLOT_RING, CONST_SLOT_AMMO };
	for (Slots_t slot : armorSlots) {
		std::shared_ptr<Item> inventoryItem = inventory[slot];
		if (inventoryItem) {
			armor += inventoryItem->getArmor();
		}
	}
	return static_cast<int32_t>(armor * vocation->armorMultiplier);
}

void Player::getShieldAndWeapon(std::shared_ptr<Item> &shield, std::shared_ptr<Item> &weapon) const {
	shield = nullptr;
	weapon = nullptr;

	for (uint32_t slot = CONST_SLOT_RIGHT; slot <= CONST_SLOT_LEFT; slot++) {
		std::shared_ptr<Item> item = inventory[slot];
		if (!item) {
			continue;
		}

		switch (item->getWeaponType()) {
			case WEAPON_NONE:
				break;

			case WEAPON_SHIELD: {
				if (!shield || (shield && item->getDefense() > shield->getDefense())) {
					shield = item;
				}
				break;
			}

			default: { // weapons that are not shields
				weapon = item;
				break;
			}
		}
	}
}

float Player::getMitigation() const {
	return wheel()->calculateMitigation();
}

int32_t Player::getDefense() const {
	int32_t defenseSkill = getSkillLevel(SKILL_FIST);
	int32_t defenseValue = 7;
	std::shared_ptr<Item> weapon;
	std::shared_ptr<Item> shield;
	try {
		getShieldAndWeapon(shield, weapon);
	} catch (const std::exception &e) {
		g_logger().error("{} got exception {}", getName(), e.what());
	}

	if (weapon) {
		defenseValue = weapon->getDefense() + weapon->getExtraDefense();
		defenseSkill = getWeaponSkill(weapon);
	}

	if (shield) {
		defenseValue = weapon != nullptr ? shield->getDefense() + weapon->getExtraDefense() : shield->getDefense();
		// Wheel of destiny - Combat Mastery
		if (shield->getDefense() > 0) {
			defenseValue += wheel()->getMajorStatConditional("Combat Mastery", WheelMajor_t::DEFENSE);
		}
		defenseSkill = getSkillLevel(SKILL_SHIELD);
	}

	if (defenseSkill == 0) {
		switch (fightMode) {
			case FIGHTMODE_ATTACK:
			case FIGHTMODE_BALANCED:
				return 1;

			case FIGHTMODE_DEFENSE:
				return 2;
		}
	}

	return (defenseSkill / 4. + 2.23) * defenseValue * 0.15 * getDefenseFactor() * vocation->defenseMultiplier;
}

float Player::getAttackFactor() const {
	switch (fightMode) {
		case FIGHTMODE_ATTACK:
			return 1.0f;
		case FIGHTMODE_BALANCED:
			return 0.75f;
		case FIGHTMODE_DEFENSE:
			return 0.5f;
		default:
			return 1.0f;
	}
}

float Player::getDefenseFactor() const {
	switch (fightMode) {
		case FIGHTMODE_ATTACK:
			return (OTSYS_TIME() - lastAttack) < getAttackSpeed() ? 0.5f : 1.0f;
		case FIGHTMODE_BALANCED:
			return (OTSYS_TIME() - lastAttack) < getAttackSpeed() ? 0.75f : 1.0f;
		case FIGHTMODE_DEFENSE:
			return 1.0f;
		default:
			return 1.0f;
	}
}

uint32_t Player::getClientIcons() {
	uint32_t icons = 0;
	for (const auto &condition : conditions) {
		if (!isSuppress(condition->getType(), false)) {
			icons |= condition->getIcons();
		}
	}

	if (pzLocked) {
		icons |= ICON_REDSWORDS;
	}

	auto tile = getTile();
	if (tile && tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
		icons |= ICON_PIGEON;
		client->sendRestingStatus(1);

		// Don't show ICON_SWORDS if player is in protection zone.
		if (hasBitSet(ICON_SWORDS, icons)) {
			icons &= ~ICON_SWORDS;
		}
	} else {
		client->sendRestingStatus(0);
	}

	// Game client debugs with 10 or more icons
	// so let's prevent that from happening.
	std::bitset<32> icon_bitset(static_cast<uint64_t>(icons));
	for (size_t pos = 0, bits_set = icon_bitset.count(); bits_set >= 10; ++pos) {
		if (icon_bitset[pos]) {
			icon_bitset.reset(pos);
			--bits_set;
		}
	}
	return icon_bitset.to_ulong();
}

void Player::addMonsterToCyclopediaTrackerList(const std::shared_ptr<MonsterType> mtype, bool isBoss, bool reloadClient /* = false */) {
	if (!client) {
		return;
	}

	const uint16_t raceId = mtype ? mtype->info.raceid : 0;
	auto &tracker = isBoss ? m_bosstiaryMonsterTracker : m_bestiaryMonsterTracker;
	if (tracker.emplace(mtype).second) {
		if (reloadClient && raceId != 0) {
			if (isBoss) {
				client->parseSendBosstiary();
			} else {
				client->sendBestiaryEntryChanged(raceId);
			}
		}

		client->refreshCyclopediaMonsterTracker(tracker, isBoss);
	}
}

void Player::removeMonsterFromCyclopediaTrackerList(std::shared_ptr<MonsterType> mtype, bool isBoss, bool reloadClient /* = false */) {
	if (!client) {
		return;
	}

	const uint16_t raceId = mtype ? mtype->info.raceid : 0;
	auto &tracker = isBoss ? m_bosstiaryMonsterTracker : m_bestiaryMonsterTracker;

	if (tracker.erase(mtype) > 0) {
		if (reloadClient && raceId != 0) {
			if (isBoss) {
				client->parseSendBosstiary();
			} else {
				client->sendBestiaryEntryChanged(raceId);
			}
		}

		client->refreshCyclopediaMonsterTracker(tracker, isBoss);
	}
}

bool Player::isBossOnBosstiaryTracker(const std::shared_ptr<MonsterType> &monsterType) const {
	return monsterType ? m_bosstiaryMonsterTracker.contains(monsterType) : false;
}

void Player::updateInventoryWeight() {
	if (hasFlag(PlayerFlags_t::HasInfiniteCapacity)) {
		return;
	}

	inventoryWeight = 0;
	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		std::shared_ptr<Item> item = inventory[i];
		if (item) {
			inventoryWeight += item->getWeight();
		}
	}
}

void Player::updateInventoryImbuement() {
	// Get the tile the player is currently on
	std::shared_ptr<Tile> playerTile = getTile();
	// Check if the player is in a protection zone
	bool isInProtectionZone = playerTile && playerTile->hasFlag(TILESTATE_PROTECTIONZONE);
	// Check if the player is in fight mode
	bool isInFightMode = hasCondition(CONDITION_INFIGHT);
	bool nonAggressiveFightOnly = g_configManager().getBoolean(TOGGLE_IMBUEMENT_NON_AGGRESSIVE_FIGHT_ONLY, __FUNCTION__);

	// Iterate through all items in the player's inventory
	for (auto [key, item] : getAllSlotItems()) {
		// Iterate through all imbuement slots on the item

		for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
			ImbuementInfo imbuementInfo;
			// Get the imbuement information for the current slot
			if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
				// If no imbuement is found, continue to the next slot
				continue;
			}

			// Imbuement from imbuementInfo, this variable reduces code complexity
			auto imbuement = imbuementInfo.imbuement;
			// Get the category of the imbuement
			const CategoryImbuement* categoryImbuement = g_imbuements().getCategoryByID(imbuement->getCategory());
			// Parent of the imbued item
			auto parent = item->getParent();
			bool isInBackpack = parent && parent->getContainer();
			// If the imbuement is aggressive and the player is not in fight mode or is in a protection zone, or the item is in a container, ignore it.
			if (categoryImbuement && (categoryImbuement->agressive || nonAggressiveFightOnly) && (isInProtectionZone || !isInFightMode || isInBackpack)) {
				continue;
			}
			// If the item is not in the backpack slot and it's not a agressive imbuement, ignore it.
			if (categoryImbuement && !categoryImbuement->agressive && parent && parent != getPlayer()) {
				continue;
			}

			// If the imbuement's duration is 0, remove its stats and continue to the next slot
			if (imbuementInfo.duration == 0) {
				removeItemImbuementStats(imbuement);
				updateImbuementTrackerStats();
				continue;
			}

			g_logger().trace("Decaying imbuement {} from item {} of player {}", imbuement->getName(), item->getName(), getName());
			// Calculate the new duration of the imbuement, making sure it doesn't go below 0
			uint32_t duration = std::max<uint32_t>(0, imbuementInfo.duration - EVENT_IMBUEMENT_INTERVAL / 1000);
			// Update the imbuement's duration in the item
			item->decayImbuementTime(slotid, imbuement->getID(), duration);

			if (duration == 0) {
				removeItemImbuementStats(imbuement);
				updateImbuementTrackerStats();
				continue;
			}
		}
	}
}

phmap::flat_hash_map<uint8_t, std::shared_ptr<Item>> Player::getAllSlotItems() const {
	phmap::flat_hash_map<uint8_t, std::shared_ptr<Item>> itemMap;
	for (uint8_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		std::shared_ptr<Item> item = inventory[i];
		if (!item) {
			continue;
		}

		itemMap[i] = item;
	}

	return itemMap;
}

void Player::setTraining(bool value) {
	for (const auto &[key, player] : g_game().getPlayers()) {
		if (!this->isInGhostMode() || player->isAccessPlayer()) {
			player->vip()->notifyStatusChange(static_self_cast<Player>(), value ? VipStatus_t::Training : VipStatus_t::Online, false);
		}
	}
	vip()->setStatus(VipStatus_t::Training);
	setExerciseTraining(value);
}

uint16_t Player::getLoyaltySkill(skills_t skill) const {
	uint16_t level = getBaseSkill(skill);
	absl::uint128 currReqTries = vocation->getReqSkillTries(skill, level);
	absl::uint128 nextReqTries = vocation->getReqSkillTries(skill, level + 1);
	if (currReqTries >= nextReqTries) {
		// player has reached max skill
		return skills[skill].level;
	}

	absl::uint128 tries = skills[skill].tries;
	absl::uint128 totalTries = vocation->getTotalSkillTries(skill, skills[skill].level) + tries;
	absl::uint128 loyaltyTries = (totalTries * getLoyaltyBonus()) / 100;
	while ((tries + loyaltyTries) >= nextReqTries) {
		loyaltyTries -= nextReqTries - tries;
		level++;
		tries = 0;

		currReqTries = nextReqTries;
		nextReqTries = vocation->getReqSkillTries(skill, level + 1);
		if (currReqTries >= nextReqTries) {
			loyaltyTries = 0;
			break;
		}
	}
	return level;
}

void Player::addSkillAdvance(skills_t skill, uint64_t count) {
	uint64_t currReqTries = vocation->getReqSkillTries(skill, skills[skill].level);
	uint64_t nextReqTries = vocation->getReqSkillTries(skill, skills[skill].level + 1);
	if (currReqTries >= nextReqTries) {
		// player has reached max skill
		return;
	}

	g_events().eventPlayerOnGainSkillTries(static_self_cast<Player>(), skill, count);
	g_callbacks().executeCallback(EventCallback_t::playerOnGainSkillTries, &EventCallback::playerOnGainSkillTries, getPlayer(), skill, count);
	if (count == 0) {
		return;
	}

	bool sendUpdateSkills = false;
	while ((skills[skill].tries + count) >= nextReqTries) {
		count -= nextReqTries - skills[skill].tries;
		skills[skill].level++;
		skills[skill].tries = 0;
		skills[skill].percent = 0;

		std::ostringstream ss;
		ss << "You advanced to " << getSkillName(skill) << " level " << skills[skill].level << '.';
		sendTextMessage(MESSAGE_EVENT_ADVANCE, ss.str());
		if (skill == SKILL_LEVEL) {
			sendTakeScreenshot(SCREENSHOT_TYPE_LEVELUP);
		} else {
			sendTakeScreenshot(SCREENSHOT_TYPE_SKILLUP);
		}

		g_creatureEvents().playerAdvance(static_self_cast<Player>(), skill, (skills[skill].level - 1), skills[skill].level);

		sendUpdateSkills = true;
		currReqTries = nextReqTries;
		nextReqTries = vocation->getReqSkillTries(skill, skills[skill].level + 1);
		if (currReqTries >= nextReqTries) {
			count = 0;
			break;
		}
	}

	skills[skill].tries += count;

	uint32_t newPercent;
	if (nextReqTries > currReqTries) {
		newPercent = Player::getPercentLevel(skills[skill].tries, nextReqTries);
	} else {
		newPercent = 0;
	}

	if (skills[skill].percent != newPercent) {
		skills[skill].percent = newPercent;
		sendUpdateSkills = true;
	}

	if (sendUpdateSkills) {
		sendSkills();
		sendStats();
	}
}

void Player::setVarStats(stats_t stat, int32_t modifier) {
	varStats[stat] += modifier;

	switch (stat) {
		case STAT_MAXHITPOINTS: {
			if (getHealth() > getMaxHealth()) {
				Creature::changeHealth(getMaxHealth() - getHealth());
			} else {
				g_game().addCreatureHealth(static_self_cast<Player>());
			}
			break;
		}

		case STAT_MAXMANAPOINTS: {
			if (getMana() > getMaxMana()) {
				Creature::changeMana(getMaxMana() - getMana());
			} else {
				g_game().addPlayerMana(static_self_cast<Player>());
			}
			break;
		}

		default: {
			break;
		}
	}
}

int32_t Player::getDefaultStats(stats_t stat) const {
	switch (stat) {
		case STAT_MAXHITPOINTS:
			return healthMax;
		case STAT_MAXMANAPOINTS:
			return manaMax;
		case STAT_MAGICPOINTS:
			return getBaseMagicLevel();
		default:
			return 0;
	}
}

void Player::addContainer(uint8_t cid, std::shared_ptr<Container> container) {
	if (cid > 0xF) {
		return;
	}

	if (!container) {
		return;
	}

	auto it = openContainers.find(cid);
	if (it != openContainers.end()) {
		OpenContainer &openContainer = it->second;
		auto oldContainer = openContainer.container;
		if (oldContainer->getID() == ITEM_BROWSEFIELD) {
		}

		openContainer.container = container;
		openContainer.index = 0;
	} else {
		OpenContainer openContainer;
		openContainer.container = container;
		openContainer.index = 0;
		openContainers[cid] = openContainer;
	}
}

void Player::closeContainer(uint8_t cid) {
	auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return;
	}

	OpenContainer openContainer = it->second;
	std::shared_ptr<Container> container = openContainer.container;

	if (container && container->isAnyKindOfRewardChest() && !hasOtherRewardContainerOpen(container)) {
		removeEmptyRewards();
	}
	openContainers.erase(it);
	if (container && container->getID() == ITEM_BROWSEFIELD) {
	}
}

void Player::removeEmptyRewards() {
	std::erase_if(rewardMap, [this](const auto &rewardBag) {
		auto [id, reward] = rewardBag;
		if (reward->empty()) {
			getRewardChest()->removeItem(reward);
			return true;
		}
		return false;
	});
}

bool Player::hasOtherRewardContainerOpen(const std::shared_ptr<Container> container) const {
	return std::ranges::any_of(openContainers.begin(), openContainers.end(), [container](const auto &containerPair) {
		return containerPair.second.container != container && containerPair.second.container->isAnyKindOfRewardContainer();
	});
}

void Player::setContainerIndex(uint8_t cid, uint16_t index) {
	auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return;
	}
	it->second.index = index;
}

std::shared_ptr<Container> Player::getContainerByID(uint8_t cid) {
	auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return nullptr;
	}
	return it->second.container;
}

int8_t Player::getContainerID(std::shared_ptr<Container> container) const {
	for (const auto &it : openContainers) {
		if (it.second.container == container) {
			return it.first;
		}
	}
	return -1;
}

uint16_t Player::getContainerIndex(uint8_t cid) const {
	auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return 0;
	}
	return it->second.index;
}

bool Player::canOpenCorpse(uint32_t ownerId) const {
	return getID() == ownerId || (m_party && m_party->canOpenCorpse(ownerId));
}

uint16_t Player::getLookCorpse() const {
	if (sex == PLAYERSEX_FEMALE) {
		return ITEM_FEMALE_CORPSE;
	} else {
		return ITEM_MALE_CORPSE;
	}
}

void Player::addStorageValue(const uint32_t key, const int32_t value, const bool isLogin /* = false*/) {
	if (IS_IN_KEYRANGE(key, RESERVED_RANGE)) {
		if (IS_IN_KEYRANGE(key, OUTFITS_RANGE)) {
			outfits.emplace_back(
				value >> 16,
				value & 0xFF
			);
			return;
		} else if (IS_IN_KEYRANGE(key, MOUNTS_RANGE)) {
			// do nothing
		} else if (IS_IN_KEYRANGE(key, FAMILIARS_RANGE)) {
			familiars.emplace_back(
				value >> 16
			);
			return;
		} else {
			g_logger().warn("Unknown reserved key: {} for player: {}", key, getName());
			return;
		}
	}

	if (value != -1) {
		int32_t oldValue = getStorageValue(key);
		storageMap[key] = value;

		if (!isLogin) {
			auto currentFrameTime = g_dispatcher().getDispatcherCycle();
			g_events().eventOnStorageUpdate(static_self_cast<Player>(), key, value, oldValue, currentFrameTime);
			g_callbacks().executeCallback(EventCallback_t::playerOnStorageUpdate, &EventCallback::playerOnStorageUpdate, getPlayer(), key, value, oldValue, currentFrameTime);
		}
	} else {
		storageMap.erase(key);
	}
}

int32_t Player::getStorageValue(const uint32_t key) const {
	int32_t value = -1;
	auto it = storageMap.find(key);
	if (it == storageMap.end()) {
		return value;
	}

	value = it->second;
	return value;
}

int32_t Player::getStorageValueByName(const std::string &storageName) const {
	auto it = g_storages().getStorageMap().find(storageName);
	if (it == g_storages().getStorageMap().end()) {
		return -1;
	}
	uint32_t key = it->second;

	return getStorageValue(key);
}

void Player::addStorageValueByName(const std::string &storageName, const int32_t value, const bool isLogin /* = false*/) {
	auto it = g_storages().getStorageMap().find(storageName);
	if (it == g_storages().getStorageMap().end()) {
		g_logger().error("[{}] Storage name '{}' not found in storage map, register your storage in 'storages.xml' first for use", __func__, storageName);
		return;
	}
	uint32_t key = it->second;
	addStorageValue(key, value, isLogin);
}

bool Player::canSee(const Position &pos) {
	if (!client) {
		return false;
	}
	return client->canSee(pos);
}

bool Player::canSeeCreature(std::shared_ptr<Creature> creature) const {
	if (creature.get() == this) {
		return true;
	}

	if (creature->isInGhostMode() && !group->access) {
		return false;
	}

	if (!creature->getPlayer() && !canSeeInvisibility() && creature->isInvisible()) {
		return false;
	}
	return true;
}

bool Player::canWalkthrough(std::shared_ptr<Creature> creature) {
	if (group->access || creature->isInGhostMode()) {
		return true;
	}

	std::shared_ptr<Player> player = creature->getPlayer();
	std::shared_ptr<Monster> monster = creature->getMonster();
	std::shared_ptr<Npc> npc = creature->getNpc();
	if (monster) {
		if (!monster->isFamiliar()) {
			return false;
		}
		return true;
	}

	if (player) {
		std::shared_ptr<Tile> playerTile = player->getTile();
		if (!playerTile || (!playerTile->hasFlag(TILESTATE_NOPVPZONE) && !playerTile->hasFlag(TILESTATE_PROTECTIONZONE) && player->getLevel() > static_cast<uint32_t>(g_configManager().getNumber(PROTECTION_LEVEL, __FUNCTION__)) && g_game().getWorldType() != WORLD_TYPE_NO_PVP)) {
			return false;
		}

		std::shared_ptr<Item> playerTileGround = playerTile->getGround();
		if (!playerTileGround || !playerTileGround->hasWalkStack()) {
			return false;
		}

		std::shared_ptr<Player> thisPlayer = getPlayer();
		if ((OTSYS_TIME() - lastWalkthroughAttempt) > 2000) {
			thisPlayer->setLastWalkthroughAttempt(OTSYS_TIME());
			return false;
		}

		if (creature->getPosition() != lastWalkthroughPosition) {
			thisPlayer->setLastWalkthroughPosition(creature->getPosition());
			return false;
		}

		thisPlayer->setLastWalkthroughPosition(creature->getPosition());
		return true;
	} else if (npc) {
		std::shared_ptr<Tile> tile = npc->getTile();
		std::shared_ptr<HouseTile> houseTile = std::dynamic_pointer_cast<HouseTile>(tile);
		return (houseTile != nullptr);
	}

	return false;
}

bool Player::canWalkthroughEx(std::shared_ptr<Creature> creature) {
	if (group->access) {
		return true;
	}

	std::shared_ptr<Monster> monster = creature->getMonster();
	if (monster) {
		if (!monster->isFamiliar()) {
			return false;
		}
		return true;
	}

	std::shared_ptr<Player> player = creature->getPlayer();
	std::shared_ptr<Npc> npc = creature->getNpc();
	if (player) {
		std::shared_ptr<Tile> playerTile = player->getTile();
		return playerTile && (playerTile->hasFlag(TILESTATE_NOPVPZONE) || playerTile->hasFlag(TILESTATE_PROTECTIONZONE) || player->getLevel() <= static_cast<uint32_t>(g_configManager().getNumber(PROTECTION_LEVEL, __FUNCTION__)) || g_game().getWorldType() == WORLD_TYPE_NO_PVP);
	} else if (npc) {
		std::shared_ptr<Tile> tile = npc->getTile();
		std::shared_ptr<HouseTile> houseTile = std::dynamic_pointer_cast<HouseTile>(tile);
		return (houseTile != nullptr);
	} else {
		return false;
	}
}

void Player::onReceiveMail() {
	if (isNearDepotBox()) {
		sendTextMessage(MESSAGE_EVENT_ADVANCE, "New mail has arrived.");
	}
}

std::shared_ptr<Container> Player::refreshManagedContainer(ObjectCategory_t category, std::shared_ptr<Container> container, bool isLootContainer, bool loading /* = false*/) {
	std::shared_ptr<Container> previousContainer = nullptr;
	auto toSetAttribute = isLootContainer ? ItemAttribute_t::QUICKLOOTCONTAINER : ItemAttribute_t::OBTAINCONTAINER;
	if (auto it = m_managedContainers.find(category); it != m_managedContainers.end() && !loading) {
		previousContainer = isLootContainer ? it->second.first : it->second.second;
		if (previousContainer) {
			auto flags = previousContainer->getAttribute<uint32_t>(toSetAttribute);
			flags &= ~(1 << category);
			if (flags == 0) {
				previousContainer->removeAttribute(toSetAttribute);
			} else {
				previousContainer->setAttribute(toSetAttribute, flags);
			}
		}

		if (isLootContainer) {
			it->second.first = nullptr;
		} else {
			it->second.second = nullptr;
		}

		if (!it->second.first && !it->second.second) {
			m_managedContainers.erase(it);
		}
	}

	if (container) {
		previousContainer = container;
		if (m_managedContainers.find(category) != m_managedContainers.end()) {
			if (isLootContainer) {
				m_managedContainers[category].first = container;
			} else {
				m_managedContainers[category].second = container;
			}
		} else {
			std::pair<std::shared_ptr<Container>, std::shared_ptr<Container>> newPair;
			if (isLootContainer) {
				newPair.first = container;
				newPair.second = nullptr;
			} else {
				newPair.first = nullptr;
				newPair.second = container;
			}
			m_managedContainers[category] = newPair;
		}

		if (!loading) {
			auto flags = container->getAttribute<uint32_t>(toSetAttribute);
			auto sendAttribute = flags | (1 << category);
			container->setAttribute(toSetAttribute, sendAttribute);
		}
	}

	return previousContainer;
}

std::shared_ptr<Container> Player::getManagedContainer(ObjectCategory_t category, bool isLootContainer) const {
	if (category != OBJECTCATEGORY_DEFAULT && !isPremium()) {
		category = OBJECTCATEGORY_DEFAULT;
	}

	auto it = m_managedContainers.find(category);
	std::shared_ptr<Container> container = nullptr;
	if (it != m_managedContainers.end()) {
		container = isLootContainer ? it->second.first : it->second.second;
	}

	if (!container && category != OBJECTCATEGORY_DEFAULT) {
		// firstly, fallback to default
		container = getManagedContainer(OBJECTCATEGORY_DEFAULT, isLootContainer);
	}

	return container;
}

void Player::checkLootContainers(std::shared_ptr<Container> container) {
	if (!container) {
		return;
	}

	bool shouldSend = false;
	for (auto it = m_managedContainers.begin(); it != m_managedContainers.end();) {
		std::shared_ptr<Container> &lootContainer = it->second.first;
		std::shared_ptr<Container> &obtainContainer = it->second.second;
		bool removeLoot = false;
		bool removeObtain = false;
		if (lootContainer && container->getHoldingPlayer() != getPlayer() && (container == lootContainer || container->isHoldingItem(lootContainer))) {
			removeLoot = true;
			shouldSend = true;
			lootContainer->removeAttribute(ItemAttribute_t::QUICKLOOTCONTAINER);
		}

		if (obtainContainer && container->getHoldingPlayer() != getPlayer() && (container == obtainContainer || container->isHoldingItem(obtainContainer))) {
			removeObtain = true;
			shouldSend = true;
			obtainContainer->removeAttribute(ItemAttribute_t::OBTAINCONTAINER);
		}

		if (removeLoot) {
			lootContainer.reset();
		}

		if (removeObtain) {
			obtainContainer.reset();
		}

		if (!lootContainer && !obtainContainer) {
			it = m_managedContainers.erase(it);
		} else {
			++it;
		}
	}

	if (shouldSend) {
		sendLootContainers();
	}
}

void Player::setMainBackpackUnassigned(std::shared_ptr<Container> container) {
	if (!container) {
		return;
	}

	// Update containers
	bool toSendInventoryUpdate = false;
	for (bool isLootContainer : { true, false }) {
		std::shared_ptr<Container> managedContainer = getManagedContainer(OBJECTCATEGORY_DEFAULT, isLootContainer);
		if (!managedContainer) {
			refreshManagedContainer(OBJECTCATEGORY_DEFAULT, container, isLootContainer);
			toSendInventoryUpdate = true;
		}
	}

	if (toSendInventoryUpdate) {
		sendInventoryItem(CONST_SLOT_BACKPACK, container);
		sendLootContainers();
	}
}

void Player::sendLootStats(std::shared_ptr<Item> item, uint8_t count) {
	uint64_t value = 0;
	if (item->getID() == ITEM_GOLD_COIN || item->getID() == ITEM_PLATINUM_COIN || item->getID() == ITEM_CRYSTAL_COIN) {
		if (item->getID() == ITEM_PLATINUM_COIN) {
			value = count * 100;
		} else if (item->getID() == ITEM_CRYSTAL_COIN) {
			value = count * 10000;
		} else {
			value = count;
		}
	} else if (
		auto npc = g_game().getNpcByName("The Lootmonger")
	) {
		const auto &iType = Item::items.getItemType(item->getID());
		value = iType.sellPrice * count;
	}
	g_metrics().addCounter("player_loot", value, { { "player", getName() } });

	if (client) {
		client->sendLootStats(item, count);
	}

	if (m_party) {
		m_party->addPlayerLoot(getPlayer(), item);
	}
}

bool Player::isNearDepotBox() {
	const Position &pos = getPosition();
	for (int32_t cx = -1; cx <= 1; ++cx) {
		for (int32_t cy = -1; cy <= 1; ++cy) {
			std::shared_ptr<Tile> posTile = g_game().map.getTile(static_cast<uint16_t>(pos.x + cx), static_cast<uint16_t>(pos.y + cy), pos.z);
			if (!posTile) {
				continue;
			}

			if (posTile->hasFlag(TILESTATE_DEPOT)) {
				return true;
			}
		}
	}
	return false;
}

std::shared_ptr<DepotChest> Player::getDepotChest(uint32_t depotId, bool autoCreate) {
	auto it = depotChests.find(depotId);
	if (it != depotChests.end()) {
		return it->second;
	}

	if (!autoCreate) {
		return nullptr;
	}

	std::shared_ptr<DepotChest> depotChest;
	if (depotId > 0 && depotId < 18) {
		depotChest = std::make_shared<DepotChest>(ITEM_DEPOT_NULL + depotId);
	} else if (depotId == 18) {
		depotChest = std::make_shared<DepotChest>(ITEM_DEPOT_XVIII);
	} else if (depotId == 19) {
		depotChest = std::make_shared<DepotChest>(ITEM_DEPOT_XIX);
	} else {
		depotChest = std::make_shared<DepotChest>(ITEM_DEPOT_XX);
	}

	depotChests[depotId] = depotChest;
	return depotChest;
}

std::shared_ptr<DepotLocker> Player::getDepotLocker(uint32_t depotId) {
	auto it = depotLockerMap.find(depotId);
	if (it != depotLockerMap.end()) {
		inbox->setParent(it->second);
		for (uint32_t i = g_configManager().getNumber(DEPOT_BOXES, __FUNCTION__); i > 0; i--) {
			if (std::shared_ptr<DepotChest> depotBox = getDepotChest(i, false)) {
				depotBox->setParent(it->second->getItemByIndex(0)->getContainer());
			}
		}
		return it->second;
	}

	// We need to make room for supply stash on 12+ protocol versions and remove it for 10x.
	bool createSupplyStash = !client->oldProtocol;

	std::shared_ptr<DepotLocker> depotLocker = std::make_shared<DepotLocker>(ITEM_LOCKER, createSupplyStash ? 4 : 3);
	depotLocker->setDepotId(depotId);
	depotLocker->internalAddThing(Item::CreateItem(ITEM_MARKET));
	depotLocker->internalAddThing(inbox);
	if (createSupplyStash) {
		depotLocker->internalAddThing(Item::CreateItem(ITEM_SUPPLY_STASH));
	}
	std::shared_ptr<Container> depotChest = Item::CreateItemAsContainer(ITEM_DEPOT, static_cast<uint16_t>(g_configManager().getNumber(DEPOT_BOXES, __FUNCTION__)));
	for (uint32_t i = g_configManager().getNumber(DEPOT_BOXES, __FUNCTION__); i > 0; i--) {
		std::shared_ptr<DepotChest> depotBox = getDepotChest(i, true);
		depotChest->internalAddThing(depotBox);
		depotBox->setParent(depotChest);
	}
	depotLocker->internalAddThing(depotChest);
	depotLockerMap[depotId] = depotLocker;
	return depotLocker;
}

std::shared_ptr<RewardChest> Player::getRewardChest() {
	if (rewardChest != nullptr) {
		return rewardChest;
	}

	rewardChest = std::make_shared<RewardChest>(ITEM_REWARD_CHEST);
	return rewardChest;
}

std::shared_ptr<Reward> Player::getReward(const uint64_t rewardId, const bool autoCreate) {
	auto it = rewardMap.find(rewardId);
	if (it != rewardMap.end()) {
		return it->second;
	}
	if (!autoCreate) {
		return nullptr;
	}

	auto reward = std::make_shared<Reward>();
	reward->setAttribute(ItemAttribute_t::DATE, rewardId);
	rewardMap[rewardId] = reward;
	g_game().internalAddItem(getRewardChest(), reward, INDEX_WHEREEVER, FLAG_NOLIMIT);

	return reward;
}

void Player::removeReward(uint64_t rewardId) {
	rewardMap.erase(rewardId);
}

void Player::getRewardList(std::vector<uint64_t> &rewards) const {
	rewards.reserve(rewardMap.size());
	for (auto &it : rewardMap) {
		rewards.push_back(it.first);
	}
}

std::vector<std::shared_ptr<Item>> Player::getRewardsFromContainer(std::shared_ptr<Container> container) const {
	std::vector<std::shared_ptr<Item>> rewardItemsVector;
	if (container) {
		for (const auto &item : container->getItems(false)) {
			if (item->getID() == ITEM_REWARD_CONTAINER) {
				auto items = getRewardsFromContainer(item->getContainer());
				rewardItemsVector.insert(rewardItemsVector.end(), items.begin(), items.end());
			} else {
				rewardItemsVector.push_back(item);
			}
		}
	}

	return rewardItemsVector;
}

void Player::sendCancelMessage(ReturnValue message) const {
	sendCancelMessage(getReturnMessage(message));
}

void Player::sendStats() {
	if (client) {
		client->sendStats();
		lastStatsTrainingTime = getOfflineTrainingTime() / 60 / 1000;
	}
}

void Player::updateSupplyTracker(std::shared_ptr<Item> item) {
	const auto &iType = Item::items.getItemType(item->getID());
	auto value = iType.buyPrice;
	g_metrics().addCounter("player_supply", value, { { "player", getName() } });

	if (client) {
		client->sendUpdateSupplyTracker(item);
	}

	if (m_party) {
		m_party->addPlayerSupply(getPlayer(), item);
	}
}

void Player::updateImpactTracker(CombatType_t type, int32_t amount) const {
	if (client) {
		client->sendUpdateImpactTracker(type, amount);
	}
}

void Player::sendPing() {
	int64_t timeNow = OTSYS_TIME();

	bool hasLostConnection = false;
	if ((timeNow - lastPing) >= 5000) {
		lastPing = timeNow;
		if (client) {
			client->sendPing();
		} else {
			hasLostConnection = true;
		}
	}

	int64_t noPongTime = timeNow - lastPong;
	auto attackedCreature = getAttackedCreature();
	if ((hasLostConnection || noPongTime >= 7000) && attackedCreature && attackedCreature->getPlayer()) {
		setAttackedCreature(nullptr);
	}

	if (noPongTime >= 60000 && canLogout() && g_creatureEvents().playerLogout(static_self_cast<Player>())) {
		g_logger().info("Player {} has been kicked due to ping timeout. (has client: {})", getName(), client != nullptr);
		if (client) {
			client->logout(true, true);
		} else {
			g_game().removeCreature(static_self_cast<Player>(), true);
		}
	}
}

std::shared_ptr<Item> Player::getWriteItem(uint32_t &retWindowTextId, uint16_t &retMaxWriteLen) {
	retWindowTextId = this->windowTextId;
	retMaxWriteLen = this->maxWriteLen;
	return writeItem;
}

void Player::setImbuingItem(std::shared_ptr<Item> item) {
	imbuingItem = item;
}

void Player::setWriteItem(std::shared_ptr<Item> item, uint16_t maxWriteLength /*= 0*/) {
	windowTextId++;

	if (item) {
		writeItem = item;
		this->maxWriteLen = maxWriteLength;
	} else {
		writeItem = nullptr;
		this->maxWriteLen = 0;
	}
}

std::shared_ptr<House> Player::getEditHouse(uint32_t &retWindowTextId, uint32_t &retListId) {
	retWindowTextId = this->windowTextId;
	retListId = this->editListId;
	return editHouse;
}

void Player::setEditHouse(std::shared_ptr<House> house, uint32_t listId /*= 0*/) {
	windowTextId++;
	editHouse = house;
	editListId = listId;
}

void Player::sendHouseWindow(std::shared_ptr<House> house, uint32_t listId) const {
	if (!client) {
		return;
	}

	std::string text;
	if (house->getAccessList(listId, text)) {
		client->sendHouseWindow(windowTextId, text);
	}
}

void Player::onApplyImbuement(Imbuement* imbuement, std::shared_ptr<Item> item, uint8_t slot, bool protectionCharm) {
	if (!imbuement || !item) {
		return;
	}

	ImbuementInfo imbuementInfo;
	if (item->getImbuementInfo(slot, &imbuementInfo)) {
		g_logger().error("[Player::onApplyImbuement] - An error occurred while player with name {} try to apply imbuement, item already contains imbuement", this->getName());
		this->sendImbuementResult("An error ocurred, please reopen imbuement window.");
		return;
	}

	const auto items = imbuement->getItems();
	for (auto &[key, value] : items) {
		const ItemType &itemType = Item::items[key];
		if (static_self_cast<Player>()->getItemTypeCount(key) + this->getStashItemCount(itemType.id) < value) {
			this->sendImbuementResult("You don't have all necessary items.");
			return;
		}
	}

	const BaseImbuement* baseImbuement = g_imbuements().getBaseByID(imbuement->getBaseID());
	if (!baseImbuement) {
		return;
	}

	uint32_t price = baseImbuement->price;
	price += protectionCharm ? baseImbuement->protectionPrice : 0;

	if (!g_game().removeMoney(static_self_cast<Player>(), price, 0, true)) {
		std::string message = fmt::format("You don't have {} gold coins.", price);

		g_logger().error("[Player::onApplyImbuement] - An error occurred while player with name {} try to apply imbuement, player do not have money", this->getName());
		sendImbuementResult(message);
		return;
	}

	g_metrics().addCounter("balance_decrease", price, { { "player", getName() }, { "context", "apply_imbuement" } });

	for (auto &[key, value] : items) {
		std::stringstream withdrawItemMessage;

		uint32_t inventoryItemCount = getItemTypeCount(key);
		if (inventoryItemCount >= value) {
			removeItemOfType(key, value, -1, true);
			continue;
		}

		uint32_t mathItemCount = value;
		if (inventoryItemCount > 0 && removeItemOfType(key, inventoryItemCount, -1, false)) {
			mathItemCount = mathItemCount - inventoryItemCount;
		}

		const ItemType &itemType = Item::items[key];

		withdrawItemMessage << "Using " << mathItemCount << "x " << itemType.name << " from your supply stash. ";
		withdrawItem(itemType.id, mathItemCount);
		sendTextMessage(MESSAGE_STATUS, withdrawItemMessage.str());
	}

	if (!protectionCharm && uniform_random(1, 100) > baseImbuement->percent) {
		openImbuementWindow(item);
		sendImbuementResult("Oh no!\n\nThe imbuement has failed. You have lost the astral sources and gold you needed for the imbuement.\n\nNext time use a protection charm to better your chances.");
		openImbuementWindow(item);
		return;
	}

	// Update imbuement stats item if the item is equipped
	if (item->getParent() == getPlayer()) {
		addItemImbuementStats(imbuement);
	}

	item->addImbuement(slot, imbuement->getID(), baseImbuement->duration);
	openImbuementWindow(item);
}

void Player::onClearImbuement(std::shared_ptr<Item> item, uint8_t slot) {
	if (!item) {
		return;
	}

	ImbuementInfo imbuementInfo;
	if (!item->getImbuementInfo(slot, &imbuementInfo)) {
		g_logger().error("[Player::onClearImbuement] - An error occurred while player with name {} try to apply imbuement, item not contains imbuement", this->getName());
		this->sendImbuementResult("An error ocurred, please reopen imbuement window.");
		return;
	}

	const BaseImbuement* baseImbuement = g_imbuements().getBaseByID(imbuementInfo.imbuement->getBaseID());
	if (!baseImbuement) {
		return;
	}

	if (!g_game().removeMoney(static_self_cast<Player>(), baseImbuement->removeCost, 0, true)) {
		std::string message = fmt::format("You don't have {} gold coins.", baseImbuement->removeCost);

		g_logger().error("[Player::onClearImbuement] - An error occurred while player with name {} try to apply imbuement, player do not have money", this->getName());
		this->sendImbuementResult(message);
		this->openImbuementWindow(item);
		return;
	}
	g_metrics().addCounter("balance_decrease", baseImbuement->removeCost, { { "player", getName() }, { "context", "clear_imbuement" } });

	if (item->getParent() == getPlayer()) {
		removeItemImbuementStats(imbuementInfo.imbuement);
	}

	item->clearImbuement(slot, imbuementInfo.imbuement->getID());
	this->openImbuementWindow(item);
}

void Player::openImbuementWindow(std::shared_ptr<Item> item) {
	if (!client || !item) {
		return;
	}

	if (item->getImbuementSlot() <= 0) {
		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item is not imbuable.");
		return;
	}

	auto itemParent = item->getTopParent();
	if (itemParent && itemParent != getPlayer()) {
		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to pick up the item to imbue it.");
		return;
	}

	client->openImbuementWindow(item);
}

void Player::sendSaleItemList(const std::map<uint16_t, uint16_t> &inventoryMap) const {
	if (client && shopOwner) {
		client->sendSaleItemList(shopOwner->getShopItemVector(getGUID()), inventoryMap);
	}
}

void Player::sendMarketEnter(uint32_t depotId) {
	if (!client || this->getLastDepotId() == -1 || !depotId) {
		return;
	}

	client->sendMarketEnter(depotId);
}

// container
void Player::sendAddContainerItem(std::shared_ptr<Container> container, std::shared_ptr<Item> item) {
	if (!client) {
		return;
	}

	if (!container) {
		return;
	}

	for (const auto &it : openContainers) {
		const OpenContainer &openContainer = it.second;
		if (openContainer.container != container) {
			continue;
		}

		uint16_t slot = openContainer.index;
		if (container->getID() == ITEM_BROWSEFIELD) {
			uint16_t containerSize = container->size() - 1;
			uint16_t pageEnd = openContainer.index + container->capacity() - 1;
			if (containerSize > pageEnd) {
				slot = pageEnd;
				item = container->getItemByIndex(pageEnd);
			} else {
				slot = containerSize;
			}
		} else if (openContainer.index >= container->capacity()) {
			item = container->getItemByIndex(openContainer.index - 1);
		}
		client->sendAddContainerItem(it.first, slot, item);
	}
}

void Player::sendUpdateContainerItem(std::shared_ptr<Container> container, uint16_t slot, std::shared_ptr<Item> newItem) {
	if (!client) {
		return;
	}

	for (const auto &it : openContainers) {
		const OpenContainer &openContainer = it.second;
		if (openContainer.container != container) {
			continue;
		}

		if (slot < openContainer.index) {
			continue;
		}

		uint16_t pageEnd = openContainer.index + container->capacity();
		if (slot >= pageEnd) {
			continue;
		}

		client->sendUpdateContainerItem(it.first, slot, newItem);
	}
}

void Player::sendRemoveContainerItem(std::shared_ptr<Container> container, uint16_t slot) {
	if (!client) {
		return;
	}

	if (!container) {
		return;
	}

	for (auto &it : openContainers) {
		OpenContainer &openContainer = it.second;
		if (openContainer.container != container) {
			continue;
		}

		uint16_t &firstIndex = openContainer.index;
		if (firstIndex > 0 && firstIndex >= container->size() - 1) {
			firstIndex -= container->capacity();
			sendContainer(it.first, container, false, firstIndex);
		}

		client->sendRemoveContainerItem(it.first, std::max<uint16_t>(slot, firstIndex), container->getItemByIndex(container->capacity() + firstIndex));
	}
}

void Player::onUpdateTileItem(std::shared_ptr<Tile> updateTile, const Position &pos, std::shared_ptr<Item> oldItem, const ItemType &oldType, std::shared_ptr<Item> newItem, const ItemType &newType) {
	Creature::onUpdateTileItem(updateTile, pos, oldItem, oldType, newItem, newType);

	if (oldItem != newItem) {
		onRemoveTileItem(updateTile, pos, oldType, oldItem);
	}

	if (tradeState != TRADE_TRANSFER) {
		if (tradeItem && oldItem == tradeItem) {
			g_game().internalCloseTrade(getPlayer());
		}
	}
}

void Player::onRemoveTileItem(std::shared_ptr<Tile> fromTile, const Position &pos, const ItemType &iType, std::shared_ptr<Item> item) {
	Creature::onRemoveTileItem(fromTile, pos, iType, item);

	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(item);

		if (tradeItem) {
			std::shared_ptr<Container> container = item->getContainer();
			if (container && container->isHoldingItem(tradeItem)) {
				g_game().internalCloseTrade(static_self_cast<Player>());
			}
		}
	}

	checkLootContainers(item->getContainer());
}

void Player::onCreatureAppear(std::shared_ptr<Creature> creature, bool isLogin) {
	Creature::onCreatureAppear(creature, isLogin);

	if (isLogin && creature == getPlayer()) {
		onEquipInventory();

		// Refresh bosstiary tracker onLogin
		refreshCyclopediaMonsterTracker(true);
		// Refresh bestiary tracker onLogin
		refreshCyclopediaMonsterTracker(false);

		for (const auto &condition : storedConditionList) {
			addCondition(condition);
		}
		storedConditionList.clear();

		updateRegeneration();

		std::shared_ptr<BedItem> bed = g_game().getBedBySleeper(guid);
		if (bed) {
			bed->wakeUp(static_self_cast<Player>());
		}

		auto version = client->oldProtocol ? getProtocolVersion() : CLIENT_VERSION;
		g_logger().info("{} has logged in. (Protocol: {})", name, version);

		if (guild) {
			guild->addMember(static_self_cast<Player>());
		}

		int32_t offlineTime;
		if (getLastLogout() != 0) {
			// Not counting more than 21 days to prevent overflow when multiplying with 1000 (for milliseconds).
			offlineTime = std::min<int32_t>(time(nullptr) - getLastLogout(), 86400 * 21);
		} else {
			offlineTime = 0;
		}

		for (const std::shared_ptr<Condition> &condition : getMuteConditions()) {
			condition->setTicks(condition->getTicks() - (offlineTime * 1000));
			if (condition->getTicks() <= 0) {
				removeCondition(condition);
			}
		}

		g_game().checkPlayersRecord();
		IOLoginData::updateOnlineStatus(guid, true);
		if (getLevel() < g_configManager().getNumber(ADVENTURERSBLESSING_LEVEL, __FUNCTION__) && getVocationId() > VOCATION_NONE) {
			for (uint8_t i = 2; i <= 6; i++) {
				if (!hasBlessing(i)) {
					addBlessing(i, 1);
				}
			}
			sendBlessStatus();
		}

		if (getCurrentMount() != 0) {
			toggleMount(true);
		}

		g_game().changePlayerSpeed(static_self_cast<Player>(), 0);
	}
}

void Player::onAttackedCreatureDisappear(bool isLogout) {
	sendCancelTarget();

	if (!isLogout) {
		sendTextMessage(MESSAGE_FAILURE, "Target lost.");
	}
}

void Player::onFollowCreatureDisappear(bool isLogout) {
	sendCancelTarget();

	if (!isLogout) {
		sendTextMessage(MESSAGE_FAILURE, "Target lost.");
	}
}

void Player::onChangeZone(ZoneType_t zone) {
	if (zone == ZONE_PROTECTION) {
		if (getAttackedCreature() && !hasFlag(PlayerFlags_t::IgnoreProtectionZone)) {
			setAttackedCreature(nullptr);
			onAttackedCreatureDisappear(false);
		}

		if (!g_configManager().getBoolean(TOGGLE_MOUNT_IN_PZ, __FUNCTION__) && !group->access && isMounted()) {
			dismount();
			g_game().internalCreatureChangeOutfit(getPlayer(), defaultOutfit);
			wasMounted = true;
		}
	} else {
		int32_t ticks = g_configManager().getNumber(STAIRHOP_DELAY, __FUNCTION__);
		if (ticks > 0) {
			if (const auto &condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_PACIFIED, ticks, 0)) {
				addCondition(condition);
			}
		}
		if (wasMounted) {
			toggleMount(true);
			wasMounted = false;
		}
	}

	updateImbuementTrackerStats();
	wheel()->onThink(true);
	wheel()->sendGiftOfLifeCooldown();
	g_game().updateCreatureWalkthrough(static_self_cast<Player>());
	sendIcons();
	g_events().eventPlayerOnChangeZone(static_self_cast<Player>(), zone);

	g_callbacks().executeCallback(EventCallback_t::playerOnChangeZone, &EventCallback::playerOnChangeZone, getPlayer(), zone);
}

void Player::onAttackedCreatureChangeZone(ZoneType_t zone) {
	auto attackedCreature = getAttackedCreature();
	if (!attackedCreature) {
		return;
	}
	if (zone == ZONE_PROTECTION) {
		if (!hasFlag(PlayerFlags_t::IgnoreProtectionZone)) {
			setAttackedCreature(nullptr);
			onAttackedCreatureDisappear(false);
		}
	} else if (zone == ZONE_NOPVP) {
		if (attackedCreature->getPlayer()) {
			if (!hasFlag(PlayerFlags_t::IgnoreProtectionZone)) {
				setAttackedCreature(nullptr);
				onAttackedCreatureDisappear(false);
			}
		}
	} else if (zone == ZONE_NORMAL && g_game().getWorldType() == WORLD_TYPE_NO_PVP) {
		// attackedCreature can leave a pvp zone if not pzlocked
		if (attackedCreature->getPlayer()) {
			setAttackedCreature(nullptr);
			onAttackedCreatureDisappear(false);
		}
	}
}

void Player::onRemoveCreature(std::shared_ptr<Creature> creature, bool isLogout) {
	Creature::onRemoveCreature(creature, isLogout);

	if (auto player = getPlayer(); player == creature) {
		if (isLogout) {
			onDeEquipInventory();

			if (m_party) {
				m_party->leaveParty(player);
			}
			if (guild) {
				guild->removeMember(player);
			}

			g_game().removePlayerUniqueLogin(player);
			loginPosition = getPosition();
			lastLogout = time(nullptr);
			g_logger().info("{} has logged out", getName());
			g_chat().removeUserFromAllChannels(player);
			clearPartyInvitations();
			IOLoginData::updateOnlineStatus(guid, false);
		}

		if (eventWalk != 0) {
			setFollowCreature(nullptr);
		}

		if (tradePartner) {
			g_game().internalCloseTrade(player);
		}

		closeShopWindow();

		g_saveManager().savePlayer(player);
	}

	if (creature == shopOwner) {
		setShopOwner(nullptr);
		sendCloseShop();
	}
}

bool Player::openShopWindow(std::shared_ptr<Npc> npc, const std::vector<ShopBlock> &shopItems) {
	Benchmark brenchmark;
	if (!npc) {
		g_logger().error("[Player::openShopWindow] - Npc is wrong or nullptr");
		return false;
	}

	if (npc->isShopPlayer(getGUID())) {
		g_logger().debug("[Player::openShopWindow] - Player {} is already in shop window", getName());
		return false;
	}

	npc->addShopPlayer(getGUID(), shopItems);

	setShopOwner(npc);

	sendShop(npc);
	std::map<uint16_t, uint16_t> inventoryMap;
	sendSaleItemList(getAllSaleItemIdAndCount(inventoryMap));

	g_logger().debug("[Player::openShopWindow] - Player {} has opened shop window in {} ms", getName(), brenchmark.duration());
	return true;
}

bool Player::closeShopWindow() {
	if (!shopOwner) {
		return false;
	}

	shopOwner->removeShopPlayer(getGUID());
	setShopOwner(nullptr);

	sendCloseShop();
	return true;
}

void Player::onWalk(Direction &dir) {
	if (hasCondition(CONDITION_FEARED)) {
		Position pos = getNextPosition(dir, getPosition());

		std::shared_ptr<Tile> tile = g_game().map.getTile(pos);
		if (tile) {
			std::shared_ptr<MagicField> field = tile->getFieldItem();
			if (field && !field->isBlocking() && field->getDamage() != 0) {
				setNextActionTask(nullptr);
				setNextAction(OTSYS_TIME() + getStepDuration(dir));
				return;
			}
		}
	}

	Creature::onWalk(dir);
	setNextActionTask(nullptr);

	g_callbacks().executeCallback(EventCallback_t::playerOnWalk, &EventCallback::playerOnWalk, getPlayer(), dir);
}

void Player::onCreatureMove(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &newTile, const Position &newPos, const std::shared_ptr<Tile> &oldTile, const Position &oldPos, bool teleport) {
	Creature::onCreatureMove(creature, newTile, newPos, oldTile, oldPos, teleport);

	const auto &followCreature = getFollowCreature();
	if (hasFollowPath && (creature == followCreature || (creature.get() == this && followCreature))) {
		isUpdatingPath = false;
		g_dispatcher().addEvent([creatureId = getID()] { g_game().updateCreatureWalk(creatureId); }, "Game::updateCreatureWalk");
	}

	if (creature != getPlayer()) {
		return;
	}

	if (tradeState != TRADE_TRANSFER) {
		// check if we should close trade
		if (tradeItem && !Position::areInRange<1, 1, 0>(tradeItem->getPosition(), getPosition())) {
			g_game().internalCloseTrade(getPlayer());
		}

		if (tradePartner && !Position::areInRange<2, 2, 0>(tradePartner->getPosition(), getPosition())) {
			g_game().internalCloseTrade(getPlayer());
		}
	}

	// close modal windows
	if (!modalWindows.empty()) {
		// TODO: This shouldn't be hardcoded
		for (uint32_t modalWindowId : modalWindows) {
			if (modalWindowId == std::numeric_limits<uint32_t>::max()) {
				sendTextMessage(MESSAGE_EVENT_ADVANCE, "Offline training aborted.");
				break;
			}
		}
		modalWindows.clear();
	}

	// leave market
	if (inMarket) {
		inMarket = false;
	}

	if (m_party) {
		m_party->updateSharedExperience();
		m_party->updatePlayerStatus(getPlayer(), oldPos, newPos);
	}

	if (teleport || oldPos.z != newPos.z) {
		int32_t ticks = g_configManager().getNumber(STAIRHOP_DELAY, __FUNCTION__);
		if (ticks > 0) {
			if (const auto &condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_PACIFIED, ticks, 0)) {
				addCondition(condition);
			}
		}
	}
}

void Player::onEquipInventory() {
	for (int32_t slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; ++slot) {
		std::shared_ptr<Item> item = inventory[slot];
		if (item) {
			item->startDecaying();
			g_moveEvents().onPlayerEquip(getPlayer(), item, static_cast<Slots_t>(slot), false);
		}
	}
}

void Player::onDeEquipInventory() {
	for (int32_t slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; ++slot) {
		std::shared_ptr<Item> item = inventory[slot];
		if (item) {
			g_moveEvents().onPlayerDeEquip(getPlayer(), item, static_cast<Slots_t>(slot));
		}
	}
}

// container
void Player::onAddContainerItem(std::shared_ptr<Item> item) {
	checkTradeState(item);
}

void Player::onUpdateContainerItem(std::shared_ptr<Container> container, std::shared_ptr<Item> oldItem, std::shared_ptr<Item> newItem) {
	if (oldItem != newItem) {
		onRemoveContainerItem(container, oldItem);
	}

	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(oldItem);
	}
}

void Player::onRemoveContainerItem(std::shared_ptr<Container> container, std::shared_ptr<Item> item) {
	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(item);

		if (tradeItem) {
			if (tradeItem->getParent() != container && container->isHoldingItem(tradeItem)) {
				g_game().internalCloseTrade(static_self_cast<Player>());
			}
		}
	}

	checkLootContainers(item->getContainer());
}

void Player::onCloseContainer(std::shared_ptr<Container> container) {
	if (!client) {
		return;
	}

	for (const auto &it : openContainers) {
		if (it.second.container == container) {
			client->sendCloseContainer(it.first);
		}
	}
}

void Player::onSendContainer(std::shared_ptr<Container> container) {
	if (!client || !container) {
		return;
	}

	bool hasParent = container->hasParent();
	for (const auto &it : openContainers) {
		const OpenContainer &openContainer = it.second;
		if (openContainer.container == container) {
			client->sendContainer(it.first, container, hasParent, openContainer.index);
		}
	}
}

// inventory
void Player::onUpdateInventoryItem(std::shared_ptr<Item> oldItem, std::shared_ptr<Item> newItem) {
	if (oldItem != newItem) {
		onRemoveInventoryItem(oldItem);
	}

	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(oldItem);
	}
}

void Player::onRemoveInventoryItem(std::shared_ptr<Item> item) {
	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(item);

		if (tradeItem) {
			std::shared_ptr<Container> container = item->getContainer();
			if (container && container->isHoldingItem(tradeItem)) {
				g_game().internalCloseTrade(static_self_cast<Player>());
			}
		}
	}

	checkLootContainers(item->getContainer());
}

void Player::checkTradeState(std::shared_ptr<Item> item) {
	if (!tradeItem || tradeState == TRADE_TRANSFER) {
		return;
	}

	if (tradeItem == item) {
		g_game().internalCloseTrade(static_self_cast<Player>());
	} else {
		std::shared_ptr<Container> container = std::dynamic_pointer_cast<Container>(item->getParent());
		while (container) {
			if (container == tradeItem) {
				g_game().internalCloseTrade(static_self_cast<Player>());
				break;
			}

			container = std::dynamic_pointer_cast<Container>(container->getParent());
		}
	}
}

void Player::setNextWalkActionTask(std::shared_ptr<Task> task) {
	if (walkTaskEvent != 0) {
		g_dispatcher().stopEvent(walkTaskEvent);
		walkTaskEvent = 0;
	}

	walkTask = task;
}

void Player::setNextWalkTask(std::shared_ptr<Task> task) {
	if (nextStepEvent != 0) {
		g_dispatcher().stopEvent(nextStepEvent);
		nextStepEvent = 0;
	}

	if (task) {
		nextStepEvent = g_dispatcher().scheduleEvent(task);
		resetIdleTime();
	}
}

void Player::setNextActionTask(std::shared_ptr<Task> task, bool resetIdleTime /*= true */) {
	if (actionTaskEvent != 0) {
		g_dispatcher().stopEvent(actionTaskEvent);
		actionTaskEvent = 0;
	}

	if (!inEventMovePush && !g_configManager().getBoolean(PUSH_WHEN_ATTACKING, __FUNCTION__)) {
		cancelPush();
	}

	if (task) {
		actionTaskEvent = g_dispatcher().scheduleEvent(task);
		if (resetIdleTime) {
			this->resetIdleTime();
		}
	}
}

void Player::setNextActionPushTask(std::shared_ptr<Task> task) {
	if (actionTaskEventPush != 0) {
		g_dispatcher().stopEvent(actionTaskEventPush);
		actionTaskEventPush = 0;
	}

	if (task) {
		actionTaskEventPush = g_dispatcher().scheduleEvent(task);
	}
}

void Player::setNextPotionActionTask(std::shared_ptr<Task> task) {
	if (actionPotionTaskEvent != 0) {
		g_dispatcher().stopEvent(actionPotionTaskEvent);
		actionPotionTaskEvent = 0;
	}

	cancelPush();

	if (task) {
		actionPotionTaskEvent = g_dispatcher().scheduleEvent(task);
		// resetIdleTime();
	}
}

uint32_t Player::getNextActionTime() const {
	return std::max<int64_t>(SCHEDULER_MINTICKS, nextAction - OTSYS_TIME());
}

uint32_t Player::getNextPotionActionTime() const {
	return std::max<int64_t>(SCHEDULER_MINTICKS, nextPotionAction - OTSYS_TIME());
}

void Player::cancelPush() {
	if (actionTaskEventPush != 0) {
		g_dispatcher().stopEvent(actionTaskEventPush);
		actionTaskEventPush = 0;
		inEventMovePush = false;
	}
}

void Player::onThink(uint32_t interval) {
	Creature::onThink(interval);

	sendPing();

	MessageBufferTicks += interval;
	if (MessageBufferTicks >= 1500) {
		MessageBufferTicks = 0;
		addMessageBuffer();
	}

	// Transcendance (avatar trigger)
	triggerTranscendance();
	// Momentum (cooldown resets)
	triggerMomentum();
	auto playerTile = getTile();
	const bool vipStaysOnline = isVip() && g_configManager().getBoolean(VIP_STAY_ONLINE, __FUNCTION__);
	idleTime += interval;
	if (playerTile && !playerTile->hasFlag(TILESTATE_NOLOGOUT) && !isAccessPlayer() && !isExerciseTraining() && !vipStaysOnline) {
		const int32_t kickAfterMinutes = g_configManager().getNumber(KICK_AFTER_MINUTES, __FUNCTION__);
		if (idleTime > (kickAfterMinutes * 60000) + 60000) {
			removePlayer(true);
		} else if (client && idleTime == 60000 * kickAfterMinutes) {
			std::ostringstream ss;
			ss << "There was no variation in your behaviour for " << kickAfterMinutes << " minutes. You will be disconnected in one minute if there is no change in your actions until then.";
			client->sendTextMessage(TextMessage(MESSAGE_ADMINISTRATOR, ss.str()));
		}
	}

	if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
		checkSkullTicks(interval / 1000);
	}

	addOfflineTrainingTime(interval);
	if (lastStatsTrainingTime != getOfflineTrainingTime() / 60 / 1000) {
		sendStats();
	}

	// Wheel of destiny major spells
	wheel()->onThink();
}

uint32_t Player::isMuted() const {
	if (hasFlag(PlayerFlags_t::CannotBeMuted)) {
		return 0;
	}

	int32_t muteTicks = 0;
	for (const std::shared_ptr<Condition> &condition : conditions) {
		if (condition->getType() == CONDITION_MUTED && condition->getTicks() > muteTicks) {
			muteTicks = condition->getTicks();
		}
	}
	return static_cast<uint32_t>(muteTicks) / 1000;
}

void Player::addMessageBuffer() {
	if (MessageBufferCount > 0 && g_configManager().getNumber(MAX_MESSAGEBUFFER, __FUNCTION__) != 0 && !hasFlag(PlayerFlags_t::CannotBeMuted)) {
		--MessageBufferCount;
	}
}

void Player::removeMessageBuffer() {
	if (hasFlag(PlayerFlags_t::CannotBeMuted)) {
		return;
	}

	const int32_t maxMessageBuffer = g_configManager().getNumber(MAX_MESSAGEBUFFER, __FUNCTION__);
	if (maxMessageBuffer != 0 && MessageBufferCount <= maxMessageBuffer + 1) {
		if (++MessageBufferCount > maxMessageBuffer) {
			uint32_t muteCount = 1;
			auto it = muteCountMap.find(guid);
			if (it != muteCountMap.end()) {
				muteCount = it->second;
			}

			uint32_t muteTime = 5 * muteCount * muteCount;
			muteCountMap[guid] = muteCount + 1;
			std::shared_ptr<Condition> condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_MUTED, muteTime * 1000, 0);
			addCondition(condition);

			std::ostringstream ss;
			ss << "You are muted for " << muteTime << " seconds.";
			sendTextMessage(MESSAGE_FAILURE, ss.str());
		}
	}
}

void Player::drainHealth(std::shared_ptr<Creature> attacker, int32_t damage) {
	if (PLAYER_SOUND_HEALTH_CHANGE >= static_cast<uint32_t>(uniform_random(1, 100))) {
		g_game().sendSingleSoundEffect(static_self_cast<Player>()->getPosition(), sex == PLAYERSEX_FEMALE ? SoundEffect_t::HUMAN_FEMALE_BARK : SoundEffect_t::HUMAN_MALE_BARK, getPlayer());
	}

	Creature::drainHealth(attacker, damage);
	sendStats();
}

void Player::drainMana(std::shared_ptr<Creature> attacker, int32_t manaLoss) {
	Creature::drainMana(attacker, manaLoss);
	sendStats();
}

void Player::addManaSpent(uint64_t amount) {
	if (hasFlag(PlayerFlags_t::NotGainMana)) {
		return;
	}

	uint64_t currReqMana = vocation->getReqMana(magLevel);
	uint64_t nextReqMana = vocation->getReqMana(magLevel + 1);
	if (currReqMana >= nextReqMana) {
		// player has reached max magic level
		return;
	}

	g_events().eventPlayerOnGainSkillTries(static_self_cast<Player>(), SKILL_MAGLEVEL, amount);
	g_callbacks().executeCallback(EventCallback_t::playerOnGainSkillTries, &EventCallback::playerOnGainSkillTries, getPlayer(), SKILL_MAGLEVEL, amount);
	if (amount == 0) {
		return;
	}

	bool sendUpdateStats = false;
	while ((manaSpent + amount) >= nextReqMana) {
		amount -= nextReqMana - manaSpent;

		magLevel++;
		manaSpent = 0;

		std::ostringstream ss;
		ss << "You advanced to magic level " << magLevel << '.';
		sendTextMessage(MESSAGE_EVENT_ADVANCE, ss.str());
		sendTakeScreenshot(SCREENSHOT_TYPE_SKILLUP);

		g_creatureEvents().playerAdvance(static_self_cast<Player>(), SKILL_MAGLEVEL, magLevel - 1, magLevel);
		sendTakeScreenshot(SCREENSHOT_TYPE_SKILLUP);

		sendUpdateStats = true;
		currReqMana = nextReqMana;
		nextReqMana = vocation->getReqMana(magLevel + 1);
		if (currReqMana >= nextReqMana) {
			return;
		}
	}

	manaSpent += amount;

	uint8_t oldPercent = magLevelPercent;
	if (nextReqMana > currReqMana) {
		magLevelPercent = Player::getPercentLevel(manaSpent, nextReqMana);
	} else {
		magLevelPercent = 0;
	}

	if (oldPercent != magLevelPercent) {
		sendUpdateStats = true;
	}

	if (sendUpdateStats) {
		sendStats();
		sendSkills();
	}
}

void Player::addExperience(std::shared_ptr<Creature> target, uint64_t exp, bool sendText /* = false*/) {
	uint64_t currLevelExp = Player::getExpForLevel(level);
	uint64_t nextLevelExp = Player::getExpForLevel(level + 1);
	uint64_t rawExp = exp;
	if (currLevelExp >= nextLevelExp) {
		// player has reached max level
		levelPercent = 0;
		sendStats();
		return;
	}

	g_callbacks().executeCallback(EventCallback_t::playerOnGainExperience, &EventCallback::playerOnGainExperience, getPlayer(), target, exp, rawExp);

	g_events().eventPlayerOnGainExperience(static_self_cast<Player>(), target, exp, rawExp);
	if (exp == 0) {
		return;
	}

	auto rate = exp / rawExp;
	std::map<std::string, std::string> attrs({ { "player", getName() }, { "level", std::to_string(getLevel()) }, { "rate", std::to_string(rate) } });
	if (sendText) {
		g_metrics().addCounter("player_experience_raw", rawExp, attrs);
		g_metrics().addCounter("player_experience_actual", exp, attrs);
	} else {
		g_metrics().addCounter("player_experience_bonus_raw", rawExp, attrs);
		g_metrics().addCounter("player_experience_bonus_actual", exp, attrs);
	}

	// Hazard system experience
	std::shared_ptr<Monster> monster = target && target->getMonster() ? target->getMonster() : nullptr;
	bool handleHazardExperience = monster && monster->getHazard() && getHazardSystemPoints() > 0;
	if (handleHazardExperience) {
		exp += (exp * (1.75 * getHazardSystemPoints() * g_configManager().getFloat(HAZARD_EXP_BONUS_MULTIPLIER, __FUNCTION__))) / 100.;
	}

	experience += exp;

	if (sendText) {
		std::string expString = fmt::format("{} experience point{}.", exp, (exp != 1 ? "s" : ""));
		if (isVip()) {
			uint8_t expPercent = g_configManager().getNumber(VIP_BONUS_EXP, __FUNCTION__);
			if (expPercent > 0) {
				expString = expString + fmt::format(" (VIP bonus {}%)", expPercent > 100 ? 100 : expPercent);
			}
		}

		TextMessage message(MESSAGE_EXPERIENCE, "You gained " + expString + (handleHazardExperience ? " (Hazard)" : ""));
		message.position = position;
		message.primary.value = exp;
		message.primary.color = TEXTCOLOR_WHITE_EXP;
		sendTextMessage(message);

		auto spectators = Spectators().find<Player>(position);
		spectators.erase(static_self_cast<Player>());
		if (!spectators.empty()) {
			message.type = MESSAGE_EXPERIENCE_OTHERS;
			message.text = getName() + " gained " + expString;
			for (const std::shared_ptr<Creature> &spectator : spectators) {
				spectator->getPlayer()->sendTextMessage(message);
			}
		}
	}

	uint32_t prevLevel = level;
	while (experience >= nextLevelExp) {
		++level;
		// Player stats gain for vocations level <= 8
		if (vocation->getId() != VOCATION_NONE && level <= 8) {
			const auto &noneVocation = g_vocations().getVocation(VOCATION_NONE);
			healthMax += noneVocation->getHPGain();
			health += noneVocation->getHPGain();
			manaMax += noneVocation->getManaGain();
			mana += noneVocation->getManaGain();
			capacity += noneVocation->getCapGain();
		} else {
			healthMax += vocation->getHPGain();
			health += vocation->getHPGain();
			manaMax += vocation->getManaGain();
			mana += vocation->getManaGain();
			capacity += vocation->getCapGain();
		}

		currLevelExp = nextLevelExp;
		nextLevelExp = Player::getExpForLevel(level + 1);
		if (currLevelExp >= nextLevelExp) {
			// player has reached max level
			break;
		}
	}

	if (prevLevel != level) {
		health = healthMax;
		mana = manaMax;

		updateBaseSpeed();
		setBaseSpeed(getBaseSpeed());
		g_game().changeSpeed(static_self_cast<Player>(), 0);
		g_game().addCreatureHealth(static_self_cast<Player>());
		g_game().addPlayerMana(static_self_cast<Player>());

		if (m_party) {
			m_party->updateSharedExperience();
		}

		g_creatureEvents().playerAdvance(static_self_cast<Player>(), SKILL_LEVEL, prevLevel, level);

		std::ostringstream ss;
		ss << "You advanced from Level " << prevLevel << " to Level " << level << '.';
		sendTextMessage(MESSAGE_EVENT_ADVANCE, ss.str());
		sendTakeScreenshot(SCREENSHOT_TYPE_LEVELUP);
	}

	if (nextLevelExp > currLevelExp) {
		levelPercent = Player::getPercentLevel(experience - currLevelExp, nextLevelExp - currLevelExp);
	} else {
		levelPercent = 0;
	}
	sendStats();
	sendExperienceTracker(rawExp, exp);
}

void Player::removeExperience(uint64_t exp, bool sendText /* = false*/) {
	if (experience == 0 || exp == 0) {
		return;
	}

	g_events().eventPlayerOnLoseExperience(static_self_cast<Player>(), exp);
	g_callbacks().executeCallback(EventCallback_t::playerOnLoseExperience, &EventCallback::playerOnLoseExperience, getPlayer(), exp);
	if (exp == 0) {
		return;
	}

	uint64_t lostExp = experience;
	experience = std::max<int64_t>(0, experience - exp);

	if (sendText) {
		lostExp -= experience;

		std::string expString = fmt::format("You lost {} experience point{}.", lostExp, (lostExp != 1 ? "s" : ""));

		TextMessage message(MESSAGE_EXPERIENCE, expString);
		message.position = position;
		message.primary.value = lostExp;
		message.primary.color = TEXTCOLOR_RED;
		sendTextMessage(message);

		auto spectators = Spectators().find<Player>(position);
		spectators.erase(static_self_cast<Player>());
		if (!spectators.empty()) {
			message.type = MESSAGE_EXPERIENCE_OTHERS;
			message.text = getName() + " lost " + expString;
			for (const std::shared_ptr<Creature> &spectator : spectators) {
				spectator->getPlayer()->sendTextMessage(message);
			}
		}
	}

	uint32_t oldLevel = level;
	uint64_t currLevelExp = Player::getExpForLevel(level);

	while (level > 1 && experience < currLevelExp) {
		--level;
		// Player stats loss for vocations level <= 8
		if (vocation->getId() != VOCATION_NONE && level <= 8) {
			const auto &noneVocation = g_vocations().getVocation(VOCATION_NONE);
			healthMax = std::max<int32_t>(0, healthMax - noneVocation->getHPGain());
			manaMax = std::max<int32_t>(0, manaMax - noneVocation->getManaGain());
			capacity = std::max<int32_t>(0, capacity - noneVocation->getCapGain());
		} else {
			healthMax = std::max<int32_t>(0, healthMax - vocation->getHPGain());
			manaMax = std::max<int32_t>(0, manaMax - vocation->getManaGain());
			capacity = std::max<int32_t>(0, capacity - vocation->getCapGain());
		}
		currLevelExp = Player::getExpForLevel(level);
	}

	if (oldLevel != level) {
		health = healthMax;
		mana = manaMax;

		updateBaseSpeed();
		setBaseSpeed(getBaseSpeed());

		g_game().changeSpeed(static_self_cast<Player>(), 0);
		g_game().addCreatureHealth(static_self_cast<Player>());
		g_game().addPlayerMana(static_self_cast<Player>());

		if (m_party) {
			m_party->updateSharedExperience();
		}

		std::ostringstream ss;
		ss << "You were downgraded from Level " << oldLevel << " to Level " << level << '.';
		sendTextMessage(MESSAGE_EVENT_ADVANCE, ss.str());
	}

	uint64_t nextLevelExp = Player::getExpForLevel(level + 1);
	if (nextLevelExp > currLevelExp) {
		levelPercent = Player::getPercentLevel(experience - currLevelExp, nextLevelExp - currLevelExp);
	} else {
		levelPercent = 0;
	}
	sendStats();
	sendExperienceTracker(0, -static_cast<int64_t>(exp));
}

double_t Player::getPercentLevel(uint64_t count, uint64_t nextLevelCount) {
	if (nextLevelCount == 0) {
		return 0;
	}

	double_t result = round(((count * 100.) / nextLevelCount) * 100.) / 100.;
	if (result > 100) {
		return 0;
	}
	return result;
}

void Player::onBlockHit() {
	if (shieldBlockCount > 0) {
		--shieldBlockCount;

		if (hasShield()) {
			addSkillAdvance(SKILL_SHIELD, 1);
		}
	}
}

void Player::onTakeDamage(std::shared_ptr<Creature> attacker, int32_t damage) {
	// nothing here yet
}

void Player::onAttackedCreatureBlockHit(BlockType_t blockType) {
	lastAttackBlockType = blockType;

	switch (blockType) {
		case BLOCK_NONE: {
			addAttackSkillPoint = true;
			bloodHitCount = 30;
			shieldBlockCount = 30;
			break;
		}

		case BLOCK_DEFENSE:
		case BLOCK_ARMOR: {
			// need to draw blood every 30 hits
			if (bloodHitCount > 0) {
				addAttackSkillPoint = true;
				--bloodHitCount;
			} else {
				addAttackSkillPoint = false;
			}
			break;
		}

		default: {
			addAttackSkillPoint = false;
			break;
		}
	}
}

bool Player::hasShield() const {
	std::shared_ptr<Item> item = inventory[CONST_SLOT_LEFT];
	if (item && item->getWeaponType() == WEAPON_SHIELD) {
		return true;
	}

	item = inventory[CONST_SLOT_RIGHT];
	if (item && item->getWeaponType() == WEAPON_SHIELD) {
		return true;
	}
	return false;
}

BlockType_t Player::blockHit(std::shared_ptr<Creature> attacker, CombatType_t combatType, int32_t &damage, bool checkDefense /* = false*/, bool checkArmor /* = false*/, bool field /* = false*/) {
	BlockType_t blockType = Creature::blockHit(attacker, combatType, damage, checkDefense, checkArmor, field);
	if (attacker) {
		sendCreatureSquare(attacker, SQ_COLOR_BLACK);
	}

	if (blockType != BLOCK_NONE) {
		return blockType;
	}

	if (damage > 0) {
		for (int32_t slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; ++slot) {
			if (!isItemAbilityEnabled(static_cast<Slots_t>(slot))) {
				continue;
			}

			std::shared_ptr<Item> item = inventory[slot];
			if (!item) {
				continue;
			}

			const ItemType &it = Item::items[item->getID()];
			if (it.abilities) {
				const int16_t &absorbPercent = it.abilities->absorbPercent[combatTypeToIndex(combatType)];
				auto charges = item->getAttribute<uint16_t>(ItemAttribute_t::CHARGES);
				if (absorbPercent != 0) {
					damage -= std::round(damage * (absorbPercent / 100.));
					if (charges != 0) {
						g_game().transformItem(item, item->getID(), charges - 1);
					}
				}

				if (field) {
					const int16_t &fieldAbsorbPercent = it.abilities->fieldAbsorbPercent[combatTypeToIndex(combatType)];
					if (fieldAbsorbPercent != 0) {
						damage -= std::round(damage * (fieldAbsorbPercent / 100.));
						if (charges != 0) {
							g_game().transformItem(item, item->getID(), charges - 1);
						}
					}
				}
			}

			for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
				ImbuementInfo imbuementInfo;
				if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
					continue;
				}

				const int16_t &imbuementAbsorbPercent = imbuementInfo.imbuement->absorbPercent[combatTypeToIndex(combatType)];

				if (imbuementAbsorbPercent != 0) {
					damage -= std::ceil(damage * (imbuementAbsorbPercent / 100.));
				}
			}
		}

		// Wheel of destiny - apply resistance
		wheel()->adjustDamageBasedOnResistanceAndSkill(damage, combatType);

		if (damage <= 0) {
			damage = 0;
			blockType = BLOCK_ARMOR;
		}
	}

	return blockType;
}

void Player::death(std::shared_ptr<Creature> lastHitCreature) {
	if (!g_configManager().getBoolean(TOGGLE_MOUNT_IN_PZ, __FUNCTION__) && isMounted()) {
		dismount();
		g_game().internalCreatureChangeOutfit(getPlayer(), defaultOutfit);
	}

	loginPosition = town->getTemplePosition();

	g_game().sendSingleSoundEffect(static_self_cast<Player>()->getPosition(), sex == PLAYERSEX_FEMALE ? SoundEffect_t::HUMAN_FEMALE_DEATH : SoundEffect_t::HUMAN_MALE_DEATH, getPlayer());
	if (skillLoss) {
		uint8_t unfairFightReduction = 100;
		int playerDmg = 0;
		int othersDmg = 0;
		uint32_t sumLevels = 0;
		uint32_t inFightTicks = 5 * 60 * 1000;
		for (const auto &it : damageMap) {
			CountBlock_t cb = it.second;
			if ((OTSYS_TIME() - cb.ticks) <= inFightTicks) {
				std::shared_ptr<Player> damageDealer = g_game().getPlayerByID(it.first);
				if (damageDealer) {
					playerDmg += cb.total;
					sumLevels += damageDealer->getLevel();
				} else {
					othersDmg += cb.total;
				}
			}
		}
		bool pvpDeath = false;
		if (playerDmg > 0 || othersDmg > 0) {
			pvpDeath = (Player::lastHitIsPlayer(lastHitCreature) || playerDmg / (playerDmg + static_cast<double>(othersDmg)) >= 0.05);
		}
		if (pvpDeath && sumLevels > level) {
			double reduce = level / static_cast<double>(sumLevels);
			unfairFightReduction = std::max<uint8_t>(20, std::floor((reduce * 100) + 0.5));
		}

		// Magic level loss
		uint64_t sumMana = 0;
		uint64_t lostMana = 0;

		// sum up all the mana
		for (uint32_t i = 1; i <= magLevel; ++i) {
			sumMana += vocation->getReqMana(i);
		}

		sumMana += manaSpent;

		double deathLossPercent = getLostPercent() * (unfairFightReduction / 100.);

		// Charm bless bestiary
		if (lastHitCreature && lastHitCreature->getMonster()) {
			if (charmRuneBless != 0) {
				const auto mType = g_monsters().getMonsterType(lastHitCreature->getName());
				if (mType && mType->info.raceid == charmRuneBless) {
					deathLossPercent = (deathLossPercent * 90) / 100;
				}
			}
		}

		lostMana = static_cast<uint64_t>(sumMana * deathLossPercent);

		while (lostMana > manaSpent && magLevel > 0) {
			lostMana -= manaSpent;
			manaSpent = vocation->getReqMana(magLevel);
			magLevel--;
		}

		manaSpent -= lostMana;

		uint64_t nextReqMana = vocation->getReqMana(magLevel + 1);
		if (nextReqMana > vocation->getReqMana(magLevel)) {
			magLevelPercent = Player::getPercentLevel(manaSpent, nextReqMana);
		} else {
			magLevelPercent = 0;
		}

		// Level loss
		uint64_t expLoss = static_cast<uint64_t>(experience * deathLossPercent);
		g_events().eventPlayerOnLoseExperience(static_self_cast<Player>(), expLoss);
		g_callbacks().executeCallback(EventCallback_t::playerOnLoseExperience, &EventCallback::playerOnLoseExperience, getPlayer(), expLoss);

		sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are dead.");
		std::ostringstream lostExp;
		lostExp << "You lost " << expLoss << " experience.";

		// Skill loss
		for (uint8_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) { // for each skill
			uint64_t sumSkillTries = 0;
			for (uint16_t c = 11; c <= skills[i].level; ++c) { // sum up all required tries for all skill levels
				sumSkillTries += vocation->getReqSkillTries(i, c);
			}

			sumSkillTries += skills[i].tries;

			uint32_t lostSkillTries = static_cast<uint32_t>(sumSkillTries * deathLossPercent);
			while (lostSkillTries > skills[i].tries) {
				lostSkillTries -= skills[i].tries;

				if (skills[i].level <= 10) {
					skills[i].level = 10;
					skills[i].tries = 0;
					lostSkillTries = 0;
					break;
				}

				skills[i].tries = vocation->getReqSkillTries(i, skills[i].level);
				skills[i].level--;
			}

			skills[i].tries = std::max<int32_t>(0, skills[i].tries - lostSkillTries);
			skills[i].percent = Player::getPercentLevel(skills[i].tries, vocation->getReqSkillTries(i, skills[i].level));
		}

		sendTextMessage(MESSAGE_EVENT_ADVANCE, lostExp.str());

		if (expLoss != 0) {
			uint32_t oldLevel = level;

			if (vocation->getId() == VOCATION_NONE || level > 7) {
				experience -= expLoss;
			}

			while (level > 1 && experience < Player::getExpForLevel(level)) {
				--level;
				healthMax = std::max<int32_t>(0, healthMax - vocation->getHPGain());
				manaMax = std::max<int32_t>(0, manaMax - vocation->getManaGain());
				capacity = std::max<int32_t>(0, capacity - vocation->getCapGain());
			}

			if (oldLevel != level) {
				std::ostringstream ss;
				ss << "You were downgraded from Level " << oldLevel << " to Level " << level << '.';
				sendTextMessage(MESSAGE_EVENT_ADVANCE, ss.str());
			}

			uint64_t currLevelExp = Player::getExpForLevel(level);
			uint64_t nextLevelExp = Player::getExpForLevel(level + 1);
			if (nextLevelExp > currLevelExp) {
				levelPercent = Player::getPercentLevel(experience - currLevelExp, nextLevelExp - currLevelExp);
			} else {
				levelPercent = 0;
			}
		}

		std::ostringstream deathType;
		deathType << "You died during ";
		if (pvpDeath) {
			deathType << "PvP.";
		} else {
			deathType << "PvE.";
		}
		sendTextMessage(MESSAGE_EVENT_ADVANCE, deathType.str());

		auto adventurerBlessingLevel = g_configManager().getNumber(ADVENTURERSBLESSING_LEVEL, __FUNCTION__);
		auto willNotLoseBless = getLevel() < adventurerBlessingLevel && getVocationId() > VOCATION_NONE;

		std::string bless = getBlessingsName();
		std::ostringstream blessOutput;
		if (willNotLoseBless) {
			blessOutput << fmt::format("You still have adventurer's blessings for being level lower than {}!", adventurerBlessingLevel);
		} else {
			bless.empty() ? blessOutput << "You weren't protected with any blessings."
						  : blessOutput << "You were blessed with " << bless;

			// Make player lose bless
			uint8_t maxBlessing = 8;
			if (pvpDeath && hasBlessing(1)) {
				removeBlessing(1, 1); // Remove TOF only
			} else {
				for (int i = 2; i <= maxBlessing; i++) {
					removeBlessing(i, 1);
				}
			}
		}
		sendTextMessage(MESSAGE_EVENT_ADVANCE, blessOutput.str());

		sendStats();
		sendSkills();
		sendReLoginWindow(unfairFightReduction);
		sendBlessStatus();
		if (getSkull() == SKULL_BLACK) {
			health = 40;
			mana = 0;
		} else {
			health = healthMax;
			mana = manaMax;
		}

		auto it = conditions.begin(), end = conditions.end();
		while (it != end) {
			std::shared_ptr<Condition> condition = *it;
			// isSupress block to delete spells conditions (ensures that the player cannot, for example, reset the cooldown time of the familiar and summon several)
			if (condition->isPersistent() && condition->isRemovableOnDeath()) {
				it = conditions.erase(it);

				condition->endCondition(static_self_cast<Player>());
				onEndCondition(condition->getType());
			} else {
				++it;
			}
		}
	} else {
		setSkillLoss(true);

		auto it = conditions.begin(), end = conditions.end();
		while (it != end) {
			std::shared_ptr<Condition> condition = *it;
			if (condition->isPersistent()) {
				it = conditions.erase(it);

				condition->endCondition(static_self_cast<Player>());
				onEndCondition(condition->getType());
			} else {
				++it;
			}
		}

		health = healthMax;
		g_game().internalTeleport(static_self_cast<Player>(), getTemplePosition(), true);
		g_game().addCreatureHealth(static_self_cast<Player>());
		g_game().addPlayerMana(static_self_cast<Player>());
		onThink(EVENT_CREATURE_THINK_INTERVAL);
		onIdleStatus();
		sendStats();
	}

	despawn();
}

bool Player::spawn() {
	setDead(false);

	const Position &pos = getLoginPosition();

	if (!g_game().map.placeCreature(pos, getPlayer(), false, true)) {
		return false;
	}

	auto spectators = Spectators().find<Creature>(position, true);
	for (const auto &spectator : spectators) {
		if (const auto &tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendCreatureAppear(static_self_cast<Player>(), pos, true);
		}

		spectator->onCreatureAppear(static_self_cast<Player>(), false);
	}

	getParent()->postAddNotification(static_self_cast<Player>(), nullptr, 0);
	g_game().addCreatureCheck(static_self_cast<Player>());
	g_game().addPlayer(static_self_cast<Player>());
	static_self_cast<Player>()->onChangeZone(static_self_cast<Player>()->getZoneType());
	return true;
}

void Player::despawn() {
	if (isDead()) {
		return;
	}

	listWalkDir.clear();
	stopEventWalk();
	onWalkAborted();
	closeAllExternalContainers();
	g_game().playerSetAttackedCreature(static_self_cast<Player>()->getID(), 0);
	g_game().playerFollowCreature(static_self_cast<Player>()->getID(), 0);

	// remove check
	Game::removeCreatureCheck(static_self_cast<Player>());

	// remove from map
	std::shared_ptr<Tile> tile = getTile();
	if (!tile) {
		return;
	}

	std::vector<int32_t> oldStackPosVector;

	auto spectators = Spectators().find<Creature>(tile->getPosition(), true);
	size_t i = 0;
	for (const auto &spectator : spectators) {
		if (const auto &player = spectator->getPlayer()) {
			oldStackPosVector.push_back(player->canSeeCreature(static_self_cast<Player>()) ? tile->getStackposOfCreature(player, getPlayer()) : -1);
		}
		if (const auto &player = spectator->getPlayer()) {
			player->sendRemoveTileThing(tile->getPosition(), oldStackPosVector[i++]);
		}

		spectator->onRemoveCreature(static_self_cast<Player>(), false);
	}

	tile->removeCreature(static_self_cast<Player>());

	getParent()->postRemoveNotification(static_self_cast<Player>(), nullptr, 0);

	g_game().removePlayer(static_self_cast<Player>());

	// show player as pending
	for (const auto &[key, player] : g_game().getPlayers()) {
		player->vip()->notifyStatusChange(static_self_cast<Player>(), VipStatus_t::Pending, false);
	}

	setDead(true);
}

bool Player::dropCorpse(std::shared_ptr<Creature> lastHitCreature, std::shared_ptr<Creature> mostDamageCreature, bool lastHitUnjustified, bool mostDamageUnjustified) {
	if (getZoneType() != ZONE_PVP || !Player::lastHitIsPlayer(lastHitCreature)) {
		return Creature::dropCorpse(lastHitCreature, mostDamageCreature, lastHitUnjustified, mostDamageUnjustified);
	}

	setDropLoot(true);
	return false;
}

std::shared_ptr<Item> Player::getCorpse(std::shared_ptr<Creature> lastHitCreature, std::shared_ptr<Creature> mostDamageCreature) {
	std::shared_ptr<Item> corpse = Creature::getCorpse(lastHitCreature, mostDamageCreature);
	if (corpse && corpse->getContainer()) {
		std::ostringstream ss;
		if (lastHitCreature) {
			std::string subjectPronoun = getSubjectPronoun();
			capitalizeWords(subjectPronoun);
			ss << "You recognize " << getNameDescription() << ". " << subjectPronoun << " " << getSubjectVerb(true) << " killed by " << lastHitCreature->getNameDescription() << '.';
		} else {
			ss << "You recognize " << getNameDescription() << '.';
		}

		corpse->setAttribute(ItemAttribute_t::DESCRIPTION, ss.str());
	}
	return corpse;
}

void Player::addInFightTicks(bool pzlock /*= false*/) {
	wheel()->checkAbilities();

	if (hasFlag(PlayerFlags_t::NotGainInFight)) {
		return;
	}

	if (pzlock) {
		pzLocked = true;
		sendIcons();
	}

	updateImbuementTrackerStats();

	std::shared_ptr<Condition> condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_INFIGHT, g_configManager().getNumber(PZ_LOCKED, __FUNCTION__), 0);
	addCondition(condition);
}

void Player::removeList() {
	g_game().removePlayer(static_self_cast<Player>());

	for (const auto &[key, player] : g_game().getPlayers()) {
		player->vip()->notifyStatusChange(static_self_cast<Player>(), VipStatus_t::Offline);
	}
}

void Player::addList() {
	for (const auto &[key, player] : g_game().getPlayers()) {
		player->vip()->notifyStatusChange(static_self_cast<Player>(), vip()->getStatus());
	}

	g_game().addPlayer(static_self_cast<Player>());
}

void Player::removePlayer(bool displayEffect, bool forced /*= true*/) {
	g_creatureEvents().playerLogout(static_self_cast<Player>());
	if (client) {
		client->logout(displayEffect, forced);
	} else {
		g_game().removeCreature(static_self_cast<Player>());
	}
}

// close container and its child containers
void Player::autoCloseContainers(std::shared_ptr<Container> container) {
	std::vector<uint32_t> closeList;
	for (const auto &it : openContainers) {
		std::shared_ptr<Container> tmpContainer = it.second.container;
		while (tmpContainer) {
			if (tmpContainer->isRemoved() || tmpContainer == container) {
				closeList.push_back(it.first);
				break;
			}

			tmpContainer = std::dynamic_pointer_cast<Container>(tmpContainer->getParent());
		}
	}

	for (uint32_t containerId : closeList) {
		closeContainer(containerId);
		if (client) {
			client->sendCloseContainer(containerId);
		}
	}
}

bool Player::hasCapacity(std::shared_ptr<Item> item, uint32_t count) const {
	if (hasFlag(PlayerFlags_t::CannotPickupItem)) {
		return false;
	}

	if (hasFlag(PlayerFlags_t::HasInfiniteCapacity) || item->getTopParent().get() == this) {
		return true;
	}

	uint32_t itemWeight = item->getContainer() != nullptr ? item->getWeight() : item->getBaseWeight();
	if (item->isStackable()) {
		itemWeight *= count;
	}
	return itemWeight <= getFreeCapacity();
}

ReturnValue Player::queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature>) {
	std::shared_ptr<Item> item = thing->getItem();
	if (item == nullptr) {
		g_logger().error("[Player::queryAdd] - Item is nullptr");
		return RETURNVALUE_NOTPOSSIBLE;
	}
	if (item->hasOwner() && !item->isOwner(getPlayer())) {
		return RETURNVALUE_ITEMISNOTYOURS;
	}

	bool childIsOwner = hasBitSet(FLAG_CHILDISOWNER, flags);
	if (childIsOwner) {
		// a child container is querying the player, just check if enough capacity
		bool skipLimit = hasBitSet(FLAG_NOLIMIT, flags);
		if (skipLimit || hasCapacity(item, count)) {
			return RETURNVALUE_NOERROR;
		}
		return RETURNVALUE_NOTENOUGHCAPACITY;
	}

	if (!item->isPickupable()) {
		return RETURNVALUE_CANNOTPICKUP;
	}

	ReturnValue ret = RETURNVALUE_NOERROR;

	const int32_t &slotPosition = item->getSlotPosition();

	bool allowPutItemsOnAmmoSlot = g_configManager().getBoolean(ENABLE_PLAYER_PUT_ITEM_IN_AMMO_SLOT, __FUNCTION__);
	if (allowPutItemsOnAmmoSlot && index == CONST_SLOT_AMMO) {
		ret = RETURNVALUE_NOERROR;
	} else {
		if ((slotPosition & SLOTP_HEAD) || (slotPosition & SLOTP_NECKLACE) || (slotPosition & SLOTP_BACKPACK) || (slotPosition & SLOTP_ARMOR) || (slotPosition & SLOTP_LEGS) || (slotPosition & SLOTP_FEET) || (slotPosition & SLOTP_RING)) {
			ret = RETURNVALUE_CANNOTBEDRESSED;
		} else if (slotPosition & SLOTP_TWO_HAND) {
			ret = RETURNVALUE_PUTTHISOBJECTINBOTHHANDS;
		} else if ((slotPosition & SLOTP_RIGHT) || (slotPosition & SLOTP_LEFT)) {
			ret = RETURNVALUE_CANNOTBEDRESSED;
		}
	}

	switch (index) {
		case CONST_SLOT_HEAD: {
			if (slotPosition & SLOTP_HEAD) {
				ret = RETURNVALUE_NOERROR;
			}
			break;
		}

		case CONST_SLOT_NECKLACE: {
			if (slotPosition & SLOTP_NECKLACE) {
				ret = RETURNVALUE_NOERROR;
			}
			break;
		}

		case CONST_SLOT_BACKPACK: {
			if (slotPosition & SLOTP_BACKPACK) {
				ret = RETURNVALUE_NOERROR;
			}
			break;
		}

		case CONST_SLOT_ARMOR: {
			if (slotPosition & SLOTP_ARMOR) {
				ret = RETURNVALUE_NOERROR;
			}
			break;
		}

		case CONST_SLOT_RIGHT: {
			if (slotPosition & SLOTP_RIGHT) {
				if (item->getWeaponType() != WEAPON_SHIELD && !item->isQuiver()) {
					ret = RETURNVALUE_CANNOTBEDRESSED;
				} else {
					std::shared_ptr<Item> leftItem = inventory[CONST_SLOT_LEFT];
					if (leftItem) {
						if ((leftItem->getSlotPosition() | slotPosition) & SLOTP_TWO_HAND) {
							if (item->isQuiver() && leftItem->getWeaponType() == WEAPON_DISTANCE) {
								ret = RETURNVALUE_NOERROR;
							} else {
								ret = RETURNVALUE_BOTHHANDSNEEDTOBEFREE;
							}
						} else {
							ret = RETURNVALUE_NOERROR;
						}
					} else {
						ret = RETURNVALUE_NOERROR;
					}
				}
			} else if (slotPosition & SLOTP_TWO_HAND) {
				ret = RETURNVALUE_CANNOTBEDRESSED;
			} else if (inventory[CONST_SLOT_LEFT]) {
				std::shared_ptr<Item> leftItem = inventory[CONST_SLOT_LEFT];
				WeaponType_t type = item->getWeaponType(), leftType = leftItem->getWeaponType();

				if (leftItem->getSlotPosition() & SLOTP_TWO_HAND) {
					ret = RETURNVALUE_DROPTWOHANDEDITEM;
				} else if (item == leftItem && count == item->getItemCount()) {
					ret = RETURNVALUE_NOERROR;
				} else if (leftType == WEAPON_SHIELD && type == WEAPON_SHIELD) {
					ret = RETURNVALUE_CANONLYUSEONESHIELD;
				} else if (leftType == WEAPON_NONE || type == WEAPON_NONE || leftType == WEAPON_SHIELD || leftType == WEAPON_AMMO || type == WEAPON_SHIELD || type == WEAPON_AMMO) {
					ret = RETURNVALUE_NOERROR;
				} else {
					ret = RETURNVALUE_CANONLYUSEONEWEAPON;
				}
			} else {
				ret = RETURNVALUE_NOERROR;
			}
			break;
		}

		case CONST_SLOT_LEFT: {
			if (item->isQuiver()) {
				ret = RETURNVALUE_CANNOTBEDRESSED;
			} else if (slotPosition & SLOTP_TWO_HAND) {
				if (inventory[CONST_SLOT_RIGHT]) {
					WeaponType_t type = item->getWeaponType();
					// Allow equip bow when quiver is in SLOT_RIGHT
					if (type == WEAPON_DISTANCE && inventory[CONST_SLOT_RIGHT]->isQuiver()) {
						ret = RETURNVALUE_NOERROR;
					} else {
						ret = RETURNVALUE_BOTHHANDSNEEDTOBEFREE;
					}
				} else {
					ret = RETURNVALUE_NOERROR;
				}
			} else if (slotPosition & SLOTP_LEFT) {
				WeaponType_t type = item->getWeaponType();
				if (type == WEAPON_NONE || type == WEAPON_SHIELD || type == WEAPON_AMMO) {
					ret = RETURNVALUE_CANNOTBEDRESSED;
				} else {
					ret = RETURNVALUE_NOERROR;
				}
			} else if (inventory[CONST_SLOT_RIGHT]) {
				std::shared_ptr<Item> rightItem = inventory[CONST_SLOT_RIGHT];
				WeaponType_t type = item->getWeaponType(), rightType = rightItem->getWeaponType();

				if (rightItem->getSlotPosition() & SLOTP_TWO_HAND) {
					ret = RETURNVALUE_DROPTWOHANDEDITEM;
				} else if (item == rightItem && count == item->getItemCount()) {
					ret = RETURNVALUE_NOERROR;
				} else if (rightType == WEAPON_SHIELD && type == WEAPON_SHIELD) {
					ret = RETURNVALUE_CANONLYUSEONESHIELD;
				} else if (rightType == WEAPON_NONE || type == WEAPON_NONE || rightType == WEAPON_SHIELD || rightType == WEAPON_AMMO || type == WEAPON_SHIELD || type == WEAPON_AMMO) {
					ret = RETURNVALUE_NOERROR;
				} else {
					ret = RETURNVALUE_CANONLYUSEONEWEAPON;
				}
			} else {
				ret = RETURNVALUE_NOERROR;
			}
			break;
		}

		case CONST_SLOT_LEGS: {
			if (slotPosition & SLOTP_LEGS) {
				ret = RETURNVALUE_NOERROR;
			}
			break;
		}

		case CONST_SLOT_FEET: {
			if (slotPosition & SLOTP_FEET) {
				ret = RETURNVALUE_NOERROR;
			}
			break;
		}

		case CONST_SLOT_RING: {
			if (slotPosition & SLOTP_RING) {
				ret = RETURNVALUE_NOERROR;
			}
			break;
		}

		case CONST_SLOT_AMMO: {
			if (allowPutItemsOnAmmoSlot) {
				ret = RETURNVALUE_NOERROR;
			} else {
				if ((slotPosition & SLOTP_AMMO)) {
					ret = RETURNVALUE_NOERROR;
				}
			}
			break;
		}

		case CONST_SLOT_WHEREEVER:
		case -1:
			ret = RETURNVALUE_NOTENOUGHROOM;
			break;

		default:
			ret = RETURNVALUE_NOTPOSSIBLE;
			break;
	}

	if (ret == RETURNVALUE_NOERROR || ret == RETURNVALUE_NOTENOUGHROOM) {
		// need an exchange with source?
		std::shared_ptr<Item> inventoryItem = getInventoryItem(static_cast<Slots_t>(index));
		if (inventoryItem && (!inventoryItem->isStackable() || inventoryItem->getID() != item->getID())) {
			return RETURNVALUE_NEEDEXCHANGE;
		}

		// check if enough capacity
		if (!hasCapacity(item, count)) {
			return RETURNVALUE_NOTENOUGHCAPACITY;
		}

		if (!g_moveEvents().onPlayerEquip(getPlayer(), item, static_cast<Slots_t>(index), true)) {
			return RETURNVALUE_CANNOTBEDRESSED;
		}
	}

	return ret;
}

ReturnValue Player::queryMaxCount(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t &maxQueryCount, uint32_t flags) {
	auto item = thing->getItem();
	if (item == nullptr) {
		maxQueryCount = 0;
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (index == INDEX_WHEREEVER) {
		uint32_t n = 0;
		for (int32_t slotIndex = CONST_SLOT_FIRST; slotIndex <= CONST_SLOT_LAST; ++slotIndex) {
			std::shared_ptr<Item> inventoryItem = inventory[slotIndex];
			if (inventoryItem) {
				if (std::shared_ptr<Container> subContainer = inventoryItem->getContainer()) {
					uint32_t queryCount = 0;
					subContainer->queryMaxCount(INDEX_WHEREEVER, item, item->getItemCount(), queryCount, flags);
					n += queryCount;

					// iterate through all items, including sub-containers (deep search)
					for (ContainerIterator it = subContainer->iterator(); it.hasNext(); it.advance()) {
						if (std::shared_ptr<Container> tmpContainer = (*it)->getContainer()) {
							queryCount = 0;
							tmpContainer->queryMaxCount(INDEX_WHEREEVER, item, item->getItemCount(), queryCount, flags);
							n += queryCount;
						}
					}
				} else if (inventoryItem->isStackable() && item->equals(inventoryItem) && inventoryItem->getItemCount() < inventoryItem->getStackSize()) {
					uint32_t remainder = (inventoryItem->getStackSize() - inventoryItem->getItemCount());

					if (queryAdd(slotIndex, item, remainder, flags) == RETURNVALUE_NOERROR) {
						n += remainder;
					}
				}
			} else if (queryAdd(slotIndex, item, item->getItemCount(), flags) == RETURNVALUE_NOERROR) { // empty slot
				if (item->isStackable()) {
					n += item->getStackSize();
				} else {
					++n;
				}
			}
		}

		maxQueryCount = n;
	} else {
		std::shared_ptr<Item> destItem = nullptr;

		std::shared_ptr<Thing> destThing = getThing(index);
		if (destThing) {
			destItem = destThing->getItem();
		}

		if (destItem) {
			if (destItem->isStackable() && item->equals(destItem) && destItem->getItemCount() < destItem->getStackSize()) {
				maxQueryCount = destItem->getStackSize() - destItem->getItemCount();
			} else {
				maxQueryCount = 0;
			}
		} else if (queryAdd(index, item, count, flags) == RETURNVALUE_NOERROR) { // empty slot
			if (item->isStackable()) {
				maxQueryCount = item->getStackSize();
			} else {
				maxQueryCount = 1;
			}

			return RETURNVALUE_NOERROR;
		}
	}

	if (maxQueryCount < count) {
		return RETURNVALUE_NOTENOUGHROOM;
	} else {
		return RETURNVALUE_NOERROR;
	}
}

ReturnValue Player::queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, std::shared_ptr<Creature> /*= nullptr*/) {
	int32_t index = getThingIndex(thing);
	if (index == -1) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	std::shared_ptr<Item> item = thing->getItem();
	if (item == nullptr) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (count == 0 || (item->isStackable() && count > item->getItemCount())) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (!item->isMovable() && !hasBitSet(FLAG_IGNORENOTMOVABLE, flags)) {
		return RETURNVALUE_NOTMOVABLE;
	}

	return RETURNVALUE_NOERROR;
}

std::shared_ptr<Cylinder> Player::queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item>* destItem, uint32_t &flags) {
	if (index == 0 /*drop to capacity window*/ || index == INDEX_WHEREEVER) {
		*destItem = nullptr;

		std::shared_ptr<Item> item = thing->getItem();
		if (item == nullptr) {
			return getPlayer();
		}

		bool autoStack = !((flags & FLAG_IGNOREAUTOSTACK) == FLAG_IGNOREAUTOSTACK);
		bool isStackable = item->isStackable();

		std::vector<std::shared_ptr<Container>> containers;

		for (uint32_t slotIndex = CONST_SLOT_FIRST; slotIndex <= CONST_SLOT_AMMO; ++slotIndex) {
			std::shared_ptr<Item> inventoryItem = inventory[slotIndex];
			if (inventoryItem) {
				if (inventoryItem == tradeItem) {
					continue;
				}

				if (inventoryItem == item) {
					continue;
				}

				if (autoStack && isStackable) {
					// try find an already existing item to stack with
					if (queryAdd(slotIndex, item, item->getItemCount(), 0) == RETURNVALUE_NOERROR) {
						if (inventoryItem->equals(item) && inventoryItem->getItemCount() < inventoryItem->getStackSize()) {
							index = slotIndex;
							*destItem = inventoryItem;
							return getPlayer();
						}
					}

					if (std::shared_ptr<Container> subContainer = inventoryItem->getContainer()) {
						containers.push_back(subContainer);
					}
				} else if (std::shared_ptr<Container> subContainer = inventoryItem->getContainer()) {
					containers.push_back(subContainer);
				}
			} else if (queryAdd(slotIndex, item, item->getItemCount(), flags) == RETURNVALUE_NOERROR) { // empty slot
				index = slotIndex;
				*destItem = nullptr;
				return getPlayer();
			}
		}

		size_t i = 0;
		while (i < containers.size()) {
			std::shared_ptr<Container> tmpContainer = containers[i++];
			if (!autoStack || !isStackable) {
				// we need to find first empty container as fast as we can for non-stackable items
				uint32_t n = tmpContainer->capacity() - tmpContainer->size();
				while (n) {
					if (tmpContainer->queryAdd(tmpContainer->capacity() - n, item, item->getItemCount(), flags) == RETURNVALUE_NOERROR) {
						index = tmpContainer->capacity() - n;
						*destItem = nullptr;
						return tmpContainer;
					}

					n--;
				}

				for (const std::shared_ptr<Item> &tmpContainerItem : tmpContainer->getItemList()) {
					if (std::shared_ptr<Container> subContainer = tmpContainerItem->getContainer()) {
						containers.push_back(subContainer);
					}
				}

				continue;
			}

			uint32_t n = 0;

			for (const std::shared_ptr<Item> &tmpItem : tmpContainer->getItemList()) {
				if (tmpItem == tradeItem) {
					continue;
				}

				if (tmpItem == item) {
					continue;
				}

				// try find an already existing item to stack with
				if (tmpItem->equals(item) && tmpItem->getItemCount() < tmpItem->getStackSize()) {
					index = n;
					*destItem = tmpItem;
					return tmpContainer;
				}

				if (std::shared_ptr<Container> subContainer = tmpItem->getContainer()) {
					containers.push_back(subContainer);
				}

				n++;
			}

			if (n < tmpContainer->capacity() && tmpContainer->queryAdd(n, item, item->getItemCount(), flags) == RETURNVALUE_NOERROR) {
				index = n;
				*destItem = nullptr;
				return tmpContainer;
			}
		}

		return getPlayer();
	}

	std::shared_ptr<Thing> destThing = getThing(index);
	if (destThing) {
		*destItem = destThing->getItem();
	}

	std::shared_ptr<Item> item = thing->getItem();
	bool movingAmmoToQuiver = item && *destItem && (*destItem)->isQuiver() && item->isAmmo();
	// force shield any slot right to player cylinder
	if (index == CONST_SLOT_RIGHT && !movingAmmoToQuiver) {
		return getPlayer();
	}

	std::shared_ptr<Cylinder> subCylinder = std::dynamic_pointer_cast<Cylinder>(destThing);
	if (subCylinder) {
		index = INDEX_WHEREEVER;
		*destItem = nullptr;
		return subCylinder;
	} else {
		return getPlayer();
	}
}

void Player::addThing(int32_t index, std::shared_ptr<Thing> thing) {
	if (!thing) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	if (index < CONST_SLOT_FIRST || index > CONST_SLOT_LAST) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	std::shared_ptr<Item> item = thing->getItem();
	if (!item) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	item->setParent(static_self_cast<Player>());
	inventory[index] = item;

	// send to client
	sendInventoryItem(static_cast<Slots_t>(index), item);
}

void Player::updateThing(std::shared_ptr<Thing> thing, uint16_t itemId, uint32_t count) {
	int32_t index = getThingIndex(thing);
	if (index == -1) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	std::shared_ptr<Item> item = thing->getItem();
	if (!item) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	item->setID(itemId);
	item->setSubType(count);

	// send to client
	sendInventoryItem(static_cast<Slots_t>(index), item);

	// event methods
	onUpdateInventoryItem(item, item);
}

void Player::replaceThing(uint32_t index, std::shared_ptr<Thing> thing) {
	if (index > CONST_SLOT_LAST) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	std::shared_ptr<Item> oldItem = getInventoryItem(static_cast<Slots_t>(index));
	if (!oldItem) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	std::shared_ptr<Item> item = thing->getItem();
	if (!item) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	// send to client
	sendInventoryItem(static_cast<Slots_t>(index), item);

	// event methods
	onUpdateInventoryItem(oldItem, item);

	item->setParent(static_self_cast<Player>());

	inventory[index] = item;
}

void Player::removeThing(std::shared_ptr<Thing> thing, uint32_t count) {
	std::shared_ptr<Item> item = thing->getItem();
	if (!item) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	int32_t index = getThingIndex(thing);
	if (index == -1) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	if (item->isStackable()) {
		if (count == item->getItemCount()) {
			// send change to client
			sendInventoryItem(static_cast<Slots_t>(index), nullptr);

			// event methods
			onRemoveInventoryItem(item);

			item->resetParent();
			inventory[index] = nullptr;
		} else {
			uint8_t newCount = static_cast<uint8_t>(std::max<int32_t>(0, item->getItemCount() - count));
			item->setItemCount(newCount);

			// send change to client
			sendInventoryItem(static_cast<Slots_t>(index), item);

			// event methods
			onUpdateInventoryItem(item, item);
		}
	} else {
		// send change to client
		sendInventoryItem(static_cast<Slots_t>(index), nullptr);

		// event methods
		onRemoveInventoryItem(item);

		item->resetParent();
		inventory[index] = nullptr;
	}
}

int32_t Player::getThingIndex(std::shared_ptr<Thing> thing) const {
	for (uint8_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		if (inventory[i] == thing) {
			return i;
		}
	}
	return -1;
}

size_t Player::getFirstIndex() const {
	return CONST_SLOT_FIRST;
}

size_t Player::getLastIndex() const {
	return CONST_SLOT_LAST + 1;
}

uint32_t Player::getItemTypeCount(uint16_t itemId, int32_t subType /*= -1*/) const {
	uint32_t count = 0;
	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; i++) {
		std::shared_ptr<Item> item = inventory[i];
		if (!item) {
			continue;
		}

		if (item->getID() == itemId) {
			count += Item::countByType(item, subType);
		}

		if (std::shared_ptr<Container> container = item->getContainer()) {
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				if ((*it)->getID() == itemId) {
					count += Item::countByType(*it, subType);
				}
			}
		}
	}
	return count;
}

void Player::stashContainer(StashContainerList itemDict) {
	StashItemList stashItemDict; // ItemID - Count
	for (const auto &it_dict : itemDict) {
		stashItemDict[(it_dict.first)->getID()] = it_dict.second;
	}

	for (auto it : stashItems) {
		if (!stashItemDict[it.first]) {
			stashItemDict[it.first] = it.second;
		} else {
			stashItemDict[it.first] += it.second;
		}
	}

	if (getStashSize(stashItemDict) > g_configManager().getNumber(STASH_ITEMS, __FUNCTION__)) {
		sendCancelMessage("You don't have capacity in the Supply Stash to stow all this item->");
		return;
	}

	uint32_t totalStowed = 0;
	std::ostringstream retString;
	uint16_t refreshDepotSearchOnItem = 0;
	for (const auto &stashIterator : itemDict) {
		uint16_t iteratorCID = (stashIterator.first)->getID();
		if (g_game().internalRemoveItem(stashIterator.first, stashIterator.second) == RETURNVALUE_NOERROR) {
			addItemOnStash(iteratorCID, stashIterator.second);
			totalStowed += stashIterator.second;
			if (isDepotSearchOpenOnItem(iteratorCID)) {
				refreshDepotSearchOnItem = iteratorCID;
			}
		}
	}

	if (totalStowed == 0) {
		sendCancelMessage("Sorry, not possible.");
		return;
	}

	retString << "Stowed " << totalStowed << " object" << (totalStowed > 1 ? "s." : ".");
	if (moved) {
		retString << " Moved " << movedItems << " object" << (movedItems > 1 ? "s." : ".");
		movedItems = 0;
	}
	sendTextMessage(MESSAGE_STATUS, retString.str());

	// Refresh depot search window if necessary
	if (refreshDepotSearchOnItem != 0) {
		requestDepotSearchItem(refreshDepotSearchOnItem, 0);
	}
}

bool Player::removeItemOfType(uint16_t itemId, uint32_t amount, int32_t subType, bool ignoreEquipped /* = false*/) {
	if (amount == 0) {
		return true;
	}

	std::vector<std::shared_ptr<Item>> itemList;

	uint32_t count = 0;
	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; i++) {
		std::shared_ptr<Item> item = inventory[i];
		if (!item) {
			continue;
		}

		if (!ignoreEquipped && item->getID() == itemId) {
			uint32_t itemCount = Item::countByType(item, subType);
			if (itemCount == 0) {
				continue;
			}

			itemList.push_back(item);

			count += itemCount;
			if (count >= amount) {
				g_game().internalRemoveItems(std::move(itemList), amount, Item::items[itemId].stackable);
				return true;
			}
		} else if (std::shared_ptr<Container> container = item->getContainer()) {
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				std::shared_ptr<Item> containerItem = *it;
				if (containerItem->getID() == itemId) {
					uint32_t itemCount = Item::countByType(containerItem, subType);
					if (itemCount == 0) {
						continue;
					}

					itemList.push_back(containerItem);

					count += itemCount;
					auto stackable = Item::items[itemId].stackable;
					// If the amount of items in the backpack is equal to or greater than the amount
					// It will remove items and stop the iteration
					if (count >= amount) {
						g_game().internalRemoveItems(std::move(itemList), amount, stackable);
						return true;
					}
				}
			}
		}
	}

	return false;
}

bool Player::hasItemCountById(uint16_t itemId, uint32_t itemAmount, bool checkStash) const {
	uint32_t newCount = 0;
	// Check items from inventory
	for (const auto &item : getAllInventoryItems()) {
		if (!item || item->getID() != itemId) {
			continue;
		}

		newCount += item->getItemCount();
	}

	// Check items from stash
	for (StashItemList stashToSend = getStashItems();
	     auto [stashItemId, itemCount] : stashToSend) {
		if (!checkStash) {
			break;
		}

		if (stashItemId == itemId) {
			newCount += itemCount;
		}
	}

	return newCount >= itemAmount;
}

bool Player::removeItemCountById(uint16_t itemId, uint32_t itemAmount, bool removeFromStash /* = true*/) {
	// Here we guarantee that the player has at least the necessary amount of items he needs, if not, we return
	if (!hasItemCountById(itemId, itemAmount, removeFromStash)) {
		return false;
	}

	uint32_t amountToRemove = itemAmount;
	// Check items from inventory
	for (const auto &item : getAllInventoryItems()) {
		if (!item || item->getID() != itemId) {
			continue;
		}

		// If the item quantity is already needed, remove the quantity and stop the loop
		if (item->getItemAmount() >= amountToRemove) {
			g_game().internalRemoveItem(item, amountToRemove);
			return true;
		}

		// If not, we continue removing items and checking the next slot.
		g_game().internalRemoveItem(item);
		amountToRemove -= item->getItemAmount();
	}

	// If there are not enough items in the inventory, we will remove the remaining from stash
	if (removeFromStash && amountToRemove > 0 && withdrawItem(itemId, amountToRemove)) {
		return true;
	}

	return false;
}

ItemsTierCountList Player::getInventoryItemsId(bool ignoreStoreInbox /* false */) const {
	ItemsTierCountList itemMap;
	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; i++) {
		std::shared_ptr<Item> item = inventory[i];
		if (!item) {
			continue;
		}

		const bool isStoreInbox = item->getID() == ITEM_STORE_INBOX;

		if (!isStoreInbox) {
			(itemMap[item->getID()])[item->getTier()] += Item::countByType(item, -1);
		}

		const auto &container = item->getContainer();
		if (container && (!isStoreInbox || !ignoreStoreInbox)) {
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				auto containerItem = *it;
				(itemMap[containerItem->getID()])[containerItem->getTier()] += Item::countByType(containerItem, -1);
			}
		}
	}
	return itemMap;
}

std::vector<std::shared_ptr<Item>> Player::getInventoryItemsFromId(uint16_t itemId, bool ignore /*= true*/) const {
	std::vector<std::shared_ptr<Item>> itemVector;
	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		std::shared_ptr<Item> item = inventory[i];
		if (!item) {
			continue;
		}

		if (!ignore && item->getID() == itemId) {
			itemVector.push_back(item);
		}

		if (std::shared_ptr<Container> container = item->getContainer()) {
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				auto containerItem = *it;
				if (containerItem->getID() == itemId) {
					itemVector.push_back(containerItem);
				}
			}
		}
	}

	return itemVector;
}

std::array<double_t, COMBAT_COUNT> Player::getFinalDamageReduction() const {
	std::array<double_t, COMBAT_COUNT> combatReductionArray;
	combatReductionArray.fill(0);
	calculateDamageReductionFromEquipedItems(combatReductionArray);
	for (int combatTypeIndex = 0; combatTypeIndex < COMBAT_COUNT; combatTypeIndex++) {
		combatReductionArray[combatTypeIndex] = std::clamp<double_t>(
			std::floor(combatReductionArray[combatTypeIndex]),
			-100.,
			100.
		);
	}
	return combatReductionArray;
}

void Player::calculateDamageReductionFromEquipedItems(std::array<double_t, COMBAT_COUNT> &combatReductionArray) const {
	for (uint8_t slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; ++slot) {
		std::shared_ptr<Item> item = inventory[slot];
		if (item) {
			calculateDamageReductionFromItem(combatReductionArray, item);
		}
	}
}

void Player::calculateDamageReductionFromItem(std::array<double_t, COMBAT_COUNT> &combatReductionArray, std::shared_ptr<Item> item) const {
	for (uint16_t combatTypeIndex = 0; combatTypeIndex < COMBAT_COUNT; combatTypeIndex++) {
		updateDamageReductionFromItemImbuement(combatReductionArray, item, combatTypeIndex);
		updateDamageReductionFromItemAbility(combatReductionArray, item, combatTypeIndex);
	}
}

void Player::updateDamageReductionFromItemImbuement(
	std::array<double_t, COMBAT_COUNT> &combatReductionArray, std::shared_ptr<Item> item, uint16_t combatTypeIndex
) const {
	for (uint8_t imbueSlotId = 0; imbueSlotId < item->getImbuementSlot(); imbueSlotId++) {
		ImbuementInfo imbuementInfo;
		if (item->getImbuementInfo(imbueSlotId, &imbuementInfo) && imbuementInfo.imbuement) {
			int16_t imbuementAbsorption = imbuementInfo.imbuement->absorbPercent[combatTypeIndex];
			if (imbuementAbsorption != 0) {
				combatReductionArray[combatTypeIndex] = calculateDamageReduction(combatReductionArray[combatTypeIndex], imbuementAbsorption);
			}
		}
	}
}

void Player::updateDamageReductionFromItemAbility(
	std::array<double_t, COMBAT_COUNT> &combatReductionArray, std::shared_ptr<Item> item, uint16_t combatTypeIndex
) const {
	if (!item) {
		return;
	}

	const ItemType &itemType = Item::items[item->getID()];
	if (itemType.abilities) {
		int16_t elementReduction = itemType.abilities->absorbPercent[combatTypeIndex];
		if (elementReduction != 0) {
			combatReductionArray[combatTypeIndex] = calculateDamageReduction(combatReductionArray[combatTypeIndex], elementReduction);
		}
	}
}

double_t Player::calculateDamageReduction(double_t currentTotal, int16_t resistance) const {
	return (100 - currentTotal) / 100.0 * resistance + currentTotal;
}

ItemsTierCountList Player::getStoreInboxItemsId() const {
	ItemsTierCountList itemMap;
	const auto &container = getStoreInbox();
	if (container) {
		for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
			std::shared_ptr<Item> item = *it;
			(itemMap[item->getID()])[item->getTier()] += Item::countByType(item, -1);
		}
	}

	return itemMap;
}

ItemsTierCountList Player::getDepotChestItemsId() const {
	ItemsTierCountList itemMap;

	for (const auto &[index, depot] : depotChests) {
		const std::shared_ptr<Container> &container = depot->getContainer();
		for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
			std::shared_ptr<Item> item = *it;
			(itemMap[item->getID()])[item->getTier()] += Item::countByType(item, -1);
		}
	}

	return itemMap;
}

ItemsTierCountList Player::getDepotInboxItemsId() const {
	ItemsTierCountList itemMap;

	const std::shared_ptr<Inbox> &inbox = getInbox();
	const std::shared_ptr<Container> &container = inbox->getContainer();
	if (container) {
		for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
			const auto &item = *it;
			(itemMap[item->getID()])[item->getTier()] += Item::countByType(item, -1);
		}
	}

	return itemMap;
}

std::vector<std::shared_ptr<Item>> Player::getAllInventoryItems(bool ignoreEquiped /*= false*/, bool ignoreItemWithTier /* false*/) const {
	std::vector<std::shared_ptr<Item>> itemVector;
	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		std::shared_ptr<Item> item = inventory[i];
		if (!item) {
			continue;
		}

		// Only get equiped items if ignored equipped is false
		if (!ignoreEquiped) {
			itemVector.push_back(item);
		}
		if (std::shared_ptr<Container> container = item->getContainer()) {
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				if (ignoreItemWithTier && (*it)->getTier() > 0) {
					continue;
				}

				itemVector.push_back(*it);
			}
		}
	}

	return itemVector;
}

std::vector<std::shared_ptr<Item>> Player::getEquippedAugmentItemsByType(Augment_t augmentType) const {
	std::vector<std::shared_ptr<Item>> equippedAugmentItemsByType;
	const auto equippedAugmentItems = getEquippedItems();

	for (const auto &item : equippedAugmentItems) {
		for (auto &augment : item->getAugments()) {
			if (augment->type == augmentType) {
				equippedAugmentItemsByType.push_back(item);
			}
		}
	}

	return equippedAugmentItemsByType;
}

std::vector<std::shared_ptr<Item>> Player::getEquippedAugmentItems() const {
	std::vector<std::shared_ptr<Item>> equippedAugmentItems;
	const auto equippedItems = getEquippedItems();

	for (const auto &item : equippedItems) {
		if (item->getAugments().size() < 1) {
			continue;
		}
		equippedAugmentItems.push_back(item);
	}

	return equippedAugmentItems;
}

std::vector<std::shared_ptr<Item>> Player::getEquippedItems() const {
	std::vector<Slots_t> valid_slots {
		CONST_SLOT_HEAD,
		CONST_SLOT_NECKLACE,
		CONST_SLOT_BACKPACK,
		CONST_SLOT_ARMOR,
		CONST_SLOT_RIGHT,
		CONST_SLOT_LEFT,
		CONST_SLOT_LEGS,
		CONST_SLOT_FEET,
		CONST_SLOT_RING,
	};

	std::vector<std::shared_ptr<Item>> valid_items;
	for (const auto &slot : valid_slots) {
		std::shared_ptr<Item> item = inventory[slot];
		if (!item) {
			continue;
		}

		valid_items.push_back(item);
	}

	return valid_items;
}

std::map<uint32_t, uint32_t> &Player::getAllItemTypeCount(std::map<uint32_t, uint32_t> &countMap) const {
	for (const auto &item : getAllInventoryItems()) {
		countMap[static_cast<uint32_t>(item->getID())] += Item::countByType(item, -1);
	}
	return countMap;
}

std::map<uint16_t, uint16_t> &Player::getAllSaleItemIdAndCount(std::map<uint16_t, uint16_t> &countMap) const {
	for (const auto &item : getAllInventoryItems(false, true)) {
		countMap[item->getID()] += item->getItemCount();
	}

	return countMap;
}

void Player::getAllItemTypeCountAndSubtype(std::map<uint32_t, uint32_t> &countMap) const {
	for (const auto &item : getAllInventoryItems()) {
		uint16_t itemId = item->getID();
		if (Item::items[itemId].isFluidContainer()) {
			countMap[static_cast<uint32_t>(itemId) | (item->getAttribute<uint32_t>(ItemAttribute_t::FLUIDTYPE)) << 16] += item->getItemCount();
		} else {
			countMap[static_cast<uint32_t>(itemId)] += item->getItemCount();
		}
	}
}

std::shared_ptr<Item> Player::getForgeItemFromId(uint16_t itemId, uint8_t tier) {
	for (auto item : getAllInventoryItems(true)) {
		if (item->hasImbuements()) {
			continue;
		}

		if (item->getID() == itemId && item->getTier() == tier) {
			return item;
		}
	}

	return nullptr;
}

std::shared_ptr<Thing> Player::getThing(size_t index) const {
	if (index >= CONST_SLOT_FIRST && index <= CONST_SLOT_LAST) {
		return inventory[index];
	}
	return nullptr;
}

void Player::postAddNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> oldParent, int32_t index, CylinderLink_t link /*= LINK_OWNER*/) {
	if (link == LINK_OWNER) {
		// calling movement scripts
		g_moveEvents().onPlayerEquip(getPlayer(), thing->getItem(), static_cast<Slots_t>(index), false);
	}

	bool requireListUpdate = true;
	if (link == LINK_OWNER || link == LINK_TOPPARENT) {
		std::shared_ptr<Item> i = (oldParent ? oldParent->getItem() : nullptr);
		const auto &container = i ? i->getContainer() : nullptr;
		if (container) {
			requireListUpdate = container->getHoldingPlayer() != getPlayer();
		} else {
			requireListUpdate = oldParent != getPlayer();
		}

		updateInventoryWeight();
		updateItemsLight();
		sendInventoryIds();
		sendStats();
	}

	if (std::shared_ptr<Item> item = thing->getItem()) {
		if (std::shared_ptr<Container> container = item->getContainer()) {
			onSendContainer(container);
		}

		if (shopOwner && !scheduledSaleUpdate && requireListUpdate) {
			updateSaleShopList(item);
		}
	} else if (std::shared_ptr<Creature> creature = thing->getCreature()) {
		if (creature == getPlayer()) {
			// check containers
			std::vector<std::shared_ptr<Container>> containers;

			for (const auto &it : openContainers) {
				std::shared_ptr<Container> container = it.second.container;
				if (container == nullptr) {
					continue;
				}

				if (!Position::areInRange<1, 1, 0>(container->getPosition(), getPosition())) {
					containers.push_back(container);
				}
			}

			for (const std::shared_ptr<Container> &container : containers) {
				autoCloseContainers(container);
			}
		}
	}
}

void Player::postRemoveNotification(std::shared_ptr<Thing> thing, std::shared_ptr<Cylinder> newParent, int32_t index, CylinderLink_t link /*= LINK_OWNER*/) {
	if (link == LINK_OWNER) {
		// calling movement scripts
		g_moveEvents().onPlayerDeEquip(getPlayer(), thing->getItem(), static_cast<Slots_t>(index));
	}

	bool requireListUpdate = true;

	if (link == LINK_OWNER || link == LINK_TOPPARENT) {
		std::shared_ptr<Item> i = (newParent ? newParent->getItem() : nullptr);
		const auto &container = i ? i->getContainer() : nullptr;
		if (container) {
			requireListUpdate = container->getHoldingPlayer() != getPlayer();
		} else {
			requireListUpdate = newParent != getPlayer();
		}

		updateInventoryWeight();
		updateItemsLight();
		sendInventoryIds();
		sendStats();
	}

	if (std::shared_ptr<Item> item = thing->getItem()) {
		if (std::shared_ptr<Container> container = item->getContainer()) {
			checkLootContainers(container);

			if (container->isRemoved() || !Position::areInRange<1, 1, 0>(getPosition(), container->getPosition())) {
				autoCloseContainers(container);
			} else if (container->getTopParent() == getPlayer()) {
				onSendContainer(container);
			} else if (std::shared_ptr<Container> topContainer = std::dynamic_pointer_cast<Container>(container->getTopParent())) {
				if (std::shared_ptr<DepotChest> depotChest = std::dynamic_pointer_cast<DepotChest>(topContainer)) {
					bool isOwner = false;

					for (const auto &it : depotChests) {
						if (it.second == depotChest) {
							isOwner = true;
							it.second->stopDecaying();
							onSendContainer(container);
						}
					}

					if (!isOwner) {
						autoCloseContainers(container);
					}
				} else {
					onSendContainer(container);
				}
			} else {
				autoCloseContainers(container);
			}
		}

		// force list update if item exists tier
		if (item->getTier() > 0 && !requireListUpdate) {
			requireListUpdate = true;
		}

		if (shopOwner && !scheduledSaleUpdate && requireListUpdate) {
			updateSaleShopList(item);
		}
	}
}

// i will keep this function so it can be reviewed
bool Player::updateSaleShopList(std::shared_ptr<Item> item) {
	uint16_t itemId = item->getID();
	if (!itemId || !item) {
		return true;
	}

	g_dispatcher().addEvent([creatureId = getID()] { g_game().updatePlayerSaleItems(creatureId); }, "Game::updatePlayerSaleItems");
	scheduledSaleUpdate = true;
	return true;
}

bool Player::hasShopItemForSale(uint16_t itemId, uint8_t subType) const {
	if (!shopOwner) {
		return false;
	}

	const ItemType &itemType = Item::items[itemId];
	const auto &shoplist = shopOwner->getShopItemVector(getGUID());
	return std::any_of(shoplist.begin(), shoplist.end(), [&](const ShopBlock &shopBlock) {
		return shopBlock.itemId == itemId && shopBlock.itemBuyPrice != 0 && (!itemType.isFluidContainer() || shopBlock.itemSubType == subType);
	});
}

void Player::internalAddThing(std::shared_ptr<Thing> thing) {
	internalAddThing(0, thing);
}

void Player::internalAddThing(uint32_t index, std::shared_ptr<Thing> thing) {
	if (!thing) {
		return;
	}

	std::shared_ptr<Item> item = thing->getItem();
	if (!item) {
		return;
	}

	// index == 0 means we should equip this item at the most appropiate slot (no action required here)
	if (index >= CONST_SLOT_FIRST && index <= CONST_SLOT_LAST) {
		if (inventory[index]) {
			return;
		}

		inventory[index] = item;
		item->setParent(static_self_cast<Player>());
	}
}

bool Player::setFollowCreature(std::shared_ptr<Creature> creature) {
	if (!Creature::setFollowCreature(creature)) {
		setFollowCreature(nullptr);
		setAttackedCreature(nullptr);

		sendCancelMessage(RETURNVALUE_THEREISNOWAY);
		sendCancelTarget();
		stopWalk();
		return false;
	}
	return true;
}

bool Player::setAttackedCreature(std::shared_ptr<Creature> creature) {
	if (!Creature::setAttackedCreature(creature)) {
		sendCancelTarget();
		return false;
	}

	auto followCreature = getFollowCreature();
	if (chaseMode && creature) {
		if (followCreature != creature) {
			setFollowCreature(creature);
		}
	} else if (followCreature) {
		setFollowCreature(nullptr);
	}

	if (creature) {
		g_dispatcher().addEvent([creatureId = getID()] { g_game().checkCreatureAttack(creatureId); }, "Game::checkCreatureAttack");
	}
	return true;
}

void Player::goToFollowCreature() {
	if (!walkTask) {
		if ((OTSYS_TIME() - lastFailedFollow) < 2000) {
			return;
		}

		Creature::goToFollowCreature();

		if (getFollowCreature() && !hasFollowPath) {
			lastFailedFollow = OTSYS_TIME();
		}
	}
}

void Player::getPathSearchParams(const std::shared_ptr<Creature> &creature, FindPathParams &fpp) {
	Creature::getPathSearchParams(creature, fpp);
	fpp.fullPathSearch = true;
}

void Player::doAttacking(uint32_t) {
	if (lastAttack == 0) {
		lastAttack = OTSYS_TIME() - getAttackSpeed() - 1;
	}

	if (hasCondition(CONDITION_PACIFIED)) {
		return;
	}

	auto attackedCreature = getAttackedCreature();
	if (!attackedCreature) {
		return;
	}

	if ((OTSYS_TIME() - lastAttack) >= getAttackSpeed()) {
		bool result = false;

		std::shared_ptr<Item> tool = getWeapon();
		const WeaponShared_ptr weapon = g_weapons().getWeapon(tool);
		uint32_t delay = getAttackSpeed();
		bool classicSpeed = g_configManager().getBoolean(CLASSIC_ATTACK_SPEED, __FUNCTION__);

		if (weapon) {
			if (!weapon->interruptSwing()) {
				result = weapon->useWeapon(static_self_cast<Player>(), tool, attackedCreature);
			} else if (!classicSpeed && !canDoAction()) {
				delay = getNextActionTime();
			} else {
				result = weapon->useWeapon(static_self_cast<Player>(), tool, attackedCreature);
			}
		} else if (hasWeaponDistanceEquipped()) {
			return;
		} else {
			result = Weapon::useFist(static_self_cast<Player>(), attackedCreature);
		}

		const auto &task = createPlayerTask(
			std::max<uint32_t>(SCHEDULER_MINTICKS, delay),
			[playerId = getID()] { g_game().checkCreatureAttack(playerId); }, "Game::checkCreatureAttack"
		);

		if (!classicSpeed) {
			setNextActionTask(task, false);
		} else {
			g_dispatcher().scheduleEvent(task);
		}

		if (result) {
			updateLastAggressiveAction();
			updateLastAttack();
		}
	}
}

uint64_t Player::getGainedExperience(std::shared_ptr<Creature> attacker) const {
	if (g_configManager().getBoolean(EXPERIENCE_FROM_PLAYERS, __FUNCTION__)) {
		auto attackerPlayer = attacker->getPlayer();
		if (attackerPlayer && attackerPlayer.get() != this && skillLoss && std::abs(static_cast<int32_t>(attackerPlayer->getLevel() - level)) <= g_configManager().getNumber(EXP_FROM_PLAYERS_LEVEL_RANGE, __FUNCTION__)) {
			return std::max<uint64_t>(0, std::floor(getLostExperience() * getDamageRatio(attacker) * 0.75));
		}
	}
	return 0;
}

void Player::onFollowCreature(const std::shared_ptr<Creature> &creature) {
	if (!creature) {
		stopWalk();
	}
}

void Player::setChaseMode(bool mode) {
	bool prevChaseMode = chaseMode;
	chaseMode = mode;
	auto attackedCreature = getAttackedCreature();
	auto followCreature = getFollowCreature();

	if (prevChaseMode != chaseMode) {
		if (chaseMode) {
			if (!followCreature && attackedCreature) {
				// chase opponent
				setFollowCreature(attackedCreature);
			}
		} else if (attackedCreature) {
			setFollowCreature(nullptr);
			cancelNextWalk = true;
		}
	}
}

void Player::onWalkAborted() {
	setNextWalkActionTask(nullptr);
	sendCancelWalk();
}

void Player::onWalkComplete() {
	if (hasCondition(CONDITION_FEARED)) {
		/**
		 * The walk is only processed during the fear condition execution,
		 * but adding this check and executing the condition here as soon it ends
		 * makes the fleeing more smooth and with litle to no hickups.
		 */

		g_logger().debug("[Player::onWalkComplete] Executing feared conditions as players completed it's walk.");
		std::shared_ptr<Condition> f = getCondition(CONDITION_FEARED);
		f->executeCondition(static_self_cast<Player>(), 0);
	}

	if (walkTask) {
		walkTaskEvent = g_dispatcher().scheduleEvent(walkTask);
		walkTask = nullptr;
	}
}

void Player::stopWalk() {
	cancelNextWalk = true;
}

LightInfo Player::getCreatureLight() const {
	if (internalLight.level > itemsLight.level) {
		return internalLight;
	}
	return itemsLight;
}

void Player::updateItemsLight(bool internal /*=false*/) {
	LightInfo maxLight;

	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		std::shared_ptr<Item> item = inventory[i];
		if (item) {
			LightInfo curLight = item->getLightInfo();

			if (curLight.level > maxLight.level) {
				maxLight = curLight;
			}
		}
	}

	if (itemsLight.level != maxLight.level || itemsLight.color != maxLight.color) {
		itemsLight = maxLight;

		if (!internal) {
			g_game().changeLight(static_self_cast<Player>());
		}
	}
}

void Player::onAddCondition(ConditionType_t type) {
	Creature::onAddCondition(type);

	if (type == CONDITION_OUTFIT && isMounted()) {
		dismount();
		wasMounted = true;
	}

	sendIcons();
}

void Player::onAddCombatCondition(ConditionType_t type) {
	if (IsConditionSuppressible(type)) {
		updateLastConditionTime(type);
	}
	switch (type) {
		case CONDITION_POISON:
			sendTextMessage(MESSAGE_FAILURE, "You are poisoned.");
			break;

		case CONDITION_DROWN:
			sendTextMessage(MESSAGE_FAILURE, "You are drowning.");
			break;

		case CONDITION_PARALYZE:
			sendTextMessage(MESSAGE_FAILURE, "You are paralyzed.");
			break;

		case CONDITION_DRUNK:
			sendTextMessage(MESSAGE_FAILURE, "You are drunk.");
			break;

		case CONDITION_LESSERHEX:

		case CONDITION_INTENSEHEX:

		case CONDITION_GREATERHEX:

			sendTextMessage(MESSAGE_FAILURE, "You are hexed.");
			break;
		case CONDITION_ROOTED:
			sendTextMessage(MESSAGE_FAILURE, "You are rooted.");
			break;

		case CONDITION_FEARED:
			sendTextMessage(MESSAGE_FAILURE, "You are feared.");
			break;

		case CONDITION_CURSED:
			sendTextMessage(MESSAGE_FAILURE, "You are cursed.");
			break;

		case CONDITION_FREEZING:
			sendTextMessage(MESSAGE_FAILURE, "You are freezing.");
			break;

		case CONDITION_DAZZLED:
			sendTextMessage(MESSAGE_FAILURE, "You are dazzled.");
			break;

		case CONDITION_BLEEDING:
			sendTextMessage(MESSAGE_FAILURE, "You are bleeding.");
			break;

		default:
			break;
	}
}

void Player::onEndCondition(ConditionType_t type) {
	Creature::onEndCondition(type);

	if (type == CONDITION_INFIGHT) {
		onIdleStatus();
		pzLocked = false;
		clearAttacked();

		if (getSkull() != SKULL_RED && getSkull() != SKULL_BLACK) {
			setSkull(SKULL_NONE);
		}
	}

	if (type == CONDITION_OUTFIT && wasMounted) {
		toggleMount(true);
	}

	sendIcons();
}

void Player::onCombatRemoveCondition(std::shared_ptr<Condition> condition) {
	// Creature::onCombatRemoveCondition(condition);
	if (condition->getId() > 0) {
		// Means the condition is from an item, id == slot
		if (g_game().getWorldType() == WORLD_TYPE_PVP_ENFORCED) {
			std::shared_ptr<Item> item = getInventoryItem(static_cast<Slots_t>(condition->getId()));
			if (item) {
				// 25% chance to destroy the item
				if (25 >= uniform_random(1, 100)) {
					g_game().internalRemoveItem(item);
				}
			}
		}
	} else {
		if (!canDoAction()) {
			const uint32_t delay = getNextActionTime();
			const int32_t ticks = delay - (delay % EVENT_CREATURE_THINK_INTERVAL);
			if (ticks < 0 || condition->getType() == CONDITION_PARALYZE) {
				removeCondition(condition);
			} else {
				condition->setTicks(ticks);
			}
		} else {
			removeCondition(condition);
		}
	}
}

void Player::onAttackedCreature(std::shared_ptr<Creature> target) {
	Creature::onAttackedCreature(target);

	if (target->getZoneType() == ZONE_PVP) {
		return;
	}

	if (target == getPlayer()) {
		addInFightTicks();
		return;
	}

	if (hasFlag(PlayerFlags_t::NotGainInFight)) {
		return;
	}

	auto targetPlayer = target->getPlayer();
	if (targetPlayer && !isPartner(targetPlayer) && !isGuildMate(targetPlayer)) {
		if (!pzLocked && g_game().getWorldType() == WORLD_TYPE_PVP_ENFORCED) {
			pzLocked = true;
			sendIcons();
		}

		if (getSkull() == SKULL_NONE && getSkullClient(targetPlayer) == SKULL_YELLOW) {
			addAttacked(targetPlayer);
			targetPlayer->sendCreatureSkull(static_self_cast<Player>());
		} else if (!targetPlayer->hasAttacked(static_self_cast<Player>())) {
			if (!pzLocked) {
				pzLocked = true;
				sendIcons();
			}

			if (!Combat::isInPvpZone(static_self_cast<Player>(), targetPlayer) && !isInWar(targetPlayer)) {
				addAttacked(targetPlayer);

				if (targetPlayer->getSkull() == SKULL_NONE && getSkull() == SKULL_NONE && !targetPlayer->hasKilled(static_self_cast<Player>())) {
					setSkull(SKULL_WHITE);
				}

				if (getSkull() == SKULL_NONE) {
					targetPlayer->sendCreatureSkull(static_self_cast<Player>());
				}
			}
		}
	}

	addInFightTicks();
}

void Player::onAttacked() {
	Creature::onAttacked();

	addInFightTicks();
}

void Player::onIdleStatus() {
	Creature::onIdleStatus();

	if (m_party) {
		m_party->clearPlayerPoints(static_self_cast<Player>());
	}
}

void Player::onPlacedCreature() {
	// scripting event - onLogin
	if (!g_creatureEvents().playerLogin(static_self_cast<Player>())) {
		removePlayer(true);
	}

	this->onChangeZone(this->getZoneType());

	sendUnjustifiedPoints();
}

void Player::onAttackedCreatureDrainHealth(std::shared_ptr<Creature> target, int32_t points) {
	Creature::onAttackedCreatureDrainHealth(target, points);

	if (target) {
		if (m_party && !Combat::isPlayerCombat(target)) {
			auto tmpMonster = target->getMonster();
			if (tmpMonster && tmpMonster->isHostile()) {
				// We have fulfilled a requirement for shared experience
				m_party->updatePlayerTicks(static_self_cast<Player>(), points);
			}
		}
	}
}

void Player::onTargetCreatureGainHealth(std::shared_ptr<Creature> target, int32_t points) {
	if (target && m_party) {
		std::shared_ptr<Player> tmpPlayer = nullptr;

		if (isPartner(tmpPlayer) && (tmpPlayer != getPlayer())) {
			tmpPlayer = target->getPlayer();
		} else if (std::shared_ptr<Creature> targetMaster = target->getMaster()) {
			if (std::shared_ptr<Player> targetMasterPlayer = targetMaster->getPlayer()) {
				tmpPlayer = targetMasterPlayer;
			}
		}

		if (isPartner(tmpPlayer)) {
			m_party->updatePlayerTicks(static_self_cast<Player>(), points);
		}
	}
}

bool Player::onKilledPlayer(const std::shared_ptr<Player> &target, bool lastHit) {
	bool unjustified = false;
	if (target->getZoneType() == ZONE_PVP) {
		target->setDropLoot(false);
		target->setSkillLoss(false);
	} else if (!hasFlag(PlayerFlags_t::NotGainInFight) && !isPartner(target)) {
		if (!Combat::isInPvpZone(getPlayer(), target) && hasAttacked(target) && !target->hasAttacked(getPlayer()) && !isGuildMate(target) && target != getPlayer()) {
			if (target->hasKilled(getPlayer())) {
				for (auto &kill : target->unjustifiedKills) {
					if (kill.target == getGUID() && kill.unavenged) {
						kill.unavenged = false;
						attackedSet.erase(target->guid);
						break;
					}
				}
			} else if (target->getSkull() == SKULL_NONE && !isInWar(target)) {
				unjustified = true;
				addUnjustifiedDead(target);
			}

			if (lastHit && hasCondition(CONDITION_INFIGHT)) {
				pzLocked = true;
				std::shared_ptr<Condition> condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_INFIGHT, g_configManager().getNumber(WHITE_SKULL_TIME, __FUNCTION__), 0);
				addCondition(condition);
			}
		}
	}
	return unjustified;
}

void Player::addHuntingTaskKill(const std::shared_ptr<MonsterType> &mType) {
	const auto &taskSlot = getTaskHuntingWithCreature(mType->info.raceid);
	if (!taskSlot) {
		return;
	}

	if (const auto &option = g_ioprey().getTaskRewardOption(taskSlot)) {
		taskSlot->currentKills += 1;
		if ((taskSlot->upgrade && taskSlot->currentKills >= option->secondKills) || (!taskSlot->upgrade && taskSlot->currentKills >= option->firstKills)) {
			taskSlot->state = PreyTaskDataState_Completed;
			std::string message = "You succesfully finished your hunting task. Your reward is ready to be claimed!";
			sendTextMessage(MESSAGE_STATUS, message);
		}
		reloadTaskSlot(taskSlot->id);
	}
}

void Player::addBestiaryKill(const std::shared_ptr<MonsterType> &mType) {
	if (mType->isBoss()) {
		return;
	}
	uint32_t kills = g_configManager().getNumber(BESTIARY_KILL_MULTIPLIER, __FUNCTION__);
	if (isConcoctionActive(Concoction_t::BestiaryBetterment)) {
		kills *= 2;
	}
	g_iobestiary().addBestiaryKill(getPlayer(), mType, kills);
}

void Player::addBosstiaryKill(const std::shared_ptr<MonsterType> &mType) {
	if (!mType->isBoss()) {
		return;
	}
	uint32_t kills = g_configManager().getNumber(BOSSTIARY_KILL_MULTIPLIER, __FUNCTION__);
	if (g_ioBosstiary().getBoostedBossId() == mType->info.raceid) {
		kills *= g_configManager().getNumber(BOOSTED_BOSS_KILL_BONUS, __FUNCTION__);
	}
	g_ioBosstiary().addBosstiaryKill(getPlayer(), mType, kills);
}

bool Player::onKilledMonster(const std::shared_ptr<Monster> &monster) {
	if (hasFlag(PlayerFlags_t::NotGenerateLoot)) {
		monster->setDropLoot(false);
	}
	if (monster->hasBeenSummoned()) {
		return false;
	}
	auto mType = monster->getMonsterType();
	addHuntingTaskKill(mType);
	addBestiaryKill(mType);
	addBosstiaryKill(mType);
	return false;
}

void Player::gainExperience(uint64_t gainExp, std::shared_ptr<Creature> target) {
	if (hasFlag(PlayerFlags_t::NotGainExperience) || gainExp == 0 || staminaMinutes == 0) {
		return;
	}

	addExperience(target, gainExp, true);
}

void Player::onGainExperience(uint64_t gainExp, std::shared_ptr<Creature> target) {
	if (hasFlag(PlayerFlags_t::NotGainExperience)) {
		return;
	}

	if (target && !target->getPlayer() && m_party && m_party->isSharedExperienceActive() && m_party->isSharedExperienceEnabled()) {
		m_party->shareExperience(gainExp, target);
		// We will get a share of the experience through the sharing mechanism
		return;
	}

	Creature::onGainExperience(gainExp, target);
	gainExperience(gainExp, target);
}

void Player::onGainSharedExperience(uint64_t gainExp, std::shared_ptr<Creature> target) {
	gainExperience(gainExp, target);
}

bool Player::isImmune(CombatType_t type) const {
	if (hasFlag(PlayerFlags_t::CannotBeAttacked)) {
		return true;
	}
	return Creature::isImmune(type);
}

bool Player::isImmune(ConditionType_t type) const {
	if (hasFlag(PlayerFlags_t::CannotBeAttacked)) {
		return true;
	}

	return m_conditionImmunities[static_cast<size_t>(type)];
}

bool Player::isAttackable() const {
	return !hasFlag(PlayerFlags_t::CannotBeAttacked);
}

bool Player::lastHitIsPlayer(std::shared_ptr<Creature> lastHitCreature) {
	if (!lastHitCreature) {
		return false;
	}

	if (lastHitCreature->getPlayer()) {
		return true;
	}

	std::shared_ptr<Creature> lastHitMaster = lastHitCreature->getMaster();
	return lastHitMaster && lastHitMaster->getPlayer();
}

void Player::changeHealth(int32_t healthChange, bool sendHealthChange /* = true*/) {
	Creature::changeHealth(healthChange, sendHealthChange);
	sendStats();
}

void Player::changeMana(int32_t manaChange) {
	if (!hasFlag(PlayerFlags_t::HasInfiniteMana)) {
		Creature::changeMana(manaChange);
	}
	g_game().addPlayerMana(static_self_cast<Player>());
	sendStats();
}

void Player::changeSoul(int32_t soulChange) {
	if (soulChange > 0) {
		soul += std::min<int32_t>(soulChange * g_configManager().getFloat(RATE_SOUL_REGEN, __FUNCTION__), vocation->getSoulMax() - soul);
	} else {
		soul = std::max<int32_t>(0, soul + soulChange);
	}

	sendStats();
}

bool Player::canWear(uint16_t lookType, uint8_t addons) const {
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS, __FUNCTION__) && lookType != 0 && !g_game().isLookTypeRegistered(lookType)) {
		g_logger().warn("[Player::canWear] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", lookType);
		return false;
	}

	if (group->access) {
		return true;
	}

	const auto &outfit = Outfits::getInstance().getOutfitByLookType(getPlayer(), lookType);
	if (!outfit) {
		return false;
	}

	if (outfit->premium && !isPremium()) {
		return false;
	}

	if (outfit->unlocked && addons == 0) {
		return true;
	}

	for (const OutfitEntry &outfitEntry : outfits) {
		if (outfitEntry.lookType != lookType) {
			continue;
		}
		return (outfitEntry.addons & addons) == addons;
	}
	return false;
}

bool Player::canLogout() {
	if (isConnecting) {
		return false;
	}

	auto tile = getTile();
	if (!tile) {
		return false;
	}

	if (tile->hasFlag(TILESTATE_NOLOGOUT)) {
		return false;
	}

	if (tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
		return true;
	}

	return !isPzLocked() && !hasCondition(CONDITION_INFIGHT);
}

void Player::genReservedStorageRange() {
	// generate outfits range
	uint32_t outfits_key = PSTRG_OUTFITS_RANGE_START;
	for (const OutfitEntry &entry : outfits) {
		storageMap[++outfits_key] = (entry.lookType << 16) | entry.addons;
	}
	// generate familiars range
	uint32_t familiar_key = PSTRG_FAMILIARS_RANGE_START;
	for (const FamiliarEntry &entry : familiars) {
		storageMap[++familiar_key] = (entry.lookType << 16);
	}
}

void Player::addOutfit(uint16_t lookType, uint8_t addons) {
	for (OutfitEntry &outfitEntry : outfits) {
		if (outfitEntry.lookType == lookType) {
			outfitEntry.addons |= addons;
			return;
		}
	}
	outfits.emplace_back(lookType, addons);
}

bool Player::removeOutfit(uint16_t lookType) {
	for (auto it = outfits.begin(), end = outfits.end(); it != end; ++it) {
		OutfitEntry &entry = *it;
		if (entry.lookType == lookType) {
			outfits.erase(it);
			return true;
		}
	}
	return false;
}

bool Player::removeOutfitAddon(uint16_t lookType, uint8_t addons) {
	for (OutfitEntry &outfitEntry : outfits) {
		if (outfitEntry.lookType == lookType) {
			outfitEntry.addons &= ~addons;
			return true;
		}
	}
	return false;
}

bool Player::getOutfitAddons(const std::shared_ptr<Outfit> &outfit, uint8_t &addons) const {
	if (group->access) {
		addons = 3;
		return true;
	}

	if (outfit->premium && !isPremium()) {
		return false;
	}

	for (const OutfitEntry &outfitEntry : outfits) {
		if (outfitEntry.lookType != outfit->lookType) {
			continue;
		}

		addons = outfitEntry.addons;
		return true;
	}

	if (!outfit->unlocked) {
		return false;
	}

	addons = 0;
	return true;
}

bool Player::canFamiliar(uint16_t lookType) const {
	if (group->access) {
		return true;
	}

	const auto &familiar = Familiars::getInstance().getFamiliarByLookType(getVocationId(), lookType);
	if (!familiar) {
		return false;
	}

	if (familiar->premium && !isPremium()) {
		return false;
	}

	if (familiar->unlocked) {
		return true;
	}

	for (const FamiliarEntry &familiarEntry : familiars) {
		if (familiarEntry.lookType == lookType) {
			return true;
		}
	}
	return false;
}

void Player::addFamiliar(uint16_t lookType) {
	for (FamiliarEntry &familiarEntry : familiars) {
		if (familiarEntry.lookType == lookType) {
			return;
		}
	}
	familiars.emplace_back(lookType);
}

bool Player::removeFamiliar(uint16_t lookType) {
	for (auto it = familiars.begin(), end = familiars.end(); it != end; ++it) {
		FamiliarEntry &entry = *it;
		if (entry.lookType == lookType) {
			familiars.erase(it);
			return true;
		}
	}
	return false;
}

bool Player::getFamiliar(const std::shared_ptr<Familiar> &familiar) const {
	if (group->access) {
		return true;
	}

	if (familiar->premium && !isPremium()) {
		return false;
	}

	for (const FamiliarEntry &familiarEntry : familiars) {
		if (familiarEntry.lookType != familiar->lookType) {
			continue;
		}

		return true;
	}

	if (!familiar->unlocked) {
		return false;
	}

	return true;
}

void Player::setSex(PlayerSex_t newSex) {
	sex = newSex;
}

void Player::setPronoun(PlayerPronoun_t newPronoun) {
	pronoun = newPronoun;
}

Skulls_t Player::getSkull() const {
	if (hasFlag(PlayerFlags_t::NotGainInFight)) {
		return SKULL_NONE;
	}
	return skull;
}

Skulls_t Player::getSkullClient(std::shared_ptr<Creature> creature) {
	if (!creature || g_game().getWorldType() != WORLD_TYPE_PVP) {
		return SKULL_NONE;
	}

	std::shared_ptr<Player> player = creature->getPlayer();
	if (player && player->getSkull() == SKULL_NONE) {
		if (player.get() == this) {
			for (const auto &kill : unjustifiedKills) {
				if (kill.unavenged && (time(nullptr) - kill.time) < g_configManager().getNumber(ORANGE_SKULL_DURATION, __FUNCTION__) * 24 * 60 * 60) {
					return SKULL_ORANGE;
				}
			}
		}

		if (player->hasKilled(getPlayer())) {
			return SKULL_ORANGE;
		}

		if (player->hasAttacked(getPlayer())) {
			return SKULL_YELLOW;
		}

		if (m_party && m_party == player->m_party) {
			return SKULL_GREEN;
		}
	}
	return Creature::getSkullClient(creature);
}

bool Player::hasKilled(std::shared_ptr<Player> player) const {
	for (const auto &kill : unjustifiedKills) {
		if (kill.target == player->getGUID() && (time(nullptr) - kill.time) < g_configManager().getNumber(ORANGE_SKULL_DURATION, __FUNCTION__) * 24 * 60 * 60 && kill.unavenged) {
			return true;
		}
	}

	return false;
}

bool Player::hasAttacked(std::shared_ptr<Player> attacked) const {
	if (hasFlag(PlayerFlags_t::NotGainInFight) || !attacked) {
		return false;
	}

	return attackedSet.contains(attacked->guid);
}

void Player::addAttacked(std::shared_ptr<Player> attacked) {
	if (hasFlag(PlayerFlags_t::NotGainInFight) || !attacked || attacked == getPlayer()) {
		return;
	}

	attackedSet.emplace(attacked->guid);
}

void Player::removeAttacked(std::shared_ptr<Player> attacked) {
	if (!attacked || attacked == getPlayer()) {
		return;
	}

	attackedSet.erase(attacked->guid);
}

void Player::clearAttacked() {
	attackedSet.clear();
}

void Player::addUnjustifiedDead(std::shared_ptr<Player> attacked) {
	if (hasFlag(PlayerFlags_t::NotGainInFight) || attacked == getPlayer() || g_game().getWorldType() == WORLD_TYPE_PVP_ENFORCED) {
		return;
	}

	sendTextMessage(MESSAGE_EVENT_ADVANCE, "Warning! The murder of " + attacked->getName() + " was not justified.");

	unjustifiedKills.emplace_back(attacked->getGUID(), time(nullptr), true);

	uint8_t dayKills = 0;
	uint8_t weekKills = 0;
	uint8_t monthKills = 0;

	for (const auto &kill : unjustifiedKills) {
		const auto diff = time(nullptr) - kill.time;
		if (diff <= 4 * 60 * 60) {
			dayKills += 1;
		}
		if (diff <= 7 * 24 * 60 * 60) {
			weekKills += 1;
		}
		if (diff <= 30 * 24 * 60 * 60) {
			monthKills += 1;
		}
	}

	if (getSkull() != SKULL_BLACK) {
		if (dayKills >= 2 * g_configManager().getNumber(DAY_KILLS_TO_RED, __FUNCTION__) || weekKills >= 2 * g_configManager().getNumber(WEEK_KILLS_TO_RED, __FUNCTION__) || monthKills >= 2 * g_configManager().getNumber(MONTH_KILLS_TO_RED, __FUNCTION__)) {
			setSkull(SKULL_BLACK);
			// start black skull time
			skullTicks = static_cast<int64_t>(g_configManager().getNumber(BLACK_SKULL_DURATION, __FUNCTION__)) * 24 * 60 * 60;
		} else if (dayKills >= g_configManager().getNumber(DAY_KILLS_TO_RED, __FUNCTION__) || weekKills >= g_configManager().getNumber(WEEK_KILLS_TO_RED, __FUNCTION__) || monthKills >= g_configManager().getNumber(MONTH_KILLS_TO_RED, __FUNCTION__)) {
			setSkull(SKULL_RED);
			// reset red skull time
			skullTicks = static_cast<int64_t>(g_configManager().getNumber(RED_SKULL_DURATION, __FUNCTION__)) * 24 * 60 * 60;
		}
	}

	sendUnjustifiedPoints();
}

void Player::checkSkullTicks(int64_t ticks) {
	int64_t newTicks = skullTicks - ticks;
	if (newTicks < 0) {
		skullTicks = 0;
	} else {
		skullTicks = newTicks;
	}

	if ((skull == SKULL_RED || skull == SKULL_BLACK) && skullTicks < 1 && !hasCondition(CONDITION_INFIGHT)) {
		setSkull(SKULL_NONE);
	}
}

bool Player::isPromoted() const {
	uint16_t promotedVocation = g_vocations().getPromotedVocation(vocation->getId());
	return promotedVocation == VOCATION_NONE && vocation->getId() != promotedVocation;
}

double Player::getLostPercent() const {
	int32_t blessingCount = 0;
	uint8_t maxBlessing = (operatingSystem == CLIENTOS_NEW_WINDOWS || operatingSystem == CLIENTOS_NEW_MAC) ? 8 : 6;
	for (int i = 2; i <= maxBlessing; i++) {
		if (hasBlessing(i)) {
			blessingCount++;
		}
	}

	int32_t deathLosePercent = g_configManager().getNumber(DEATH_LOSE_PERCENT, __FUNCTION__);
	if (deathLosePercent != -1) {
		if (isPromoted()) {
			deathLosePercent -= 3;
		}

		deathLosePercent -= blessingCount;
		return std::max<int32_t>(0, deathLosePercent) / 100.;
	}

	double lossPercent;
	if (level >= 24) {
		double tmpLevel = level + (levelPercent / 100.);
		lossPercent = ((tmpLevel + 50) * 50 * ((tmpLevel * tmpLevel) - (5 * tmpLevel) + 8)) / experience;
	} else {
		lossPercent = 5;
	}

	double percentReduction = 0;
	if (isPromoted()) {
		percentReduction += 30;
	}

	percentReduction += blessingCount * 8;
	return lossPercent * (1 - (percentReduction / 100.)) / 100.;
}

void Player::learnInstantSpell(const std::string &spellName) {
	if (!hasLearnedInstantSpell(spellName)) {
		learnedInstantSpellList.emplace_back(spellName);
	}
}

void Player::forgetInstantSpell(const std::string &spellName) {
	std::erase(learnedInstantSpellList, spellName);
}

bool Player::hasLearnedInstantSpell(const std::string &spellName) const {
	if (hasFlag(PlayerFlags_t::CannotUseSpells)) {
		return false;
	}

	if (hasFlag(PlayerFlags_t::IgnoreSpellCheck)) {
		return true;
	}

	for (const auto &learnedSpellName : learnedInstantSpellList) {
		if (strcasecmp(learnedSpellName.c_str(), spellName.c_str()) == 0) {
			return true;
		}
	}
	return false;
}

bool Player::isInWar(std::shared_ptr<Player> player) const {
	if (!player || !guild) {
		return false;
	}

	const auto playerGuild = player->getGuild();
	if (!playerGuild) {
		return false;
	}

	return isInWarList(playerGuild->getId()) && player->isInWarList(guild->getId());
}

bool Player::isInWarList(uint32_t guildId) const {
	return std::find(guildWarVector.begin(), guildWarVector.end(), guildId) != guildWarVector.end();
}

uint32_t Player::getMagicLevel() const {
	uint32_t magic = std::max<int32_t>(0, getLoyaltyMagicLevel() + varStats[STAT_MAGICPOINTS]);
	// Wheel of destiny magic bonus
	magic += m_wheelPlayer->getStat(WheelStat_t::MAGIC); // Regular bonus
	magic += m_wheelPlayer->getMajorStatConditional("Positional Tatics", WheelMajor_t::MAGIC); // Revelation bonus
	return magic;
}

uint32_t Player::getLoyaltyMagicLevel() const {
	uint32_t level = getBaseMagicLevel();
	absl::uint128 currReqMana = vocation->getReqMana(level);
	absl::uint128 nextReqMana = vocation->getReqMana(level + 1);
	if (currReqMana >= nextReqMana) {
		// player has reached max magic level
		return level;
	}

	absl::uint128 spent = manaSpent;
	absl::uint128 totalMana = vocation->getTotalMana(level) + spent;
	absl::uint128 loyaltyMana = (totalMana * getLoyaltyBonus()) / 100;
	while ((spent + loyaltyMana) >= nextReqMana) {
		loyaltyMana -= nextReqMana - spent;
		level++;
		spent = 0;

		currReqMana = nextReqMana;
		nextReqMana = vocation->getReqMana(level + 1);
		if (currReqMana >= nextReqMana) {
			loyaltyMana = 0;
			break;
		}
	}
	return level;
}

uint32_t Player::getCapacity() const {
	if (hasFlag(PlayerFlags_t::CannotPickupItem)) {
		return 0;
	} else if (hasFlag(PlayerFlags_t::HasInfiniteCapacity)) {
		return std::numeric_limits<uint32_t>::max();
	}
	return capacity + bonusCapacity + varStats[STAT_CAPACITY] + m_wheelPlayer->getStat(WheelStat_t::CAPACITY);
}

int32_t Player::getMaxHealth() const {
	return std::max<int32_t>(1, healthMax + varStats[STAT_MAXHITPOINTS] + m_wheelPlayer->getStat(WheelStat_t::HEALTH));
}

uint32_t Player::getMaxMana() const {
	return std::max<int32_t>(0, manaMax + varStats[STAT_MAXMANAPOINTS] + m_wheelPlayer->getStat(WheelStat_t::MANA));
}

uint16_t Player::getSkillLevel(skills_t skill) const {
	auto skillLevel = getLoyaltySkill(skill);
	skillLevel = std::max<int32_t>(0, skillLevel + varSkills[skill]);

	if (auto it = maxValuePerSkill.find(skill);
	    it != maxValuePerSkill.end()) {
		skillLevel = std::min<int32_t>(it->second, skillLevel);
	}

	// Wheel of destiny
	if (skill >= SKILL_CLUB && skill <= SKILL_AXE) {
		skillLevel += m_wheelPlayer->getStat(WheelStat_t::MELEE);
		skillLevel += m_wheelPlayer->getMajorStatConditional("Battle Instinct", WheelMajor_t::MELEE);
	} else if (skill == SKILL_DISTANCE) {
		skillLevel += m_wheelPlayer->getMajorStatConditional("Positional Tatics", WheelMajor_t::DISTANCE);
		skillLevel += m_wheelPlayer->getStat(WheelStat_t::DISTANCE);
	} else if (skill == SKILL_SHIELD) {
		skillLevel += m_wheelPlayer->getMajorStatConditional("Battle Instinct", WheelMajor_t::SHIELD);
	} else if (skill == SKILL_MAGLEVEL) {
		skillLevel += m_wheelPlayer->getMajorStatConditional("Positional Tatics", WheelMajor_t::MAGIC);
		skillLevel += m_wheelPlayer->getStat(WheelStat_t::MAGIC);
	} else if (skill == SKILL_LIFE_LEECH_AMOUNT) {
		skillLevel += m_wheelPlayer->getStat(WheelStat_t::LIFE_LEECH);
	} else if (skill == SKILL_MANA_LEECH_AMOUNT) {
		skillLevel += m_wheelPlayer->getStat(WheelStat_t::MANA_LEECH);
	} else if (skill == SKILL_CRITICAL_HIT_DAMAGE) {
		skillLevel += m_wheelPlayer->getStat(WheelStat_t::CRITICAL_DAMAGE);
		skillLevel += m_wheelPlayer->getMajorStatConditional("Combat Mastery", WheelMajor_t::CRITICAL_DMG_2);
		skillLevel += m_wheelPlayer->getMajorStatConditional("Ballistic Mastery", WheelMajor_t::CRITICAL_DMG);
		skillLevel += m_wheelPlayer->checkAvatarSkill(WheelAvatarSkill_t::CRITICAL_DAMAGE);
	}

	int32_t avatarCritChance = m_wheelPlayer->checkAvatarSkill(WheelAvatarSkill_t::CRITICAL_CHANCE);
	if (skill == SKILL_CRITICAL_HIT_CHANCE && avatarCritChance > 0) {
		skillLevel = avatarCritChance; // 100%
	}

	return std::min<uint16_t>(std::numeric_limits<uint16_t>::max(), std::max<uint16_t>(0, static_cast<uint16_t>(skillLevel)));
}

bool Player::isAccessPlayer() const {
	return group->access;
}

bool Player::isPlayerGroup() const {
	return group->id <= GROUP_TYPE_SENIORTUTOR;
}

bool Player::isPremium() const {
	if (g_configManager().getBoolean(FREE_PREMIUM, __FUNCTION__) || hasFlag(PlayerFlags_t::IsAlwaysPremium)) {
		return true;
	}

	if (!account) {
		return false;
	}

	return account->getPremiumRemainingDays() > 0 || account->getPremiumLastDay() > getTimeNow();
}

uint32_t Player::getPremiumDays() const {
	return account->getPremiumRemainingDays();
}

time_t Player::getPremiumLastDay() const {
	return account->getPremiumLastDay();
}

void Player::setTibiaCoins(int32_t v) {
	coinBalance = v;
}

int32_t Player::getCleavePercent(bool useCharges) const {
	int32_t result = cleavePercent;
	for (const auto &item : getEquippedItems()) {
		const ItemType &it = Item::items[item->getID()];
		if (!it.abilities) {
			continue;
		}

		const int32_t &cleave_percent = it.abilities->cleavePercent;
		if (cleave_percent != 0) {
			result += cleave_percent;
			uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

int32_t Player::getPerfectShotDamage(uint8_t range, bool useCharges) const {
	int32_t result = 0;
	auto it = perfectShot.find(range);
	if (it != perfectShot.end()) {
		result = it->second;
	}

	for (const auto &item : getEquippedItems()) {
		const ItemType &itemType = Item::items[item->getID()];
		if (!itemType.abilities) {
			continue;
		}

		if (!itemType.abilities->perfectShotRange) {
			continue;
		}

		if (itemType.abilities->perfectShotRange == range) {
			result += itemType.abilities->perfectShotDamage;
			uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

int32_t Player::getSpecializedMagicLevel(CombatType_t combat, bool useCharges) const {
	int32_t result = specializedMagicLevel[combatTypeToIndex(combat)];
	for (const auto &item : getEquippedItems()) {
		const ItemType &itemType = Item::items[item->getID()];
		if (!itemType.abilities) {
			continue;
		}

		int32_t specialized_magic_level = itemType.abilities->specializedMagicLevel[combatTypeToIndex(combat)];
		if (specialized_magic_level > 0) {
			result += specialized_magic_level;
			uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

int32_t Player::getMagicShieldCapacityFlat(bool useCharges) const {
	int32_t result = magicShieldCapacityFlat;
	for (const auto &item : getEquippedItems()) {
		const ItemType &itemType = Item::items[item->getID()];
		if (!itemType.abilities) {
			continue;
		}

		int32_t magicCapacity = itemType.abilities->magicShieldCapacityFlat;
		if (magicCapacity != 0) {
			result += magicCapacity;
			uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

int32_t Player::getMagicShieldCapacityPercent(bool useCharges) const {
	int32_t result = magicShieldCapacityPercent;
	for (const auto &item : getEquippedItems()) {
		const ItemType &itemType = Item::items[item->getID()];
		if (!itemType.abilities) {
			continue;
		}

		int32_t magicPercent = itemType.abilities->magicShieldCapacityPercent;
		if (magicPercent != 0) {
			result += magicPercent;
			uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

int32_t Player::getReflectPercent(CombatType_t combat, bool useCharges) const {
	int32_t result = reflectPercent[combatTypeToIndex(combat)];
	for (const auto &item : getEquippedItems()) {
		const ItemType &itemType = Item::items[item->getID()];
		if (!itemType.abilities) {
			continue;
		}

		int32_t reflectPercent = itemType.abilities->reflectPercent[combatTypeToIndex(combat)];
		if (reflectPercent != 0) {
			result += reflectPercent;
			uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

int32_t Player::getReflectFlat(CombatType_t combat, bool useCharges) const {
	int32_t result = reflectFlat[combatTypeToIndex(combat)];
	for (const auto &item : getEquippedItems()) {
		const ItemType &itemType = Item::items[item->getID()];
		if (!itemType.abilities) {
			continue;
		}

		int32_t reflectFlat = itemType.abilities->reflectFlat[combatTypeToIndex(combat)];
		if (reflectFlat != 0) {
			result += reflectFlat;
			uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

void Player::setTransferableTibiaCoins(int32_t v) {
	coinTransferableBalance = v;
}

PartyShields_t Player::getPartyShield(std::shared_ptr<Player> player) {
	if (!player) {
		return SHIELD_NONE;
	}

	if (m_party) {
		if (m_party->getLeader() == player) {
			if (m_party->isSharedExperienceActive()) {
				if (m_party->isSharedExperienceEnabled()) {
					return SHIELD_YELLOW_SHAREDEXP;
				}

				if (m_party->canUseSharedExperience(player)) {
					return SHIELD_YELLOW_NOSHAREDEXP;
				}

				return SHIELD_YELLOW_NOSHAREDEXP_BLINK;
			}

			return SHIELD_YELLOW;
		}

		if (player->m_party == m_party) {
			if (m_party->isSharedExperienceActive()) {
				if (m_party->isSharedExperienceEnabled()) {
					return SHIELD_BLUE_SHAREDEXP;
				}

				if (m_party->canUseSharedExperience(player)) {
					return SHIELD_BLUE_NOSHAREDEXP;
				}

				return SHIELD_BLUE_NOSHAREDEXP_BLINK;
			}

			return SHIELD_BLUE;
		}

		if (isInviting(player)) {
			return SHIELD_WHITEBLUE;
		}
	}

	if (player->isInviting(getPlayer())) {
		return SHIELD_WHITEYELLOW;
	}

	if (player->m_party) {
		return SHIELD_GRAY;
	}

	return SHIELD_NONE;
}

bool Player::isInviting(std::shared_ptr<Player> player) const {
	if (!player || !m_party || m_party->getLeader().get() != this) {
		return false;
	}
	return m_party->isPlayerInvited(player);
}

bool Player::isPartner(std::shared_ptr<Player> player) const {
	if (!player || !m_party || player.get() == this) {
		return false;
	}
	return m_party == player->m_party;
}

bool Player::isGuildMate(std::shared_ptr<Player> player) const {
	if (!player || !guild) {
		return false;
	}
	return guild == player->guild;
}

void Player::sendPlayerPartyIcons(std::shared_ptr<Player> player) {
	sendPartyCreatureShield(player);
	sendPartyCreatureSkull(player);
}

bool Player::addPartyInvitation(std::shared_ptr<Party> newParty) {
	auto it = std::find(invitePartyList.begin(), invitePartyList.end(), newParty);
	if (it != invitePartyList.end()) {
		return false;
	}

	invitePartyList.emplace_back(newParty);
	return true;
}

void Player::removePartyInvitation(std::shared_ptr<Party> remParty) {
	std::erase(invitePartyList, remParty);
}

void Player::clearPartyInvitations() {
	for (const auto &invitingParty : invitePartyList) {
		invitingParty->removeInvite(getPlayer(), false);
	}
	invitePartyList.clear();
}

GuildEmblems_t Player::getGuildEmblem(std::shared_ptr<Player> player) const {
	if (!player) {
		return GUILDEMBLEM_NONE;
	}

	const auto playerGuild = player->getGuild();
	if (!playerGuild) {
		return GUILDEMBLEM_NONE;
	}

	if (player->getGuildWarVector().empty()) {
		if (guild == playerGuild) {
			return GUILDEMBLEM_MEMBER;
		} else {
			return GUILDEMBLEM_OTHER;
		}
	} else if (guild == playerGuild) {
		return GUILDEMBLEM_ALLY;
	} else if (isInWar(player)) {
		return GUILDEMBLEM_ENEMY;
	}

	return GUILDEMBLEM_NEUTRAL;
}

void Player::sendUnjustifiedPoints() {
	if (client) {
		double dayKills = 0;
		double weekKills = 0;
		double monthKills = 0;

		for (const auto &kill : unjustifiedKills) {
			const auto diff = time(nullptr) - kill.time;
			if (diff <= 24 * 60 * 60) {
				dayKills += 1;
			}
			if (diff <= 7 * 24 * 60 * 60) {
				weekKills += 1;
			}
			if (diff <= 30 * 24 * 60 * 60) {
				monthKills += 1;
			}
		}

		bool isRed = getSkull() == SKULL_RED;

		auto dayMax = ((isRed ? 2 : 1) * g_configManager().getNumber(DAY_KILLS_TO_RED, __FUNCTION__));
		auto weekMax = ((isRed ? 2 : 1) * g_configManager().getNumber(WEEK_KILLS_TO_RED, __FUNCTION__));
		auto monthMax = ((isRed ? 2 : 1) * g_configManager().getNumber(MONTH_KILLS_TO_RED, __FUNCTION__));

		uint8_t dayProgress = std::min(std::round(dayKills / dayMax * 100), 100.0);
		uint8_t weekProgress = std::min(std::round(weekKills / weekMax * 100), 100.0);
		uint8_t monthProgress = std::min(std::round(monthKills / monthMax * 100), 100.0);
		uint8_t skullDuration = 0;
		if (skullTicks != 0) {
			skullDuration = std::floor<uint8_t>(skullTicks / (24 * 60 * 60 * 1000));
		}
		client->sendUnjustifiedPoints(dayProgress, std::max(dayMax - dayKills, 0.0), weekProgress, std::max(weekMax - weekKills, 0.0), monthProgress, std::max(monthMax - monthKills, 0.0), skullDuration);
	}
}

uint8_t Player::getLastMount() const {
	int32_t value = getStorageValue(PSTRG_MOUNTS_CURRENTMOUNT);
	if (value > 0) {
		return value;
	}
	return static_cast<uint8_t>(kv()->get("last-mount")->get<int>());
}

uint8_t Player::getCurrentMount() const {
	int32_t value = getStorageValue(PSTRG_MOUNTS_CURRENTMOUNT);
	if (value > 0) {
		return value;
	}
	return 0;
}

void Player::setCurrentMount(uint8_t mount) {
	addStorageValue(PSTRG_MOUNTS_CURRENTMOUNT, mount);
}

bool Player::hasAnyMount() const {
	const auto mounts = g_game().mounts.getMounts();
	for (const auto &mount : mounts) {
		if (hasMount(mount)) {
			return true;
		}
	}
	return false;
}

uint8_t Player::getRandomMountId() const {
	std::vector<uint8_t> playerMounts;
	const auto mounts = g_game().mounts.getMounts();
	for (const auto &mount : mounts) {
		if (hasMount(mount)) {
			playerMounts.push_back(mount->id);
		}
	}

	auto playerMountsSize = static_cast<int32_t>(playerMounts.size() - 1);
	auto randomIndex = uniform_random(0, std::max<int32_t>(0, playerMountsSize));
	return playerMounts.at(randomIndex);
}

bool Player::toggleMount(bool mount) {
	if ((OTSYS_TIME() - lastToggleMount) < 3000 && !wasMounted) {
		sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
		return false;
	}

	if (isWearingSupportOutfit()) {
		return false;
	}

	if (mount) {
		if (isMounted()) {
			return false;
		}

		auto tile = getTile();
		if (!g_configManager().getBoolean(TOGGLE_MOUNT_IN_PZ, __FUNCTION__) && !group->access && tile && tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
			sendCancelMessage(RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE);
			return false;
		}

		const auto &playerOutfit = Outfits::getInstance().getOutfitByLookType(getPlayer(), defaultOutfit.lookType);
		if (!playerOutfit) {
			return false;
		}

		uint8_t currentMountId = getLastMount();
		if (currentMountId == 0) {
			sendOutfitWindow();
			return false;
		}

		if (isRandomMounted()) {
			currentMountId = getRandomMountId();
		}

		const auto currentMount = g_game().mounts.getMountByID(currentMountId);
		if (!currentMount) {
			return false;
		}

		if (!hasMount(currentMount)) {
			setCurrentMount(0);
			kv()->set("last-mount", 0);
			sendOutfitWindow();
			return false;
		}

		if (currentMount->premium && !isPremium()) {
			sendCancelMessage(RETURNVALUE_YOUNEEDPREMIUMACCOUNT);
			return false;
		}

		if (hasCondition(CONDITION_OUTFIT)) {
			sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
			return false;
		}

		defaultOutfit.lookMount = currentMount->clientId;
		setCurrentMount(currentMount->id);
		kv()->set("last-mount", currentMount->id);

		if (currentMount->speed != 0) {
			g_game().changeSpeed(static_self_cast<Player>(), currentMount->speed);
		}
	} else {
		if (!isMounted()) {
			return false;
		}

		dismount();
	}

	g_game().internalCreatureChangeOutfit(static_self_cast<Player>(), defaultOutfit);
	lastToggleMount = OTSYS_TIME();
	return true;
}

bool Player::tameMount(uint8_t mountId) {
	if (!g_game().mounts.getMountByID(mountId)) {
		return false;
	}

	const uint8_t tmpMountId = mountId - 1;
	const uint32_t key = PSTRG_MOUNTS_RANGE_START + (tmpMountId / 31);

	int32_t value = getStorageValue(key);
	if (value != -1) {
		value |= (1 << (tmpMountId % 31));
	} else {
		value = (1 << (tmpMountId % 31));
	}

	addStorageValue(key, value);
	return true;
}

bool Player::untameMount(uint8_t mountId) {
	if (!g_game().mounts.getMountByID(mountId)) {
		return false;
	}

	const uint8_t tmpMountId = mountId - 1;
	const uint32_t key = PSTRG_MOUNTS_RANGE_START + (tmpMountId / 31);

	int32_t value = getStorageValue(key);
	if (value == -1) {
		return true;
	}

	value &= ~(1 << (tmpMountId % 31));
	addStorageValue(key, value);

	if (getCurrentMount() == mountId) {
		if (isMounted()) {
			dismount();
			g_game().internalCreatureChangeOutfit(static_self_cast<Player>(), defaultOutfit);
		}

		setCurrentMount(0);
		kv()->set("last-mount", 0);
	}

	return true;
}

bool Player::hasMount(const std::shared_ptr<Mount> mount) const {
	if (isAccessPlayer()) {
		return true;
	}

	if (mount->premium && !isPremium()) {
		return false;
	}

	const uint8_t tmpMountId = mount->id - 1;

	int32_t value = getStorageValue(PSTRG_MOUNTS_RANGE_START + (tmpMountId / 31));
	if (value == -1) {
		return false;
	}

	return ((1 << (tmpMountId % 31)) & value) != 0;
}

void Player::dismount() {
	const auto mount = g_game().mounts.getMountByID(getCurrentMount());
	if (mount && mount->speed > 0) {
		g_game().changeSpeed(static_self_cast<Player>(), -mount->speed);
	}

	defaultOutfit.lookMount = 0;
}

bool Player::addOfflineTrainingTries(skills_t skill, uint64_t tries) {
	if (tries == 0 || skill == SKILL_LEVEL) {
		return false;
	}

	bool sendUpdate = false;
	uint32_t oldSkillValue, newSkillValue;
	long double oldPercentToNextLevel, newPercentToNextLevel;

	if (skill == SKILL_MAGLEVEL) {
		uint64_t currReqMana = vocation->getReqMana(magLevel);
		uint64_t nextReqMana = vocation->getReqMana(magLevel + 1);

		if (currReqMana >= nextReqMana) {
			return false;
		}

		oldSkillValue = magLevel;
		oldPercentToNextLevel = static_cast<long double>(manaSpent * 100) / nextReqMana;

		g_events().eventPlayerOnGainSkillTries(static_self_cast<Player>(), SKILL_MAGLEVEL, tries);
		g_callbacks().executeCallback(EventCallback_t::playerOnGainSkillTries, &EventCallback::playerOnGainSkillTries, getPlayer(), SKILL_MAGLEVEL, tries);

		uint32_t currMagLevel = magLevel;
		while ((manaSpent + tries) >= nextReqMana) {
			tries -= nextReqMana - manaSpent;

			magLevel++;
			manaSpent = 0;

			g_creatureEvents().playerAdvance(static_self_cast<Player>(), SKILL_MAGLEVEL, magLevel - 1, magLevel);

			sendUpdate = true;
			currReqMana = nextReqMana;
			nextReqMana = vocation->getReqMana(magLevel + 1);

			if (currReqMana >= nextReqMana) {
				tries = 0;
				break;
			}
		}

		manaSpent += tries;

		if (magLevel != currMagLevel) {
			std::ostringstream ss;
			ss << "You advanced to magic level " << magLevel << '.';
			sendTextMessage(MESSAGE_EVENT_ADVANCE, ss.str());
			sendTakeScreenshot(SCREENSHOT_TYPE_SKILLUP);
		}

		uint8_t newPercent;
		if (nextReqMana > currReqMana) {
			newPercent = Player::getPercentLevel(manaSpent, nextReqMana);
			newPercentToNextLevel = static_cast<long double>(manaSpent * 100) / nextReqMana;
		} else {
			newPercent = 0;
			newPercentToNextLevel = 0;
		}

		if (newPercent != magLevelPercent) {
			magLevelPercent = newPercent;
			sendUpdate = true;
		}

		newSkillValue = magLevel;
	} else {
		uint64_t currReqTries = vocation->getReqSkillTries(skill, skills[skill].level);
		uint64_t nextReqTries = vocation->getReqSkillTries(skill, skills[skill].level + 1);
		if (currReqTries >= nextReqTries) {
			return false;
		}

		oldSkillValue = skills[skill].level;
		oldPercentToNextLevel = static_cast<long double>(skills[skill].tries * 100) / nextReqTries;

		g_events().eventPlayerOnGainSkillTries(static_self_cast<Player>(), skill, tries);
		g_callbacks().executeCallback(EventCallback_t::playerOnGainSkillTries, &EventCallback::playerOnGainSkillTries, getPlayer(), skill, tries);
		uint32_t currSkillLevel = skills[skill].level;

		while ((skills[skill].tries + tries) >= nextReqTries) {
			tries -= nextReqTries - skills[skill].tries;

			skills[skill].level++;
			skills[skill].tries = 0;
			skills[skill].percent = 0;

			g_creatureEvents().playerAdvance(static_self_cast<Player>(), skill, (skills[skill].level - 1), skills[skill].level);

			sendUpdate = true;
			currReqTries = nextReqTries;
			nextReqTries = vocation->getReqSkillTries(skill, skills[skill].level + 1);

			if (currReqTries >= nextReqTries) {
				tries = 0;
				break;
			}
		}

		skills[skill].tries += tries;

		if (currSkillLevel != skills[skill].level) {
			std::ostringstream ss;
			ss << "You advanced to " << getSkillName(skill) << " level " << skills[skill].level << '.';
			sendTextMessage(MESSAGE_EVENT_ADVANCE, ss.str());
			if (skill == SKILL_LEVEL) {
				sendTakeScreenshot(SCREENSHOT_TYPE_LEVELUP);
			} else {
				sendTakeScreenshot(SCREENSHOT_TYPE_SKILLUP);
			}
		}

		uint8_t newPercent;
		if (nextReqTries > currReqTries) {
			newPercent = Player::getPercentLevel(skills[skill].tries, nextReqTries);
			newPercentToNextLevel = static_cast<long double>(skills[skill].tries * 100) / nextReqTries;
		} else {
			newPercent = 0;
			newPercentToNextLevel = 0;
		}

		if (skills[skill].percent != newPercent) {
			skills[skill].percent = newPercent;
			sendUpdate = true;
		}

		newSkillValue = skills[skill].level;
	}

	if (sendUpdate) {
		sendSkills();
		sendStats();
	}

	std::string message = fmt::format(
		"Your {} skill changed from level {} (with {:.2f}% progress towards level {}) to level {} (with {:.2f}% progress towards level {})",
		ucwords(getSkillName(skill)),
		oldSkillValue,
		oldPercentToNextLevel,
		oldSkillValue + 1,
		newSkillValue,
		newPercentToNextLevel,
		newSkillValue + 1
	);

	sendTextMessage(MESSAGE_EVENT_ADVANCE, message);
	return sendUpdate;
}

bool Player::hasModalWindowOpen(uint32_t modalWindowId) const {
	return find(modalWindows.begin(), modalWindows.end(), modalWindowId) != modalWindows.end();
}

void Player::onModalWindowHandled(uint32_t modalWindowId) {
	std::erase(modalWindows, modalWindowId);
}

void Player::sendModalWindow(const ModalWindow &modalWindow) {
	if (!client) {
		return;
	}

	modalWindows.emplace_back(modalWindow.id);
	client->sendModalWindow(modalWindow);
}

void Player::clearModalWindows() {
	modalWindows.clear();
}

uint16_t Player::getHelpers() const {
	if (guild && m_party) {
		const auto &guildMembers = guild->getMembersOnline();

		stdext::vector_set<std::shared_ptr<Player>> helperSet;
		helperSet.insert(helperSet.end(), guildMembers.begin(), guildMembers.end());
		helperSet.insertAll(m_party->getMembers());
		helperSet.insertAll(m_party->getInvitees());

		helperSet.emplace(m_party->getLeader());

		return static_cast<uint16_t>(helperSet.size());
	}

	if (guild) {
		return static_cast<uint16_t>(guild->getMemberCountOnline());
	}

	if (m_party) {
		return static_cast<uint16_t>(m_party->getMemberCount() + m_party->getInvitationCount() + 1);
	}

	return 0u;
}

void Player::sendClosePrivate(uint16_t channelId) {
	if (channelId == CHANNEL_GUILD || channelId == CHANNEL_PARTY) {
		g_chat().removeUserFromChannel(getPlayer(), channelId);
	}

	if (client) {
		client->sendClosePrivate(channelId);
	}
}

void Player::sendCyclopediaCharacterAchievements(uint16_t secretsUnlocked, std::vector<std::pair<Achievement, uint32_t>> achievementsUnlocked) {
	if (client) {
		client->sendCyclopediaCharacterAchievements(secretsUnlocked, achievementsUnlocked);
	}
}

uint64_t Player::getMoney() const {
	std::vector<std::shared_ptr<Container>> containers;
	uint64_t moneyCount = 0;

	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		std::shared_ptr<Item> item = inventory[i];
		if (!item) {
			continue;
		}

		std::shared_ptr<Container> container = item->getContainer();
		if (container) {
			containers.push_back(container);
		} else {
			moneyCount += item->getWorth();
		}
	}

	size_t i = 0;
	while (i < containers.size()) {
		std::shared_ptr<Container> container = containers[i++];
		for (const std::shared_ptr<Item> &item : container->getItemList()) {
			std::shared_ptr<Container> tmpContainer = item->getContainer();
			if (tmpContainer) {
				containers.push_back(tmpContainer);
			} else {
				moneyCount += item->getWorth();
			}
		}
	}
	return moneyCount;
}

std::pair<uint64_t, uint64_t> Player::getForgeSliversAndCores() const {
	uint64_t sliverCount = 0;
	uint64_t coreCount = 0;

	// Check items from inventory
	for (const auto &item : getAllInventoryItems()) {
		if (!item) {
			continue;
		}

		sliverCount += item->getForgeSlivers();
		coreCount += item->getForgeCores();
	}

	// Check items from stash
	for (StashItemList stashToSend = getStashItems();
	     auto [itemId, itemCount] : stashToSend) {
		if (itemId == ITEM_FORGE_SLIVER) {
			sliverCount += itemCount;
		}
		if (itemId == ITEM_FORGE_CORE) {
			coreCount += itemCount;
		}
	}

	return std::make_pair(sliverCount, coreCount);
}

size_t Player::getMaxDepotItems() const {
	if (group->maxDepotItems != 0) {
		return group->maxDepotItems;
	} else if (isPremium()) {
		return g_configManager().getNumber(PREMIUM_DEPOT_LIMIT, __FUNCTION__);
	}
	return g_configManager().getNumber(FREE_DEPOT_LIMIT, __FUNCTION__);
}

std::vector<std::shared_ptr<Condition>> Player::getMuteConditions() const {
	std::vector<std::shared_ptr<Condition>> muteConditions;
	muteConditions.reserve(conditions.size());

	for (const std::shared_ptr<Condition> &condition : conditions) {
		if (condition->getTicks() <= 0) {
			continue;
		}

		ConditionType_t type = condition->getType();
		if (type != CONDITION_MUTED && type != CONDITION_CHANNELMUTEDTICKS && type != CONDITION_YELLTICKS) {
			continue;
		}

		muteConditions.emplace_back(condition);
	}
	return muteConditions;
}

void Player::setGuild(const std::shared_ptr<Guild> newGuild) {
	if (newGuild == guild) {
		return;
	}

	if (guild) {
		guild->removeMember(static_self_cast<Player>());
		guild = nullptr;
	}

	guildNick.clear();
	guildRank = nullptr;

	if (newGuild) {
		const auto rank = newGuild->getRankByLevel(1);
		if (!rank) {
			return;
		}

		guild = newGuild;
		guildRank = rank;
		newGuild->addMember(static_self_cast<Player>());
	}
}

void Player::updateRegeneration() {
	if (!vocation) {
		return;
	}

	std::shared_ptr<Condition> condition = getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	if (condition) {
		condition->setParam(CONDITION_PARAM_HEALTHGAIN, vocation->getHealthGainAmount());
		condition->setParam(CONDITION_PARAM_HEALTHTICKS, vocation->getHealthGainTicks());
		condition->setParam(CONDITION_PARAM_MANAGAIN, vocation->getManaGainAmount());
		condition->setParam(CONDITION_PARAM_MANATICKS, vocation->getManaGainTicks());
	}
}

// User Interface action exhaustion
bool Player::isUIExhausted(uint32_t exhaustionTime /*= 250*/) const {
	return (OTSYS_TIME() - lastUIInteraction < exhaustionTime);
}

void Player::updateUIExhausted() {
	lastUIInteraction = OTSYS_TIME();
}

void Player::setImmuneFear() {
	m_fearCondition.first = CONDITION_FEARED;
	m_fearCondition.second = OTSYS_TIME() + 10000;
}

bool Player::isImmuneFear() const {
	uint64_t timenow = OTSYS_TIME();
	return (m_fearCondition.first == CONDITION_FEARED) && (timenow <= m_fearCondition.second);
}

uint64_t Player::getItemCustomPrice(uint16_t itemId, bool buyPrice /* = false*/) const {
	auto it = itemPriceMap.find(itemId);
	if (it != itemPriceMap.end()) {
		return it->second;
	}

	std::map<uint16_t, uint64_t> itemMap { { itemId, 1 } };
	return g_game().getItemMarketPrice(itemMap, buyPrice);
}

uint16_t Player::getFreeBackpackSlots() const {
	std::shared_ptr<Thing> thing = getThing(CONST_SLOT_BACKPACK);
	if (!thing) {
		return 0;
	}

	std::shared_ptr<Container> backpack = thing->getContainer();
	if (!backpack) {
		return 0;
	}

	uint16_t counter = std::max<uint16_t>(0, backpack->getFreeSlots());

	return counter;
}

void Player::addItemImbuementStats(const Imbuement* imbuement) {
	bool requestUpdate = false;
	// Check imbuement skills
	for (int32_t skill = SKILL_FIRST; skill <= SKILL_LAST; ++skill) {
		if (imbuement->skills[skill]) {
			requestUpdate = true;
			setVarSkill(static_cast<skills_t>(skill), imbuement->skills[skill]);
		}
	}

	// Check imbuement magic level
	for (int32_t stat = STAT_FIRST; stat <= STAT_LAST; ++stat) {
		if (imbuement->stats[stat]) {
			requestUpdate = true;
			setVarStats(static_cast<stats_t>(stat), imbuement->stats[stat]);
		}
	}

	// Add imbuement speed
	if (imbuement->speed != 0) {
		g_game().changeSpeed(static_self_cast<Player>(), imbuement->speed);
	}

	// Add imbuement capacity
	if (imbuement->capacity != 0) {
		requestUpdate = true;
		bonusCapacity = (capacity * imbuement->capacity) / 100;
	}

	if (requestUpdate) {
		sendStats();
		sendSkills();
	}
}

void Player::removeItemImbuementStats(const Imbuement* imbuement) {
	if (!imbuement) {
		return;
	}

	bool requestUpdate = false;

	for (int32_t skill = SKILL_FIRST; skill <= SKILL_LAST; ++skill) {
		if (imbuement->skills[skill]) {
			requestUpdate = true;
			setVarSkill(static_cast<skills_t>(skill), -imbuement->skills[skill]);
		}
	}

	// Check imbuement magic level
	for (int32_t stat = STAT_FIRST; stat <= STAT_LAST; ++stat) {
		if (imbuement->stats[stat]) {
			requestUpdate = true;
			setVarStats(static_cast<stats_t>(stat), -imbuement->stats[stat]);
		}
	}

	// Remove imbuement speed
	if (imbuement->speed != 0) {
		g_game().changeSpeed(static_self_cast<Player>(), -imbuement->speed);
	}

	// Remove imbuement capacity
	if (imbuement->capacity != 0) {
		requestUpdate = true;
		bonusCapacity = 0;
	}

	if (requestUpdate) {
		sendStats();
		sendSkills();
	}
}

void Player::updateImbuementTrackerStats() const {
	if (imbuementTrackerWindowOpen) {
		g_game().playerRequestInventoryImbuements(getID(), true);
	}
}

bool Player::addItemFromStash(uint16_t itemId, uint32_t itemCount) {
	uint32_t stackCount = 100u;

	while (itemCount > 0) {
		auto addValue = itemCount > stackCount ? stackCount : itemCount;
		itemCount -= addValue;
		std::shared_ptr<Item> newItem = Item::CreateItem(itemId, addValue);

		if (!g_game().tryRetrieveStashItems(static_self_cast<Player>(), newItem)) {
			g_game().internalPlayerAddItem(static_self_cast<Player>(), newItem, true);
		}
	}

	// This check is necessary because we need to block it when we retrieve an item from depot search.
	if (!isDepotSearchOpenOnItem(itemId)) {
		sendOpenStash();
	}

	return true;
}

void sendStowItems(const std::shared_ptr<Item> &item, const std::shared_ptr<Item> &stowItem, StashContainerList &itemDict) {
	if (stowItem->getID() == item->getID()) {
		itemDict.push_back(std::pair<std::shared_ptr<Item>, uint32_t>(stowItem, stowItem->getItemCount()));
	}

	if (auto container = stowItem->getContainer()) {
		for (const auto &stowable_it : container->getStowableItems()) {
			if ((stowable_it.first)->getID() == item->getID()) {
				itemDict.push_back(stowable_it);
			}
		}
	}
}

void Player::stowItem(std::shared_ptr<Item> item, uint32_t count, bool allItems) {
	if (!item || !item->isItemStorable()) {
		sendCancelMessage("This item cannot be stowed here.");
		return;
	}

	StashContainerList itemDict;
	if (allItems) {
		if (!item->isInsideDepot(true)) {
			// Stow "all items" from player backpack
			if (auto backpack = getInventoryItem(CONST_SLOT_BACKPACK)) {
				sendStowItems(item, backpack, itemDict);
			}

			// Stow "all items" from loot pouch
			auto itemParent = item->getParent();
			auto lootPouch = itemParent->getItem();
			if (itemParent && lootPouch && lootPouch->getID() == ITEM_GOLD_POUCH) {
				sendStowItems(item, lootPouch, itemDict);
			}
		}

		// Stow locker items
		std::shared_ptr<DepotLocker> depotLocker = getDepotLocker(getLastDepotId());
		auto [itemVector, itemMap] = requestLockerItems(depotLocker);
		for (const auto &lockerItem : itemVector) {
			if (lockerItem == nullptr) {
				break;
			}

			if (item->isInsideDepot(true)) {
				sendStowItems(item, lockerItem, itemDict);
			}
		}
	} else if (item->getContainer()) {
		itemDict = item->getContainer()->getStowableItems();
		for (const std::shared_ptr<Item> &containerItem : item->getContainer()->getItems(true)) {
			uint32_t depotChest = g_configManager().getNumber(DEPOTCHEST, __FUNCTION__);
			bool validDepot = depotChest > 0 && depotChest < 21;
			if (g_configManager().getBoolean(STASH_MOVING, __FUNCTION__) && containerItem && !containerItem->isStackable() && validDepot) {
				g_game().internalMoveItem(containerItem->getParent(), getDepotChest(depotChest, true), INDEX_WHEREEVER, containerItem, containerItem->getItemCount(), nullptr);
				movedItems++;
				moved = true;
			}
		}
	} else {
		itemDict.emplace_back(item, count);
	}

	if (itemDict.empty()) {
		sendCancelMessage("There is no stowable items on this container.");
		return;
	}

	stashContainer(itemDict);
}

void Player::openPlayerContainers() {
	std::vector<std::pair<uint8_t, std::shared_ptr<Container>>> openContainersList;

	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; i++) {
		std::shared_ptr<Item> item = inventory[i];
		if (!item) {
			continue;
		}

		std::shared_ptr<Container> itemContainer = item->getContainer();
		if (itemContainer) {
			auto cid = item->getAttribute<int64_t>(ItemAttribute_t::OPENCONTAINER);
			if (cid > 0) {
				openContainersList.emplace_back(cid, itemContainer);
			}
			for (ContainerIterator it = itemContainer->iterator(); it.hasNext(); it.advance()) {
				std::shared_ptr<Container> subContainer = (*it)->getContainer();
				if (subContainer) {
					auto subcid = (*it)->getAttribute<uint8_t>(ItemAttribute_t::OPENCONTAINER);
					if (subcid > 0) {
						openContainersList.emplace_back(subcid, subContainer);
					}
				}
			}
		}
	}

	std::sort(openContainersList.begin(), openContainersList.end(), [](const std::pair<uint8_t, std::shared_ptr<Container>> &left, const std::pair<uint8_t, std::shared_ptr<Container>> &right) {
		return left.first < right.first;
	});

	for (auto &it : openContainersList) {
		addContainer(it.first - 1, it.second);
		onSendContainer(it.second);
	}
}

void Player::initializePrey() {
	if (preys.empty()) {
		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			auto slot = std::make_unique<PreySlot>(static_cast<PreySlot_t>(slotId));
			if (!g_configManager().getBoolean(PREY_ENABLED, __FUNCTION__)) {
				slot->state = PreyDataState_Inactive;
			} else if (slot->id == PreySlot_Three && !g_configManager().getBoolean(PREY_FREE_THIRD_SLOT, __FUNCTION__)) {
				slot->state = PreyDataState_Locked;
			} else if (slot->id == PreySlot_Two && !isPremium()) {
				slot->state = PreyDataState_Locked;
			} else {
				slot->state = PreyDataState_Selection;
				slot->reloadMonsterGrid(getPreyBlackList(), getLevel());
			}

			setPreySlotClass(slot);
		}
	}
}

void Player::removePreySlotById(PreySlot_t slotid) {
	auto it = std::remove_if(preys.begin(), preys.end(), [slotid](const std::unique_ptr<PreySlot> &preyIt) {
		return preyIt->id == slotid;
	});

	preys.erase(it, preys.end());
}

void Player::initializeTaskHunting() {
	if (taskHunting.empty()) {
		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			auto slot = std::make_unique<TaskHuntingSlot>(static_cast<PreySlot_t>(slotId));
			if (!g_configManager().getBoolean(TASK_HUNTING_ENABLED, __FUNCTION__)) {
				slot->state = PreyTaskDataState_Inactive;
			} else if (slot->id == PreySlot_Three && !g_configManager().getBoolean(TASK_HUNTING_FREE_THIRD_SLOT, __FUNCTION__)) {
				slot->state = PreyTaskDataState_Locked;
			} else if (slot->id == PreySlot_Two && !isPremium()) {
				slot->state = PreyTaskDataState_Locked;
			} else {
				slot->state = PreyTaskDataState_Selection;
				slot->reloadMonsterGrid(getTaskHuntingBlackList(), getLevel());
			}

			setTaskHuntingSlotClass(slot);
		}
	}

	if (client && g_configManager().getBoolean(TASK_HUNTING_ENABLED, __FUNCTION__) && !client->oldProtocol) {
		client->writeToOutputBuffer(g_ioprey().getTaskHuntingBaseDate());
	}
}

std::string Player::getBlessingsName() const {
	uint8_t count = 0;
	std::for_each(blessings.begin(), blessings.end(), [&count](uint8_t amount) {
		if (amount != 0) {
			count++;
		}
	});

	auto BlessingNames = g_game().getBlessingNames();
	std::ostringstream os;
	for (uint8_t i = 1; i <= 8; i++) {
		if (hasBlessing(i)) {
			if (auto blessName = BlessingNames.find(static_cast<Blessings_t>(i));
			    blessName != BlessingNames.end()) {
				os << (*blessName).second;
			} else {
				continue;
			}

			--count;
			if (count > 1) {
				os << ", ";
			} else if (count == 1) {
				os << " and ";
			} else {
				os << ".";
			}
		}
	}

	return os.str();
}

bool Player::isCreatureUnlockedOnTaskHunting(const std::shared_ptr<MonsterType> mtype) const {
	if (!mtype) {
		return false;
	}

	return getBestiaryKillCount(mtype->info.raceid) >= mtype->info.bestiaryToUnlock;
}

void Player::triggerMomentum() {
	auto item = getInventoryItem(CONST_SLOT_HEAD);
	if (item == nullptr) {
		return;
	}

	double_t chance = item->getMomentumChance();
	double_t randomChance = uniform_random(0, 10000) / 100.;
	if (getZoneType() != ZONE_PROTECTION && hasCondition(CONDITION_INFIGHT) && ((OTSYS_TIME() / 1000) % 2) == 0 && chance > 0 && randomChance < chance) {
		bool triggered = false;
		auto it = conditions.begin();
		while (it != conditions.end()) {
			auto condItem = *it;
			ConditionType_t type = condItem->getType();
			auto maxu16 = std::numeric_limits<uint16_t>::max();
			auto checkSpellId = condItem->getSubId();
			auto spellId = checkSpellId > maxu16 ? 0u : static_cast<uint16_t>(checkSpellId);
			int32_t ticks = condItem->getTicks();
			int32_t newTicks = (ticks <= 2000) ? 0 : ticks - 2000;
			triggered = true;
			if (type == CONDITION_SPELLCOOLDOWN || (type == CONDITION_SPELLGROUPCOOLDOWN && spellId > SPELLGROUP_SUPPORT)) {
				condItem->setTicks(newTicks);
				type == CONDITION_SPELLGROUPCOOLDOWN ? sendSpellGroupCooldown(static_cast<SpellGroup_t>(spellId), newTicks) : sendSpellCooldown(spellId, newTicks);
			}
			++it;
		}
		if (triggered) {
			g_game().addMagicEffect(getPosition(), CONST_ME_HOURGLASS);
			sendTextMessage(MESSAGE_ATTENTION, "Momentum was triggered.");
		}
	}
}

void Player::clearCooldowns() {
	auto it = conditions.begin();
	while (it != conditions.end()) {
		auto condItem = *it;
		ConditionType_t type = condItem->getType();
		auto maxu16 = std::numeric_limits<uint16_t>::max();
		auto checkSpellId = condItem->getSubId();
		auto spellId = checkSpellId > maxu16 ? 0u : static_cast<uint16_t>(checkSpellId);
		if (type == CONDITION_SPELLCOOLDOWN || type == CONDITION_SPELLGROUPCOOLDOWN) {
			condItem->setTicks(0);
			type == CONDITION_SPELLGROUPCOOLDOWN ? sendSpellGroupCooldown(static_cast<SpellGroup_t>(spellId), 0) : sendSpellCooldown(spellId, 0);
		}
		++it;
	}
}

void Player::triggerTranscendance() {
	if (wheel()->getOnThinkTimer(WheelOnThink_t::AVATAR_FORGE) > OTSYS_TIME()) {
		return;
	}

	auto item = getInventoryItem(CONST_SLOT_LEGS);
	if (item == nullptr) {
		return;
	}

	double_t chance = item->getTranscendenceChance();
	double_t randomChance = uniform_random(0, 10000) / 100.;
	if (getZoneType() != ZONE_PROTECTION && checkLastAggressiveActionWithin(2000) && ((OTSYS_TIME() / 1000) % 2) == 0 && chance > 0 && randomChance < chance) {
		int64_t duration = g_configManager().getNumber(TRANSCENDANCE_AVATAR_DURATION, __FUNCTION__);
		auto outfitCondition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_OUTFIT, duration, 0)->static_self_cast<ConditionOutfit>();
		Outfit_t outfit;
		outfit.lookType = getVocation()->getAvatarLookType();
		outfitCondition->setOutfit(outfit);
		addCondition(outfitCondition);
		wheel()->setOnThinkTimer(WheelOnThink_t::AVATAR_FORGE, OTSYS_TIME() + duration);
		g_game().addMagicEffect(getPosition(), CONST_ME_AVATAR_APPEAR);

		sendSkills();
		sendStats();
		sendBasicData();

		sendTextMessage(MESSAGE_ATTENTION, "Transcendance was triggered.");

		// Send player data after transcendance timer expire
		const auto &task = createPlayerTask(
			std::max<uint32_t>(SCHEDULER_MINTICKS, duration),
			[playerId = getID()] {
				auto player = g_game().getPlayerByID(playerId);
				if (player) {
					player->sendSkills();
					player->sendStats();
					player->sendBasicData();
				}
			},
			"Player::triggerTranscendance"
		);
		g_dispatcher().scheduleEvent(task);

		wheel()->sendGiftOfLifeCooldown();
		g_game().reloadCreature(getPlayer());
	}
}

/*******************************************************************************
 * Depot search system
 ******************************************************************************/
void Player::requestDepotItems() {
	ItemsTierCountList itemMap;
	uint16_t count = 0;
	std::shared_ptr<DepotLocker> depotLocker = getDepotLocker(getLastDepotId());
	if (!depotLocker) {
		return;
	}

	for (const std::shared_ptr<Item> &locker : depotLocker->getItemList()) {
		std::shared_ptr<Container> c = locker->getContainer();
		if (!c || c->empty()) {
			continue;
		}

		for (ContainerIterator it = c->iterator(); it.hasNext(); it.advance()) {
			auto itemMap_it = itemMap.find((*it)->getID());

			uint8_t itemTier = Item::items[(*it)->getID()].upgradeClassification > 0 ? (*it)->getTier() + 1 : 0;
			if (itemMap_it == itemMap.end()) {
				std::map<uint8_t, uint32_t> itemTierMap;
				itemTierMap[itemTier] = Item::countByType((*it), -1);
				itemMap[(*it)->getID()] = itemTierMap;
				count++;
			} else if (auto itemTier_it = itemMap[(*it)->getID()].find(itemTier); itemTier_it == itemMap[(*it)->getID()].end()) {
				itemMap[(*it)->getID()][itemTier] = Item::countByType((*it), -1);
				count++;
			} else {
				itemMap[(*it)->getID()][itemTier] += Item::countByType((*it), -1);
			}
		}
	}

	for (const auto &[itemId, itemCount] : getStashItems()) {
		auto itemMap_it = itemMap.find(itemId);
		// Stackable items not have upgrade classification
		if (Item::items[itemId].upgradeClassification > 0) {
			g_logger().error("{} - Player {} have wrong item with id {} on stash with upgrade classification", __FUNCTION__, getName(), itemId);
			continue;
		}

		if (itemMap_it == itemMap.end()) {
			std::map<uint8_t, uint32_t> itemTierMap;
			itemTierMap[0] = itemCount;
			itemMap[itemId] = itemTierMap;
			count++;
		} else if (auto itemTier_it = itemMap[itemId].find(0); itemTier_it == itemMap[itemId].end()) {
			itemMap[itemId][0] = itemCount;
			count++;
		} else {
			itemMap[itemId][0] += itemCount;
		}
	}

	setDepotSearchIsOpen(1, 0);
	sendDepotItems(itemMap, count);
}

void Player::requestDepotSearchItem(uint16_t itemId, uint8_t tier) {
	ItemVector depotItems;
	ItemVector inboxItems;
	uint32_t depotCount = 0;
	uint32_t inboxCount = 0;
	uint32_t stashCount = 0;

	if (const ItemType &iType = Item::items[itemId];
	    iType.stackable && iType.wareId > 0) {
		stashCount = getStashItemCount(itemId);
	}

	std::shared_ptr<DepotLocker> depotLocker = getDepotLocker(getLastDepotId());
	if (!depotLocker) {
		return;
	}

	for (const std::shared_ptr<Item> &locker : depotLocker->getItemList()) {
		std::shared_ptr<Container> c = locker->getContainer();
		if (!c || c->empty()) {
			continue;
		}

		for (ContainerIterator it = c->iterator(); it.hasNext(); it.advance()) {
			std::shared_ptr<Item> item = *it;
			if (!item || item->getID() != itemId || item->getTier() != tier) {
				continue;
			}

			if (c->isInbox()) {
				if (inboxItems.size() < 255) {
					inboxItems.push_back(item);
				}
				inboxCount += Item::countByType(item, -1);
			} else {
				if (depotItems.size() < 255) {
					depotItems.push_back(item);
				}
				depotCount += Item::countByType(item, -1);
			}
		}
	}

	setDepotSearchIsOpen(itemId, tier);
	sendDepotSearchResultDetail(itemId, tier, depotCount, depotItems, inboxCount, inboxItems, stashCount);
}

void Player::retrieveAllItemsFromDepotSearch(uint16_t itemId, uint8_t tier, bool isDepot) {
	std::shared_ptr<DepotLocker> depotLocker = getDepotLocker(getLastDepotId());
	if (!depotLocker) {
		return;
	}

	std::vector<std::shared_ptr<Item>> itemsVector;
	for (const std::shared_ptr<Item> &locker : depotLocker->getItemList()) {
		std::shared_ptr<Container> c = locker->getContainer();
		if (!c || c->empty() ||
		    // Retrieve from inbox.
		    (c->isInbox() && isDepot) ||
		    // Retrieve from depot.
		    (!c->isInbox() && !isDepot)) {
			continue;
		}

		for (ContainerIterator it = c->iterator(); it.hasNext(); it.advance()) {
			std::shared_ptr<Item> item = *it;
			if (!item) {
				continue;
			}

			if (item->getID() == itemId && item->getTier() == depotSearchOnItem.second) {
				itemsVector.push_back(item);
			}
		}
	}

	ReturnValue ret = RETURNVALUE_NOERROR;
	for (const std::shared_ptr<Item> &item : itemsVector) {
		// First lets try to retrieve the item to the stash retrieve container.
		if (g_game().tryRetrieveStashItems(static_self_cast<Player>(), item)) {
			continue;
		}

		// If the retrieve fails to move the item to the stash retrieve container, let's add the item anywhere.
		if (ret = g_game().internalMoveItem(item->getParent(), getPlayer(), INDEX_WHEREEVER, item, item->getItemCount(), nullptr); ret == RETURNVALUE_NOERROR) {
			continue;
		}

		sendCancelMessage(ret);
		return;
	}

	requestDepotSearchItem(itemId, tier);
}

void Player::openContainerFromDepotSearch(const Position &pos) {
	if (!isDepotSearchOpen()) {
		sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	std::shared_ptr<Item> item = getItemFromDepotSearch(depotSearchOnItem.first, pos);
	if (!item) {
		sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	std::shared_ptr<Container> container = item->getParent() ? item->getParent()->getContainer() : nullptr;
	if (!container) {
		sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	g_actions().useItem(static_self_cast<Player>(), pos, 0, container, false);
}

std::shared_ptr<Item> Player::getItemFromDepotSearch(uint16_t itemId, const Position &pos) {
	std::shared_ptr<DepotLocker> depotLocker = getDepotLocker(getLastDepotId());
	if (!depotLocker) {
		return nullptr;
	}

	uint8_t index = 0;
	for (const std::shared_ptr<Item> &locker : depotLocker->getItemList()) {
		std::shared_ptr<Container> c = locker->getContainer();
		if (!c || c->empty() || (c->isInbox() && pos.y != 0x21) || // From inbox.
		    (!c->isInbox() && pos.y != 0x20)) { // From depot.
			continue;
		}

		for (ContainerIterator it = c->iterator(); it.hasNext(); it.advance()) {
			std::shared_ptr<Item> item = *it;
			if (!item || item->getID() != itemId || item->getTier() != depotSearchOnItem.second) {
				continue;
			}

			if (pos.z == index) {
				return item;
			}
			index++;
		}
	}

	return nullptr;
}

std::pair<std::vector<std::shared_ptr<Item>>, std::map<uint16_t, std::map<uint8_t, uint32_t>>>
Player::requestLockerItems(std::shared_ptr<DepotLocker> depotLocker, bool sendToClient /*= false*/, uint8_t tier /*= 0*/) const {
	if (!depotLocker) {
		g_logger().error("{} - Depot locker is nullptr", __FUNCTION__);
		return {};
	}

	std::map<uint16_t, std::map<uint8_t, uint32_t>> lockerItems;
	std::vector<std::shared_ptr<Item>> itemVector;
	std::vector<std::shared_ptr<Container>> containers { depotLocker };

	for (size_t i = 0; i < containers.size(); ++i) {
		std::shared_ptr<Container> container = containers[i];

		for (const auto &item : container->getItemList()) {
			std::shared_ptr<Container> lockerContainers = item->getContainer();
			if (lockerContainers && !lockerContainers->empty()) {
				containers.push_back(lockerContainers);
				continue;
			}

			const ItemType &itemType = Item::items[item->getID()];
			if (item->isStoreItem() || itemType.wareId == 0) {
				continue;
			}

			if (lockerContainers && (!itemType.isContainer() || lockerContainers->capacity() != itemType.maxItems)) {
				continue;
			}

			if (!item->hasMarketAttributes() || (!sendToClient && item->getTier() != tier)) {
				continue;
			}

			lockerItems[itemType.wareId][item->getTier()] += Item::countByType(item, -1);
			itemVector.push_back(item);
		}
	}

	StashItemList stashToSend = getStashItems();
	for (const auto &[itemId, itemCount] : stashToSend) {
		const ItemType &itemType = Item::items[itemId];
		if (itemType.wareId != 0) {
			lockerItems[itemType.wareId][0] += itemCount;
		}
	}

	return { itemVector, lockerItems };
}

std::pair<std::vector<std::shared_ptr<Item>>, uint16_t> Player::getLockerItemsAndCountById(const std::shared_ptr<DepotLocker> &depotLocker, uint8_t tier, uint16_t itemId) {
	std::vector<std::shared_ptr<Item>> lockerItems;
	auto [itemVector, itemMap] = requestLockerItems(depotLocker, false, tier);
	uint16_t totalCount = 0;
	for (const auto &item : itemVector) {
		if (!item || item->getID() != itemId) {
			continue;
		}

		totalCount++;
		lockerItems.push_back(item);
	}

	return std::make_pair(lockerItems, totalCount);
}

bool Player::saySpell(
	SpeakClasses type,
	const std::string &text,
	bool ghostMode,
	Spectators* spectatorsPtr /* = nullptr*/,
	const Position* pos /* = nullptr*/
) {
	if (text.empty()) {
		g_logger().debug("{} - Spell text is empty for player {}", __FUNCTION__, getName());
		return false;
	}

	if (!pos) {
		pos = &getPosition();
	}

	Spectators spectators;

	if (!spectatorsPtr || spectatorsPtr->empty()) {
		// This somewhat complex construct ensures that the cached Spectators
		// is used if available and if it can be used, else a local vector is
		// used (hopefully the compiler will optimize away the construction of
		// the temporary when it's not used).
		if (type != TALKTYPE_YELL && type != TALKTYPE_MONSTER_YELL) {
			spectators.find<Creature>(*pos, false, MAP_MAX_CLIENT_VIEW_PORT_X, MAP_MAX_CLIENT_VIEW_PORT_X, MAP_MAX_CLIENT_VIEW_PORT_Y, MAP_MAX_CLIENT_VIEW_PORT_Y);
		} else {
			spectators.find<Creature>(*pos, true, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_X + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2, (MAP_MAX_CLIENT_VIEW_PORT_Y + 1) * 2);
		}
	} else {
		spectators = (*spectatorsPtr);
	}

	int32_t valueEmote = 0;
	// Send to client
	for (const std::shared_ptr<Creature> &spectator : spectators) {
		if (std::shared_ptr<Player> tmpPlayer = spectator->getPlayer()) {
			if (g_configManager().getBoolean(EMOTE_SPELLS, __FUNCTION__)) {
				valueEmote = tmpPlayer->getStorageValue(STORAGEVALUE_EMOTE);
			}
			if (!ghostMode || tmpPlayer->canSeeCreature(static_self_cast<Player>())) {
				if (valueEmote == 1) {
					tmpPlayer->sendCreatureSay(static_self_cast<Player>(), TALKTYPE_MONSTER_SAY, text, pos);
				} else {
					tmpPlayer->sendCreatureSay(static_self_cast<Player>(), TALKTYPE_SPELL_USE, text, pos);
				}
			}
		}
	}

	// Execute lua event method
	for (const std::shared_ptr<Creature> &spectator : spectators) {
		auto tmpPlayer = spectator->getPlayer();
		if (!tmpPlayer) {
			continue;
		}

		tmpPlayer->onCreatureSay(static_self_cast<Player>(), type, text);
		if (static_self_cast<Player>() != tmpPlayer) {
			g_events().eventCreatureOnHear(tmpPlayer, getPlayer(), text, type);
			g_callbacks().executeCallback(EventCallback_t::creatureOnHear, &EventCallback::creatureOnHear, tmpPlayer, getPlayer(), text, type);
		}
	}
	return true;
}

// Forge system
void Player::forgeFuseItems(ForgeAction_t actionType, uint16_t firstItemId, uint8_t tier, uint16_t secondItemId, bool success, bool reduceTierLoss, bool convergence, uint8_t bonus, uint8_t coreCount) {
	if (getFreeBackpackSlots() == 0) {
		sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
		return;
	}

	ForgeHistory history;
	history.actionType = actionType;
	history.tier = tier;
	history.success = success;
	history.tierLoss = reduceTierLoss;

	auto firstForgingItem = getForgeItemFromId(firstItemId, tier);
	if (!firstForgingItem) {
		g_logger().error("[Log 1] Player with name {} failed to fuse item with id {}", getName(), firstItemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	auto returnValue = g_game().internalRemoveItem(firstForgingItem, 1);
	if (returnValue != RETURNVALUE_NOERROR) {
		g_logger().error("[Log 1] Failed to remove forge item {} from player with name {}", firstItemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	auto secondForgingItem = getForgeItemFromId(secondItemId, tier);
	if (!secondForgingItem) {
		g_logger().error("[Log 2] Player with name {} failed to fuse item with id {}", getName(), secondItemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	if (returnValue = g_game().internalRemoveItem(secondForgingItem, 1);
	    returnValue != RETURNVALUE_NOERROR) {
		g_logger().error("[Log 2] Failed to remove forge item {} from player with name {}", secondItemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	auto exaltationChest = Item::CreateItem(ITEM_EXALTATION_CHEST, 1);
	if (!exaltationChest) {
		g_logger().error("Failed to create exaltation chest");
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	auto exaltationContainer = exaltationChest->getContainer();
	if (!exaltationContainer) {
		g_logger().error("Failed to create exaltation container");
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	std::shared_ptr<Item> firstForgedItem = Item::CreateItem(firstItemId, 1);
	if (!firstForgedItem) {
		g_logger().error("[Log 3] Player with name {} failed to fuse item with id {}", getName(), firstItemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	returnValue = g_game().internalAddItem(exaltationContainer, firstForgedItem, INDEX_WHEREEVER);
	if (returnValue != RETURNVALUE_NOERROR) {
		g_logger().error("[Log 1] Failed to add forge item {} from player with name {}", firstItemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	auto configKey = convergence ? FORGE_CONVERGENCE_FUSION_DUST_COST : FORGE_FUSION_DUST_COST;
	auto dustCost = static_cast<uint64_t>(g_configManager().getNumber(configKey, __FUNCTION__));
	if (convergence) {
		firstForgedItem->setTier(tier + 1);
		history.dustCost = dustCost;
		setForgeDusts(getForgeDusts() - dustCost);

		uint64_t cost = 0;
		for (const auto* itemClassification : g_game().getItemsClassifications()) {
			if (itemClassification->id != firstForgingItem->getClassification()) {
				continue;
			}

			for (const auto &[mapTier, mapPrice] : itemClassification->tiers) {
				if (mapTier == firstForgingItem->getTier()) {
					cost = mapPrice.convergenceFusionPrice;
					break;
				}
			}
			break;
		}
		if (!g_game().removeMoney(static_self_cast<Player>(), cost, 0, true)) {
			g_logger().error("[{}] Failed to remove {} gold from player with name {}", __FUNCTION__, cost, getName());
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}
		g_metrics().addCounter("balance_decrease", cost, { { "player", getName() }, { "context", "forge_convergence_fuse" } });
		history.cost = cost;
	} else {
		firstForgedItem->setTier(tier);
		std::shared_ptr<Item> secondForgedItem = Item::CreateItem(secondItemId, 1);
		if (!secondForgedItem) {
			g_logger().error("[Log 4] Player with name {} failed to fuse item with id {}", getName(), secondItemId);
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		secondForgedItem->setTier(tier);
		returnValue = g_game().internalAddItem(exaltationContainer, secondForgedItem, INDEX_WHEREEVER);
		if (returnValue != RETURNVALUE_NOERROR) {
			g_logger().error("[Log 2] Failed to add forge item {} from player with name {}", secondItemId, getName());
			sendCancelMessage(getReturnMessage(returnValue));
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		if (success) {
			firstForgedItem->setTier(tier + 1);

			if (bonus != 1) {
				history.dustCost = dustCost;
				setForgeDusts(getForgeDusts() - dustCost);
			}
			if (bonus != 2) {
				if (coreCount != 0 && !removeItemCountById(ITEM_FORGE_CORE, coreCount)) {
					g_logger().error("[{}][Log 1] Failed to remove item 'id :{} count: {}' from player {}", __FUNCTION__, fmt::underlying(ITEM_FORGE_CORE), coreCount, getName());
					sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
					return;
				}
				history.coresCost = coreCount;
			}
			if (bonus != 3) {
				uint64_t cost = 0;
				for (const auto* itemClassification : g_game().getItemsClassifications()) {
					if (itemClassification->id != firstForgedItem->getClassification()) {
						continue;
					}
					if (!itemClassification->tiers.contains(firstForgedItem->getTier())) {
						g_logger().error("[{}] Failed to find tier {} for item {} in classification {}", __FUNCTION__, firstForgedItem->getTier(), firstForgedItem->getClassification(), itemClassification->id);
						sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
						break;
					}
					cost = itemClassification->tiers.at(firstForgedItem->getTier()).regularPrice;
					break;
				}
				if (!g_game().removeMoney(static_self_cast<Player>(), cost, 0, true)) {
					g_logger().error("[{}] Failed to remove {} gold from player with name {}", __FUNCTION__, cost, getName());
					sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
					return;
				}
				g_metrics().addCounter("balance_decrease", cost, { { "player", getName() }, { "context", "forge_fuse" } });
				history.cost = cost;
			}

			if (bonus == 4) {
				if (tier > 0) {
					secondForgedItem->setTier(tier - 1);
				}
			} else if (bonus == 6) {
				secondForgedItem->setTier(tier + 1);
			} else if (bonus == 7 && tier + 2 <= firstForgedItem->getClassification()) {
				firstForgedItem->setTier(tier + 2);
			}

			if (bonus != 4 && bonus != 5 && bonus != 6 && bonus != 8) {
				returnValue = g_game().internalRemoveItem(secondForgedItem, 1);
				if (returnValue != RETURNVALUE_NOERROR) {
					g_logger().error("[Log 6] Failed to remove forge item {} from player with name {}", secondItemId, getName());
					sendCancelMessage(getReturnMessage(returnValue));
					sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
					return;
				}
			}
		} else {
			auto isTierLost = uniform_random(1, 100) <= (reduceTierLoss ? g_configManager().getNumber(FORGE_TIER_LOSS_REDUCTION, __FUNCTION__) : 100);
			if (isTierLost) {
				if (secondForgedItem->getTier() >= 1) {
					secondForgedItem->setTier(tier - 1);
				} else {
					returnValue = g_game().internalRemoveItem(secondForgedItem, 1);
					if (returnValue != RETURNVALUE_NOERROR) {
						g_logger().error("[Log 7] Failed to remove forge item {} from player with name {}", secondItemId, getName());
						sendCancelMessage(getReturnMessage(returnValue));
						sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
						return;
					}
				}
			}
			bonus = (isTierLost ? 0 : 8);
			history.coresCost = coreCount;

			if (getForgeDusts() < dustCost) {
				g_logger().error("[Log 7] Failed to remove fuse dusts from player with name {}", getName());
				sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
				return;
			} else {
				setForgeDusts(getForgeDusts() - dustCost);
			}

			if (coreCount != 0 && !removeItemCountById(ITEM_FORGE_CORE, coreCount)) {
				g_logger().error("[{}][Log 2] Failed to remove item 'id: {}, count: {}' from player {}", __FUNCTION__, fmt::underlying(ITEM_FORGE_CORE), coreCount, getName());
				sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
				return;
			}

			uint64_t cost = 0;
			for (const auto* itemClassification : g_game().getItemsClassifications()) {
				if (itemClassification->id != firstForgingItem->getClassification()) {
					continue;
				}
				if (!itemClassification->tiers.contains(firstForgingItem->getTier() + 1)) {
					g_logger().error("[{}] Failed to find tier {} for item {} in classification {}", __FUNCTION__, firstForgingItem->getTier() + 1, firstForgingItem->getClassification(), itemClassification->id);
					sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
					break;
				}
				cost = itemClassification->tiers.at(firstForgingItem->getTier() + 1).regularPrice;
				break;
			}
			if (!g_game().removeMoney(static_self_cast<Player>(), cost, 0, true)) {
				g_logger().error("[{}] Failed to remove {} gold from player with name {}", __FUNCTION__, cost, getName());
				sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
				return;
			}
			g_metrics().addCounter("balance_decrease", cost, { { "player", getName() }, { "context", "forge_fuse" } });

			history.cost = cost;
		}
	}

	returnValue = g_game().internalAddItem(static_self_cast<Player>(), exaltationContainer, INDEX_WHEREEVER);
	if (returnValue != RETURNVALUE_NOERROR) {
		g_logger().error("Failed to add exaltation chest to player with name {}", fmt::underlying(ITEM_EXALTATION_CHEST), getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	history.firstItemName = firstForgingItem->getName();
	history.secondItemName = secondForgingItem->getName();
	history.bonus = bonus;
	history.createdAt = getTimeNow();
	history.convergence = convergence;
	registerForgeHistoryDescription(history);

	sendForgeResult(actionType, firstItemId, tier, secondItemId, tier + 1, success, bonus, coreCount, convergence);
}

void Player::forgeTransferItemTier(ForgeAction_t actionType, uint16_t donorItemId, uint8_t tier, uint16_t receiveItemId, bool convergence) {
	if (getFreeBackpackSlots() == 0) {
		sendCancelMessage(RETURNVALUE_NOTENOUGHROOM);
		return;
	}

	ForgeHistory history;
	history.actionType = actionType;
	history.tier = tier;
	history.success = true;

	auto donorItem = getForgeItemFromId(donorItemId, tier);
	if (!donorItem) {
		g_logger().error("[Log 1] Player with name {} failed to transfer item with id {}", getName(), donorItemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	auto returnValue = g_game().internalRemoveItem(donorItem, 1);
	if (returnValue != RETURNVALUE_NOERROR) {
		g_logger().error("[Log 1] Failed to remove transfer item {} from player with name {}", donorItemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	auto receiveItem = getForgeItemFromId(receiveItemId, 0);
	if (!receiveItem) {
		g_logger().error("[Log 2] Player with name {} failed to transfer item with id {}", getName(), receiveItemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	if (returnValue = g_game().internalRemoveItem(receiveItem, 1);
	    returnValue != RETURNVALUE_NOERROR) {
		g_logger().error("[Log 2] Failed to remove transfer item {} from player with name {}", receiveItemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	auto exaltationChest = Item::CreateItem(ITEM_EXALTATION_CHEST, 1);
	if (!exaltationChest) {
		g_logger().error("Exaltation chest is nullptr");
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	auto exaltationContainer = exaltationChest->getContainer();
	if (!exaltationContainer) {
		g_logger().error("Exaltation container is nullptr");
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	std::shared_ptr<Item> newReceiveItem = Item::CreateItem(receiveItemId, 1);
	if (!newReceiveItem) {
		g_logger().error("[Log 6] Player with name {} failed to fuse item with id {}", getName(), receiveItemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	auto configKey = convergence ? FORGE_CONVERGENCE_TRANSFER_DUST_COST : FORGE_TRANSFER_DUST_COST;
	if (getForgeDusts() < g_configManager().getNumber(configKey, __FUNCTION__)) {
		g_logger().error("[Log 8] Failed to remove transfer dusts from player with name {}", getName());
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	} else {
		setForgeDusts(getForgeDusts() - g_configManager().getNumber(configKey, __FUNCTION__));
	}

	if (convergence) {
		newReceiveItem->setTier(tier);
	} else {
		newReceiveItem->setTier(tier - 1);
	}
	returnValue = g_game().internalAddItem(exaltationContainer, newReceiveItem, INDEX_WHEREEVER);
	if (returnValue != RETURNVALUE_NOERROR) {
		g_logger().error("[Log 7] Failed to add forge item {} from player with name {}", receiveItemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	uint8_t coresAmount = 0;
	uint64_t cost = 0;
	for (const auto &itemClassification : g_game().getItemsClassifications()) {
		if (itemClassification->id != donorItem->getClassification()) {
			continue;
		}
		if (!itemClassification->tiers.contains(donorItem->getTier())) {
			g_logger().error("[{}] Failed to find tier {} for item {} in classification {}", __FUNCTION__, donorItem->getTier(), donorItem->getClassification(), itemClassification->id);
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			break;
		}
		auto tierPriecs = itemClassification->tiers.at(donorItem->getTier());
		cost = convergence ? tierPriecs.convergenceTransferPrice : tierPriecs.regularPrice;
		coresAmount = tierPriecs.corePrice;
		break;
	}

	if (!removeItemCountById(ITEM_FORGE_CORE, coresAmount)) {
		g_logger().error("[{}] Failed to remove item 'id: {}, count: {}' from player {}", __FUNCTION__, fmt::underlying(ITEM_FORGE_CORE), 1, getName());
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	if (!g_game().removeMoney(static_self_cast<Player>(), cost, 0, true)) {
		g_logger().error("[{}] Failed to remove {} gold from player with name {}", __FUNCTION__, cost, getName());
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	history.cost = cost;
	g_metrics().addCounter("balance_decrease", cost, { { "player", getName() }, { "context", "forge_transfer" } });

	returnValue = g_game().internalAddItem(static_self_cast<Player>(), exaltationContainer, INDEX_WHEREEVER);
	if (returnValue != RETURNVALUE_NOERROR) {
		g_logger().error("[Log 10] Failed to add forge item {} from player with name {}", fmt::underlying(ITEM_EXALTATION_CHEST), getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	history.firstItemName = Item::items[donorItemId].name;
	history.secondItemName = newReceiveItem->getName();
	history.createdAt = getTimeNow();
	history.convergence = convergence;
	registerForgeHistoryDescription(history);

	sendForgeResult(actionType, donorItemId, tier, receiveItemId, convergence ? tier : tier - 1, true, 0, 0, convergence);
}

void Player::forgeResourceConversion(ForgeAction_t actionType) {
	ForgeHistory history;
	history.actionType = actionType;
	history.success = true;

	ReturnValue returnValue = RETURNVALUE_NOERROR;
	if (actionType == ForgeAction_t::DUSTTOSLIVERS) {
		auto dusts = getForgeDusts();
		auto cost = static_cast<uint16_t>(g_configManager().getNumber(FORGE_COST_ONE_SLIVER, __FUNCTION__) * g_configManager().getNumber(FORGE_SLIVER_AMOUNT, __FUNCTION__));
		if (cost > dusts) {
			g_logger().error("[{}] Not enough dust", __FUNCTION__);
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		auto itemCount = static_cast<uint16_t>(g_configManager().getNumber(FORGE_SLIVER_AMOUNT, __FUNCTION__));
		std::shared_ptr<Item> item = Item::CreateItem(ITEM_FORGE_SLIVER, itemCount);
		returnValue = g_game().internalPlayerAddItem(static_self_cast<Player>(), item);
		if (returnValue != RETURNVALUE_NOERROR) {
			g_logger().error("Failed to add {} slivers to player with name {}", itemCount, getName());
			sendCancelMessage(getReturnMessage(returnValue));
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}
		history.cost = cost;
		history.gained = 3;
		setForgeDusts(dusts - cost);
	} else if (actionType == ForgeAction_t::SLIVERSTOCORES) {
		auto [sliverCount, coreCount] = getForgeSliversAndCores();
		auto cost = static_cast<uint16_t>(g_configManager().getNumber(FORGE_CORE_COST, __FUNCTION__));
		if (cost > sliverCount) {
			g_logger().error("[{}] Not enough sliver", __FUNCTION__);
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		if (!removeItemCountById(ITEM_FORGE_SLIVER, cost)) {
			g_logger().error("[{}] Failed to remove item 'id: {}, count {}' from player {}", __FUNCTION__, fmt::underlying(ITEM_FORGE_SLIVER), cost, getName());
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		if (std::shared_ptr<Item> item = Item::CreateItem(ITEM_FORGE_CORE, 1);
		    item) {
			returnValue = g_game().internalPlayerAddItem(static_self_cast<Player>(), item);
		}
		if (returnValue != RETURNVALUE_NOERROR) {
			g_logger().error("Failed to add one core to player with name {}", getName());
			sendCancelMessage(getReturnMessage(returnValue));
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		history.cost = cost;
		history.gained = 1;
	} else {
		auto dustLevel = getForgeDustLevel();
		if (dustLevel >= g_configManager().getNumber(FORGE_MAX_DUST, __FUNCTION__)) {
			g_logger().error("[{}] Maximum level reached", __FUNCTION__);
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		auto upgradeCost = dustLevel - 75;
		if (auto dusts = getForgeDusts();
		    upgradeCost > dusts) {
			g_logger().error("[{}] Not enough dust", __FUNCTION__);
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		history.cost = upgradeCost;
		history.gained = dustLevel;
		removeForgeDusts(upgradeCost);
		addForgeDustLevel(1);
	}

	history.createdAt = getTimeNow();
	registerForgeHistoryDescription(history);
	sendForgingData();
}

void Player::forgeHistory(uint8_t page) const {
	sendForgeHistory(page);
}

void Player::registerForgeHistoryDescription(ForgeHistory history) {
	std::string successfulString = history.success ? "Successful" : "Unsuccessful";
	std::string historyTierString = history.tier > 0 ? "tier - 1" : "consumed";
	std::string price = history.bonus != 3 ? formatPrice(std::to_string(history.cost), true) : "0";
	std::stringstream detailsResponse;
	auto itemId = Item::items.getItemIdByName(history.firstItemName);
	const ItemType &itemType = Item::items[itemId];
	if (history.actionType == ForgeAction_t::FUSION) {
		if (history.success) {
			detailsResponse << fmt::format(
				"{:s}{:s} <br><br>"
				"Fusion partners:"
				"<ul> "
				"<li>"
				"First item: {:s} {:s}, tier {:s}"
				"</li>"
				"<li>"
				"Second item: {:s} {:s}, tier {:s}"
				"</li>"
				"</ul>"
				"<br>"
				"Result:"
				"<ul> "
				"<li>"
				"First item: tier + 1"
				"</li>"
				"<li>"
				"Second item: {:s}"
				"</li>"
				"</ul>"
				"<br>"
				"Invested:"
				"<ul>"
				"<li>"
				"{:d} cores"
				"</li>"
				"<li>"
				"{:d} dust"
				"</li>"
				"<li>"
				"{:s} gold"
				"</li>"
				"</ul>",
				successfulString,
				history.convergence ? " (convergence)" : "",
				itemType.article, itemType.name, std::to_string(history.tier),
				itemType.article, itemType.name, std::to_string(history.tier),
				history.bonus == 8 ? "unchanged" : "consumed",
				history.coresCost, history.dustCost, price
			);
		} else {
			detailsResponse << fmt::format(
				"{:s}{:s} <br><br>"
				"Fusion partners:"
				"<ul> "
				"<li>"
				"First item: {:s} {:s}, tier {:s}"
				"</li>"
				"<li>"
				"Second item: {:s} {:s}, tier {:s}"
				"</li>"
				"</ul>"
				"<br>"
				"Result:"
				"<ul> "
				"<li>"
				"First item: unchanged"
				"</li>"
				"<li>"
				"Second item: {:s}"
				"</li>"
				"</ul>"
				"<br>"
				"Invested:"
				"<ul>"
				"<li>"
				"{:d} cores"
				"</li>"
				"<li>"
				"100 dust"
				"</li>"
				"<li>"
				"{:s} gold"
				"</li>"
				"</ul>",
				successfulString,
				history.convergence ? " (convergence)" : "",
				itemType.article, itemType.name, std::to_string(history.tier),
				itemType.article, itemType.name, std::to_string(history.tier),
				history.bonus == 8 ? "unchanged" : historyTierString,
				history.coresCost, price
			);
		}
	} else if (history.actionType == ForgeAction_t::TRANSFER) {
		detailsResponse << fmt::format(
			"{:s}{:s} <br><br>"
			"Transfer partners:"
			"<ul> "
			"<li>"
			"First item: {:s} {:s}, tier {:s}"
			"</li>"
			"<li>"
			"Second item: {:s} {:s}, tier {:s}"
			"</li>"
			"</ul>"
			"<br>"
			"Result:"
			"<ul> "
			"<li>"
			"First item: {:s} {:s}, tier {:s}"
			"</li>"
			"<li>"
			"Second item: {:s} {:s}, {:s}"
			"</li>"
			"</ul>"
			"<br>"
			"Invested:"
			"<ul>"
			"<li>"
			"1 cores"
			"</li>"
			"<li>"
			"100 dust"
			"</li>"
			"<li>"
			"{:s} gold"
			"</li>"
			"</ul>",
			successfulString,
			history.convergence ? " (convergence)" : "",
			itemType.article, itemType.name, std::to_string(history.tier),
			itemType.article, itemType.name, std::to_string(history.tier),
			itemType.article, itemType.name, std::to_string(history.tier),
			itemType.article, itemType.name, std::to_string(history.tier),
			price
		);
	} else if (history.actionType == ForgeAction_t::DUSTTOSLIVERS) {
		detailsResponse << fmt::format("Converted {:d} dust to {:d} slivers.", history.cost, history.gained);
	} else if (history.actionType == ForgeAction_t::SLIVERSTOCORES) {
		history.actionType = ForgeAction_t::DUSTTOSLIVERS;
		detailsResponse << fmt::format("Converted {:d} slivers to {:d} exalted core.", history.cost, history.gained);
	} else if (history.actionType == ForgeAction_t::INCREASELIMIT) {
		history.actionType = ForgeAction_t::DUSTTOSLIVERS;
		detailsResponse << fmt::format("Spent {:d} dust to increase the dust limit to {:d}.", history.cost, history.gained + 1);
	} else {
		detailsResponse << "(unknown)";
	}

	history.description = detailsResponse.str();

	setForgeHistory(history);
}

void Player::closeAllExternalContainers() {
	if (openContainers.empty()) {
		return;
	}

	std::vector<std::shared_ptr<Container>> containerToClose;
	for (const auto &it : openContainers) {
		std::shared_ptr<Container> container = it.second.container;
		if (!container) {
			continue;
		}

		if (container->getHoldingPlayer() != getPlayer()) {
			containerToClose.push_back(container);
		}
	}

	for (const std::shared_ptr<Container> &container : containerToClose) {
		autoCloseContainers(container);
	}
}

SoundEffect_t Player::getHitSoundEffect() const {
	// Distance sound effects
	std::shared_ptr<Item> tool = getWeapon();
	if (tool == nullptr) {
		return SoundEffect_t::SILENCE;
	}

	switch (const auto &it = Item::items[tool->getID()]; it.weaponType) {
		case WEAPON_AMMO: {
			if (it.ammoType == AMMO_BOLT) {
				return SoundEffect_t::DIST_ATK_CROSSBOW_SHOT;
			} else if (it.ammoType == AMMO_ARROW) {
				if (it.shootType == CONST_ANI_BURSTARROW) {
					return SoundEffect_t::BURST_ARROW_EFFECT;
				} else if (it.shootType == CONST_ANI_DIAMONDARROW) {
					return SoundEffect_t::DIAMOND_ARROW_EFFECT;
				}
			} else {
				return SoundEffect_t::DIST_ATK_THROW_SHOT;
			}
		}
		case WEAPON_DISTANCE: {
			if (tool->getAmmoType() == AMMO_BOLT) {
				return SoundEffect_t::DIST_ATK_CROSSBOW_SHOT;
			} else if (tool->getAmmoType() == AMMO_ARROW) {
				return SoundEffect_t::DIST_ATK_BOW_SHOT;
			} else {
				return SoundEffect_t::DIST_ATK_THROW_SHOT;
			}
		}
		case WEAPON_WAND: {
			// Separate between wand and rod here
			// return SoundEffect_t::DIST_ATK_ROD_SHOT;
			return SoundEffect_t::DIST_ATK_WAND_SHOT;
		}
		default: {
			return SoundEffect_t::SILENCE;
		}
	} // switch

	return SoundEffect_t::SILENCE;
}

SoundEffect_t Player::getAttackSoundEffect() const {
	std::shared_ptr<Item> tool = getWeapon();
	if (tool == nullptr) {
		return SoundEffect_t::HUMAN_CLOSE_ATK_FIST;
	}

	const ItemType &it = Item::items[tool->getID()];
	if (it.weaponType == WEAPON_NONE || it.weaponType == WEAPON_SHIELD) {
		return SoundEffect_t::HUMAN_CLOSE_ATK_FIST;
	}

	switch (it.weaponType) {
		case WEAPON_AXE: {
			return SoundEffect_t::MELEE_ATK_AXE;
		}
		case WEAPON_SWORD: {
			return SoundEffect_t::MELEE_ATK_SWORD;
		}
		case WEAPON_CLUB: {
			return SoundEffect_t::MELEE_ATK_CLUB;
		}
		case WEAPON_AMMO:
		case WEAPON_DISTANCE: {
			if (tool->getAmmoType() == AMMO_BOLT) {
				return SoundEffect_t::DIST_ATK_CROSSBOW;
			} else if (tool->getAmmoType() == AMMO_ARROW) {
				return SoundEffect_t::DIST_ATK_BOW;
			} else {
				return SoundEffect_t::DIST_ATK_THROW;
			}

			break;
		}
		case WEAPON_WAND: {
			return SoundEffect_t::MAGICAL_RANGE_ATK;
		}
		default: {
			return SoundEffect_t::SILENCE;
		}
	}

	return SoundEffect_t::SILENCE;
}

bool Player::canAutoWalk(const Position &toPosition, const std::function<void()> &function, uint32_t delay /* = 500*/) {
	if (!Position::areInRange<1, 1>(getPosition(), toPosition)) {
		// Check if can walk to the toPosition and send event to use function
		stdext::arraylist<Direction> listDir(128);
		if (getPathTo(toPosition, listDir, 0, 1, true, true)) {
			g_dispatcher().addEvent([creatureId = getID(), dirs = listDir.data()] { g_game().playerAutoWalk(creatureId, dirs); }, __FUNCTION__);

			std::shared_ptr<Task> task = createPlayerTask(delay, function, __FUNCTION__);
			setNextWalkActionTask(task);
			return true;
		} else {
			sendCancelMessage(RETURNVALUE_THEREISNOWAY);
		}
	}
	return false;
}

// Account
bool Player::setAccount(uint32_t accountId) {
	if (account) {
		g_logger().warn("Account was already set!");
		return true;
	}

	account = std::make_shared<Account>(accountId);
	return AccountErrors_t::Ok == enumFromValue<AccountErrors_t>(account->load());
}

uint8_t Player::getAccountType() const {
	return static_cast<uint8_t>(account ? account->getAccountType() : static_cast<uint8_t>(AccountType::ACCOUNT_TYPE_NORMAL));
}

uint32_t Player::getAccountId() const {
	return account ? account->getID() : 0;
}

std::shared_ptr<Account> Player::getAccount() const {
	return account;
}

/*******************************************************************************
 * Hazard system
 ******************************************************************************/

void Player::setHazardSystemPoints(int32_t count) {
	if (!g_configManager().getBoolean(TOGGLE_HAZARDSYSTEM, __FUNCTION__)) {
		return;
	}
	addStorageValue(STORAGEVALUE_HAZARDCOUNT, std::max<int32_t>(0, std::min<int32_t>(0xFFFF, count)), true);
	reloadHazardSystemPointsCounter = true;
	if (count > 0) {
		setIcon("hazard", CreatureIcon(CreatureIconQuests_t::Hazard, count));
	} else {
		removeIcon("hazard");
	}
}

void Player::parseAttackRecvHazardSystem(CombatDamage &damage, std::shared_ptr<Monster> monster) {
	if (!monster || !monster->getHazard()) {
		return;
	}

	if (!g_configManager().getBoolean(TOGGLE_HAZARDSYSTEM, __FUNCTION__)) {
		return;
	}

	if (damage.primary.type == COMBAT_HEALING) {
		return;
	}

	auto points = getHazardSystemPoints();
	if (m_party) {
		for (const auto &partyMember : m_party->getMembers()) {
			if (partyMember && partyMember->getHazardSystemPoints() < points) {
				points = partyMember->getHazardSystemPoints();
			}
		}

		if (m_party->getLeader() && m_party->getLeader()->getHazardSystemPoints() < points) {
			points = m_party->getLeader()->getHazardSystemPoints();
		}
	}

	if (points == 0) {
		return;
	}

	uint16_t stage = 0;
	auto chance = static_cast<uint16_t>(normal_random(1, 10000));
	auto critChance = g_configManager().getNumber(HAZARD_CRITICAL_CHANCE, __FUNCTION__);
	// Critical chance
	if (monster->getHazardSystemCrit() && (lastHazardSystemCriticalHit + g_configManager().getNumber(HAZARD_CRITICAL_INTERVAL, __FUNCTION__)) <= OTSYS_TIME() && chance <= critChance && !damage.critical) {
		damage.critical = true;
		damage.extension = true;
		damage.exString = "(Hazard)";

		stage = (points - 1) * static_cast<uint16_t>(g_configManager().getNumber(HAZARD_CRITICAL_MULTIPLIER, __FUNCTION__));
		damage.primary.value += static_cast<int32_t>(std::ceil((static_cast<double>(damage.primary.value) * (5000 + stage)) / 10000));
		damage.secondary.value += static_cast<int32_t>(std::ceil((static_cast<double>(damage.secondary.value) * (5000 + stage)) / 10000));
		lastHazardSystemCriticalHit = OTSYS_TIME();
	}

	// To prevent from punish the player twice with critical + damage boost, just uncomment code from the if
	if (monster->getHazardSystemDamageBoost() /* && !damage.critical*/) {
		stage = points * static_cast<uint16_t>(g_configManager().getNumber(HAZARD_DAMAGE_MULTIPLIER, __FUNCTION__));
		if (stage != 0) {
			damage.extension = true;
			damage.exString = "(Hazard)";
			damage.primary.value += static_cast<int32_t>(std::ceil((static_cast<double>(damage.primary.value) * stage) / 10000));
			if (damage.secondary.value != 0) {
				damage.secondary.value += static_cast<int32_t>(std::ceil((static_cast<double>(damage.secondary.value) * stage) / 10000));
			}
		}
	}
}

void Player::parseAttackDealtHazardSystem(CombatDamage &damage, std::shared_ptr<Monster> monster) {
	if (!g_configManager().getBoolean(TOGGLE_HAZARDSYSTEM, __FUNCTION__)) {
		return;
	}

	if (!monster || !monster->getHazard()) {
		return;
	}

	if (damage.primary.type == COMBAT_HEALING) {
		return;
	}

	auto points = getHazardSystemPoints();
	if (m_party) {
		for (const auto &partyMember : m_party->getMembers()) {
			if (partyMember && partyMember->getHazardSystemPoints() < points) {
				points = partyMember->getHazardSystemPoints();
			}
		}

		if (m_party->getLeader() && m_party->getLeader()->getHazardSystemPoints() < points) {
			points = m_party->getLeader()->getHazardSystemPoints();
		}
	}

	if (points == 0) {
		return;
	}

	// Dodge chance
	uint16_t stage;
	if (monster->getHazardSystemDodge()) {
		stage = points * g_configManager().getNumber(HAZARD_DODGE_MULTIPLIER, __FUNCTION__);
		auto chance = static_cast<uint16_t>(normal_random(1, 10000));
		if (chance <= stage) {
			damage.primary.value = 0;
			damage.secondary.value = 0;
			return;
		}
	}
	if (monster->getHazardSystemDefenseBoost()) {
		stage = points * static_cast<uint16_t>(g_configManager().getNumber(HAZARD_DEFENSE_MULTIPLIER, __FUNCTION__));
		if (stage != 0) {
			damage.exString = fmt::format("(hazard -{}%)", stage / 100.);
			damage.primary.value -= static_cast<int32_t>(std::ceil((static_cast<double>(damage.primary.value) * stage) / 10000));
			if (damage.secondary.value != 0) {
				damage.secondary.value -= static_cast<int32_t>(std::ceil((static_cast<double>(damage.secondary.value) * stage) / 10000));
			}
			return;
		}
	}
}

/*******************************************************************************
 * Interfaces
 ******************************************************************************/

// Wheel interface
std::unique_ptr<PlayerWheel> &Player::wheel() {
	return m_wheelPlayer;
}

const std::unique_ptr<PlayerWheel> &Player::wheel() const {
	return m_wheelPlayer;
}

// Achievement interface
std::unique_ptr<PlayerAchievement> &Player::achiev() {
	return m_playerAchievement;
}

const std::unique_ptr<PlayerAchievement> &Player::achiev() const {
	return m_playerAchievement;
}

// Badge interface
std::unique_ptr<PlayerBadge> &Player::badge() {
	return m_playerBadge;
}

const std::unique_ptr<PlayerBadge> &Player::badge() const {
	return m_playerBadge;
}

// Title interface
std::unique_ptr<PlayerTitle> &Player::title() {
	return m_playerTitle;
}

const std::unique_ptr<PlayerTitle> &Player::title() const {
	return m_playerTitle;
}

// VIP interface
std::unique_ptr<PlayerVIP> &Player::vip() {
	return m_playerVIP;
}

const std::unique_ptr<PlayerVIP> &Player::vip() const {
	return m_playerVIP;
}

// Cyclopedia
std::unique_ptr<PlayerCyclopedia> &Player::cyclopedia() {
	return m_playerCyclopedia;
}

const std::unique_ptr<PlayerCyclopedia> &Player::cyclopedia() const {
	return m_playerCyclopedia;
}

void Player::sendLootMessage(const std::string &message) const {
	auto party = getParty();
	if (!party) {
		sendTextMessage(MESSAGE_LOOT, message);
		return;
	}

	if (auto partyLeader = party->getLeader()) {
		partyLeader->sendTextMessage(MESSAGE_LOOT, message);
	}
	for (const auto &partyMember : party->getMembers()) {
		if (partyMember) {
			partyMember->sendTextMessage(MESSAGE_LOOT, message);
		}
	}
}

std::shared_ptr<Container> Player::getLootPouch() {
	// Allow players with CM access or higher have the loot pouch anywhere
	auto parentItem = getParent() ? getParent()->getItem() : nullptr;
	if (isPlayerGroup() && parentItem && parentItem->getID() != ITEM_STORE_INBOX) {
		return nullptr;
	}

	auto inventoryItems = getInventoryItemsFromId(ITEM_GOLD_POUCH);
	if (inventoryItems.empty()) {
		return nullptr;
	}
	auto containerItem = inventoryItems.front();
	if (!containerItem) {
		return nullptr;
	}
	auto container = containerItem->getContainer();
	if (!container) {
		return nullptr;
	}

	return container;
}

std::shared_ptr<Container> Player::getStoreInbox() const {
	auto thing = getThing(CONST_SLOT_STORE_INBOX);
	if (!thing) {
		return nullptr;
	}

	auto storeInbox = thing->getContainer();
	return storeInbox ? storeInbox : nullptr;
}

bool Player::hasPermittedConditionInPZ() const {
	static const std::unordered_set<ConditionType_t> allowedConditions = {
		CONDITION_ENERGY,
		CONDITION_FIRE,
		CONDITION_POISON,
		CONDITION_BLEEDING,
		CONDITION_CURSED,
		CONDITION_DAZZLED
	};

	bool hasPermittedCondition = false;
	for (auto condition : allowedConditions) {
		if (getCondition(condition)) {
			hasPermittedCondition = true;
			break;
		}
	}

	return hasPermittedCondition;
}

uint16_t Player::getDodgeChance() const {
	uint16_t chance = 0;
	if (auto playerArmor = getInventoryItem(CONST_SLOT_ARMOR);
	    playerArmor != nullptr && playerArmor->getTier()) {
		chance += static_cast<uint16_t>(playerArmor->getDodgeChance() * 100);
	}

	chance += m_wheelPlayer->getStat(WheelStat_t::DODGE);

	return chance;
}

void Player::checkAndShowBlessingMessage() {
	auto adventurerBlessingLevel = g_configManager().getNumber(ADVENTURERSBLESSING_LEVEL, __FUNCTION__);
	auto willNotLoseBless = getLevel() < adventurerBlessingLevel && getVocationId() > VOCATION_NONE;
	std::string bless = getBlessingsName();
	std::ostringstream blessOutput;

	if (willNotLoseBless) {
		auto addedBless = false;
		for (uint8_t i = 2; i <= 6; i++) {
			if (!hasBlessing(i)) {
				addBlessing(i, 1);
				addedBless = true;
			}
		}
		sendBlessStatus();
		if (addedBless) {
			blessOutput << fmt::format("You have received adventurer's blessings for being level lower than {}!\nYou are still blessed with {}", adventurerBlessingLevel, bless);
		}
	} else {
		bless.empty() ? blessOutput << "You lost all your blessings." : blessOutput << "You are still blessed with " << bless;
	}

	if (!blessOutput.str().empty()) {
		sendTextMessage(MESSAGE_EVENT_ADVANCE, blessOutput.str());
	}
}

bool Player::canSpeakWithHireling(uint8_t speechbubble) {
	const auto &playerTile = getTile();
	const auto &house = playerTile ? playerTile->getHouse() : nullptr;
	if (speechbubble == SPEECHBUBBLE_HIRELING && (!house || house->getHouseAccessLevel(static_self_cast<Player>()) == HOUSE_NOT_INVITED)) {
		return false;
	}

	return true;
}

uint16_t Player::getPlayerVocationEnum() const {
	int cipTibiaId = getVocation()->getClientId();
	if (cipTibiaId == 1 || cipTibiaId == 11) {
		return Vocation_t::VOCATION_KNIGHT_CIP; // Knight
	} else if (cipTibiaId == 2 || cipTibiaId == 12) {
		return Vocation_t::VOCATION_PALADIN_CIP; // Paladin
	} else if (cipTibiaId == 3 || cipTibiaId == 13) {
		return Vocation_t::VOCATION_SORCERER_CIP; // Sorcerer
	} else if (cipTibiaId == 4 || cipTibiaId == 14) {
		return Vocation_t::VOCATION_DRUID_CIP; // Druid
	}

	return Vocation_t::VOCATION_NONE;
}
