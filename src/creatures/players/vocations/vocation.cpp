/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
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

#include "otpch.h"

#include "creatures/players/vocations/vocation.h"

#include "utils/tools.h"

bool Vocations::loadFromXml()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/vocations.xml");
	if (!result) {
		printXMLError("[Vocations::loadFromXml]", "data/XML/vocations.xml", result);
		return false;
	}

	for (auto vocationNode : doc.child("vocations").children()) {
		pugi::xml_attribute attr;
		if (attr = vocationNode.attribute("id");
		!attr || !isNumber(attr.as_string()))
		{
			SPDLOG_WARN("[Vocations::loadFromXml] - Missing or wrong vocation id");
			continue;
		}

		auto vocationId = static_cast<uint16_t>(attr.as_uint());

		auto [id, vocation] = vocationsMap.emplace(
			std::piecewise_construct,
			std::forward_as_tuple(vocationId),
			std::forward_as_tuple(vocationId)
		);

		Vocation& voc = id->second;
		if (attr = vocationNode.attribute("name");
		!attr || attr.empty())
		{
			SPDLOG_WARN("[Vocations::loadFromXml] - Missing or wrong vocation name for vocation id {}", vocationNode.attribute("id").as_string());
			continue;
		}
		voc.name = attr.as_string();

		if ((attr = vocationNode.attribute("clientid"))) {
			voc.clientId = static_cast<uint8_t>(attr.as_uint());
		}

		if ((attr = vocationNode.attribute("baseid"))) {
			voc.baseId = static_cast<uint8_t>(attr.as_uint());
		}
		
		if ((attr = vocationNode.attribute("description"))) {
			voc.description = attr.as_string();
		}

		if ((attr = vocationNode.attribute("magicshield"))) {
			voc.magicShield = attr.as_bool();
		}

		if ((attr = vocationNode.attribute("gaincap"))) {
			voc.gainCap = attr.as_uint() * 100;
		}

		if ((attr = vocationNode.attribute("gainhp"))) {
			voc.gainHP = attr.as_uint();
		}

		if ((attr = vocationNode.attribute("gainmana"))) {
			voc.gainMana = attr.as_uint();
		}

		if ((attr = vocationNode.attribute("gainhpticks"))) {
			voc.gainHealthTicks = attr.as_uint();
		}

		if ((attr = vocationNode.attribute("gainhpamount"))) {
			voc.gainHealthAmount = attr.as_uint();
		}

		if ((attr = vocationNode.attribute("gainmanaticks"))) {
			voc.gainManaTicks = attr.as_uint();
		}

		if ((attr = vocationNode.attribute("gainmanaamount"))) {
			voc.gainManaAmount = attr.as_uint();
		}

		if ((attr = vocationNode.attribute("manamultiplier"))) {
			voc.manaMultiplier = attr.as_float();
		}

		if ((attr = vocationNode.attribute("attackspeed"))) {
			voc.attackSpeed = attr.as_uint();
		}

		if ((attr = vocationNode.attribute("basespeed"))) {
			voc.baseSpeed = attr.as_uint();
		}

		if ((attr = vocationNode.attribute("soulmax"))) {
			voc.soulMax = static_cast<uint8_t>(attr.as_uint());
		}

		if ((attr = vocationNode.attribute("gainsoulticks"))) {
			voc.gainSoulTicks = attr.as_uint();
		}

		if ((attr = vocationNode.attribute("fromvoc"))) {
			voc.fromVocation = attr.as_uint();
		}

		for (auto childNode : vocationNode.children()) {
			if (strcasecmp(childNode.name(), "skill") == 0) {
				pugi::xml_attribute skillIdAttribute = childNode.attribute("id");
				if (skillIdAttribute) {
					auto skill_id = static_cast<uint16_t>(skillIdAttribute.as_uint());
					if (skill_id <= SKILL_LAST) {
						voc.skillMultipliers[skill_id] = childNode.attribute("multiplier").as_float();
					} else {
						SPDLOG_WARN("[Vocations::loadFromXml] - "
                                    "No valid skill id: {} for vocation: {}",
                                    skill_id, voc.id);
					}
				} else {
					SPDLOG_WARN("[Vocations::loadFromXml] - "
                                "Missing skill id for vocation: {}", voc.id);
				}
			} else if (strcasecmp(childNode.name(), "formula") == 0) {
				pugi::xml_attribute meleeDamageAttribute = childNode.attribute("meleeDamage");
				if (meleeDamageAttribute) {
					voc.meleeDamageMultiplier = meleeDamageAttribute.as_float();
				}

				pugi::xml_attribute distDamageAttribute = childNode.attribute("distDamage");
				if (distDamageAttribute) {
					voc.distDamageMultiplier = distDamageAttribute.as_float();
				}

				pugi::xml_attribute defenseAttribute = childNode.attribute("defense");
				if (defenseAttribute) {
					voc.defenseMultiplier = defenseAttribute.as_float();
				}

				pugi::xml_attribute armorAttribute = childNode.attribute("armor");
				if (armorAttribute) {
					voc.armorMultiplier = armorAttribute.as_float();
				}
			}
		}
	}
	return true;
}

Vocation* Vocations::getVocation(uint16_t id)
{
	auto it = vocationsMap.find(id);
	if (it == vocationsMap.end()) {
		SPDLOG_WARN("[Vocations::getVocation] - "
                    "Vocation {} not found", id);
		return nullptr;
	}
	return &it->second;
}

int32_t Vocations::getVocationId(const std::string& name) const
{
	for (const auto& it : vocationsMap) {
		if (strcasecmp(it.second.name.c_str(), name.c_str()) == 0) {
			return it.first;
		}
	}
	return -1;
}

uint16_t Vocations::getPromotedVocation(uint16_t vocationId) const
{
	for (const auto& it : vocationsMap) {
		if (it.second.fromVocation == vocationId && it.first != vocationId) {
			return it.first;
		}
	}
	return VOCATION_NONE;
}

uint32_t Vocation::skillBase[SKILL_LAST + 1] = {50, 50, 50, 50, 30, 100, 20};

uint64_t Vocation::getReqSkillTries(uint8_t skill, uint16_t level)
{
	if (skill > SKILL_LAST || level <= 10) {
		return 0;
	}

	auto it = cacheSkill[skill].find(level);
	if (it != cacheSkill[skill].end()) {
		return it->second;
	}

	uint64_t tries = static_cast<uint64_t>(skillBase[skill] * std::pow(static_cast<double>(skillMultipliers[skill]), level - 11));
	cacheSkill[skill][level] = tries;
	return tries;
}

uint64_t Vocation::getReqMana(uint32_t magLevel)
{
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
