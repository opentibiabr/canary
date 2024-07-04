/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/players/vocations/vocation.hpp"

#include "utils/pugicast.hpp"
#include "utils/tools.hpp"

bool Vocations::reload() {
	vocationsMap.clear();
	return loadFromXml();
}

bool Vocations::loadFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY, __FUNCTION__) + "/XML/vocations.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (auto vocationNode : doc.child("vocations").children()) {
		pugi::xml_attribute attr;
		if (!(attr = vocationNode.attribute("id"))) {
			g_logger().warn("[{}] - Missing vocation id", __FUNCTION__);
			continue;
		}

		uint16_t id = pugi::cast<uint16_t>(attr.value());

		auto res = vocationsMap.emplace(std::piecewise_construct, std::forward_as_tuple(id), std::forward_as_tuple(std::make_shared<Vocation>(id)));
		auto voc = res.first->second;

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

		for (auto childNode : vocationNode.children()) {
			if (strcasecmp(childNode.name(), "skill") == 0) {
				pugi::xml_attribute skillIdAttribute = childNode.attribute("id");
				if (skillIdAttribute) {
					uint16_t skill_id = pugi::cast<uint16_t>(skillIdAttribute.value());
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
				auto name = nameAttr.as_string();
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

uint16_t Vocations::getVocationId(const std::string &name) const {
	for (const auto &it : vocationsMap) {
		if (strcasecmp(it.second->name.c_str(), name.c_str()) == 0) {
			return it.first;
		}
	}
	return -1;
}

uint16_t Vocations::getPromotedVocation(uint16_t vocationId) const {
	for (const auto &it : vocationsMap) {
		if (it.second->fromVocation == vocationId && it.first != vocationId) {
			return it.first;
		}
	}
	return VOCATION_NONE;
}

uint32_t Vocation::skillBase[SKILL_LAST + 1] = { 50, 50, 50, 50, 30, 100, 20 };
const uint16_t minSkillLevel = 10;

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

	uint64_t tries = static_cast<uint64_t>(skillBase[skill] * std::pow(static_cast<double>(skillMultipliers[skill]), level - (minSkillLevel + 1)));
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

	uint64_t reqMana = std::floor<uint64_t>(1600 * std::pow<double>(manaMultiplier, static_cast<int32_t>(magLevel) - 1));
	cacheMana[magLevel] = reqMana;
	return reqMana;
}

std::vector<WheelGemSupremeModifier_t> Vocation::getSupremeGemModifiers() {
	if (!m_supremeGemModifiers.empty()) {
		return m_supremeGemModifiers;
	}
	auto baseVocation = g_vocations().getVocation(getBaseId());
	auto vocationName = asLowerCaseString(baseVocation->getVocName());
	auto allModifiers = magic_enum::enum_entries<WheelGemSupremeModifier_t>();
	g_logger().debug("Loading supreme gem modifiers for vocation: {}", vocationName);
	for (const auto &[value, modifierName] : allModifiers) {
		std::string targetVocation(modifierName.substr(0, modifierName.find('_')));
		toLowerCaseString(targetVocation);
		g_logger().debug("Checking supreme gem modifier: {}, targetVocation: {}", modifierName, targetVocation);
		if (targetVocation == "general" || targetVocation.find(vocationName) != std::string::npos) {
			m_supremeGemModifiers.push_back(value);
		}
	}
	return m_supremeGemModifiers;
}
