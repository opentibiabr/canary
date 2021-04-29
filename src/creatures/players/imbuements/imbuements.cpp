/**
 * @file imbuements.cpp
 *
 * Credits: Yamaken
 * Credits: Cjaker
 * Rewritten and adapted: LucasCPrazeres
 */

#include "otpch.h"
#include "lua/creature/events.h"
#include "creatures/players/imbuements/imbuements.h"
#include "utils/pugicast.h"

extern Events* g_events;

Imbuement* Imbuements::getImbuement(uint16_t id)
{
	auto it = imbues.find(id);
	if (it == imbues.end()) {
		SPDLOG_WARN("Imbuement {} not found", id);
		return nullptr;
	}
	return &it->second;
}

bool Imbuements::loadFromXml(bool /* reloading */) {
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/imbuements.xml");
	if (!result) {
		printXMLError("Error - Imbuements::loadFromXml", "data/XML/imbuements.xml", result);
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
			bases.emplace_back(
				pugi::cast<uint16_t>(id.value()),
				baseNode.attribute("name").as_string(),
				pugi::cast<uint32_t>(baseNode.attribute("protection").value()),
				pugi::cast<uint32_t>(baseNode.attribute("price").value()),
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
			categories.emplace_back(
				pugi::cast<uint16_t>(id.value()),
				baseNode.attribute("name").as_string()
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

			auto res = imbues.emplace(std::piecewise_construct,
				std::forward_as_tuple(runningid),
				std::forward_as_tuple(runningid, baseid));

			if (!res.second) {
				SPDLOG_WARN("Duplicate imbuement of Base ID: '{}' ignored", baseid);
				continue;
			}

			Imbuement& imb = res.first->second;

			pugi::xml_attribute iconBase = baseNode.attribute("iconid");
			if (!iconBase) {
				SPDLOG_WARN("Missing 'iconid' for imbuement entry");
				continue;
			}
			imb.icon = pugi::cast<uint16_t>(iconBase.value());

			pugi::xml_attribute premiumBase = baseNode.attribute("premium");
			if (premiumBase) {
				imb.premium = premiumBase.as_bool();
			}

			pugi::xml_attribute subgroupBase = baseNode.attribute("subgroup");
			if (subgroupBase) {
				imb.subgroup = subgroupBase.as_string();
			}

			pugi::xml_attribute categorybase = baseNode.attribute("category");
			if (!categorybase) {
				SPDLOG_WARN("Missing imbuement category");
				continue;
			}

			uint16_t category = pugi::cast<uint16_t>(categorybase.value());
			auto category_p = getCategoryByID(category);
			if (category_p == nullptr) {
				SPDLOG_WARN("Category {} not exist", category);
				continue;
			}

			imb.category = category;

			pugi::xml_attribute nameBase = baseNode.attribute("name");
			if (!nameBase) {
				SPDLOG_WARN("Missing imbuement name");
				continue;
			}
			imb.name = nameBase.value();

			for (auto childNode : baseNode.children()) {
				if (!(attr = childNode.attribute("key"))) {
					SPDLOG_WARN("Missing key attribute in imbuement id: {}", runningid);
					continue;
				}

				std::string type = attr.as_string();
				if (strcasecmp(type.c_str(), "item") == 0) {
					if (!(attr = childNode.attribute("value"))) {
						SPDLOG_WARN("Missing item ID for imbuement name '{}'", imb.name);
						continue;
					}
					uint16_t sourceId = pugi::cast<uint16_t>(attr.value());

					uint16_t count = 1;
					if ((attr = childNode.attribute("count"))) {
						count = pugi::cast<uint16_t>(childNode.attribute("count").value());
					}

					auto it2 = std::find_if(imb.items.begin(), imb.items.end(), [sourceId](const std::pair<uint16_t, uint16_t>& source) -> bool {
						return source.first == sourceId;
					});

					if (it2 != imb.items.end()) {
						SPDLOG_WARN("Duplicate item: {}, imbument name: {} ignored",
													childNode.attribute("value").value(), imb.name);
						continue;
					}

					imb.items.emplace_back(sourceId, count);

				} else if  (strcasecmp(type.c_str(), "description") == 0) {
					std::string description = imb.name;
					if ((attr = childNode.attribute("value"))) {
						description = attr.as_string();
					}

					imb.description = description;
				} else if  (strcasecmp(type.c_str(), "effect") == 0) {
					// Effects
					if (!(attr = childNode.attribute("type"))) {
						SPDLOG_WARN("Missing effect type for imbuement name: {}", imb.name);
						continue;
					}

					std::string effecttype = attr.as_string();

					if (strcasecmp(effecttype.c_str(), "skill") == 0) {
						if (!(attr = childNode.attribute("value"))) {
							SPDLOG_WARN("Missing effect value for imbuement name {}", imb.name);
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
								tmpStrValue, imb.name);
							continue;
						}

						if (!(attr = childNode.attribute("bonus"))) {
							SPDLOG_WARN("Missing skill bonus for imbuement name {}",
								imb.name);
							continue;
						}
						int32_t bonus = pugi::cast<int32_t>(attr.value());

						if (usenormalskill == 1) {
							imb.skills[skillId] = bonus;
						} else if (usenormalskill == 2) {
							imb.stats[skillId] = bonus;
						} else if (usenormalskill == 3) {
							imb.skills[skillId] = bonus;
							int32_t chance = 100;
							if ((attr = childNode.attribute("chance")))
								chance = std::min<uint32_t>(100, pugi::cast<int32_t>(attr.value()));

							imb.skills[skillId - 1] = chance;
						}
					} else if (strcasecmp(effecttype.c_str(), "damage") == 0) {
						if (!(attr = childNode.attribute("combat"))) {
							SPDLOG_WARN("Missing combat for imbuement name {}", imb.name);
							continue;
						}

						CombatType_t combatType = getCombatType(attr.as_string());
						if (combatType == COMBAT_NONE) {
							SPDLOG_WARN("Unknown combat type for element {}", attr.as_string());
							continue;
						}

						if (!(attr = childNode.attribute("value"))) {
							SPDLOG_WARN("Missing damage reduction percentage for imbuement name {}",
								imb.name);
							continue;
						}

						uint32_t percent = std::min<uint32_t>(100, pugi::cast<uint32_t>(attr.value()));

						imb.combatType = combatType;
						imb.elementDamage = std::min<int16_t>(100, percent);
					} else if (strcasecmp(effecttype.c_str(), "reduction") == 0) {
						if (!(attr = childNode.attribute("combat"))) {
							SPDLOG_WARN("Missing combat for imbuement name {}", imb.name);
							continue;
						}

						CombatType_t combatType = getCombatType(attr.as_string());
						if (combatType == COMBAT_NONE) {
							SPDLOG_WARN("Unknown combat type for element {}", attr.as_string());
							continue;
						}

						if (!(attr = childNode.attribute("value"))) {
							SPDLOG_WARN("Missing damage reduction percentage for imbuement name {}",
								imb.name);
							continue;
						}

						uint32_t percent = std::min<uint32_t>(100, pugi::cast<uint32_t>(attr.value()));

						imb.absorbPercent[combatTypeToIndex(combatType)] = percent;
					} else if (strcasecmp(effecttype.c_str(), "speed") == 0) {
						if (!(attr = childNode.attribute("value"))) {
							SPDLOG_WARN("Missing speed value for imbuement name {}", imb.name);
							continue;
						}

						imb.speed = pugi::cast<uint32_t>(attr.value());
					} else if (strcasecmp(effecttype.c_str(), "capacity") == 0) {
						if (!(attr = childNode.attribute("value"))) {
							SPDLOG_WARN("Missing cap value for imbuement name {}", imb.name);
							continue;
						}

						imb.capacity = pugi::cast<uint32_t>(attr.value());
					}
				}
			}
		}
	}

	return true;
}

bool Imbuements::reload() {
	imbues.clear();
	bases.clear();
	categories.clear();
	runningid = 0;
	loaded = false;

	return loadFromXml(true);
}

BaseImbue* Imbuements::getBaseByID(uint16_t id)
{
	auto it = std::find_if(bases.begin(), bases.end(), [id](const BaseImbue& group_imb) {
				return group_imb.id == id;
			});

	return it != bases.end() ? &*it : nullptr;
}

Category* Imbuements::getCategoryByID(uint16_t id)
{
	auto it = std::find_if(categories.begin(), categories.end(), [id](const Category& cat_imb) {
				return cat_imb.id == id;
			});

	return it != categories.end() ? &*it : nullptr;
}

std::vector<Imbuement*> Imbuements::getImbuements(Player* player, Item* item)
{
	std::vector<Imbuement*> filtered;
	for (auto& info : imbues) {
		Imbuement* imbuement = &info.second;
		if (!g_events->eventPlayerCanBeAppliedImbuement(player, imbuement, item)) {
			continue;
		}

		filtered.push_back(imbuement);
	}

	return filtered;
}
