/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
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
#include "creatures/players/imbuements/imbuements.h"
#include "lua/creature/events.h"
#include "utils/pugicast.h"

Imbuement* Imbuements::getImbuement(uint16_t id)
{
	if (id == 0) {
		return nullptr;
	}

	auto it = imbuementMap.find(id);
	if (it == imbuementMap.end()) {
		SPDLOG_WARN("Imbuement {} not found", id);
		return nullptr;
	}
	return &it->second;
}

bool Imbuements::loadFromXml(bool /* reloading */) {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY) + "/XML/imbuements.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return  false;
	}

	loaded = true;
	for (auto baseNode : doc.child("imbuements").children()) {
		pugi::xml_attribute attr;
		// Base for imbue
		if (strcasecmp(baseNode.name(), "base") == 0) {
			pugi::xml_attribute id = baseNode.attribute("id");
			if (!id) {
				SPDLOG_WARN("Missing id for base entry");
				continue;
			}
			basesImbuement.emplace_back(
				pugi::cast<uint16_t>(id.value()),
				baseNode.attribute("name").as_string(),
				pugi::cast<uint32_t>(baseNode.attribute("price").value()),
				pugi::cast<uint32_t>(baseNode.attribute("protectionPrice").value()),
				pugi::cast<uint32_t>(baseNode.attribute("removecost").value()),
				pugi::cast<int32_t>(baseNode.attribute("duration").value()),
				pugi::cast<uint16_t>(baseNode.attribute("percent").value())

			);

		// Category/Group
		} else if (strcasecmp(baseNode.name(), "category") == 0) {
			pugi::xml_attribute id = baseNode.attribute("id");
			if (!id) {
				SPDLOG_WARN("Missing id for category entry");
				continue;
			}
			categoriesImbuement.emplace_back(
				pugi::cast<uint16_t>(id.value()),
				baseNode.attribute("name").as_string(),
				baseNode.attribute("agressive").as_bool(true)
			);

		// Imbuements
		} else if (strcasecmp(baseNode.name(), "imbuement") == 0) {
			++runningid;
			pugi::xml_attribute base = baseNode.attribute("base");
			if (!base) {
				SPDLOG_WARN("Missing imbuement base id");
				continue;
			}

			uint16_t baseid = pugi::cast<uint32_t>(base.value());
			auto groupBase = getBaseByID(baseid);
			if (groupBase == nullptr) {
				SPDLOG_WARN("Group base '{}' not exist", baseid);
				continue;
			}

			auto imbuements = imbuementMap.emplace(std::piecewise_construct,
				std::forward_as_tuple(runningid),
				std::forward_as_tuple(runningid, baseid));

			if (!imbuements.second) {
				SPDLOG_WARN("Duplicate imbuement of Base ID: '{}' ignored", baseid);
				continue;
			}

			Imbuement& imbuement = imbuements.first->second;

			pugi::xml_attribute iconBase = baseNode.attribute("iconid");
			if (!iconBase) {
				SPDLOG_WARN("Missing 'iconid' for imbuement entry");
				continue;
			}
			imbuement.icon = pugi::cast<uint16_t>(iconBase.value());

			pugi::xml_attribute soundBase = baseNode.attribute("sound");
			if (soundBase) {
				imbuement.soundEffect = static_cast<SoundEffect_t>(pugi::cast<uint16_t>(soundBase.value()));
			}

			pugi::xml_attribute premiumBase = baseNode.attribute("premium");
			if (premiumBase) {
				imbuement.premium = premiumBase.as_bool();
			}

			if (pugi::xml_attribute storageBase = baseNode.attribute("storage")) {
				imbuement.storage = pugi::cast<uint32_t>(storageBase.value());
			}

			pugi::xml_attribute subgroupBase = baseNode.attribute("subgroup");
			if (subgroupBase) {
				imbuement.subgroup = subgroupBase.as_string();
			}

			pugi::xml_attribute categorybase = baseNode.attribute("category");
			if (!categorybase) {
				SPDLOG_WARN("Missing imbuement category");
				continue;
			}

			uint16_t category = pugi::cast<uint16_t>(categorybase.value());
			auto category_p = getCategoryByID(category);
			if (category_p == nullptr) {
				SPDLOG_WARN("Category imbuement {} not exist", category);
				continue;
			}

			imbuement.category = category;

			pugi::xml_attribute nameBase = baseNode.attribute("name");
			if (!nameBase) {
				SPDLOG_WARN("Missing imbuement name");
				continue;
			}
			imbuement.name = nameBase.value();

			for (auto childNode : baseNode.children()) {
				if (!(attr = childNode.attribute("key"))) {
					SPDLOG_WARN("Missing key attribute in imbuement id: {}", runningid);
					continue;
				}

				std::string type = attr.as_string();
				if (strcasecmp(type.c_str(), "item") == 0) {
					if (!(attr = childNode.attribute("value"))) {
						SPDLOG_WARN("Missing item ID for imbuement name '{}'", imbuement.name);
						continue;
					}
					uint16_t sourceId = pugi::cast<uint16_t>(attr.value());

					uint16_t count = 1;
					if ((attr = childNode.attribute("count"))) {
						count = pugi::cast<uint16_t>(childNode.attribute("count").value());
					}

					auto it2 = std::find_if(imbuement.items.begin(), imbuement.items.end(), [sourceId](const std::pair<uint16_t, uint16_t>& source) -> bool {
						return source.first == sourceId;
					});

					if (it2 != imbuement.items.end()) {
						SPDLOG_WARN("Duplicate item: {}, imbument name: {} ignored",
													childNode.attribute("value").value(), imbuement.name);
						continue;
					}

					imbuement.items.emplace_back(sourceId, count);

				} else if  (strcasecmp(type.c_str(), "description") == 0) {
					std::string description = imbuement.name;
					if ((attr = childNode.attribute("value"))) {
						description = attr.as_string();
					}

					imbuement.description = description;
				} else if  (strcasecmp(type.c_str(), "effect") == 0) {
					// Effects
					if (!(attr = childNode.attribute("type"))) {
						SPDLOG_WARN("Missing effect type for imbuement name: {}", imbuement.name);
						continue;
					}

					std::string effecttype = attr.as_string();

					if (strcasecmp(effecttype.c_str(), "skill") == 0) {
						if (!(attr = childNode.attribute("value"))) {
							SPDLOG_WARN("Missing effect value for imbuement name {}", imbuement.name);
							continue;
						}

						uint8_t usenormalskill = 1; // 1 = skill normal, 2 = magiclevel, 3 = leechs/crit

						uint8_t skillId;
						std::string tmpStrValue = asLowerCaseString(attr.as_string());
						if (tmpStrValue == "sword") {
							skillId = SKILL_SWORD;
						} else if (tmpStrValue == "axe") {
							skillId = SKILL_AXE;
						} else if (tmpStrValue == "club") {
							skillId = SKILL_CLUB;
						} else if ((tmpStrValue == "dist") || (tmpStrValue == "distance")) {
							skillId = SKILL_DISTANCE;
						} else if (tmpStrValue == "fish") {
							skillId = SKILL_FISHING;
						} else if (tmpStrValue == "shield") {
							skillId = SKILL_SHIELD;
						} else if (tmpStrValue == "fist") {
							skillId = SKILL_FIST;
						} else if (tmpStrValue == "magicpoints") {
							skillId = STAT_MAGICPOINTS;
							usenormalskill = 2;
						} else if (tmpStrValue == "critical") {
							usenormalskill = 3;
							skillId = SKILL_CRITICAL_HIT_DAMAGE;
						} else if (tmpStrValue == "lifeleech") {
							usenormalskill = 3;
							skillId = SKILL_LIFE_LEECH_AMOUNT;
						} else if (tmpStrValue == "manaleech") {
							usenormalskill = 3;
							skillId = SKILL_MANA_LEECH_AMOUNT;
						} else {
							SPDLOG_WARN("Unknow skill name {} in imbuement name {}",
								tmpStrValue, imbuement.name);
							continue;
						}

						if (!(attr = childNode.attribute("bonus"))) {
							SPDLOG_WARN("Missing skill bonus for imbuement name {}",
								imbuement.name);
							continue;
						}
						int32_t bonus = pugi::cast<int32_t>(attr.value());

						if (usenormalskill == 1) {
							imbuement.skills[skillId] = bonus;
						} else if (usenormalskill == 2) {
							imbuement.stats[skillId] = bonus;
						} else if (usenormalskill == 3) {
							imbuement.skills[skillId] = bonus;
							int32_t chance = 100;
							if ((attr = childNode.attribute("chance")))
								chance = std::min<uint32_t>(100, pugi::cast<int32_t>(attr.value()));

							imbuement.skills[skillId - 1] = chance;
						}
					} else if (strcasecmp(effecttype.c_str(), "damage") == 0) {
						if (!(attr = childNode.attribute("combat"))) {
							SPDLOG_WARN("Missing combat for imbuement name {}", imbuement.name);
							continue;
						}

						CombatType_t combatType = getCombatType(attr.as_string());
						if (combatType == COMBAT_NONE) {
							SPDLOG_WARN("Unknown combat type for element {}", attr.as_string());
							continue;
						}

						if (!(attr = childNode.attribute("value"))) {
							SPDLOG_WARN("Missing damage reduction percentage for imbuement name {}",
								imbuement.name);
							continue;
						}

						uint32_t percent = std::min<uint32_t>(100, pugi::cast<uint32_t>(attr.value()));

						imbuement.combatType = combatType;
						imbuement.elementDamage = std::min<int16_t>(100, percent);
					} else if (strcasecmp(effecttype.c_str(), "reduction") == 0) {
						if (!(attr = childNode.attribute("combat"))) {
							SPDLOG_WARN("Missing combat for imbuement name {}", imbuement.name);
							continue;
						}

						CombatType_t combatType = getCombatType(attr.as_string());
						if (combatType == COMBAT_NONE) {
							SPDLOG_WARN("Unknown combat type for element {}", attr.as_string());
							continue;
						}

						if (!(attr = childNode.attribute("value"))) {
							SPDLOG_WARN("Missing damage reduction percentage for imbuement name {}",
								imbuement.name);
							continue;
						}

						uint32_t percent = std::min<uint32_t>(100, pugi::cast<uint32_t>(attr.value()));

						imbuement.absorbPercent[combatTypeToIndex(combatType)] = percent;
					} else if (strcasecmp(effecttype.c_str(), "speed") == 0) {
						if (!(attr = childNode.attribute("value"))) {
							SPDLOG_WARN("Missing speed value for imbuement name {}", imbuement.name);
							continue;
						}

						imbuement.speed = pugi::cast<uint32_t>(attr.value());
					} else if (strcasecmp(effecttype.c_str(), "capacity") == 0) {
						if (!(attr = childNode.attribute("value"))) {
							SPDLOG_WARN("Missing cap value for imbuement name {}", imbuement.name);
							continue;
						}

						imbuement.capacity = pugi::cast<uint32_t>(attr.value());
					}
				}
			}
		}
	}

	return true;
}

