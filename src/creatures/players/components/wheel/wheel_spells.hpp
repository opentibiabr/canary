/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#pragma once

namespace WheelSpells {
	struct Increase {
		bool area = false;
		int damage = 0;
		int heal = 0;
		int aditionalTarget = 0;
		int damageReduction = 0;
		int duration = 0;
		int criticalDamage = 0;
		int criticalChance = 0;
	};

	struct Decrease {
		int cooldown = 0;
		int manaCost = 0;
		int secondaryGroupCooldown = 0;
	};

	struct Leech {
		int mana = 0;
		int life = 0;
	};

	struct Bonus {
		Leech leech;
		Increase increase;
		Decrease decrease;
	};
}
