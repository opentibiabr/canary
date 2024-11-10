/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/player.hpp"

#include "account/account.hpp"
#include "config/configmanager.hpp"
#include "core.hpp"
#include "creatures/appearance/mounts/mounts.hpp"
#include "creatures/combat/combat.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/interactions/chat.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/npcs/npc.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "creatures/players/wheel/wheel_gems.hpp"
#include "creatures/players/achievement/player_achievement.hpp"
#include "creatures/players/cyclopedia/player_badge.hpp"
#include "creatures/players/cyclopedia/player_cyclopedia.hpp"
#include "creatures/players/cyclopedia/player_title.hpp"
#include "creatures/players/grouping/party.hpp"
#include "creatures/players/imbuements/imbuements.hpp"
#include "creatures/players/storages/storages.hpp"
#include "creatures/players/vip/player_vip.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "enums/account_errors.hpp"
#include "enums/account_group_type.hpp"
#include "enums/account_type.hpp"
#include "enums/object_category.hpp"
#include "enums/player_blessings.hpp"
#include "enums/player_icons.hpp"
#include "game/game.hpp"
#include "game/modal_window/modal_window.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/scheduling/save_manager.hpp"
#include "game/scheduling/task.hpp"
#include "grouping/familiars.hpp"
#include "grouping/guild.hpp"
#include "io/iobestiary.hpp"
#include "io/iologindata.hpp"
#include "io/ioprey.hpp"
#include "items/bed.hpp"
#include "items/containers/depot/depotchest.hpp"
#include "items/containers/depot/depotlocker.hpp"
#include "items/containers/rewards/reward.hpp"
#include "items/containers/rewards/rewardchest.hpp"
#include "items/items_classification.hpp"
#include "items/weapons/weapons.hpp"
#include "lib/metrics/metrics.hpp"
#include "lua/callbacks/event_callback.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "lua/creature/actions.hpp"
#include "lua/creature/creatureevent.hpp"
#include "lua/creature/events.hpp"
#include "lua/creature/movement.hpp"
#include "map/spectators.hpp"

MuteCountMap Player::muteCountMap;

Player::Player(std::shared_ptr<ProtocolGame> p) :
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
	for (const auto &item : inventory) {
		if (item) {
			item->resetParent();
			item->stopDecaying();
		}
	}

	for (const auto &[depotId, depotLocker] : depotLockerMap) {
		if (depotId == 0) {
			continue;
		}

		depotLocker->removeInbox(inbox);
	}

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

uint16_t Player::getVocationId() const {
	return vocation->getId();
}

bool Player::isPushable() {
	if (hasFlag(PlayerFlags_t::CannotBePushed)) {
		return false;
	}
	return Creature::isPushable();
}

