/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"
#include "creatures/players/imbuements/imbuements.hpp"
#include "lua/creature/events.hpp"
#include "utils/pugicast.hpp"

static const std::unordered_map<std::string, uint8_t> skillMap = {
	{"sword", SKILL_SWORD},
	{"axe", SKILL_AXE},
	{"club", SKILL_CLUB},
	{"dist", SKILL_DISTANCE},
	{"distance", SKILL_DISTANCE},
	{"fish", SKILL_FISHING},
	{"shield", SKILL_SHIELD},
	{"fist", SKILL_FIST},
	{"magicpoints", STAT_MAGICPOINTS},
	{"critical", SKILL_CRITICAL_HIT_DAMAGE},
	{"lifeleech", SKILL_LIFE_LEECH_AMOUNT},
	{"manaleech", SKILL_MANA_LEECH_AMOUNT}
};

static const std::unordered_map<std::string, UseSkillMode> effectTypeToSkillMode = {
	{"skill", NormalSkill},
	{"magicpoints", MagicLevel},
	{"critical", SpecialSkill},
	{"lifeleech", SpecialSkill},
	{"manaleech", SpecialSkill}
};

std::shared_ptr<Imbuement> Imbuements::getImbuement(uint16_t id) const {
	if (id == 0) {
		return nullptr;
	}

	auto it = imbuementMap.find(id);
	if (it == imbuementMap.end()) {
		g_logger().warn("Imbuement {} not found", id);
		return nullptr;
	}
	return it->second;
}

bool Imbuements::loadFromXml(bool /* reloading */) {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY, __FUNCTION__) + "/XML/imbuements.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	loaded = true;
	if (!std::ranges::all_of(doc.child("imbuements").children(), [&](const auto& baseNode) {
			++runningid;
			if (strcasecmp(baseNode.name(), "base") == 0) {
				if (!processBaseNode(baseNode)) {
					g_logger().error("Falha ao processar o nó base");
					return false;
				}
			} else if (strcasecmp(baseNode.name(), "category") == 0) {
				if (!processCategoryNode(baseNode)) {
					g_logger().error("Falha ao processar o nó category");
					return false;
				}
			} else if (strcasecmp(baseNode.name(), "imbuement") == 0) {
				if (!processImbuementNode(baseNode)) {
					g_logger().error("Falha ao processar o nó imbuement");
					return false;
				}
			}
			return true;
		})) {
		return false;
	}
	return true;
}

bool Imbuements::processBaseNode(const pugi::xml_node &baseNode) {
	pugi::xml_attribute id = baseNode.attribute("id");
	if (!id) {
		g_logger().warn("Missing id for base entry");
		return false;
	}

	basesImbuement.emplace_back(std::make_shared<BaseImbuement>(
		pugi::cast<uint16_t>(id.value()),
		baseNode.attribute("name").as_string(),
		pugi::cast<uint32_t>(baseNode.attribute("price").value()),
		pugi::cast<uint32_t>(baseNode.attribute("protectionPrice").value()),
		pugi::cast<uint32_t>(baseNode.attribute("removecost").value()),
		pugi::cast<uint32_t>(baseNode.attribute("duration").value()),
		pugi::cast<uint16_t>(baseNode.attribute("percent").value())
	));

	return true;
}

bool Imbuements::processCategoryNode(const pugi::xml_node &categoryNode) {
	pugi::xml_attribute id = categoryNode.attribute("id");
	if (!id) {
		g_logger().warn("Missing id for category entry");
		return false;
	}

	categoriesImbuement.emplace_back(std::make_shared<CategoryImbuement>(
		pugi::cast<uint16_t>(id.value()),
		categoryNode.attribute("name").as_string(),
		categoryNode.attribute("agressive").as_bool(true)
	));

	return true;
}

