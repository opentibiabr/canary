/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/combat/condition.hpp"

#include "config/configmanager.hpp"
#include "creatures/combat/combat.hpp"
#include "creatures/monsters/monsters.hpp"
#include "enums/player_icons.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "io/fileloader.hpp"
#include "kv/kv.hpp"
#include "map/spectators.hpp"
#include "creatures/creature.hpp"
#include "creatures/players/player.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "utils/object_pool.hpp"

/**
 *  Condition
 */

bool Condition::setParam(ConditionParam_t param, int32_t value) {
	switch (param) {
		case CONDITION_PARAM_TICKS: {
			ticks = value;
			return true;
		}

		case CONDITION_PARAM_DRAIN_BODY: {
			drainBodyStage = std::min(static_cast<uint8_t>(value), std::numeric_limits<uint8_t>::max());
			return true;
		}

		case CONDITION_PARAM_BUFF_SPELL: {
			isBuff = (value != 0);
			return true;
		}

		case CONDITION_PARAM_SUBID: {
			subId = value;
			return true;
		}

		case CONDITION_PARAM_SOUND_TICK: {
			tickSound = static_cast<SoundEffect_t>(value);
			return true;
		}

		case CONDITION_PARAM_SOUND_ADD: {
			addSound = static_cast<SoundEffect_t>(value);
			return true;
		}

		default: {
			return false;
		}
	}
}

bool Condition::setPositionParam(ConditionParam_t param, const Position &pos) {
	return false;
}

bool Condition::unserialize(PropStream &propStream) {
	uint8_t attr_type;
	while (propStream.read<uint8_t>(attr_type) && attr_type != CONDITIONATTR_END) {
		if (!unserializeProp(static_cast<ConditionAttr_t>(attr_type), propStream)) {
			return false;
		}
	}
	return true;
}

bool Condition::unserializeProp(ConditionAttr_t attr, PropStream &propStream) {
	switch (attr) {
		case CONDITIONATTR_TYPE: {
			int32_t value;
			if (!propStream.read<int32_t>(value)) {
				return false;
			}

			conditionType = static_cast<ConditionType_t>(value);
			return true;
		}

		case CONDITIONATTR_ID: {
			int32_t value;
			if (!propStream.read<int32_t>(value)) {
				return false;
			}

			id = static_cast<ConditionId_t>(value);
			return true;
		}

		case CONDITIONATTR_TICKS: {
			return propStream.read<int32_t>(ticks);
		}

		case CONDITIONATTR_ISBUFF: {
			uint8_t value;
			if (!propStream.read<uint8_t>(value)) {
				return false;
			}

			isBuff = (value != 0);
			return true;
		}

		case CONDITIONATTR_SUBID: {
			return propStream.read<uint32_t>(subId);
		}

		case CONDITIONATTR_TICKSOUND: {
			uint16_t value;
			if (!propStream.read<uint16_t>(value)) {
				return false;
			}

			tickSound = static_cast<SoundEffect_t>(value);
			return true;
		}

		case CONDITIONATTR_ADDSOUND: {
			uint16_t value;
			if (!propStream.read<uint16_t>(value)) {
				return false;
			}

			addSound = static_cast<SoundEffect_t>(value);
			return true;
		}

		case CONDITIONATTR_PERSISTENT: {
			bool value = false;
			if (!propStream.read<bool>(value)) {
				return false;
			}

			m_isPersistent = value;
			return true;
		}

		case CONDITIONATTR_END:
			return true;

		default:
			return false;
	}
}

void Condition::serialize(PropWriteStream &propWriteStream) {
	propWriteStream.write<uint8_t>(CONDITIONATTR_TYPE);
	propWriteStream.write<int8_t>(conditionType);

	propWriteStream.write<uint8_t>(CONDITIONATTR_ID);
	propWriteStream.write<uint32_t>(id);

	propWriteStream.write<uint8_t>(CONDITIONATTR_TICKS);
	propWriteStream.write<uint32_t>(ticks);

	propWriteStream.write<uint8_t>(CONDITIONATTR_ISBUFF);
	propWriteStream.write<uint8_t>(isBuff);

	propWriteStream.write<uint8_t>(CONDITIONATTR_SUBID);
	propWriteStream.write<uint32_t>(subId);

	propWriteStream.write<uint8_t>(CONDITIONATTR_TICKSOUND);
	propWriteStream.write<uint16_t>(static_cast<uint16_t>(tickSound));

	propWriteStream.write<uint8_t>(CONDITIONATTR_ADDSOUND);
	propWriteStream.write<uint16_t>(static_cast<uint16_t>(addSound));

	propWriteStream.write<uint8_t>(CONDITIONATTR_PERSISTENT);
	propWriteStream.write<bool>(m_isPersistent);
}

void Condition::setTicks(int32_t newTicks) {
	ticks = newTicks;
	endTime = ticks + OTSYS_TIME();
}

bool Condition::executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) {
	if (ticks == -1) {
		return true;
	}

	// Not using set ticks here since it would reset endTime
	ticks = std::max<int32_t>(0, ticks - interval);
	if (getEndTime() < OTSYS_TIME()) {
		return false;
	}

	if (creature && tickSound != SoundEffect_t::SILENCE) {
		g_game().sendSingleSoundEffect(creature->getPosition(), tickSound, creature);
	}

	return true;
}

std::shared_ptr<Condition> Condition::createCondition(ConditionId_t id, ConditionType_t type, int32_t ticks, int32_t param /* = 0*/, bool buff /* = false*/, uint32_t subId /* = 0*/, bool isPersistent /* = false*/) {
	switch (type) {
		case CONDITION_POISON:
		case CONDITION_FIRE:
		case CONDITION_ENERGY:
		case CONDITION_DROWN:
		case CONDITION_FREEZING:
		case CONDITION_DAZZLED:
		case CONDITION_CURSED:
		case CONDITION_BLEEDING:
			return ObjectPool<ConditionDamage, 1024>::allocateShared(id, type, buff, subId);

		case CONDITION_HASTE:
		case CONDITION_PARALYZE:
			return ObjectPool<ConditionSpeed, 1024>::allocateShared(id, type, ticks, buff, subId, param);

		case CONDITION_INVISIBLE:
			return ObjectPool<ConditionInvisible, 1024>::allocateShared(id, type, ticks, buff, subId);

		case CONDITION_OUTFIT:
			return ObjectPool<ConditionOutfit, 1024>::allocateShared(id, type, ticks, buff, subId);

		case CONDITION_LIGHT:
			return ObjectPool<ConditionLight, 1024>::allocateShared(id, type, ticks, buff, subId, param & 0xFF, (param & 0xFF00) >> 8);

		case CONDITION_REGENERATION:
			return ObjectPool<ConditionRegeneration, 1024>::allocateShared(id, type, ticks, buff, subId);

		case CONDITION_SOUL:
			return ObjectPool<ConditionSoul, 1024>::allocateShared(id, type, ticks, buff, subId);

		case CONDITION_LESSERHEX:
		case CONDITION_INTENSEHEX:
		case CONDITION_GREATERHEX:
		case CONDITION_ATTRIBUTES:
			return ObjectPool<ConditionAttributes, 1024>::allocateShared(id, type, ticks, buff, subId);

		case CONDITION_SPELLCOOLDOWN:
			return ObjectPool<ConditionSpellCooldown, 1024>::allocateShared(id, type, ticks, buff, subId);

		case CONDITION_SPELLGROUPCOOLDOWN:
			return ObjectPool<ConditionSpellGroupCooldown, 1024>::allocateShared(id, type, ticks, buff, subId);

		case CONDITION_MANASHIELD:
			return ObjectPool<ConditionManaShield, 1024>::allocateShared(id, type, ticks, buff, subId);

		case CONDITION_FEARED:
			return ObjectPool<ConditionFeared, 1024>::allocateShared(id, type, ticks, buff, subId);

		case CONDITION_ROOTED:
		case CONDITION_INFIGHT:
		case CONDITION_DRUNK:
		case CONDITION_EXHAUST:
		case CONDITION_EXHAUST_COMBAT:
		case CONDITION_EXHAUST_HEAL:
		case CONDITION_MUTED:
		case CONDITION_CHANNELMUTEDTICKS:
		case CONDITION_YELLTICKS:
		case CONDITION_POWERLESS:
		case CONDITION_PACIFIED:
			return ObjectPool<ConditionGeneric, 1024>::allocateShared(id, type, ticks, buff, subId);

		case CONDITION_BAKRAGORE:
			return ObjectPool<ConditionGeneric, 1024>::allocateShared(id, type, ticks, buff, subId, isPersistent);

		case CONDITION_GOSHNARTAINT:
			return ObjectPool<ConditionGeneric, 1024>::allocateShared(id, type, ticks, buff, subId);

		default:
			return nullptr;
	}
}

std::shared_ptr<Condition> Condition::createCondition(PropStream &propStream) {
	uint8_t attr;
	if (!propStream.read<uint8_t>(attr) || attr != CONDITIONATTR_TYPE) {
		return nullptr;
	}

	int8_t type;
	if (!propStream.read<int8_t>(type)) {
		return nullptr;
	}

	if (!propStream.read<uint8_t>(attr) || attr != CONDITIONATTR_ID) {
		return nullptr;
	}

	uint32_t id;
	if (!propStream.read<uint32_t>(id)) {
		return nullptr;
	}

	if (!propStream.read<uint8_t>(attr) || attr != CONDITIONATTR_TICKS) {
		return nullptr;
	}

	uint32_t ticks;
	if (!propStream.read<uint32_t>(ticks)) {
		return nullptr;
	}

	if (!propStream.read<uint8_t>(attr) || attr != CONDITIONATTR_ISBUFF) {
		return nullptr;
	}

	uint8_t buff;
	if (!propStream.read<uint8_t>(buff)) {
		return nullptr;
	}

	if (!propStream.read<uint8_t>(attr) || attr != CONDITIONATTR_SUBID) {
		return nullptr;
	}

	uint32_t subId;
	if (!propStream.read<uint32_t>(subId)) {
		return nullptr;
	}

	return createCondition(static_cast<ConditionId_t>(id), static_cast<ConditionType_t>(type), ticks, 0, buff != 0, subId);
}

Condition::Condition(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId, bool isPersistent) :
	endTime(initTicks == -1 ? std::numeric_limits<int64_t>::max() : 0),
	subId(initSubId), ticks(initTicks), conditionType(initType), id(initId), isBuff(initBuff), m_isPersistent(isPersistent) { }

bool Condition::startCondition(std::shared_ptr<Creature>) {
	if (ticks > 0) {
		endTime = ticks + OTSYS_TIME();
	}
	return true;
}