std::shared_ptr<Task> Player::createPlayerTask(uint32_t delay, std::function<void(void)> f, const std::string &context) {
	return std::make_shared<Task>(std::move(f), context, delay);
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
	const auto playerTitle = title()->getCurrentTitle() == 0 ? "" : (", " + title()->getCurrentTitleName());

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

		const size_t memberCount = m_party->getMemberCount() + 1;
		if (memberCount == 1) {
			s << "1 member and ";
		} else {
			s << memberCount << " members and ";
		}

		const size_t invitationCount = m_party->getInvitationCount();
		if (invitationCount == 1) {
			s << "1 pending invitation.";
		} else {
			s << invitationCount << " pending invitations.";
		}
	}

	if (guild && guildRank) {
		const size_t memberCount = guild->getMemberCount();
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

bool Player::isItemAbilityEnabled(Slots_t slot) const {
	return inventoryAbilities[slot];
}

void Player::setItemAbility(Slots_t slot, bool enabled) {
	inventoryAbilities[slot] = enabled;
}

void Player::setVarSkill(skills_t skill, int32_t modifier) {
	varSkills[skill] += modifier;
}

bool Player::isSuppress(ConditionType_t conditionType, bool attackerPlayer) const {
	auto minDelay = g_configManager().getNumber(MIN_DELAY_BETWEEN_CONDITIONS);
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
	const auto &item = inventory[slot];
	if (!item) {
		return nullptr;
	}

	const WeaponType_t &weaponType = item->getWeaponType();
	if (weaponType == WEAPON_NONE || weaponType == WEAPON_SHIELD || weaponType == WEAPON_AMMO) {
		return nullptr;
	}

	if (!ignoreAmmo && (weaponType == WEAPON_DISTANCE || weaponType == WEAPON_MISSILE)) {
		const ItemType &it = Item::items[item->getID()];
		if (it.ammoType != AMMO_NONE) {
			return getQuiverAmmoOfType(it);
		}
	}

	return item;
}

bool Player::hasQuiverEquipped() const {
	const auto &quiver = inventory[CONST_SLOT_RIGHT];
	return quiver && quiver->isQuiver() && quiver->getContainer();
}

bool Player::hasWeaponDistanceEquipped() const {
	const auto &item = inventory[CONST_SLOT_LEFT];
	return item && item->getWeaponType() == WEAPON_DISTANCE;
}

std::shared_ptr<Item> Player::getQuiverAmmoOfType(const ItemType &it) const {
	if (!hasQuiverEquipped()) {
		return nullptr;
	}

	const auto &quiver = inventory[CONST_SLOT_RIGHT];
	for (const auto &container = quiver->getContainer();
	     const auto &ammoItem : container->getItemList()) {
		if (ammoItem->getAmmoType() == it.ammoType) {
			if (level >= Item::items[ammoItem->getID()].minReqLevel) {
				return ammoItem;
			}
		}
	}
	return nullptr;
}

std::shared_ptr<Item> Player::getWeapon(bool ignoreAmmo /* = false*/) const {
	const auto &itemLeft = getWeapon(CONST_SLOT_LEFT, ignoreAmmo);
	if (itemLeft) {
		return itemLeft;
	}

	const auto &itemRight = getWeapon(CONST_SLOT_RIGHT, ignoreAmmo);
	if (itemRight) {
		return itemRight;
	}
	return nullptr;
}

WeaponType_t Player::getWeaponType() const {
	const auto &item = getWeapon();
	if (!item) {
		return WEAPON_NONE;
	}
	return item->getWeaponType();
}

int32_t Player::getWeaponSkill(const std::shared_ptr<Item> &item) const {
	if (!item) {
		return getSkillLevel(SKILL_FIST);
	}

	int32_t attackSkill;

	const WeaponType_t &weaponType = item->getWeaponType();
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

	static constexpr Slots_t armorSlots[] = { CONST_SLOT_HEAD, CONST_SLOT_NECKLACE, CONST_SLOT_ARMOR, CONST_SLOT_LEGS, CONST_SLOT_FEET, CONST_SLOT_RING, CONST_SLOT_AMMO };
	for (const Slots_t &slot : armorSlots) {
		const auto &inventoryItem = inventory[slot];
		if (inventoryItem) {
			armor += inventoryItem->getArmor();
		}
	}
	return armor * static_cast<int32_t>(vocation->armorMultiplier);
}

void Player::getShieldAndWeapon(std::shared_ptr<Item> &shield, std::shared_ptr<Item> &weapon) const {
	shield = nullptr;
	weapon = nullptr;

	for (uint32_t slot = CONST_SLOT_RIGHT; slot <= CONST_SLOT_LEFT; slot++) {
		const auto &item = inventory[slot];
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

void Player::setLastWalkthroughAttempt(int64_t walkthroughAttempt) {
	lastWalkthroughAttempt = walkthroughAttempt;
}

void Player::setLastWalkthroughPosition(Position walkthroughPosition) {
	lastWalkthroughPosition = walkthroughPosition;
}

std::shared_ptr<Inbox> Player::getInbox() const {
	return inbox;
}

std::unordered_set<PlayerIcon> Player::getClientIcons() {
	std::unordered_set<PlayerIcon> icons;

	for (const auto &condition : conditions) {
		if (!isSuppress(condition->getType(), false)) {
			auto conditionIcons = condition->getIcons();
			icons.insert(conditionIcons.begin(), conditionIcons.end());
			if (icons.size() == 9) {
				return icons;
			}
		}
	}

	if (pzLocked && icons.size() < 9) {
		icons.insert(PlayerIcon::RedSwords);
	}

	const auto &tile = getTile();
	if (tile && tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
		if (icons.size() < 9) {
			icons.insert(PlayerIcon::Pigeon);
		}
		client->sendRestingStatus(1);

		icons.erase(PlayerIcon::Swords);
	} else {
		client->sendRestingStatus(0);
	}

	return icons;
}

const std::unordered_set<std::shared_ptr<MonsterType>> &Player::getCyclopediaMonsterTrackerSet(bool isBoss) const {
	return isBoss ? m_bosstiaryMonsterTracker : m_bestiaryMonsterTracker;
}

void Player::addMonsterToCyclopediaTrackerList(const std::shared_ptr<MonsterType> &mtype, bool isBoss, bool reloadClient /* = false */) {
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

void Player::removeMonsterFromCyclopediaTrackerList(const std::shared_ptr<MonsterType> &mtype, bool isBoss, bool reloadClient /* = false */) {
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

void Player::sendBestiaryEntryChanged(uint16_t raceid) const {
	if (client) {
		client->sendBestiaryEntryChanged(raceid);
	}
}

void Player::refreshCyclopediaMonsterTracker(const std::unordered_set<std::shared_ptr<MonsterType>> &trackerList, bool isBoss) const {
	if (client) {
		client->refreshCyclopediaMonsterTracker(trackerList, isBoss);
	}
}

bool Player::isBossOnBosstiaryTracker(const std::shared_ptr<MonsterType> &monsterType) const {
	return monsterType ? m_bosstiaryMonsterTracker.contains(monsterType) : false;
}

std::shared_ptr<Vocation> Player::getVocation() const {
	return vocation;
}

OperatingSystem_t Player::getOperatingSystem() const {
	return operatingSystem;
}

void Player::setOperatingSystem(OperatingSystem_t clientos) {
	operatingSystem = clientos;
}

bool Player::isOldProtocol() const {
	return client && client->oldProtocol;
}

uint32_t Player::getProtocolVersion() const {
	if (!client) {
		return 0;
	}

	return client->getVersion();
}

bool Player::hasSecureMode() const {
	return secureMode;
}

void Player::setParty(std::shared_ptr<Party> newParty) {
	m_party = std::move(newParty);
}

std::shared_ptr<Party> Player::getParty() const {
	return m_party;
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
			const uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

void Player::updateInventoryWeight() {
	if (hasFlag(PlayerFlags_t::HasInfiniteCapacity)) {
		return;
	}

	inventoryWeight = 0;
	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		const auto &item = inventory[i];
		if (item) {
			inventoryWeight += item->getWeight();
		}
	}
}

void Player::updateInventoryImbuement() {
	// Get the tile the player is currently on
	const auto &playerTile = getTile();
	// Check if the player is in a protection zone
	const bool &isInProtectionZone = playerTile && playerTile->hasFlag(TILESTATE_PROTECTIONZONE);
	// Check if the player is in fight mode
	bool isInFightMode = hasCondition(CONDITION_INFIGHT);
	bool nonAggressiveFightOnly = g_configManager().getBoolean(TOGGLE_IMBUEMENT_NON_AGGRESSIVE_FIGHT_ONLY);

	// Iterate through all items in the player's inventory
	for (const auto &[slodNumber, item] : getAllSlotItems()) {
		// Iterate through all imbuement slots on the item
		for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
			ImbuementInfo imbuementInfo;
			// Get the imbuement information for the current slot
			if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
				// If no imbuement is found, continue to the next slot
				continue;
			}

			// Imbuement from imbuementInfo, this variable reduces code complexity
			const auto imbuement = imbuementInfo.imbuement;
			// Get the category of the imbuement
			const CategoryImbuement* categoryImbuement = g_imbuements().getCategoryByID(imbuement->getCategory());
			// Parent of the imbued item
			const auto &parent = item->getParent();
			const bool &isInBackpack = parent && parent->getContainer();
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
			const uint32_t duration = std::max<uint32_t>(0, imbuementInfo.duration - EVENT_IMBUEMENT_INTERVAL / 1000);
			// Update the imbuement's duration in the item
			item->decayImbuementTime(slotid, imbuement->getID(), duration);

			if (duration == 0) {
				removeItemImbuementStats(imbuement);
				updateImbuementTrackerStats();
			}
		}
	}
}

phmap::flat_hash_map<uint8_t, std::shared_ptr<Item>> Player::getAllSlotItems() const {
	phmap::flat_hash_map<uint8_t, std::shared_ptr<Item>> itemMap;
	for (uint8_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		const auto &item = inventory[i];
		if (!item) {
			continue;
		}

		itemMap[i] = item;
	}

	return itemMap;
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
	const absl::uint128 totalTries = vocation->getTotalSkillTries(skill, skills[skill].level) + tries;
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

uint16_t Player::getBaseSkill(uint8_t skill) const {
	return skills[skill].level;
}

double_t Player::getSkillPercent(skills_t skill) const {
	return skills[skill].percent;
}

bool Player::getAddAttackSkill() const {
	return addAttackSkillPoint;
}

BlockType_t Player::getLastAttackBlockType() const {
	return lastAttackBlockType;
}

uint64_t Player::getLastConditionTime(ConditionType_t type) const {
	if (!lastConditionTime.contains(static_cast<uint8_t>(type))) {
		return 0;
	}
	return lastConditionTime.at(static_cast<uint8_t>(type));
}

void Player::updateLastConditionTime(ConditionType_t type) {
	lastConditionTime[static_cast<uint8_t>(type)] = OTSYS_TIME();
}

bool Player::checkLastConditionTimeWithin(ConditionType_t type, uint32_t interval) const {
	if (!lastConditionTime.contains(static_cast<uint8_t>(type))) {
		return false;
	}
	const auto last = lastConditionTime.at(static_cast<uint8_t>(type));
	return last > 0 && ((OTSYS_TIME() - last) < interval);
}

uint64_t Player::getLastAttack() const {
	return lastAttack;
}

bool Player::checkLastAttackWithin(uint32_t interval) const {
	return lastAttack > 0 && ((OTSYS_TIME() - lastAttack) < interval);
}

void Player::updateLastAttack() {
	if (lastAttack == 0) {
		lastAttack = OTSYS_TIME() - getAttackSpeed() - 1;
		return;
	}
	lastAttack = OTSYS_TIME();
}

uint64_t Player::getLastAggressiveAction() const {
	return lastAggressiveAction;
}

bool Player::checkLastAggressiveActionWithin(uint32_t interval) const {
	return lastAggressiveAction > 0 && ((OTSYS_TIME() - lastAggressiveAction) < interval);
}

void Player::updateLastAggressiveAction() {
	lastAggressiveAction = OTSYS_TIME();
}

void Player::addSkillAdvance(skills_t skill, uint64_t count) {
	uint64_t currReqTries = vocation->getReqSkillTries(skill, skills[skill].level);
	uint64_t nextReqTries = vocation->getReqSkillTries(skill, skills[skill].level + 1);
	if (currReqTries >= nextReqTries) {
		// player has reached max skill
		return;
	}

	g_events().eventPlayerOnGainSkillTries(static_self_cast<Player>(), skill, count);
	g_callbacks().executeCallback(EventCallback_t::playerOnGainSkillTries, &EventCallback::playerOnGainSkillTries, getPlayer(), std::ref(skill), std::ref(count));
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

void Player::addContainer(uint8_t cid, const std::shared_ptr<Container> &container) {
	if (cid > 0xF) {
		return;
	}

	if (!container) {
		return;
	}

	const auto it = openContainers.find(cid);
	if (it != openContainers.end()) {
		OpenContainer &openContainer = it->second;
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
	const auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return;
	}

	const OpenContainer &openContainer = it->second;
	const auto &container = openContainer.container;

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

bool Player::hasOtherRewardContainerOpen(const std::shared_ptr<Container> &container) const {
	return std::ranges::any_of(openContainers.begin(), openContainers.end(), [container](const auto &containerPair) {
		return containerPair.second.container != container && containerPair.second.container->isAnyKindOfRewardContainer();
	});
}

void Player::setContainerIndex(uint8_t cid, uint16_t index) {
	const auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return;
	}
	it->second.index = index;
}

std::shared_ptr<Container> Player::getContainerByID(uint8_t cid) {
	const auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return nullptr;
	}
	return it->second.container;
}

int8_t Player::getContainerID(const std::shared_ptr<Container> &container) const {
	for (const auto &[containerId, containerInfo] : openContainers) {
		if (containerInfo.container == container) {
			return containerId;
		}
	}
	return -1;
}

uint16_t Player::getContainerIndex(uint8_t cid) const {
	const auto it = openContainers.find(cid);
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
	}
	return ITEM_MALE_CORPSE;
}

void Player::addStorageValue(const uint32_t key, const int32_t value, const bool isLogin /* = false*/) {
	if (IS_IN_KEYRANGE(key, RESERVED_RANGE)) {
		if (IS_IN_KEYRANGE(key, OUTFITS_RANGE)) {
			outfits.emplace_back(
				value >> 16,
				value & 0xFF
			);
			return;
		}
		if (IS_IN_KEYRANGE(key, MOUNTS_RANGE)) {
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
	const auto it = storageMap.find(key);
	if (it == storageMap.end()) {
		return value;
	}

	value = it->second;
	return value;
}

int32_t Player::getStorageValueByName(const std::string &storageName) const {
	const auto it = g_storages().getStorageMap().find(storageName);
	if (it == g_storages().getStorageMap().end()) {
		return -1;
	}
	const uint32_t key = it->second;

	return getStorageValue(key);
}

void Player::addStorageValueByName(const std::string &storageName, const int32_t value, const bool isLogin /* = false*/) {
	auto it = g_storages().getStorageMap().find(storageName);
	if (it == g_storages().getStorageMap().end()) {
		g_logger().error("[{}] Storage name '{}' not found in storage map, register your storage in 'storages.xml' first for use", __func__, storageName);
		return;
	}
	const uint32_t key = it->second;
	addStorageValue(key, value, isLogin);
}

std::shared_ptr<KV> Player::kv() const {
	return g_kv().scoped("player")->scoped(fmt::format("{}", getGUID()));
}

bool Player::canSee(const Position &pos) {
	if (!client) {
		return false;
	}
	return client->canSee(pos);
}

bool Player::canSeeCreature(const std::shared_ptr<Creature> &creature) const {
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

bool Player::canWalkthrough(const std::shared_ptr<Creature> &creature) {
	if (group->access || creature->isInGhostMode()) {
		return true;
	}

	const auto &player = creature->getPlayer();
	const auto &monster = creature->getMonster();
	const auto &npc = creature->getNpc();
	if (monster) {
		if (!monster->isFamiliar()) {
			return false;
		}
		return true;
	}

	if (player) {
		const auto &playerTile = player->getTile();
		if (!playerTile || (!playerTile->hasFlag(TILESTATE_NOPVPZONE) && !playerTile->hasFlag(TILESTATE_PROTECTIONZONE) && player->getLevel() > static_cast<uint32_t>(g_configManager().getNumber(PROTECTION_LEVEL)) && g_game().getWorldType() != WORLD_TYPE_NO_PVP)) {
			return false;
		}

		const auto &playerTileGround = playerTile->getGround();
		if (!playerTileGround || !playerTileGround->hasWalkStack()) {
			return false;
		}

		const auto &thisPlayer = getPlayer();
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
		const auto &tile = npc->getTile();
		const auto &houseTile = std::dynamic_pointer_cast<HouseTile>(tile);
		return (houseTile != nullptr);
	}

	return false;
}

bool Player::canWalkthroughEx(const std::shared_ptr<Creature> &creature) const {
	if (group->access) {
		return true;
	}

	const auto &monster = creature->getMonster();
	if (monster) {
		if (!monster->isFamiliar()) {
			return false;
		}
		return true;
	}

	const auto &player = creature->getPlayer();
	const auto &npc = creature->getNpc();
	if (player) {
		const auto &playerTile = player->getTile();
		return playerTile && (playerTile->hasFlag(TILESTATE_NOPVPZONE) || playerTile->hasFlag(TILESTATE_PROTECTIONZONE) || player->getLevel() <= static_cast<uint32_t>(g_configManager().getNumber(PROTECTION_LEVEL)) || g_game().getWorldType() == WORLD_TYPE_NO_PVP);
	} else if (npc) {
		const auto &tile = npc->getTile();
		const auto &houseTile = std::dynamic_pointer_cast<HouseTile>(tile);
		return (houseTile != nullptr);
	} else {
		return false;
	}
}

RaceType_t Player::getRace() const {
	return RACE_BLOOD;
}

uint64_t Player::getMoney() const {
	uint64_t moneyCount = 0;

	auto countMoneyInContainer = [&moneyCount](const auto &self, const std::shared_ptr<Container> &container) -> void {
		for (const auto &item : container->getItemList()) {
			if (const auto &tmpContainer = item->getContainer()) {
				self(self, tmpContainer);
			} else {
				moneyCount += item->getWorth();
			}
		}
	};

	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		const auto &item = inventory[i];
		if (!item) {
			continue;
		}

		if (const auto &container = item->getContainer()) {
			countMoneyInContainer(countMoneyInContainer, container);
		} else {
			moneyCount += item->getWorth();
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
	for (const auto &stashToSend = getStashItems();
	     const auto &[itemId, itemCount] : stashToSend) {
		if (itemId == ITEM_FORGE_SLIVER) {
			sliverCount += itemCount;
		}
		if (itemId == ITEM_FORGE_CORE) {
			coreCount += itemCount;
		}
	}

	return std::make_pair(sliverCount, coreCount);
}

void Player::onReceiveMail() {
	if (isNearDepotBox()) {
		sendTextMessage(MESSAGE_EVENT_ADVANCE, "New mail has arrived.");
	}
}

std::shared_ptr<Container> Player::refreshManagedContainer(ObjectCategory_t category, const std::shared_ptr<Container> &container, bool isLootContainer, bool loading /* = false*/) {
	std::shared_ptr<Container> previousContainer = nullptr;
	const auto toSetAttribute = isLootContainer ? ItemAttribute_t::QUICKLOOTCONTAINER : ItemAttribute_t::OBTAINCONTAINER;
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
		if (m_managedContainers.contains(category)) {
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
			const auto flags = container->getAttribute<uint32_t>(toSetAttribute);
			const auto sendAttribute = flags | (1 << category);
			container->setAttribute(toSetAttribute, sendAttribute);
		}
	}

	return previousContainer;
}

std::shared_ptr<Container> Player::getManagedContainer(ObjectCategory_t category, bool isLootContainer) const {
	if (category != OBJECTCATEGORY_DEFAULT && !isPremium()) {
		category = OBJECTCATEGORY_DEFAULT;
	}

	const auto it = m_managedContainers.find(category);
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

void Player::checkLootContainers(const std::shared_ptr<Container> &container) {
	if (!container) {
		return;
	}

	bool shouldSend = false;
	for (auto it = m_managedContainers.begin(); it != m_managedContainers.end();) {
		auto &lootContainer = it->second.first;
		auto &obtainContainer = it->second.second;
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

void Player::setMainBackpackUnassigned(const std::shared_ptr<Container> &container) {
	if (!container) {
		return;
	}

	// Update containers
	bool toSendInventoryUpdate = false;
	for (const bool isLootContainer : { true, false }) {
		const auto &managedContainer = getManagedContainer(OBJECTCATEGORY_DEFAULT, isLootContainer);
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

bool Player::updateKillTracker(const std::shared_ptr<Container> &corpse, const std::string &playerName, const Outfit_t &creatureOutfit) const {
	if (client) {
		client->sendKillTrackerUpdate(corpse, playerName, creatureOutfit);
		return true;
	}

	return false;
}

void Player::updatePartyTrackerAnalyzer() const {
	if (client && m_party) {
		client->updatePartyTrackerAnalyzer(m_party);
	}
}

void Player::sendLootStats(const std::shared_ptr<Item> &item, uint8_t count) {
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
		const auto &npc = g_game().getNpcByName("The Lootmonger")
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

void Player::updateSupplyTracker(const std::shared_ptr<Item> &item) {
	const auto &iType = Item::items.getItemType(item->getID());
	const auto value = iType.buyPrice;
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

void Player::updateInputAnalyzer(CombatType_t type, int32_t amount, const std::string &target) const {
	if (client) {
		client->sendUpdateInputAnalyzer(type, amount, target);
	}
}

void Player::createLeaderTeamFinder(NetworkMessage &msg) const {
	if (client) {
		client->createLeaderTeamFinder(msg);
	}
}

void Player::sendLeaderTeamFinder(bool reset) const {
	if (client) {
		client->sendLeaderTeamFinder(reset);
	}
}

void Player::sendTeamFinderList() const {
	if (client) {
		client->sendTeamFinderList();
	}
}

void Player::sendCreatureHelpers(uint32_t creatureId, uint16_t helpers) const {
	if (client) {
		client->sendCreatureHelpers(creatureId, helpers);
	}
}

void Player::setItemCustomPrice(uint16_t itemId, uint64_t price) {
	itemPriceMap[itemId] = price;
}

uint32_t Player::getCharmPoints() const {
	return charmPoints;
}

void Player::setCharmPoints(uint32_t points) {
	charmPoints = points;
}

bool Player::hasCharmExpansion() const {
	return charmExpansion;
}

void Player::setCharmExpansion(bool onOff) {
	charmExpansion = onOff;
}

void Player::setUsedRunesBit(int32_t bit) {
	UsedRunesBit = bit;
}

int32_t Player::getUsedRunesBit() const {
	return UsedRunesBit;
}

void Player::setUnlockedRunesBit(int32_t bit) {
	UnlockedRunesBit = bit;
}

int32_t Player::getUnlockedRunesBit() const {
	return UnlockedRunesBit;
}

void Player::setImmuneCleanse(ConditionType_t conditiontype) {
	cleanseCondition.first = conditiontype;
	cleanseCondition.second = OTSYS_TIME() + 10000;
}

bool Player::isImmuneCleanse(ConditionType_t conditiontype) const {
	const uint64_t timenow = OTSYS_TIME();
	if ((cleanseCondition.first == conditiontype)
	    && (timenow <= cleanseCondition.second)) {
		return true;
	}
	return false;
}

void Player::setImmuneFear() {
	m_fearCondition.first = CONDITION_FEARED;
	m_fearCondition.second = OTSYS_TIME() + 10000;
}

bool Player::isImmuneFear() const {
	const uint64_t timenow = OTSYS_TIME();
	return (m_fearCondition.first == CONDITION_FEARED) && (timenow <= m_fearCondition.second);
}

uint16_t Player::parseRacebyCharm(charmRune_t charmId, bool set, uint16_t newRaceid) {
	uint16_t raceid = 0;
	switch (charmId) {
		case CHARM_WOUND:
			if (set) {
				charmRuneWound = newRaceid;
			} else {
				raceid = charmRuneWound;
			}
			break;
		case CHARM_ENFLAME:
			if (set) {
				charmRuneEnflame = newRaceid;
			} else {
				raceid = charmRuneEnflame;
			}
			break;
		case CHARM_POISON:
			if (set) {
				charmRunePoison = newRaceid;
			} else {
				raceid = charmRunePoison;
			}
			break;
		case CHARM_FREEZE:
			if (set) {
				charmRuneFreeze = newRaceid;
			} else {
				raceid = charmRuneFreeze;
			}
			break;
		case CHARM_ZAP:
			if (set) {
				charmRuneZap = newRaceid;
			} else {
				raceid = charmRuneZap;
			}
			break;
		case CHARM_CURSE:
			if (set) {
				charmRuneCurse = newRaceid;
			} else {
				raceid = charmRuneCurse;
			}
			break;
		case CHARM_CRIPPLE:
			if (set) {
				charmRuneCripple = newRaceid;
			} else {
				raceid = charmRuneCripple;
			}
			break;
		case CHARM_PARRY:
			if (set) {
				charmRuneParry = newRaceid;
			} else {
				raceid = charmRuneParry;
			}
			break;
		case CHARM_DODGE:
			if (set) {
				charmRuneDodge = newRaceid;
			} else {
				raceid = charmRuneDodge;
			}
			break;
		case CHARM_ADRENALINE:
			if (set) {
				charmRuneAdrenaline = newRaceid;
			} else {
				raceid = charmRuneAdrenaline;
			}
			break;
		case CHARM_NUMB:
			if (set) {
				charmRuneNumb = newRaceid;
			} else {
				raceid = charmRuneNumb;
			}
			break;
		case CHARM_CLEANSE:
			if (set) {
				charmRuneCleanse = newRaceid;
			} else {
				raceid = charmRuneCleanse;
			}
			break;
		case CHARM_BLESS:
			if (set) {
				charmRuneBless = newRaceid;
			} else {
				raceid = charmRuneBless;
			}
			break;
		case CHARM_SCAVENGE:
			if (set) {
				charmRuneScavenge = newRaceid;
			} else {
				raceid = charmRuneScavenge;
			}
			break;
		case CHARM_GUT:
			if (set) {
				charmRuneGut = newRaceid;
			} else {
				raceid = charmRuneGut;
			}
			break;
		case CHARM_LOW:
			if (set) {
				charmRuneLowBlow = newRaceid;
			} else {
				raceid = charmRuneLowBlow;
			}
			break;
		case CHARM_DIVINE:
			if (set) {
				charmRuneDivine = newRaceid;
			} else {
				raceid = charmRuneDivine;
			}
			break;
		case CHARM_VAMP:
			if (set) {
				charmRuneVamp = newRaceid;
			} else {
				raceid = charmRuneVamp;
			}
			break;
		case CHARM_VOID:
			if (set) {
				charmRuneVoid = newRaceid;
			} else {
				raceid = charmRuneVoid;
			}
			break;
		default:
			raceid = 0;
			break;
	}
	return raceid;
}

bool Player::isNearDepotBox() {
	const Position &pos = getPosition();
	for (int32_t cx = -1; cx <= 1; ++cx) {
		for (int32_t cy = -1; cy <= 1; ++cy) {
			const auto &posTile = g_game().map.getTile(static_cast<uint16_t>(pos.x + cx), static_cast<uint16_t>(pos.y + cy), pos.z);
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
	const auto it = depotChests.find(depotId);
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
	const auto it = depotLockerMap.find(depotId);
	if (it != depotLockerMap.end()) {
		inbox->setParent(it->second);
		for (uint32_t i = g_configManager().getNumber(DEPOT_BOXES); i > 0; i--) {
			if (const auto &depotBox = getDepotChest(i, false)) {
				depotBox->setParent(it->second->getItemByIndex(0)->getContainer());
			}
		}
		return it->second;
	}

	// We need to make room for supply stash on 12+ protocol versions and remove it for 10x.
	const bool createSupplyStash = !client->oldProtocol;

	auto depotLocker = std::make_shared<DepotLocker>(ITEM_LOCKER, createSupplyStash ? 4 : 3);
	depotLocker->setDepotId(depotId);
	const auto &marketItem = Item::CreateItem(ITEM_MARKET);
	depotLocker->internalAddThing(marketItem);
	depotLocker->internalAddThing(inbox);
	if (createSupplyStash) {
		const auto &supplyStashPtr = Item::CreateItem(ITEM_SUPPLY_STASH);
		depotLocker->internalAddThing(supplyStashPtr);
	}
	const auto &depotChest = Item::CreateItemAsContainer(ITEM_DEPOT, static_cast<uint16_t>(g_configManager().getNumber(DEPOT_BOXES)));
	for (uint32_t i = g_configManager().getNumber(DEPOT_BOXES); i > 0; i--) {
		const auto &depotBox = getDepotChest(i, true);
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
	const auto it = rewardMap.find(rewardId);
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
	for (const auto &[rewardId, snd] : rewardMap) {
		rewards.emplace_back(rewardId);
	}
}

std::vector<std::shared_ptr<Item>> Player::getRewardsFromContainer(const std::shared_ptr<Container> &container) const {
	std::vector<std::shared_ptr<Item>> rewardItemsVector;
	if (container) {
		for (const auto &item : container->getItems(false)) {
			if (item->getID() == ITEM_REWARD_CONTAINER) {
				const auto &items = getRewardsFromContainer(item->getContainer());
				rewardItemsVector.insert(rewardItemsVector.end(), items.begin(), items.end());
			} else {
				rewardItemsVector.emplace_back(item);
			}
		}
	}

	return rewardItemsVector;
}

void Player::sendCancelMessage(const std::string &msg) const {
	if (client) {
		client->sendTextMessage(TextMessage(MESSAGE_FAILURE, msg));
	}
}

void Player::sendCancelMessage(ReturnValue message) const {
	sendCancelMessage(getReturnMessage(message));
}

void Player::sendCancelTarget() const {
	if (client) {
		client->sendCancelTarget();
	}
}

void Player::sendCancelWalk() const {
	if (client) {
		client->sendCancelWalk();
	}
}

void Player::sendChangeSpeed(const std::shared_ptr<Creature> &creature, uint16_t newSpeed) const {
	if (client) {
		client->sendChangeSpeed(creature, newSpeed);
	}
}

void Player::sendCreatureHealth(const std::shared_ptr<Creature> &creature) const {
	if (client) {
		client->sendCreatureHealth(creature);
	}
}

void Player::sendPartyCreatureUpdate(const std::shared_ptr<Creature> &creature) const {
	if (client) {
		client->sendPartyCreatureUpdate(creature);
	}
}

void Player::sendPartyCreatureShield(const std::shared_ptr<Creature> &creature) const {
	if (client) {
		client->sendPartyCreatureShield(creature);
	}
}

void Player::sendPartyCreatureSkull(const std::shared_ptr<Creature> &creature) const {
	if (client) {
		client->sendPartyCreatureSkull(creature);
	}
}

void Player::sendPartyCreatureHealth(const std::shared_ptr<Creature> &creature, uint8_t healthPercent) const {
	if (client) {
		client->sendPartyCreatureHealth(creature, healthPercent);
	}
}

void Player::sendPartyPlayerMana(const std::shared_ptr<Player> &player, uint8_t manaPercent) const {
	if (client) {
		client->sendPartyPlayerMana(player, manaPercent);
	}
}

void Player::sendPartyCreatureShowStatus(const std::shared_ptr<Creature> &creature, bool showStatus) const {
	if (client) {
		client->sendPartyCreatureShowStatus(creature, showStatus);
	}
}

void Player::sendPartyPlayerVocation(const std::shared_ptr<Player> &player) const {
	if (client) {
		client->sendPartyPlayerVocation(player);
	}
}

void Player::sendPlayerVocation(const std::shared_ptr<Player> &player) const {
	if (client) {
		client->sendPlayerVocation(player);
	}
}

void Player::sendDistanceShoot(const Position &from, const Position &to, uint16_t type) const {
	if (client) {
		client->sendDistanceShoot(from, to, type);
	}
}

void Player::sendHouseWindow(const std::shared_ptr<House> &house, uint32_t listId) const {
	if (!client) {
		return;
	}

	std::string text;
	if (house->getAccessList(listId, text)) {
		client->sendHouseWindow(windowTextId, text);
	}
}

void Player::sendCreatePrivateChannel(uint16_t channelId, const std::string &channelName) const {
	if (client) {
		client->sendCreatePrivateChannel(channelId, channelName);
	}
}

void Player::sendClosePrivate(uint16_t channelId) {
	if (channelId == CHANNEL_GUILD || channelId == CHANNEL_PARTY) {
		g_chat().removeUserFromChannel(getPlayer(), channelId);
	}

	if (client) {
		client->sendClosePrivate(channelId);
	}
}

void Player::sendIcons() {
	if (!client) {
		return;
	}

	// Iterates over the Bakragore icons to check if the player has any
	auto iconBakragore = IconBakragore::None;
	for (const auto &icon : magic_enum::enum_values<IconBakragore>()) {
		if (icon == IconBakragore::None) {
			continue;
		}

		const auto &condition = getCondition(CONDITION_BAKRAGORE, CONDITIONID_DEFAULT, magic_enum::enum_integer(icon));
		if (condition) {
			g_logger().debug("[{}] found active condition Bakragore with subId {}", __FUNCTION__, magic_enum::enum_integer(icon));
			iconBakragore = icon;
		}
	}

	// Remove the last icon so that Bakragore's is added
	auto iconSet = getClientIcons();
	if (iconSet.size() >= 9 && iconBakragore != IconBakragore::None) {
		std::vector<PlayerIcon> tempVector(iconSet.begin(), iconSet.end());
		tempVector.pop_back();
		iconSet = std::unordered_set<PlayerIcon>(tempVector.begin(), tempVector.end());
	}

	client->sendIcons(iconSet, iconBakragore);
}

void Player::sendIconBakragore(IconBakragore icon) const {
	if (client) {
		client->sendIconBakragore(icon);
	}
}

void Player::removeBakragoreIcons() {
	for (auto icon : magic_enum::enum_values<IconBakragore>()) {
		if (hasCondition(CONDITION_BAKRAGORE, enumToValue(icon))) {
			removeCondition(CONDITION_BAKRAGORE, CONDITIONID_DEFAULT, true);
		}
	}
}

void Player::removeBakragoreIcon(const IconBakragore icon) {
	if (hasCondition(CONDITION_BAKRAGORE, enumToValue(icon))) {
		removeCondition(CONDITION_BAKRAGORE, CONDITIONID_DEFAULT, true);
	}
}

void Player::sendClientCheck() const {
	if (client) {
		client->sendClientCheck();
	}
}

void Player::sendGameNews() const {
	if (client) {
		client->sendGameNews();
	}
}

void Player::sendMagicEffect(const Position &pos, uint16_t type) const {
	if (client) {
		client->sendMagicEffect(pos, type);
	}
}

void Player::removeMagicEffect(const Position &pos, uint16_t type) const {
	if (client) {
		client->removeMagicEffect(pos, type);
	}
}

void Player::sendPing() {
	const int64_t timeNow = OTSYS_TIME();

	bool hasLostConnection = false;
	if ((timeNow - lastPing) >= 5000) {
		lastPing = timeNow;
		if (client) {
			client->sendPing();
		} else {
			hasLostConnection = true;
		}
	}

	const int64_t noPongTime = timeNow - lastPong;
	const auto &attackedCreature = getAttackedCreature();
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

void Player::sendPingBack() const {
	if (client) {
		client->sendPingBack();
	}
}

void Player::sendStats() {
	if (client) {
		client->sendStats();
		lastStatsTrainingTime = getOfflineTrainingTime() / 60 / 1000;
	}
}

void Player::sendBasicData() const {
	if (client) {
		client->sendBasicData();
	}
}

void Player::sendBlessStatus() const {
	if (client) {
		client->sendBlessStatus();
	}
}

void Player::sendSkills() const {
	if (client) {
		client->sendSkills();
	}
}

void Player::sendTextMessage(MessageClasses mclass, const std::string &message) const {
	if (client) {
		client->sendTextMessage(TextMessage(mclass, message));
	}
}

void Player::sendTextMessage(const TextMessage &message) const {
	if (client) {
		client->sendTextMessage(message);
	}
}

void Player::sendReLoginWindow(uint8_t unfairFightReduction) const {
	if (client) {
		client->sendReLoginWindow(unfairFightReduction);
	}
}

void Player::sendTextWindow(const std::shared_ptr<Item> &item, uint16_t maxlen, bool canWrite) const {
	if (client) {
		client->sendTextWindow(windowTextId, item, maxlen, canWrite);
	}
}

void Player::sendToChannel(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text, uint16_t channelId) const {
	if (client) {
		client->sendToChannel(creature, type, text, channelId);
	}
}

void Player::sendShop(const std::shared_ptr<Npc> &npc) const {
	if (client) {
		client->sendShop(npc);
	}
}

void Player::sendSaleItemList(const std::map<uint16_t, uint16_t> &inventoryMap) const {
	if (client && shopOwner) {
		client->sendSaleItemList(shopOwner->getShopItemVector(getGUID()), inventoryMap);
	}
}

bool Player::hasImbuingItem() const {
	return imbuingItem != nullptr;
}

void Player::setImbuingItem(const std::shared_ptr<Item> &item) {
	imbuingItem = item;
}

void Player::addBlessing(uint8_t index, uint8_t count) {
	if (blessings[index - 1] == 255) {
		return;
	}

	blessings[index - 1] += count;
}

void Player::removeBlessing(uint8_t index, uint8_t count) {
	if (blessings[index - 1] == 0) {
		return;
	}

	blessings[index - 1] -= count;
}

bool Player::hasBlessing(uint8_t index) const {
	return blessings[index - 1] != 0;
}

void Player::sendCloseShop() const {
	if (client) {
		client->sendCloseShop();
	}
}

void Player::sendMarketEnter(uint32_t depotId) const {
	if (!client || this->getLastDepotId() == -1 || !depotId) {
		return;
	}

	client->sendMarketEnter(depotId);
}

void Player::sendMarketLeave() {
	inMarket = false;
	if (client) {
		client->sendMarketLeave();
	}
}

void Player::sendMarketBrowseItem(uint16_t itemId, const MarketOfferList &buyOffers, const MarketOfferList &sellOffers, uint8_t tier) const {
	if (client) {
		client->sendMarketBrowseItem(itemId, buyOffers, sellOffers, tier);
	}
}

void Player::sendMarketBrowseOwnOffers(const MarketOfferList &buyOffers, const MarketOfferList &sellOffers) const {
	if (client) {
		client->sendMarketBrowseOwnOffers(buyOffers, sellOffers);
	}
}

void Player::sendMarketBrowseOwnHistory(const HistoryMarketOfferList &buyOffers, const HistoryMarketOfferList &sellOffers) const {
	if (client) {
		client->sendMarketBrowseOwnHistory(buyOffers, sellOffers);
	}
}

void Player::sendMarketDetail(uint16_t itemId, uint8_t tier) const {
	if (client) {
		client->sendMarketDetail(itemId, tier);
	}
}

void Player::sendMarketAcceptOffer(const MarketOfferEx &offer) const {
	if (client) {
		client->sendMarketAcceptOffer(offer);
	}
}

void Player::sendMarketCancelOffer(const MarketOfferEx &offer) const {
	if (client) {
		client->sendMarketCancelOffer(offer);
	}
}

void Player::sendTradeItemRequest(const std::string &traderName, const std::shared_ptr<Item> &item, bool ack) const {
	if (client) {
		client->sendTradeItemRequest(traderName, item, ack);
	}
}

void Player::sendTradeClose() const {
	if (client) {
		client->sendCloseTrade();
	}
}

void Player::sendWorldLight(LightInfo lightInfo) const {
	if (client) {
		client->sendWorldLight(lightInfo);
	}
}

void Player::sendTibiaTime(int32_t time) const {
	if (client) {
		client->sendTibiaTime(time);
	}
}

void Player::sendChannelsDialog() const {
	if (client) {
		client->sendChannelsDialog();
	}
}

void Player::sendOpenPrivateChannel(const std::string &receiver) const {
	if (client) {
		client->sendOpenPrivateChannel(receiver);
	}
}

void Player::sendExperienceTracker(int64_t rawExp, int64_t finalExp) const {
	if (client) {
		client->sendExperienceTracker(rawExp, finalExp);
	}
}

void Player::sendOutfitWindow() const {
	if (client) {
		client->sendOutfitWindow();
	}
}

// Imbuements

void Player::onApplyImbuement(const Imbuement* imbuement, const std::shared_ptr<Item> &item, uint8_t slot, bool protectionCharm) {
	if (!imbuement || !item) {
		return;
	}

	ImbuementInfo imbuementInfo;
	if (item->getImbuementInfo(slot, &imbuementInfo)) {
		g_logger().error("[Player::onApplyImbuement] - An error occurred while player with name {} try to apply imbuement, item already contains imbuement", this->getName());
		this->sendImbuementResult("An error ocurred, please reopen imbuement window.");
		return;
	}

	const auto &items = imbuement->getItems();
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
		const std::string message = fmt::format("You don't have {} gold coins.", price);

		g_logger().error("[Player::onApplyImbuement] - An error occurred while player with name {} try to apply imbuement, player do not have money", this->getName());
		sendImbuementResult(message);
		return;
	}

	g_metrics().addCounter("balance_decrease", price, { { "player", getName() }, { "context", "apply_imbuement" } });

	for (auto &[key, value] : items) {
		std::stringstream withdrawItemMessage;

		const uint32_t inventoryItemCount = getItemTypeCount(key);
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

void Player::onClearImbuement(const std::shared_ptr<Item> &item, uint8_t slot) {
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
		const std::string message = fmt::format("You don't have {} gold coins.", baseImbuement->removeCost);

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

void Player::openImbuementWindow(const std::shared_ptr<Item> &item) {
	if (!client || !item) {
		return;
	}

	if (item->getImbuementSlot() <= 0) {
		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item is not imbuable.");
		return;
	}

	const auto &itemParent = item->getTopParent();
	if (itemParent && itemParent != getPlayer()) {
		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to pick up the item to imbue it.");
		return;
	}

	client->openImbuementWindow(item);
}

// inventory

void Player::onChangeZone(ZoneType_t zone) {
	if (zone == ZONE_PROTECTION) {
		if (getAttackedCreature() && !hasFlag(PlayerFlags_t::IgnoreProtectionZone)) {
			setAttackedCreature(nullptr);
			onAttackedCreatureDisappear(false);
		}

		if (!g_configManager().getBoolean(TOGGLE_MOUNT_IN_PZ) && !group->access && isMounted()) {
			dismount();
			g_game().internalCreatureChangeOutfit(getPlayer(), defaultOutfit);
			wasMounted = true;
		}
	} else {
		int32_t ticks = g_configManager().getNumber(STAIRHOP_DELAY);
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
	const auto &attackedCreature = getAttackedCreature();
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

bool Player::openShopWindow(const std::shared_ptr<Npc> &npc, const std::vector<ShopBlock> &shopItems) {
	Benchmark brenchmark;
	if (!npc) {
		g_logger().error("[Player::openShopWindow] - Npc is wrong or nullptr");
		return false;
	}

	if (npc->isShopPlayer(getGUID()) && npc->getShopItemVector(getGUID()).size() == shopItems.size()) {
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
		const Position pos = getNextPosition(dir, getPosition());

		const auto &tile = g_game().map.getTile(pos);
		if (tile) {
			const auto &field = tile->getFieldItem();
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

void Player::checkTradeState(const std::shared_ptr<Item> &item) {
	if (!tradeItem || tradeState == TRADE_TRANSFER) {
		return;
	}

	if (tradeItem == item) {
		g_game().internalCloseTrade(static_self_cast<Player>());
	} else {
		auto container = std::dynamic_pointer_cast<Container>(item->getParent());
		while (container) {
			if (container == tradeItem) {
				g_game().internalCloseTrade(static_self_cast<Player>());
				break;
			}

			container = std::dynamic_pointer_cast<Container>(container->getParent());
		}
	}
}

void Player::setNextWalkActionTask(const std::shared_ptr<Task> &task) {
	if (walkTaskEvent != 0) {
		g_dispatcher().stopEvent(walkTaskEvent);
		walkTaskEvent = 0;
	}

	walkTask = task;
}

void Player::setNextWalkTask(const std::shared_ptr<Task> &task) {
	if (nextStepEvent != 0) {
		g_dispatcher().stopEvent(nextStepEvent);
		nextStepEvent = 0;
	}

	if (task) {
		nextStepEvent = g_dispatcher().scheduleEvent(task);
		resetIdleTime();
	}
}

void Player::setNextActionTask(const std::shared_ptr<Task> &task, bool resetIdleTime /*= true */) {
	if (actionTaskEvent != 0) {
		g_dispatcher().stopEvent(actionTaskEvent);
		actionTaskEvent = 0;
	}

	if (!inEventMovePush && !g_configManager().getBoolean(PUSH_WHEN_ATTACKING)) {
		cancelPush();
	}

	if (task) {
		actionTaskEvent = g_dispatcher().scheduleEvent(task);
		if (resetIdleTime) {
			this->resetIdleTime();
		}
	}
}

void Player::setNextActionPushTask(const std::shared_ptr<Task> &task) {
	if (actionTaskEventPush != 0) {
		g_dispatcher().stopEvent(actionTaskEventPush);
		actionTaskEventPush = 0;
	}

	if (task) {
		actionTaskEventPush = g_dispatcher().scheduleEvent(task);
	}
}

void Player::setNextPotionActionTask(const std::shared_ptr<Task> &task) {
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

void Player::setModuleDelay(uint8_t byteortype, int16_t delay) {
	moduleDelayMap[byteortype] = OTSYS_TIME() + delay;
}

bool Player::canRunModule(uint8_t byteortype) {
	if (!moduleDelayMap[byteortype]) {
		return true;
	}
	return moduleDelayMap[byteortype] <= OTSYS_TIME();
}

uint32_t Player::getNextActionTime() const {
	return std::max<int64_t>(SCHEDULER_MINTICKS, nextAction - OTSYS_TIME());
}

uint32_t Player::getNextPotionActionTime() const {
	return std::max<int64_t>(SCHEDULER_MINTICKS, nextPotionAction - OTSYS_TIME());
}

std::shared_ptr<Item> Player::getWriteItem(uint32_t &retWindowTextId, uint16_t &retMaxWriteLen) {
	retWindowTextId = this->windowTextId;
	retMaxWriteLen = this->maxWriteLen;
	return writeItem;
}

void Player::setWriteItem(const std::shared_ptr<Item> &item, uint16_t maxWriteLength) {
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

void Player::setEditHouse(const std::shared_ptr<House> &house, uint32_t listId) {
	windowTextId++;
	editHouse = house;
	editListId = listId;
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

	return std::ranges::any_of(learnedInstantSpellList, [&](const auto &learnedSpellName) {
		return strcasecmp(learnedSpellName.c_str(), spellName.c_str()) == 0;
	});
}

void Player::updateRegeneration() const {
	if (!vocation) {
		return;
	}

	const auto &condition = getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	if (condition) {
		condition->setParam(CONDITION_PARAM_HEALTHGAIN, vocation->getHealthGainAmount());
		condition->setParam(CONDITION_PARAM_HEALTHTICKS, vocation->getHealthGainTicks());
		condition->setParam(CONDITION_PARAM_MANAGAIN, vocation->getManaGainAmount());
		condition->setParam(CONDITION_PARAM_MANATICKS, vocation->getManaGainTicks());
	}
}

void Player::setScheduledSaleUpdate(bool scheduled) {
	scheduledSaleUpdate = scheduled;
}

bool Player::getScheduledSaleUpdate() const {
	return scheduledSaleUpdate;
}

bool Player::inPushEvent() const {
	return inEventMovePush;
}

void Player::pushEvent(bool b) {
	inEventMovePush = b;
}

bool Player::walkExhausted() const {
	if (hasCondition(CONDITION_PARALYZE)) {
		return lastWalking > OTSYS_TIME();
	}

	return false;
}

void Player::setWalkExhaust(int64_t value) {
	lastWalking = OTSYS_TIME() + value;
}

const std::map<uint8_t, OpenContainer> &Player::getOpenContainers() const {
	return openContainers;
}

uint16_t Player::getBaseXpGain() const {
	return baseXpGain;
}

void Player::setBaseXpGain(uint16_t value) {
	baseXpGain = std::min<uint16_t>(std::numeric_limits<uint16_t>::max(), value);
}

uint16_t Player::getVoucherXpBoost() const {
	return voucherXpBoost;
}

void Player::setVoucherXpBoost(uint16_t value) {
	voucherXpBoost = std::min<uint16_t>(std::numeric_limits<uint16_t>::max(), value);
}

uint16_t Player::getGrindingXpBoost() const {
	return grindingXpBoost;
}

void Player::setGrindingXpBoost(uint16_t value) {
	grindingXpBoost = std::min<uint16_t>(std::numeric_limits<uint16_t>::max(), value);
}

uint16_t Player::getXpBoostPercent() const {
	return xpBoostPercent;
}

void Player::setXpBoostPercent(uint16_t percent) {
	xpBoostPercent = percent;
}

uint16_t Player::getStaminaXpBoost() const {
	return staminaXpBoost;
}

void Player::setStaminaXpBoost(uint16_t value) {
	staminaXpBoost = std::min<uint16_t>(std::numeric_limits<uint16_t>::max(), value);
}

void Player::setXpBoostTime(uint16_t timeLeft) {
	// only allow time boosts of 12 hours or less
	if (timeLeft > 12 * 3600) {
		xpBoostTime = 12 * 3600;
		return;
	}
	xpBoostTime = timeLeft;
}

uint16_t Player::getXpBoostTime() const {
	return xpBoostTime;
}

int32_t Player::getIdleTime() const {
	return idleTime;
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

// User Interface action exhaustion

bool Player::isUIExhausted(uint32_t exhaustionTime) const {
	return (OTSYS_TIME() - lastUIInteraction < exhaustionTime);
}

void Player::updateUIExhausted() {
	lastUIInteraction = OTSYS_TIME();
}

bool Player::isQuickLootListedItem(const std::shared_ptr<Item> &item) const {
	if (!item) {
		return false;
	}

	auto it = std::ranges::find(quickLootListItemIds, item->getID());
	return it != quickLootListItemIds.end();
}

void Player::setNextAction(int64_t time) {
	if (time > nextAction) {
		nextAction = time;
	}
}

bool Player::canDoAction() const {
	return nextAction <= OTSYS_TIME();
}

void Player::setNextPotionAction(int64_t time) {
	if (time > nextPotionAction) {
		nextPotionAction = time;
	}
}

bool Player::canDoPotionAction() const {
	return nextPotionAction <= OTSYS_TIME();
}

void Player::cancelPush() {
	if (actionTaskEventPush != 0) {
		g_dispatcher().stopEvent(actionTaskEventPush);
		actionTaskEventPush = 0;
		inEventMovePush = false;
	}
}

uint32_t Player::isMuted() const {
	if (hasFlag(PlayerFlags_t::CannotBeMuted)) {
		return 0;
	}

	int32_t muteTicks = 0;
	for (const auto &condition : conditions) {
		if (condition->getType() == CONDITION_MUTED && condition->getTicks() > muteTicks) {
			muteTicks = condition->getTicks();
		}
	}
	return static_cast<uint32_t>(muteTicks) / 1000;
}

void Player::addMessageBuffer() {
	if (MessageBufferCount > 0 && g_configManager().getNumber(MAX_MESSAGEBUFFER) != 0 && !hasFlag(PlayerFlags_t::CannotBeMuted)) {
		--MessageBufferCount;
	}
}

void Player::removeMessageBuffer() {
	if (hasFlag(PlayerFlags_t::CannotBeMuted)) {
		return;
	}

	const int32_t maxMessageBuffer = g_configManager().getNumber(MAX_MESSAGEBUFFER);
	if (maxMessageBuffer != 0 && MessageBufferCount <= maxMessageBuffer + 1) {
		if (++MessageBufferCount > maxMessageBuffer) {
			uint32_t muteCount = 1;
			const auto it = muteCountMap.find(guid);
			if (it != muteCountMap.end()) {
				muteCount = it->second;
			}

			const uint32_t muteTime = 5 * muteCount * muteCount;
			muteCountMap[guid] = muteCount + 1;
			const auto &condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_MUTED, muteTime * 1000, 0);
			addCondition(condition);

			std::ostringstream ss;
			ss << "You are muted for " << muteTime << " seconds.";
			sendTextMessage(MESSAGE_FAILURE, ss.str());
		}
	}
}

void Player::drainHealth(const std::shared_ptr<Creature> &attacker, int32_t damage) {
	if (PLAYER_SOUND_HEALTH_CHANGE >= static_cast<uint32_t>(uniform_random(1, 100))) {
		g_game().sendSingleSoundEffect(static_self_cast<Player>()->getPosition(), sex == PLAYERSEX_FEMALE ? SoundEffect_t::HUMAN_FEMALE_BARK : SoundEffect_t::HUMAN_MALE_BARK, getPlayer());
	}

	Creature::drainHealth(attacker, damage);
	sendStats();
}

void Player::drainMana(const std::shared_ptr<Creature> &attacker, int32_t manaLoss) {
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

	const uint8_t oldPercent = magLevelPercent;
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

void Player::addExperience(const std::shared_ptr<Creature> &target, uint64_t exp, bool sendText /* = false*/) {
	uint64_t currLevelExp = getExpForLevel(level);
	uint64_t nextLevelExp = getExpForLevel(level + 1);
	uint64_t rawExp = exp;
	if (currLevelExp >= nextLevelExp) {
		// player has reached max level
		levelPercent = 0;
		sendStats();
		return;
	}

	g_callbacks().executeCallback(EventCallback_t::playerOnGainExperience, &EventCallback::playerOnGainExperience, getPlayer(), target, std::ref(exp), std::ref(rawExp));

	g_events().eventPlayerOnGainExperience(static_self_cast<Player>(), target, exp, rawExp);
	if (exp == 0) {
		return;
	}

	const auto rate = exp / rawExp;
	const std::map<std::string, std::string> attrs({ { "player", getName() }, { "level", std::to_string(getLevel()) }, { "rate", std::to_string(rate) } });
	if (sendText) {
		g_metrics().addCounter("player_experience_raw", rawExp, attrs);
		g_metrics().addCounter("player_experience_actual", exp, attrs);
	} else {
		g_metrics().addCounter("player_experience_bonus_raw", rawExp, attrs);
		g_metrics().addCounter("player_experience_bonus_actual", exp, attrs);
	}

	// Hazard system experience
	const auto &monster = target && target->getMonster() ? target->getMonster() : nullptr;
	const bool handleHazardExperience = monster && monster->getHazard() && getHazardSystemPoints() > 0;
	if (handleHazardExperience) {
		exp += (exp * (1.75 * getHazardSystemPoints() * g_configManager().getFloat(HAZARD_EXP_BONUS_MULTIPLIER))) / 100.;
	}

	experience += exp;

	if (sendText) {
		std::string expString = fmt::format("{} experience point{}.", exp, (exp != 1 ? "s" : ""));
		if (isVip()) {
			uint8_t expPercent = g_configManager().getNumber(VIP_BONUS_EXP);
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
			for (const auto &spectator : spectators) {
				spectator->getPlayer()->sendTextMessage(message);
			}
		}
	}

	const uint32_t prevLevel = level;
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
		nextLevelExp = getExpForLevel(level + 1);
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
	g_callbacks().executeCallback(EventCallback_t::playerOnLoseExperience, &EventCallback::playerOnLoseExperience, getPlayer(), std::ref(exp));
	if (exp == 0) {
		return;
	}

	uint64_t lostExp = experience;
	experience = std::max<int64_t>(0, experience - exp);

	if (sendText) {
		lostExp -= experience;

		const std::string expString = fmt::format("You lost {} experience point{}.", lostExp, (lostExp != 1 ? "s" : ""));

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
			for (const auto &spectator : spectators) {
				spectator->getPlayer()->sendTextMessage(message);
			}
		}
	}

	const uint32_t oldLevel = level;
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

	const uint64_t nextLevelExp = Player::getExpForLevel(level + 1);
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

	const double_t result = round(((count * 100.) / nextLevelCount) * 100.) / 100.;
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

void Player::onTakeDamage(const std::shared_ptr<Creature> &attacker, int32_t damage) {
	// nothing here yet
}

void Player::onAttackedCreatureBlockHit(const BlockType_t &blockType) {
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
	const auto &itemLeft = inventory[CONST_SLOT_LEFT];
	if (itemLeft && itemLeft->getWeaponType() == WEAPON_SHIELD) {
		return true;
	}

	const auto &itemRight = inventory[CONST_SLOT_RIGHT];
	if (itemRight && itemRight->getWeaponType() == WEAPON_SHIELD) {
		return true;
	}
	return false;
}

bool Player::isPzLocked() const {
	return pzLocked;
}

BlockType_t Player::blockHit(const std::shared_ptr<Creature> &attacker, const CombatType_t &combatType, int32_t &damage, bool checkDefense, bool checkArmor, bool field) {
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

			const auto &item = inventory[slot];
			if (!item) {
				continue;
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

			//
			const ItemType &it = Item::items[item->getID()];
			if (it.abilities) {
				int totalAbsorbPercent = 0;
				const int16_t &absorbPercent = it.abilities->absorbPercent[combatTypeToIndex(combatType)];
				if (absorbPercent != 0) {
					totalAbsorbPercent += absorbPercent;
				}

				if (field) {
					const int16_t &fieldAbsorbPercent = it.abilities->fieldAbsorbPercent[combatTypeToIndex(combatType)];
					if (fieldAbsorbPercent != 0) {
						totalAbsorbPercent += fieldAbsorbPercent;
					}
				}

				if (totalAbsorbPercent > 0) {
					damage -= std::round(damage * (totalAbsorbPercent / 100.0));

					const auto charges = item->getAttribute<uint16_t>(ItemAttribute_t::CHARGES);
					if (charges != 0) {
						g_game().transformItem(item, item->getID(), charges - 1);
					}
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

void Player::doAttacking(uint32_t interval) {
	if (lastAttack == 0) {
		lastAttack = OTSYS_TIME() - getAttackSpeed() - 1;
	}

	if (hasCondition(CONDITION_PACIFIED)) {
		return;
	}

	const auto &attackedCreature = getAttackedCreature();
	if (!attackedCreature) {
		return;
	}

	if ((OTSYS_TIME() - lastAttack) >= getAttackSpeed()) {
		bool result = false;

		const auto &tool = getWeapon();
		const auto &weapon = g_weapons().getWeapon(tool);
		uint32_t delay = getAttackSpeed();
		bool classicSpeed = g_configManager().getBoolean(CLASSIC_ATTACK_SPEED);

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
			[playerId = getID()] { g_game().checkCreatureAttack(playerId); },
			__FUNCTION__
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

void Player::death(const std::shared_ptr<Creature> &lastHitCreature) {
	if (!g_configManager().getBoolean(TOGGLE_MOUNT_IN_PZ) && isMounted()) {
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
		for (const auto &[creatureId, damageInfo] : damageMap) {
			const auto &[total, ticks] = damageInfo;
			if ((OTSYS_TIME() - ticks) <= inFightTicks) {
				const auto &damageDealer = g_game().getPlayerByID(creatureId);
				if (damageDealer) {
					playerDmg += total;
					sumLevels += damageDealer->getLevel();
				} else {
					othersDmg += total;
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
		auto expLoss = static_cast<uint64_t>(experience * deathLossPercent);
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

			auto lostSkillTries = static_cast<uint32_t>(sumSkillTries * deathLossPercent);
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

		auto adventurerBlessingLevel = g_configManager().getNumber(ADVENTURERSBLESSING_LEVEL);
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
			auto condition = *it;
			// isSupress block to delete spells conditions (ensures that the player cannot, for example, reset the cooldown time of the familiar and summon several)
			if (condition->isPersistent() && condition->isRemovableOnDeath()) {
				it = conditions.erase(it);

				condition->endCondition(static_self_cast<Player>());
				onEndCondition(condition->getType());
			} else {
				++it;
			}
		}
		despawn();
	} else {
		setSkillLoss(true);

		auto it = conditions.begin(), end = conditions.end();
		while (it != end) {
			auto condition = *it;
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
}

bool Player::spawn() {
	setDead(false);

	const Position &pos = getLoginPosition();

	if (!g_game().map.placeCreature(pos, getPlayer(), false, true)) {
		return false;
	}

	const auto &spectators = Spectators().find<Creature>(position, true);
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
	const auto &tile = getTile();
	if (!tile) {
		return;
	}

	std::vector<int32_t> oldStackPosVector;

	const auto &spectators = Spectators().find<Creature>(tile->getPosition(), true);
	size_t i = 0;
	for (const auto &spectator : spectators) {
		if (const auto &player = spectator->getPlayer()) {
			oldStackPosVector.emplace_back(player->canSeeCreature(static_self_cast<Player>()) ? tile->getStackposOfCreature(player, getPlayer()) : -1);
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

bool Player::dropCorpse(const std::shared_ptr<Creature> &lastHitCreature, const std::shared_ptr<Creature> &mostDamageCreature, bool lastHitUnjustified, bool mostDamageUnjustified) {
	if (getZoneType() != ZONE_PVP || !Player::lastHitIsPlayer(lastHitCreature)) {
		return Creature::dropCorpse(lastHitCreature, mostDamageCreature, lastHitUnjustified, mostDamageUnjustified);
	}

	setDropLoot(true);
	return false;
}

std::shared_ptr<Item> Player::getCorpse(const std::shared_ptr<Creature> &lastHitCreature, const std::shared_ptr<Creature> &mostDamageCreature) {
	const auto &corpse = Creature::getCorpse(lastHitCreature, mostDamageCreature);
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

	safeCall([this] {
		addCondition(Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_INFIGHT, g_configManager().getNumber(PZ_LOCKED), 0));
	});
}

void Player::setDailyReward(uint8_t reward) {
	this->isDailyReward = reward;
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

uint64_t Player::getExpForLevel(const uint32_t level) {
	return (((level - 6ULL) * level + 17ULL) * level - 12ULL) / 6ULL * 100ULL;
}

uint16_t Player::getStaminaMinutes() const {
	return staminaMinutes;
}

void Player::sendItemsPrice() const {
	if (client) {
		client->sendItemsPrice();
	}
}

void Player::sendForgingData() const {
	if (client) {
		client->sendForgingData();
	}
}

bool Player::hasCapacity(const std::shared_ptr<Item> &item, uint32_t count) const {
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

ReturnValue Player::queryAdd(int32_t index, const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> &) {
	const auto &item = thing->getItem();
	if (item == nullptr) {
		g_logger().error("[Player::queryAdd] - Item is nullptr");
		return RETURNVALUE_NOTPOSSIBLE;
	}
	if (item->hasOwner() && !item->isOwner(getPlayer())) {
		return RETURNVALUE_ITEMISNOTYOURS;
	}

	const bool childIsOwner = hasBitSet(FLAG_CHILDISOWNER, flags);
	if (childIsOwner) {
		// a child container is querying the player, just check if enough capacity
		const bool skipLimit = hasBitSet(FLAG_NOLIMIT, flags);
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

	bool allowPutItemsOnAmmoSlot = g_configManager().getBoolean(ENABLE_PLAYER_PUT_ITEM_IN_AMMO_SLOT);
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
					const auto &leftItem = inventory[CONST_SLOT_LEFT];
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
				const auto &leftItem = inventory[CONST_SLOT_LEFT];
				const WeaponType_t type = item->getWeaponType();
				const WeaponType_t leftType = leftItem ? leftItem->getWeaponType() : WEAPON_NONE;
				if (leftItem && leftItem->getSlotPosition() & SLOTP_TWO_HAND) {
					ret = RETURNVALUE_DROPTWOHANDEDITEM;
				} else if (leftItem && item == leftItem && count == item->getItemCount()) {
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
					const WeaponType_t type = item->getWeaponType();
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
				const WeaponType_t type = item->getWeaponType();
				if (type == WEAPON_NONE || type == WEAPON_SHIELD || type == WEAPON_AMMO) {
					ret = RETURNVALUE_CANNOTBEDRESSED;
				} else {
					ret = RETURNVALUE_NOERROR;
				}
			} else if (inventory[CONST_SLOT_RIGHT]) {
				const auto &rightItem = inventory[CONST_SLOT_RIGHT];
				const WeaponType_t type = item->getWeaponType();
				const WeaponType_t rightType = rightItem ? rightItem->getWeaponType() : WEAPON_NONE;

				if (rightItem && rightItem->getSlotPosition() & SLOTP_TWO_HAND) {
					ret = RETURNVALUE_DROPTWOHANDEDITEM;
				} else if (rightItem && item == rightItem && count == item->getItemCount()) {
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
		const auto &inventoryItem = getInventoryItem(static_cast<Slots_t>(index));
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
	const auto &item = thing->getItem();
	if (item == nullptr) {
		maxQueryCount = 0;
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (index == INDEX_WHEREEVER) {
		uint32_t n = 0;
		for (int32_t slotIndex = CONST_SLOT_FIRST; slotIndex <= CONST_SLOT_LAST; ++slotIndex) {
			const auto &inventoryItem = inventory[slotIndex];
			if (inventoryItem) {
				if (const auto &subContainer = inventoryItem->getContainer()) {
					uint32_t queryCount = 0;
					subContainer->queryMaxCount(INDEX_WHEREEVER, item, item->getItemCount(), queryCount, flags);
					n += queryCount;

					// iterate through all items, including sub-containers (deep search)
					for (ContainerIterator it = subContainer->iterator(); it.hasNext(); it.advance()) {
						if (const auto &tmpContainer = (*it)->getContainer()) {
							queryCount = 0;
							tmpContainer->queryMaxCount(INDEX_WHEREEVER, item, item->getItemCount(), queryCount, flags);
							n += queryCount;
						}
					}
				} else if (inventoryItem->isStackable() && item->equals(inventoryItem) && inventoryItem->getItemCount() < inventoryItem->getStackSize()) {
					const uint32_t remainder = (inventoryItem->getStackSize() - inventoryItem->getItemCount());

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

		const auto &destThing = getThing(index);
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
	}
	return RETURNVALUE_NOERROR;
}

ReturnValue Player::queryRemove(const std::shared_ptr<Thing> &thing, uint32_t count, uint32_t flags, const std::shared_ptr<Creature> & /*= nullptr */) {
	const int32_t index = getThingIndex(thing);
	if (index == -1) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	const auto &item = thing->getItem();
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

std::shared_ptr<Cylinder> Player::queryDestination(int32_t &index, const std::shared_ptr<Thing> &thing, std::shared_ptr<Item> &destItem, uint32_t &flags) {
	if (index == 0 /*drop to capacity window*/ || index == INDEX_WHEREEVER) {
		destItem = nullptr;

		const auto &item = thing->getItem();
		if (!item) {
			return getPlayer();
		}

		const bool autoStack = !(flags & FLAG_IGNOREAUTOSTACK);
		const bool isStackable = item->isStackable();

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
							destItem = inventoryItem;
							return getPlayer();
						}
					}

					if (const auto &subContainer = inventoryItem->getContainer()) {
						containers.push_back(subContainer);
					}
				} else if (const auto &subContainer = inventoryItem->getContainer()) {
					containers.push_back(subContainer);
				}
			} else if (queryAdd(slotIndex, item, item->getItemCount(), flags) == RETURNVALUE_NOERROR) { // empty slot
				index = slotIndex;
				destItem = nullptr;
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
						destItem = nullptr;
						return tmpContainer;
					}

					n--;
				}

				for (const auto &tmpContainerItem : tmpContainer->getItemList()) {
					if (const auto &subContainer = tmpContainerItem->getContainer()) {
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
					destItem = tmpItem;
					return tmpContainer;
				}

				if (const auto &subContainer = tmpItem->getContainer()) {
					containers.push_back(subContainer);
				}

				n++;
			}

			if (n < tmpContainer->capacity() && tmpContainer->queryAdd(n, item, item->getItemCount(), flags) == RETURNVALUE_NOERROR) {
				index = n;
				destItem = nullptr;
				return tmpContainer;
			}
		}

		return getPlayer();
	}

	std::shared_ptr<Thing> destThing = getThing(index);
	if (destThing) {
		destItem = destThing->getItem();
	}

	std::shared_ptr<Item> item = thing->getItem();
	bool movingAmmoToQuiver = item && destItem && destItem->isQuiver() && item->isAmmo();
	// force shield any slot right to player cylinder
	if (index == CONST_SLOT_RIGHT && !movingAmmoToQuiver) {
		return getPlayer();
	}

	std::shared_ptr<Cylinder> subCylinder = std::dynamic_pointer_cast<Cylinder>(destThing);
	if (subCylinder) {
		index = INDEX_WHEREEVER;
		destItem = nullptr;
		return subCylinder;
	} else {
		return getPlayer();
	}
}

void Player::addThing(int32_t index, const std::shared_ptr<Thing> &thing) {
	if (!thing) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	if (index < CONST_SLOT_FIRST || index > CONST_SLOT_LAST) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const auto &item = thing->getItem();
	if (!item) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	item->setParent(static_self_cast<Player>());
	inventory[index] = item;

	// send to client
	sendInventoryItem(static_cast<Slots_t>(index), item);
}

void Player::updateThing(const std::shared_ptr<Thing> &thing, uint16_t itemId, uint32_t count) {
	int32_t index = getThingIndex(thing);
	if (index == -1) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const auto &item = thing->getItem();
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

void Player::replaceThing(uint32_t index, const std::shared_ptr<Thing> &thing) {
	if (index > CONST_SLOT_LAST) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const auto &oldItem = getInventoryItem(static_cast<Slots_t>(index));
	if (!oldItem) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	const auto &item = thing->getItem();
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

void Player::removeThing(const std::shared_ptr<Thing> &thing, uint32_t count) {
	const auto &item = thing->getItem();
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
			const auto newCount = static_cast<uint8_t>(std::max<int32_t>(0, item->getItemCount() - count));
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

int32_t Player::getThingIndex(const std::shared_ptr<Thing> &thing) const {
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
		const auto &item = inventory[i];
		if (!item) {
			continue;
		}

		if (item->getID() == itemId) {
			count += Item::countByType(item, subType);
		}

		if (const auto &container = item->getContainer()) {
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				if ((*it)->getID() == itemId) {
					count += Item::countByType(*it, subType);
				}
			}
		}
	}
	return count;
}

void Player::stashContainer(const StashContainerList &itemDict) {
	StashItemList stashItemDict; // ItemID - Count
	for (const auto &[item, itemCount] : itemDict) {
		if (!item) {
			continue;
		}

		stashItemDict[item->getID()] = itemCount;
	}

	for (const auto &[itemId, itemCount] : stashItems) {
		if (!stashItemDict[itemId]) {
			stashItemDict[itemId] = itemCount;
		} else {
			stashItemDict[itemId] += itemCount;
		}
	}

	if (getStashSize(stashItemDict) > g_configManager().getNumber(STASH_ITEMS)) {
		sendCancelMessage("You don't have capacity in the Supply Stash to stow all this item->");
		return;
	}

	uint32_t totalStowed = 0;
	std::ostringstream retString;
	uint16_t refreshDepotSearchOnItem = 0;
	for (const auto &[item, itemCount] : itemDict) {
		if (!item) {
			continue;
		}
		const uint16_t iteratorCID = item->getID();
		if (g_game().internalRemoveItem(item, itemCount) == RETURNVALUE_NOERROR) {
			addItemOnStash(iteratorCID, itemCount);
			totalStowed += itemCount;
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

bool Player::removeItemOfType(uint16_t itemId, uint32_t amount, int32_t subType, bool ignoreEquipped /* = false*/) const {
	if (amount == 0) {
		return true;
	}

	std::vector<std::shared_ptr<Item>> itemList;

	uint32_t count = 0;
	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; i++) {
		const auto &item = inventory[i];
		if (!item) {
			continue;
		}

		if (!ignoreEquipped && item->getID() == itemId) {
			const uint32_t itemCount = Item::countByType(item, subType);
			if (itemCount == 0) {
				continue;
			}

			itemList.emplace_back(item);

			count += itemCount;
			if (count >= amount) {
				g_game().internalRemoveItems(itemList, amount, Item::items[itemId].stackable);
				return true;
			}
		} else if (const auto &container = item->getContainer()) {
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				const auto &containerItem = *it;
				if (containerItem->getID() == itemId) {
					const uint32_t itemCount = Item::countByType(containerItem, subType);
					if (itemCount == 0) {
						continue;
					}

					itemList.emplace_back(containerItem);

					count += itemCount;
					const auto stackable = Item::items[itemId].stackable;
					// If the amount of items in the backpack is equal to or greater than the amount
					// It will remove items and stop the iteration
					if (count >= amount) {
						g_game().internalRemoveItems(itemList, amount, stackable);
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
	     const auto &[stashItemId, itemCount] : stashToSend) {
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

void Player::addItemOnStash(uint16_t itemId, uint32_t amount) {
	const auto it = stashItems.find(itemId);
	if (it != stashItems.end()) {
		stashItems[itemId] += amount;
		return;
	}

	stashItems[itemId] = amount;
}

uint32_t Player::getStashItemCount(uint16_t itemId) const {
	const auto it = stashItems.find(itemId);
	if (it != stashItems.end()) {
		return it->second;
	}
	return 0;
}

bool Player::withdrawItem(uint16_t itemId, uint32_t amount) {
	const auto it = stashItems.find(itemId);
	if (it != stashItems.end()) {
		if (it->second > amount) {
			stashItems[itemId] -= amount;
		} else if (it->second == amount) {
			stashItems.erase(itemId);
		} else {
			return false;
		}
		return true;
	}
	return false;
}

StashItemList Player::getStashItems() const {
	return stashItems;
}

uint32_t Player::getBaseCapacity() const {
	if (hasFlag(PlayerFlags_t::CannotPickupItem)) {
		return 0;
	}
	if (hasFlag(PlayerFlags_t::HasInfiniteCapacity)) {
		return std::numeric_limits<uint32_t>::max();
	}
	return capacity;
}

uint32_t Player::getCapacity() const {
	if (hasFlag(PlayerFlags_t::CannotPickupItem)) {
		return 0;
	}
	if (hasFlag(PlayerFlags_t::HasInfiniteCapacity)) {
		return std::numeric_limits<uint32_t>::max();
	}
	return capacity + bonusCapacity + varStats[STAT_CAPACITY] + (m_wheelPlayer->getStat(WheelStat_t::CAPACITY) * 100);
}

uint32_t Player::getBonusCapacity() const {
	if (hasFlag(PlayerFlags_t::CannotPickupItem) || hasFlag(PlayerFlags_t::HasInfiniteCapacity)) {
		return std::numeric_limits<uint32_t>::max();
	}
	return bonusCapacity;
}

uint32_t Player::getFreeCapacity() const {
	if (hasFlag(PlayerFlags_t::CannotPickupItem)) {
		return 0;
	} else if (hasFlag(PlayerFlags_t::HasInfiniteCapacity)) {
		return std::numeric_limits<uint32_t>::max();
	} else {
		return std::max<int32_t>(0, getCapacity() - inventoryWeight);
	}
}

ItemsTierCountList Player::getInventoryItemsId(bool ignoreStoreInbox /* false */) const {
	ItemsTierCountList itemMap;
	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; i++) {
		const auto &item = inventory[i];
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

/*******************************************************************************
 * Hazard system
 ******************************************************************************/
// Parser

void Player::parseAttackRecvHazardSystem(CombatDamage &damage, const std::shared_ptr<Monster> &monster) {
	if (!monster || !monster->getHazard()) {
		return;
	}

	if (!g_configManager().getBoolean(TOGGLE_HAZARDSYSTEM)) {
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
	auto critChance = g_configManager().getNumber(HAZARD_CRITICAL_CHANCE);
	// Critical chance
	if (monster->getHazardSystemCrit() && (lastHazardSystemCriticalHit + g_configManager().getNumber(HAZARD_CRITICAL_INTERVAL)) <= OTSYS_TIME() && chance <= critChance && !damage.critical) {
		damage.critical = true;
		damage.extension = true;
		damage.exString = "(Hazard)";

		stage = (points - 1) * static_cast<uint16_t>(g_configManager().getNumber(HAZARD_CRITICAL_MULTIPLIER));
		damage.primary.value += static_cast<int32_t>(std::ceil((static_cast<double>(damage.primary.value) * (5000 + stage)) / 10000));
		damage.secondary.value += static_cast<int32_t>(std::ceil((static_cast<double>(damage.secondary.value) * (5000 + stage)) / 10000));
		lastHazardSystemCriticalHit = OTSYS_TIME();
	}

	// To prevent from punish the player twice with critical + damage boost, just uncomment code from the if
	if (monster->getHazardSystemDamageBoost() /* && !damage.critical*/) {
		stage = points * static_cast<uint16_t>(g_configManager().getNumber(HAZARD_DAMAGE_MULTIPLIER));
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

void Player::parseAttackDealtHazardSystem(CombatDamage &damage, const std::shared_ptr<Monster> &monster) const {
	if (!g_configManager().getBoolean(TOGGLE_HAZARDSYSTEM)) {
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
		stage = points * g_configManager().getNumber(HAZARD_DODGE_MULTIPLIER);
		auto chance = static_cast<uint16_t>(normal_random(1, 10000));
		if (chance <= stage) {
			damage.primary.value = 0;
			damage.secondary.value = 0;
			return;
		}
	}
	if (monster->getHazardSystemDefenseBoost()) {
		stage = points * static_cast<uint16_t>(g_configManager().getNumber(HAZARD_DEFENSE_MULTIPLIER));
		if (stage != 0) {
			damage.exString = fmt::format("(hazard -{}%)", stage / 100.);
			damage.primary.value -= static_cast<int32_t>(std::ceil((static_cast<double>(damage.primary.value) * stage) / 10000));
			if (damage.secondary.value != 0) {
				damage.secondary.value -= static_cast<int32_t>(std::ceil((static_cast<double>(damage.secondary.value) * stage) / 10000));
			}
		}
	}
}

// Points get:
// Points increase:
void Player::setHazardSystemPoints(int32_t count) {
	if (!g_configManager().getBoolean(TOGGLE_HAZARDSYSTEM)) {
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

uint16_t Player::getHazardSystemPoints() const {
	const int32_t points = getStorageValue(STORAGEVALUE_HAZARDCOUNT);
	if (points <= 0) {
		return 0;
	}
	return static_cast<uint16_t>(std::max<int32_t>(0, std::min<int32_t>(0xFFFF, points)));
}

// Concoction system

void Player::updateConcoction(uint16_t itemId, uint16_t timeLeft) {
	if (timeLeft == 0) {
		activeConcoctions.erase(itemId);
	} else {
		activeConcoctions[itemId] = timeLeft;
	}
}

std::map<uint16_t, uint16_t> Player::getActiveConcoctions() const {
	return activeConcoctions;
}

bool Player::isConcoctionActive(Concoction_t concotion) const {
	const auto itemId = static_cast<uint16_t>(concotion);
	if (!activeConcoctions.contains(itemId)) {
		return false;
	}
	const auto timeLeft = activeConcoctions.at(itemId);
	return timeLeft > 0;
}

bool Player::checkAutoLoot(bool isBoss) const {
	if (!g_configManager().getBoolean(AUTOLOOT)) {
		return false;
	}
	if (g_configManager().getBoolean(VIP_SYSTEM_ENABLED) && g_configManager().getBoolean(VIP_AUTOLOOT_VIP_ONLY) && !isVip()) {
		return false;
	}

	auto featureKV = kv()->scoped("features")->get("autoloot");
	auto value = featureKV.has_value() ? featureKV->getNumber() : 0;
	if (value == 2) {
		return true;
	} else if (value == 1) {
		return !isBoss;
	}
	return false;
}

QuickLootFilter_t Player::getQuickLootFilter() const {
	return quickLootFilter;
}

std::vector<std::shared_ptr<Item>> Player::getInventoryItemsFromId(uint16_t itemId, bool ignore /*= true*/) const {
	std::vector<std::shared_ptr<Item>> itemVector;
	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		const auto &item = inventory[i];
		if (!item) {
			continue;
		}

		if (!ignore && item->getID() == itemId) {
			itemVector.emplace_back(item);
		}

		if (const auto &container = item->getContainer()) {
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				const auto &containerItem = *it;
				if (containerItem->getID() == itemId) {
					itemVector.emplace_back(containerItem);
				}
			}
		}
	}

	return itemVector;
}

std::array<double_t, COMBAT_COUNT> Player::getFinalDamageReduction() const {
	std::array<double_t, COMBAT_COUNT> combatReductionArray {};
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
		const auto &item = inventory[slot];
		if (item) {
			calculateDamageReductionFromItem(combatReductionArray, item);
		}
	}
}

void Player::calculateDamageReductionFromItem(std::array<double_t, COMBAT_COUNT> &combatReductionArray, const std::shared_ptr<Item> &item) const {
	for (uint16_t combatTypeIndex = 0; combatTypeIndex < COMBAT_COUNT; combatTypeIndex++) {
		updateDamageReductionFromItemImbuement(combatReductionArray, item, combatTypeIndex);
		updateDamageReductionFromItemAbility(combatReductionArray, item, combatTypeIndex);
	}
}

void Player::updateDamageReductionFromItemImbuement(
	std::array<double_t, COMBAT_COUNT> &combatReductionArray, const std::shared_ptr<Item> &item, uint16_t combatTypeIndex
) const {
	for (uint8_t imbueSlotId = 0; imbueSlotId < item->getImbuementSlot(); imbueSlotId++) {
		ImbuementInfo imbuementInfo;
		if (item->getImbuementInfo(imbueSlotId, &imbuementInfo) && imbuementInfo.imbuement) {
			const int16_t imbuementAbsorption = imbuementInfo.imbuement->absorbPercent[combatTypeIndex];
			if (imbuementAbsorption != 0) {
				combatReductionArray[combatTypeIndex] = calculateDamageReduction(combatReductionArray[combatTypeIndex], imbuementAbsorption);
			}
		}
	}
}

void Player::updateDamageReductionFromItemAbility(
	std::array<double_t, COMBAT_COUNT> &combatReductionArray, const std::shared_ptr<Item> &item, uint16_t combatTypeIndex
) const {
	if (!item) {
		return;
	}

	const ItemType &itemType = Item::items[item->getID()];
	if (itemType.abilities) {
		const int16_t elementReduction = itemType.abilities->absorbPercent[combatTypeIndex];
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
			const auto &item = *it;
			(itemMap[item->getID()])[item->getTier()] += Item::countByType(item, -1);
		}
	}

	return itemMap;
}

ItemsTierCountList Player::getDepotChestItemsId() const {
	ItemsTierCountList itemMap;

	for (const auto &[index, depot] : depotChests) {
		const auto &container = depot->getContainer();
		for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
			const auto &item = *it;
			(itemMap[item->getID()])[item->getTier()] += Item::countByType(item, -1);
		}
	}

	return itemMap;
}

ItemsTierCountList Player::getDepotInboxItemsId() const {
	ItemsTierCountList itemMap;

	const auto &inbox = getInbox();
	const auto &container = inbox->getContainer();
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
		const auto &item = inventory[i];
		if (!item) {
			continue;
		}

		// Only get equiped items if ignored equipped is false
		if (!ignoreEquiped) {
			itemVector.emplace_back(item);
		}
		if (const auto &container = item->getContainer()) {
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				if (ignoreItemWithTier && (*it)->getTier() > 0) {
					continue;
				}

				itemVector.emplace_back(*it);
			}
		}
	}

	return itemVector;
}

std::vector<std::shared_ptr<Item>> Player::getEquippedAugmentItemsByType(Augment_t augmentType) const {
	std::vector<std::shared_ptr<Item>> equippedAugmentItemsByType;
	auto equippedAugmentItems = getEquippedItems();

	for (const auto &item : equippedAugmentItems) {
		for (const auto &augment : item->getAugments()) {
			if (augment->type == augmentType) {
				equippedAugmentItemsByType.emplace_back(item);
			}
		}
	}

	return equippedAugmentItemsByType;
}

std::vector<std::shared_ptr<Item>> Player::getEquippedAugmentItems() const {
	std::vector<std::shared_ptr<Item>> equippedAugmentItems;
	auto equippedItems = getEquippedItems();

	for (const auto &item : equippedItems) {
		if (item->getAugments().empty()) {
			continue;
		}
		equippedAugmentItems.emplace_back(item);
	}

	return equippedAugmentItems;
}

std::vector<std::shared_ptr<Item>> Player::getEquippedItems() const {
	static const std::vector valid_slots {
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
		const auto &item = inventory[slot];
		if (!item) {
			continue;
		}

		valid_items.emplace_back(item);
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
		if (item->getID() != ITEM_GOLD_POUCH) {
			if (!item->hasMarketAttributes()) {
				continue;
			}

			if (const auto &container = item->getContainer()) {
				if (!container->empty()) {
					continue;
				}
			}
		}

		countMap[item->getID()] += item->getItemCount();
	}

	return countMap;
}

void Player::getAllItemTypeCountAndSubtype(std::map<uint32_t, uint32_t> &countMap) const {
	for (const auto &item : getAllInventoryItems()) {
		const uint16_t itemId = item->getID();
		if (Item::items[itemId].isFluidContainer()) {
			countMap[static_cast<uint32_t>(itemId) | (item->getAttribute<uint32_t>(ItemAttribute_t::FLUIDTYPE)) << 16] += item->getItemCount();
		} else {
			countMap[static_cast<uint32_t>(itemId)] += item->getItemCount();
		}
	}
}

std::shared_ptr<Item> Player::getForgeItemFromId(uint16_t itemId, uint8_t tier) const {
	for (const auto &item : getAllInventoryItems(true)) {
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

// TODO: review this function
bool Player::updateSaleShopList(const std::shared_ptr<Item> &item) {
	const uint16_t itemId = item->getID();
	if (!itemId || !item) {
		return true;
	}

	g_dispatcher().addEvent([creatureId = getID()] { g_game().updatePlayerSaleItems(creatureId); }, __FUNCTION__);
	scheduledSaleUpdate = true;
	return true;
}

bool Player::hasShopItemForSale(uint16_t itemId, uint8_t subType) const {
	if (!shopOwner) {
		return false;
	}

	const ItemType &itemType = Item::items[itemId];
	const auto &shoplist = shopOwner->getShopItemVector(getGUID());
	return std::ranges::any_of(shoplist, [&](const ShopBlock &shopBlock) {
		return shopBlock.itemId == itemId && shopBlock.itemBuyPrice != 0 && (!itemType.isFluidContainer() || shopBlock.itemSubType == subType);
	});
}

void Player::internalAddThing(const std::shared_ptr<Thing> &thing) {
	internalAddThing(0, thing);
}

void Player::internalAddThing(uint32_t index, const std::shared_ptr<Thing> &thing) {
	if (!thing) {
		return;
	}

	const auto &item = thing->getItem();
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

// safe-trade functions

void Player::setTradeState(TradeState_t state) {
	tradeState = state;
}

TradeState_t Player::getTradeState() const {
	return tradeState;
}

std::shared_ptr<Item> Player::getTradeItem() {
	return tradeItem;
}

// shop functions

void Player::setShopOwner(std::shared_ptr<Npc> owner) {
	shopOwner = std::move(owner);
}

std::shared_ptr<Npc> Player::getShopOwner() const {
	return shopOwner;
}

bool Player::setFollowCreature(const std::shared_ptr<Creature> &creature) {
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

bool Player::setAttackedCreature(const std::shared_ptr<Creature> &creature) {
	if (!Creature::setAttackedCreature(creature)) {
		sendCancelTarget();
		return false;
	}

	const auto &followCreature = getFollowCreature();
	if (chaseMode && creature) {
		if (followCreature != creature) {
			setFollowCreature(creature);
		}
	} else if (followCreature) {
		setFollowCreature(nullptr);
	}

	if (creature) {
		g_dispatcher().addEvent([creatureId = getID()] { g_game().checkCreatureAttack(creatureId); }, __FUNCTION__);
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

uint64_t Player::getGainedExperience(const std::shared_ptr<Creature> &attacker) const {
	if (g_configManager().getBoolean(EXPERIENCE_FROM_PLAYERS)) {
		const auto &attackerPlayer = attacker->getPlayer();
		if (attackerPlayer && attackerPlayer.get() != this && skillLoss && std::abs(static_cast<int32_t>(attackerPlayer->getLevel() - level)) <= g_configManager().getNumber(EXP_FROM_PLAYERS_LEVEL_RANGE)) {
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
	const bool prevChaseMode = chaseMode;
	chaseMode = mode;
	const auto &attackedCreature = getAttackedCreature();
	const auto &followCreature = getFollowCreature();

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

void Player::setFightMode(FightMode_t mode) {
	fightMode = mode;
}

void Player::setSecureMode(bool mode) {
	secureMode = mode;
}

Faction_t Player::getFaction() const {
	return faction;
}

void Player::setFaction(Faction_t factionId) {
	faction = factionId;
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
		const auto &fearedCondition = getCondition(CONDITION_FEARED);
		if (fearedCondition) {
			fearedCondition->executeCondition(static_self_cast<Player>(), 0);
		}
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
		const auto &item = inventory[i];
		if (item) {
			const auto &curLight = item->getLightInfo();

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

void Player::onCombatRemoveCondition(const std::shared_ptr<Condition> &condition) {
	if (!condition) {
		return;
	}

	// Creature::onCombatRemoveCondition(condition);
	if (condition->getId() > 0) {
		// Means the condition is from an item, id == slot
		if (g_game().getWorldType() == WORLD_TYPE_PVP_ENFORCED) {
			const auto &item = getInventoryItem(static_cast<Slots_t>(condition->getId()));
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

void Player::onAttackedCreature(const std::shared_ptr<Creature> &target) {
	Creature::onAttackedCreature(target);

	if (!target) {
		return;
	}

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

	const auto &targetPlayer = target->getPlayer();
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

void Player::onAttackedCreatureDrainHealth(const std::shared_ptr<Creature> &target, int32_t points) {
	Creature::onAttackedCreatureDrainHealth(target, points);

	if (target) {
		if (m_party && !Combat::isPlayerCombat(target)) {
			const auto &tmpMonster = target->getMonster();
			if (tmpMonster && tmpMonster->isHostile()) {
				// We have fulfilled a requirement for shared experience
				m_party->updatePlayerTicks(static_self_cast<Player>(), points);
			}
		}
	}
}

void Player::onTargetCreatureGainHealth(const std::shared_ptr<Creature> &target, int32_t points) {
	if (target && m_party) {
		std::shared_ptr<Player> tmpPlayer = nullptr;

		if (isPartner(tmpPlayer) && (tmpPlayer != getPlayer())) {
			tmpPlayer = target->getPlayer();
		} else if (const auto &targetMaster = target->getMaster()) {
			if (const auto &targetMasterPlayer = targetMaster->getPlayer()) {
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
				const auto &condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_INFIGHT, g_configManager().getNumber(WHITE_SKULL_TIME), 0);
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
			const std::string message = "You succesfully finished your hunting task. Your reward is ready to be claimed!";
			sendTextMessage(MESSAGE_STATUS, message);
		}
		reloadTaskSlot(taskSlot->id);
	}
}

void Player::addBestiaryKill(const std::shared_ptr<MonsterType> &mType) {
	if (mType->isBoss()) {
		return;
	}
	uint32_t kills = g_configManager().getNumber(BESTIARY_KILL_MULTIPLIER);
	if (isConcoctionActive(Concoction_t::BestiaryBetterment)) {
		kills *= 2;
	}
	g_iobestiary().addBestiaryKill(getPlayer(), mType, kills);
}

void Player::addBosstiaryKill(const std::shared_ptr<MonsterType> &mType) {
	if (!mType->isBoss()) {
		return;
	}
	uint32_t kills = g_configManager().getNumber(BOSSTIARY_KILL_MULTIPLIER);
	if (g_ioBosstiary().getBoostedBossId() == mType->info.raceid) {
		kills *= g_configManager().getNumber(BOOSTED_BOSS_KILL_BONUS);
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
	const auto &mType = monster->getMonsterType();
	if (mType == nullptr) {
		g_logger().error("[{}] Monster type is null.", __FUNCTION__);
		return false;
	}
	addHuntingTaskKill(mType);
	addBestiaryKill(mType);
	addBosstiaryKill(mType);
	return false;
}

void Player::gainExperience(uint64_t gainExp, const std::shared_ptr<Creature> &target) {
	if (hasFlag(PlayerFlags_t::NotGainExperience) || gainExp == 0 || staminaMinutes == 0) {
		return;
	}

	addExperience(target, gainExp, true);
}

void Player::onGainExperience(uint64_t gainExp, const std::shared_ptr<Creature> &target) {
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

void Player::onGainSharedExperience(uint64_t gainExp, const std::shared_ptr<Creature> &target) {
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

bool Player::lastHitIsPlayer(const std::shared_ptr<Creature> &lastHitCreature) {
	if (!lastHitCreature) {
		return false;
	}

	if (lastHitCreature->getPlayer()) {
		return true;
	}

	const auto &lastHitMaster = lastHitCreature->getMaster();
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
		soul += std::min<int32_t>(soulChange * g_configManager().getFloat(RATE_SOUL_REGEN), vocation->getSoulMax() - soul);
	} else {
		soul = std::max<int32_t>(0, soul + soulChange);
	}

	sendStats();
}

bool Player::canWear(uint16_t lookType, uint8_t addons) const {
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && lookType != 0 && !g_game().isLookTypeRegistered(lookType)) {
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

	for (const auto &outfitEntry : outfits) {
		if (outfitEntry.lookType != lookType) {
			continue;
		}
		return (outfitEntry.addons & addons) == addons;
	}
	return false;
}

void Player::genReservedStorageRange() {
	// generate outfits range
	uint32_t outfits_key = PSTRG_OUTFITS_RANGE_START;
	for (const auto &entry : outfits) {
		storageMap[++outfits_key] = (entry.lookType << 16) | entry.addons;
	}
	// generate familiars range
	uint32_t familiar_key = PSTRG_FAMILIARS_RANGE_START;
	for (const auto &entry : familiars) {
		storageMap[++familiar_key] = (entry.lookType << 16);
	}
}

void Player::setSpecialMenuAvailable(bool supplyStashBool, bool marketMenuBool, bool depotSearchBool) {
	// Closing depot search when player have special container disabled and it's still open.
	if (isDepotSearchOpen() && !depotSearchBool && depotSearch) {
		depotSearchOnItem = { 0, 0 };
		sendCloseDepotSearch();
	}

	// Menu option 'stow, stow container ...'
	// Menu option 'show in market'
	// Menu option to open depot search
	supplyStash = supplyStashBool;
	marketMenu = marketMenuBool;
	depotSearch = depotSearchBool;
	if (client) {
		client->sendSpecialContainersAvailable();
	}
}

void Player::addOutfit(uint16_t lookType, uint8_t addons) {
	for (auto &outfitEntry : outfits) {
		if (outfitEntry.lookType == lookType) {
			outfitEntry.addons |= addons;
			return;
		}
	}
	outfits.emplace_back(lookType, addons);
}

bool Player::removeOutfit(uint16_t lookType) {
	for (auto it = outfits.begin(), end = outfits.end(); it != end; ++it) {
		const auto &entry = *it;
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

	if (std::ranges::any_of(familiars, [&](const FamiliarEntry &familiarEntry) {
			return familiarEntry.lookType == lookType;
		})) {
		return true;
	}

	return false;
}

void Player::addFamiliar(uint16_t lookType) {
	if (std::ranges::none_of(familiars, [&](const FamiliarEntry &familiarEntry) {
			return familiarEntry.lookType == lookType;
		})) {
		familiars.emplace_back(lookType);
	}
}

bool Player::removeFamiliar(uint16_t lookType) {
	const auto initialSize = familiars.size();
	std::erase_if(familiars, [lookType](const FamiliarEntry &entry) {
		return entry.lookType == lookType;
	});
	return familiars.size() != initialSize;
}

bool Player::getFamiliar(const std::shared_ptr<Familiar> &familiar) const {
	if (group->access) {
		return true;
	}

	if (familiar->premium && !isPremium()) {
		return false;
	}

	if (std::ranges::any_of(familiars, [&](const FamiliarEntry &familiarEntry) {
			return familiarEntry.lookType == familiar->lookType;
		})) {
		return true;
	}

	if (!familiar->unlocked) {
		return false;
	}

	return true;
}

void Player::setFamiliarLooktype(uint16_t familiarLooktype) {
	this->defaultOutfit.lookFamiliarsType = familiarLooktype;
}

bool Player::canLogout() {
	if (isConnecting) {
		return false;
	}

	const auto &tile = getTile();
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

bool Player::hasKilled(const std::shared_ptr<Player> &player) const {
	return std::ranges::any_of(unjustifiedKills, [&](const auto &kill) {
		return kill.target == player->getGUID() && (getTimeNow() - kill.time) < g_configManager().getNumber(ORANGE_SKULL_DURATION) * 24 * 60 * 60 && kill.unavenged;
	});
}

size_t Player::getMaxDepotItems() const {
	if (group->maxDepotItems != 0) {
		return group->maxDepotItems;
	}
	if (isPremium()) {
		return g_configManager().getNumber(PREMIUM_DEPOT_LIMIT);
	}
	return g_configManager().getNumber(FREE_DEPOT_LIMIT);
}

// tile
// send methods
// tile
// send methods

void Player::sendAddTileItem(const std::shared_ptr<Tile> &itemTile, const Position &pos, const std::shared_ptr<Item> &item) {
	if (client) {
		int32_t stackpos = itemTile->getStackposOfItem(static_self_cast<Player>(), item);
		if (stackpos != -1) {
			client->sendAddTileItem(pos, stackpos, item);
		}
	}
}

void Player::sendUpdateTileItem(const std::shared_ptr<Tile> &updateTile, const Position &pos, const std::shared_ptr<Item> &item) {
	if (client) {
		int32_t stackpos = updateTile->getStackposOfItem(static_self_cast<Player>(), item);
		if (stackpos != -1) {
			client->sendUpdateTileItem(pos, stackpos, item);
		}
	}
}

void Player::sendRemoveTileThing(const Position &pos, int32_t stackpos) const {
	if (stackpos != -1 && client) {
		client->sendRemoveTileThing(pos, stackpos);
	}
}

void Player::sendUpdateTileCreature(const std::shared_ptr<Creature> &creature) {
	if (client) {
		client->sendUpdateTileCreature(creature->getPosition(), creature->getTile()->getClientIndexOfCreature(static_self_cast<Player>(), creature), creature);
	}
}

std::string Player::getObjectPronoun() const {
	return getPlayerObjectPronoun(pronoun, sex, name);
}

std::string Player::getSubjectPronoun() const {
	return getPlayerSubjectPronoun(pronoun, sex, name);
}

std::string Player::getPossessivePronoun() const {
	return getPlayerPossessivePronoun(pronoun, sex, name);
}

std::string Player::getReflexivePronoun() const {
	return getPlayerReflexivePronoun(pronoun, sex, name);
}

std::string Player::getSubjectVerb(bool past) const {
	return getVerbForPronoun(pronoun, past);
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

Skulls_t Player::getSkullClient(const std::shared_ptr<Creature> &creature) {
	if (!creature || g_game().getWorldType() != WORLD_TYPE_PVP) {
		return SKULL_NONE;
	}

	const auto &player = creature->getPlayer();
	if (player && player->getSkull() == SKULL_NONE) {
		if (player.get() == this) {
			if (std::ranges::any_of(unjustifiedKills, [&](const auto &kill) {
					return kill.unavenged && (getTimeNow() - kill.time) < g_configManager().getNumber(ORANGE_SKULL_DURATION) * 24 * 60 * 60;
				})) {
				return SKULL_ORANGE;
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

int64_t Player::getSkullTicks() const {
	return skullTicks;
}

void Player::setSkullTicks(int64_t ticks) {
	skullTicks = ticks;
}

bool Player::hasAttacked(const std::shared_ptr<Player> &attacked) const {
	if (hasFlag(PlayerFlags_t::NotGainInFight) || !attacked) {
		return false;
	}

	return attackedSet.contains(attacked->guid);
}

void Player::addAttacked(const std::shared_ptr<Player> &attacked) {
	if (hasFlag(PlayerFlags_t::NotGainInFight) || !attacked || attacked == getPlayer()) {
		return;
	}

	attackedSet.emplace(attacked->guid);
}

void Player::removeAttacked(const std::shared_ptr<Player> &attacked) {
	if (!attacked || attacked == getPlayer()) {
		return;
	}

	attackedSet.erase(attacked->guid);
}

void Player::clearAttacked() {
	attackedSet.clear();
}

void Player::addUnjustifiedDead(const std::shared_ptr<Player> &attacked) {
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
		if (dayKills >= 2 * g_configManager().getNumber(DAY_KILLS_TO_RED) || weekKills >= 2 * g_configManager().getNumber(WEEK_KILLS_TO_RED) || monthKills >= 2 * g_configManager().getNumber(MONTH_KILLS_TO_RED)) {
			setSkull(SKULL_BLACK);
			// start black skull time
			skullTicks = static_cast<int64_t>(g_configManager().getNumber(BLACK_SKULL_DURATION)) * 24 * 60 * 60;
		} else if (dayKills >= g_configManager().getNumber(DAY_KILLS_TO_RED) || weekKills >= g_configManager().getNumber(WEEK_KILLS_TO_RED) || monthKills >= g_configManager().getNumber(MONTH_KILLS_TO_RED)) {
			setSkull(SKULL_RED);
			// reset red skull time
			skullTicks = static_cast<int64_t>(g_configManager().getNumber(RED_SKULL_DURATION)) * 24 * 60 * 60;
		}
	}

	sendUnjustifiedPoints();
}

void Player::sendCreatureEmblem(const std::shared_ptr<Creature> &creature) const {
	if (client) {
		client->sendCreatureEmblem(creature);
	}
}

void Player::sendCreatureSkull(const std::shared_ptr<Creature> &creature) const {
	if (client) {
		client->sendCreatureSkull(creature);
	}
}

void Player::checkSkullTicks(int64_t ticks) {
	const int64_t newTicks = skullTicks - ticks;
	if (newTicks < 0) {
		skullTicks = 0;
	} else {
		skullTicks = newTicks;
	}

	if ((skull == SKULL_RED || skull == SKULL_BLACK) && skullTicks < 1 && !hasCondition(CONDITION_INFIGHT)) {
		setSkull(SKULL_NONE);
	}
}

void Player::updateBaseSpeed() {
	if (baseSpeed >= PLAYER_MAX_SPEED) {
		return;
	}

	if (!hasFlag(PlayerFlags_t::SetMaxSpeed)) {
		baseSpeed = static_cast<uint16_t>(vocation->getBaseSpeed() + (level - 1));
	} else {
		baseSpeed = PLAYER_MAX_SPEED;
	}
}

bool Player::isPromoted() const {
	const uint16_t promotedVocation = g_vocations().getPromotedVocation(vocation->getId());
	return promotedVocation == VOCATION_NONE && vocation->getId() != promotedVocation;
}

uint32_t Player::getAttackSpeed() const {
	bool onFistAttackSpeed = g_configManager().getBoolean(TOGGLE_ATTACK_SPEED_ONFIST);
	uint32_t MAX_ATTACK_SPEED = g_configManager().getNumber(MAX_SPEED_ATTACKONFIST);
	if (onFistAttackSpeed) {
		uint32_t baseAttackSpeed = vocation->getAttackSpeed();
		uint32_t skillLevel = getSkillLevel(SKILL_FIST);
		uint32_t attackSpeed = baseAttackSpeed - (skillLevel * g_configManager().getNumber(MULTIPLIER_ATTACKONFIST));

		if (attackSpeed < MAX_ATTACK_SPEED) {
			attackSpeed = MAX_ATTACK_SPEED;
		}

		return attackSpeed;
	} else {
		return vocation->getAttackSpeed();
	}
}

double Player::getLostPercent() const {
	int32_t blessingCount = 0;
	const uint8_t maxBlessing = (operatingSystem == CLIENTOS_NEW_WINDOWS || operatingSystem == CLIENTOS_NEW_MAC) ? 8 : 6;
	for (int i = 2; i <= maxBlessing; i++) {
		if (hasBlessing(i)) {
			blessingCount++;
		}
	}

	int32_t deathLosePercent = g_configManager().getNumber(DEATH_LOSE_PERCENT);
	if (deathLosePercent != -1) {
		if (isPromoted()) {
			deathLosePercent -= 3;
		}

		deathLosePercent -= blessingCount;
		return std::max<int32_t>(0, deathLosePercent) / 100.;
	}

	double lossPercent;
	if (level >= 24) {
		const double tmpLevel = level + (levelPercent / 100.);
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

[[nodiscard]] const std::string &Player::getGuildNick() const {
	return guildNick;
}

void Player::setGuildNick(std::string nick) {
	guildNick = std::move(nick);
}

bool Player::isInWar(const std::shared_ptr<Player> &player) const {
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
	return std::ranges::find(guildWarVector, guildId) != guildWarVector.end();
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
	const absl::uint128 totalMana = vocation->getTotalMana(level) + spent;
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

int32_t Player::getMaxHealth() const {
	return std::max<int32_t>(1, healthMax + varStats[STAT_MAXHITPOINTS] + m_wheelPlayer->getStat(WheelStat_t::HEALTH));
}

uint32_t Player::getMaxMana() const {
	return std::max<int32_t>(0, manaMax + varStats[STAT_MAXMANAPOINTS] + m_wheelPlayer->getStat(WheelStat_t::MANA));
}

bool Player::hasExtraSwing() {
	return lastAttack > 0 && !checkLastAttackWithin(getAttackSpeed());
}

uint16_t Player::getSkillLevel(skills_t skill) const {
	auto skillLevel = getLoyaltySkill(skill);
	skillLevel = std::max<int32_t>(0, skillLevel + varSkills[skill]);

	const auto &maxValuePerSkill = getMaxValuePerSkill();
	if (const auto it = maxValuePerSkill.find(skill);
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

	const int32_t avatarCritChance = m_wheelPlayer->checkAvatarSkill(WheelAvatarSkill_t::CRITICAL_CHANCE);
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
	if (g_configManager().getBoolean(FREE_PREMIUM) || hasFlag(PlayerFlags_t::IsAlwaysPremium)) {
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

bool Player::isVip() const {
	return g_configManager().getBoolean(VIP_SYSTEM_ENABLED) && (getPremiumDays() > 0 || getPremiumLastDay() > getTimeNow());
}

void Player::setTibiaCoins(int32_t v) {
	coinBalance = v;
}

void Player::setCleavePercent(int32_t value) {
	cleavePercent = std::max(0, cleavePercent + value);
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
			const uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

void Player::setPerfectShotDamage(uint8_t range, int32_t damage) {
	int32_t actualDamage = getPerfectShotDamage(range);
	const bool aboveZero = (actualDamage != 0);
	actualDamage += damage;
	if (actualDamage == 0 && aboveZero) {
		perfectShot.erase(range);
	} else {
		perfectShot[range] = actualDamage;
	}
}

int32_t Player::getSpecializedMagicLevel(CombatType_t combat, bool useCharges) const {
	int32_t result = specializedMagicLevel[combatTypeToIndex(combat)];
	for (const auto &item : getEquippedItems()) {
		const ItemType &itemType = Item::items[item->getID()];
		if (!itemType.abilities) {
			continue;
		}

		const int32_t specialized_magic_level = itemType.abilities->specializedMagicLevel[combatTypeToIndex(combat)];
		if (specialized_magic_level > 0) {
			result += specialized_magic_level;
			const uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

void Player::setSpecializedMagicLevel(CombatType_t combat, int32_t value) {
	specializedMagicLevel[combatTypeToIndex(combat)] = std::max(0, specializedMagicLevel[combatTypeToIndex(combat)] + value);
}

int32_t Player::getMagicShieldCapacityFlat(bool useCharges) const {
	int32_t result = magicShieldCapacityFlat;
	for (const auto &item : getEquippedItems()) {
		const ItemType &itemType = Item::items[item->getID()];
		if (!itemType.abilities) {
			continue;
		}

		const int32_t magicCapacity = itemType.abilities->magicShieldCapacityFlat;
		if (magicCapacity != 0) {
			result += magicCapacity;
			const uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

void Player::setMagicShieldCapacityFlat(int32_t value) {
	magicShieldCapacityFlat += value;
}

int32_t Player::getMagicShieldCapacityPercent(bool useCharges) const {
	int32_t result = magicShieldCapacityPercent;
	for (const auto &item : getEquippedItems()) {
		const ItemType &itemType = Item::items[item->getID()];
		if (!itemType.abilities) {
			continue;
		}

		const int32_t magicPercent = itemType.abilities->magicShieldCapacityPercent;
		if (magicPercent != 0) {
			result += magicPercent;
			const uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

void Player::setMagicShieldCapacityPercent(int32_t value) {
	magicShieldCapacityPercent += value;
}

double_t Player::getReflectPercent(CombatType_t combat, bool useCharges) const {
	double_t result = reflectPercent[combatTypeToIndex(combat)];
	for (const auto &item : getEquippedItems()) {
		const ItemType &itemType = Item::items[item->getID()];
		if (!itemType.abilities) {
			continue;
		}

		double_t reflectPercent = itemType.abilities->reflectPercent[combatTypeToIndex(combat)];
		if (reflectPercent != 0) {
			result += reflectPercent;
			const uint16_t charges = item->getCharges();
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

		const int32_t reflectFlat = itemType.abilities->reflectFlat[combatTypeToIndex(combat)];
		if (reflectFlat != 0) {
			result += reflectFlat;
			const uint16_t charges = item->getCharges();
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

PartyShields_t Player::getPartyShield(const std::shared_ptr<Player> &player) {
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

bool Player::isInviting(const std::shared_ptr<Player> &player) const {
	if (!player || !m_party || m_party->getLeader().get() != this) {
		return false;
	}
	return m_party->isPlayerInvited(player);
}

bool Player::isPartner(const std::shared_ptr<Player> &player) const {
	if (!player || !m_party || player.get() == this) {
		return false;
	}
	return m_party == player->m_party;
}

void Player::sendPlayerPartyIcons(const std::shared_ptr<Player> &player) const {
	sendPartyCreatureShield(player);
	sendPartyCreatureSkull(player);
}

bool Player::addPartyInvitation(const std::shared_ptr<Party> &newParty) {
	auto it = std::ranges::find(invitePartyList, newParty);
	if (it != invitePartyList.end()) {
		return false;
	}

	invitePartyList.emplace_back(newParty);
	return true;
}

void Player::removePartyInvitation(const std::shared_ptr<Party> &remParty) {
	std::erase(invitePartyList, remParty);
}

void Player::clearPartyInvitations() {
	for (const auto &invitingParty : invitePartyList) {
		invitingParty->removeInvite(getPlayer(), false);
	}
	invitePartyList.clear();
}

GuildEmblems_t Player::getGuildEmblem(const std::shared_ptr<Player> &player) const {
	if (!player) {
		return GUILDEMBLEM_NONE;
	}

	const auto &playerGuild = player->getGuild();
	if (!playerGuild) {
		return GUILDEMBLEM_NONE;
	}

	if (player->getGuildWarVector().empty()) {
		if (guild == playerGuild) {
			return GUILDEMBLEM_MEMBER;
		}
		return GUILDEMBLEM_OTHER;
	}
	if (guild == playerGuild) {
		return GUILDEMBLEM_ALLY;
	}
	if (isInWar(player)) {
		return GUILDEMBLEM_ENEMY;
	}

	return GUILDEMBLEM_NEUTRAL;
}

uint64_t Player::getSpentMana() const {
	return manaSpent;
}

bool Player::hasFlag(PlayerFlags_t flag) const {
	return group->flags[static_cast<std::size_t>(flag)];
}

void Player::setFlag(PlayerFlags_t flag) const {
	group->flags[static_cast<std::size_t>(flag)] = true;
}

void Player::removeFlag(PlayerFlags_t flag) const {
	group->flags[static_cast<std::size_t>(flag)] = false;
}

std::shared_ptr<BedItem> Player::getBedItem() {
	return bedItem;
}

void Player::setBedItem(std::shared_ptr<BedItem> b) {
	bedItem = std::move(b);
}

void Player::sendUnjustifiedPoints() const {
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

		const bool isRed = getSkull() == SKULL_RED;

		auto dayMax = ((isRed ? 2 : 1) * g_configManager().getNumber(DAY_KILLS_TO_RED));
		auto weekMax = ((isRed ? 2 : 1) * g_configManager().getNumber(WEEK_KILLS_TO_RED));
		auto monthMax = ((isRed ? 2 : 1) * g_configManager().getNumber(MONTH_KILLS_TO_RED));

		const uint8_t dayProgress = std::min(std::round(dayKills / dayMax * 100), 100.0);
		const uint8_t weekProgress = std::min(std::round(weekKills / weekMax * 100), 100.0);
		const uint8_t monthProgress = std::min(std::round(monthKills / monthMax * 100), 100.0);
		uint8_t skullDuration = 0;
		if (skullTicks != 0) {
			skullDuration = std::floor<uint8_t>(skullTicks / (24 * 60 * 60 * 1000));
		}
		client->sendUnjustifiedPoints(dayProgress, std::max(dayMax - dayKills, 0.0), weekProgress, std::max(weekMax - weekKills, 0.0), monthProgress, std::max(monthMax - monthKills, 0.0), skullDuration);
	}
}

uint8_t Player::getLastMount() const {
	const int32_t value = getStorageValue(PSTRG_MOUNTS_CURRENTMOUNT);
	if (value > 0) {
		return value;
	}
	return static_cast<uint8_t>(kv()->get("last-mount")->get<int>());
}

uint8_t Player::getCurrentMount() const {
	const int32_t value = getStorageValue(PSTRG_MOUNTS_CURRENTMOUNT);
	if (value > 0) {
		return value;
	}
	return 0;
}

void Player::setCurrentMount(uint8_t mount) {
	addStorageValue(PSTRG_MOUNTS_CURRENTMOUNT, mount);
}

bool Player::hasAnyMount() const {
	const auto &mounts = g_game().mounts->getMounts();
	return std::ranges::any_of(mounts, [&](const auto &mount) {
		return hasMount(mount);
	});
}

uint8_t Player::getRandomMountId() const {
	std::vector<uint8_t> playerMounts;
	const auto mounts = g_game().mounts->getMounts();
	for (const auto &mount : mounts) {
		if (hasMount(mount)) {
			playerMounts.emplace_back(mount->id);
		}
	}

	const auto playerMountsSize = static_cast<int32_t>(playerMounts.size() - 1);
	const auto randomIndex = uniform_random(0, std::max<int32_t>(0, playerMountsSize));
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

		const auto &tile = getTile();
		if (!g_configManager().getBoolean(TOGGLE_MOUNT_IN_PZ) && !group->access && tile && tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
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

		const auto &currentMount = g_game().mounts->getMountByID(currentMountId);
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
	if (!g_game().mounts->getMountByID(mountId)) {
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
	if (!g_game().mounts->getMountByID(mountId)) {
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

bool Player::hasMount(const std::shared_ptr<Mount> &mount) const {
	if (isAccessPlayer()) {
		return true;
	}

	if (mount->premium && !isPremium()) {
		return false;
	}

	const uint8_t tmpMountId = mount->id - 1;

	const int32_t value = getStorageValue(PSTRG_MOUNTS_RANGE_START + (tmpMountId / 31));
	if (value == -1) {
		return false;
	}

	return ((1 << (tmpMountId % 31)) & value) != 0;
}

void Player::dismount() {
	const auto &mount = g_game().mounts->getMountByID(getCurrentMount());
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
		g_callbacks().executeCallback(EventCallback_t::playerOnGainSkillTries, &EventCallback::playerOnGainSkillTries, getPlayer(), SKILL_MAGLEVEL, std::ref(tries));

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

void Player::addOfflineTrainingTime(int32_t addTime) {
	offlineTrainingTime = std::min<int32_t>(12 * 3600 * 1000, offlineTrainingTime + addTime);
}

void Player::removeOfflineTrainingTime(int32_t removeTime) {
	offlineTrainingTime = std::max<int32_t>(0, offlineTrainingTime - removeTime);
}

int32_t Player::getOfflineTrainingTime() const {
	return offlineTrainingTime;
}

int8_t Player::getOfflineTrainingSkill() const {
	return offlineTrainingSkill;
}

void Player::setOfflineTrainingSkill(int8_t skill) {
	offlineTrainingSkill = skill;
}

uint64_t Player::getBankBalance() const {
	return bankBalance;
}

void Player::setBankBalance(uint64_t balance) {
	bankBalance = balance;
}

std::shared_ptr<Town> Player::getTown() const {
	return town;
}
void Player::setTown(const std::shared_ptr<Town> &newTown) {
	this->town = newTown;
}

bool Player::hasModalWindowOpen(uint32_t modalWindowId) const {
	return std::ranges::find(modalWindows, modalWindowId) != modalWindows.end();
}

void Player::onModalWindowHandled(uint32_t modalWindowId) {
	std::erase(modalWindows, modalWindowId);
}

const Position &Player::getTemplePosition() const {
	if (!town) {
		static auto emptyPosition = Position();
		return emptyPosition;
	}

	return town->getTemplePosition();
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

void Player::sendImbuementResult(const std::string &message) const {
	if (client) {
		client->sendImbuementResult(message);
	}
}

void Player::closeImbuementWindow() const {
	if (client) {
		client->closeImbuementWindow();
	}
}

void Player::sendPodiumWindow(const std::shared_ptr<Item> &podium, const Position &position, uint16_t itemId, uint8_t stackpos) const {
	if (client) {
		client->sendPodiumWindow(podium, position, itemId, stackpos);
	}
}

void Player::sendCloseContainer(uint8_t cid) const {
	if (client) {
		client->sendCloseContainer(cid);
	}
}

void Player::sendChannel(uint16_t channelId, const std::string &channelName, const UsersMap* channelUsers, const InvitedMap* invitedUsers) const {
	if (client) {
		client->sendChannel(channelId, channelName, channelUsers, invitedUsers);
	}
}

void Player::sendTutorial(uint8_t tutorialId) const {
	if (client) {
		client->sendTutorial(tutorialId);
	}
}

void Player::sendAddMarker(const Position &pos, uint8_t markType, const std::string &desc) const {
	if (client) {
		client->sendAddMarker(pos, markType, desc);
	}
}

void Player::sendItemInspection(uint16_t itemId, uint8_t itemCount, const std::shared_ptr<Item> &item, bool cyclopedia) const {
	if (client) {
		client->sendItemInspection(itemId, itemCount, item, cyclopedia);
	}
}

void Player::sendCyclopediaCharacterNoData(CyclopediaCharacterInfoType_t characterInfoType, uint8_t errorCode) const {
	if (client) {
		client->sendCyclopediaCharacterNoData(characterInfoType, errorCode);
	}
}

void Player::sendCyclopediaCharacterBaseInformation() const {
	if (client) {
		client->sendCyclopediaCharacterBaseInformation();
	}
}

void Player::sendCyclopediaCharacterGeneralStats() const {
	if (client) {
		client->sendCyclopediaCharacterGeneralStats();
	}
}

void Player::sendCyclopediaCharacterCombatStats() const {
	if (client) {
		client->sendCyclopediaCharacterCombatStats();
	}
}

void Player::sendCyclopediaCharacterRecentDeaths(uint16_t page, uint16_t pages, const std::vector<RecentDeathEntry> &entries) const {
	if (client) {
		client->sendCyclopediaCharacterRecentDeaths(page, pages, entries);
	}
}

void Player::sendCyclopediaCharacterRecentPvPKills(uint16_t page, uint16_t pages, const std::vector<RecentPvPKillEntry> &entries) const {
	if (client) {
		client->sendCyclopediaCharacterRecentPvPKills(page, pages, entries);
	}
}

void Player::sendCyclopediaCharacterAchievements(uint16_t secretsUnlocked, const std::vector<std::pair<Achievement, uint32_t>> &achievementsUnlocked) const {
	if (client) {
		client->sendCyclopediaCharacterAchievements(secretsUnlocked, achievementsUnlocked);
	}
}

void Player::sendCyclopediaCharacterItemSummary(const ItemsTierCountList &inventoryItems, const ItemsTierCountList &storeInboxItems, const StashItemList &supplyStashItems, const ItemsTierCountList &depotBoxItems, const ItemsTierCountList &inboxItems) const {
	if (client) {
		client->sendCyclopediaCharacterItemSummary(inventoryItems, storeInboxItems, supplyStashItems, depotBoxItems, inboxItems);
	}
}

void Player::sendCyclopediaCharacterOutfitsMounts() const {
	if (client) {
		client->sendCyclopediaCharacterOutfitsMounts();
	}
}

void Player::sendCyclopediaCharacterStoreSummary() const {
	if (client) {
		client->sendCyclopediaCharacterStoreSummary();
	}
}

void Player::sendCyclopediaCharacterInspection() const {
	if (client) {
		client->sendCyclopediaCharacterInspection();
	}
}

void Player::sendCyclopediaCharacterBadges() const {
	if (client) {
		client->sendCyclopediaCharacterBadges();
	}
}

void Player::sendCyclopediaCharacterTitles() const {
	if (client) {
		client->sendCyclopediaCharacterTitles();
	}
}

void Player::sendHighscoresNoData() const {
	if (client) {
		client->sendHighscoresNoData();
	}
}

void Player::sendHighscores(const std::vector<HighscoreCharacter> &characters, uint8_t categoryId, uint32_t vocationId, uint16_t page, uint16_t pages, uint32_t updateTimer) const {
	if (client) {
		client->sendHighscores(characters, categoryId, vocationId, page, pages, updateTimer);
	}
}

void Player::addAsyncOngoingTask(uint64_t flags) {
	asyncOngoingTasks |= flags;
}

bool Player::hasAsyncOngoingTask(uint64_t flags) const {
	return (asyncOngoingTasks & flags);
}

void Player::resetAsyncOngoingTask(uint64_t flags) {
	asyncOngoingTasks &= ~flags;
}

void Player::sendEnterWorld() const {
	if (client) {
		client->sendEnterWorld();
	}
}

void Player::sendFightModes() const {
	if (client) {
		client->sendFightModes();
	}
}

void Player::sendNetworkMessage(const NetworkMessage &message) const {
	if (client) {
		client->writeToOutputBuffer(message);
	}
}

void Player::receivePing() {
	lastPong = OTSYS_TIME();
}

void Player::sendOpenStash(bool isNpc) const {
	if (client && ((getLastDepotId() != -1) || isNpc)) {
		client->sendOpenStash();
	}
}

void Player::sendTakeScreenshot(Screenshot_t screenshotType) const {
	if (client) {
		client->sendTakeScreenshot(screenshotType);
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
	const auto &playerTile = getTile();
	const bool vipStaysOnline = isVip() && g_configManager().getBoolean(VIP_STAY_ONLINE);
	idleTime += interval;
	if (playerTile && !playerTile->hasFlag(TILESTATE_NOLOGOUT) && !isAccessPlayer() && !isExerciseTraining() && !vipStaysOnline) {
		const int32_t kickAfterMinutes = g_configManager().getNumber(KICK_AFTER_MINUTES);
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

	g_callbacks().executeCallback(EventCallback_t::playerOnThink, &EventCallback::playerOnThink, getPlayer(), interval);
}

void Player::postAddNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &oldParent, int32_t index, CylinderLink_t link) {
	if (link == LINK_OWNER) {
		// calling movement scripts
		g_moveEvents().onPlayerEquip(getPlayer(), thing->getItem(), static_cast<Slots_t>(index), false);
	}

	bool requireListUpdate = true;
	if (link == LINK_OWNER || link == LINK_TOPPARENT) {
		const auto &item = oldParent ? oldParent->getItem() : nullptr;
		const auto &container = item ? item->getContainer() : nullptr;
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

	if (const auto &item = thing->getItem()) {
		if (const auto &container = item->getContainer()) {
			onSendContainer(container);
		}

		if (shopOwner && !scheduledSaleUpdate && requireListUpdate) {
			updateSaleShopList(item);
		}
	} else if (const auto &creature = thing->getCreature()) {
		if (creature == getPlayer()) {
			// check containers
			std::vector<std::shared_ptr<Container>> containers;

			for (const auto &[containerId, containerInfo] : openContainers) {
				const auto &container = containerInfo.container;
				if (container == nullptr) {
					continue;
				}

				if (!Position::areInRange<1, 1, 0>(container->getPosition(), getPosition())) {
					containers.emplace_back(container);
				}
			}

			for (const auto &container : containers) {
				autoCloseContainers(container);
			}
		}
	}
}

void Player::postRemoveNotification(const std::shared_ptr<Thing> &thing, const std::shared_ptr<Cylinder> &newParent, int32_t index, CylinderLink_t link) {
	if (!thing) {
		return;
	}

	const auto copyThing = thing;
	const auto copyNewParent = newParent;

	if (link == LINK_OWNER) {
		if (const auto &item = copyThing->getItem()) {
			g_moveEvents().onPlayerDeEquip(getPlayer(), item, static_cast<Slots_t>(index));
		}
	}
	bool requireListUpdate = true;

	if (link == LINK_OWNER || link == LINK_TOPPARENT) {
		const auto &item = copyNewParent ? copyNewParent->getItem() : nullptr;
		const auto &container = item ? item->getContainer() : nullptr;
		if (container) {
			requireListUpdate = container->getHoldingPlayer() != getPlayer();
		} else {
			requireListUpdate = copyNewParent != getPlayer();
		}

		updateInventoryWeight();
		updateItemsLight();
		sendInventoryIds();
		sendStats();
	}

	if (const auto &item = copyThing->getItem()) {
		if (const auto &container = item->getContainer()) {
			checkLootContainers(container);

			if (container->isRemoved() || !Position::areInRange<1, 1, 0>(getPosition(), container->getPosition())) {
				autoCloseContainers(container);
			} else if (container->getTopParent() == getPlayer()) {
				onSendContainer(container);
			} else if (const auto &topContainer = std::dynamic_pointer_cast<Container>(container->getTopParent())) {
				if (const auto &depotChest = std::dynamic_pointer_cast<DepotChest>(topContainer)) {
					bool isOwner = false;

					for (const auto &[depotId, depotChestMap] : depotChests) {
						if (depotId == 0) {
							continue;
						}

						if (depotChestMap == depotChest) {
							isOwner = true;
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

void Player::sendUpdateTile(const std::shared_ptr<Tile> &updateTile, const Position &pos) const {
	if (client) {
		client->sendUpdateTile(updateTile, pos);
	}
}

void Player::sendChannelMessage(const std::string &author, const std::string &text, SpeakClasses type, uint16_t channel) const {
	if (client) {
		client->sendChannelMessage(author, text, type, channel);
	}
}

void Player::sendChannelEvent(uint16_t channelId, const std::string &playerName, ChannelEvent_t channelEvent) const {
	if (client) {
		client->sendChannelEvent(channelId, playerName, channelEvent);
	}
}

void Player::sendCreatureAppear(const std::shared_ptr<Creature> &creature, const Position &pos, bool isLogin) {
	if (!creature) {
		return;
	}

	auto tile = creature->getTile();
	if (!tile) {
		return;
	}

	if (client) {
		client->sendAddCreature(creature, pos, tile->getStackposOfCreature(static_self_cast<Player>(), creature), isLogin);
	}
}

void Player::sendCreatureMove(const std::shared_ptr<Creature> &creature, const Position &newPos, int32_t newStackPos, const Position &oldPos, int32_t oldStackPos, bool teleport) const {
	if (client) {
		client->sendMoveCreature(creature, newPos, newStackPos, oldPos, oldStackPos, teleport);
	}
}

void Player::sendCreatureTurn(const std::shared_ptr<Creature> &creature) {
	if (!creature) {
		return;
	}

	auto tile = creature->getTile();
	if (!tile) {
		return;
	}

	if (client && canSeeCreature(creature)) {
		int32_t stackpos = tile->getStackposOfCreature(static_self_cast<Player>(), creature);
		if (stackpos != -1) {
			client->sendCreatureTurn(creature, stackpos);
		}
	}
}

void Player::sendCreatureSay(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text, const Position* pos) const {
	if (client) {
		client->sendCreatureSay(creature, type, text, pos);
	}
}

void Player::sendCreatureReload(const std::shared_ptr<Creature> &creature) const {
	if (client) {
		client->reloadCreature(creature);
	}
}

void Player::sendPrivateMessage(const std::shared_ptr<Player> &speaker, SpeakClasses type, const std::string &text) const {
	if (client) {
		client->sendPrivateMessage(speaker, type, text);
	}
}

void Player::sendCreatureSquare(const std::shared_ptr<Creature> &creature, SquareColor_t color) const {
	if (client) {
		client->sendCreatureSquare(creature, color);
	}
}

void Player::sendCreatureChangeOutfit(const std::shared_ptr<Creature> &creature, const Outfit_t &outfit) const {
	if (client) {
		client->sendCreatureOutfit(creature, outfit);
	}
}

void Player::sendCreatureChangeVisible(const std::shared_ptr<Creature> &creature, bool visible) {
	if (!client || !creature) {
		return;
	}

	if (creature->getPlayer()) {
		if (visible) {
			client->sendCreatureOutfit(creature, creature->getCurrentOutfit());
		} else {
			static Outfit_t outfit;
			client->sendCreatureOutfit(creature, outfit);
		}
	} else if (canSeeInvisibility()) {
		client->sendCreatureOutfit(creature, creature->getCurrentOutfit());
	} else {
		auto tile = creature->getTile();
		if (!tile) {
			return;
		}
		int32_t stackpos = tile->getStackposOfCreature(static_self_cast<Player>(), creature);
		if (stackpos == -1) {
			return;
		}

		if (visible) {
			client->sendAddCreature(creature, creature->getPosition(), stackpos, false);
		} else {
			client->sendRemoveTileThing(creature->getPosition(), stackpos);
		}
	}
}

void Player::sendCreatureLight(const std::shared_ptr<Creature> &creature) const {
	if (client) {
		client->sendCreatureLight(creature);
	}
}

void Player::sendCreatureIcon(const std::shared_ptr<Creature> &creature) const {
	if (client && !client->oldProtocol) {
		client->sendCreatureIcon(creature);
	}
}

void Player::sendUpdateCreature(const std::shared_ptr<Creature> &creature) const {
	if (client) {
		client->sendUpdateCreature(creature);
	}
}

void Player::sendCreatureWalkthrough(const std::shared_ptr<Creature> &creature, bool walkthrough) const {
	if (client) {
		client->sendCreatureWalkthrough(creature, walkthrough);
	}
}

void Player::sendCreatureShield(const std::shared_ptr<Creature> &creature) const {
	if (client) {
		client->sendCreatureShield(creature);
	}
}

void Player::sendCreatureType(const std::shared_ptr<Creature> &creature, uint8_t creatureType) const {
	if (client) {
		client->sendCreatureType(creature, creatureType);
	}
}

void Player::sendSpellCooldown(uint16_t spellId, uint32_t time) const {
	if (client) {
		client->sendSpellCooldown(spellId, time);
	}
}

void Player::sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time) const {
	if (client) {
		client->sendSpellGroupCooldown(groupId, time);
	}
}

void Player::sendUseItemCooldown(uint32_t time) const {
	if (client) {
		client->sendUseItemCooldown(time);
	}
}

void Player::reloadCreature(const std::shared_ptr<Creature> &creature) const {
	if (client) {
		client->reloadCreature(creature);
	}
}

void Player::sendModalWindow(const ModalWindow &modalWindow) {
	if (!client) {
		return;
	}

	modalWindows.emplace_back(modalWindow.id);
	client->sendModalWindow(modalWindow);
}

// container

void Player::closeAllExternalContainers() {
	if (openContainers.empty()) {
		return;
	}

	std::vector<std::shared_ptr<Container>> containerToClose;
	for (const auto &[containerId, containerInfo] : openContainers) {
		const auto &container = containerInfo.container;
		if (!container) {
			continue;
		}

		if (container->getHoldingPlayer() != getPlayer()) {
			containerToClose.emplace_back(container);
		}
	}

	for (const auto &container : containerToClose) {
		autoCloseContainers(container);
	}
}

// container

void Player::sendAddContainerItem(const std::shared_ptr<Container> &container, std::shared_ptr<Item> item) {
	if (!client) {
		return;
	}

	if (!container) {
		return;
	}

	for (const auto &[containerId, containerInfo] : openContainers) {
		if (containerInfo.container != container) {
			continue;
		}

		uint16_t slot = containerInfo.index;
		if (container->getID() == ITEM_BROWSEFIELD) {
			const uint16_t containerSize = container->size() - 1;
			const uint16_t pageEnd = containerInfo.index + container->capacity() - 1;
			if (containerSize > pageEnd) {
				slot = pageEnd;
				item = container->getItemByIndex(pageEnd);
			} else {
				slot = containerSize;
			}
		} else if (containerInfo.index >= container->capacity()) {
			item = container->getItemByIndex(containerInfo.index - 1);
		}
		client->sendAddContainerItem(containerId, slot, item);
	}
}

void Player::sendUpdateContainerItem(const std::shared_ptr<Container> &container, uint16_t slot, const std::shared_ptr<Item> &newItem) {
	if (!client) {
		return;
	}

	for (const auto &[containerId, containerInfo] : openContainers) {
		if (containerInfo.container != container) {
			continue;
		}

		if (slot < containerInfo.index) {
			continue;
		}

		const uint16_t pageEnd = containerInfo.index + container->capacity();
		if (slot >= pageEnd) {
			continue;
		}

		client->sendUpdateContainerItem(containerId, slot, newItem);
	}
}

void Player::sendRemoveContainerItem(const std::shared_ptr<Container> &container, uint16_t slot) {
	if (!client) {
		return;
	}

	if (!container) {
		return;
	}

	for (auto &[containerId, containerInfo] : openContainers) {
		if (containerInfo.container != container) {
			continue;
		}

		uint16_t &firstIndex = containerInfo.index;
		if (firstIndex > 0 && firstIndex >= container->size() - 1) {
			firstIndex -= container->capacity();
			sendContainer(containerId, container, false, firstIndex);
		}

		client->sendRemoveContainerItem(containerId, std::max<uint16_t>(slot, firstIndex), container->getItemByIndex(container->capacity() + firstIndex));
	}
}

void Player::sendContainer(uint8_t cid, const std::shared_ptr<Container> &container, bool hasParent, uint16_t firstIndex) const {
	if (client) {
		client->sendContainer(cid, container, hasParent, firstIndex);
	}
}

// inventory

void Player::sendDepotItems(const ItemsTierCountList &itemMap, uint16_t count) const {
	if (client) {
		client->sendDepotItems(itemMap, count);
	}
}

void Player::sendCloseDepotSearch() const {
	if (client) {
		client->sendCloseDepotSearch();
	}
}

void Player::sendDepotSearchResultDetail(uint16_t itemId, uint8_t tier, uint32_t depotCount, const ItemVector &depotItems, uint32_t inboxCount, const ItemVector &inboxItems, uint32_t stashCount) const {
	if (client) {
		client->sendDepotSearchResultDetail(itemId, tier, depotCount, depotItems, inboxCount, inboxItems, stashCount);
	}
}

void Player::sendCoinBalance() const {
	if (client) {
		client->sendCoinBalance();
	}
}

void Player::sendInventoryItem(Slots_t slot, const std::shared_ptr<Item> &item) const {
	if (client) {
		client->sendInventoryItem(slot, item);
	}
}

void Player::sendInventoryIds() const {
	if (client) {
		client->sendInventoryIds();
	}
}

std::vector<std::shared_ptr<Condition>> Player::getMuteConditions() const {
	std::vector<std::shared_ptr<Condition>> muteConditions;
	muteConditions.reserve(conditions.size());

	for (const auto &condition : conditions) {
		if (condition->getTicks() <= 0) {
			continue;
		}

		const auto &type = condition->getType();
		if (type != CONDITION_MUTED && type != CONDITION_CHANNELMUTEDTICKS && type != CONDITION_YELLTICKS) {
			continue;
		}

		muteConditions.emplace_back(condition);
	}
	return muteConditions;
}

[[nodiscard]] std::shared_ptr<Guild> Player::getGuild() const {
	return guild;
}

void Player::setGuild(const std::shared_ptr<Guild> &newGuild) {
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
		const auto &rank = newGuild->getRankByLevel(1);
		if (!rank) {
			return;
		}

		guild = newGuild;
		guildRank = rank;
		newGuild->addMember(static_self_cast<Player>());
	}
}

[[nodiscard]] GuildRank_ptr Player::getGuildRank() const {
	return guildRank;
}

void Player::setGuildRank(GuildRank_ptr newGuildRank) {
	guildRank = std::move(newGuildRank);
}

bool Player::isGuildMate(const std::shared_ptr<Player> &player) const {
	if (!player || !guild) {
		return false;
	}
	return guild == player->guild;
}

bool Player::addItemFromStash(uint16_t itemId, uint32_t itemCount) {
	const uint32_t stackCount = 100u;

	while (itemCount > 0) {
		const auto addValue = itemCount > stackCount ? stackCount : itemCount;
		itemCount -= addValue;
		const auto &newItem = Item::CreateItem(itemId, addValue);

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
		itemDict.emplace_back(stowItem, stowItem->getItemCount());
	}

	if (const auto &container = stowItem->getContainer()) {
		std::ranges::copy_if(container->getStowableItems(), std::back_inserter(itemDict), [&item](const auto &stowable_it) {
			return stowable_it.first->getID() == item->getID();
		});
	}
}

void Player::stowItem(const std::shared_ptr<Item> &item, uint32_t count, bool allItems) {
	if (!item || !item->isItemStorable()) {
		sendCancelMessage("This item cannot be stowed here.");
		return;
	}

	StashContainerList itemDict;
	if (allItems) {
		if (!item->isInsideDepot(true)) {
			// Stow "all items" from player backpack
			if (const auto &backpack = getInventoryItem(CONST_SLOT_BACKPACK)) {
				sendStowItems(item, backpack, itemDict);
			}

			// Stow "all items" from loot pouch
			const auto &itemParent = item->getParent();
			const auto &lootPouch = itemParent->getItem();
			if (itemParent && lootPouch && lootPouch->getID() == ITEM_GOLD_POUCH) {
				sendStowItems(item, lootPouch, itemDict);
			}
		}

		// Stow locker items
		const auto &depotLocker = getDepotLocker(getLastDepotId());
		const auto &[itemVector, itemMap] = requestLockerItems(depotLocker);
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
			uint32_t depotChest = g_configManager().getNumber(DEPOTCHEST);
			bool validDepot = depotChest > 0 && depotChest < 21;
			if (g_configManager().getBoolean(STASH_MOVING) && containerItem && !containerItem->isStackable() && validDepot) {
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

void Player::sendPreyData() const {
	if (client) {
		for (const std::unique_ptr<PreySlot> &slot : preys) {
			client->sendPreyData(slot);
		}

		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards());
	}
}

void Player::sendPreyTimeLeft(const std::unique_ptr<PreySlot> &slot) const {
	if (g_configManager().getBoolean(PREY_ENABLED) && client) {
		client->sendPreyTimeLeft(slot);
	}
}

void Player::reloadPreySlot(PreySlot_t slotid) {
	if (g_configManager().getBoolean(PREY_ENABLED) && client) {
		client->sendPreyData(getPreySlotById(slotid));
		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
	}
}

const std::unique_ptr<PreySlot> &Player::getPreySlotById(PreySlot_t slotid) {
	if (auto it = std::ranges::find_if(preys, [slotid](const std::unique_ptr<PreySlot> &preyIt) {
			return preyIt->id == slotid;
		});
	    it != preys.end()) {
		return *it;
	}

	return PreySlotNull;
}

bool Player::setPreySlotClass(std::unique_ptr<PreySlot> &slot) {
	if (getPreySlotById(slot->id)) {
		return false;
	}

	preys.emplace_back(std::move(slot));
	return true;
}

bool Player::usePreyCards(uint16_t amount) {
	if (preyCards < amount) {
		return false;
	}

	preyCards -= amount;
	if (client) {
		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
	}
	return true;
}

void Player::addPreyCards(uint64_t amount) {
	preyCards += amount;
	if (client) {
		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
	}
}

uint64_t Player::getPreyCards() const {
	return preyCards;
}

uint32_t Player::getPreyRerollPrice() const {
	return getLevel() * g_configManager().getNumber(PREY_REROLL_PRICE_LEVEL);
}

std::vector<uint16_t> Player::getPreyBlackList() const {
	std::vector<uint16_t> rt;
	for (const std::unique_ptr<PreySlot> &slot : preys) {
		if (slot) {
			if (slot->isOccupied()) {
				rt.push_back(slot->selectedRaceId);
			}
			for (uint16_t raceId : slot->raceIdList) {
				rt.push_back(raceId);
			}
		}
	}

	return rt;
}

const std::unique_ptr<PreySlot> &Player::getPreyWithMonster(uint16_t raceId) const {
	if (!g_configManager().getBoolean(PREY_ENABLED)) {
		return PreySlotNull;
	}

	if (auto it = std::ranges::find_if(preys, [raceId](const std::unique_ptr<PreySlot> &preyPtr) {
			return preyPtr->selectedRaceId == raceId;
		});
	    it != preys.end()) {
		return *it;
	}

	return PreySlotNull;
}

// Task hunting system

void Player::initializeTaskHunting() {
	if (taskHunting.empty()) {
		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			auto slot = std::make_unique<TaskHuntingSlot>(static_cast<PreySlot_t>(slotId));
			if (!g_configManager().getBoolean(TASK_HUNTING_ENABLED)) {
				slot->state = PreyTaskDataState_Inactive;
			} else if (slot->id == PreySlot_Three && !g_configManager().getBoolean(TASK_HUNTING_FREE_THIRD_SLOT)) {
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

	if (client && g_configManager().getBoolean(TASK_HUNTING_ENABLED) && !client->oldProtocol) {
		client->writeToOutputBuffer(g_ioprey().getTaskHuntingBaseDate());
	}
}

bool Player::isCreatureUnlockedOnTaskHunting(const std::shared_ptr<MonsterType> &mtype) const {
	if (!mtype) {
		return false;
	}

	return getBestiaryKillCount(mtype->info.raceid) >= mtype->info.bestiaryToUnlock;
}

bool Player::setTaskHuntingSlotClass(std::unique_ptr<TaskHuntingSlot> &slot) {
	if (getTaskHuntingSlotById(slot->id)) {
		return false;
	}

	taskHunting.emplace_back(std::move(slot));
	return true;
}

uint8_t Player::getBlessingCount(uint8_t index, bool storeCount) const {
	if (!storeCount) {
		if (index > 0 && index <= blessings.size()) {
			return blessings[index - 1];
		} else {
			g_logger().error("[{}] - index outside range 0-10.", __FUNCTION__);
			return 0;
		}
	}
	auto amount = kv()->scoped("summary")->scoped("blessings")->scoped(fmt::format("{}", index))->get("amount");
	return amount ? static_cast<uint8_t>(amount->getNumber()) : 0;
}

std::string Player::getBlessingsName() const {
	std::vector<std::string> blessingNames;
	for (const auto &bless : magic_enum::enum_values<Blessings>()) {
		if (hasBlessing(enumToValue(bless))) {
			std::string name = toStartCaseWithSpace(magic_enum::enum_name(bless).data());
			blessingNames.emplace_back(name);
		}
	}

	std::ostringstream os;
	if (!blessingNames.empty()) {
		// Join all elements but the last with ", " and add the last one with " and "
		for (size_t i = 0; i < blessingNames.size() - 1; ++i) {
			os << blessingNames[i] << ", ";
		}
		if (blessingNames.size() > 1) {
			os << "and ";
		}
		os << blessingNames.back() << ".";
	}

	return os.str();
}

void Player::disconnect() const {
	if (client) {
		client->disconnect();
	}
}

uint32_t Player::getIP() const {
	return client ? client->getIP() : 0;
}

void Player::reloadTaskSlot(PreySlot_t slotid) {
	if (g_configManager().getBoolean(TASK_HUNTING_ENABLED) && client) {
		client->sendTaskHuntingData(getTaskHuntingSlotById(slotid));
		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
	}
}

const std::unique_ptr<TaskHuntingSlot> &Player::getTaskHuntingSlotById(PreySlot_t slotid) {
	if (auto it = std::ranges::find_if(taskHunting, [slotid](const std::unique_ptr<TaskHuntingSlot> &itTask) {
			return itTask->id == slotid;
		});
	    it != taskHunting.end()) {
		return *it;
	}

	return TaskHuntingSlotNull;
}

std::vector<uint16_t> Player::getTaskHuntingBlackList() const {
	std::vector<uint16_t> rt;

	std::ranges::for_each(taskHunting, [&rt](const std::unique_ptr<TaskHuntingSlot> &slot) {
		if (slot->isOccupied()) {
			rt.push_back(slot->selectedRaceId);
		} else {
			std::ranges::for_each(slot->raceIdList, [&rt](uint16_t raceId) {
				rt.push_back(raceId);
			});
		}
	});

	return rt;
}

void Player::sendTaskHuntingData() const {
	if (client) {
		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
		for (const std::unique_ptr<TaskHuntingSlot> &slot : taskHunting) {
			if (slot) {
				client->sendTaskHuntingData(slot);
			}
		}
	}
}

void Player::addTaskHuntingPoints(uint64_t amount) {
	taskHuntingPoints += amount;
	if (client) {
		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
	}
}

bool Player::useTaskHuntingPoints(uint64_t amount) {
	if (taskHuntingPoints < amount) {
		return false;
	}

	taskHuntingPoints -= amount;
	if (client) {
		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints());
	}
	return true;
}

uint64_t Player::getTaskHuntingPoints() const {
	return taskHuntingPoints;
}

uint32_t Player::getTaskHuntingRerollPrice() const {
	return getLevel() * g_configManager().getNumber(TASK_HUNTING_REROLL_PRICE_LEVEL);
}

const std::unique_ptr<TaskHuntingSlot> &Player::getTaskHuntingWithCreature(uint16_t raceId) const {
	if (!g_configManager().getBoolean(TASK_HUNTING_ENABLED)) {
		return TaskHuntingSlotNull;
	}

	if (auto it = std::ranges::find_if(taskHunting, [raceId](const std::unique_ptr<TaskHuntingSlot> &itTask) {
			return itTask->selectedRaceId == raceId;
		});
	    it != taskHunting.end()) {
		return *it;
	}

	return TaskHuntingSlotNull;
}

uint32_t Player::getLoyaltyPoints() const {
	return loyaltyPoints;
}

void Player::setLoyaltyBonus(uint16_t bonus) {
	loyaltyBonusPercent = bonus;
	sendSkills();
}

void Player::setLoyaltyTitle(std::string title) {
	loyaltyTitle = std::move(title);
}

std::string Player::getLoyaltyTitle() const {
	return loyaltyTitle;
}

uint16_t Player::getLoyaltyBonus() const {
	return loyaltyBonusPercent;
}

// Depot search system
/*******************************************************************************
 * Depot search system
 ******************************************************************************/

void Player::requestDepotItems() {
	ItemsTierCountList itemMap;
	uint16_t count = 0;
	const auto &depotLocker = getDepotLocker(getLastDepotId());
	if (!depotLocker) {
		return;
	}

	for (const auto &locker : depotLocker->getItemList()) {
		const auto &c = locker->getContainer();
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

	const auto &depotLocker = getDepotLocker(getLastDepotId());
	if (!depotLocker) {
		return;
	}

	for (const auto &locker : depotLocker->getItemList()) {
		const auto &c = locker->getContainer();
		if (!c || c->empty()) {
			continue;
		}

		inboxItems.reserve(inboxItems.size());
		depotItems.reserve(depotItems.size());

		for (ContainerIterator it = c->iterator(); it.hasNext(); it.advance()) {
			const auto item = *it;
			if (!item || item->getID() != itemId || item->getTier() != tier) {
				continue;
			}

			if (c->isInbox()) {
				if (inboxItems.size() < 255) {
					inboxItems.emplace_back(item);
				}
				inboxCount += Item::countByType(item, -1);
			} else {
				if (depotItems.size() < 255) {
					depotItems.emplace_back(item);
				}
				depotCount += Item::countByType(item, -1);
			}
		}
	}

	setDepotSearchIsOpen(itemId, tier);
	sendDepotSearchResultDetail(itemId, tier, depotCount, depotItems, inboxCount, inboxItems, stashCount);
}

void Player::retrieveAllItemsFromDepotSearch(uint16_t itemId, uint8_t tier, bool isDepot) {
	const auto &depotLocker = getDepotLocker(getLastDepotId());
	if (!depotLocker) {
		return;
	}

	std::vector<std::shared_ptr<Item>> itemsVector;
	for (const auto &locker : depotLocker->getItemList()) {
		const auto &c = locker->getContainer();
		if (!c || c->empty() ||
		    // Retrieve from inbox.
		    (c->isInbox() && isDepot) ||
		    // Retrieve from depot.
		    (!c->isInbox() && !isDepot)) {
			continue;
		}

		for (ContainerIterator it = c->iterator(); it.hasNext(); it.advance()) {
			const auto &item = *it;
			if (!item) {
				continue;
			}

			if (item->getID() == itemId && item->getTier() == depotSearchOnItem.second) {
				itemsVector.emplace_back(item);
			}
		}
	}

	ReturnValue ret = RETURNVALUE_NOERROR;
	for (const auto &item : itemsVector) {
		if (!item) {
			continue;
		}

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

	const auto &item = getItemFromDepotSearch(depotSearchOnItem.first, pos);
	if (!item) {
		sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	const auto &container = item->getParent() ? item->getParent()->getContainer() : nullptr;
	if (!container) {
		sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	g_actions().useItem(static_self_cast<Player>(), pos, 0, container, false);
}

std::shared_ptr<Item> Player::getItemFromDepotSearch(uint16_t itemId, const Position &pos) {
	const auto &depotLocker = getDepotLocker(getLastDepotId());
	if (!depotLocker) {
		return nullptr;
	}

	uint8_t index = 0;
	for (const auto &locker : depotLocker->getItemList()) {
		const auto &c = locker->getContainer();
		if (!c || c->empty() || (c->isInbox() && pos.y != 0x21) || // From inbox.
		    (!c->isInbox() && pos.y != 0x20)) { // From depot.
			continue;
		}

		for (ContainerIterator it = c->iterator(); it.hasNext(); it.advance()) {
			const auto &item = *it;
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

std::pair<std::vector<std::shared_ptr<Item>>, std::map<uint16_t, std::map<uint8_t, uint32_t>>> Player::requestLockerItems(const std::shared_ptr<DepotLocker> &depotLocker, bool sendToClient, uint8_t tier) const {
	if (!depotLocker) {
		g_logger().error("{} - Depot locker is nullptr", __FUNCTION__);
		return {};
	}

	std::map<uint16_t, std::map<uint8_t, uint32_t>> lockerItems;
	std::vector<std::shared_ptr<Item>> itemVector;
	std::vector<std::shared_ptr<Container>> containers { depotLocker };

	for (size_t i = 0; i < containers.size(); ++i) {
		const auto &container = containers[i];

		for (const auto &item : container->getItemList()) {
			const auto &lockerContainers = item->getContainer();
			if (lockerContainers && !lockerContainers->empty()) {
				containers.emplace_back(lockerContainers);
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
			itemVector.emplace_back(item);
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

/**
    This function returns a pair of an array of items and a 16-bit integer from a DepotLocker instance, a 8-bit byte and a 16-bit integer.
    @param depotLocker The instance of DepotLocker from which to retrieve items.
    @param tier The 8-bit byte that specifies the level of the tier to search.
    @param itemId The 16-bit integer that specifies the ID of the item to search for.
    @return A pair of an array of items and a 16-bit integer, where the array of items is filled with all items from the
    locker with the specified id and the 16-bit integer is the total items found.
    */

std::pair<std::vector<std::shared_ptr<Item>>, uint16_t> Player::getLockerItemsAndCountById(const std::shared_ptr<DepotLocker> &depotLocker, uint8_t tier, uint16_t itemId) const {
	std::vector<std::shared_ptr<Item>> lockerItems;
	const auto &[itemVector, itemMap] = requestLockerItems(depotLocker, false, tier);
	uint16_t totalCount = 0;
	for (const auto &item : itemVector) {
		if (!item || item->getID() != itemId) {
			continue;
		}

		totalCount++;
		lockerItems.emplace_back(item);
	}

	return std::make_pair(lockerItems, totalCount);
}

bool Player::saySpell(SpeakClasses type, const std::string &text, bool isGhostMode, const Spectators* spectatorsPtr, const Position* pos) {
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
	for (const auto &spectator : spectators) {
		if (const auto &tmpPlayer = spectator->getPlayer()) {
			if (g_configManager().getBoolean(EMOTE_SPELLS)) {
				valueEmote = tmpPlayer->getStorageValue(STORAGEVALUE_EMOTE);
			}
			if (!isGhostMode || tmpPlayer->canSeeCreature(static_self_cast<Player>())) {
				if (valueEmote == 1) {
					tmpPlayer->sendCreatureSay(static_self_cast<Player>(), TALKTYPE_MONSTER_SAY, text, pos);
				} else {
					tmpPlayer->sendCreatureSay(static_self_cast<Player>(), TALKTYPE_SPELL_USE, text, pos);
				}
			}
		}
	}

	// Execute lua event method
	for (const auto &spectator : spectators) {
		const auto &tmpPlayer = spectator->getPlayer();
		if (!tmpPlayer) {
			continue;
		}

		tmpPlayer->onCreatureSay(static_self_cast<Player>(), type, text);
	}
	return true;
}

void Player::triggerMomentum() {
	double_t chance = 0;
	if (const auto &item = getInventoryItem(CONST_SLOT_HEAD)) {
		chance += item->getMomentumChance();
	}

	chance += m_wheelPlayer->getBonusData().momentum;
	double_t randomChance = uniform_random(0, 10000) / 100.;
	if (getZoneType() != ZONE_PROTECTION && hasCondition(CONDITION_INFIGHT) && ((OTSYS_TIME() / 1000) % 2) == 0 && chance > 0 && randomChance < chance) {
		bool triggered = false;
		auto it = conditions.begin();
		while (it != conditions.end()) {
			const auto condItem = *it;
			const ConditionType_t type = condItem->getType();
			constexpr auto maxu16 = std::numeric_limits<uint16_t>::max();
			const auto checkSpellId = condItem->getSubId();
			auto spellId = checkSpellId > maxu16 ? 0u : static_cast<uint16_t>(checkSpellId);
			const int32_t ticks = condItem->getTicks();
			const int32_t newTicks = (ticks <= 2000) ? 0 : ticks - 2000;
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
		const auto &condItem = *it;
		if (!condItem) {
			++it;
			continue;
		}

		const ConditionType_t type = condItem->getType();
		constexpr auto maxu16 = std::numeric_limits<uint16_t>::max();
		const auto checkSpellId = condItem->getSubId();
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

	const auto &item = getInventoryItem(CONST_SLOT_LEGS);
	if (item == nullptr) {
		return;
	}

	const double_t chance = item->getTranscendenceChance();
	const double_t randomChance = uniform_random(0, 10000) / 100.;
	if (getZoneType() != ZONE_PROTECTION && checkLastAggressiveActionWithin(2000) && ((OTSYS_TIME() / 1000) % 2) == 0 && chance > 0 && randomChance < chance) {
		int64_t duration = g_configManager().getNumber(TRANSCENDANCE_AVATAR_DURATION);
		const auto &outfitCondition = Condition::createCondition(CONDITIONID_COMBAT, CONDITION_OUTFIT, duration, 0)->static_self_cast<ConditionOutfit>();
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
				const auto &player = g_game().getPlayerByID(playerId);
				if (player) {
					player->sendSkills();
					player->sendStats();
					player->sendBasicData();
				}
			},
			__FUNCTION__
		);
		g_dispatcher().scheduleEvent(task);

		wheel()->sendGiftOfLifeCooldown();
		g_game().reloadCreature(getPlayer());
	}
}

// Forge system
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

	const auto &firstForgingItem = getForgeItemFromId(firstItemId, tier);
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
	const auto &secondForgingItem = getForgeItemFromId(secondItemId, tier);
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

	const auto &exaltationChest = Item::CreateItem(ITEM_EXALTATION_CHEST, 1);
	if (!exaltationChest) {
		g_logger().error("Failed to create exaltation chest");
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	const auto &exaltationContainer = exaltationChest->getContainer();
	if (!exaltationContainer) {
		g_logger().error("Failed to create exaltation container");
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	const auto &firstForgedItem = Item::CreateItem(firstItemId, 1);
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
	auto dustCost = static_cast<uint64_t>(g_configManager().getNumber(configKey));
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
				if (mapTier == firstForgingItem->getTier() + 1) {
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
		const auto &secondForgedItem = Item::CreateItem(secondItemId, 1);
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
			auto isTierLost = uniform_random(1, 100) <= (reduceTierLoss ? g_configManager().getNumber(FORGE_TIER_LOSS_REDUCTION) : 100);
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

	const auto &donorItem = getForgeItemFromId(donorItemId, tier);
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

	const auto &receiveItem = getForgeItemFromId(receiveItemId, 0);
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

	const auto &exaltationChest = Item::CreateItem(ITEM_EXALTATION_CHEST, 1);
	if (!exaltationChest) {
		g_logger().error("Exaltation chest is nullptr");
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	const auto &exaltationContainer = exaltationChest->getContainer();
	if (!exaltationContainer) {
		g_logger().error("Exaltation container is nullptr");
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	const auto &newReceiveItem = Item::CreateItem(receiveItemId, 1);
	if (!newReceiveItem) {
		g_logger().error("[Log 6] Player with name {} failed to fuse item with id {}", getName(), receiveItemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	auto configKey = convergence ? FORGE_CONVERGENCE_TRANSFER_DUST_COST : FORGE_TRANSFER_DUST_COST;
	if (getForgeDusts() < g_configManager().getNumber(configKey)) {
		g_logger().error("[Log 8] Failed to remove transfer dusts from player with name {}", getName());
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	setForgeDusts(getForgeDusts() - g_configManager().getNumber(configKey));

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

		const uint8_t toTier = convergence ? donorItem->getTier() : donorItem->getTier() - 1;
		auto tierPriecs = itemClassification->tiers.at(toTier);
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
		auto cost = static_cast<uint16_t>(g_configManager().getNumber(FORGE_COST_ONE_SLIVER) * g_configManager().getNumber(FORGE_SLIVER_AMOUNT));
		if (cost > dusts) {
			g_logger().error("[{}] Not enough dust", __FUNCTION__);
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		auto itemCount = static_cast<uint16_t>(g_configManager().getNumber(FORGE_SLIVER_AMOUNT));
		const auto &item = Item::CreateItem(ITEM_FORGE_SLIVER, itemCount);
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
		const auto &[sliverCount, coreCount] = getForgeSliversAndCores();
		auto cost = static_cast<uint16_t>(g_configManager().getNumber(FORGE_CORE_COST));
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

		if (const auto &item = Item::CreateItem(ITEM_FORGE_CORE, 1);
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
		if (dustLevel >= g_configManager().getNumber(FORGE_MAX_DUST)) {
			g_logger().error("[{}] Maximum level reached", __FUNCTION__);
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		const auto upgradeCost = dustLevel - 75;
		if (const auto dusts = getForgeDusts();
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

void Player::sendOpenForge() const {
	if (client) {
		client->sendOpenForge();
	}
}

void Player::sendForgeError(ReturnValue returnValue) const {
	if (client) {
		client->sendForgeError(returnValue);
	}
}

void Player::sendForgeResult(ForgeAction_t actionType, uint16_t leftItemId, uint8_t leftTier, uint16_t rightItemId, uint8_t rightTier, bool success, uint8_t bonus, uint8_t coreCount, bool convergence) const {
	if (client) {
		client->sendForgeResult(actionType, leftItemId, leftTier, rightItemId, rightTier, success, bonus, coreCount, convergence);
	}
}

void Player::sendForgeHistory(uint8_t page) const {
	if (client) {
		client->sendForgeHistory(page);
	}
}

void Player::closeForgeWindow() const {
	if (client) {
		client->closeForgeWindow();
	}
}

void Player::setForgeDusts(uint64_t amount) {
	forgeDusts = amount;
	if (client) {
		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints(), getForgeDusts());
	}
}

void Player::addForgeDusts(uint64_t amount) {
	forgeDusts += amount;
	if (client) {
		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints(), getForgeDusts());
	}
}

void Player::removeForgeDusts(uint64_t amount) {
	forgeDusts = std::max<uint64_t>(0, forgeDusts - amount);
	if (client) {
		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints(), getForgeDusts());
	}
}

uint64_t Player::getForgeDusts() const {
	return forgeDusts;
}

void Player::addForgeDustLevel(uint64_t amount) {
	forgeDustLevel += amount;
	if (client) {
		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints(), getForgeDusts());
	}
}

void Player::removeForgeDustLevel(uint64_t amount) {
	forgeDustLevel = std::max<uint64_t>(0, forgeDustLevel - amount);
	if (client) {
		client->sendResourcesBalance(getMoney(), getBankBalance(), getPreyCards(), getTaskHuntingPoints(), getForgeDusts());
	}
}

uint64_t Player::getForgeDustLevel() const {
	return forgeDustLevel;
}

std::vector<ForgeHistory> &Player::getForgeHistory() {
	return forgeHistoryVector;
}

void Player::setForgeHistory(const ForgeHistory &history) {
	forgeHistoryVector.emplace_back(history);
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

// Quickloot

void Player::openPlayerContainers() {
	std::vector<std::pair<uint8_t, std::shared_ptr<Container>>> openContainersList;

	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; i++) {
		const auto &item = inventory[i];
		if (!item) {
			continue;
		}

		const auto &itemContainer = item->getContainer();
		if (itemContainer) {
			const auto &cid = item->getAttribute<int64_t>(ItemAttribute_t::OPENCONTAINER);
			if (cid > 0) {
				openContainersList.emplace_back(cid, itemContainer);
			}
			for (ContainerIterator it = itemContainer->iterator(); it.hasNext(); it.advance()) {
				const auto &subContainer = (*it)->getContainer();
				if (subContainer) {
					const auto &subcid = (*it)->getAttribute<uint8_t>(ItemAttribute_t::OPENCONTAINER);
					if (subcid > 0) {
						openContainersList.emplace_back(subcid, subContainer);
					}
				}
			}
		}
	}

	std::ranges::sort(openContainersList, [](const std::pair<uint8_t, std::shared_ptr<Container>> &left, const std::pair<uint8_t, std::shared_ptr<Container>> &right) {
		return left.first < right.first;
	});

	for (const auto &[containerId, container] : openContainersList) {
		addContainer(containerId - 1, container);
		onSendContainer(container);
	}
}

// Quickloot

void Player::sendLootContainers() const {
	if (client) {
		client->sendLootContainers();
	}
}

void Player::sendSingleSoundEffect(const Position &pos, SoundEffect_t id, SourceEffect_t source) const {
	if (client) {
		client->sendSingleSoundEffect(pos, id, source);
	}
}

void Player::sendDoubleSoundEffect(const Position &pos, SoundEffect_t mainSoundId, SourceEffect_t mainSource, SoundEffect_t secondarySoundId, SourceEffect_t secondarySource) const {
	if (client) {
		client->sendDoubleSoundEffect(pos, mainSoundId, mainSource, secondarySoundId, secondarySource);
	}
}

SoundEffect_t Player::getAttackSoundEffect() const {
	const auto &tool = getWeapon();
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
			}
			if (tool->getAmmoType() == AMMO_ARROW) {
				return SoundEffect_t::DIST_ATK_BOW;
			}
			return SoundEffect_t::DIST_ATK_THROW;

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

SoundEffect_t Player::getHitSoundEffect() const {
	// Distance sound effects
	const auto &tool = getWeapon();
	if (tool == nullptr) {
		return SoundEffect_t::SILENCE;
	}

	switch (const auto &it = Item::items[tool->getID()]; it.weaponType) {
		case WEAPON_AMMO: {
			if (it.ammoType == AMMO_BOLT) {
				return SoundEffect_t::DIST_ATK_CROSSBOW_SHOT;
			}
			if (it.ammoType == AMMO_ARROW) {
				if (it.shootType == CONST_ANI_BURSTARROW) {
					return SoundEffect_t::BURST_ARROW_EFFECT;
				}
				if (it.shootType == CONST_ANI_DIAMONDARROW) {
					return SoundEffect_t::DIAMOND_ARROW_EFFECT;
				}
			} else {
				return SoundEffect_t::DIST_ATK_THROW_SHOT;
			}
		}
		case WEAPON_DISTANCE: {
			if (tool->getAmmoType() == AMMO_BOLT) {
				return SoundEffect_t::DIST_ATK_CROSSBOW_SHOT;
			}
			if (tool->getAmmoType() == AMMO_ARROW) {
				return SoundEffect_t::DIST_ATK_BOW_SHOT;
			}
			return SoundEffect_t::DIST_ATK_THROW_SHOT;
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

// event methods

void Player::onUpdateTileItem(const std::shared_ptr<Tile> &updateTile, const Position &pos, const std::shared_ptr<Item> &oldItem, const ItemType &oldType, const std::shared_ptr<Item> &newItem, const ItemType &newType) {
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

void Player::onRemoveTileItem(const std::shared_ptr<Tile> &fromTile, const Position &pos, const ItemType &iType, const std::shared_ptr<Item> &item) {
	Creature::onRemoveTileItem(fromTile, pos, iType, item);

	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(item);

		if (tradeItem) {
			const auto &container = item->getContainer();
			if (container && container->isHoldingItem(tradeItem)) {
				g_game().internalCloseTrade(static_self_cast<Player>());
			}
		}
	}

	checkLootContainers(item->getContainer());
}

void Player::onCreatureAppear(const std::shared_ptr<Creature> &creature, bool isLogin) {
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

		const auto &bed = g_game().getBedBySleeper(guid);
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

		for (const auto &condition : getMuteConditions()) {
			condition->setTicks(condition->getTicks() - (offlineTime * 1000));
			if (condition->getTicks() <= 0) {
				removeCondition(condition);
			}
		}

		g_game().checkPlayersRecord();
		if (getLevel() < g_configManager().getNumber(ADVENTURERSBLESSING_LEVEL) && getVocationId() > VOCATION_NONE) {
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

void Player::onRemoveCreature(const std::shared_ptr<Creature> &creature, bool isLogout) {
	Creature::onRemoveCreature(creature, isLogout);

	if (const auto &player = getPlayer(); player == creature) {
		if (isLogout) {
			onDeEquipInventory();

			if (m_party) {
				m_party->leaveParty(player, true);
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

void Player::onCreatureMove(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &newTile, const Position &newPos, const std::shared_ptr<Tile> &oldTile, const Position &oldPos, bool teleport) {
	Creature::onCreatureMove(creature, newTile, newPos, oldTile, oldPos, teleport);

	const auto &followCreature = getFollowCreature();
	if (hasFollowPath && (creature == followCreature || (creature.get() == this && followCreature))) {
		isUpdatingPath = false;
		g_game().updateCreatureWalk(getID()); // internally uses addEventWalk.
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
		for (const uint32_t modalWindowId : modalWindows) {
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
		int32_t ticks = g_configManager().getNumber(STAIRHOP_DELAY);
		if (ticks > 0) {
			if (const auto &condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_PACIFIED, ticks, 0)) {
				addCondition(condition);
			}
		}
	}
}

void Player::onEquipInventory() {
	for (int32_t slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; ++slot) {
		const auto &item = inventory[slot];
		if (item) {
			item->startDecaying();
			g_moveEvents().onPlayerEquip(getPlayer(), item, static_cast<Slots_t>(slot), false);
		}
	}
}

void Player::onDeEquipInventory() {
	for (int32_t slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; ++slot) {
		const auto &item = inventory[slot];
		if (item) {
			g_moveEvents().onPlayerDeEquip(getPlayer(), item, static_cast<Slots_t>(slot));
		}
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

// container
// container

void Player::onAddContainerItem(const std::shared_ptr<Item> &item) {
	checkTradeState(item);
}

void Player::onUpdateContainerItem(const std::shared_ptr<Container> &container, const std::shared_ptr<Item> &oldItem, const std::shared_ptr<Item> &newItem) {
	if (oldItem != newItem) {
		onRemoveContainerItem(container, oldItem);
	}

	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(oldItem);
	}
}

void Player::onRemoveContainerItem(const std::shared_ptr<Container> &container, const std::shared_ptr<Item> &item) {
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

void Player::onCloseContainer(const std::shared_ptr<Container> &container) {
	if (!client) {
		return;
	}

	for (const auto &[containerId, containerInfo] : openContainers) {
		if (containerInfo.container == container) {
			client->sendCloseContainer(containerId);
		}
	}
}

void Player::onSendContainer(const std::shared_ptr<Container> &container) {
	if (!client || !container) {
		return;
	}

	const bool hasParent = container->hasParent();
	for (const auto &[containerId, containerInfo] : openContainers) {
		if (containerInfo.container == container) {
			client->sendContainer(containerId, container, hasParent, containerInfo.index);
		}
	}
}

// close container and its child containers

void Player::autoCloseContainers(const std::shared_ptr<Container> &container) {
	std::vector<uint32_t> closeList;
	for (const auto &[containerId, containerInfo] : openContainers) {
		auto tmpContainer = containerInfo.container;
		while (tmpContainer) {
			if (tmpContainer->isRemoved() || tmpContainer == container) {
				closeList.emplace_back(containerId);
				break;
			}

			tmpContainer = std::dynamic_pointer_cast<Container>(tmpContainer->getParent());
		}
	}

	for (const uint32_t containerId : closeList) {
		closeContainer(containerId);
		if (client) {
			client->sendCloseContainer(containerId);
		}
	}
}

// inventory
// inventory

void Player::onUpdateInventoryItem(const std::shared_ptr<Item> &oldItem, const std::shared_ptr<Item> &newItem) {
	if (oldItem != newItem) {
		onRemoveInventoryItem(oldItem);
	}

	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(oldItem);
	}
}

void Player::onRemoveInventoryItem(const std::shared_ptr<Item> &item) {
	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(item);

		if (tradeItem) {
			const auto &container = item->getContainer();
			if (container && container->isHoldingItem(tradeItem)) {
				g_game().internalCloseTrade(static_self_cast<Player>());
			}
		}
	}

	checkLootContainers(item->getContainer());
}

uint64_t Player::getItemCustomPrice(uint16_t itemId, bool buyPrice) const {
	auto it = itemPriceMap.find(itemId);
	if (it != itemPriceMap.end()) {
		return it->second;
	}

	const std::map<uint16_t, uint64_t> itemMap { { itemId, 1 } };
	return g_game().getItemMarketPrice(itemMap, buyPrice);
}

uint16_t Player::getFreeBackpackSlots() const {
	const auto &thing = getThing(CONST_SLOT_BACKPACK);
	if (!thing) {
		return 0;
	}

	const auto &backpack = thing->getContainer();
	if (!backpack) {
		return 0;
	}

	const uint16_t counter = std::max<uint16_t>(0, backpack->getFreeSlots());

	return counter;
}

bool Player::canAutoWalk(const Position &toPosition, const std::function<void()> &function, uint32_t delay) {
	if (!Position::areInRange<1, 1>(getPosition(), toPosition)) {
		// Check if can walk to the toPosition and send event to use function
		std::vector<Direction> listDir;
		if (getPathTo(toPosition, listDir, 0, 1, true, true)) {
			g_dispatcher().addEvent([creatureId = getID(), listDir] { g_game().playerAutoWalk(creatureId, listDir); }, __FUNCTION__);
			const auto &task = createPlayerTask(delay, function, __FUNCTION__);
			setNextWalkActionTask(task);
			return true;
		} else {
			sendCancelMessage(RETURNVALUE_THEREISNOWAY);
		}
	}
	return false;
}

void Player::sendMessageDialog(const std::string &message) const {
	if (client) {
		client->sendMessageDialog(message);
	}
}

// Account
// Account

bool Player::setAccount(uint32_t accountId) {
	if (account) {
		g_logger().warn("Account was already set!");
		return true;
	}

	account = std::make_shared<Account>(accountId);
	return AccountErrors_t::Ok == account->load();
}

uint8_t Player::getAccountType() const {
	return account ? account->getAccountType() : AccountType::ACCOUNT_TYPE_NORMAL;
}

uint32_t Player::getAccountId() const {
	return account ? account->getID() : 0;
}

std::shared_ptr<Account> Player::getAccount() const {
	return account;
}

// Prey system

void Player::initializePrey() {
	if (preys.empty()) {
		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			auto slot = std::make_unique<PreySlot>(static_cast<PreySlot_t>(slotId));
			if (!g_configManager().getBoolean(PREY_ENABLED)) {
				slot->state = PreyDataState_Inactive;
			} else if (slot->id == PreySlot_Three && !g_configManager().getBoolean(PREY_FREE_THIRD_SLOT)) {
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
	const auto it = std::ranges::remove_if(preys, [slotid](const auto &preyIt) {
						return preyIt->id == slotid;
					}).begin();

	preys.erase(it, preys.end());
}

/*******************************************************************************
 * Hazard system
 ******************************************************************************/

void Player::setBossPoints(uint32_t amount) {
	bossPoints = amount;
}

void Player::addBossPoints(uint32_t amount) {
	bossPoints += amount;
}

void Player::removeBossPoints(uint32_t amount) {
	bossPoints = std::max<uint32_t>(0, bossPoints - amount);
}

uint32_t Player::getBossPoints() const {
	return bossPoints;
}

void Player::sendBosstiaryCooldownTimer() const {
	if (client) {
		client->sendBosstiaryCooldownTimer();
	}
}

void Player::setSlotBossId(uint8_t slotId, uint32_t bossId) {
	if (slotId == 1) {
		bossIdSlotOne = bossId;
	} else {
		bossIdSlotTwo = bossId;
	}
	if (client) {
		client->parseSendBosstiarySlots();
	}
}

uint32_t Player::getSlotBossId(uint8_t slotId) const {
	if (slotId == 1) {
		return bossIdSlotOne;
	} else {
		return bossIdSlotTwo;
	}
}

void Player::addRemoveTime() {
	bossRemoveTimes = bossRemoveTimes + 1;
}

void Player::setRemoveBossTime(uint8_t newRemoveTimes) {
	bossRemoveTimes = newRemoveTimes;
}

uint8_t Player::getRemoveTimes() const {
	return bossRemoveTimes;
}

void Player::sendMonsterPodiumWindow(const std::shared_ptr<Item> &podium, const Position &position, uint16_t itemId, uint8_t stackpos) const {
	if (client) {
		client->sendMonsterPodiumWindow(podium, position, itemId, stackpos);
	}
}

void Player::sendBosstiaryEntryChanged(uint32_t bossid) const {
	if (client) {
		client->sendBosstiaryEntryChanged(bossid);
	}
}

void Player::sendInventoryImbuements(const std::map<Slots_t, std::shared_ptr<Item>> &items) const {
	if (client) {
		client->sendInventoryImbuements(items);
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
	const auto &party = getParty();
	if (!party) {
		sendTextMessage(MESSAGE_LOOT, message);
		return;
	}

	if (const auto &partyLeader = party->getLeader()) {
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
	const auto &parentItem = getParent() ? getParent()->getItem() : nullptr;
	if (isPlayerGroup() && parentItem && parentItem->getID() != ITEM_STORE_INBOX) {
		return nullptr;
	}

	const auto &inventoryItems = getInventoryItemsFromId(ITEM_GOLD_POUCH);
	if (inventoryItems.empty()) {
		return nullptr;
	}
	const auto &containerItem = inventoryItems.front();
	if (!containerItem) {
		return nullptr;
	}
	const auto &container = containerItem->getContainer();
	if (!container) {
		return nullptr;
	}

	return container;
}

std::shared_ptr<Container> Player::getStoreInbox() const {
	const auto &thing = getThing(CONST_SLOT_STORE_INBOX);
	if (!thing) {
		return nullptr;
	}

	const auto &storeInbox = thing->getContainer();
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
	for (const auto &condition : allowedConditions) {
		if (!condition) {
			continue;
		}

		if (getCondition(condition)) {
			hasPermittedCondition = true;
			break;
		}
	}

	return hasPermittedCondition;
}

uint16_t Player::getDodgeChance() const {
	uint16_t chance = 0;
	if (const auto &playerArmor = getInventoryItem(CONST_SLOT_ARMOR);
	    playerArmor != nullptr && playerArmor->getTier()) {
		chance += static_cast<uint16_t>(playerArmor->getDodgeChance() * 100);
	}

	chance += m_wheelPlayer->getStat(WheelStat_t::DODGE);

	return chance;
}

uint8_t Player::isRandomMounted() const {
	return randomMount;
}

void Player::setRandomMount(uint8_t isMountRandomized) {
	randomMount = isMountRandomized;
}

void Player::sendFYIBox(const std::string &message) const {
	if (client) {
		client->sendFYIBox(message);
	}
}

void Player::BestiarysendCharms() const {
	if (client) {
		client->BestiarysendCharms();
	}
}

void Player::addBestiaryKillCount(uint16_t raceid, uint32_t amount) {
	const uint32_t oldCount = getBestiaryKillCount(raceid);
	const uint32_t key = STORAGEVALUE_BESTIARYKILLCOUNT + raceid;
	addStorageValue(key, static_cast<int32_t>(oldCount + amount), true);
}

uint32_t Player::getBestiaryKillCount(uint16_t raceid) const {
	const uint32_t key = STORAGEVALUE_BESTIARYKILLCOUNT + raceid;
	const auto value = getStorageValue(key);
	return value > 0 ? static_cast<uint32_t>(value) : 0;
}

void Player::setGUID(uint32_t newGuid) {
	this->guid = newGuid;
}

uint32_t Player::getGUID() const {
	return guid;
}

bool Player::canSeeInvisibility() const {
	return hasFlag(PlayerFlags_t::CanSenseInvisibility) || group->access;
}

void Player::checkAndShowBlessingMessage() {
	auto adventurerBlessingLevel = g_configManager().getNumber(ADVENTURERSBLESSING_LEVEL);
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
	const int cipTibiaId = getVocation()->getClientId();
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