bool Imbuements::processImbuementNode(const pugi::xml_node &imbuementNode) {
	pugi::xml_attribute base = imbuementNode.attribute("base");
	if (!base) {
		g_logger().warn("Missing imbuement base id");
		return false;
	}

	uint16_t baseid = pugi::cast<uint32_t>(base.value());
	const auto &groupBase = getBaseByID(baseid);
	if (groupBase == nullptr) {
		g_logger().warn("Group base '{}' not exist", baseid);
		return false;
	}

	auto imbuements = imbuementMap.emplace(std::piecewise_construct, std::forward_as_tuple(runningid), std::forward_as_tuple(std::make_shared<Imbuement>(runningid, baseid)));

	if (!imbuements.second) {
		g_logger().warn("Duplicate imbuement of Base ID: '{}' ignored", baseid);
		return false;
	}

	const auto &imbuement = imbuements.first->second;

	pugi::xml_attribute iconBase = imbuementNode.attribute("iconid");
	if (!iconBase) {
		g_logger().warn("Missing 'iconid' for imbuement entry");
		return false;
	}
	imbuement->icon = pugi::cast<uint16_t>(iconBase.value());

	if (pugi::xml_attribute soundBase = imbuementNode.attribute("sound")) {
		imbuement->soundEffect = static_cast<SoundEffect_t>(pugi::cast<uint16_t>(soundBase.value()));
	}

	pugi::xml_attribute premiumBase = imbuementNode.attribute("premium");
	if (premiumBase) {
		imbuement->premium = premiumBase.as_bool();
	}

	if (pugi::xml_attribute storageBase = imbuementNode.attribute("storage")) {
		imbuement->storage = pugi::cast<uint32_t>(storageBase.value());
	}

	pugi::xml_attribute subgroupBase = imbuementNode.attribute("subgroup");
	if (subgroupBase) {
		imbuement->subgroup = subgroupBase.as_string();
	}

	pugi::xml_attribute categorybase = imbuementNode.attribute("category");
	if (!categorybase) {
		g_logger().warn("Missing imbuement category");
		return false;
	}

	auto category = pugi::cast<uint16_t>(categorybase.value());
	const auto &category_p = getCategoryByID(category);
	if (category_p == nullptr) {
		g_logger().warn("Category imbuement {} not exist", category);
		return false;
	}

	imbuement->category = category;

	pugi::xml_attribute nameBase = imbuementNode.attribute("name");
	if (!nameBase) {
		g_logger().warn("Missing imbuement name");
		return false;
	}
	imbuement->name = nameBase.value();

	return processImbuementChildNodes(imbuementNode, imbuement);
}