bool Condition::isPersistent() const {
	if (m_isPersistent) {
		g_logger().debug("Condition {} is persistent", conditionType);
		return true;
	}
	if (ticks == -1) {
		return false;
	}

	if (!(id == CONDITIONID_DEFAULT || id == CONDITIONID_COMBAT)) {
		return false;
	}

	return true;
}

bool Condition::isRemovableOnDeath() const {
	if (m_isPersistent) {
		return false;
	}

	if (ticks == -1) {
		return false;
	}

	static const std::unordered_set<ConditionType_t> nonRemovableConditions = {
		CONDITION_SPELLCOOLDOWN,
		CONDITION_SPELLGROUPCOOLDOWN,
		CONDITION_MUTED,
		CONDITION_GOSHNARTAINT
	};

	if (nonRemovableConditions.find(conditionType) != nonRemovableConditions.end()) {
		return false;
	}

	return true;
}

std::unordered_set<PlayerIcon> Condition::getIcons() const {
	std::unordered_set<PlayerIcon> icons;
	if (isBuff) {
		icons.insert(PlayerIcon::PartyBuff);
	}

	return icons;
}

ConditionId_t Condition::getId() const {
	return id;
}

uint32_t Condition::getSubId() const {
	return subId;
}

ConditionType_t Condition::getType() const {
	return conditionType;
}

int64_t Condition::getEndTime() const {
	return endTime;
}

int32_t Condition::getTicks() const {
	return ticks;
}

bool Condition::updateCondition(const std::shared_ptr<Condition> &addCondition) {
	if (conditionType != addCondition->getType()) {
		return false;
	}

	if (ticks == -1 && addCondition->getTicks() > 0) {
		return false;
	}

	if (addCondition->getTicks() >= 0 && getEndTime() > (OTSYS_TIME() + addCondition->getTicks())) {
		return false;
	}

	return true;
}

/**
 *  ConditionGeneric
 */

ConditionGeneric::ConditionGeneric(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId, bool isPersistent) :
	Condition(initId, initType, initTicks, initBuff, initSubId, isPersistent) { }

bool ConditionGeneric::startCondition(std::shared_ptr<Creature> creature) {
	return Condition::startCondition(creature);
}

bool ConditionGeneric::executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) {
	return Condition::executeCondition(creature, interval);
}

void ConditionGeneric::endCondition(std::shared_ptr<Creature>) {
	//
}

void ConditionGeneric::addCondition(std::shared_ptr<Creature> creature, const std::shared_ptr<Condition> addCondition) {
	if (updateCondition(addCondition)) {
		setTicks(addCondition->getTicks());

		if (creature && addSound != SoundEffect_t::SILENCE) {
			g_game().sendSingleSoundEffect(creature->getPosition(), addSound, creature);
		}
	}
}

std::unordered_set<PlayerIcon> ConditionGeneric::getIcons() const {
	auto icons = Condition::getIcons();

	switch (conditionType) {
		case CONDITION_INFIGHT:
			icons.insert(PlayerIcon::Swords);
			break;

		case CONDITION_DRUNK:
			icons.insert(PlayerIcon::Drunk);
			break;

		case CONDITION_ROOTED:
			icons.insert(PlayerIcon::Rooted);
			break;

		case CONDITION_LESSERHEX:
			icons.insert(PlayerIcon::LesserHex);
			break;

		case CONDITION_INTENSEHEX:
			icons.insert(PlayerIcon::IntenseHex);
			break;

		case CONDITION_GREATERHEX:
			icons.insert(PlayerIcon::GreaterHex);
			break;

		case CONDITION_POWERLESS:
			icons.insert(PlayerIcon::Powerless);
			break;

		case CONDITION_GOSHNARTAINT:
			switch (subId) {
				case 1:
					icons.insert(PlayerIcon::GoshnarTaint1);
					break;
				case 2:
					icons.insert(PlayerIcon::GoshnarTaint2);
					break;
				case 3:
					icons.insert(PlayerIcon::GoshnarTaint3);
					break;
				case 4:
					icons.insert(PlayerIcon::GoshnarTaint4);
					break;
				case 5:
					icons.insert(PlayerIcon::GoshnarTaint5);
					break;
				default:
					break;
			}
		default:
			break;
	}

	return icons;
}

std::shared_ptr<Condition> ConditionGeneric::clone() const {
	return std::make_shared<ConditionGeneric>(*this);
}

/**
 *  ConditionAttributes
 */

void ConditionAttributes::addCondition(std::shared_ptr<Creature> creature, const std::shared_ptr<Condition> addCondition) {
	if (!creature) {
		return;
	}

	if (updateCondition(addCondition)) {
		setTicks(addCondition->getTicks());

		const std::shared_ptr<ConditionAttributes> &conditionAttrs = addCondition->static_self_cast<ConditionAttributes>();
		// Remove the old condition
		endCondition(creature);

		// Apply the new one
		std::ranges::copy(std::span(conditionAttrs->skills), skills);
		std::ranges::copy(std::span(conditionAttrs->skillsPercent), skillsPercent);
		std::ranges::copy(std::span(conditionAttrs->stats), stats);
		std::ranges::copy(std::span(conditionAttrs->statsPercent), statsPercent);
		std::ranges::copy(std::span(conditionAttrs->buffs), buffs);
		std::ranges::copy(std::span(conditionAttrs->buffsPercent), buffsPercent);

		absorbs = conditionAttrs->absorbs;
		absorbsPercent = conditionAttrs->absorbsPercent;
		increases = conditionAttrs->increases;
		increasesPercent = conditionAttrs->increasesPercent;
		charmChanceModifier = conditionAttrs->charmChanceModifier;

		updatePercentBuffs(creature);
		updateBuffs(creature);
		updatePercentAbsorbs(creature);
		updateAbsorbs(creature);
		updatePercentIncreases(creature);
		updateIncreases(creature);
		updateCharmChanceModifier(creature);
		disableDefense = conditionAttrs->disableDefense;

		if (const auto &player = creature->getPlayer()) {
			updatePercentSkills(player);
			updateSkills(player);
			updatePercentStats(player);
			updateStats(player);
		}
	}
	if (drainBodyStage > 0) {
		creature->setWheelOfDestinyDrainBodyDebuff(drainBodyStage);
	}
}

bool ConditionAttributes::unserializeProp(ConditionAttr_t attr, PropStream &propStream) {
	if (attr == CONDITIONATTR_SKILLS) {
		return propStream.read<int32_t>(skills[currentSkill++]);
	} else if (attr == CONDITIONATTR_STATS) {
		return propStream.read<int32_t>(stats[currentStat++]);
	} else if (attr == CONDITIONATTR_BUFFS) {
		return propStream.read<int32_t>(buffs[currentBuff++]);
	} else if (attr == CONDITIONATTR_ABSORBS) {
		for (int32_t i = 0; i < CombatType_t::COMBAT_COUNT; ++i) {
			uint8_t index;
			int32_t value;
			if (!propStream.read<uint8_t>(index) || !propStream.read<int32_t>(value)) {
				return false;
			}

			setAbsorb(index, value);
		}

		return true;
	} else if (attr == CONDITIONATTR_INCREASES) {
		for (int32_t i = 0; i < CombatType_t::COMBAT_COUNT; ++i) {
			uint8_t index;
			int32_t value;
			if (!propStream.read<uint8_t>(index) || !propStream.read<int32_t>(value)) {
				return false;
			}

			setIncrease(index, value);
		}

		return true;
	} else if (attr == CONDITIONATTR_CHARM_CHANCE_MODIFIER) {
		return propStream.read<int8_t>(charmChanceModifier);
	}
	return Condition::unserializeProp(attr, propStream);
}

void ConditionAttributes::serialize(PropWriteStream &propWriteStream) {
	Condition::serialize(propWriteStream);

	for (int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
		propWriteStream.write<uint8_t>(CONDITIONATTR_SKILLS);
		propWriteStream.write<int32_t>(skills[i]);
	}

	for (int32_t i = STAT_FIRST; i <= STAT_LAST; ++i) {
		propWriteStream.write<uint8_t>(CONDITIONATTR_STATS);
		propWriteStream.write<int32_t>(stats[i]);
	}

	for (int32_t i = BUFF_FIRST; i <= BUFF_LAST; ++i) {
		propWriteStream.write<uint8_t>(CONDITIONATTR_BUFFS);
		propWriteStream.write<int32_t>(buffs[i]);
	}

	// Save attribute absorbs
	propWriteStream.write<uint8_t>(CONDITIONATTR_ABSORBS);
	for (int32_t i = 0; i < CombatType_t::COMBAT_COUNT; ++i) {
		// Save index
		propWriteStream.write<uint8_t>(i);
		// Save percent
		propWriteStream.write<int32_t>(getAbsorbByIndex(i));
	}

	// Save attribute increases
	propWriteStream.write<uint8_t>(CONDITIONATTR_INCREASES);
	for (int32_t i = 0; i < CombatType_t::COMBAT_COUNT; ++i) {
		// Save index
		propWriteStream.write<uint8_t>(i);
		// Save percent
		propWriteStream.write<int32_t>(getIncreaseByIndex(i));
	}

	// Save charm percent
	propWriteStream.write<uint8_t>(CONDITIONATTR_CHARM_CHANCE_MODIFIER);
	propWriteStream.write<int8_t>(charmChanceModifier);
}

ConditionAttributes::ConditionAttributes(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId) :
	ConditionGeneric(initId, initType, initTicks, initBuff, initSubId) { }

bool ConditionAttributes::startCondition(std::shared_ptr<Creature> creature) {
	if (!Condition::startCondition(creature)) {
		return false;
	}

	creature->setUseDefense(!disableDefense);
	updatePercentBuffs(creature);
	updateBuffs(creature);
	// 12.72 mechanics
	updatePercentAbsorbs(creature);
	updateAbsorbs(creature);
	updatePercentIncreases(creature);
	updateIncreases(creature);
	updateCharmChanceModifier(creature);
	if (const auto &player = creature->getPlayer()) {
		updatePercentSkills(player);
		updateSkills(player);
		updatePercentStats(player);
		updateStats(player);
	}

	return true;
}

void ConditionAttributes::updatePercentStats(const std::shared_ptr<Player> &player) {
	for (int32_t i = STAT_FIRST; i <= STAT_LAST; ++i) {
		if (statsPercent[i] == 0) {
			continue;
		}

		switch (i) {
			case STAT_MAXHITPOINTS:
				stats[i] = static_cast<int32_t>(player->getMaxHealth() * ((statsPercent[i] - 100) / 100.f));
				break;

			case STAT_MAXMANAPOINTS:
				stats[i] = static_cast<int32_t>(player->getMaxMana() * ((statsPercent[i] - 100) / 100.f));
				break;

			case STAT_MAGICPOINTS:
				stats[i] = static_cast<int32_t>(player->getBaseMagicLevel() * ((statsPercent[i] - 100) / 100.f));
				break;

			case STAT_CAPACITY:
				stats[i] = static_cast<int32_t>(player->getCapacity() * (statsPercent[i] / 100.f));
				break;
		}
	}
}