bool Imbuements::reload() {
	imbuementMap.clear();
	basesImbuement.clear();
	categoriesImbuement.clear();

	runningid = 0;
	loaded = false;

	return loadFromXml(true);
}

BaseImbuement* Imbuements::getBaseByID(uint16_t id)
{
	auto baseImbuements = std::find_if(basesImbuement.begin(), basesImbuement.end(), [id](const BaseImbuement& groupImbuement) {
				return groupImbuement.id == id;
			});

	return baseImbuements != basesImbuement.end() ? &*baseImbuements : nullptr;
}

CategoryImbuement* Imbuements::getCategoryByID(uint16_t id)
{
	auto categoryImbuements = std::find_if(categoriesImbuement.begin(), categoriesImbuement.end(), [id](const CategoryImbuement& categoryImbuement) {
				return categoryImbuement.id == id;
			});

	return categoryImbuements != categoriesImbuement.end() ? &*categoryImbuements : nullptr;
}

std::vector<Imbuement*> Imbuements::getImbuements(const Player* player, Item* item)
{
	std::vector<Imbuement*> imbuements;

	for (auto& [key, value] : imbuementMap)
	{
		Imbuement* imbuement = &value;
		if (!imbuement) {
			continue;
		}

		// Parse the storages for each imbuement in imbuements.xml and config.lua (enable/disable storage)
		int32_t storageValue;
		if (g_configManager().getBoolean(TOGGLE_IMBUEMENT_SHRINE_STORAGE)
		&& imbuement->getStorage() != 0
		&& !player->getStorageValue(imbuement->getStorage(), storageValue)
		&& imbuement->getBaseID() >= 1 && imbuement->getBaseID() <= 3) {
			continue;
		}

		// Send only the imbuements registered on item (in items.xml) to the imbuement window
		const CategoryImbuement* categoryImbuement = getCategoryByID(imbuement->getCategory());
		if (!item->hasImbuementType(static_cast<ImbuementTypes_t>(categoryImbuement->id), imbuement->getBaseID())) {
			continue;
		}

		// If the item is already imbued with an imbuement, remove the imbuement from the next free slot
		if (item->hasImbuementCategoryId(categoryImbuement->id)) {
			continue;
		}

		imbuements.push_back(imbuement);
	}

	return imbuements;
}
