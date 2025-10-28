/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/vocations/vocation.hpp"

#include "config/configmanager.hpp"
#include "items/item.hpp"
#include "lib/di/container.hpp"
#include "utils/pugicast.hpp"
#include "utils/tools.hpp"
#include "enums/player_wheel.hpp"

bool Vocations::reload() {
	vocationsMap.clear();
	return loadFromXml();
}

Vocations &Vocations::getInstance() {
	return inject<Vocations>();
}

bool Vocations::loadFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY) + "/XML/vocations.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (const auto &vocationNode : doc.child("vocations").children()) {
		pugi::xml_attribute attr;
		if (!((attr = vocationNode.attribute("id")))) {
			g_logger().warn("[{}] - Missing vocation id", __FUNCTION__);
			continue;
		}

		auto id = pugi::cast<uint16_t>(attr.value());

		auto [fst, snd] = vocationsMap.emplace(std::piecewise_construct, std::forward_as_tuple(id), std::forward_as_tuple(std::make_shared<Vocation>(id)));
		const auto voc = fst->second;

		if ((attr = vocationNode.attribute("name"))) {
			voc->name = attr.as_string();
		}

		if ((attr = vocationNode.attribute("clientid"))) {
			voc->clientId = pugi::cast<uint16_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("baseid"))) {
			voc->baseId = pugi::cast<uint16_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("description"))) {
			voc->description = attr.as_string();
		}

		if ((attr = vocationNode.attribute("magicshield"))) {
			voc->magicShield = attr.as_bool();
		}

		if ((attr = vocationNode.attribute("gaincap"))) {
			voc->gainCap = pugi::cast<uint32_t>(attr.value()) * 100;
		}

		if ((attr = vocationNode.attribute("gainhp"))) {
			voc->gainHP = pugi::cast<uint32_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("gainmana"))) {
			voc->gainMana = pugi::cast<uint32_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("gainhpticks"))) {
			voc->gainHealthTicks = pugi::cast<uint32_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("gainhpamount"))) {
			voc->gainHealthAmount = pugi::cast<uint32_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("gainmanaticks"))) {
			voc->gainManaTicks = pugi::cast<uint32_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("gainmanaamount"))) {
			voc->gainManaAmount = pugi::cast<uint32_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("manamultiplier"))) {
			voc->manaMultiplier = pugi::cast<float>(attr.value());
		}

		if ((attr = vocationNode.attribute("attackspeed"))) {
			voc->attackSpeed = pugi::cast<uint32_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("basespeed"))) {
			voc->baseSpeed = pugi::cast<uint32_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("soulmax"))) {
			voc->soulMax = pugi::cast<uint16_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("gainsoulticks"))) {
			voc->gainSoulTicks = pugi::cast<uint32_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("fromvoc"))) {
			voc->fromVocation = pugi::cast<uint32_t>(attr.value());
		}

		if ((attr = vocationNode.attribute("canCombat"))) {
			voc->combat = attr.as_bool();
		}

		if ((attr = vocationNode.attribute("avatarlooktype"))) {
			voc->avatarLookType = pugi::cast<uint16_t>(attr.value());
		}

		for (const auto &childNode : vocationNode.children()) {
			if (strcasecmp(childNode.name(), "skill") == 0) {
				pugi::xml_attribute skillIdAttribute = childNode.attribute("id");
				if (skillIdAttribute) {
					auto skill_id = pugi::cast<uint16_t>(skillIdAttribute.value());
					if (skill_id <= SKILL_LAST) {
						voc->skillMultipliers[skill_id] = pugi::cast<float>(childNode.attribute("multiplier").value());
					} else {
						g_logger().warn("[Vocations::loadFromXml] - "
						                "No valid skill id: {} for vocation: {}",
						                skill_id, voc->id);
					}
				} else {
					g_logger().warn("[Vocations::loadFromXml] - "
					                "Missing skill id for vocation: {}",
					                voc->id);
				}
			} else if (strcasecmp(childNode.name(), "mitigation") == 0) {
				pugi::xml_attribute factorAttribute = childNode.attribute("multiplier");
				if (factorAttribute) {
					voc->mitigationFactor = pugi::cast<float>(factorAttribute.value());
				}

				pugi::xml_attribute primaryShieldAttribute = childNode.attribute("primaryShield");
				if (primaryShieldAttribute) {
					voc->mitigationPrimaryShield = pugi::cast<float>(primaryShieldAttribute.value());
				}

				pugi::xml_attribute secondaryShieldAttribute = childNode.attribute("secondaryShield");
				if (secondaryShieldAttribute) {
					voc->mitigationSecondaryShield = pugi::cast<float>(secondaryShieldAttribute.value());
				}
			} else if (strcasecmp(childNode.name(), "formula") == 0) {
				pugi::xml_attribute meleeDamageAttribute = childNode.attribute("meleeDamage");
				if (meleeDamageAttribute) {
					voc->meleeDamageMultiplier = pugi::cast<float>(meleeDamageAttribute.value());
				}

				pugi::xml_attribute distDamageAttribute = childNode.attribute("distDamage");
				if (distDamageAttribute) {
					voc->distDamageMultiplier = pugi::cast<float>(distDamageAttribute.value());
				}

				pugi::xml_attribute defenseAttribute = childNode.attribute("defense");
				if (defenseAttribute) {
					voc->defenseMultiplier = pugi::cast<float>(defenseAttribute.value());
				}

				pugi::xml_attribute armorAttribute = childNode.attribute("armor");
				if (armorAttribute) {
					voc->armorMultiplier = pugi::cast<float>(armorAttribute.value());
				}
			} else if (strcasecmp(childNode.name(), "pvp") == 0) {
				pugi::xml_attribute pvpDamageReceivedMultiplier = childNode.attribute("damageReceivedMultiplier");
				if (pvpDamageReceivedMultiplier) {
					voc->pvpDamageReceivedMultiplier = pugi::cast<float>(pvpDamageReceivedMultiplier.value());
				}

				pugi::xml_attribute pvpDamageDealtMultiplier = childNode.attribute("damageDealtMultiplier");
				if (pvpDamageDealtMultiplier) {
					voc->pvpDamageDealtMultiplier = pugi::cast<float>(pvpDamageDealtMultiplier.value());
				}
			} else if (strcasecmp(childNode.name(), "gem") == 0) {
				pugi::xml_attribute qualityAttr = childNode.attribute("quality");
				pugi::xml_attribute nameAttr = childNode.attribute("name");
				auto quality = pugi::cast<uint8_t>(qualityAttr.value());
				const auto name = nameAttr.as_string();
				voc->wheelGems[static_cast<WheelGemQuality_t>(quality)] = name;
			}
		}
	}
	return true;
}