void ConditionAttributes::updateStats(const std::shared_ptr<Player> &player) const {
	bool needUpdate = false;

	for (int32_t i = STAT_FIRST; i <= STAT_LAST; ++i) {
		if (stats[i]) {
			needUpdate = true;
			player->setVarStats(static_cast<stats_t>(i), stats[i]);
		}
	}

	if (needUpdate) {
		player->sendStats();
		player->sendSkills();
	}
}

void ConditionAttributes::updatePercentSkills(const std::shared_ptr<Player> &player) {
	for (uint8_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
		auto skill = static_cast<skills_t>(i);
		if (skillsPercent[skill] == 0) {
			continue;
		}

		int32_t unmodifiedSkill = player->getBaseSkill(skill);
		skills[skill] = static_cast<int32_t>(unmodifiedSkill * ((skillsPercent[skill] - 100) / 100.f));
	}
}

void ConditionAttributes::updateSkills(const std::shared_ptr<Player> &player) const {
	bool needUpdateSkills = false;

	for (int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
		if (skills[i]) {
			needUpdateSkills = true;
			player->setVarSkill(static_cast<skills_t>(i), skills[i]);
		}
	}

	if (needUpdateSkills) {
		player->sendSkills();
	}
}

void ConditionAttributes::updatePercentAbsorbs(const std::shared_ptr<Creature> &creature) {
	for (uint8_t i = 0; i < COMBAT_COUNT; i++) {
		auto value = getAbsorbPercentByIndex(i);
		if (value == 0) {
			continue;
		}
		setAbsorb(i, std::round((100 - creature->getAbsorbPercent(indexToCombatType(i))) * value / 100.f));
	}
}

void ConditionAttributes::updateAbsorbs(const std::shared_ptr<Creature> &creature) const {
	for (uint8_t i = 0; i < COMBAT_COUNT; i++) {
		auto value = getAbsorbByIndex(i);
		if (value == 0) {
			continue;
		}

		creature->setAbsorbPercent(indexToCombatType(i), value);
	}
}

void ConditionAttributes::updatePercentIncreases(const std::shared_ptr<Creature> &creature) {
	for (uint8_t i = 0; i < COMBAT_COUNT; i++) {
		auto increasePercentValue = getIncreasePercentById(i);
		if (increasePercentValue == 0) {
			continue;
		}
		setIncrease(i, std::round((100 - creature->getIncreasePercent(indexToCombatType(i))) * increasePercentValue / 100.f));
	}
}

void ConditionAttributes::updateIncreases(const std::shared_ptr<Creature> &creature) const {
	for (uint8_t i = 0; i < COMBAT_COUNT; i++) {
		auto increaseValue = getIncreaseByIndex(i);
		if (increaseValue == 0) {
			continue;
		}
		creature->setIncreasePercent(indexToCombatType(i), increaseValue);
	}
}

void ConditionAttributes::updateCharmChanceModifier(const std::shared_ptr<Creature> &creature) const {
	creature->setCharmChanceModifier(creature->getCharmChanceModifier() + charmChanceModifier);
}

void ConditionAttributes::updatePercentBuffs(const std::shared_ptr<Creature> &creature) {
	for (int32_t i = BUFF_FIRST; i <= BUFF_LAST; ++i) {
		if (buffsPercent[i] == 0) {
			continue;
		}

		int32_t actualBuff = creature->getBuff(i);
		buffs[i] = static_cast<int32_t>(actualBuff * ((buffsPercent[i] - 100) / 100.f));
	}
}

void ConditionAttributes::updateBuffs(const std::shared_ptr<Creature> &creature) const {
	bool needUpdate = false;
	for (int32_t i = BUFF_FIRST; i <= BUFF_LAST; ++i) {
		if (buffs[i]) {
			needUpdate = true;
			creature->setBuff(static_cast<buffs_t>(i), buffs[i]);
		}
	}
	if (creature->getMonster() && needUpdate) {
		g_game().updateCreatureIcon(creature);
	}
}

bool ConditionAttributes::executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) {
	return ConditionGeneric::executeCondition(creature, interval);
}

void ConditionAttributes::endCondition(std::shared_ptr<Creature> creature) {
	const auto &player = creature->getPlayer();
	if (player) {
		bool needUpdate = false;

		for (int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i) {
			if (skills[i] || skillsPercent[i]) {
				needUpdate = true;
				player->setVarSkill(static_cast<skills_t>(i), -skills[i]);
			}
		}

		for (int32_t i = STAT_FIRST; i <= STAT_LAST; ++i) {
			if (stats[i]) {
				needUpdate = true;
				player->setVarStats(static_cast<stats_t>(i), -stats[i]);
			}
		}

		player->setCharmChanceModifier(player->getCharmChanceModifier() - charmChanceModifier);

		if (needUpdate) {
			player->sendStats();
			player->sendSkills();
		}
	}
	bool needUpdateIcons = false;
	for (int32_t i = BUFF_FIRST; i <= BUFF_LAST; ++i) {
		if (buffs[i]) {
			needUpdateIcons = true;
			creature->setBuff(static_cast<buffs_t>(i), -buffs[i]);
		}
	}
	for (uint8_t i = 0; i < COMBAT_COUNT; i++) {
		auto value = getAbsorbByIndex(i);
		if (value) {
			creature->setAbsorbPercent(indexToCombatType(i), -value);
		}
		auto increaseValue = getIncreaseByIndex(i);
		if (increaseValue > 0) {
			creature->setIncreasePercent(indexToCombatType(i), -increaseValue);
		}
	}

	if (creature->getMonster() && needUpdateIcons) {
		g_game().updateCreatureIcon(creature);
	}

	if (disableDefense) {
		creature->setUseDefense(true);
	}
}