bool Imbuements::processImbuementChildNodes(const pugi::xml_node &imbuementNode, const std::shared_ptr<Imbuement> &imbuement) {
	pugi::xml_attribute attr;
	for (auto childNode : imbuementNode.children()) {
		if (!(attr = childNode.attribute("key"))) {
			g_logger().warn("Missing key attribute in imbuement id: {}", runningid);
			return false;
		}

		std::string type = attr.as_string();
		if (strcasecmp(type.c_str(), "item") == 0) {
			if (!(attr = childNode.attribute("value"))) {
				g_logger().warn("Missing item ID for imbuement name '{}'", imbuement->name);
				return false;
			}
			auto sourceId = pugi::cast<uint16_t>(attr.value());

			uint16_t count = 1;
			if ((attr = childNode.attribute("count"))) {
				count = pugi::cast<uint16_t>(attr.value());
			}

			auto it2 = std::find_if(imbuement->items.begin(), imbuement->items.end(), [sourceId](const std::pair<uint16_t, uint16_t> &source) -> bool {
				return source.first == sourceId;
			});

			if (it2 != imbuement->items.end()) {
				g_logger().warn("Duplicate item: {}, imbument name: {} ignored", childNode.attribute("value").value(), imbuement->name);
				return false;
			}

			imbuement->items.emplace_back(sourceId, count);

		} else if (strcasecmp(type.c_str(), "description") == 0) {
			std::string description = imbuement->name;
			if ((attr = childNode.attribute("value"))) {
				description = attr.as_string();
			}

			imbuement->description = description;
		} else if (strcasecmp(type.c_str(), "effect") == 0) {
			// Effects
			if (!(attr = childNode.attribute("type"))) {
				g_logger().warn("Missing effect type for imbuement name: {}", imbuement->name);
				return false;
			}

			std::string effecttype = attr.as_string();

			if (strcasecmp(effecttype.c_str(), "skill") == 0) {
				if (!(attr = childNode.attribute("value"))) {
					g_logger().warn("Missing effect value for imbuement name {}", imbuement->name);
					return false;
				}

				std::string skillName = asLowerCaseString(attr.as_string());
				auto it = skillMap.find(skillName);
				if (it == skillMap.end()) {
					g_logger().warn("Unknown skill name {} in imbuement name {}", skillName, imbuement->name);
					return false;
				}

				uint8_t skillId = it->second;

				if (!(attr = childNode.attribute("bonus"))) {
					g_logger().warn("Missing skill bonus for imbuement name {}", imbuement->name);
					return false;
				}
				auto bonus = pugi::cast<int32_t>(attr.value());

				auto itSkillMode = effectTypeToSkillMode.find(effecttype);
				UseSkillMode useSkillMode = (itSkillMode != effectTypeToSkillMode.end()) ? itSkillMode->second : NormalSkill;

				if (useSkillMode == NormalSkill) {
					imbuement->skills[skillId] = bonus;
				} else if (useSkillMode == MagicLevel) {
					imbuement->stats[skillId] = bonus;
				} else if (useSkillMode == SpecialSkill) {
					imbuement->skills[skillId] = bonus;
					int32_t chance = 100;
					if ((attr = childNode.attribute("chance"))) {
						chance = std::min<int32_t>(10000, pugi::cast<int32_t>(attr.value()));
					}
					imbuement->skills[skillId - 1] = chance;
				}
			} else if (strcasecmp(effecttype.c_str(), "damage") == 0) {
				if (!(attr = childNode.attribute("combat"))) {
					g_logger().warn("Missing combat for imbuement name {}", imbuement->name);
					return false;
				}

				CombatType_t combatType = getCombatTypeByName(attr.as_string());
				if (combatType == COMBAT_NONE) {
					g_logger().warn("Unknown combat type for element {}", attr.as_string());
					return false;
				}

				if (!(attr = childNode.attribute("value"))) {
					g_logger().warn("Missing damage reduction percentage for imbuement name {}", imbuement->name);
					return false;
				}

				uint32_t percent = std::min<uint32_t>(100, pugi::cast<uint32_t>(attr.value()));

				imbuement->combatType = combatType;
				imbuement->elementDamage = std::min<int16_t>(100, static_cast<int16_t>(percent));
			} else if (strcasecmp(effecttype.c_str(), "reduction") == 0) {
				if (!(attr = childNode.attribute("combat"))) {
					g_logger().warn("Missing combat for imbuement name {}", imbuement->name);
					return false;
				}

				CombatType_t combatType = getCombatTypeByName(attr.as_string());
				if (combatType == COMBAT_NONE) {
					g_logger().warn("Unknown combat type for element {}", attr.as_string());
					return false;
				}

				if (!(attr = childNode.attribute("value"))) {
					g_logger().warn("Missing damage reduction percentage for imbuement name {}", imbuement->name);
					return false;
				}

				uint32_t percent = std::min<uint32_t>(100, pugi::cast<uint32_t>(attr.value()));

				imbuement->absorbPercent[combatTypeToIndex(combatType)] = static_cast<int16_t>(percent);
			} else if (strcasecmp(effecttype.c_str(), "speed") == 0) {
				if (!(attr = childNode.attribute("value"))) {
					g_logger().warn("Missing speed value for imbuement name {}", imbuement->name);
					return false;
				}

				imbuement->speed = static_cast<int32_t>(pugi::cast<uint32_t>(attr.value()));
			} else if (strcasecmp(effecttype.c_str(), "capacity") == 0) {
				if (!(attr = childNode.attribute("value"))) {
					g_logger().warn("Missing cap value for imbuement name {}", imbuement->name);
					return false;
				}

				imbuement->capacity = pugi::cast<uint32_t>(attr.value());
			} else if (strcasecmp(effecttype.c_str(), "vibrancy") == 0) {
				if (!(attr = childNode.attribute("chance"))) {
					g_logger().warn("Missing chance value for imbuement name {}", imbuement->name);
					return false;
				}

				imbuement->paralyzeReduction = pugi::cast<int32_t>(attr.value());
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

std::shared_ptr<BaseImbuement> Imbuements::getBaseByID(uint16_t id) const {
	auto baseImbuements = std::find_if(basesImbuement.begin(), basesImbuement.end(), [id](const auto &groupImbuement) {
		return groupImbuement->id == id;
	});

	return baseImbuements != basesImbuement.end() ? *baseImbuements : nullptr;
}

std::shared_ptr<CategoryImbuement> Imbuements::getCategoryByID(uint16_t id) const {
	auto categoryImbuements = std::find_if(categoriesImbuement.begin(), categoriesImbuement.end(), [id](const auto &categoryImbuement) {
		return categoryImbuement->id == id;
	});

	return categoryImbuements != categoriesImbuement.end() ? *categoryImbuements : nullptr;
}

std::vector<std::shared_ptr<Imbuement>> Imbuements::getImbuements(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item) const {
	std::vector<std::shared_ptr<Imbuement>> imbuements;

	for (auto &[key, value] : imbuementMap) {
		const std::shared_ptr<Imbuement> &imbuement = value;
		if (!imbuement) {
			continue;
		}

		// Parse the storages for each imbuement in imbuements.xml and config.lua (enable/disable storage)
		if (g_configManager().getBoolean(TOGGLE_IMBUEMENT_SHRINE_STORAGE, __FUNCTION__)
			&& imbuement->getStorage() != 0
			&& player->getStorageValue(imbuement->getStorage() == -1)
			&& imbuement->getBaseID() >= 1 && imbuement->getBaseID() <= 3) {
			continue;
		}

		// Send only the imbuements registered on item (in items.xml) to the imbuement window
		const std::shared_ptr<CategoryImbuement> &categoryImbuement = getCategoryByID(imbuement->getCategory());
		if (!item->hasImbuementType(static_cast<ImbuementTypes_t>(categoryImbuement->id), imbuement->getBaseID())) {
			continue;
		}

		// If the item is already imbued with an imbuement, remove the imbuement from the next free slot
		if (item->hasImbuementCategoryId(categoryImbuement->id)) {
			continue;
		}

		imbuements.emplace_back(imbuement);
	}

	return imbuements;
}