std::shared_ptr<Vocation> Vocations::getVocation(uint16_t id) {
	auto it = vocationsMap.find(id);
	if (it == vocationsMap.end()) {
		g_logger().warn("[Vocations::getVocation] - "
		                "Vocation {} not found",
		                id);
		return nullptr;
	}
	return it->second;
}

const std::map<uint16_t, std::shared_ptr<Vocation>> &Vocations::getVocations() const {
	return vocationsMap;
}

uint16_t Vocations::getVocationId(const std::string &name) const {
	for (const auto &[vocationId, vocationPtr] : vocationsMap) {
		if (caseInsensitiveCompare(vocationPtr->name, name)) {
			return vocationId;
		}
	}
	return VOCATION_NONE;
}

uint16_t Vocations::getPromotedVocation(uint16_t vocationId) const {
	for (const auto &[currentVocationId, vocationPtr] : vocationsMap) {
		if (vocationPtr->fromVocation == vocationId && currentVocationId != vocationId) {
			return currentVocationId;
		}
	}
	return VOCATION_NONE;
}

uint32_t Vocation::skillBase[SKILL_LAST + 1] = { 50, 50, 50, 50, 30, 100, 20 };
constexpr uint16_t minSkillLevel = 10;

const std::string &Vocation::getVocName() const {
	return name;
}

const std::string &Vocation::getVocDescription() const {
	return description;
}

absl::uint128 Vocation::getTotalSkillTries(uint8_t skill, uint16_t level) {
	if (skill > SKILL_LAST) {
		return 0;
	}

	auto it = cacheSkillTotal[skill].find(level);
	if (it != cacheSkillTotal[skill].end()) {
		return it->second;
	}

	absl::uint128 totalTries = 0;
	for (uint16_t i = minSkillLevel; i <= level; ++i) {
		totalTries += getReqSkillTries(skill, i);
	}
	cacheSkillTotal[skill][level] = totalTries;
	return totalTries;
}