bool ConditionAttributes::setParam(ConditionParam_t param, int32_t value) {
	bool ret = ConditionGeneric::setParam(param, value);

	switch (param) {
		case CONDITION_PARAM_SKILL_MELEE: {
			skills[SKILL_CLUB] = value;
			skills[SKILL_AXE] = value;
			skills[SKILL_SWORD] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_MELEEPERCENT: {
			skillsPercent[SKILL_CLUB] = value;
			skillsPercent[SKILL_AXE] = value;
			skillsPercent[SKILL_SWORD] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_FIST: {
			skills[SKILL_FIST] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_FISTPERCENT: {
			skillsPercent[SKILL_FIST] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_CLUB: {
			skills[SKILL_CLUB] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_CLUBPERCENT: {
			skillsPercent[SKILL_CLUB] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_SWORD: {
			skills[SKILL_SWORD] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_SWORDPERCENT: {
			skillsPercent[SKILL_SWORD] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_AXE: {
			skills[SKILL_AXE] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_AXEPERCENT: {
			skillsPercent[SKILL_AXE] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_DISTANCE: {
			skills[SKILL_DISTANCE] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_DISTANCEPERCENT: {
			skillsPercent[SKILL_DISTANCE] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_SHIELD: {
			skills[SKILL_SHIELD] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_SHIELDPERCENT: {
			skillsPercent[SKILL_SHIELD] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_FISHING: {
			skills[SKILL_FISHING] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_FISHINGPERCENT: {
			skillsPercent[SKILL_FISHING] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE: {
			skills[SKILL_CRITICAL_HIT_CHANCE] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE: {
			skills[SKILL_CRITICAL_HIT_DAMAGE] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_LIFE_LEECH_CHANCE: {
			skills[SKILL_LIFE_LEECH_CHANCE] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT: {
			skills[SKILL_LIFE_LEECH_AMOUNT] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_MANA_LEECH_CHANCE: {
			skills[SKILL_MANA_LEECH_CHANCE] = value;
			return true;
		}

		case CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT: {
			skills[SKILL_MANA_LEECH_AMOUNT] = value;
			return true;
		}

		case CONDITION_PARAM_STAT_MAXHITPOINTS: {
			stats[STAT_MAXHITPOINTS] = value;
			return true;
		}

		case CONDITION_PARAM_STAT_MAXMANAPOINTS: {
			stats[STAT_MAXMANAPOINTS] = value;
			return true;
		}

		case CONDITION_PARAM_STAT_MAGICPOINTS: {
			stats[STAT_MAGICPOINTS] = value;
			return true;
		}

		case CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT: {
			statsPercent[STAT_MAXHITPOINTS] = std::max<int32_t>(0, value);
			return true;
		}

		case CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT: {
			statsPercent[STAT_MAXMANAPOINTS] = std::max<int32_t>(0, value);
			return true;
		}

		case CONDITION_PARAM_STAT_MAGICPOINTSPERCENT: {
			statsPercent[STAT_MAGICPOINTS] = std::max<int32_t>(0, value);
			return true;
		}

		case CONDITION_PARAM_DISABLE_DEFENSE: {
			disableDefense = (value != 0);
			return true;
		}

		case CONDITION_PARAM_STAT_CAPACITYPERCENT: {
			statsPercent[STAT_CAPACITY] = std::max<int32_t>(0, value);
			return true;
		}

		case CONDITION_PARAM_BUFF_HEALINGRECEIVED: {
			buffsPercent[BUFF_HEALINGRECEIVED] = std::max<int32_t>(0, value);
			return true;
		}

		case CONDITION_PARAM_BUFF_DAMAGEDEALT: {
			buffsPercent[BUFF_DAMAGEDEALT] = std::max<int32_t>(0, value);
			return true;
		}

		case CONDITION_PARAM_BUFF_DAMAGERECEIVED: {
			buffsPercent[BUFF_DAMAGERECEIVED] = std::max<int32_t>(0, value);
			return true;
		}

		case CONDITION_PARAM_ABSORB_PHYSICALPERCENT: {
			setAbsorbPercent(combatTypeToIndex(COMBAT_PHYSICALDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_ABSORB_FIREPERCENT: {
			setAbsorbPercent(combatTypeToIndex(COMBAT_FIREDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_ABSORB_ENERGYPERCENT: {
			setAbsorbPercent(combatTypeToIndex(COMBAT_ENERGYDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_ABSORB_ICEPERCENT: {
			setAbsorbPercent(combatTypeToIndex(COMBAT_ICEDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_ABSORB_EARTHPERCENT: {
			setAbsorbPercent(combatTypeToIndex(COMBAT_EARTHDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_ABSORB_DEATHPERCENT: {
			setAbsorbPercent(combatTypeToIndex(COMBAT_DEATHDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_ABSORB_HOLYPERCENT: {
			setAbsorbPercent(combatTypeToIndex(COMBAT_HOLYDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_ABSORB_LIFEDRAINPERCENT: {
			setAbsorbPercent(combatTypeToIndex(COMBAT_LIFEDRAIN), value);
			return true;
		}

		case CONDITION_PARAM_ABSORB_MANADRAINPERCENT: {
			setAbsorbPercent(combatTypeToIndex(COMBAT_MANADRAIN), value);
			return true;
		}

		case CONDITION_PARAM_ABSORB_DROWNPERCENT: {
			setAbsorbPercent(combatTypeToIndex(COMBAT_DROWNDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_INCREASE_PHYSICALPERCENT: {
			setIncreasePercent(combatTypeToIndex(COMBAT_PHYSICALDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_INCREASE_FIREPERCENT: {
			setIncreasePercent(combatTypeToIndex(COMBAT_FIREDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_INCREASE_ENERGYPERCENT: {
			setIncreasePercent(combatTypeToIndex(COMBAT_ENERGYDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_INCREASE_ICEPERCENT: {
			setIncreasePercent(combatTypeToIndex(COMBAT_ICEDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_INCREASE_EARTHPERCENT: {
			setIncreasePercent(combatTypeToIndex(COMBAT_EARTHDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_INCREASE_DEATHPERCENT: {
			setIncreasePercent(combatTypeToIndex(COMBAT_DEATHDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_INCREASE_HOLYPERCENT: {
			setIncreasePercent(combatTypeToIndex(COMBAT_HOLYDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_INCREASE_LIFEDRAINPERCENT: {
			setIncreasePercent(combatTypeToIndex(COMBAT_LIFEDRAIN), value);
			return true;
		}

		case CONDITION_PARAM_INCREASE_MANADRAINPERCENT: {
			setIncreasePercent(combatTypeToIndex(COMBAT_MANADRAIN), value);
			return true;
		}

		case CONDITION_PARAM_INCREASE_DROWNPERCENT: {
			setIncreasePercent(combatTypeToIndex(COMBAT_DROWNDAMAGE), value);
			return true;
		}

		case CONDITION_PARAM_CHARM_CHANCE_MODIFIER: {
			charmChanceModifier = static_cast<int8_t>(value);
			return true;
		}

		default:
			return ret;
	}
}

std::shared_ptr<Condition> ConditionAttributes::clone() const {
	return std::make_shared<ConditionAttributes>(*this);
}

int32_t ConditionAttributes::getAbsorbByIndex(uint8_t index) const {
	try {
		return absorbs.at(index);
	} catch (const std::out_of_range &e) {
		g_logger().error("Index {} is out of range in getAbsorbsValue: {}", index, e.what());
	}
	return 0;
}

void ConditionAttributes::setAbsorb(uint8_t index, int32_t value) {
	try {
		absorbs.at(index) = value;
	} catch (const std::out_of_range &e) {
		g_logger().error("Index {} is out of range in setAbsorb: {}", index, e.what());
	}
}

int32_t ConditionAttributes::getAbsorbPercentByIndex(uint8_t index) const {
	try {
		return absorbsPercent.at(index);
	} catch (const std::out_of_range &e) {
		g_logger().error("Index {} is out of range in getAbsorbPercentByIndex: {}", index, e.what());
	}
	return 0;
}

void ConditionAttributes::setAbsorbPercent(uint8_t index, int32_t value) {
	try {
		absorbsPercent.at(index) = value;
	} catch (const std::out_of_range &e) {
		g_logger().error("Index {} is out of range in setAbsorbPercent: {}", index, e.what());
	}
}

int32_t ConditionAttributes::getIncreaseByIndex(uint8_t index) const {
	try {
		return increases.at(index);
	} catch (const std::out_of_range &e) {
		g_logger().error("Index {} is out of range in getIncreaseByIndex: {}", index, e.what());
	}
	return 0;
}

void ConditionAttributes::setIncrease(uint8_t index, int32_t value) {
	try {
		increases.at(index) = value;
	} catch (const std::out_of_range &e) {
		g_logger().error("Index {} is out of range in setIncrease: {}", index, e.what());
	}
}

int32_t ConditionAttributes::getIncreasePercentById(uint8_t index) const {
	try {
		return increasesPercent.at(index);
	} catch (const std::out_of_range &e) {
		g_logger().error("Index {} is out of range in getIncreasePercentById: {}", index, e.what());
	}
	return 0;
}

void ConditionAttributes::setIncreasePercent(uint8_t index, int32_t value) {
	try {
		increasesPercent.at(index) = value;
	} catch (const std::out_of_range &e) {
		g_logger().error("Index {} is out of range in setIncreasePercent: {}", index, e.what());
	}
}

/**
 *  ConditionRegeneration
 */

ConditionRegeneration::ConditionRegeneration(ConditionId_t initId, ConditionType_t initType, int32_t iniTicks, bool initBuff, uint32_t initSubId) :
	ConditionGeneric(initId, initType, iniTicks, initBuff, initSubId) { }

bool ConditionRegeneration::startCondition(std::shared_ptr<Creature> creature) {
	if (!Condition::startCondition(creature)) {
		return false;
	}

	if (const auto &player = creature->getPlayer()) {
		player->sendStats();
	}
	return true;
}

void ConditionRegeneration::endCondition(std::shared_ptr<Creature> creature) {
	if (const auto &player = creature->getPlayer()) {
		player->sendStats();
	}
}

void ConditionRegeneration::addCondition(std::shared_ptr<Creature> creature, const std::shared_ptr<Condition> addCondition) {
	if (updateCondition(addCondition)) {
		setTicks(addCondition->getTicks());

		const auto &conditionRegen = addCondition->static_self_cast<ConditionRegeneration>();

		healthTicks = conditionRegen->healthTicks;
		manaTicks = conditionRegen->manaTicks;

		healthGain = conditionRegen->healthGain;
		manaGain = conditionRegen->manaGain;
	}

	if (const auto &player = creature->getPlayer()) {
		player->sendStats();
	}
}

bool ConditionRegeneration::unserializeProp(ConditionAttr_t attr, PropStream &propStream) {
	if (attr == CONDITIONATTR_HEALTHTICKS) {
		return propStream.read<uint32_t>(healthTicks);
	} else if (attr == CONDITIONATTR_HEALTHGAIN) {
		return propStream.read<uint32_t>(healthGain);
	} else if (attr == CONDITIONATTR_MANATICKS) {
		return propStream.read<uint32_t>(manaTicks);
	} else if (attr == CONDITIONATTR_MANAGAIN) {
		return propStream.read<uint32_t>(manaGain);
	}
	return Condition::unserializeProp(attr, propStream);
}

void ConditionRegeneration::serialize(PropWriteStream &propWriteStream) {
	Condition::serialize(propWriteStream);

	propWriteStream.write<uint8_t>(CONDITIONATTR_HEALTHTICKS);
	propWriteStream.write<uint32_t>(healthTicks);

	propWriteStream.write<uint8_t>(CONDITIONATTR_HEALTHGAIN);
	propWriteStream.write<uint32_t>(healthGain);

	propWriteStream.write<uint8_t>(CONDITIONATTR_MANATICKS);
	propWriteStream.write<uint32_t>(manaTicks);

	propWriteStream.write<uint8_t>(CONDITIONATTR_MANAGAIN);
	propWriteStream.write<uint32_t>(manaGain);
}

bool ConditionRegeneration::executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) {
	internalHealthTicks += interval;
	internalManaTicks += interval;
	const auto &player = creature->getPlayer();
	int32_t dailyStreak = 0;
	if (player) {
		auto optStreak = player->kv()->scoped("daily-reward")->get("streak");
		if (optStreak) {
			dailyStreak = static_cast<int32_t>(optStreak->getNumber());
		}
	}
	if (creature->getZoneType() != ZONE_PROTECTION || dailyStreak >= DAILY_REWARD_HP_REGENERATION) {
		if (internalHealthTicks >= getHealthTicks(creature)) {
			internalHealthTicks = 0;

			int32_t realHealthGain = creature->getHealth();
			if (creature->getZoneType() == ZONE_PROTECTION && dailyStreak >= DAILY_REWARD_DOUBLE_HP_REGENERATION) {
				creature->changeHealth(healthGain * 2); // Double regen from daily reward
			} else {
				creature->changeHealth(healthGain);
			}
			realHealthGain = creature->getHealth() - realHealthGain;

			if (isBuff && realHealthGain > 0) {
				if (player) {
					std::string healString = fmt::format("{} hitpoint{}.", realHealthGain, (realHealthGain != 1 ? "s" : ""));

					TextMessage message(MESSAGE_HEALED, "You were healed for " + healString);
					message.position = player->getPosition();
					message.primary.value = realHealthGain;
					message.primary.color = TEXTCOLOR_PASTELRED;
					player->sendTextMessage(message);

					auto spectators = Spectators().find<Player>(player->getPosition());
					spectators.erase(player);
					if (!spectators.empty()) {
						message.type = MESSAGE_HEALED_OTHERS;
						message.text = player->getName() + " was healed for " + healString;
						for (const auto &spectator : spectators) {
							spectator->getPlayer()->sendTextMessage(message);
						}
					}
				}
			}
		}
	}

	if (creature->getZoneType() != ZONE_PROTECTION || dailyStreak >= DAILY_REWARD_MP_REGENERATION) {
		if (internalManaTicks >= getManaTicks(creature)) {
			internalManaTicks = 0;
			if (creature->getZoneType() == ZONE_PROTECTION && dailyStreak >= DAILY_REWARD_DOUBLE_MP_REGENERATION) {
				creature->changeMana(manaGain * 2); // Double regen from daily reward
			} else {
				creature->changeMana(manaGain);
			}
		}
	}

	return ConditionGeneric::executeCondition(creature, interval);
}

bool ConditionRegeneration::setParam(ConditionParam_t param, int32_t value) {
	bool ret = ConditionGeneric::setParam(param, value);

	switch (param) {
		case CONDITION_PARAM_HEALTHGAIN:
			healthGain = value;
			return true;

		case CONDITION_PARAM_HEALTHTICKS:
			healthTicks = value;
			return true;

		case CONDITION_PARAM_MANAGAIN:
			manaGain = value;
			return true;

		case CONDITION_PARAM_MANATICKS:
			manaTicks = value;
			return true;

		default:
			return ret;
	}
}

uint32_t ConditionRegeneration::getHealthTicks(const std::shared_ptr<Creature> &creature) const {
	const auto &player = creature->getPlayer();

	if (player != nullptr && isBuff) {
		return healthTicks / g_configManager().getFloat(RATE_SPELL_COOLDOWN);
	}

	return healthTicks;
}

uint32_t ConditionRegeneration::getManaTicks(const std::shared_ptr<Creature> &creature) const {
	const auto &player = creature->getPlayer();

	if (player != nullptr && isBuff) {
		return manaTicks / g_configManager().getFloat(RATE_SPELL_COOLDOWN);
	}

	return manaTicks;
}

std::shared_ptr<Condition> ConditionRegeneration::clone() const {
	return std::make_shared<ConditionRegeneration>(*this);
}

/**
 *  ConditionManaShield
 */

ConditionManaShield::ConditionManaShield(ConditionId_t initId, ConditionType_t initType, int32_t iniTicks, bool initBuff, uint32_t initSubId) :
	Condition(initId, initType, iniTicks, initBuff, initSubId) { }

bool ConditionManaShield::startCondition(std::shared_ptr<Creature> creature) {
	if (!Condition::startCondition(creature)) {
		return false;
	}

	creature->setManaShield(manaShield);
	creature->setMaxManaShield(manaShield);

	if (const auto &player = creature->getPlayer()) {
		player->sendStats();
	}

	return true;
}

void ConditionManaShield::endCondition(std::shared_ptr<Creature> creature) {
	creature->setManaShield(0);
	creature->setMaxManaShield(0);
	if (const auto &player = creature->getPlayer()) {
		player->sendStats();
	}
}

void ConditionManaShield::addCondition(std::shared_ptr<Creature> creature, const std::shared_ptr<Condition> addCondition) {
	endCondition(creature);
	setTicks(addCondition->getTicks());

	const std::shared_ptr<ConditionManaShield> &conditionManaShield = addCondition->static_self_cast<ConditionManaShield>();

	manaShield = conditionManaShield->manaShield;
	creature->setManaShield(manaShield);
	creature->setMaxManaShield(manaShield);

	if (const auto &player = creature->getPlayer()) {
		player->sendStats();
	}
}

bool ConditionManaShield::unserializeProp(ConditionAttr_t attr, PropStream &propStream) {
	if (attr == CONDITIONATTR_MANASHIELD) {
		return propStream.read<uint32_t>(manaShield);
	}
	return Condition::unserializeProp(attr, propStream);
}

void ConditionManaShield::serialize(PropWriteStream &propWriteStream) {
	Condition::serialize(propWriteStream);

	propWriteStream.write<uint8_t>(CONDITIONATTR_MANASHIELD);
	propWriteStream.write<uint32_t>(manaShield);
}

bool ConditionManaShield::setParam(ConditionParam_t param, int32_t value) {
	bool ret = Condition::setParam(param, value);

	switch (param) {
		case CONDITION_PARAM_MANASHIELD:
			manaShield = value;
			return true;
		default:
			return ret;
	}
}

std::shared_ptr<Condition> ConditionManaShield::clone() const {
	return std::make_shared<ConditionManaShield>(*this);
}

std::unordered_set<PlayerIcon> ConditionManaShield::getIcons() const {
	auto icons = Condition::getIcons();
	if (manaShield != 0) {
		icons.insert(PlayerIcon::NewManaShield);
	} else {
		icons.insert(PlayerIcon::ManaShield);
	}
	return icons;
}

/**
 *  ConditionSoul
 */

ConditionSoul::ConditionSoul(ConditionId_t initId, ConditionType_t initType, int32_t iniTicks, bool initBuff, uint32_t initSubId) :
	ConditionGeneric(initId, initType, iniTicks, initBuff, initSubId) { }

void ConditionSoul::addCondition(std::shared_ptr<Creature>, const std::shared_ptr<Condition> addCondition) {
	if (updateCondition(addCondition)) {
		setTicks(addCondition->getTicks());

		const auto &conditionSoul = addCondition->static_self_cast<ConditionSoul>();

		soulTicks = conditionSoul->soulTicks;
		soulGain = conditionSoul->soulGain;
	}
}

bool ConditionSoul::unserializeProp(ConditionAttr_t attr, PropStream &propStream) {
	if (attr == CONDITIONATTR_SOULGAIN) {
		return propStream.read<uint32_t>(soulGain);
	} else if (attr == CONDITIONATTR_SOULTICKS) {
		return propStream.read<uint32_t>(soulTicks);
	}
	return Condition::unserializeProp(attr, propStream);
}

void ConditionSoul::serialize(PropWriteStream &propWriteStream) {
	Condition::serialize(propWriteStream);

	propWriteStream.write<uint8_t>(CONDITIONATTR_SOULGAIN);
	propWriteStream.write<uint32_t>(soulGain);

	propWriteStream.write<uint8_t>(CONDITIONATTR_SOULTICKS);
	propWriteStream.write<uint32_t>(soulTicks);
}

bool ConditionSoul::executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) {
	internalSoulTicks += interval;

	if (const auto &player = creature->getPlayer()) {
		if (player->getZoneType() != ZONE_PROTECTION) {
			if (internalSoulTicks >= soulTicks) {
				internalSoulTicks = 0;
				player->changeSoul(soulGain);
			}
		}
	}

	return ConditionGeneric::executeCondition(creature, interval);
}

bool ConditionSoul::setParam(ConditionParam_t param, int32_t value) {
	bool ret = ConditionGeneric::setParam(param, value);
	switch (param) {
		case CONDITION_PARAM_SOULGAIN:
			soulGain = value;
			return true;

		case CONDITION_PARAM_SOULTICKS:
			soulTicks = value;
			return true;

		default:
			return ret;
	}
}

std::shared_ptr<Condition> ConditionSoul::clone() const {
	return std::make_shared<ConditionSoul>(*this);
}

/**
 *  ConditionDamage
 */

bool ConditionDamage::setParam(ConditionParam_t param, int32_t value) {
	bool ret = Condition::setParam(param, value);

	switch (param) {
		case CONDITION_PARAM_OWNER:
			owner = value;
			return true;

		case CONDITION_PARAM_FORCEUPDATE:
			forceUpdate = (value != 0);
			return true;

		case CONDITION_PARAM_DELAYED:
			delayed = (value != 0);
			return true;

		case CONDITION_PARAM_MAXVALUE:
			maxDamage = std::abs(value);
			break;

		case CONDITION_PARAM_MINVALUE:
			minDamage = std::abs(value);
			break;

		case CONDITION_PARAM_STARTVALUE:
			startDamage = std::abs(value);
			break;

		case CONDITION_PARAM_TICKINTERVAL:
			tickInterval = std::abs(value);
			break;

		case CONDITION_PARAM_PERIODICDAMAGE:
			periodDamage = value;
			break;

		case CONDITION_PARAM_FIELD:
			field = (value != 0);
			break;

		default:
			return false;
	}

	return ret;
}

bool ConditionDamage::unserializeProp(ConditionAttr_t attr, PropStream &propStream) {
	if (attr == CONDITIONATTR_DELAYED) {
		uint8_t value;
		if (!propStream.read<uint8_t>(value)) {
			return false;
		}

		delayed = (value != 0);
		return true;
	} else if (attr == CONDITIONATTR_PERIODDAMAGE) {
		return propStream.read<int32_t>(periodDamage);
	} else if (attr == CONDITIONATTR_OWNER) {
		return propStream.skip(4);
	} else if (attr == CONDITIONATTR_INTERVALDATA) {
		IntervalInfo damageInfo {};
		if (!propStream.read<IntervalInfo>(damageInfo)) {
			return false;
		}

		damageList.emplace_back(damageInfo);
		if (ticks != -1) {
			setTicks(ticks + damageInfo.interval);
		}
		return true;
	}
	return Condition::unserializeProp(attr, propStream);
}

void ConditionDamage::serialize(PropWriteStream &propWriteStream) {
	Condition::serialize(propWriteStream);

	propWriteStream.write<uint8_t>(CONDITIONATTR_DELAYED);
	propWriteStream.write<uint8_t>(delayed);

	propWriteStream.write<uint8_t>(CONDITIONATTR_PERIODDAMAGE);
	propWriteStream.write<int32_t>(periodDamage);

	for (const IntervalInfo &intervalInfo : damageList) {
		propWriteStream.write<uint8_t>(CONDITIONATTR_INTERVALDATA);
		propWriteStream.write<IntervalInfo>(intervalInfo);
	}
}

bool ConditionDamage::updateCondition(const std::shared_ptr<Condition> &addCondition) {
	const auto &conditionDamage = addCondition->static_self_cast<ConditionDamage>();
	if (conditionDamage->doForceUpdate()) {
		return true;
	}

	if (ticks == -1 && conditionDamage->ticks > 0) {
		return false;
	}

	return conditionDamage->getTotalDamage() > getTotalDamage();
}

bool ConditionDamage::addDamage(int32_t rounds, int32_t time, int32_t value) {
	time = std::max<int32_t>(time, EVENT_CREATURE_THINK_INTERVAL);
	if (rounds == -1) {
		// periodic damage
		periodDamage = value;
		setParam(CONDITION_PARAM_TICKINTERVAL, time);
		setParam(CONDITION_PARAM_TICKS, -1);
		return true;
	}

	if (periodDamage > 0) {
		return false;
	}

	// rounds, time, damage
	for (int32_t i = 0; i < rounds; ++i) {
		IntervalInfo damageInfo {};
		damageInfo.interval = time;
		damageInfo.timeLeft = time;
		damageInfo.value = value;

		damageList.emplace_back(damageInfo);

		if (ticks != -1) {
			setTicks(ticks + damageInfo.interval);
		}
	}

	return true;
}

bool ConditionDamage::doForceUpdate() const {
	return forceUpdate;
}

bool ConditionDamage::init() {
	if (periodDamage != 0) {
		return true;
	}

	if (damageList.empty()) {
		setTicks(0);

		int32_t amount = uniform_random(minDamage, maxDamage);
		if (amount != 0) {
			if (startDamage > maxDamage) {
				startDamage = maxDamage;
			} else if (startDamage == 0) {
				startDamage = std::max<int32_t>(1, std::ceil(amount / 20.0));
			}

			std::list<int32_t> list;
			ConditionDamage::generateDamageList(amount, startDamage, list);
			for (int32_t value : list) {
				addDamage(1, tickInterval, -value);
			}
		}
	}
	return !damageList.empty();
}

bool ConditionDamage::startCondition(std::shared_ptr<Creature> creature) {
	if (!Condition::startCondition(creature)) {
		return false;
	}

	if (!init()) {
		return false;
	}

	if (!delayed) {
		int32_t damage;
		if (getNextDamage(damage)) {
			return doDamage(creature, damage);
		}
	}
	return true;
}

bool ConditionDamage::executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) {
	if (periodDamage != 0) {
		periodDamageTick += interval;

		if (periodDamageTick >= tickInterval) {
			periodDamageTick = 0;
			doDamage(creature, periodDamage);
		}
	} else if (!damageList.empty()) {
		IntervalInfo &damageInfo = damageList.front();

		bool bRemove = (ticks != -1);
		creature->onTickCondition(getType(), bRemove);
		damageInfo.timeLeft -= interval;

		if (damageInfo.timeLeft <= 0) {
			int32_t damage = damageInfo.value;

			if (bRemove) {
				damageList.pop_front();
			} else {
				damageInfo.timeLeft = damageInfo.interval;
			}

			doDamage(creature, damage);
		}

		if (!bRemove) {
			if (ticks > 0) {
				endTime += interval;
			}

			interval = 0;
		}
	}

	return Condition::executeCondition(creature, interval);
}

bool ConditionDamage::getNextDamage(int32_t &damage) {
	if (periodDamage != 0) {
		damage = periodDamage;
		return true;
	} else if (!damageList.empty()) {
		IntervalInfo &damageInfo = damageList.front();
		damage = damageInfo.value;
		if (ticks != -1) {
			damageList.pop_front();
		}
		return true;
	}
	return false;
}

bool ConditionDamage::doDamage(const std::shared_ptr<Creature> &creature, int32_t healthChange) const {
	// Only perform checks and assign attacker if owner is not 0, keeping a const reference to the shared_ptr
	const auto &attacker = (owner != 0) ? (g_game().getPlayerByGUID(owner) ? g_game().getPlayerByGUID(owner)->getCreature() : g_game().getCreatureByID(owner)) : nullptr;
	const auto &attackerPlayer = attacker ? attacker->getPlayer() : nullptr;
	if (creature->isSuppress(getType(), attackerPlayer != nullptr)) {
		return true;
	}

	CombatDamage damage;
	damage.origin = ORIGIN_CONDITION;
	damage.primary.value = healthChange;
	damage.primary.type = Combat::ConditionToDamageType(conditionType);

	if (field && creature->getPlayer() && attackerPlayer) {
		damage.primary.value = static_cast<int32_t>(std::round(damage.primary.value / 2.));
	}

	if (!creature->isAttackable() || Combat::canDoCombat(attacker, creature, damage.primary.type != COMBAT_HEALING) != RETURNVALUE_NOERROR) {
		if (!creature->isInGhostMode() && !creature->getNpc()) {
			g_game().addMagicEffect(creature->getPosition(), CONST_ME_POFF);
		}
		return false;
	}

	if (g_game().combatBlockHit(damage, attacker, creature, false, false, field)) {
		return false;
	}

	if (creature && tickSound != SoundEffect_t::SILENCE) {
		g_game().sendSingleSoundEffect(creature->getPosition(), tickSound, creature);
	}

	return g_game().combatChangeHealth(attacker, creature, damage);
}

void ConditionDamage::endCondition(std::shared_ptr<Creature>) {
	//
}

void ConditionDamage::addCondition(std::shared_ptr<Creature> creature, const std::shared_ptr<Condition> addCondition) {
	if (addCondition->getType() != conditionType) {
		return;
	}

	if (!updateCondition(addCondition)) {
		return;
	}

	const std::shared_ptr<ConditionDamage> &conditionDamage = addCondition->static_self_cast<ConditionDamage>();

	setTicks(addCondition->getTicks());
	owner = conditionDamage->owner;
	maxDamage = conditionDamage->maxDamage;
	minDamage = conditionDamage->minDamage;
	startDamage = conditionDamage->startDamage;
	tickInterval = conditionDamage->tickInterval;
	periodDamage = conditionDamage->periodDamage;
	int32_t nextTimeLeft = tickInterval;

	if (!damageList.empty()) {
		// save previous timeLeft
		IntervalInfo &damageInfo = damageList.front();
		nextTimeLeft = damageInfo.timeLeft;
		damageList.clear();
	}

	damageList = conditionDamage->damageList;

	if (init()) {
		if (!damageList.empty()) {
			// restore last timeLeft
			IntervalInfo &damageInfo = damageList.front();
			damageInfo.timeLeft = nextTimeLeft;
		}

		if (!delayed) {
			int32_t damage;
			if (getNextDamage(damage)) {
				doDamage(creature, damage);
			}
		}
	}
}

int32_t ConditionDamage::getTotalDamage() const {
	int32_t result;
	if (!damageList.empty()) {
		result = 0;
		for (const IntervalInfo &intervalInfo : damageList) {
			result += intervalInfo.value;
		}
	} else {
		result = minDamage + (maxDamage - minDamage) / 2;
	}
	return std::abs(result);
}

std::unordered_set<PlayerIcon> ConditionDamage::getIcons() const {
	auto icons = Condition::getIcons();
	switch (conditionType) {
		case CONDITION_FIRE:
			icons.insert(PlayerIcon::Burn);
			break;

		case CONDITION_ENERGY:
			icons.insert(PlayerIcon::Energy);
			break;

		case CONDITION_DROWN:
			icons.insert(PlayerIcon::Drowning);
			break;

		case CONDITION_POISON:
			icons.insert(PlayerIcon::Poison);
			break;

		case CONDITION_FREEZING:
			icons.insert(PlayerIcon::Freezing);
			break;

		case CONDITION_DAZZLED:
			icons.insert(PlayerIcon::Dazzled);
			break;

		case CONDITION_CURSED:
			icons.insert(PlayerIcon::Cursed);
			break;

		case CONDITION_BLEEDING:
			icons.insert(PlayerIcon::Bleeding);
			break;

		default:
			break;
	}
	return icons;
}

std::shared_ptr<Condition> ConditionDamage::clone() const {
	return std::make_shared<ConditionDamage>(*this);
}

ConditionDamage::ConditionDamage(ConditionId_t intiId, ConditionType_t initType, bool initBuff, uint32_t initSubId) :
	Condition(intiId, initType, 0, initBuff, initSubId) { }

void ConditionDamage::generateDamageList(int32_t amount, int32_t start, std::list<int32_t> &list) {
	amount = std::abs(amount);
	int32_t sum = 0;
	double x1, x2;

	for (int32_t i = start; i > 0; --i) {
		int32_t n = start + 1 - i;
		int32_t med = (n * amount) / start;

		do {
			sum += i;
			list.emplace_back(i);

			x1 = std::fabs(1.0 - ((static_cast<float>(sum)) + i) / med);
			x2 = std::fabs(1.0 - (static_cast<float>(sum) / med));
		} while (x1 < x2);
	}
}

/**
 *  ConditionFeared
 */
bool ConditionFeared::isStuck(const std::shared_ptr<Creature> &creature, Position pos) const {
	return std::ranges::all_of(m_directionsVector, [&](Direction dir) {
		return !canWalkTo(creature, pos, dir);
	});
}

bool ConditionFeared::getRandomDirection(const std::shared_ptr<Creature> &creature, Position pos) {
	static std::vector<Direction> directions {
		DIRECTION_NORTH,
		DIRECTION_NORTHEAST,
		DIRECTION_EAST,
		DIRECTION_SOUTHEAST,
		DIRECTION_SOUTH,
		DIRECTION_SOUTHWEST,
		DIRECTION_WEST,
		DIRECTION_NORTHWEST
	};

	std::ranges::shuffle(directions, getRandomGenerator());

	auto it = std::ranges::find_if(directions, [&](Direction dir) {
		return canWalkTo(creature, pos, dir);
	});

	if (it != directions.end()) {
		this->fleeIndx = static_cast<uint8_t>(*it);
		return true;
	}

	return false;
}

bool ConditionFeared::canWalkTo(const std::shared_ptr<Creature> &creature, Position pos, Direction moveDirection) const {
	pos = getNextPosition(moveDirection, pos);
	if (!creature) {
		g_logger().error("[{}] creature is nullptr", __FUNCTION__);
		return false;
	}

	auto tile = g_game().map.getTile(pos);
	if (tile && tile->getTopVisibleCreature(creature) == nullptr && tile->queryAdd(0, creature, 1, FLAG_PATHFINDING) == RETURNVALUE_NOERROR) {
		const auto &field = tile->getFieldItem();
		if (field && !field->isBlocking() && field->getDamage() != 0) {
			return false;
		}
		return true;
	}

	return false;
}

bool ConditionFeared::getFleeDirection(const std::shared_ptr<Creature> &creature) {
	Position creaturePos = creature->getPosition();

	int_fast32_t offx = Position::getOffsetX(creaturePos, fleeingFromPos);
	int_fast32_t offy = Position::getOffsetY(creaturePos, fleeingFromPos);

	// Discover where the monster is
	if (offx == 0 && offy == 0) {
		/*
		 *	Monster is on the same SQM of the player
		 *	Flee to Anywhere
		 */
		g_logger().debug("[ConditionsFeared::getFleeDirection] Monster is on top of player, flee randomly. {} {}", offx, offy);
		return getRandomDirection(creature, creaturePos);
	} else if (offx >= 1 && offy <= 0) {
		/*
		 *	Monster is on SW Region
		 *	Flee to N(0), NE(1) and E(2)
		 */
		g_logger().debug("[ConditionsFeared::getFleeDirection] Monster is on the SW region, flee to N, NE or E. {} {}", offx, offy);

		if (offy == 0) {
			this->fleeIndx = 2; // Starts at East
		} else {
			this->fleeIndx = 0; // Starts at North
		}

		return true;
	} else if (offx >= 0 && offy >= 1) {
		/*
		 *	Monster is on NW Region
		 *	Flee to E(2), SE(3) and S(4)
		 */
		g_logger().debug("[ConditionsFeared::getFleeDirection] Monster is on the NW region, flee to E, SE or S. {} {}", offx, offy);

		if (offx == 0) {
			this->fleeIndx = 4; // Starts at South
		} else {
			this->fleeIndx = 2; // Starts at East
		}

		return true;
	} else if (offx <= -1 && offy >= 0) {
		/*
		 *	Monster is on NE Region
		 *	Flee to S(4), SW(5) and W(6)
		 */
		g_logger().debug("[ConditionsFeared::getFleeDirection] Monster is on the NE region, flee to S, SW or W. {} {}", offx, offy);

		if (offy == 0) {
			this->fleeIndx = 6; // Starts at West
		} else {
			this->fleeIndx = 4; // Starts at South
		}

		return true;
	} else if (offx <= 0 && offy <= -1) {
		/*
		 *	Monster is on SE
		 *	Flee to W(6), NW(7) and N(0)
		 */
		g_logger().debug("[ConditionsFeared::getFleeDirection] Monster is on the SE region, flee to W, NW or N. {} {}", offx, offy);

		if (offx == 0) {
			this->fleeIndx = 0; // Starts at North
		} else {
			this->fleeIndx = 6; // Starts at West
		}

		return true;
	}

	g_logger().debug("[ConditionsFeared::getFleeDirection] Something went wrong. {} {}", offx, offy);
	return false;
}

bool ConditionFeared::getFleePath(const std::shared_ptr<Creature> &creature, const Position &pos, std::vector<Direction> &dirList) {
	const std::vector<uint8_t> walkSize { 15, 9, 3, 1 };
	bool found = false;
	std::ptrdiff_t found_size = 0;
	Position futurePos = pos;

	do {
		for (uint8_t wsize : walkSize) {
			g_logger().debug("[{}] Checking on index {} with walkSize of {}", __FUNCTION__, fleeIndx, wsize);

			if (fleeIndx == 8) { // Reset index if at the end of the loop
				fleeIndx = 0;
			}

			if (isStuck(creature, pos)) { // Check if it is possible to walk to any direction
				g_logger().debug("[{}] Can't walk to anywhere", __FUNCTION__);
				return false;
			}

			futurePos = pos; // Reset position to be the same as creature

			switch (m_directionsVector[fleeIndx]) {
				case DIRECTION_NORTH:
					futurePos.y += wsize;
					g_logger().debug("[{}] Trying to flee to NORTH to {} [{}]", __FUNCTION__, futurePos.toString(), wsize);
					break;

				case DIRECTION_NORTHEAST:
					futurePos.x += wsize;
					futurePos.y -= wsize;
					g_logger().debug("[{}] Trying to flee to NORTHEAST to {} [{}]", __FUNCTION__, futurePos.toString(), wsize);
					break;

				case DIRECTION_EAST:
					futurePos.x -= wsize;
					g_logger().debug("[{}] Trying to flee to EAST to {} [{}]", __FUNCTION__, futurePos.toString(), wsize);
					break;

				case DIRECTION_SOUTHEAST:
					futurePos.x -= wsize;
					futurePos.y += wsize;
					g_logger().debug("[{}] Trying to flee to SOUTHEAST to {} [{}]", __FUNCTION__, futurePos.toString(), wsize);
					break;

				case DIRECTION_SOUTH:
					futurePos.y += wsize;
					g_logger().debug("[{}] Trying to flee to SOUTH to {} [{}]", __FUNCTION__, futurePos.toString(), wsize);
					break;

				case DIRECTION_SOUTHWEST:
					futurePos.x += wsize;
					futurePos.y += wsize;
					g_logger().debug("[{}] Trying to flee to SOUTHWEST to {} [{}]", __FUNCTION__, futurePos.toString(), wsize);
					break;

				case DIRECTION_WEST:
					futurePos.x += wsize;
					g_logger().debug("[{}] Trying to flee to WEST to {} [{}]", __FUNCTION__, futurePos.toString(), wsize);
					break;

				case DIRECTION_NORTHWEST:
					futurePos.x += wsize;
					futurePos.y -= wsize;
					g_logger().debug("[{}] Trying to flee to NORTHWEST to {} [{}]", __FUNCTION__, futurePos.toString(), wsize);
					break;
				case DIRECTION_NONE:
					break;
			}

			found = creature->getPathTo(futurePos, dirList, 0, 30);
			found_size = std::distance(dirList.begin(), dirList.end());

			if (found && found_size > 0) {
				break;
			}
		}

		if (!found || found_size == 0) {
			this->fleeIndx += 1;
		}
	} while (!found && found_size == 0);

	g_logger().debug("[{}] Found Available path to {} with {} steps", __FUNCTION__, futurePos.toString(), found_size);
	return true;
}

bool ConditionFeared::setPositionParam(ConditionParam_t param, const Position &pos) {
	if (param == CONDITION_PARAM_CASTER_POSITION) {
		this->fleeingFromPos = pos;
		return true;
	}
	return false;
}

ConditionFeared::ConditionFeared(ConditionId_t intiId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId) :
	Condition(intiId, initType, initTicks, initBuff, initSubId) { }

bool ConditionFeared::startCondition(std::shared_ptr<Creature> creature) {
	g_logger().debug("[ConditionFeared::executeCondition] Condition started for {}", creature->getName());
	getFleeDirection(creature);
	g_logger().debug("[ConditionFeared::executeCondition] Flee from {}", fleeingFromPos.toString());
	return Condition::startCondition(creature);
}

bool ConditionFeared::executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) {
	Position currentPos = creature->getPosition();
	std::vector<Direction> listDir;

	g_logger().debug("[ConditionFeared::executeCondition] Executing condition, current position is {}", currentPos.toString());

	if (creature->getWalkSize() < 2) {
		if (fleeIndx == 99) {
			getFleeDirection(creature);
		}

		if (getFleePath(creature, currentPos, listDir)) {
			g_dispatcher().addEvent(
				[id = creature->getID(), listDir] {
					g_game().forcePlayerAutoWalk(id, listDir);
				},
				__FUNCTION__
			);

			g_logger().debug("[ConditionFeared::executeCondition] Walking Scheduled");
		}
	}

	return Condition::executeCondition(creature, interval);
}

void ConditionFeared::endCondition(std::shared_ptr<Creature> creature) {
	creature->stopEventWalk();
	/*
	 * After a player is feared there's a 10 seconds before they can can feared again.
	 */
	const auto &player = creature->getPlayer();
	if (player) {
		player->setImmuneFear();
	}
}

void ConditionFeared::addCondition(std::shared_ptr<Creature>, const std::shared_ptr<Condition> addCondition) {
	if (updateCondition(addCondition)) {
		setTicks(addCondition->getTicks());
	}
}

std::unordered_set<PlayerIcon> ConditionFeared::getIcons() const {
	auto icons = Condition::getIcons();

	icons.insert(PlayerIcon::Feared);
	return icons;
}

std::shared_ptr<Condition> ConditionFeared::clone() const {
	return std::make_shared<ConditionFeared>(*this);
}

/**
 *  ConditionSpeed
 */

void ConditionSpeed::setFormulaVars(float NewMina, float NewMinb, float NewMaxa, float NewMaxb) {
	this->mina = NewMina;
	this->minb = NewMinb;
	this->maxa = NewMaxa;
	this->maxb = NewMaxb;
}

void ConditionSpeed::getFormulaValues(int32_t var, int32_t &min, int32_t &max) const {
	int32_t difference = var - 40;
	min = mina * difference + minb;
	max = maxa * difference + maxb;
}

bool ConditionSpeed::setParam(ConditionParam_t param, int32_t value) {
	Condition::setParam(param, value);
	if (param != CONDITION_PARAM_SPEED) {
		return false;
	}

	speedDelta = value;

	if (value > 0) {
		conditionType = CONDITION_HASTE;
	} else {
		conditionType = CONDITION_PARALYZE;
	}
	return true;
}

bool ConditionSpeed::unserializeProp(ConditionAttr_t attr, PropStream &propStream) {
	if (attr == CONDITIONATTR_SPEEDDELTA) {
		return propStream.read<int32_t>(speedDelta);
	} else if (attr == CONDITIONATTR_FORMULA_MINA) {
		return propStream.read<float>(mina);
	} else if (attr == CONDITIONATTR_FORMULA_MINB) {
		return propStream.read<float>(minb);
	} else if (attr == CONDITIONATTR_FORMULA_MAXA) {
		return propStream.read<float>(maxa);
	} else if (attr == CONDITIONATTR_FORMULA_MAXB) {
		return propStream.read<float>(maxb);
	}
	return Condition::unserializeProp(attr, propStream);
}

void ConditionSpeed::serialize(PropWriteStream &propWriteStream) {
	Condition::serialize(propWriteStream);

	propWriteStream.write<uint8_t>(CONDITIONATTR_SPEEDDELTA);
	propWriteStream.write<int32_t>(speedDelta);

	propWriteStream.write<uint8_t>(CONDITIONATTR_FORMULA_MINA);
	propWriteStream.write<float>(mina);

	propWriteStream.write<uint8_t>(CONDITIONATTR_FORMULA_MINB);
	propWriteStream.write<float>(minb);

	propWriteStream.write<uint8_t>(CONDITIONATTR_FORMULA_MAXA);
	propWriteStream.write<float>(maxa);

	propWriteStream.write<uint8_t>(CONDITIONATTR_FORMULA_MAXB);
	propWriteStream.write<float>(maxb);
}

ConditionSpeed::ConditionSpeed(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId, int32_t initChangeSpeed) :
	Condition(initId, initType, initTicks, initBuff, initSubId), speedDelta(initChangeSpeed) { }

bool ConditionSpeed::startCondition(std::shared_ptr<Creature> creature) {
	if (!Condition::startCondition(creature)) {
		return false;
	}

	if (speedDelta == 0) {
		int32_t min;
		int32_t max;
		auto baseSpeed = creature->getBaseSpeed();
		getFormulaValues(baseSpeed, min, max);
		speedDelta = uniform_random(min, max) - baseSpeed;
		if (conditionType == CONDITION_PARALYZE && speedDelta < 40 - baseSpeed) {
			speedDelta = 40 - baseSpeed;
		}
	}

	g_game().changeSpeed(creature, speedDelta);
	return true;
}

bool ConditionSpeed::executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) {
	return Condition::executeCondition(creature, interval);
}

void ConditionSpeed::endCondition(std::shared_ptr<Creature> creature) {
	g_game().changeSpeed(creature, -speedDelta);
}

void ConditionSpeed::addCondition(std::shared_ptr<Creature> creature, const std::shared_ptr<Condition> addCondition) {
	if (conditionType != addCondition->getType()) {
		return;
	}

	if (ticks == -1 && addCondition->getTicks() > 0) {
		return;
	}

	setTicks(addCondition->getTicks());

	const auto &conditionSpeed = addCondition->static_self_cast<ConditionSpeed>();
	int32_t oldSpeedDelta = speedDelta;
	speedDelta = conditionSpeed->speedDelta;
	mina = conditionSpeed->mina;
	maxa = conditionSpeed->maxa;
	minb = conditionSpeed->minb;
	maxb = conditionSpeed->maxb;

	if (speedDelta == 0) {
		int32_t min;
		int32_t max;
		auto baseSpeed = creature->getBaseSpeed();
		getFormulaValues(baseSpeed, min, max);
		speedDelta = uniform_random(min, max) - baseSpeed;

		if (conditionType == CONDITION_PARALYZE && speedDelta < 40 - baseSpeed) {
			speedDelta = 40 - baseSpeed;
		}
	}

	int32_t newSpeedChange = (speedDelta - oldSpeedDelta);
	if (newSpeedChange != 0) {
		g_game().changeSpeed(creature, newSpeedChange);
	}
}

std::unordered_set<PlayerIcon> ConditionSpeed::getIcons() const {
	auto icons = Condition::getIcons();
	switch (conditionType) {
		case CONDITION_HASTE:
			icons.insert(PlayerIcon::Haste);
			break;

		case CONDITION_PARALYZE:
			icons.insert(PlayerIcon::Paralyze);
			break;

		default:
			break;
	}
	return icons;
}

std::shared_ptr<Condition> ConditionSpeed::clone() const {
	return std::make_shared<ConditionSpeed>(*this);
}

/**
 *  ConditionInvisible
 */

ConditionInvisible::ConditionInvisible(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId) :
	ConditionGeneric(initId, initType, initTicks, initBuff, initSubId) { }

bool ConditionInvisible::startCondition(std::shared_ptr<Creature> creature) {
	if (!Condition::startCondition(creature)) {
		return false;
	}

	g_game().internalCreatureChangeVisible(creature, false);
	return true;
}

void ConditionInvisible::endCondition(std::shared_ptr<Creature> creature) {
	if (!creature->isInvisible()) {
		g_game().internalCreatureChangeVisible(creature, true);
	}
}

std::shared_ptr<Condition> ConditionInvisible::clone() const {
	return std::make_shared<ConditionInvisible>(*this);
}

/**
 * ConditionOutfit
 */

void ConditionOutfit::setOutfit(const Outfit_t &newOutfit) {
	this->outfit = newOutfit;
}

void ConditionOutfit::setLazyMonsterOutfit(const std::string &monsterName) {
	this->monsterName = monsterName;
}

bool ConditionOutfit::unserializeProp(ConditionAttr_t attr, PropStream &propStream) {
	if (attr == CONDITIONATTR_OUTFIT) {
		return propStream.read<Outfit_t>(outfit);
	}
	return Condition::unserializeProp(attr, propStream);
}

void ConditionOutfit::serialize(PropWriteStream &propWriteStream) {
	Condition::serialize(propWriteStream);

	propWriteStream.write<uint8_t>(CONDITIONATTR_OUTFIT);
	propWriteStream.write<Outfit_t>(outfit);
}

ConditionOutfit::ConditionOutfit(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId) :
	Condition(initId, initType, initTicks, initBuff, initSubId) { }

bool ConditionOutfit::startCondition(std::shared_ptr<Creature> creature) {
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && outfit.lookType != 0 && !g_game().isLookTypeRegistered(outfit.lookType)) {
		g_logger().warn("[ConditionOutfit::startCondition] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", outfit.lookType);
		return false;
	}

	if ((outfit.lookType == 0 && outfit.lookTypeEx == 0) && !monsterName.empty()) {
		const auto &monsterType = g_monsters().getMonsterType(monsterName);
		if (monsterType) {
			setOutfit(monsterType->info.outfit);
		} else {
			g_logger().error("[ConditionOutfit::startCondition] Monster {} does not exist", monsterName);
			return false;
		}
	}

	if (!Condition::startCondition(creature)) {
		return false;
	}

	g_game().internalCreatureChangeOutfit(creature, outfit);
	return true;
}

bool ConditionOutfit::executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) {
	return Condition::executeCondition(creature, interval);
}

void ConditionOutfit::endCondition(std::shared_ptr<Creature> creature) {
	g_game().internalCreatureChangeOutfit(creature, creature->getDefaultOutfit());
}

void ConditionOutfit::addCondition(std::shared_ptr<Creature> creature, const std::shared_ptr<Condition> addCondition) {
	if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && outfit.lookType != 0 && !g_game().isLookTypeRegistered(outfit.lookType)) {
		g_logger().warn("[ConditionOutfit::addCondition] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", outfit.lookType);
		return;
	}

	if (updateCondition(addCondition)) {
		setTicks(addCondition->getTicks());

		const auto &conditionOutfit = addCondition->static_self_cast<ConditionOutfit>();
		if (!conditionOutfit->monsterName.empty() && conditionOutfit->monsterName != monsterName) {
			const auto &monsterType = g_monsters().getMonsterType(conditionOutfit->monsterName);
			if (monsterType) {
				setOutfit(monsterType->info.outfit);
			} else {
				g_logger().error("[ConditionOutfit::addCondition] - Monster {} does not exist", monsterName);
				return;
			}
		} else if (conditionOutfit->outfit.lookType != 0 || conditionOutfit->outfit.lookTypeEx != 0) {
			setOutfit(conditionOutfit->outfit);
		}

		g_game().internalCreatureChangeOutfit(creature, outfit);
	}
}

std::shared_ptr<Condition> ConditionOutfit::clone() const {
	return std::make_shared<ConditionOutfit>(*this);
}

/**
 *  ConditionLight
 */

ConditionLight::ConditionLight(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId, uint8_t initLightlevel, uint8_t initLightcolor) :
	Condition(initId, initType, initTicks, initBuff, initSubId), lightInfo(initLightlevel, initLightcolor) { }

bool ConditionLight::startCondition(std::shared_ptr<Creature> creature) {
	if (!Condition::startCondition(creature)) {
		return false;
	}

	internalLightTicks = 0;
	lightChangeInterval = ticks / lightInfo.level;
	creature->setCreatureLight(lightInfo);
	g_game().changeLight(creature);
	return true;
}

bool ConditionLight::executeCondition(const std::shared_ptr<Creature> &creature, int32_t interval) {
	internalLightTicks += interval;

	if (internalLightTicks >= lightChangeInterval) {
		internalLightTicks = 0;
		LightInfo creatureLightInfo = creature->getCreatureLight();

		if (creatureLightInfo.level > 0) {
			--creatureLightInfo.level;
			creature->setCreatureLight(creatureLightInfo);
			g_game().changeLight(creature);
		}
	}

	return Condition::executeCondition(creature, interval);
}

void ConditionLight::endCondition(std::shared_ptr<Creature> creature) {
	creature->setNormalCreatureLight();
	g_game().changeLight(creature);
}

void ConditionLight::addCondition(std::shared_ptr<Creature> creature, const std::shared_ptr<Condition> condition) {
	if (updateCondition(condition)) {
		setTicks(condition->getTicks());

		const auto &conditionLight = condition->static_self_cast<ConditionLight>();
		lightInfo.level = conditionLight->lightInfo.level;
		lightInfo.color = conditionLight->lightInfo.color;
		lightChangeInterval = ticks / std::max<uint8_t>(1, lightInfo.level);
		internalLightTicks = 0;
		creature->setCreatureLight(lightInfo);
		g_game().changeLight(creature);
	}
}

std::shared_ptr<Condition> ConditionLight::clone() const {
	return std::make_shared<ConditionLight>(*this);
}

bool ConditionLight::setParam(ConditionParam_t param, int32_t value) {
	bool ret = Condition::setParam(param, value);
	if (ret) {
		return false;
	}

	switch (param) {
		case CONDITION_PARAM_LIGHT_LEVEL: {
			if (value < 1) {
				g_logger().warn("[ConditionLight::setParam] Trying to set invalid light value: '{}', defaulting to 1.", value);
			}
			lightInfo.level = std::max<uint8_t>(1, static_cast<uint8_t>(value));
			return true;
		}

		case CONDITION_PARAM_LIGHT_COLOR:
			lightInfo.color = value;
			return true;

		default:
			return false;
	}
}

bool ConditionLight::unserializeProp(ConditionAttr_t attr, PropStream &propStream) {
	if (attr == CONDITIONATTR_LIGHTCOLOR) {
		uint32_t value;
		if (!propStream.read<uint32_t>(value)) {
			return false;
		}

		lightInfo.color = value;
		return true;
	} else if (attr == CONDITIONATTR_LIGHTLEVEL) {
		uint32_t value;
		if (!propStream.read<uint32_t>(value)) {
			return false;
		}

		lightInfo.level = value;
		return true;
	} else if (attr == CONDITIONATTR_LIGHTTICKS) {
		return propStream.read<uint32_t>(internalLightTicks);
	} else if (attr == CONDITIONATTR_LIGHTINTERVAL) {
		return propStream.read<uint32_t>(lightChangeInterval);
	}
	return Condition::unserializeProp(attr, propStream);
}

void ConditionLight::serialize(PropWriteStream &propWriteStream) {
	Condition::serialize(propWriteStream);

	// TODO: color and level could be serialized as 8-bit if we can retain backwards
	// compatibility, but perhaps we should keep it like this in case they increase
	// in the future...
	propWriteStream.write<uint8_t>(CONDITIONATTR_LIGHTCOLOR);
	propWriteStream.write<uint32_t>(lightInfo.color);

	propWriteStream.write<uint8_t>(CONDITIONATTR_LIGHTLEVEL);
	propWriteStream.write<uint32_t>(lightInfo.level);

	propWriteStream.write<uint8_t>(CONDITIONATTR_LIGHTTICKS);
	propWriteStream.write<uint32_t>(internalLightTicks);

	propWriteStream.write<uint8_t>(CONDITIONATTR_LIGHTINTERVAL);
	propWriteStream.write<uint32_t>(lightChangeInterval);
}

/**
 *  ConditionSpellCooldown
 */

void ConditionSpellCooldown::addCondition(std::shared_ptr<Creature> creature, const std::shared_ptr<Condition> addCondition) {
	if (updateCondition(addCondition)) {
		setTicks(addCondition->getTicks());

		if (subId != 0 && ticks > 0) {
			const auto &player = creature->getPlayer();
			if (player) {
				player->sendSpellCooldown(subId, ticks);
			}
		}
	}
}

std::shared_ptr<Condition> ConditionSpellCooldown::clone() const {
	return std::make_shared<ConditionSpellCooldown>(*this);
}

ConditionSpellCooldown::ConditionSpellCooldown(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId) :
	ConditionGeneric(initId, initType, initTicks, initBuff, initSubId) { }

bool ConditionSpellCooldown::startCondition(std::shared_ptr<Creature> creature) {
	if (!Condition::startCondition(creature)) {
		return false;
	}

	if (subId != 0 && ticks > 0) {
		const auto &player = creature->getPlayer();
		if (player) {
			player->sendSpellCooldown(subId, ticks);
		}
	}
	return true;
}

/**
 *  ConditionSpellGroupCooldown
 */

void ConditionSpellGroupCooldown::addCondition(std::shared_ptr<Creature> creature, const std::shared_ptr<Condition> addCondition) {
	if (updateCondition(addCondition)) {
		setTicks(addCondition->getTicks());

		if (subId != 0 && ticks > 0) {
			const auto &player = creature->getPlayer();
			if (player) {
				player->sendSpellGroupCooldown(static_cast<SpellGroup_t>(subId), ticks);
			}
		}
	}
}

std::shared_ptr<Condition> ConditionSpellGroupCooldown::clone() const {
	return std::make_shared<ConditionSpellGroupCooldown>(*this);
}

ConditionSpellGroupCooldown::ConditionSpellGroupCooldown(ConditionId_t initId, ConditionType_t initType, int32_t initTicks, bool initBuff, uint32_t initSubId) :
	ConditionGeneric(initId, initType, initTicks, initBuff, initSubId) { }

bool ConditionSpellGroupCooldown::startCondition(std::shared_ptr<Creature> creature) {
	if (!Condition::startCondition(creature)) {
		return false;
	}

	if (subId != 0 && ticks > 0) {
		const auto &player = creature->getPlayer();
		if (player) {
			player->sendSpellGroupCooldown(static_cast<SpellGroup_t>(subId), ticks);
		}
	}
	return true;
}
