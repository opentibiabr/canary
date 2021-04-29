/**
 * @file imbuements.h
 * 
 * Credits: Yamaken
 * Credits: Cjaker
 * Rewritten and adapted: LucasCPrazeres
 */

#ifndef OT_SRC_IMBUEMENTS_H_
#define OT_SRC_IMBUEMENTS_H_

#include "creatures/players/player.h"
#include "utils/enums.h"
#include "utils/tools.h"

class Player;
class Item;

class Imbuement;

struct BaseImbue {
	BaseImbue(uint16_t initId, std::string initName, uint32_t initProtection, uint32_t initPrice, uint32_t initRemovecust, int32_t initDuration, uint16_t initPercent) :
		id(initId), name(std::move(initName)), protection(initProtection), price(initPrice), removecust(initRemovecust), duration(initDuration), percent(initPercent) {}

	uint16_t id;
	std::string name;
	uint32_t protection;
	uint32_t price;
	uint32_t removecust;
	int32_t duration;
	uint16_t percent;
};

struct Category {
	Category(uint16_t initId, std::string initName) :
		id(initId), name(std::move(initName)) {}

	uint16_t id;
	std::string name;
};

class Imbuements {
	public:
		bool loadFromXml(bool reloading = false);
		bool reload();

		Imbuement* getImbuement(uint16_t id);

		BaseImbue* getBaseByID(uint16_t id);
		Category* getCategoryByID(uint16_t id);
		std::vector<Imbuement*> getImbuements(Player* player, Item* item);

	protected:
		friend class Imbuement;

		std::map<uint32_t, Imbuement> imbues;
		std::vector<BaseImbue> bases;
		std::vector<Category> categories;

		bool loaded = false;

	private:
		uint32_t runningid = 0;

};

class Imbuement
{
	public:
		Imbuement(uint16_t initId, uint16_t initBaseId) : 
				id(initId), baseid(initBaseId) {}

		uint16_t getId() const {
			return id;
		}

		uint16_t getBaseID() const {
			return baseid;
		}

		bool isPremium() {
			return premium;
		}
		std::string getName() const {
			return name;
		}
		std::string getDescription() const {
			return description;
		}

		std::string getSubGroup() const {
			return subgroup;
		}

		uint16_t getCategory() const {
			return category;
		}

		const std::vector<std::pair<uint16_t, uint16_t>>& getItems() const {
			return items;
		}

		uint16_t getIconID() {
			return icon + (baseid - 1);
		}

		uint16_t icon = 1;
		int32_t stats[STAT_LAST + 1] = {};
		int32_t skills[SKILL_LAST + 1] = {};
		int32_t speed = 0;
		uint32_t capacity = 0;
		int16_t absorbPercent[COMBAT_COUNT] = {};
		int16_t elementDamage = 0;

		CombatType_t combatType = COMBAT_NONE;

	protected:
		friend class Imbuements;
		friend class Item;

	private:
		bool premium = false;
		uint16_t id, baseid, category = 0;
		std::string name, description, subgroup = "";

		std::vector<std::pair<uint16_t, uint16_t>> items;
};

#endif
