/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019 Mark Samman <mark.samman@gmail.com>
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

#include "pch.hpp"

#include "creatures/combat/combat.h"
#include "creatures/interactions/chat.h"
#include "creatures/monsters/monster.h"
#include "creatures/monsters/monsters.h"
#include "creatures/players/player.h"
#include "game/game.h"
#include "game/scheduling/scheduler.h"
#include "grouping/familiars.h"
#include "lua/creature/creatureevent.h"
#include "lua/creature/events.h"
#include "lua/creature/movement.h"
#include "io/iologindata.h"
#include "io/iobestiary.h"
#include "items/bed.h"
#include "items/weapons/weapons.h"

MuteCountMap Player::muteCountMap;

uint32_t Player::playerAutoID = 0x10010000;

Player::Player(ProtocolGame_ptr p) :
                                    Creature(),
                                    lastPing(OTSYS_TIME()),
                                    lastPong(lastPing),
                                    inbox(new Inbox(ITEM_INBOX)),
                                    client(std::move(p)) {
  inbox->incrementReferenceCounter();
}

Player::~Player()
{
	for (Item* item : inventory) {
		if (item) {
			item->setParent(nullptr);
			item->stopDecaying();
			item->decrementReferenceCounter();
		}
	}

	for (const auto& it : depotLockerMap) {
		it.second->removeInbox(inbox);
		it.second->stopDecaying();
		it.second->decrementReferenceCounter();
	}

	for (const auto& it : rewardMap) {
		it.second->decrementReferenceCounter();
	}

	for (const auto& it : quickLootContainers) {
		it.second->decrementReferenceCounter();
	}

	for (PreySlot* slot : preys) {
		if (slot) {
			delete slot;
		}
	}

	for (TaskHuntingSlot* slot : taskHunting) {
		if (slot) {
			delete slot;
		}
	}

	inbox->stopDecaying();
	inbox->decrementReferenceCounter();

	setWriteItem(nullptr);
	setEditHouse(nullptr);
	logged = false;
}

bool Player::setVocation(uint16_t vocId)
{
	Vocation* voc = g_vocations().getVocation(vocId);
	if (!voc) {
		return false;
	}
	vocation = voc;

	updateRegeneration();
	g_game().addPlayerVocation(this);
	return true;
}

bool Player::isPushable() const
{
	if (hasFlag(PlayerFlag_CannotBePushed)) {
		return false;
	}
	return Creature::isPushable();
}