uint64_t Vocation::getReqSkillTries(uint8_t skill, uint16_t level) {
	if (skill > SKILL_LAST || level <= minSkillLevel) {
		return 0;
	}

	auto it = cacheSkill[skill].find(level);
	if (it != cacheSkill[skill].end()) {
		return it->second;
	}

	const auto tries = static_cast<uint64_t>(skillBase[skill] * std::pow(static_cast<double>(skillMultipliers[skill]), level - (minSkillLevel + 1)));
	cacheSkill[skill][level] = tries;
	return tries;
}

absl::uint128 Vocation::getTotalMana(uint32_t magLevel) {
	if (magLevel == 0) {
		return 0;
	}
	auto it = cacheManaTotal.find(magLevel);
	if (it != cacheManaTotal.end()) {
		return it->second;
	}
	absl::uint128 totalMana = 0;
	for (uint32_t i = 1; i <= magLevel; ++i) {
		totalMana += getReqMana(i);
	}
	return totalMana;
}

uint64_t Vocation::getReqMana(uint32_t magLevel) {
	if (magLevel == 0) {
		return 0;
	}
	auto it = cacheMana.find(magLevel);
	if (it != cacheMana.end()) {
		return it->second;
	}

	const uint64_t reqMana = std::floor<uint64_t>(1600 * std::pow<double>(manaMultiplier, static_cast<int32_t>(magLevel) - 1));
	cacheMana[magLevel] = reqMana;
	return reqMana;
}

uint16_t Vocation::getId() const {
	return id;
}

uint8_t Vocation::getClientId() const {
	return clientId;
}

uint8_t Vocation::getBaseId() const {
	return baseId;
}

uint16_t Vocation::getAvatarLookType() const {
	return avatarLookType;
}

uint32_t Vocation::getHPGain() const {
	return gainHP;
}

uint32_t Vocation::getManaGain() const {
	return gainMana;
}

uint32_t Vocation::getCapGain() const {
	return gainCap;
}

uint32_t Vocation::getManaGainTicks() const {
	return gainManaTicks / g_configManager().getFloat(RATE_MANA_REGEN_SPEED);
}

uint32_t Vocation::getManaGainAmount() const {
	return gainManaAmount * g_configManager().getFloat(RATE_MANA_REGEN);
}

uint32_t Vocation::getHealthGainTicks() const {
	return gainHealthTicks / g_configManager().getFloat(RATE_HEALTH_REGEN_SPEED);
}

uint32_t Vocation::getHealthGainAmount() const {
	return gainHealthAmount * g_configManager().getFloat(RATE_HEALTH_REGEN);
}

uint8_t Vocation::getSoulMax() const {
	return soulMax;
}

uint32_t Vocation::getSoulGainTicks() const {
	return gainSoulTicks / g_configManager().getFloat(RATE_SOUL_REGEN_SPEED);
}

uint32_t Vocation::getBaseAttackSpeed() const {
	return attackSpeed;
}

uint32_t Vocation::getAttackSpeed() const {
	return attackSpeed / g_configManager().getFloat(RATE_ATTACK_SPEED);
}

uint32_t Vocation::getBaseSpeed() const {
	return baseSpeed;
}

uint32_t Vocation::getFromVocation() const {
	return fromVocation;
}

bool Vocation::getMagicShield() const {
	return magicShield;
}

bool Vocation::canCombat() const {
	return combat;
}

std::vector<WheelGemSupremeModifier_t> Vocation::getSupremeGemModifiers() {
	if (!m_supremeGemModifiers.empty()) {
		return m_supremeGemModifiers;
	}
	const auto baseVocation = g_vocations().getVocation(getFromVocation());
	auto vocationName = asLowerCaseString(baseVocation->getVocName());
	auto allModifiers = magic_enum::enum_entries<WheelGemSupremeModifier_t>();
	g_logger().debug("Loading supreme gem modifiers for vocation: {}", vocationName);

	for (const auto &[value, modifierName] : allModifiers) {
		std::string targetVocation(modifierName.substr(0, modifierName.find('_')));
		toLowerCaseString(targetVocation);
		g_logger().debug("Checking supreme gem modifier: {}, targetVocation: {}", modifierName, targetVocation);
		if (targetVocation == "general" || targetVocation.find(vocationName) != std::string::npos) {
			m_supremeGemModifiers.emplace_back(value);
		}
	}
	return m_supremeGemModifiers;
}

uint16_t Vocation::getWheelGemId(WheelGemQuality_t quality) {
	if (!wheelGems.contains(quality)) {
		return 0;
	}
	const auto &gemName = wheelGems[quality];
	return Item::items.getItemIdByName(gemName);
}