std::string Player::getDescription(int32_t lookDistance) const
{
	std::ostringstream s;

	if (lookDistance == -1) {
		s << "yourself.";

		if (group->access) {
			s << " You are " << group->name << '.';
		} else if (vocation->getId() != VOCATION_NONE) {
			s << " You are " << vocation->getVocDescription() << '.';
		} else {
			s << " You have no vocation.";
		}
	} else {
		s << name;
		if (!group->access) {
			s << " (Level " << level << ')';
		}
		s << '.';

		if (sex == PLAYERSEX_FEMALE) {
			s << " She";
		} else {
			s << " He";
		}

		if (group->access) {
			s << " is " << group->name << '.';
		} else if (vocation->getId() != VOCATION_NONE) {
			s << " is " << vocation->getVocDescription() << '.';
		} else {
			s << " has no vocation.";
		}
	}

	if (party) {
		if (lookDistance == -1) {
			s << " Your party has ";
		} else if (sex == PLAYERSEX_FEMALE) {
			s << " She is in a party with ";
		} else {
			s << " He is in a party with ";
		}

		size_t memberCount = party->getMemberCount() + 1;
		if (memberCount == 1) {
			s << "1 member and ";
		} else {
			s << memberCount << " members and ";
		}

		size_t invitationCount = party->getInvitationCount();
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
		} else if (sex == PLAYERSEX_FEMALE) {
			s << " She is ";
		} else {
			s << " He is ";
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

Item* Player::getInventoryItem(Slots_t slot) const
{
	if (slot < CONST_SLOT_FIRST || slot > CONST_SLOT_LAST) {
		return nullptr;
	}
	return inventory[slot];
}

void Player::addConditionSuppressions(uint32_t addConditions)
{
	conditionSuppressions |= addConditions;
}

void Player::removeConditionSuppressions(uint32_t removeConditions)
{
	conditionSuppressions &= ~removeConditions;
}

Item* Player::getWeapon(Slots_t slot, bool ignoreAmmo) const
{
	Item* item = inventory[slot];
	if (!item) {
		return nullptr;
	}

	WeaponType_t weaponType = item->getWeaponType();
	if (weaponType == WEAPON_NONE || weaponType == WEAPON_SHIELD || weaponType == WEAPON_AMMO) {
		return nullptr;
	}

  if (!ignoreAmmo && weaponType == WEAPON_DISTANCE) {
    const ItemType& it = Item::items[item->getID()];
    if (it.ammoType != AMMO_NONE) {
      Item* quiver = inventory[CONST_SLOT_RIGHT];
      if (!quiver || !quiver->isQuiver())
        return nullptr;
      Container* container = quiver->getContainer();
      if (!container)
        return nullptr;
      bool found = false;
      for (Item* ammoItem : container->getItemList()) {
        if (ammoItem->getAmmoType() == it.ammoType) {
          if (level >= Item::items[ammoItem->getID()].minReqLevel) {
            item = ammoItem;
            found = true;
            break;
          }
        }
      }
      if (!found)
        return nullptr;
    }
  }
	return item;
}

Item* Player::getWeapon(bool ignoreAmmo/* = false*/) const
{
	Item* item = getWeapon(CONST_SLOT_LEFT, ignoreAmmo);
	if (item) {
		return item;
	}

	item = getWeapon(CONST_SLOT_RIGHT, ignoreAmmo);
	if (item) {
		return item;
	}
	return nullptr;
}

WeaponType_t Player::getWeaponType() const
{
	Item* item = getWeapon();
	if (!item) {
		return WEAPON_NONE;
	}
	return item->getWeaponType();
}

int32_t Player::getWeaponSkill(const Item* item) const
{
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

int32_t Player::getArmor() const
{
	int32_t armor = 0;

	static const Slots_t armorSlots[] = {CONST_SLOT_HEAD, CONST_SLOT_NECKLACE, CONST_SLOT_ARMOR, CONST_SLOT_LEGS, CONST_SLOT_FEET, CONST_SLOT_RING};
	for (Slots_t slot : armorSlots) {
		Item* inventoryItem = inventory[slot];
		if (inventoryItem) {
			armor += inventoryItem->getArmor();
		}
	}
	return static_cast<int32_t>(armor * vocation->armorMultiplier);
}

void Player::getShieldAndWeapon(const Item*& shield, const Item*& weapon) const
{
	shield = nullptr;
	weapon = nullptr;

	for (uint32_t slot = CONST_SLOT_RIGHT; slot <= CONST_SLOT_LEFT; slot++) {
		Item* item = inventory[slot];
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

int32_t Player::getDefense() const
{
	int32_t defenseSkill = getSkillLevel(SKILL_FIST);
	int32_t defenseValue = 7;
	const Item* weapon;
	const Item* shield;
	try {
		getShieldAndWeapon(shield, weapon);
	}
	catch (const std::exception &e) {
		SPDLOG_ERROR("{} got exception {}", getName(), e.what());
	}

	if (weapon) {
		defenseValue = weapon->getDefense() + weapon->getExtraDefense();
		defenseSkill = getWeaponSkill(weapon);
	}

	if (shield) {
		defenseValue = weapon != nullptr ? shield->getDefense() + weapon->getExtraDefense() : shield->getDefense();
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

float Player::getAttackFactor() const
{
	switch (fightMode) {
		case FIGHTMODE_ATTACK: return 1.0f;
		case FIGHTMODE_BALANCED: return 0.75f;
		case FIGHTMODE_DEFENSE: return 0.5f;
		default: return 1.0f;
	}
}

float Player::getDefenseFactor() const
{
	switch (fightMode) {
		case FIGHTMODE_ATTACK: return (OTSYS_TIME() - lastAttack) < getAttackSpeed() ? 0.5f : 1.0f;
		case FIGHTMODE_BALANCED: return (OTSYS_TIME() - lastAttack) < getAttackSpeed() ? 0.75f : 1.0f;
		case FIGHTMODE_DEFENSE: return 1.0f;
		default: return 1.0f;
	}
}

uint32_t Player::getClientIcons() const
{
	uint32_t icons = 0;
	for (Condition* condition : conditions) {
		if (!isSuppress(condition->getType())) {
			icons |= condition->getIcons();
		}
	}

	if (pzLocked) {
		icons |= ICON_REDSWORDS;
	}

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

void Player::updateInventoryWeight()
{
	if (hasFlag(PlayerFlag_HasInfiniteCapacity)) {
		return;
	}

	inventoryWeight = 0;
	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		const Item* item = inventory[i];
		if (item) {
			inventoryWeight += item->getWeight();
		}
	}
}

void Player::updateInventoryImbuement(bool init /* = false */)
{
	uint8_t imbuementsToCheck = g_game().getPlayerActiveImbuements(getID());
	for (int items = CONST_SLOT_FIRST; items <= CONST_SLOT_LAST; ++items) {
		/*
		 * Small optimization to avoid unneeded iteration.
		 */
		if (!init && imbuementsToCheck == 0) {
			break;
		}

		Item* item = inventory[items];
		if (!item) {
			continue;
		}

		for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
			ImbuementInfo imbuementInfo;
			if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
				continue;
			}

			// Time not decay on protection zone
			const Tile* playerTile = getTile();
			const CategoryImbuement *categoryImbuement = g_imbuements().getCategoryByID(imbuementInfo.imbuement->getCategory());
			if (categoryImbuement->agressive && playerTile && playerTile->hasFlag(TILESTATE_PROTECTIONZONE)) {
				continue;
			}

			// Time not decay if not is infight mode
			if (categoryImbuement->agressive && !hasCondition(CONDITION_INFIGHT)) {
				continue;
			}

			if (init) {
				g_game().increasePlayerActiveImbuements(getID());
			}

			int32_t duration = std::max<int32_t>(0, imbuementInfo.duration - EVENT_IMBUEMENT_INTERVAL / 1000);
			item->decayImbuementTime(slotid, imbuementInfo.imbuement->getID(), duration);
			if (duration == 0) {
				removeItemImbuementStats(imbuementInfo.imbuement);
				g_game().decreasePlayerActiveImbuements(getID());
			}

			imbuementsToCheck--;
		}
	}
}

void Player::setTraining(bool value) {
	for (const auto& [key, player] : g_game().getPlayers()) {
		if (!this->isInGhostMode() || player->isAccessPlayer()) {
			player->notifyStatusChange(this, value ? VIPSTATUS_TRAINING : VIPSTATUS_ONLINE, false);
		}
	}
	this->statusVipList = VIPSTATUS_TRAINING;
	setExerciseTraining(value);
}

void Player::addSkillAdvance(skills_t skill, uint64_t count)
{
	uint64_t currReqTries = vocation->getReqSkillTries(skill, skills[skill].level);
	uint64_t nextReqTries = vocation->getReqSkillTries(skill, skills[skill].level + 1);
	if (currReqTries >= nextReqTries) {
		//player has reached max skill
		return;
	}

	g_events().eventPlayerOnGainSkillTries(this, skill, count);
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

		g_creatureEvents().playerAdvance(this, skill, (skills[skill].level - 1), skills[skill].level);

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

void Player::setVarStats(stats_t stat, int32_t modifier)
{
	varStats[stat] += modifier;

	switch (stat) {
		case STAT_MAXHITPOINTS: {
			if (getHealth() > getMaxHealth()) {
				Creature::changeHealth(getMaxHealth() - getHealth());
			} else {
				g_game().addCreatureHealth(this);
			}
			break;
		}

		case STAT_MAXMANAPOINTS: {
			if (getMana() > getMaxMana()) {
				Creature::changeMana(getMaxMana() - getMana());
			}
			else {
				g_game().addPlayerMana(this);
			}
			break;
		}

		default: {
			break;
		}
	}
}

int64_t Player::getDefaultStats(stats_t stat) const
{
	switch (stat) {
		case STAT_MAXHITPOINTS: return healthMax;
		case STAT_MAXMANAPOINTS: return manaMax;
		case STAT_MAGICPOINTS: return getBaseMagicLevel();
		default: return 0;
	}
}

void Player::addContainer(uint8_t cid, Container* container)
{
	if (cid > 0xF) {
		return;
	}

	if (!container) {
		return;
	}

	if (container->getID() == ITEM_BROWSEFIELD) {
		container->incrementReferenceCounter();
	}

	auto it = openContainers.find(cid);
	if (it != openContainers.end()) {
		OpenContainer& openContainer = it->second;
		Container* oldContainer = openContainer.container;
		if (oldContainer->getID() == ITEM_BROWSEFIELD) {
			oldContainer->decrementReferenceCounter();
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

void Player::closeContainer(uint8_t cid)
{
	auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return;
	}

	OpenContainer openContainer = it->second;
	Container* container = openContainer.container;
	openContainers.erase(it);

	if (container && container->getID() == ITEM_BROWSEFIELD) {
		container->decrementReferenceCounter();
	}
}

void Player::setContainerIndex(uint8_t cid, uint16_t index)
{
	auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return;
	}
	it->second.index = index;
}

Container* Player::getContainerByID(uint8_t cid)
{
	auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return nullptr;
	}
	return it->second.container;
}

int8_t Player::getContainerID(const Container* container) const
{
	for (const auto& it : openContainers) {
		if (it.second.container == container) {
			return it.first;
		}
	}
	return -1;
}

uint16_t Player::getContainerIndex(uint8_t cid) const
{
	auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return 0;
	}
	return it->second.index;
}

bool Player::canOpenCorpse(uint32_t ownerId) const
{
	return getID() == ownerId || (party && party->canOpenCorpse(ownerId));
}

uint16_t Player::getLookCorpse() const
{
	if (sex == PLAYERSEX_FEMALE) {
		return ITEM_FEMALE_CORPSE;
	} else {
		return ITEM_MALE_CORPSE;
	}
}

void Player::addStorageValue(const uint32_t key, const int32_t value, const bool isLogin/* = false*/)
{
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
				value >> 16);
			return;
		} else {
			SPDLOG_WARN("Unknown reserved key: {} for player: {}", key, getName());
			return;
		}
	}

	if (value != -1) {
		int32_t oldValue;
		getStorageValue(key, oldValue);

		storageMap[key] = value;

		if (!isLogin) {
			auto currentFrameTime = g_dispatcher().getDispatcherCycle();
			g_events().eventOnStorageUpdate(this, key, value, oldValue, currentFrameTime);
		}
	} else {
		storageMap.erase(key);
	}
}

bool Player::getStorageValue(const uint32_t key, int32_t& value) const
{
	auto it = storageMap.find(key);
	if (it == storageMap.end()) {
		value = -1;
		return false;
	}

	value = it->second;
	return true;
}

bool Player::canSee(const Position& pos) const
{
	if (!client) {
		return false;
	}
	return client->canSee(pos);
}

bool Player::canSeeCreature(const Creature* creature) const
{
	if (creature == this) {
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

bool Player::canWalkthrough(const Creature* creature) const
{
	if (group->access || creature->isInGhostMode()) {
		return true;
	}

	const Player* player = creature->getPlayer();
	const Monster* monster = creature->getMonster();
	const Npc* npc = creature->getNpc();
	if (monster) {
		if (!monster->isFamiliar()) {
			return false;
		}
		return true;
	}

	if (player) {
		const Tile* playerTile = player->getTile();
		if (!playerTile || (!playerTile->hasFlag(TILESTATE_NOPVPZONE) && !playerTile->hasFlag(TILESTATE_PROTECTIONZONE) && player->getLevel() > static_cast<uint32_t>(g_configManager().getNumber(PROTECTION_LEVEL)) && g_game().getWorldType() != WORLD_TYPE_NO_PVP)) {
			return false;
		}

		const Item* playerTileGround = playerTile->getGround();
		if (!playerTileGround || !playerTileGround->hasWalkStack()) {
			return false;
		}

		Player* thisPlayer = const_cast<Player*>(this);
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
		const Tile* tile = npc->getTile();
		const HouseTile* houseTile = dynamic_cast<const HouseTile*>(tile);
		return (houseTile != nullptr);
	}

	return false;
}

bool Player::canWalkthroughEx(const Creature* creature) const
{
	if (group->access) {
		return true;
	}

	const Monster* monster = creature->getMonster();
	if (monster) {
		if (!monster->isFamiliar()) {
			return false;
		}
		return true;
	}

	const Player* player = creature->getPlayer();
	const Npc* npc = creature->getNpc();
	if (player) {
		const Tile* playerTile = player->getTile();
		return playerTile && (playerTile->hasFlag(TILESTATE_NOPVPZONE) || playerTile->hasFlag(TILESTATE_PROTECTIONZONE) || player->getLevel() <= static_cast<uint32_t>(g_configManager().getNumber(PROTECTION_LEVEL)) || g_game().getWorldType() == WORLD_TYPE_NO_PVP);
	} else if (npc) {
		const Tile* tile = npc->getTile();
		const HouseTile* houseTile = dynamic_cast<const HouseTile*>(tile);
		return (houseTile != nullptr);
	} else {
		return false;
	}

}

void Player::onReceiveMail() const
{
	if (isNearDepotBox()) {
		sendTextMessage(MESSAGE_EVENT_ADVANCE, "New mail has arrived.");
	}
}

Container* Player::setLootContainer(ObjectCategory_t category, Container* container, bool loading /* = false*/)
{
	Container* previousContainer = nullptr;
	auto it = quickLootContainers.find(category);
	if (it != quickLootContainers.end() && !loading) {
		previousContainer = (*it).second;
		int64_t flags = previousContainer->getIntAttr(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER);
		flags &= ~(1 << category);
		if (flags == 0) {
			previousContainer->removeAttribute(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER);
		} else {
			previousContainer->setIntAttr(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER, flags);
		}

		previousContainer->decrementReferenceCounter();
		quickLootContainers.erase(it);
	}

	if (container) {
		previousContainer = container;
		quickLootContainers[category] = container;

		container->incrementReferenceCounter();
		if (!loading) {
			int64_t flags = container->getIntAttr(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER);
			container->setIntAttr(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER, flags | static_cast<uint32_t>(1 << category));
		}
	}

	return previousContainer;
}

Container* Player::getLootContainer(ObjectCategory_t category) const
{
	if (category != OBJECTCATEGORY_DEFAULT && !isPremium()) {
		category = OBJECTCATEGORY_DEFAULT;
	}

	auto it = quickLootContainers.find(category);
	if (it != quickLootContainers.end()) {
		return (*it).second;
	}

	if (category != OBJECTCATEGORY_DEFAULT) {
		// firstly, fallback to default
		return getLootContainer(OBJECTCATEGORY_DEFAULT);
	}

	return nullptr;
}

void Player::checkLootContainers(const Item* item)
{
  if (!item) {
    return;
  }

	const Container* container = item->getContainer();
	if (!container) {
		return;
	}

	bool shouldSend = false;

	auto it = quickLootContainers.begin();
	while (it != quickLootContainers.end()) {
		Container* lootContainer = (*it).second;

		bool remove = false;
		if (item->getHoldingPlayer() != this && (item == lootContainer || container->isHoldingItem(lootContainer))) {
			remove = true;
		}

		if (remove) {
			shouldSend = true;
			it = quickLootContainers.erase(it);
			lootContainer->decrementReferenceCounter();
			lootContainer->removeAttribute(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER);
		} else {
			++it;
		}
	}

	if (shouldSend) {
		sendLootContainers();
	}
}

void Player::sendLootStats(Item* item, uint8_t count) const
{
	if (client) {
		client->sendLootStats(item, count);
	}

	if (party) {
		party->addPlayerLoot(this, item);
	}
}

bool Player::isNearDepotBox() const
{
	const Position& pos = getPosition();
	for (int32_t cx = -1; cx <= 1; ++cx) {
		for (int32_t cy = -1; cy <= 1; ++cy) {
			const Tile* posTile = g_game().map.getTile(static_cast<uint16_t>(pos.x + cx), static_cast<uint16_t>(pos.y + cy), pos.z);
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

DepotChest* Player::getDepotChest(uint32_t depotId, bool autoCreate)
{
	auto it = depotChests.find(depotId);
	if (it != depotChests.end()) {
		return it->second;
	}

	if (!autoCreate) {
		return nullptr;
	}

	DepotChest* depotChest;
	if (depotId > 0 && depotId < 18) {
		depotChest = new DepotChest(ITEM_DEPOT_NULL + depotId);
	} else if (depotId  == 18) {
		depotChest = new DepotChest(ITEM_DEPOT_XVIII);
	} else if (depotId  == 19) {
		depotChest = new DepotChest(ITEM_DEPOT_XIX);
	} else {
		depotChest = new DepotChest(ITEM_DEPOT_XX);
	}

	depotChest->incrementReferenceCounter();
	depotChests[depotId] = depotChest;
	return depotChest;
}

DepotLocker* Player::getDepotLocker(uint32_t depotId)
{
	auto it = depotLockerMap.find(depotId);
	if (it != depotLockerMap.end()) {
		inbox->setParent(it->second);
		for (uint32_t i = g_configManager().getNumber(DEPOT_BOXES); i > 0; i--) {
			if (DepotChest* depotBox = getDepotChest(i, false)) {
				depotBox->setParent(it->second->getItemByIndex(0)->getContainer());
 			}
		}
		return it->second;
	}

	DepotLocker* depotLocker = new DepotLocker(ITEM_LOCKER);
	depotLocker->setDepotId(depotId);
	depotLocker->internalAddThing(Item::CreateItem(ITEM_MARKET));
	depotLocker->internalAddThing(inbox);
	depotLocker->internalAddThing(Item::CreateItem(ITEM_SUPPLY_STASH));
	Container* depotChest = Item::CreateItemAsContainer(ITEM_DEPOT, static_cast<uint16_t>(g_configManager().getNumber(DEPOT_BOXES)));
	for (uint32_t i = g_configManager().getNumber(DEPOT_BOXES); i > 0; i--) {
		DepotChest* depotBox = getDepotChest(i, true);
		depotChest->internalAddThing(depotBox);
		depotBox->setParent(depotChest);
	}
	depotLocker->internalAddThing(depotChest);
	depotLockerMap[depotId] = depotLocker;
	return depotLocker;
}

RewardChest* Player::getRewardChest()
{
	if (rewardChest != nullptr) {
		return rewardChest;
	}

	rewardChest = new RewardChest(ITEM_REWARD_CHEST);
	return rewardChest;
}

Reward* Player::getReward(uint32_t rewardId, bool autoCreate)
{
	auto it = rewardMap.find(rewardId);
	if (it != rewardMap.end()) {
		return it->second;
	}

	if (!autoCreate) {
		return nullptr;
	}

	Reward* reward = new Reward();
	reward->incrementReferenceCounter();
	reward->setIntAttr(ITEM_ATTRIBUTE_DATE, rewardId);
	rewardMap[rewardId] = reward;

	g_game().internalAddItem(getRewardChest(), reward, INDEX_WHEREEVER, FLAG_NOLIMIT);

	return reward;
}

void Player::removeReward(uint32_t rewardId) {
	rewardMap.erase(rewardId);
}

void Player::getRewardList(std::vector<uint32_t>& rewards) {
	rewards.reserve(rewardMap.size());
	for (auto& it : rewardMap) {
		rewards.push_back(it.first);
	}
}

void Player::sendCancelMessage(ReturnValue message) const
{
	sendCancelMessage(getReturnMessage(message));
}

void Player::sendStats()
{
	if (client) {
		client->sendStats();
		lastStatsTrainingTime = getOfflineTrainingTime() / 60 / 1000;
	}
}

void Player::updateSupplyTracker(const Item* item) const
{
	if (client) {
		client->sendUpdateSupplyTracker(item);
	}

	if (party) {
		party->addPlayerSupply(this, item);
	}
}

void Player::updateImpactTracker(CombatType_t type, int32_t amount) const
{
	if (client) {
		client->sendUpdateImpactTracker(type, amount);
	}
}

void Player::sendPing()
{
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
	if ((hasLostConnection || noPongTime >= 7000) && attackedCreature && attackedCreature->getPlayer()) {
		setAttackedCreature(nullptr);
	}

	if (noPongTime >= 60000 && canLogout() && g_creatureEvents().playerLogout(this)) {
		if (client) {
			client->logout(true, true);
		} else {
			g_game().removeCreature(this, true);
		}
	}
}

Item* Player::getWriteItem(uint32_t& retWindowTextId, uint16_t& retMaxWriteLen)
{
	retWindowTextId = this->windowTextId;
	retMaxWriteLen = this->maxWriteLen;
	return writeItem;
}

void Player::setImbuingItem(Item* item)
{
	if (imbuingItem) {
		imbuingItem->decrementReferenceCounter();
	}

	if (item) {
		item->incrementReferenceCounter();
	}

	imbuingItem = item;
}

void Player::setWriteItem(Item* item, uint16_t maxWriteLength /*= 0*/)
{
	windowTextId++;

	if (writeItem) {
		writeItem->decrementReferenceCounter();
	}

	if (item) {
		writeItem = item;
		this->maxWriteLen = maxWriteLength;
		writeItem->incrementReferenceCounter();
	} else {
		writeItem = nullptr;
		this->maxWriteLen = 0;
	}
}

House* Player::getEditHouse(uint32_t& retWindowTextId, uint32_t& retListId)
{
	retWindowTextId = this->windowTextId;
	retListId = this->editListId;
	return editHouse;
}

void Player::setEditHouse(House* house, uint32_t listId /*= 0*/)
{
	windowTextId++;
	editHouse = house;
	editListId = listId;
}

void Player::sendHouseWindow(House* house, uint32_t listId) const
{
	if (!client) {
		return;
	}

	std::string text;
	if (house->getAccessList(listId, text)) {
		client->sendHouseWindow(windowTextId, text);
	}
}

void Player::onApplyImbuement(Imbuement *imbuement, Item *item, uint8_t slot, bool protectionCharm)
{
	if (!imbuement || !item) {
		return;
	}

	ImbuementInfo imbuementInfo;
	if (item->getImbuementInfo(slot, &imbuementInfo))
	{
		SPDLOG_ERROR("[Player::onApplyImbuement] - An error occurred while player with name {} try to apply imbuement, item already contains imbuement", this->getName());
		this->sendImbuementResult("An error ocurred, please reopen imbuement window.");
		return;
	}

	const auto& items = imbuement->getItems();
	for (auto& [key, value] : items)
	{
		const ItemType& itemType = Item::items[key];
		if (this->getItemTypeCount(key) + this->getStashItemCount(itemType.id) < value)
		{
			this->sendImbuementResult("You don't have all necessary items.");
			return;
		}
	}

	const BaseImbuement *baseImbuement = g_imbuements().getBaseByID(imbuement->getBaseID());
	if (!baseImbuement)
	{
		return;
	}

	uint32_t price = baseImbuement->price;
	price += protectionCharm ? baseImbuement->protectionPrice : 0;

	if (!g_game().removeMoney(this, price, 0, true))
	{
		std::string message = "You don't have " + std::to_string(price) + " gold coins.";

		SPDLOG_ERROR("[Player::onApplyImbuement] - An error occurred while player with name {} try to apply imbuement, player do not have money", this->getName());
		sendImbuementResult(message);
		return;
	}

	std::stringstream withdrawItemMessage;
	for (auto& [key, value] : items)
	{
		uint32_t inventoryItemCount = getItemTypeCount(key);
		if (inventoryItemCount >= value)
		{
			removeItemOfType(key, value, -1, true);
			continue;
		}

		uint32_t mathItemCount = value;
		if (inventoryItemCount > 0 && removeItemOfType(key, inventoryItemCount, -1, false))
		{
			mathItemCount = mathItemCount - inventoryItemCount;
		}

		const ItemType& itemType = Item::items[key];

		withdrawItemMessage << "Using " << mathItemCount << "x "<< itemType.name <<" from your supply stash. ";
		withdrawItem(itemType.id, mathItemCount);
	}

	sendTextMessage(MESSAGE_STATUS, withdrawItemMessage.str());

	if (!protectionCharm && uniform_random(1, 100) > baseImbuement->percent)
	{
		openImbuementWindow(item);
		sendImbuementResult("Oh no!\n\nThe imbuement has failed. You have lost the astral sources and gold you needed for the imbuement.\n\nNext time use a protection charm to better your chances.");
		openImbuementWindow(item);
		return;
	}

	item->addImbuement(slot, imbuement->getID(), baseImbuement->duration);

	// Update imbuement stats item if the item is equipped
	if (item->getParent() == this) {
		addItemImbuementStats(imbuement);
	}
	openImbuementWindow(item);
}

void Player::onClearImbuement(Item* item, uint8_t slot)
{
	if (!item) {
		return;
	}

	ImbuementInfo imbuementInfo;
	if (!item->getImbuementInfo(slot, &imbuementInfo))
	{
		SPDLOG_ERROR("[Player::onClearImbuement] - An error occurred while player with name {} try to apply imbuement, item not contains imbuement", this->getName());
		this->sendImbuementResult("An error ocurred, please reopen imbuement window.");
		return;
	}

	const BaseImbuement *baseImbuement = g_imbuements().getBaseByID(imbuementInfo.imbuement->getBaseID());
	if (!baseImbuement) {
		return;
	}

	if (!g_game().removeMoney(this, baseImbuement->removeCost, 0, true))
	{
		std::string message = "You don't have " + std::to_string(baseImbuement->removeCost) + " gold coins.";

		SPDLOG_ERROR("[Player::onClearImbuement] - An error occurred while player with name {} try to apply imbuement, player do not have money", this->getName());
		this->sendImbuementResult(message);
		this->openImbuementWindow(item);
		return;
	}

	if (item->getParent() == this) {
		removeItemImbuementStats(imbuementInfo.imbuement);
	}

	item->clearImbuement(slot, imbuementInfo.imbuement->getID());
	this->openImbuementWindow(item);
}

void Player::openImbuementWindow(Item* item)
{
	if (!client || !item) {
		return;
	}

	if (item->getTopParent() != this) {
		this->sendTextMessage(MESSAGE_FAILURE,
			"You have to pick up the item to imbue it.");
		return;
	}

	if (item->getImbuementSlot() <= 0) {
		this->sendTextMessage(MESSAGE_FAILURE, "This item is not imbuable.");
		return;
	}

	client->openImbuementWindow(item);
}

void Player::sendMarketEnter(uint32_t depotId)
{
	if (!client || this->getLastDepotId() == -1 || !depotId) {
		return;
	}
	
	client->sendMarketEnter(depotId);
}

//container
void Player::sendAddContainerItem(const Container* container, const Item* item)
{
	if (!client) {
		return;
	}

	if (!container) {
		return;
	}

	for (const auto& it : openContainers) {
		const OpenContainer& openContainer = it.second;
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

void Player::sendUpdateContainerItem(const Container* container, uint16_t slot, const Item* newItem)
{
	if (!client) {
		return;
	}

	for (const auto& it : openContainers) {
		const OpenContainer& openContainer = it.second;
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

void Player::sendRemoveContainerItem(const Container* container, uint16_t slot)
{
	if (!client) {
		return;
	}

	if (!container) {
		return;
	}

	for (auto& it : openContainers) {
		OpenContainer& openContainer = it.second;
		if (openContainer.container != container) {
			continue;
		}

		uint16_t& firstIndex = openContainer.index;
		if (firstIndex > 0 && firstIndex >= container->size() - 1) {
			firstIndex -= container->capacity();
			sendContainer(it.first, container, false, firstIndex);
		}

		client->sendRemoveContainerItem(it.first, std::max<uint16_t>(slot, firstIndex), container->getItemByIndex(container->capacity() + firstIndex));
	}
}

void Player::onUpdateTileItem(const Tile* updateTile, const Position& pos, const Item* oldItem,
                              const ItemType& oldType, const Item* newItem, const ItemType& newType)
{
	Creature::onUpdateTileItem(updateTile, pos, oldItem, oldType, newItem, newType);

	if (oldItem != newItem) {
		onRemoveTileItem(updateTile, pos, oldType, oldItem);
	}

	if (tradeState != TRADE_TRANSFER) {
		if (tradeItem && oldItem == tradeItem) {
			g_game().internalCloseTrade(this);
		}
	}
}

void Player::onRemoveTileItem(const Tile* fromTile, const Position& pos, const ItemType& iType,
                              const Item* item)
{
	Creature::onRemoveTileItem(fromTile, pos, iType, item);

	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(item);

		if (tradeItem) {
			const Container* container = item->getContainer();
			if (container && container->isHoldingItem(tradeItem)) {
				g_game().internalCloseTrade(this);
			}
		}
	}

  checkLootContainers(item);
}

void Player::onCreatureAppear(Creature* creature, bool isLogin)
{
	Creature::onCreatureAppear(creature, isLogin);

	if (isLogin && creature == this) {
		for (int32_t slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; ++slot) {
			Item* item = inventory[slot];
			if (item) {
				item->startDecaying();
				g_moveEvents().onPlayerEquip(*this, *item, static_cast<Slots_t>(slot), false);
			}
		}

		for (Condition* condition : storedConditionList) {
			addCondition(condition);
		}
		storedConditionList.clear();

		updateRegeneration();

		BedItem* bed = g_game().getBedBySleeper(guid);
		if (bed) {
			bed->wakeUp(this);
		}

		SPDLOG_INFO("{} has logged in", name);

		if (guild) {
			guild->addMember(this);
		}

		int32_t offlineTime;
		if (getLastLogout() != 0) {
			// Not counting more than 21 days to prevent overflow when multiplying with 1000 (for milliseconds).
			offlineTime = std::min<int32_t>(time(nullptr) - getLastLogout(), 86400 * 21);
		} else {
			offlineTime = 0;
		}

		for (Condition* condition : getMuteConditions()) {
			condition->setTicks(condition->getTicks() - (offlineTime * 1000));
			if (condition->getTicks() <= 0) {
				removeCondition(condition);
			}
		}

		// Reload bestiary tracker
		refreshBestiaryTracker(getBestiaryTrackerList());

		g_game().checkPlayersRecord();
		IOLoginData::updateOnlineStatus(guid, true);
		if (getLevel() < g_configManager().getNumber(ADVENTURERSBLESSING_LEVEL)) {
			for (uint8_t i = 2; i <= 6; i++) {
				if (!hasBlessing(i)) {
					addBlessing(i, 1);
				}
			}
			sendBlessStatus();
		}
	}
}

void Player::onAttackedCreatureDisappear(bool isLogout)
{
	sendCancelTarget();

	if (!isLogout) {
		sendTextMessage(MESSAGE_FAILURE, "Target lost.");
	}
}

void Player::onFollowCreatureDisappear(bool isLogout)
{
	sendCancelTarget();

	if (!isLogout) {
		sendTextMessage(MESSAGE_FAILURE, "Target lost.");
	}
}

void Player::onChangeZone(ZoneType_t zone)
{
	if (zone == ZONE_PROTECTION) {
		if (attackedCreature && !hasFlag(PlayerFlag_IgnoreProtectionZone)) {
			setAttackedCreature(nullptr);
			onAttackedCreatureDisappear(false);
		}

		if (!group->access && isMounted()) {
			dismount();
			g_game().internalCreatureChangeOutfit(this, defaultOutfit);
			wasMounted = true;
		}
	} else {
		if (wasMounted) {
			toggleMount(true);
			wasMounted = false;
		}
	}

	g_game().updateCreatureWalkthrough(this);
	sendIcons();
	g_events().eventPlayerOnChangeZone(this, zone);
}

void Player::onAttackedCreatureChangeZone(ZoneType_t zone)
{
	if (zone == ZONE_PROTECTION) {
		if (!hasFlag(PlayerFlag_IgnoreProtectionZone)) {
			setAttackedCreature(nullptr);
			onAttackedCreatureDisappear(false);
		}
	} else if (zone == ZONE_NOPVP) {
		if (attackedCreature->getPlayer()) {
			if (!hasFlag(PlayerFlag_IgnoreProtectionZone)) {
				setAttackedCreature(nullptr);
				onAttackedCreatureDisappear(false);
			}
		}
	} else if (zone == ZONE_NORMAL && g_game().getWorldType() == WORLD_TYPE_NO_PVP) {
		//attackedCreature can leave a pvp zone if not pzlocked
		if (attackedCreature->getPlayer()) {
			setAttackedCreature(nullptr);
			onAttackedCreatureDisappear(false);
		}
	}
}

void Player::onRemoveCreature(Creature* creature, bool isLogout)
{
	Creature::onRemoveCreature(creature, isLogout);

	if (creature == this) {
		if (isLogout) {
			if (party) {
				party->leaveParty(this);
			}
			if (guild) {
				guild->removeMember(this);
			}

			loginPosition = getPosition();
			lastLogout = time(nullptr);
			SPDLOG_INFO("{} has logged out", getName());
			g_chat().removeUserFromAllChannels(*this);
			clearPartyInvitations();
			IOLoginData::updateOnlineStatus(guid, false);
		}

		if (eventWalk != 0) {
			setFollowCreature(nullptr);
		}

		if (tradePartner) {
			g_game().internalCloseTrade(this);
		}

		closeShopWindow();

		bool saved = false;
		for (uint32_t tries = 0; tries < 3; ++tries) {
			if (IOLoginData::savePlayer(this)) {
				saved = true;
				break;
			}
		}

		if (!saved) {
			SPDLOG_WARN("Error while saving player: {}", getName());
		}
	}

	if (creature == shopOwner) {
		setShopOwner(nullptr);
		sendCloseShop();
	}
}

bool Player::openShopWindow(Npc* npc)
{
	if (!npc) {
		SPDLOG_ERROR("[Player::openShopWindow] - Npc is wrong or nullptr");
		return false;
	}

	setShopOwner(npc);
	npc->addShopPlayer(this);

	sendShop(npc);
	std::map<uint16_t, uint16_t> inventoryMap;
	sendSaleItemList(getAllSaleItemIdAndCount(inventoryMap));
	return true;
}

bool Player::closeShopWindow(bool sendCloseShopWindow /*= true*/)
{
	if (!shopOwner) {
		return false;
	}

	shopOwner->removeShopPlayer(this);
	setShopOwner(nullptr);

	if (sendCloseShopWindow) {
		sendCloseShop();
	}

	return true;
}

void Player::onWalk(Direction& dir)
{
	Creature::onWalk(dir);
	setNextActionTask(nullptr);
	setNextAction(OTSYS_TIME() + getStepDuration(dir));
}

void Player::onCreatureMove(Creature* creature, const Tile* newTile, const Position& newPos,
							const Tile* oldTile, const Position& oldPos, bool teleport)
{
	Creature::onCreatureMove(creature, newTile, newPos, oldTile, oldPos, teleport);

	if (hasFollowPath && (creature == followCreature || (creature == this && followCreature))) {
		isUpdatingPath = false;
		g_dispatcher().addTask(createTask(std::bind(&Game::updateCreatureWalk, &g_game(), getID())));
	}

	if (creature != this) {
		return;
	}

	if (tradeState != TRADE_TRANSFER) {
		//check if we should close trade
		if (tradeItem && !Position::areInRange<1, 1, 0>(tradeItem->getPosition(), getPosition())) {
			g_game().internalCloseTrade(this);
		}

		if (tradePartner && !Position::areInRange<2, 2, 0>(tradePartner->getPosition(), getPosition())) {
			g_game().internalCloseTrade(this);
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

	if (party) {
		party->updateSharedExperience();
		party->updatePlayerStatus(this, oldPos, newPos);
	}

	if (teleport || oldPos.z != newPos.z) {
		int32_t ticks = g_configManager().getNumber(STAIRHOP_DELAY);
		if (ticks > 0) {
			if (Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_PACIFIED, ticks, 0)) {
				addCondition(condition);
			}
		}
	}
}

//container
void Player::onAddContainerItem(const Item* item)
{
	checkTradeState(item);
}

void Player::onUpdateContainerItem(const Container* container, const Item* oldItem, const Item* newItem)
{
	if (oldItem != newItem) {
		onRemoveContainerItem(container, oldItem);
	}

	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(oldItem);
	}
}

void Player::onRemoveContainerItem(const Container* container, const Item* item)
{
	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(item);

		if (tradeItem) {
			if (tradeItem->getParent() != container && container->isHoldingItem(tradeItem)) {
				g_game().internalCloseTrade(this);
			}
		}
	}

  checkLootContainers(item);
}

void Player::onCloseContainer(const Container* container)
{
	if (!client) {
		return;
	}

	for (const auto& it : openContainers) {
		if (it.second.container == container) {
			client->sendCloseContainer(it.first);
		}
	}
}

void Player::onSendContainer(const Container* container)
{
	if (!client) {
		return;
	}

	bool hasParent = container->hasParent();
	for (const auto& it : openContainers) {
		const OpenContainer& openContainer = it.second;
		if (openContainer.container == container) {
			client->sendContainer(it.first, container, hasParent, openContainer.index);
		}
	}
}

//inventory
void Player::onUpdateInventoryItem(Item* oldItem, Item* newItem)
{
	if (oldItem != newItem) {
		onRemoveInventoryItem(oldItem);
	}

	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(oldItem);
	}
}

void Player::onRemoveInventoryItem(Item* item)
{
	if (tradeState != TRADE_TRANSFER) {
		checkTradeState(item);

		if (tradeItem) {
			const Container* container = item->getContainer();
			if (container && container->isHoldingItem(tradeItem)) {
				g_game().internalCloseTrade(this);
			}
		}
	}

  checkLootContainers(item);
}

void Player::checkTradeState(const Item* item)
{
	if (!tradeItem || tradeState == TRADE_TRANSFER) {
		return;
	}

	if (tradeItem == item) {
		g_game().internalCloseTrade(this);
	} else {
		const Container* container = dynamic_cast<const Container*>(item->getParent());
		while (container) {
			if (container == tradeItem) {
				g_game().internalCloseTrade(this);
				break;
			}

			container = dynamic_cast<const Container*>(container->getParent());
		}
	}
}

void Player::setNextWalkActionTask(SchedulerTask* task)
{
	if (walkTaskEvent != 0) {
		g_scheduler().stopEvent(walkTaskEvent);
		walkTaskEvent = 0;
	}

	delete walkTask;
	walkTask = task;
}

void Player::setNextWalkTask(SchedulerTask* task)
{
	if (nextStepEvent != 0) {
		g_scheduler().stopEvent(nextStepEvent);
		nextStepEvent = 0;
	}

	if (task) {
		nextStepEvent = g_scheduler().addEvent(task);
		resetIdleTime();
	}
}

void Player::setNextActionTask(SchedulerTask* task, bool resetIdleTime /*= true */)
{
	if (actionTaskEvent != 0) {
		g_scheduler().stopEvent(actionTaskEvent);
		actionTaskEvent = 0;
	}

	if (!inEventMovePush && !g_configManager().getBoolean(PUSH_WHEN_ATTACKING)) {
		cancelPush();
	}

	if (task) {
		actionTaskEvent = g_scheduler().addEvent(task);
		if (resetIdleTime) {
			this->resetIdleTime();
		}
	}
}

void Player::setNextActionPushTask(SchedulerTask* task)
{
	if (actionTaskEventPush != 0) {
		g_scheduler().stopEvent(actionTaskEventPush);
		actionTaskEventPush = 0;
	}

	if (task) {
		actionTaskEventPush = g_scheduler().addEvent(task);
	}
}

void Player::setNextPotionActionTask(SchedulerTask* task)
{
	if (actionPotionTaskEvent != 0) {
		g_scheduler().stopEvent(actionPotionTaskEvent);
		actionPotionTaskEvent = 0;
	}

	cancelPush();

	if (task) {
		actionPotionTaskEvent = g_scheduler().addEvent(task);
		//resetIdleTime();
	}
}

uint32_t Player::getNextActionTime() const
{
	return std::max<int64_t>(SCHEDULER_MINTICKS, nextAction - OTSYS_TIME());
}

uint32_t Player::getNextPotionActionTime() const
{
	return std::max<int64_t>(SCHEDULER_MINTICKS, nextPotionAction - OTSYS_TIME());
}

void Player::cancelPush()
{
	if (actionTaskEventPush !=  0) {
		g_scheduler().stopEvent(actionTaskEventPush);
		actionTaskEventPush = 0;
		inEventMovePush = false;
	}
}

void Player::onThink(uint32_t interval)
{
	Creature::onThink(interval);

	sendPing();

	MessageBufferTicks += interval;
	if (MessageBufferTicks >= 1500) {
		MessageBufferTicks = 0;
		addMessageBuffer();
	}

	// Momentum (cooldown resets)
	triggerMomentum();

	if (!getTile()->hasFlag(TILESTATE_NOLOGOUT) && !isAccessPlayer() && !isExerciseTraining()) {
		idleTime += interval;
		const int32_t kickAfterMinutes = g_configManager().getNumber(KICK_AFTER_MINUTES);
		if (idleTime > (kickAfterMinutes * 60000) + 60000) {
			removePlayer(true);
		} else if (client && idleTime == 60000 * kickAfterMinutes) {
			std::ostringstream ss;
			ss << "There was no variation in your behaviour for " << kickAfterMinutes << " minutes. You will be disconnected in one minute if there is no change in your actions until then.";
			client->sendTextMessage(TextMessage(MESSAGE_ADMINISTRADOR, ss.str()));
		}
	}

	if (g_game().getWorldType() != WORLD_TYPE_PVP_ENFORCED) {
		checkSkullTicks(interval / 1000);
	}

	addOfflineTrainingTime(interval);
	if (lastStatsTrainingTime != getOfflineTrainingTime() / 60 / 1000) {
		sendStats();
	}
}

uint32_t Player::isMuted() const
{
	if (hasFlag(PlayerFlag_CannotBeMuted)) {
		return 0;
	}

	int32_t muteTicks = 0;
	for (Condition* condition : conditions) {
		if (condition->getType() == CONDITION_MUTED && condition->getTicks() > muteTicks) {
			muteTicks = condition->getTicks();
		}
	}
	return static_cast<uint32_t>(muteTicks) / 1000;
}

void Player::addMessageBuffer()
{
	if (MessageBufferCount > 0 && g_configManager().getNumber(MAX_MESSAGEBUFFER) != 0 && !hasFlag(PlayerFlag_CannotBeMuted)) {
		--MessageBufferCount;
	}
}

void Player::removeMessageBuffer()
{
	if (hasFlag(PlayerFlag_CannotBeMuted)) {
		return;
	}

	const int32_t maxMessageBuffer = g_configManager().getNumber(MAX_MESSAGEBUFFER);
	if (maxMessageBuffer != 0 && MessageBufferCount <= maxMessageBuffer + 1) {
		if (++MessageBufferCount > maxMessageBuffer) {
			uint32_t muteCount = 1;
			auto it = muteCountMap.find(guid);
			if (it != muteCountMap.end()) {
				muteCount = it->second;
			}

			uint32_t muteTime = 5 * muteCount * muteCount;
			muteCountMap[guid] = muteCount + 1;
			Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_MUTED, muteTime * 1000, 0);
			addCondition(condition);

			std::ostringstream ss;
			ss << "You are muted for " << muteTime << " seconds.";
			sendTextMessage(MESSAGE_FAILURE, ss.str());
		}
	}
}

void Player::drainHealth(Creature* attacker, int64_t damage)
{
	Creature::drainHealth(attacker, damage);
	sendStats();
}

void Player::drainMana(Creature* attacker, int64_t manaLoss)
{
	Creature::drainMana(attacker, manaLoss);
	sendStats();
}

void Player::addManaSpent(uint64_t amount)
{
	if (hasFlag(PlayerFlag_NotGainMana)) {
		return;
	}

	uint64_t currReqMana = vocation->getReqMana(magLevel);
	uint64_t nextReqMana = vocation->getReqMana(magLevel + 1);
	if (currReqMana >= nextReqMana) {
		//player has reached max magic level
		return;
	}

	g_events().eventPlayerOnGainSkillTries(this, SKILL_MAGLEVEL, amount);
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

		g_creatureEvents().playerAdvance(this, SKILL_MAGLEVEL, magLevel - 1, magLevel);

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

void Player::addExperience(Creature* target, uint64_t exp, bool sendText/* = false*/)
{
	uint64_t currLevelExp = Player::getExpForLevel(level);
	uint64_t nextLevelExp = Player::getExpForLevel(level + 1);
	uint64_t rawExp = exp;
	if (currLevelExp >= nextLevelExp) {
		//player has reached max level
		levelPercent = 0;
		sendStats();
		return;
	}

	g_events().eventPlayerOnGainExperience(this, target, exp, rawExp);
	if (exp == 0) {
		return;
	}

	experience += exp;

	if (sendText) {
		std::string expString = std::to_string(exp) + (exp != 1 ? " experience points." : " experience point.");

		TextMessage message(MESSAGE_EXPERIENCE, "You gained " + expString);
		message.position = position;
		message.primary.value = static_cast<int64_t>(exp);
		message.primary.color = TEXTCOLOR_WHITE_EXP;
		sendTextMessage(message);

		SpectatorHashSet spectators;
		g_game().map.getSpectators(spectators, position, false, true);
		spectators.erase(this);
		if (!spectators.empty()) {
			message.type = MESSAGE_EXPERIENCE_OTHERS;
			message.text = getName() + " gained " + expString;
			for (Creature* spectator : spectators) {
				spectator->getPlayer()->sendTextMessage(message);
			}
		}
	}

	uint32_t prevLevel = level;
	while (experience >= nextLevelExp) {
		++level;
		// Player stats gain for vocations level <= 8
		if (vocation->getId() != VOCATION_NONE && level <= 8) {
			const Vocation* noneVocation = g_vocations().getVocation(VOCATION_NONE);
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
			//player has reached max level
			break;
		}
	}

	if (prevLevel != level) {
		health = healthMax;
		mana = manaMax;

		updateBaseSpeed();
		setBaseSpeed(getBaseSpeed());
		g_game().changeSpeed(this, 0);
		g_game().addCreatureHealth(this);
		g_game().addPlayerMana(this);

		if (party) {
			party->updateSharedExperience();
		}

		g_creatureEvents().playerAdvance(this, SKILL_LEVEL, prevLevel, level);

		std::ostringstream ss;
		ss << "You advanced from Level " << prevLevel << " to Level " << level << '.';
		sendTextMessage(MESSAGE_EVENT_ADVANCE, ss.str());
	}

	if (nextLevelExp > currLevelExp) {
		levelPercent = Player::getPercentLevel(experience - currLevelExp, nextLevelExp - currLevelExp);
	} else {
		levelPercent = 0;
	}
	sendStats();
	sendExperienceTracker(rawExp, exp);
}

void Player::removeExperience(uint64_t exp, bool sendText/* = false*/)
{
	if (experience == 0 || exp == 0) {
		return;
	}

	g_events().eventPlayerOnLoseExperience(this, exp);
	if (exp == 0) {
		return;
	}

	uint64_t lostExp = experience;
	experience = std::max<int64_t>(0, experience - exp);

	if (sendText) {
		lostExp -= experience;

		std::string expString = std::to_string(lostExp) + (lostExp != 1 ? " experience points." : " experience point.");

		TextMessage message(MESSAGE_EXPERIENCE, "You lost " + expString);
		message.position = position;
		message.primary.value = static_cast<int64_t>(lostExp);
		message.primary.color = TEXTCOLOR_RED;
		sendTextMessage(message);

		SpectatorHashSet spectators;
		g_game().map.getSpectators(spectators, position, false, true);
		spectators.erase(this);
		if (!spectators.empty()) {
			message.type = MESSAGE_EXPERIENCE_OTHERS;
			message.text = getName() + " lost " + expString;
			for (Creature* spectator : spectators) {
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
			const Vocation* noneVocation = g_vocations().getVocation(VOCATION_NONE);
			healthMax = std::max<int64_t>(0, healthMax - noneVocation->getHPGain());
			manaMax = std::max<int64_t>(0, manaMax - noneVocation->getManaGain());
			capacity = std::max<int32_t>(0, capacity - noneVocation->getCapGain());
		} else {
			healthMax = std::max<int64_t>(0, healthMax - vocation->getHPGain());
			manaMax = std::max<int64_t>(0, manaMax - vocation->getManaGain());
			capacity = std::max<int32_t>(0, capacity - vocation->getCapGain());
		}
		currLevelExp = Player::getExpForLevel(level);
	}

	if (oldLevel != level) {
		health = healthMax;
		mana = manaMax;

		updateBaseSpeed();
		setBaseSpeed(getBaseSpeed());

		g_game().changeSpeed(this, 0);
		g_game().addCreatureHealth(this);
		g_game().addPlayerMana(this);

		if (party) {
			party->updateSharedExperience();
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

double_t Player::getPercentLevel(uint64_t count, uint64_t nextLevelCount)
{
	if (nextLevelCount == 0) {
		return 0;
	}

  double_t result = round( ((count * 100.) / nextLevelCount) * 100.) / 100.;
	if (result > 100) {
		return 0;
	}
	return result;
}

void Player::onBlockHit()
{
	if (shieldBlockCount > 0) {
		--shieldBlockCount;

		if (hasShield()) {
			addSkillAdvance(SKILL_SHIELD, 1);
		}
	}
}

void Player::onAttackedCreatureBlockHit(BlockType_t blockType)
{
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
			//need to draw blood every 30 hits
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

bool Player::hasShield() const
{
	Item* item = inventory[CONST_SLOT_LEFT];
	if (item && item->getWeaponType() == WEAPON_SHIELD) {
		return true;
	}

	item = inventory[CONST_SLOT_RIGHT];
	if (item && item->getWeaponType() == WEAPON_SHIELD) {
		return true;
	}
	return false;
}

BlockType_t Player::blockHit(Creature* attacker, CombatType_t combatType, int64_t& damage,
                              bool checkDefense /* = false*/, bool checkArmor /* = false*/, bool field /* = false*/)
{
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
				SPDLOG_WARN("NOT ABILIT SLOT {}", slot);
				continue;
			}

			Item* item = inventory[slot];
			if (!item) {
				continue;
			}

			const ItemType& it = Item::items[item->getID()];
			if (it.abilities) {
				const int16_t& absorbPercent = it.abilities->absorbPercent[combatTypeToIndex(combatType)];
				if (absorbPercent != 0) {
					damage -= std::round(damage * (absorbPercent / 100.));

					SPDLOG_WARN("NOT DECAY CHARGES ITEM {}", item->getID());
					uint16_t charges = item->getCharges();
					if (charges != 0) {
						SPDLOG_WARN("DECAY CHARGES ITEM {}", item->getID());
						g_game().transformItem(item, item->getID(), charges - 1);
					}
				}

				if (field) {
					const int16_t& fieldAbsorbPercent = it.abilities->fieldAbsorbPercent[combatTypeToIndex(combatType)];
					if (fieldAbsorbPercent != 0) {
						damage -= std::round(damage * (fieldAbsorbPercent / 100.));

						uint16_t charges = item->getCharges();
						if (charges != 0) {
							g_game().transformItem(item, item->getID(), charges - 1);
						}
					}
				}
				if (attacker) {
					const int16_t& reflectPercent = it.abilities->reflectPercent[combatTypeToIndex(combatType)];
					if (reflectPercent != 0) {
						CombatParams params;
						params.combatType = combatType;
						params.impactEffect = CONST_ME_MAGIC_BLUE;

						CombatDamage reflectDamage;
						reflectDamage.origin = ORIGIN_SPELL;
						reflectDamage.primary.type = combatType;
						reflectDamage.primary.value = std::round(-damage * (reflectPercent / 100.));

						Combat::doCombatHealth(this, attacker, reflectDamage, params);
					}
				}
			}

			for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++)
			{
				ImbuementInfo imbuementInfo;
				if (!item->getImbuementInfo(slotid, &imbuementInfo))
				{
					continue;
				}

				const int16_t& imbuementAbsorbPercent = imbuementInfo.imbuement->absorbPercent[combatTypeToIndex(combatType)];

				if (imbuementAbsorbPercent != 0) {
					damage -= std::ceil(damage * (imbuementAbsorbPercent / 100.));
				}
			}

		}

		if (damage <= 0) {
			damage = 0;
			blockType = BLOCK_ARMOR;
		}
	}
	return blockType;
}

uint32_t Player::getIP() const
{
	if (client) {
		return client->getIP();
	}

	return 0;
}

void Player::death(Creature* lastHitCreature)
{
	loginPosition = town->getTemplePosition();

	g_game().sendSingleSoundEffect(this->getPosition(), sex == PLAYERSEX_FEMALE ? SOUND_EFFECT_TYPE_HUMAN_FEMALE_DEATH : SOUND_EFFECT_TYPE_HUMAN_MALE_DEATH, this);
	if (skillLoss) {
		uint8_t unfairFightReduction = 100;
		int playerDmg = 0;
		int othersDmg = 0;
		uint32_t sumLevels = 0;
		uint32_t inFightTicks = 5 * 60 * 1000;
		for (const auto& it : damageMap) {
			CountBlock_t cb = it.second;
			if ((OTSYS_TIME() - cb.ticks) <= inFightTicks) {
				const Player* damageDealer = g_game().getPlayerByID(it.first);
				if (damageDealer) {
					playerDmg += cb.total;
					sumLevels += damageDealer->getLevel();
				}
				else{
					othersDmg += cb.total;
				}
			}
		}
		bool pvpDeath = false;
		if(playerDmg > 0 || othersDmg > 0){
			pvpDeath = (Player::lastHitIsPlayer(lastHitCreature) || playerDmg / (playerDmg + static_cast<double>(othersDmg)) >= 0.05);
		}
		if (pvpDeath && sumLevels > level) {
			double reduce = level / static_cast<double>(sumLevels);
			unfairFightReduction = std::max<uint8_t>(20, std::floor((reduce * 100) + 0.5));
		}

		//Magic level loss
		uint64_t sumMana = 0;
		uint64_t lostMana = 0;

		//sum up all the mana
		for (uint32_t i = 1; i <= magLevel; ++i) {
			sumMana += vocation->getReqMana(i);
		}

		sumMana += manaSpent;

		double deathLossPercent = getLostPercent() * (unfairFightReduction / 100.);

		// Charm bless bestiary
		if (lastHitCreature && lastHitCreature->getMonster()) {
			if (charmRuneBless != 0) {
				const MonsterType* mType = g_monsters().getMonsterType(lastHitCreature->getName());
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

		//Level loss
		uint64_t expLoss = static_cast<uint64_t>(experience * deathLossPercent);
		g_events().eventPlayerOnLoseExperience(this, expLoss);

		sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are dead.");
		std::ostringstream lostExp;
		lostExp << "You lost " << expLoss << " experience.";

		//Skill loss
		for (uint8_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) { //for each skill
			uint64_t sumSkillTries = 0;
			for (uint16_t c = 11; c <= skills[i].level; ++c) { //sum up all required tries for all skill levels
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
				healthMax = std::max<int64_t>(0, healthMax - vocation->getHPGain());
				manaMax = std::max<int64_t>(0, manaMax - vocation->getManaGain());
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

		std::string bless = getBlessingsName();
		std::ostringstream blesses;
		if (bless.length() == 0) {
			blesses << "You weren't protected with any blessings.";
		} else {
			blesses << "You were blessed with " << bless;
		}
		sendTextMessage(MESSAGE_EVENT_ADVANCE, blesses.str());

		//Make player lose bless
		uint8_t maxBlessing = 8;
		if (pvpDeath && hasBlessing(1)) {
			removeBlessing(1, 1); //Remove TOF only
		} else {
			for (int i = 2; i <= maxBlessing; i++) {
				removeBlessing(i, 1);
			}
		}

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
			Condition* condition = *it;
			if (condition->isPersistent()) {
				it = conditions.erase(it);

				condition->endCondition(this);
				onEndCondition(condition->getType());
				delete condition;
			} else {
				++it;
			}
		}
	} else {
		setSkillLoss(true);

		auto it = conditions.begin(), end = conditions.end();
		while (it != end) {
			Condition* condition = *it;
			if (condition->isPersistent()) {
				it = conditions.erase(it);

				condition->endCondition(this);
				onEndCondition(condition->getType());
				delete condition;
			} else {
				++it;
			}
		}

		health = healthMax;
		g_game().internalTeleport(this, getTemplePosition(), true);
		g_game().addCreatureHealth(this);
		g_game().addPlayerMana(this);
		onThink(EVENT_CREATURE_THINK_INTERVAL);
		onIdleStatus();
		sendStats();
	}
	despawn();
}

bool Player::spawn()
{
	setDead(false);

	const Position& pos = getLoginPosition();

	if (!g_game().map.placeCreature(pos, this, false, true)) {
		return false;
	}

	SpectatorHashSet spectators;
	g_game().map.getSpectators(spectators, position, false, true);
	for (Creature* spectator : spectators) {
		if (!spectator) {
			continue;
		}

		if (Player* tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->sendCreatureAppear(this, pos, true);
		}

		spectator->onCreatureAppear(this, false);
	}

	getParent()->postAddNotification(this, nullptr, 0);
	g_game().addCreatureCheck(this);
	g_game().addPlayer(this);
	return true;
}

void Player::despawn()
{
	if (isDead()) {
		return;
	}

	listWalkDir.clear();
	stopEventWalk();
	onWalkAborted();
	g_game().playerSetAttackedCreature(this->getID(), 0);
	g_game().playerFollowCreature(this->getID(), 0);

	// remove check
	Game::removeCreatureCheck(this);

	// remove from map
	Tile* tile = getTile();
	if (!tile) {
		return;
	}

	std::vector<int32_t> oldStackPosVector;

	SpectatorHashSet spectators;
	g_game().map.getSpectators(spectators, tile->getPosition(), true);
	size_t i = 0;
	for (Creature* spectator : spectators) {
		if (!spectator) {
			continue;
		}

		if (const Player* player = spectator->getPlayer()) {
			oldStackPosVector.push_back(player->canSeeCreature(this) ? tile->getStackposOfCreature(player, this) : -1);
		}
		if (Player* player = spectator->getPlayer()) {
			player->sendRemoveTileThing(tile->getPosition(), oldStackPosVector[i++]);
		} 

		spectator->onRemoveCreature(this, false);
		// Remove player from spectator target list
		spectator->setAttackedCreature(nullptr);
		spectator->setFollowCreature(nullptr);
	}

	tile->removeCreature(this);

	getParent()->postRemoveNotification(this, nullptr, 0);

	g_game().removePlayer(this);

	// show player as pending
	for (const auto& [key, player] : g_game().getPlayers()) {
		player->notifyStatusChange(this, VIPSTATUS_PENDING, false);
	}

	setDead(true);
}

bool Player::dropCorpse(Creature* lastHitCreature, Creature* mostDamageCreature, bool lastHitUnjustified, bool mostDamageUnjustified)
{
	if (getZone() != ZONE_PVP || !Player::lastHitIsPlayer(lastHitCreature)) {
		return Creature::dropCorpse(lastHitCreature, mostDamageCreature, lastHitUnjustified, mostDamageUnjustified);
	}

	setDropLoot(true);
	return false;
}

Item* Player::getCorpse(Creature* lastHitCreature, Creature* mostDamageCreature)
{
	Item* corpse = Creature::getCorpse(lastHitCreature, mostDamageCreature);
	if (corpse && corpse->getContainer()) {
		std::ostringstream ss;
		if (lastHitCreature) {
			ss << "You recognize " << getNameDescription() << ". " << (getSex() == PLAYERSEX_FEMALE ? "She" : "He") << " was killed by " << lastHitCreature->getNameDescription() << '.';
		} else {
			ss << "You recognize " << getNameDescription() << '.';
		}

		corpse->setSpecialDescription(ss.str());
	}
	return corpse;
}

void Player::addInFightTicks(bool pzlock /*= false*/)
{
	if (hasFlag(PlayerFlag_NotGainInFight)) {
		return;
	}

	if (pzlock) {
		pzLocked = true;
		sendIcons();
	}

	Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_INFIGHT, g_configManager().getNumber(PZ_LOCKED), 0);
	addCondition(condition);
}

void Player::removeList()
{
	g_game().removePlayer(this);

	for (const auto& [key, player] : g_game().getPlayers()) {
		player->notifyStatusChange(this, VIPSTATUS_OFFLINE);
	}
}

void Player::addList()
{
	for (const auto& [key, player] : g_game().getPlayers()) {
		player->notifyStatusChange(this, this->statusVipList);
	}

	g_game().addPlayer(this);
}

void Player::removePlayer(bool displayEffect, bool forced /*= true*/)
{
	g_creatureEvents().playerLogout(this);
	if (client) {
		client->logout(displayEffect, forced);
	} else {
		g_game().removeCreature(this);
	}
}

void Player::notifyStatusChange(Player* loginPlayer, VipStatus_t status, bool message)
{
	if (!client) {
		return;
	}

	auto it = VIPList.find(loginPlayer->guid);
	if (it == VIPList.end()) {
		return;
	}

	client->sendUpdatedVIPStatus(loginPlayer->guid, status);

	if (message) {
		if (status == VIPSTATUS_ONLINE) {
			client->sendTextMessage(TextMessage(MESSAGE_FAILURE, loginPlayer->getName() + " has logged in."));
		} else if (status == VIPSTATUS_OFFLINE) {
			client->sendTextMessage(TextMessage(MESSAGE_FAILURE, loginPlayer->getName() + " has logged out."));
		}
	}
}

bool Player::removeVIP(uint32_t vipGuid)
{
	if (VIPList.erase(vipGuid) == 0) {
		return false;
	}

	IOLoginData::removeVIPEntry(accountNumber, vipGuid);
	return true;
}

bool Player::addVIP(uint32_t vipGuid, const std::string& vipName, VipStatus_t status)
{
	if (VIPList.size() >= getMaxVIPEntries() || VIPList.size() == 200) { // max number of buddies is 200 in 9.53
		sendTextMessage(MESSAGE_FAILURE, "You cannot add more buddies.");
		return false;
	}

	auto result = VIPList.insert(vipGuid);
	if (!result.second) {
		sendTextMessage(MESSAGE_FAILURE, "This player is already in your list.");
		return false;
	}

	IOLoginData::addVIPEntry(accountNumber, vipGuid, "", 0, false);
	if (client) {
		client->sendVIP(vipGuid, vipName, "", 0, false, status);
	}
	return true;
}

bool Player::addVIPInternal(uint32_t vipGuid)
{
	if (VIPList.size() >= getMaxVIPEntries() || VIPList.size() == 200) { // max number of buddies is 200 in 9.53
		return false;
	}

	return VIPList.insert(vipGuid).second;
}

bool Player::editVIP(uint32_t vipGuid, const std::string& description, uint32_t icon, bool notify)
{
	auto it = VIPList.find(vipGuid);
	if (it == VIPList.end()) {
		return false; // player is not in VIP
	}

	IOLoginData::editVIPEntry(accountNumber, vipGuid, description, icon, notify);
	return true;
}

//close container and its child containers
void Player::autoCloseContainers(const Container* container)
{
	std::vector<uint32_t> closeList;
	for (const auto& it : openContainers) {
		Container* tmpContainer = it.second.container;
		while (tmpContainer) {
			if (tmpContainer->isRemoved() || tmpContainer == container) {
				closeList.push_back(it.first);
				break;
			}

			tmpContainer = dynamic_cast<Container*>(tmpContainer->getParent());
		}
	}

	for (uint32_t containerId : closeList) {
		closeContainer(containerId);
		if (client) {
			client->sendCloseContainer(containerId);
		}
	}
}

bool Player::hasCapacity(const Item* item, uint32_t count) const
{
	if (hasFlag(PlayerFlag_CannotPickupItem)) {
		return false;
	}

	if (hasFlag(PlayerFlag_HasInfiniteCapacity) || item->getTopParent() == this) {
		return true;
	}

	uint32_t itemWeight = item->getContainer() != nullptr ? item->getWeight() : item->getBaseWeight();
	if (item->isStackable()) {
		itemWeight *= count;
	}
	return itemWeight <= getFreeCapacity();
}

ReturnValue Player::queryAdd(int32_t index, const Thing& thing, uint32_t count, uint32_t flags, Creature*) const
{
	const Item* item = thing.getItem();
	if (item == nullptr) {
		SPDLOG_ERROR("[Player::queryAdd] - Item is nullptr");
		return RETURNVALUE_NOTPOSSIBLE;
	}

	bool childIsOwner = hasBitSet(FLAG_CHILDISOWNER, flags);
	if (childIsOwner) {
		//a child container is querying the player, just check if enough capacity
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

	const int32_t& slotPosition = item->getSlotPosition();
	if ((slotPosition & SLOTP_HEAD) || (slotPosition & SLOTP_NECKLACE) ||
			(slotPosition & SLOTP_BACKPACK) || (slotPosition & SLOTP_ARMOR) ||
			(slotPosition & SLOTP_LEGS) || (slotPosition & SLOTP_FEET) ||
			(slotPosition & SLOTP_RING)) {
		ret = RETURNVALUE_CANNOTBEDRESSED;
	} else if (slotPosition & SLOTP_TWO_HAND) {
		ret = RETURNVALUE_PUTTHISOBJECTINBOTHHANDS;
	} else if ((slotPosition & SLOTP_RIGHT) || (slotPosition & SLOTP_LEFT)) {
		ret = RETURNVALUE_CANNOTBEDRESSED;
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
					const Item *leftItem = inventory[CONST_SLOT_LEFT];
					if (leftItem) {
						if ((leftItem->getSlotPosition() | slotPosition) & SLOTP_TWO_HAND) {
							if (item->isQuiver() && leftItem->getWeaponType() == WEAPON_DISTANCE)
								ret = RETURNVALUE_NOERROR;
							else
								ret = RETURNVALUE_BOTHHANDSNEEDTOBEFREE;
						} else {
							ret = RETURNVALUE_NOERROR;
						}
					} else {
						ret = RETURNVALUE_NOERROR;
					}
				}
			} else if (slotPosition & SLOTP_TWO_HAND) {
				if (inventory[CONST_SLOT_LEFT] && inventory[CONST_SLOT_LEFT] != item) {
					ret = RETURNVALUE_BOTHHANDSNEEDTOBEFREE;
				} else {
					ret = RETURNVALUE_NOERROR;
				}
			} else if (inventory[CONST_SLOT_LEFT]) {
				const Item *leftItem = inventory[CONST_SLOT_LEFT];
				WeaponType_t type = item->getWeaponType(), leftType = leftItem->getWeaponType();

				if (leftItem->getSlotPosition() & SLOTP_TWO_HAND)
				{
					ret = RETURNVALUE_DROPTWOHANDEDITEM;
				}
				else if (item == leftItem && count == item->getItemCount())
				{
					ret = RETURNVALUE_NOERROR;
				}
				else if (leftType == WEAPON_SHIELD && type == WEAPON_SHIELD)
				{
					ret = RETURNVALUE_CANONLYUSEONESHIELD;
				}
				else if (leftType == WEAPON_NONE || type == WEAPON_NONE ||
						 leftType == WEAPON_SHIELD || leftType == WEAPON_AMMO || type == WEAPON_SHIELD || type == WEAPON_AMMO)
				{
					ret = RETURNVALUE_NOERROR;
				}
				else
				{
					ret = RETURNVALUE_CANONLYUSEONEWEAPON;
				}
			} else {
				ret = RETURNVALUE_NOERROR;
			}
			break;
		}

		case CONST_SLOT_LEFT: {
			if (slotPosition & SLOTP_LEFT) {
				WeaponType_t type = item->getWeaponType();
				if (type == WEAPON_NONE || type == WEAPON_SHIELD || type == WEAPON_AMMO) {
					ret = RETURNVALUE_CANNOTBEDRESSED;
				} else if (inventory[CONST_SLOT_RIGHT] && (slotPosition & SLOTP_TWO_HAND)) {
					if (type == WEAPON_DISTANCE && inventory[CONST_SLOT_RIGHT]->isQuiver()) {
						ret = RETURNVALUE_NOERROR;
					} else {
						ret = RETURNVALUE_BOTHHANDSNEEDTOBEFREE;
					}
				} else {
					ret = RETURNVALUE_NOERROR;
				}
			} else if (slotPosition & SLOTP_TWO_HAND) {
				if (inventory[CONST_SLOT_RIGHT] && inventory[CONST_SLOT_RIGHT] != item) {
					ret = RETURNVALUE_BOTHHANDSNEEDTOBEFREE;
				} else {
					ret = RETURNVALUE_NOERROR;
				}
			} else if (inventory[CONST_SLOT_RIGHT]) {
				const Item* rightItem = inventory[CONST_SLOT_RIGHT];
				WeaponType_t type = item->getWeaponType(), rightType = rightItem->getWeaponType();

				if (rightItem->getSlotPosition() & SLOTP_TWO_HAND) {
					ret = RETURNVALUE_DROPTWOHANDEDITEM;
				} else if (item == rightItem && count == item->getItemCount()) {
					ret = RETURNVALUE_NOERROR;
				} else if (rightType == WEAPON_SHIELD && type == WEAPON_SHIELD) {
					ret = RETURNVALUE_CANONLYUSEONESHIELD;
				} else if (rightType == WEAPON_NONE || type == WEAPON_NONE ||
							rightType == WEAPON_SHIELD || rightType == WEAPON_AMMO || type == WEAPON_SHIELD || type == WEAPON_AMMO) {
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
			if ((slotPosition & SLOTP_AMMO)) {
				ret = RETURNVALUE_NOERROR;
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
		//need an exchange with source?
		const Item* inventoryItem = getInventoryItem(static_cast<Slots_t>(index));
		if (inventoryItem && (!inventoryItem->isStackable() || inventoryItem->getID() != item->getID())) {
			return RETURNVALUE_NEEDEXCHANGE;
		}

		//check if enough capacity
		if (!hasCapacity(item, count)) {
			return RETURNVALUE_NOTENOUGHCAPACITY;
		}

		if (!g_moveEvents().onPlayerEquip(const_cast<Player&>(*this), const_cast<Item&>(*item), static_cast<Slots_t>(index), true)) {
			return RETURNVALUE_CANNOTBEDRESSED;
		}
	}

	return ret;
}

ReturnValue Player::queryMaxCount(int32_t index, const Thing& thing, uint32_t count, uint32_t& maxQueryCount,
		uint32_t flags) const
{
	const Item* item = thing.getItem();
	if (item == nullptr) {
		maxQueryCount = 0;
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (index == INDEX_WHEREEVER) {
		uint32_t n = 0;
		for (int32_t slotIndex = CONST_SLOT_FIRST; slotIndex <= CONST_SLOT_LAST; ++slotIndex) {
			Item* inventoryItem = inventory[slotIndex];
			if (inventoryItem) {
				if (Container* subContainer = inventoryItem->getContainer()) {
					uint32_t queryCount = 0;
					subContainer->queryMaxCount(INDEX_WHEREEVER, *item, item->getItemCount(), queryCount, flags);
					n += queryCount;

					//iterate through all items, including sub-containers (deep search)
					for (ContainerIterator it = subContainer->iterator(); it.hasNext(); it.advance()) {
						if (Container* tmpContainer = (*it)->getContainer()) {
							queryCount = 0;
							tmpContainer->queryMaxCount(INDEX_WHEREEVER, *item, item->getItemCount(), queryCount, flags);
							n += queryCount;
						}
					}
				} else if (inventoryItem->isStackable() && item->equals(inventoryItem) && inventoryItem->getItemCount() < 100) {
					uint32_t remainder = (100 - inventoryItem->getItemCount());

					if (queryAdd(slotIndex, *item, remainder, flags) == RETURNVALUE_NOERROR) {
						n += remainder;
					}
				}
			} else if (queryAdd(slotIndex, *item, item->getItemCount(), flags) == RETURNVALUE_NOERROR) { //empty slot
				if (item->isStackable()) {
					n += 100;
				} else {
					++n;
				}
			}
		}

		maxQueryCount = n;
	} else {
		const Item* destItem = nullptr;

		const Thing* destThing = getThing(index);
		if (destThing) {
			destItem = destThing->getItem();
		}

		if (destItem) {
			if (destItem->isStackable() && item->equals(destItem) && destItem->getItemCount() < 100) {
				maxQueryCount = 100 - destItem->getItemCount();
			} else {
				maxQueryCount = 0;
			}
		} else if (queryAdd(index, *item, count, flags) == RETURNVALUE_NOERROR) { //empty slot
			if (item->isStackable()) {
				maxQueryCount = 100;
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

ReturnValue Player::queryRemove(const Thing& thing, uint32_t count, uint32_t flags, Creature* /*= nullptr*/) const
{
	int32_t index = getThingIndex(&thing);
	if (index == -1) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	const Item* item = thing.getItem();
	if (item == nullptr) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (count == 0 || (item->isStackable() && count > item->getItemCount())) {
		return RETURNVALUE_NOTPOSSIBLE;
	}

	if (!item->isMoveable() && !hasBitSet(FLAG_IGNORENOTMOVEABLE, flags)) {
		return RETURNVALUE_NOTMOVEABLE;
	}

	return RETURNVALUE_NOERROR;
}

Cylinder* Player::queryDestination(int32_t& index, const Thing& thing, Item** destItem,
		uint32_t& flags)
{
	if (index == 0 /*drop to capacity window*/ || index == INDEX_WHEREEVER) {
		*destItem = nullptr;

		const Item* item = thing.getItem();
		if (item == nullptr) {
			return this;
		}

		bool autoStack = !((flags & FLAG_IGNOREAUTOSTACK) == FLAG_IGNOREAUTOSTACK);
		bool isStackable = item->isStackable();

		std::vector<Container*> containers;

		for (uint32_t slotIndex = CONST_SLOT_FIRST; slotIndex <= CONST_SLOT_AMMO; ++slotIndex) {
			Item* inventoryItem = inventory[slotIndex];
			if (inventoryItem) {
				if (inventoryItem == tradeItem) {
					continue;
				}

				if (inventoryItem == item) {
					continue;
				}

				if (autoStack && isStackable) {
					//try find an already existing item to stack with
					if (queryAdd(slotIndex, *item, item->getItemCount(), 0) == RETURNVALUE_NOERROR) {
						if (inventoryItem->equals(item) && inventoryItem->getItemCount() < 100) {
							index = slotIndex;
							*destItem = inventoryItem;
							return this;
						}
					}

					if (Container* subContainer = inventoryItem->getContainer()) {
						containers.push_back(subContainer);
					}
				} else if (Container* subContainer = inventoryItem->getContainer()) {
					containers.push_back(subContainer);
				}
			} else if (queryAdd(slotIndex, *item, item->getItemCount(), flags) == RETURNVALUE_NOERROR) { //empty slot
				index = slotIndex;
				*destItem = nullptr;
				return this;
			}
		}

		size_t i = 0;
		while (i < containers.size()) {
			Container* tmpContainer = containers[i++];
			if (!autoStack || !isStackable) {
				//we need to find first empty container as fast as we can for non-stackable items
				uint32_t n = tmpContainer->capacity() - tmpContainer->size();
				while (n) {
					if (tmpContainer->queryAdd(tmpContainer->capacity() - n, *item, item->getItemCount(), flags) == RETURNVALUE_NOERROR) {
						index = tmpContainer->capacity() - n;
						*destItem = nullptr;
						return tmpContainer;
					}

					n--;
				}

				for (Item* tmpContainerItem : tmpContainer->getItemList()) {
					if (Container* subContainer = tmpContainerItem->getContainer()) {
						containers.push_back(subContainer);
					}
				}

				continue;
			}

			uint32_t n = 0;

			for (Item* tmpItem : tmpContainer->getItemList()) {
				if (tmpItem == tradeItem) {
					continue;
				}

				if (tmpItem == item) {
					continue;
				}

				//try find an already existing item to stack with
				if (tmpItem->equals(item) && tmpItem->getItemCount() < 100) {
					index = n;
					*destItem = tmpItem;
					return tmpContainer;
				}

				if (Container* subContainer = tmpItem->getContainer()) {
					containers.push_back(subContainer);
				}

				n++;
			}

			if (n < tmpContainer->capacity() && tmpContainer->queryAdd(n, *item, item->getItemCount(), flags) == RETURNVALUE_NOERROR) {
				index = n;
				*destItem = nullptr;
				return tmpContainer;
			}
		}

		return this;
	}

	Thing* destThing = getThing(index);
	if (destThing) {
		*destItem = destThing->getItem();
	}

	Cylinder* subCylinder = dynamic_cast<Cylinder*>(destThing);
	if (subCylinder) {
		index = INDEX_WHEREEVER;
		*destItem = nullptr;
		return subCylinder;
	} else {
		return this;
	}
}

void Player::addThing(int32_t index, Thing* thing)
{
	if (index < CONST_SLOT_FIRST || index > CONST_SLOT_LAST) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	Item* item = thing->getItem();
	if (!item) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	item->setParent(this);
	inventory[index] = item;

	//send to client
	sendInventoryItem(static_cast<Slots_t>(index), item);
}

void Player::updateThing(Thing* thing, uint16_t itemId, uint32_t count)
{
	int32_t index = getThingIndex(thing);
	if (index == -1) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	Item* item = thing->getItem();
	if (!item) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	item->setID(itemId);
	item->setSubType(count);

	//send to client
	sendInventoryItem(static_cast<Slots_t>(index), item);

	//event methods
	onUpdateInventoryItem(item, item);
}

void Player::replaceThing(uint32_t index, Thing* thing)
{
	if (index > CONST_SLOT_LAST) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	Item* oldItem = getInventoryItem(static_cast<Slots_t>(index));
	if (!oldItem) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	Item* item = thing->getItem();
	if (!item) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	//send to client
	sendInventoryItem(static_cast<Slots_t>(index), item);

	//event methods
	onUpdateInventoryItem(oldItem, item);

	item->setParent(this);

	inventory[index] = item;
}

void Player::removeThing(Thing* thing, uint32_t count)
{
	Item* item = thing->getItem();
	if (!item) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	int32_t index = getThingIndex(thing);
	if (index == -1) {
		return /*RETURNVALUE_NOTPOSSIBLE*/;
	}

	if (item->isStackable()) {
		if (count == item->getItemCount()) {
			//send change to client
			sendInventoryItem(static_cast<Slots_t>(index), nullptr);

			//event methods
			onRemoveInventoryItem(item);

			item->setParent(nullptr);
			inventory[index] = nullptr;
		} else {
			uint8_t newCount = static_cast<uint8_t>(std::max<int32_t>(0, item->getItemCount() - count));
			item->setItemCount(newCount);

			//send change to client
			sendInventoryItem(static_cast<Slots_t>(index), item);

			//event methods
			onUpdateInventoryItem(item, item);
		}
	} else {
		//send change to client
		sendInventoryItem(static_cast<Slots_t>(index), nullptr);

		//event methods
		onRemoveInventoryItem(item);

		item->setParent(nullptr);
		inventory[index] = nullptr;
	}
}

int32_t Player::getThingIndex(const Thing* thing) const
{
	for (uint8_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		if (inventory[i] == thing) {
			return i;
		}
	}
	return -1;
}

size_t Player::getFirstIndex() const
{
	return CONST_SLOT_FIRST;
}

size_t Player::getLastIndex() const
{
	return CONST_SLOT_LAST + 1;
}

uint32_t Player::getItemTypeCount(uint16_t itemId, int32_t subType /*= -1*/) const
{
	uint32_t count = 0;
	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; i++) {
		Item* item = inventory[i];
		if (!item) {
			continue;
		}

		if (item->getID() == itemId) {
			count += Item::countByType(item, subType);
		}

		if (Container* container = item->getContainer()) {
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				if ((*it)->getID() == itemId) {
					count += Item::countByType(*it, subType);
				}
			}
		}
	}
	return count;
}

void Player::stashContainer(StashContainerList itemDict)
{
	StashItemList stashItemDict; // ItemID - Count
	for (auto it_dict : itemDict) {
		stashItemDict[(it_dict.first)->getID()] = it_dict.second;
	}

	for (auto it : stashItems) {
		if(!stashItemDict[it.first]) {
			stashItemDict[it.first] = it.second;
		} else {
			stashItemDict[it.first] += it.second;
		}
	}

	if (getStashSize(stashItemDict) > g_configManager().getNumber(STASH_ITEMS)) {
		sendCancelMessage("You don't have capacity in the Supply Stash to stow all this item.");
		return;
	}

	uint32_t totalStowed = 0;
	std::ostringstream retString;
	uint16_t refreshDepotSearchOnItem = 0;
	for (auto stashIterator : itemDict) {
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

bool Player::removeItemOfType(uint16_t itemId, uint32_t amount, int32_t subType, bool ignoreEquipped/* = false*/, bool removeFromStash/* = false*/)
{
	if (amount == 0) {
		return true;
	}

	std::vector<Item*> itemList;

	uint32_t count = 0;
	uint32_t removeFromStashAmount = amount;
	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; i++) {
		Item* item = inventory[i];
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
		} else if (Container* container = item->getContainer()) {
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				Item* containerItem = *it;
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
					// If not, we will remove the amount the player have and save the rest to remove from the stash
					} else if (removeFromStash && stackable) {
						g_game().internalRemoveItems(itemList, amount, stackable);
						// Save remaining items to remove
						removeFromStashAmount -= count;
					}
				}
			}
		}
	}

	if (removeFromStash && removeFromStashAmount <= amount && withdrawItem(itemId, removeFromStashAmount)) {
		return true;
	}

	return false;
}

ItemsTierCountList Player::getInventoryItemsId() const
{
	ItemsTierCountList itemMap;
	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; i++) {
		Item* item = inventory[i];
		if (!item) {
			continue;
		}

		(itemMap[item->getID()])[item->getTier()] += Item::countByType(item, -1);
		if (Container* container = item->getContainer()) {
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				auto containerItem = *it;
				(itemMap[containerItem->getID()])[containerItem->getTier()] += Item::countByType(containerItem, -1);
			}
		}
	}
	return itemMap;
}

std::vector<Item*> Player::getInventoryItemsFromId(uint16_t itemId, bool ignore /*= true*/) const
{
	std::vector<Item*> itemVector;
	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		Item* item = inventory[i];
		if (!item) {
			continue;
		}

		if (!ignore && item->getID() == itemId) {
			itemVector.push_back(item);
		}

		if (Container* container = item->getContainer())
		{
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

std::vector<Item*> Player::getAllInventoryItems(bool ignoreEquiped /*= false*/) const
{
	std::vector<Item*> itemVector;
	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		Item* item = inventory[i];
		if (!item) {
			continue;
		}

		// Only get equiped items if ignored equipped is false
		if (!ignoreEquiped) {
			itemVector.push_back(item);
		}
		if (Container* container = item->getContainer())
		{
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
				itemVector.push_back(*it);
			}
		}
	}

	return itemVector;
}

std::map<uint32_t, uint32_t>& Player::getAllItemTypeCount(std::map<uint32_t, uint32_t>& countMap) const
{
	for (auto item : getAllInventoryItems()) {
		countMap[static_cast<uint32_t>(item->getID())] += Item::countByType(item, -1);
	}
	return countMap;
}

std::map<uint16_t, uint16_t>& Player::getAllSaleItemIdAndCount(std::map<uint16_t, uint16_t> &countMap) const
{
	for (auto item : getAllInventoryItems()) {
		if (item->getTier() > 0) {
			continue;
		}

		if (!item->hasImbuements()) {
			countMap[item->getID()] += item->getItemCount();
		}
	}

	return countMap;
}

void Player::getAllItemTypeCountAndSubtype(std::map<uint32_t, uint32_t>& countMap) const
{
	for (auto item : getAllInventoryItems()) {
		uint16_t itemId = item->getID();
		if (Item::items[itemId].isFluidContainer()) {
			countMap[static_cast<uint32_t>(itemId) | (static_cast<uint32_t>(item->getFluidType()) << 16)] += item->getItemCount();
		} else {
			countMap[static_cast<uint32_t>(itemId)] += item->getItemCount();
		}
	}
}

Item* Player::getForgeItemFromId(uint16_t itemId, uint8_t tier)
{
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

Thing* Player::getThing(size_t index) const
{
	if (index >= CONST_SLOT_FIRST && index <= CONST_SLOT_LAST) {
		return inventory[index];
	}
	return nullptr;
}

void Player::postAddNotification(Thing* thing, const Cylinder* oldParent, int32_t index, CylinderLink_t link /*= LINK_OWNER*/)
{
	if (link == LINK_OWNER) {
		//calling movement scripts
		g_moveEvents().onPlayerEquip(*this, *thing->getItem(), static_cast<Slots_t>(index), false);
	}

	bool requireListUpdate = true;

	if (link == LINK_OWNER || link == LINK_TOPPARENT) {
		const Item* i = (oldParent ? oldParent->getItem() : nullptr);

		// Check if we owned the old container too, so we don't need to do anything,
		// as the list was updated in postRemoveNotification
		assert(i ? i->getContainer() != nullptr : true);

		if (i) {
			requireListUpdate = i->getContainer()->getHoldingPlayer() != this;
		} else {
			requireListUpdate = oldParent != this;
		}

		updateInventoryWeight();
		updateItemsLight();
		sendInventoryIds();
		sendStats();
	}

	if (const Item* item = thing->getItem()) {
		if (const Container* container = item->getContainer()) {
			onSendContainer(container);
		}

		if (shopOwner && !scheduledSaleUpdate && requireListUpdate) {
			updateSaleShopList(item);
		}
	} else if (const Creature* creature = thing->getCreature()) {
		if (creature == this) {
			//check containers
			std::vector<Container*> containers;

			for (const auto& it : openContainers) {
				Container* container = it.second.container;
				if (!Position::areInRange<1, 1, 0>(container->getPosition(), getPosition())) {
					containers.push_back(container);
				}
			}

			for (const Container* container : containers) {
				autoCloseContainers(container);
			}
		}
	}
}

void Player::postRemoveNotification(Thing* thing, const Cylinder* newParent, int32_t index, CylinderLink_t link /*= LINK_OWNER*/)
{
	if (link == LINK_OWNER) {
		//calling movement scripts
		g_moveEvents().onPlayerDeEquip(*this, *thing->getItem(), static_cast<Slots_t>(index));
	}

	bool requireListUpdate = true;

	if (link == LINK_OWNER || link == LINK_TOPPARENT) {
		const Item* i = (newParent ? newParent->getItem() : nullptr);

		// Check if we owned the old container too, so we don't need to do anything,
		// as the list was updated in postRemoveNotification
		assert(i ? i->getContainer() != nullptr : true);

		if (i) {
			requireListUpdate = i->getContainer()->getHoldingPlayer() != this;
		} else {
			requireListUpdate = newParent != this;
		}

		updateInventoryWeight();
		updateItemsLight();
		sendInventoryIds();
		sendStats();
	}

	if (const Item* item = thing->getItem()) {
		if (const Container* container = item->getContainer()) {
			checkLootContainers(container);

			if (container->isRemoved() || !Position::areInRange<1, 1, 0>(getPosition(), container->getPosition())) {
				autoCloseContainers(container);
			} else if (container->getTopParent() == this) {
				onSendContainer(container);
			} else if (const Container* topContainer = dynamic_cast<const Container*>(container->getTopParent())) {
				if (const DepotChest* depotChest = dynamic_cast<const DepotChest*>(topContainer)) {
					bool isOwner = false;

					for (const auto& it : depotChests) {
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

		if (shopOwner && !scheduledSaleUpdate && requireListUpdate) {
			updateSaleShopList(item);
		}
	}
}

// i will keep this function so it can be reviewed
bool Player::updateSaleShopList(const Item* item)
{
	uint16_t itemId = item->getID();
	if (!itemId || !item)
		return true;

	g_dispatcher().addTask(createTask(std::bind(&Game::updatePlayerSaleItems, &g_game(), getID())));
	scheduledSaleUpdate = true;
	return true;
}

bool Player::hasShopItemForSale(uint16_t itemId, uint8_t subType) const
{
	if (!shopOwner) {
		return false;
	}

	const ItemType& itemType = Item::items[itemId];
	std::vector<ShopBlock> shoplist = shopOwner->getShopItemVector();
	return std::any_of(shoplist.begin(), shoplist.end(), [&](const ShopBlock& shopBlock) {
		return shopBlock.itemId == itemId && shopBlock.itemBuyPrice != 0 && (!itemType.isFluidContainer() || shopBlock.itemSubType == subType);
	});
}

void Player::internalAddThing(Thing* thing)
{
	internalAddThing(0, thing);
}

void Player::internalAddThing(uint32_t index, Thing* thing)
{
	Item* item = thing->getItem();
	if (!item) {
		return;
	}

	//index == 0 means we should equip this item at the most appropiate slot (no action required here)
	if (index >= CONST_SLOT_FIRST && index <= CONST_SLOT_LAST) {
		if (inventory[index]) {
			return;
		}

		inventory[index] = item;
		item->setParent(this);
	}
}

bool Player::setFollowCreature(Creature* creature)
{
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

bool Player::setAttackedCreature(Creature* creature)
{
	if (!Creature::setAttackedCreature(creature)) {
		sendCancelTarget();
		return false;
	}

	if (chaseMode && creature) {
		if (followCreature != creature) {
			//chase opponent
			setFollowCreature(creature);
		}
	} else if (followCreature) {
		setFollowCreature(nullptr);
	}

	if (creature) {
		g_dispatcher().addTask(createTask(std::bind(&Game::checkCreatureAttack, &g_game(), getID())));
	}
	return true;
}

void Player::goToFollowCreature()
{
	if (!walkTask) {
		if ((OTSYS_TIME() - lastFailedFollow) < 2000) {
			return;
		}

		Creature::goToFollowCreature();

		if (followCreature && !hasFollowPath) {
			lastFailedFollow = OTSYS_TIME();
		}
	}
}

void Player::getPathSearchParams(const Creature* creature, FindPathParams& fpp) const
{
	Creature::getPathSearchParams(creature, fpp);
	fpp.fullPathSearch = true;
}

void Player::doAttacking(uint32_t)
{
	if (lastAttack == 0) {
		lastAttack = OTSYS_TIME() - getAttackSpeed() - 1;
	}

	if (hasCondition(CONDITION_PACIFIED)) {
		return;
	}

	if ((OTSYS_TIME() - lastAttack) >= getAttackSpeed()) {
		bool result = false;

		Item* tool = getWeapon();
		const Weapon* weapon = g_weapons().getWeapon(tool);
		uint32_t delay = getAttackSpeed();
		bool classicSpeed = g_configManager().getBoolean(CLASSIC_ATTACK_SPEED);

		if (weapon) {
			if (!weapon->interruptSwing()) {
				result = weapon->useWeapon(this, tool, attackedCreature);
			} else if (!classicSpeed && !canDoAction()) {
				delay = getNextActionTime();
			} else {
				result = weapon->useWeapon(this, tool, attackedCreature);
			}
		} else {
			result = Weapon::useFist(this, attackedCreature);
		}

		SchedulerTask* task = createSchedulerTask(std::max<uint32_t>(SCHEDULER_MINTICKS, delay), std::bind(&Game::checkCreatureAttack, &g_game(), getID()));
		if (!classicSpeed) {
			setNextActionTask(task, false);
		} else {
			g_scheduler().addEvent(task);
		}

		if (result) {
			lastAttack = OTSYS_TIME();
		}
	}
}

uint64_t Player::getGainedExperience(Creature* attacker) const
{
	if (g_configManager().getBoolean(EXPERIENCE_FROM_PLAYERS)) {
		Player* attackerPlayer = attacker->getPlayer();
		if (attackerPlayer && attackerPlayer != this && skillLoss && std::abs(static_cast<int32_t>(attackerPlayer->getLevel() - level)) <= g_configManager().getNumber(EXP_FROM_PLAYERS_LEVEL_RANGE)) {
			return std::max<uint64_t>(0, std::floor(getLostExperience() * getDamageRatio(attacker) * 0.75));
		}
	}
	return 0;
}

void Player::onFollowCreature(const Creature* creature)
{
	if (!creature) {
		stopWalk();
	}
}

void Player::setChaseMode(bool mode)
{
	bool prevChaseMode = chaseMode;
	chaseMode = mode;

	if (prevChaseMode != chaseMode) {
		if (chaseMode) {
			if (!followCreature && attackedCreature) {
				//chase opponent
				setFollowCreature(attackedCreature);
			}
		} else if (attackedCreature) {
			setFollowCreature(nullptr);
			cancelNextWalk = true;
		}
	}
}

void Player::onWalkAborted()
{
	setNextWalkActionTask(nullptr);
	sendCancelWalk();
}

void Player::onWalkComplete()
{
	if (walkTask) {
		walkTaskEvent = g_scheduler().addEvent(walkTask);
		walkTask = nullptr;
	}
}

void Player::stopWalk()
{
	cancelNextWalk = true;
}

LightInfo Player::getCreatureLight() const
{
	if (internalLight.level > itemsLight.level) {
		return internalLight;
	}
	return itemsLight;
}

void Player::updateItemsLight(bool internal /*=false*/)
{
	LightInfo maxLight;

	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		Item* item = inventory[i];
		if (item) {
			LightInfo curLight = item->getLightInfo();

			if (curLight.level > maxLight.level) {
				maxLight = std::move(curLight);
			}
		}
	}

	if (itemsLight.level != maxLight.level || itemsLight.color != maxLight.color) {
		itemsLight = maxLight;

		if (!internal) {
			g_game().changeLight(this);
		}
	}
}

void Player::onAddCondition(ConditionType_t type)
{
	Creature::onAddCondition(type);

	if (type == CONDITION_OUTFIT && isMounted()) {
		dismount();
	}

	sendIcons();
}

void Player::onAddCombatCondition(ConditionType_t type)
{
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

		case CONDITION_ROOTED:
			sendTextMessage(MESSAGE_FAILURE, "You are rooted.");
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

void Player::onEndCondition(ConditionType_t type)
{
	Creature::onEndCondition(type);

	if (type == CONDITION_INFIGHT) {
		onIdleStatus();
		pzLocked = false;
		clearAttacked();

		if (getSkull() != SKULL_RED && getSkull() != SKULL_BLACK) {
			setSkull(SKULL_NONE);
		}
	}

	sendIcons();
}

void Player::onCombatRemoveCondition(Condition* condition)
{
	//Creature::onCombatRemoveCondition(condition);
	if (condition->getId() > 0) {
		//Means the condition is from an item, id == slot
		if (g_game().getWorldType() == WORLD_TYPE_PVP_ENFORCED) {
			Item* item = getInventoryItem(static_cast<Slots_t>(condition->getId()));
			if (item) {
				//25% chance to destroy the item
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

void Player::onAttackedCreature(Creature* target)
{
	Creature::onAttackedCreature(target);

	if (target->getZone() == ZONE_PVP) {
		return;
	}

	if (target == this) {
		addInFightTicks();
		return;
	}

	if (hasFlag(PlayerFlag_NotGainInFight)) {
		return;
	}

	Player* targetPlayer = target->getPlayer();
	if (targetPlayer && !isPartner(targetPlayer) && !isGuildMate(targetPlayer)) {
		if (!pzLocked && g_game().getWorldType() == WORLD_TYPE_PVP_ENFORCED) {
			pzLocked = true;
			sendIcons();
		}

		if (getSkull() == SKULL_NONE && getSkullClient(targetPlayer) == SKULL_YELLOW) {
			addAttacked(targetPlayer);
			targetPlayer->sendCreatureSkull(this);
		} else if (!targetPlayer->hasAttacked(this)) {
			if (!pzLocked) {
				pzLocked = true;
				sendIcons();
			}

			if (!Combat::isInPvpZone(this, targetPlayer) && !isInWar(targetPlayer)) {
				addAttacked(targetPlayer);

				if (targetPlayer->getSkull() == SKULL_NONE && getSkull() == SKULL_NONE && !targetPlayer->hasKilled(this)) {
					setSkull(SKULL_WHITE);
				}

				if (getSkull() == SKULL_NONE) {
					targetPlayer->sendCreatureSkull(this);
				}
			}
		}
	}

	addInFightTicks();
}

void Player::onAttacked()
{
	Creature::onAttacked();

	addInFightTicks();
}

void Player::onIdleStatus()
{
	Creature::onIdleStatus();

	if (party) {
		party->clearPlayerPoints(this);
	}
}

void Player::onPlacedCreature()
{
	//scripting event - onLogin
	if (!g_creatureEvents().playerLogin(this)) {
		removePlayer(true);
	}

	sendUnjustifiedPoints();
}

void Player::onAttackedCreatureDrainHealth(Creature* target, int64_t points)
{
	Creature::onAttackedCreatureDrainHealth(target, points);

	if (target) {
		if (party && !Combat::isPlayerCombat(target)) {
			Monster* tmpMonster = target->getMonster();
			if (tmpMonster && tmpMonster->isHostile()) {
				//We have fulfilled a requirement for shared experience
				party->updatePlayerTicks(this, points);
			}
		}
	}
}

void Player::onTargetCreatureGainHealth(Creature* target, int64_t points)
{
	if (target && party) {
		Player* tmpPlayer = nullptr;

		if (isPartner(tmpPlayer) && (tmpPlayer != this)) {
			tmpPlayer = target->getPlayer();
		} else if (Creature* targetMaster = target->getMaster()) {
			if (Player* targetMasterPlayer = targetMaster->getPlayer()) {
				tmpPlayer = targetMasterPlayer;
			}
		}

		if (isPartner(tmpPlayer)) {
			party->updatePlayerTicks(this, points);
		}
	}
}

bool Player::onKilledCreature(Creature* target, bool lastHit/* = true*/)
{
	bool unjustified = false;

	if (hasFlag(PlayerFlag_NotGenerateLoot)) {
		target->setDropLoot(false);
	}

	Creature::onKilledCreature(target, lastHit);

	if (Player* targetPlayer = target->getPlayer()) {
		if (targetPlayer && targetPlayer->getZone() == ZONE_PVP) {
			targetPlayer->setDropLoot(false);
			targetPlayer->setSkillLoss(false);
		} else if (!hasFlag(PlayerFlag_NotGainInFight) && !isPartner(targetPlayer)) {
			if (!Combat::isInPvpZone(this, targetPlayer) && hasAttacked(targetPlayer) && !targetPlayer->hasAttacked(this) && !isGuildMate(targetPlayer) && targetPlayer != this) {
				if (targetPlayer->hasKilled(this)) {
					for (auto& kill : targetPlayer->unjustifiedKills) {
						if (kill.target == getGUID() && kill.unavenged) {
							kill.unavenged = false;
							auto it = attackedSet.find(targetPlayer->guid);
							attackedSet.erase(it);
							break;
						}
					}
				} else if (targetPlayer->getSkull() == SKULL_NONE && !isInWar(targetPlayer)) {
					unjustified = true;
					addUnjustifiedDead(targetPlayer);
				}

				if (lastHit && hasCondition(CONDITION_INFIGHT)) {
					pzLocked = true;
					Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_INFIGHT, g_configManager().getNumber(WHITE_SKULL_TIME), 0);
					addCondition(condition);
				}
			}
		}
	} else if (const Monster* monster = target->getMonster()) {
		// Access to the monster's map damage to check if the player attacked it
		for (auto [playerId, damage] : monster->getDamageMap()) {
			auto damagePlayer = g_game().getPlayerByID(playerId);
			if (!damagePlayer) {
				continue;
			}

			// If the player is not in a party and sharing exp active and enabled
			// And it's not the player killing the creature, then we ignore everything else
			auto damageParty = damagePlayer->getParty();
			if (this->getID() != damagePlayer->getID() &&
				(!damageParty || !damageParty->isSharedExperienceActive() || !damageParty->isSharedExperienceEnabled()))
			{
				continue;
			}

			TaskHuntingSlot* taskSlot = damagePlayer->getTaskHuntingWithCreature(monster->getRaceId());
			if (!taskSlot || monster->isSummon()) {
				continue;
			}

			if (const TaskHuntingOption* option = g_ioprey().GetTaskRewardOption(taskSlot)) {
				taskSlot->currentKills += 1;
				if ((taskSlot->upgrade && taskSlot->currentKills >= option->secondKills) ||
					(!taskSlot->upgrade && taskSlot->currentKills >= option->firstKills)) {
					taskSlot->state = PreyTaskDataState_Completed;
					std::string message = "You succesfully finished your hunting task. Your reward is ready to be claimed!";
					damagePlayer->sendTextMessage(MESSAGE_STATUS, message);
				}
				damagePlayer->reloadTaskSlot(taskSlot->id);
			}
		}
	}

	return unjustified;
}

void Player::gainExperience(uint64_t gainExp, Creature* target)
{
	if (hasFlag(PlayerFlag_NotGainExperience) || gainExp == 0 || staminaMinutes == 0) {
		return;
	}

	addExperience(target, gainExp, true);
}

void Player::onGainExperience(uint64_t gainExp, Creature* target)
{
	if (hasFlag(PlayerFlag_NotGainExperience)) {
		return;
	}

	if (target && !target->getPlayer() && party && party->isSharedExperienceActive() && party->isSharedExperienceEnabled()) {
		party->shareExperience(gainExp, target);
		//We will get a share of the experience through the sharing mechanism
		return;
	}

	Creature::onGainExperience(gainExp, target);
	gainExperience(gainExp, target);
}

void Player::onGainSharedExperience(uint64_t gainExp, Creature* target)
{
	gainExperience(gainExp, target);
}

bool Player::isImmune(CombatType_t type) const
{
	if (hasFlag(PlayerFlag_CannotBeAttacked)) {
		return true;
	}
	return Creature::isImmune(type);
}

bool Player::isImmune(ConditionType_t type) const
{
	if (hasFlag(PlayerFlag_CannotBeAttacked)) {
		return true;
	}
	return Creature::isImmune(type);
}

bool Player::isAttackable() const
{
	return !hasFlag(PlayerFlag_CannotBeAttacked);
}

bool Player::lastHitIsPlayer(Creature* lastHitCreature)
{
	if (!lastHitCreature) {
		return false;
	}

	if (lastHitCreature->getPlayer()) {
		return true;
	}

	Creature* lastHitMaster = lastHitCreature->getMaster();
	return lastHitMaster && lastHitMaster->getPlayer();
}

void Player::changeHealth(int64_t healthChange, bool sendHealthChange/* = true*/)
{
	if (PLAYER_SOUND_HEALTH_CHANGE >= static_cast<uint32_t>(uniform_random(1, 100))) {
		g_game().sendSingleSoundEffect(this->getPosition(), sex == PLAYERSEX_FEMALE ? SOUND_EFFECT_TYPE_HUMAN_FEMALE_BARK : SOUND_EFFECT_TYPE_HUMAN_MALE_BARK, this);
	}

	Creature::changeHealth(healthChange, sendHealthChange);
	sendStats();
}

void Player::changeMana(int64_t manaChange)
{
	if (!hasFlag(PlayerFlag_HasInfiniteMana)) {
		Creature::changeMana(manaChange);
	}
	g_game().addPlayerMana(this);
	sendStats();
}

void Player::changeSoul(int32_t soulChange)
{
	if (soulChange > 0) {
		soul += std::min<int32_t>(soulChange * g_configManager().getFloat(RATE_SOUL_REGEN), vocation->getSoulMax() - soul);
	} else {
		soul = std::max<int32_t>(0, soul + soulChange);
	}

	sendStats();
}

bool Player::canWear(uint16_t lookType, uint8_t addons) const
{
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && lookType != 0 && !g_game().isLookTypeRegistered(lookType)) {
		SPDLOG_WARN("[Player::canWear] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", lookType);
		return false;
	}

	if (group->access) {
		return true;
	}

	const Outfit* outfit = Outfits::getInstance().getOutfitByLookType(sex, lookType);
	if (!outfit) {
		return false;
	}

	if (outfit->premium && !isPremium()) {
		return false;
	}

	if (outfit->unlocked && addons == 0) {
		return true;
	}

	for (const OutfitEntry& outfitEntry : outfits) {
		if (outfitEntry.lookType != lookType) {
			continue;
		}
		return (outfitEntry.addons & addons) == addons;
	}
	return false;
}

bool Player::canLogout()
{
	if (isConnecting) {
		return false;
	}

	if (getTile()->hasFlag(TILESTATE_NOLOGOUT)) {
		return false;
	}

	if (getTile()->hasFlag(TILESTATE_PROTECTIONZONE)) {
		return true;
	}

	return !isPzLocked() && !hasCondition(CONDITION_INFIGHT);
}

void Player::genReservedStorageRange()
{
	// generate outfits range
	uint32_t outfits_key = PSTRG_OUTFITS_RANGE_START;
	for (const OutfitEntry& entry : outfits) {
		storageMap[++outfits_key] = (entry.lookType << 16) | entry.addons;
	}
	// generate familiars range
	uint32_t familiar_key = PSTRG_FAMILIARS_RANGE_START;
	for (const FamiliarEntry& entry : familiars) {
		storageMap[++familiar_key] = (entry.lookType << 16);
	}
}

void Player::addOutfit(uint16_t lookType, uint8_t addons)
{
	for (OutfitEntry& outfitEntry : outfits) {
		if (outfitEntry.lookType == lookType) {
			outfitEntry.addons |= addons;
			return;
		}
	}
	outfits.emplace_back(lookType, addons);
}

bool Player::removeOutfit(uint16_t lookType)
{
	for (auto it = outfits.begin(), end = outfits.end(); it != end; ++it) {
		OutfitEntry& entry = *it;
		if (entry.lookType == lookType) {
			outfits.erase(it);
			return true;
		}
	}
	return false;
}

bool Player::removeOutfitAddon(uint16_t lookType, uint8_t addons)
{
	for (OutfitEntry& outfitEntry : outfits) {
		if (outfitEntry.lookType == lookType) {
			outfitEntry.addons &= ~addons;
			return true;
		}
	}
	return false;
}

bool Player::getOutfitAddons(const Outfit& outfit, uint8_t& addons) const
{
	if (group->access) {
		addons = 3;
		return true;
	}

	if (outfit.premium && !isPremium()) {
		return false;
	}

	for (const OutfitEntry& outfitEntry : outfits) {
		if (outfitEntry.lookType != outfit.lookType) {
			continue;
		}

		addons = outfitEntry.addons;
		return true;
	}

	if (!outfit.unlocked) {
		return false;
	}

	addons = 0;
	return true;
}

bool Player::canFamiliar(uint16_t lookType) const {
	if (group->access) {
		return true;
	}

	const Familiar* familiar = Familiars::getInstance().getFamiliarByLookType(getVocationId(), lookType);
	if (!familiar) {
		return false;
	}

	if (familiar->premium && !isPremium()) {
		return false;
	}

	if (familiar->unlocked) {
		return true;
	}

	for (const FamiliarEntry& familiarEntry : familiars) {
		if (familiarEntry.lookType != lookType) {
			continue;
		}
	}
	return false;
}

void Player::addFamiliar(uint16_t lookType) {
	for (FamiliarEntry& familiarEntry : familiars) {
		if (familiarEntry.lookType == lookType) {
			return;
		}
	}
	familiars.emplace_back(lookType);
}

bool Player::removeFamiliar(uint16_t lookType) {
	for (auto it = familiars.begin(), end = familiars.end(); it != end; ++it) {
		FamiliarEntry& entry = *it;
		if (entry.lookType == lookType) {
			familiars.erase(it);
			return true;
		}
	}
	return false;
}

bool Player::getFamiliar(const Familiar& familiar) const {
	if (group->access) {
		return true;
	}

	if (familiar.premium && !isPremium()) {
		return false;
	}

	for (const FamiliarEntry& familiarEntry : familiars) {
		if (familiarEntry.lookType != familiar.lookType) {
			continue;
		}

		return true;
	}

	if (!familiar.unlocked) {
		return false;
	}

	return true;
}

void Player::setSex(PlayerSex_t newSex)
{
	sex = newSex;
}

Skulls_t Player::getSkull() const
{
	if (hasFlag(PlayerFlag_NotGainInFight)) {
		return SKULL_NONE;
	}
	return skull;
}

Skulls_t Player::getSkullClient(const Creature* creature) const
{
	if (!creature || g_game().getWorldType() != WORLD_TYPE_PVP) {
		return SKULL_NONE;
	}

	const Player* player = creature->getPlayer();
	if (player && player->getSkull() == SKULL_NONE) {
		if (player == this) {
			for (const auto& kill : unjustifiedKills) {
				if (kill.unavenged && (time(nullptr) - kill.time) < g_configManager().getNumber(ORANGE_SKULL_DURATION) * 24 * 60 * 60) {
					return SKULL_ORANGE;
				}
			}
		}

		if (player->hasKilled(this)) {
			return SKULL_ORANGE;
		}

		if (player->hasAttacked(this)) {
			return SKULL_YELLOW;
		}

		if (party && party == player->party) {
			return SKULL_GREEN;
		}
	}
	return Creature::getSkullClient(creature);
}

bool Player::hasKilled(const Player* player) const
{
	for (const auto& kill : unjustifiedKills) {
		if (kill.target == player->getGUID() && (time(nullptr) - kill.time) < g_configManager().getNumber(ORANGE_SKULL_DURATION) * 24 * 60 * 60 && kill.unavenged) {
			return true;
		}
	}

	return false;
}

bool Player::hasAttacked(const Player* attacked) const
{
	if (hasFlag(PlayerFlag_NotGainInFight) || !attacked) {
		return false;
	}

	return attackedSet.find(attacked->guid) != attackedSet.end();
}

void Player::addAttacked(const Player* attacked)
{
	if (hasFlag(PlayerFlag_NotGainInFight) || !attacked || attacked == this) {
		return;
	}

	attackedSet.insert(attacked->guid);
}

void Player::removeAttacked(const Player* attacked)
{
	if (!attacked || attacked == this) {
		return;
	}

	auto it = attackedSet.find(attacked->guid);
	if (it != attackedSet.end()) {
		attackedSet.erase(it);
	}
}

void Player::clearAttacked()
{
	attackedSet.clear();
}

void Player::addUnjustifiedDead(const Player* attacked)
{
	if (hasFlag(PlayerFlag_NotGainInFight) || attacked == this || g_game().getWorldType() == WORLD_TYPE_PVP_ENFORCED) {
		return;
	}

	sendTextMessage(MESSAGE_EVENT_ADVANCE, "Warning! The murder of " + attacked->getName() + " was not justified.");

	unjustifiedKills.emplace_back(attacked->getGUID(), time(nullptr), true);

	uint8_t dayKills = 0;
	uint8_t weekKills = 0;
	uint8_t monthKills = 0;

	for (const auto& kill : unjustifiedKills) {
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
			//start black skull time
			skullTicks = static_cast<int64_t>(g_configManager().getNumber(BLACK_SKULL_DURATION)) * 24 * 60 * 60;
		} else if (dayKills >= g_configManager().getNumber(DAY_KILLS_TO_RED) || weekKills >= g_configManager().getNumber(WEEK_KILLS_TO_RED) || monthKills >= g_configManager().getNumber(MONTH_KILLS_TO_RED)) {
			setSkull(SKULL_RED);
			//reset red skull time
			skullTicks = static_cast<int64_t>(g_configManager().getNumber(RED_SKULL_DURATION)) * 24 * 60 * 60;
		}
	}

	sendUnjustifiedPoints();
}

void Player::checkSkullTicks(int64_t ticks)
{
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

bool Player::isPromoted() const
{
	uint16_t promotedVocation = g_vocations().getPromotedVocation(vocation->getId());
	return promotedVocation == VOCATION_NONE && vocation->getId() != promotedVocation;
}

double Player::getLostPercent() const
{
	int32_t blessingCount = 0;
	uint8_t maxBlessing = (operatingSystem == CLIENTOS_NEW_WINDOWS || operatingSystem == CLIENTOS_NEW_MAC) ? 8 : 6;
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

void Player::learnInstantSpell(const std::string& spellName)
{
	if (!hasLearnedInstantSpell(spellName)) {
		learnedInstantSpellList.push_front(spellName);
	}
}

void Player::forgetInstantSpell(const std::string& spellName)
{
	learnedInstantSpellList.remove(spellName);
}

bool Player::hasLearnedInstantSpell(const std::string& spellName) const
{
	if (hasFlag(PlayerFlag_CannotUseSpells)) {
		return false;
	}

	if (hasFlag(PlayerFlag_IgnoreSpellCheck)) {
		return true;
	}

	for (const auto& learnedSpellName : learnedInstantSpellList) {
		if (strcasecmp(learnedSpellName.c_str(), spellName.c_str()) == 0) {
			return true;
		}
	}
	return false;
}

bool Player::isInWar(const Player* player) const
{
	if (!player || !guild) {
		return false;
	}

	const Guild* playerGuild = player->getGuild();
	if (!playerGuild) {
		return false;
	}

	return isInWarList(playerGuild->getId()) && player->isInWarList(guild->getId());
}

bool Player::isInWarList(uint32_t guildId) const
{
	return std::find(guildWarVector.begin(), guildWarVector.end(), guildId) != guildWarVector.end();
}

bool Player::isPremium() const
{
	if (g_configManager().getBoolean(FREE_PREMIUM) || hasFlag(PlayerFlag_IsAlwaysPremium)) {
		return true;
	}

	return premiumDays > 0;
}

void Player::setPremiumDays(int32_t v)
{
	premiumDays = v;
	sendBasicData();
}

void Player::setTibiaCoins(int32_t v)
{
	coinBalance = v;
}

PartyShields_t Player::getPartyShield(const Player* player) const
{
	if (!player) {
		return SHIELD_NONE;
	}

	if (party) {
		if (party->getLeader() == player) {
			if (party->isSharedExperienceActive()) {
				if (party->isSharedExperienceEnabled()) {
					return SHIELD_YELLOW_SHAREDEXP;
				}

				if (party->canUseSharedExperience(player)) {
					return SHIELD_YELLOW_NOSHAREDEXP;
				}

				return SHIELD_YELLOW_NOSHAREDEXP_BLINK;
			}

			return SHIELD_YELLOW;
		}

		if (player->party == party) {
			if (party->isSharedExperienceActive()) {
				if (party->isSharedExperienceEnabled()) {
					return SHIELD_BLUE_SHAREDEXP;
				}

				if (party->canUseSharedExperience(player)) {
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

	if (player->isInviting(this)) {
		return SHIELD_WHITEYELLOW;
	}

	if (player->party) {
		return SHIELD_GRAY;
	}

	return SHIELD_NONE;
}

bool Player::isInviting(const Player* player) const
{
	if (!player || !party || party->getLeader() != this) {
		return false;
	}
	return party->isPlayerInvited(player);
}

bool Player::isPartner(const Player* player) const
{
	if (!player || !party || player == this) {
		return false;
	}
	return party == player->party;
}

bool Player::isGuildMate(const Player* player) const
{
	if (!player || !guild) {
		return false;
	}
	return guild == player->guild;
}

void Player::sendPlayerPartyIcons(Player* player)
{
	sendPartyCreatureShield(player);
	sendPartyCreatureSkull(player);
}

bool Player::addPartyInvitation(Party* newParty)
{
	auto it = std::find(invitePartyList.begin(), invitePartyList.end(), newParty);
	if (it != invitePartyList.end()) {
		return false;
	}

	invitePartyList.push_front(newParty);
	return true;
}

void Player::removePartyInvitation(Party* remParty)
{
	invitePartyList.remove(remParty);
}

void Player::clearPartyInvitations()
{
	for (Party* invitingParty : invitePartyList) {
		invitingParty->removeInvite(*this, false);
	}
	invitePartyList.clear();
}

GuildEmblems_t Player::getGuildEmblem(const Player* player) const
{
	if (!player) {
		return GUILDEMBLEM_NONE;
	}

	const Guild* playerGuild = player->getGuild();
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

void Player::sendUnjustifiedPoints()
{
	if (client) {
		double dayKills = 0;
		double weekKills = 0;
		double monthKills = 0;

		for (const auto& kill : unjustifiedKills) {
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

		auto dayMax = ((isRed ? 2 : 1) * g_configManager().getNumber(DAY_KILLS_TO_RED));
		auto weekMax = ((isRed ? 2 : 1) * g_configManager().getNumber(WEEK_KILLS_TO_RED));
		auto monthMax = ((isRed ? 2 : 1) * g_configManager().getNumber(MONTH_KILLS_TO_RED));

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

uint8_t Player::getCurrentMount() const
{
	int32_t value;
	if (getStorageValue(PSTRG_MOUNTS_CURRENTMOUNT, value)) {
		return value;
	}
	return 0;
}

void Player::setCurrentMount(uint8_t mount)
{
	addStorageValue(PSTRG_MOUNTS_CURRENTMOUNT, mount);
}

bool Player::toggleMount(bool mount)
{
	if ((OTSYS_TIME() - lastToggleMount) < 3000 && !wasMounted) {
		sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED);
		return false;
	}

	if (mount) {
		if (isMounted()) {
			return false;
		}

		if (!group->access && tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
			sendCancelMessage(RETURNVALUE_ACTIONNOTPERMITTEDINPROTECTIONZONE);
			return false;
		}

		const Outfit* playerOutfit = Outfits::getInstance().getOutfitByLookType(getSex(), defaultOutfit.lookType);
		if (!playerOutfit) {
			return false;
		}

		uint8_t currentMountId = getCurrentMount();
		if (currentMountId == 0) {
			sendOutfitWindow();
			return false;
		}

		const Mount* currentMount = g_game().mounts.getMountByID(currentMountId);
		if (!currentMount) {
			return false;
		}

		if (!hasMount(currentMount)) {
			setCurrentMount(0);
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

		if (currentMount->speed != 0) {
			g_game().changeSpeed(this, currentMount->speed);
		}
	} else {
		if (!isMounted()) {
			return false;
		}

		dismount();
	}

	g_game().internalCreatureChangeOutfit(this, defaultOutfit);
	lastToggleMount = OTSYS_TIME();
	return true;
}

bool Player::tameMount(uint8_t mountId)
{
	if (!g_game().mounts.getMountByID(mountId)) {
		return false;
	}

	const uint8_t tmpMountId = mountId - 1;
	const uint32_t key = PSTRG_MOUNTS_RANGE_START + (tmpMountId / 31);

	int32_t value;
	if (getStorageValue(key, value)) {
		value |= (1 << (tmpMountId % 31));
	} else {
		value = (1 << (tmpMountId % 31));
	}

	addStorageValue(key, value);
	return true;
}

bool Player::untameMount(uint8_t mountId)
{
	if (!g_game().mounts.getMountByID(mountId)) {
		return false;
	}

	const uint8_t tmpMountId = mountId - 1;
	const uint32_t key = PSTRG_MOUNTS_RANGE_START + (tmpMountId / 31);

	int32_t value;
	if (!getStorageValue(key, value)) {
		return true;
	}

	value &= ~(1 << (tmpMountId % 31));
	addStorageValue(key, value);

	if (getCurrentMount() == mountId) {
		if (isMounted()) {
			dismount();
			g_game().internalCreatureChangeOutfit(this, defaultOutfit);
		}

		setCurrentMount(0);
	}

	return true;
}

bool Player::hasMount(const Mount* mount) const
{
	if (isAccessPlayer()) {
		return true;
	}

	if (mount->premium && !isPremium()) {
		return false;
	}

	const uint8_t tmpMountId = mount->id - 1;

	int32_t value;
	if (!getStorageValue(PSTRG_MOUNTS_RANGE_START + (tmpMountId / 31), value)) {
		return false;
	}

	return ((1 << (tmpMountId % 31)) & value) != 0;
}

void Player::dismount()
{
	const Mount* mount = g_game().mounts.getMountByID(getCurrentMount());
	if (mount && mount->speed > 0) {
		g_game().changeSpeed(this, -mount->speed);
	}

	defaultOutfit.lookMount = 0;
}

bool Player::addOfflineTrainingTries(skills_t skill, uint64_t tries)
{
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

		g_events().eventPlayerOnGainSkillTries(this, SKILL_MAGLEVEL, tries);
		uint32_t currMagLevel = magLevel;

		while ((manaSpent + tries) >= nextReqMana) {
			tries -= nextReqMana - manaSpent;

			magLevel++;
			manaSpent = 0;

			g_creatureEvents().playerAdvance(this, SKILL_MAGLEVEL, magLevel - 1, magLevel);

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

		g_events().eventPlayerOnGainSkillTries(this, skill, tries);
		uint32_t currSkillLevel = skills[skill].level;

		while ((skills[skill].tries + tries) >= nextReqTries) {
			tries -= nextReqTries - skills[skill].tries;

			skills[skill].level++;
			skills[skill].tries = 0;
			skills[skill].percent = 0;

			g_creatureEvents().playerAdvance(this, skill, (skills[skill].level - 1), skills[skill].level);

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

	std::ostringstream ss;
	ss << std::fixed << std::setprecision(2) << "Your " << ucwords(getSkillName(skill)) << " skill changed from level " << oldSkillValue << " (with " << oldPercentToNextLevel << "% progress towards level " << (oldSkillValue + 1) << ") to level " << newSkillValue << " (with " << newPercentToNextLevel << "% progress towards level " << (newSkillValue + 1) << ')';
	sendTextMessage(MESSAGE_EVENT_ADVANCE, ss.str());
	return sendUpdate;
}

bool Player::hasModalWindowOpen(uint32_t modalWindowId) const
{
	return find(modalWindows.begin(), modalWindows.end(), modalWindowId) != modalWindows.end();
}

void Player::onModalWindowHandled(uint32_t modalWindowId)
{
	modalWindows.remove(modalWindowId);
}

void Player::sendModalWindow(const ModalWindow& modalWindow)
{
	if (!client) {
		return;
	}

	modalWindows.push_front(modalWindow.id);
	client->sendModalWindow(modalWindow);
}

void Player::clearModalWindows()
{
	modalWindows.clear();
}

uint16_t Player::getHelpers() const
{
	uint16_t helpers;

	if (guild && party) {
		phmap::flat_hash_set<Player*> helperSet;

		const auto& guildMembers = guild->getMembersOnline();
		helperSet.insert(guildMembers.begin(), guildMembers.end());

		const auto& partyMembers = party->getMembers();
		helperSet.insert(partyMembers.begin(), partyMembers.end());

		const auto& partyInvitees = party->getInvitees();
		helperSet.insert(partyInvitees.begin(), partyInvitees.end());

		helperSet.insert(party->getLeader());

		helpers = helperSet.size();
	} else if (guild) {
		helpers = guild->getMembersOnline().size();
	} else if (party) {
		helpers = party->getMemberCount() + party->getInvitationCount() + 1;
	} else {
		helpers = 0;
	}

	return helpers;
}

void Player::sendClosePrivate(uint16_t channelId)
{
	if (channelId == CHANNEL_GUILD || channelId == CHANNEL_PARTY) {
		g_chat().removeUserFromChannel(*this, channelId);
	}

	if (client) {
		client->sendClosePrivate(channelId);
	}
}

uint64_t Player::getMoney() const
{
	std::vector<const Container*> containers;
	uint64_t moneyCount = 0;

	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		Item* item = inventory[i];
		if (!item) {
			continue;
		}

		const Container* container = item->getContainer();
		if (container) {
			containers.push_back(container);
		} else {
			moneyCount += item->getWorth();
		}
	}

	size_t i = 0;
	while (i < containers.size()) {
		const Container* container = containers[i++];
		for (const Item* item : container->getItemList()) {
			const Container* tmpContainer = item->getContainer();
			if (tmpContainer) {
				containers.push_back(tmpContainer);
			} else {
				moneyCount += item->getWorth();
			}
		}
	}
	return moneyCount;
}

std::pair<uint64_t, uint64_t> Player::getForgeSliversAndCores() const
{
	uint64_t sliverCount = 0;
	uint64_t coreCount = 0;

	// Check items from inventory
	for (const auto *item : getAllInventoryItems()) {
		if (!item) {
			continue;
		}

		sliverCount += item->getForgeSlivers();
		coreCount += item->getForgeCores();
	}

	// Check items from stash
	for (StashItemList stashToSend = getStashItems();
		auto [itemId, itemCount] : stashToSend)
	{
		if (itemId == ITEM_FORGE_SLIVER) {
			sliverCount += itemCount;
		}
		if (itemId == ITEM_FORGE_CORE) {
			coreCount += itemCount;
		}
	}

	return std::make_pair(sliverCount, coreCount);
}

size_t Player::getMaxVIPEntries() const
{
	if (group->maxVipEntries != 0) {
		return group->maxVipEntries;
	} else if (isPremium()) {
		return 100;
	}
	return 20;
}

size_t Player::getMaxDepotItems() const
{
	if (group->maxDepotItems != 0) {
		return group->maxDepotItems;
	} else if (isPremium()) {
		return g_configManager().getNumber(PREMIUM_DEPOT_LIMIT);
	}
	return g_configManager().getNumber(FREE_DEPOT_LIMIT);
}

std::forward_list<Condition*> Player::getMuteConditions() const
{
	std::forward_list<Condition*> muteConditions;
	for (Condition* condition : conditions) {
		if (condition->getTicks() <= 0) {
			continue;
		}

		ConditionType_t type = condition->getType();
		if (type != CONDITION_MUTED && type != CONDITION_CHANNELMUTEDTICKS && type != CONDITION_YELLTICKS) {
			continue;
		}

		muteConditions.push_front(condition);
	}
	return muteConditions;
}

void Player::setGuild(Guild* newGuild)
{
	if (newGuild == this->guild) {
		return;
	}

	Guild* oldGuild = this->guild;

	this->guildNick.clear();
	this->guild = nullptr;
	this->guildRank = nullptr;

	if (newGuild) {
		GuildRank_ptr rank = newGuild->getRankByLevel(1);
		if (!rank) {
			return;
		}

		this->guild = newGuild;
		this->guildRank = rank;
		newGuild->addMember(this);
	}

	if (oldGuild) {
		oldGuild->removeMember(this);
	}
}

void Player::updateRegeneration()
{
	if (!vocation) {
		return;
	}

	Condition* condition = getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
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

uint64_t Player::getItemCustomPrice(uint16_t itemId, bool buyPrice/* = false*/) const
{
	auto it = itemPriceMap.find(itemId);
	if (it != itemPriceMap.end()) {
		return it->second;
	}

	std::map<uint16_t, uint64_t> itemMap {{itemId, 1}};
	return g_game().getItemMarketPrice(itemMap, buyPrice);
}

uint16_t Player::getFreeBackpackSlots() const
{
	Thing* thing = getThing(CONST_SLOT_BACKPACK);
	if (!thing) {
		return 0;
	}

	Container* backpack = thing->getContainer();
	if (!backpack) {
		return 0;
	}

	uint16_t counter = std::max<uint16_t>(0, backpack->getFreeSlots());

	return counter;
}

void Player::addItemImbuementStats(const Imbuement* imbuement)
{
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
		g_game().changeSpeed(this, imbuement->speed);
	}

	// Add imbuement capacity
	if (imbuement->capacity != 0) {
		requestUpdate = true;
		bonusCapacity = (capacity * imbuement->capacity)/100;
	}

	if (requestUpdate) {
		sendStats();
		sendSkills();
	}

	return;
}

void Player::removeItemImbuementStats(const Imbuement* imbuement)
{
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
		g_game().changeSpeed(this, -imbuement->speed);
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

	return;
}

bool Player::addItemFromStash(uint16_t itemId, uint32_t itemCount) {
	uint32_t stackCount = 100u;

	while (itemCount > 0) {
		auto addValue = itemCount > stackCount ? stackCount : itemCount;
		itemCount -= addValue;
		Item* newItem = Item::CreateItem(itemId, addValue);

		if (g_game().internalQuickLootItem(this, newItem, OBJECTCATEGORY_STASHRETRIEVE) != RETURNVALUE_NOERROR) {
			g_game().internalPlayerAddItem(this, newItem, true);
		}
	}

	// This check is necessary because we need to block it when we retrieve an item from depot search.
	if (!isDepotSearchOpenOnItem(itemId)) {
		sendOpenStash();
	}

	return true;
}

void sendStowItems(Item &item, Item &stowItem, StashContainerList &itemDict) {
	if (stowItem.getID() == item.getID()) {
		itemDict.push_back(std::pair<Item*, uint32_t>(&stowItem, stowItem.getItemCount()));
	}

	if (auto container = stowItem.getContainer()) {
		for (auto stowable_it : container->getStowableItems()) {
			if ((stowable_it.first)->getID() == item.getID()) {
				itemDict.push_back(stowable_it);
			}
		}
	}
}

void Player::stowItem(Item* item, uint32_t count, bool allItems) {
	if (!item || !item->isItemStorable()) {
		sendCancelMessage("This item cannot be stowed here.");
		return;
	}

	StashContainerList itemDict;
	if (allItems) {
		// Stow player backpack
		if (auto inventoryItem = getInventoryItem(CONST_SLOT_BACKPACK);
			!item->isInsideDepot(true))
		{
			sendStowItems(*item, *inventoryItem, itemDict);
		}

		// Stow locker items
		DepotLocker *depotLocker = getDepotLocker(getLastDepotId());
		auto [itemVector, itemMap] = requestLockerItems(depotLocker);
		for (auto lockerItem : itemVector)
		{
			if (lockerItem == nullptr)
			{
				break;
			}

			if (item->isInsideDepot(true))
			{
				sendStowItems(*item, *lockerItem, itemDict);
			}
		}
	} else if (item->getContainer()) {
		itemDict = item->getContainer()->getStowableItems();
		for (Item* containerItem : item->getContainer()->getItems(true)) {
			uint32_t depotChest = g_configManager().getNumber(DEPOTCHEST);
			bool validDepot = depotChest > 0 && depotChest < 21;
			if (g_configManager().getBoolean(STASH_MOVING) && containerItem && !containerItem->isStackable() && validDepot) {
				g_game().internalMoveItem(containerItem->getParent(), getDepotChest(depotChest, true), INDEX_WHEREEVER, containerItem, containerItem->getItemCount(), nullptr);
				movedItems++;
				moved = true;
			}
		}
	} else {
		itemDict.push_back(std::pair<Item*, uint32_t>(item, count));
	}

	if (itemDict.size() == 0) {
		sendCancelMessage("There is no stowable items on this container.");
		return;
	}

	stashContainer(itemDict);
}

void Player::openPlayerContainers()
{
	std::vector<std::pair<uint8_t, Container*>> openContainersList;

	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; i++) {
		Item* item = inventory[i];
		if (!item) {
			continue;
		}

		Container* itemContainer = item->getContainer();
		if (itemContainer) {
			int64_t cid = item->getIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER);
			if (cid > 0) {
				openContainersList.emplace_back(std::make_pair(cid, itemContainer));
			}
			for (ContainerIterator it = itemContainer->iterator(); it.hasNext(); it.advance()) {
				Container* subContainer = (*it)->getContainer();
				if (subContainer) {
					uint8_t subcid = (*it)->getIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER);
					if (subcid > 0) {
						openContainersList.emplace_back(std::make_pair(subcid, subContainer));
					}
				}
			}
		}
	}

	std::sort(openContainersList.begin(), openContainersList.end(), [](const std::pair<uint8_t, Container*>& left, const std::pair<uint8_t, Container*>& right) {
		return left.first < right.first;
	});

	for (auto& it : openContainersList) {
		addContainer(it.first - 1, it.second);
		onSendContainer(it.second);
	}
}

void Player::initializePrey()
{
	if (preys.empty()) {
		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			auto slot = new PreySlot(static_cast<PreySlot_t>(slotId));
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

			if (!setPreySlotClass(slot)) {
				delete slot;
			}
		}
	}
}

void Player::initializeTaskHunting()
{
	if (taskHunting.empty()) {
		for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
			auto slot = new TaskHuntingSlot(static_cast<PreySlot_t>(slotId));
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

			if (!setTaskHuntingSlotClass(slot)) {
				delete slot;
			}
		}
	}

	if (client && g_configManager().getBoolean(TASK_HUNTING_ENABLED)) {
		client->writeToOutputBuffer(g_ioprey().GetTaskHuntingBaseDate());
	}
}

std::string Player::getBlessingsName() const
{
	uint8_t count = 0;
	std::for_each(blessings.begin(), blessings.end(), [&count](uint8_t amount) {
		if (amount != 0) {
			count++;
		}
	});

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

bool Player::isCreatureUnlockedOnTaskHunting(const MonsterType* mtype) const {
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
	if (getZone() != ZONE_PROTECTION && hasCondition(CONDITION_INFIGHT) && ((OTSYS_TIME() / 1000) % 2) == 0 && chance > 0 && uniform_random(1, 100) <= chance) {
		bool triggered = false;
		auto it = conditions.begin();
		while (it != conditions.end()) {
			auto condItem = *it;
			ConditionType_t type = condItem->getType();
			uint32_t spellId = condItem->getSubId();
			int32_t ticks = condItem->getTicks();
			int32_t newTicks = (ticks <= 2000) ? 0 : ticks - 2000;
			triggered = true;
			if (type == CONDITION_SPELLCOOLDOWN || (type == CONDITION_SPELLGROUPCOOLDOWN && spellId > SPELLGROUP_SUPPORT)) {
				condItem->setTicks(newTicks);
				type == CONDITION_SPELLGROUPCOOLDOWN ? sendSpellGroupCooldown(static_cast<SpellGroup_t>(spellId), newTicks) : sendSpellCooldown(static_cast<uint16_t>(spellId), newTicks);
			}
			++it;
		}
		if (triggered) {
			g_game().addMagicEffect(getPosition(), CONST_ME_HOURGLASS);
			sendTextMessage(MESSAGE_ATTENTION, "Momentum was triggered.");
		}
	}
}

/*******************************************************************************
 * Depot search system
 ******************************************************************************/
void Player::requestDepotItems()
{
	ItemsTierCountList itemMap;
	uint16_t count = 0;
	const DepotLocker* depotLocker = getDepotLocker(getLastDepotId());
	if (!depotLocker) {
		return;
	}

	for (Item* locker : depotLocker->getItemList()) {
		const Container* c = locker->getContainer();
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

	for (const auto& [itemId, itemCount] : getStashItems()) {
		auto itemMap_it = itemMap.find(itemId);
		// Stackable items not have upgrade classification
		if (Item::items[itemId].upgradeClassification > 0) {
			SPDLOG_ERROR("{} - Player {} have wrong item with id {} on stash with upgrade classification", __FUNCTION__, getName(), itemId);
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

void Player::requestDepotSearchItem(uint16_t itemId, uint8_t tier)
{
	ItemVector depotItems;
	ItemVector inboxItems;
	uint32_t depotCount = 0;
	uint32_t inboxCount = 0;
	uint32_t stashCount = 0;

	if (const ItemType& iType = Item::items[itemId];
			iType.stackable && iType.wareId > 0) {
		stashCount = getStashItemCount(itemId);
	}

	const DepotLocker* depotLocker = getDepotLocker(getLastDepotId());
	if (!depotLocker) {
		return;
	}

	for (Item* locker : depotLocker->getItemList()) {
		const Container* c = locker->getContainer();
		if (!c || c->empty()) {
			continue;
		}

		for (ContainerIterator it = c->iterator(); it.hasNext(); it.advance()) {
			Item* item = *it;
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

void Player::retrieveAllItemsFromDepotSearch(uint16_t itemId, uint8_t tier, bool isDepot)
{
	const DepotLocker* depotLocker = getDepotLocker(getLastDepotId());
	if (!depotLocker) {
		return;
	}

	std::vector<Item*> itemsVector;
	for (Item* locker : depotLocker->getItemList()) {
		const Container* c = locker->getContainer();
		if (!c || c->empty() ||
			// Retrieve from inbox.
			(c->isInbox() && isDepot) ||
			// Retrieve from depot.
			(!c->isInbox() && !isDepot)
		)
		{
			continue;
		}

		for (ContainerIterator it = c->iterator(); it.hasNext(); it.advance()) {
			Item* item = *it;
			if (!item) {
				continue;
			}

			if (item->getID() == itemId && item->getTier() == depotSearchOnItem.second) {
				itemsVector.push_back(item);
			}
		}
	}

	ReturnValue ret = RETURNVALUE_NOERROR;
	for (Item* item : itemsVector) {
		// First lets try to retrieve the item to the stash retrieve container.
		if (ret = g_game().internalQuickLootItem(this, item, OBJECTCATEGORY_STASHRETRIEVE); ret == RETURNVALUE_NOERROR) {
			continue;
		}

		// If the retrieve fails to move the item to the stash retrieve container, let's add the item anywhere.
		if (ret = g_game().internalMoveItem(item->getParent(), this, INDEX_WHEREEVER, item, item->getItemCount(), nullptr); ret == RETURNVALUE_NOERROR) {
			continue;
		}

		sendCancelMessage(ret);
		return;
	}

	requestDepotSearchItem(itemId, tier);
}

void Player::openContainerFromDepotSearch(const Position& pos)
{
	if (!isDepotSearchOpen()) {
		sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	const Item* item = getItemFromDepotSearch(depotSearchOnItem.first, pos);
	if (!item) {
		sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	Container* container = item->getParent() ? item->getParent()->getContainer() : nullptr;
	if (!container) {
		sendCancelMessage(RETURNVALUE_NOTPOSSIBLE);
		return;
	}

	g_actions().useItem(this, pos, 0, container, false);
}

Item* Player::getItemFromDepotSearch(uint16_t itemId, const Position& pos)
{
	const DepotLocker* depotLocker = getDepotLocker(getLastDepotId());
	if (!depotLocker) {
		return nullptr;
	}

	uint8_t index = 0;
	for (Item* locker : depotLocker->getItemList()) {
		const Container* c = locker->getContainer();
		if (!c || c->empty() ||
			(c->isInbox() && pos.y != 0x21) ||	// From inbox.
			(!c->isInbox() && pos.y != 0x20)) {	// From depot.
			continue;
		}

		for (ContainerIterator it = c->iterator(); it.hasNext(); it.advance()) {
			Item* item = *it;
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

SoundEffect_t Player::getHitSoundEffect()
{
	// Distance sound effects
	if (Item* tool = getWeapon()) {
    	const ItemType& it = Item::items[tool->getID()];
		if (it.weaponType == WEAPON_AMMO) {
			if (it.ammoType == AMMO_BOLT) {
				return SOUND_EFFECT_TYPE_DIST_ATK_CROSSBOW_SHOT;
			} else if (it.ammoType == AMMO_ARROW) {
				if (it.shootType == CONST_ANI_BURSTARROW) {
					return SOUND_EFFECT_TYPE_BURST_ARROW_EFFECT;
				} else if (it.shootType == CONST_ANI_DIAMONDARROW) {
					return SOUND_EFFECT_TYPE_DIAMOND_ARROW_EFFECT;
				}
			} else {
				return SOUND_EFFECT_TYPE_DIST_ATK_THROW_SHOT;
			}
		} else if (it.weaponType == WEAPON_DISTANCE) {
			if (tool->getAmmoType() == AMMO_BOLT) {
				return SOUND_EFFECT_TYPE_DIST_ATK_CROSSBOW_SHOT;
			} else if (tool->getAmmoType() == AMMO_ARROW) {
				return SOUND_EFFECT_TYPE_DIST_ATK_BOW_SHOT;
			} else {
				return SOUND_EFFECT_TYPE_DIST_ATK_THROW_SHOT;
			}
		} else if (it.weaponType == WEAPON_WAND) {
			// Separate between wand and rod here
			//return SOUND_EFFECT_TYPE_DIST_ATK_ROD_SHOT;
			return SOUND_EFFECT_TYPE_DIST_ATK_WAND_SHOT;
		}
	}

	return SOUND_EFFECT_TYPE_SILENCE;
}

SoundEffect_t Player::getAttackSoundEffect()
{
	Item* tool = getWeapon();
	if (!tool) {
		return SOUND_EFFECT_TYPE_HUMAN_CLOSE_ATK_FIST;
	}

    const ItemType& it = Item::items[tool->getID()];
	if (it.weaponType == WEAPON_NONE || it.weaponType == WEAPON_SHIELD) {
		return SOUND_EFFECT_TYPE_HUMAN_CLOSE_ATK_FIST;
	}

	switch (it.weaponType) {
		case WEAPON_AXE: {
			return SOUND_EFFECT_TYPE_MELEE_ATK_AXE;
		}
		case WEAPON_SWORD: {
			return SOUND_EFFECT_TYPE_MELEE_ATK_SWORD;
		}
		case WEAPON_CLUB: {
			return SOUND_EFFECT_TYPE_MELEE_ATK_CLUB;
		}
		case WEAPON_AMMO:
		case WEAPON_DISTANCE: {
			if (tool->getAmmoType() == AMMO_BOLT) {
				return SOUND_EFFECT_TYPE_DIST_ATK_CROSSBOW;
			} else if (tool->getAmmoType() == AMMO_ARROW) {
				return SOUND_EFFECT_TYPE_DIST_ATK_BOW;
			} else {
				return SOUND_EFFECT_TYPE_DIST_ATK_THROW;
			}
			
			break;
		}
		case WEAPON_WAND: {
			return SOUND_EFFECT_TYPE_MAGICAL_RANGE_ATK;
		}
		default: {
			return SOUND_EFFECT_TYPE_SILENCE;
		}
	}

	return SOUND_EFFECT_TYPE_SILENCE;
}

std::pair<std::vector<Item*>, std::map<uint16_t, std::map<uint8_t, uint32_t>>> Player::requestLockerItems(
	DepotLocker *depotLocker,
	bool sendToClient/* = false*/,
	uint8_t tier/* = 0*/
) const
{
	if (depotLocker == nullptr) {
		SPDLOG_ERROR("{} - Depot locker is nullptr", __FUNCTION__);
		return {};
	}

	std::map<uint16_t, std::map<uint8_t, uint32_t>> lockerItems;
	std::vector<Item*> itemVector;
	std::vector<Container*> containers {depotLocker};

	size_t size = 0;
	do {
		const Container* container = containers[size];
		size++;

		for (Item* item : container->getItemList()) {
			Container* lockerContainers = item->getContainer();
			if (lockerContainers && !lockerContainers->empty()) {
				containers.push_back(lockerContainers);
				continue;
			}

			const ItemType& itemType = Item::items[item->getID()];
			if (itemType.wareId == 0) {
				continue;
			}

			if (lockerContainers && (!itemType.isContainer() || lockerContainers->capacity() != itemType.maxItems)) {
				continue;
			}

			if (!item->hasMarketAttributes()) {
				continue;
			}

			if (!sendToClient && item->getTier() != tier) {
				continue;
			}

			(lockerItems[itemType.wareId])[item->getTier()] += Item::countByType(item, -1);
			itemVector.push_back(item);
		}
	} while (size < containers.size());
	StashItemList stashToSend = getStashItems();
	uint32_t countSize = 0;
	for (auto [itemId, itemCount] : stashToSend)
	{
		countSize += itemCount;
	}

	do
	{
		for (auto [itemId, itemCount] : stashToSend)
		{
			const ItemType &itemType = Item::items[itemId];
			if (itemType.wareId == 0)
			{
				continue;
			}

			countSize = countSize - itemCount;
			(lockerItems[itemType.wareId])[0] += itemCount;
		}
	} while (countSize > 0);

	return std::make_pair(itemVector, lockerItems);
}

bool Player::saySpell(
	SpeakClasses type,
	const std::string& text,
	bool ghostMode,
	SpectatorHashSet* spectatorsPtr/* = nullptr*/,
	const Position* pos/* = nullptr*/)
{
	if (text.empty()) {
		SPDLOG_DEBUG("{} - Spell text is empty for player {}", __FUNCTION__, getName());
		return false;
	}

	if (!pos) {
		pos = &getPosition();
	}

	SpectatorHashSet spectators;

	if (!spectatorsPtr || spectatorsPtr->empty()) {
		// This somewhat complex construct ensures that the cached SpectatorHashSet
		// is used if available and if it can be used, else a local vector is
		// used (hopefully the compiler will optimize away the construction of
		// the temporary when it's not used).
		if (type != TALKTYPE_YELL && type != TALKTYPE_MONSTER_YELL) {
			g_game().map.getSpectators(spectators, *pos, false, false,
                           Map::maxClientViewportX, Map::maxClientViewportX,
                           Map::maxClientViewportY, Map::maxClientViewportY);
		} else {
			g_game().map.getSpectators(spectators, *pos, true, false,
                          (Map::maxClientViewportX + 1) * 2, (Map::maxClientViewportX + 1) * 2,
				          (Map::maxClientViewportY + 1) * 2, (Map::maxClientViewportY + 1) * 2);
		}
	} else {
		spectators = (*spectatorsPtr);
	}

	int32_t valueEmote = 0;
	// Send to client 
	for (Creature* spectator : spectators) {
		if (Player* tmpPlayer = spectator->getPlayer()) {
			tmpPlayer->getStorageValue(STORAGEVALUE_EMOTE, valueEmote);
			if (!ghostMode || tmpPlayer->canSeeCreature(this)) {
				if (valueEmote == 1) {
					tmpPlayer->sendCreatureSay(this, TALKTYPE_MONSTER_SAY, text, pos);
				} else {
					tmpPlayer->sendCreatureSay(this, TALKTYPE_SPELL_USE, text, pos);
				}
			}
		}
	}

	// Execute lua event method
	for (Creature* spectator : spectators) {
		auto tmpPlayer = spectator->getPlayer();
		if (!tmpPlayer) {
			continue;
		}

		tmpPlayer->onCreatureSay(this, type, text);
		if (this != tmpPlayer) {
			g_events().eventCreatureOnHear(tmpPlayer, this, text, type);
		}
	}
	return true;
}

// Forge system
void Player::forgeFuseItems(uint16_t itemId, uint8_t tier, bool success, bool reduceTierLoss, uint8_t bonus, uint8_t coreCount)
{
	ForgeHistory history;
	history.actionType = ForgeConversion_t::FORGE_ACTION_FUSION;
	history.tier = tier;
	history.success = success;
	history.tierLoss = reduceTierLoss;

	auto firstForgingItem = getForgeItemFromId(itemId, tier);
	if (!firstForgingItem) {
		SPDLOG_ERROR("[Log 1] Player with name {} failed to fuse item with id {}", getName(), itemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	auto returnValue = g_game().internalRemoveItem(firstForgingItem, 1);
	if (returnValue != RETURNVALUE_NOERROR)
	{
		SPDLOG_ERROR("[Log 1] Failed to remove forge item {} from player with name {}", itemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	auto secondForgingItem = getForgeItemFromId(itemId, tier);
	if (!secondForgingItem) {
		SPDLOG_ERROR("[Log 2] Player with name {} failed to fuse item with id {}", getName(), itemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	if (returnValue = g_game().internalRemoveItem(secondForgingItem, 1);
		returnValue != RETURNVALUE_NOERROR)
	{
		SPDLOG_ERROR("[Log 2] Failed to remove forge item {} from player with name {}", itemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	auto exaltationChest = Item::CreateItem(ITEM_EXALTATION_CHEST, 1);
	if (!exaltationChest) {
		SPDLOG_ERROR("Failed to create exaltation chest");
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	auto exaltationContainer = exaltationChest->getContainer();
	if (!exaltationContainer) {
		SPDLOG_ERROR("Failed to create exaltation container");
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	Item* firstForgedItem = Item::CreateItem(itemId, 1);
	if (!firstForgedItem) {
		SPDLOG_ERROR("[Log 3] Player with name {} failed to fuse item with id {}", getName(), itemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	firstForgedItem->setTier(tier);
	returnValue = g_game().internalAddItem(exaltationContainer, firstForgedItem, INDEX_WHEREEVER);
	if (returnValue != RETURNVALUE_NOERROR) {
		SPDLOG_ERROR("[Log 1] Failed to add forge item {} from player with name {}", itemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	Item* secondForgedItem = Item::CreateItem(itemId, 1);
	if (!secondForgedItem) {
		SPDLOG_ERROR("[Log 4] Player with name {} failed to fuse item with id {}", getName(), itemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	secondForgedItem->setTier(tier);
	returnValue = g_game().internalAddItem(exaltationContainer, secondForgedItem, INDEX_WHEREEVER);
	if (returnValue != RETURNVALUE_NOERROR) {
		SPDLOG_ERROR("[Log 2] Failed to add forge item {} from player with name {}", itemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	auto dustCost = static_cast<uint64_t>(g_configManager().getNumber(FORGE_FUSION_DUST_COST));
	if (success)
	{
		firstForgedItem->setTier(tier + 1);

		if (bonus != 1)
		{
			history.dustCost = dustCost;
			setForgeDusts(getForgeDusts() - dustCost);
		}
		if (bonus != 2)
		{
			if (!removeItemOfType(ITEM_FORGE_CORE, coreCount, -1, true, true)) {
				SPDLOG_ERROR("[{}][Log 1] Failed to remove item 'id :{} count: {}' from player {}", __FUNCTION__, ITEM_FORGE_CORE, coreCount, getName());
				sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
				return;
			}
			history.coresCost = coreCount;
		}
		if (bonus != 3)
		{
			uint64_t cost = 0;
			for (const auto *itemClassification : g_game().getItemsClassifications())
			{
				if (itemClassification->id != firstForgingItem->getClassification())
				{
					continue;
				}

				for (const auto &[mapTier, mapPrice] : itemClassification->tiers)
				{
					if (mapTier == firstForgingItem->getTier())
					{
						cost = mapPrice;
						break;
					}
				}
				break;
			}
			if (!g_game().removeMoney(this, cost, 0, true)) {
				SPDLOG_ERROR("[{}] Failed to remove {} gold from player with name {}", __FUNCTION__, cost, getName());
				sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
				return;
			}
			history.cost = cost;
		}

		if (bonus == 4)
		{
			if (tier > 0)
			{
				secondForgedItem->setTier(tier - 1);
			}
		}
		else if (bonus == 6)
		{
			secondForgedItem->setTier(tier + 1);
		}
		else if (bonus == 7 && tier + 2 <= firstForgedItem->getClassification())
		{
			firstForgedItem->setTier(tier + 2);
		}

		if (bonus != 4 && bonus != 5 && bonus != 6 && bonus != 8)
		{
			returnValue = g_game().internalRemoveItem(secondForgedItem, 1);
			if (returnValue != RETURNVALUE_NOERROR) {
				SPDLOG_ERROR("[Log 6] Failed to remove forge item {} from player with name {}", itemId, getName());
				sendCancelMessage(getReturnMessage(returnValue));
				sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
				return;
			}
		}
	} else {
		auto isTierLost = uniform_random(1, 100) <= (reduceTierLoss ? g_configManager().getNumber(FORGE_TIER_LOSS_REDUCTION) : 100);
		if (isTierLost)
		{
			if (secondForgedItem->getTier() >= 1)
			{
				secondForgedItem->setTier(tier - 1);
			}
			else
			{
				returnValue = g_game().internalRemoveItem(secondForgedItem, 1);
				if (returnValue != RETURNVALUE_NOERROR) {
					SPDLOG_ERROR("[Log 7] Failed to remove forge item {} from player with name {}", itemId, getName());
					sendCancelMessage(getReturnMessage(returnValue));
					sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
					return;
				}
			}
		}
		bonus = (isTierLost ? 0 : 8);
		history.coresCost = coreCount;

		if (getForgeDusts() < dustCost) {
			SPDLOG_ERROR("[Log 7] Failed to remove fuse dusts from player with name {}", getName());
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		} else {
			setForgeDusts(getForgeDusts() - dustCost);
		}

		if (!removeItemOfType(ITEM_FORGE_CORE, coreCount, -1, true, true)) {
			SPDLOG_ERROR("[{}][Log 2] Failed to remove item 'id: {}, count: {}' from player {}", __FUNCTION__, ITEM_FORGE_CORE, coreCount, getName());
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		uint64_t cost = 0;
		for (const auto *itemClassification : g_game().getItemsClassifications())
		{
			if (itemClassification->id != firstForgingItem->getClassification())
			{
				continue;
			}

			for (const auto &[mapTier, mapPrice] : itemClassification->tiers)
			{
				if (mapTier == firstForgingItem->getTier())
				{
					cost = mapPrice;
					break;
				}
			}
			break;
		}
		if (!g_game().removeMoney(this, cost, 0, true)) {
			SPDLOG_ERROR("[{}] Failed to remove {} gold from player with name {}", __FUNCTION__, cost, getName());
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		history.cost = cost;
	}
	returnValue = g_game().internalAddItem(this, exaltationContainer, INDEX_WHEREEVER);
	if (returnValue != RETURNVALUE_NOERROR) {
		SPDLOG_ERROR("Failed to add exaltation chest to player with name {}", ITEM_EXALTATION_CHEST, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	history.firstItemName = firstForgingItem->getName();
	history.bonus = bonus;
	history.createdAt = getTimeNow();
	registerForgeHistoryDescription(history);

	sendForgeFusionItem(itemId, tier, success, bonus, coreCount);
}

void Player::forgeTransferItemTier(uint16_t donorItemId, uint8_t tier, uint16_t receiveItemId)
{
	ForgeHistory history;
	history.actionType = ForgeConversion_t::FORGE_ACTION_TRANSFER;
	history.tier = tier;
	history.success = true;

	auto donorItem = getForgeItemFromId(donorItemId, tier);
	if (!donorItem) {
		SPDLOG_ERROR("[Log 1] Player with name {} failed to transfer item with id {}", getName(), donorItemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	auto returnValue = g_game().internalRemoveItem(donorItem, 1);
	if (returnValue != RETURNVALUE_NOERROR)
	{
		SPDLOG_ERROR("[Log 1] Failed to remove transfer item {} from player with name {}", donorItemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	auto receiveItem = getForgeItemFromId(receiveItemId, 0);
	if (!receiveItem) {
		SPDLOG_ERROR("[Log 2] Player with name {} failed to transfer item with id {}", getName(), receiveItemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	if (returnValue = g_game().internalRemoveItem(receiveItem, 1);
		returnValue != RETURNVALUE_NOERROR)
	{
		SPDLOG_ERROR("[Log 2] Failed to remove transfer item {} from player with name {}", receiveItemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	auto exaltationChest = Item::CreateItem(ITEM_EXALTATION_CHEST, 1);
	if (!exaltationChest) {
		SPDLOG_ERROR("Exaltation chest is nullptr");
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	auto exaltationContainer = exaltationChest->getContainer();
	if (!exaltationContainer) {
		SPDLOG_ERROR("Exaltation container is nullptr");
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	Item* newDonorItem = Item::CreateItem(donorItemId, 1);
	if (!newDonorItem) {
		SPDLOG_ERROR("[Log 4] Player with name {} failed to transfer item with id {}", getName(), donorItemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	returnValue = g_game().internalAddItem(exaltationContainer, newDonorItem, INDEX_WHEREEVER);
	if (returnValue != RETURNVALUE_NOERROR) {
		SPDLOG_ERROR("[Log 5] Failed to add forge item {} from player with name {}", donorItemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	Item* newReceiveItem = Item::CreateItem(receiveItemId, 1);
	if (!newReceiveItem) {
		SPDLOG_ERROR("[Log 6] Player with name {} failed to fuse item with id {}", getName(), receiveItemId);
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	newReceiveItem->setTier(tier - 1);
	returnValue = g_game().internalAddItem(exaltationContainer, newReceiveItem, INDEX_WHEREEVER);
	if (returnValue != RETURNVALUE_NOERROR) {
		SPDLOG_ERROR("[Log 7] Failed to add forge item {} from player with name {}", receiveItemId, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	if (getForgeDusts() < g_configManager().getNumber(FORGE_TRANSFER_DUST_COST)) {
		SPDLOG_ERROR("[Log 8] Failed to remove transfer dusts from player with name {}", getName());
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	} else {
		setForgeDusts(getForgeDusts() - g_configManager().getNumber(FORGE_TRANSFER_DUST_COST));
	}

	if (!removeItemOfType(ITEM_FORGE_CORE, 1, -1, true, true)) {
		SPDLOG_ERROR("[{}] Failed to remove item 'id: {}, count: {}' from player {}", __FUNCTION__, ITEM_FORGE_CORE, 1, getName());
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	uint64_t cost = 0;
	for (const auto &itemClassification : g_game().getItemsClassifications())
	{
		if (itemClassification->id != donorItem->getClassification())
		{
			continue;
		}

		for (const auto &[mapTier, mapPrice] : itemClassification->tiers)
		{
			if (mapTier == donorItem->getTier() - 1)
			{
				cost = mapPrice;
				break;
			}
		}
	}

	if (!g_game().removeMoney(this, cost, 0, true)) {
		SPDLOG_ERROR("[{}] Failed to remove {} gold from player with name {}", __FUNCTION__, cost, getName());
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}
	history.cost = cost;

	returnValue = g_game().internalAddItem(this, exaltationContainer, INDEX_WHEREEVER);
	if (returnValue != RETURNVALUE_NOERROR) {
		SPDLOG_ERROR("[Log 10] Failed to add forge item {} from player with name {}", ITEM_EXALTATION_CHEST, getName());
		sendCancelMessage(getReturnMessage(returnValue));
		sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
		return;
	}

	history.firstItemName = newDonorItem->getName();
	history.secondItemName = newReceiveItem->getName();
	history.createdAt = getTimeNow();
	registerForgeHistoryDescription(history);

	sendTransferItemTier(donorItemId, tier, receiveItemId);
}

void Player::forgeResourceConversion(uint8_t action)
{
	auto actionEnum = magic_enum::enum_value<ForgeConversion_t>(action);
	ForgeHistory history;
	history.actionType = actionEnum;
	history.success = true;

	ReturnValue returnValue = RETURNVALUE_NOERROR;
	if (actionEnum == ForgeConversion_t::FORGE_ACTION_DUSTTOSLIVERS) {
		auto dusts = getForgeDusts();
		auto cost = static_cast<uint16_t>(g_configManager().getNumber(FORGE_COST_ONE_SLIVER) * g_configManager().getNumber(FORGE_SLIVER_AMOUNT));
		if (cost > dusts) {
			SPDLOG_ERROR("[{}] Not enough dust", __FUNCTION__);
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		auto itemCount = static_cast<uint16_t>(g_configManager().getNumber(FORGE_SLIVER_AMOUNT));
		Item* item = Item::CreateItem(ITEM_FORGE_SLIVER, itemCount);
		returnValue = g_game().internalPlayerAddItem(this, item);
		if (returnValue != RETURNVALUE_NOERROR)
		{
			SPDLOG_ERROR("Failed to add {} slivers to player with name {}", itemCount, getName());
			sendCancelMessage(getReturnMessage(returnValue));
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}
		history.cost = cost;
		history.gained = 3;
		setForgeDusts(dusts - cost);
	} else if (actionEnum == ForgeConversion_t::FORGE_ACTION_SLIVERSTOCORES) {
		auto [sliverCount, coreCount] = getForgeSliversAndCores();
		auto cost = static_cast<uint16_t>(g_configManager().getNumber(FORGE_CORE_COST));
		if (cost > sliverCount) {
			SPDLOG_ERROR("[{}] Not enough sliver", __FUNCTION__);
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		if (!removeItemOfType(ITEM_FORGE_SLIVER, cost, -1, true, true)) {
			SPDLOG_ERROR("[{}] Failed to remove item 'id: {}, count {}' from player {}", __FUNCTION__, ITEM_FORGE_SLIVER, cost, getName());
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		if (Item* item = Item::CreateItem(ITEM_FORGE_CORE, 1);
			item) {
			returnValue = g_game().internalPlayerAddItem(this, item);
		}
		if (returnValue != RETURNVALUE_NOERROR)
		{
			SPDLOG_ERROR("Failed to add one core to player with name {}", getName());
			sendCancelMessage(getReturnMessage(returnValue));
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		history.cost = cost;
		history.gained = 1;
	} else {
		auto dustLevel = getForgeDustLevel();
		if (dustLevel >= g_configManager().getNumber(FORGE_MAX_DUST))
		{
			SPDLOG_ERROR("[{}] Maximum level reached", __FUNCTION__);
			sendForgeError(RETURNVALUE_CONTACTADMINISTRATOR);
			return;
		}

		auto upgradeCost = dustLevel - 75;
		if (auto dusts = getForgeDusts();
			upgradeCost > dusts)
		{
			SPDLOG_ERROR("[{}] Not enough dust", __FUNCTION__);
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

void Player::forgeHistory(uint8_t page) const
{
	sendForgeHistory(page);
}

void Player::registerForgeHistoryDescription(ForgeHistory history)
{
	std::string successfulString = history.success ? "Successful" : "Unsuccessful";
	std::string historyTierString = history.tier > 0 ? "tier - 1" : "consumed";
	std::string price = history.bonus != 3 ? formatPrice(std::to_string(history.cost), true) : "0";
	std::stringstream detailsResponse;
	auto itemId = Item::items.getItemIdByName(history.firstItemName);
	const ItemType &itemType = Item::items[itemId];
	if (history.actionType == ForgeConversion_t::FORGE_ACTION_FUSION) {
		if (history.success) {
			detailsResponse << fmt::format(
				"{:s} <br><br>"
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
				itemType.article, itemType.name, std::to_string(history.tier),
				itemType.article, itemType.name, std::to_string(history.tier),
				history.bonus == 8 ? "unchanged" : "consumed",
				history.coresCost, history.dustCost, price
			);
		} else {
			detailsResponse << fmt::format(
				"{:s} <br><br>"
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
				itemType.article, itemType.name, std::to_string(history.tier),
				itemType.article, itemType.name, std::to_string(history.tier),
				history.bonus == 8 ? "unchanged" : historyTierString,
				history.coresCost, price
			);
		}
	} else if (history.actionType == ForgeConversion_t::FORGE_ACTION_TRANSFER) {
		detailsResponse << fmt::format(
				"{:s} <br><br>"
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
				itemType.article, itemType.name, std::to_string(history.tier),
				itemType.article, itemType.name, std::to_string(history.tier),
				itemType.article, itemType.name, std::to_string(history.tier),
				itemType.article, itemType.name, std::to_string(history.tier),
				price
			);
	} else if (history.actionType == ForgeConversion_t::FORGE_ACTION_DUSTTOSLIVERS) {
		detailsResponse << fmt::format("Converted {:d} dust to {:d} slivers.", history.cost, history.gained);

	} else if (history.actionType == ForgeConversion_t::FORGE_ACTION_SLIVERSTOCORES) {
		history.actionType = ForgeConversion_t::FORGE_ACTION_DUSTTOSLIVERS;
		detailsResponse << fmt::format("Converted {:d} slivers to {:d} exalted core.", history.cost, history.gained);

	} else if (history.actionType == ForgeConversion_t::FORGE_ACTION_INCREASELIMIT) {
		history.actionType = ForgeConversion_t::FORGE_ACTION_DUSTTOSLIVERS;
		detailsResponse << fmt::format("Spent {:d} dust to increase the dust limit to {:d}.", history.cost, history.gained + 1);

	} else {
		detailsResponse << "(unknown)";
	}

	history.description = detailsResponse.str();

	setForgeHistory(history);
}

/*******************************************************************************
 * Interfaces
 ******************************************************************************/

error_t Player::SetAccountInterface(account::Account* account) {
	if (account == nullptr) {
		return account::ERROR_NULLPTR;
	}

	account_ = account;
	return account::ERROR_NO;
}

error_t Player::GetAccountInterface(account::Account* account) {
	account = account_;
	return account::ERROR_NO;
}
