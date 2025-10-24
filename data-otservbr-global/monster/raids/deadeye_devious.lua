local mType = Game.createMonsterType("Deadeye Devious")
local monster = {}

monster.description = "Deadeye Devious"
monster.experience = 750
monster.outfit = {
	lookType = 151,
	lookHead = 115,
	lookBody = 76,
	lookLegs = 33,
	lookFeet = 117,
	lookAddons = 2,
	lookMount = 0,
}

monster.health = 1450
monster.maxHealth = 1450
monster.race = "blood"
monster.corpse = 18097
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 50,
	targetDistance = 3,
	runHealth = 150,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Let's kill 'em", yell = false },
	{ text = "Arrrgh!", yell = false },
	{ text = "You'll never take me alive!", yell = false },
	{ text = "§%§&§! #*$§$!!", yell = false },
	{ text = "You won't get me alive!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 140 }, -- Gold Coin
	{ id = 6102, chance = 100000 }, -- Deadeye Devious' Eye Patch
	{ id = 3357, chance = 84999 }, -- Plate Armor
	{ id = 3114, chance = 78950, maxCount = 2 }, -- Skull (Item)
	{ id = 3577, chance = 47370, maxCount = 3 }, -- Meat
	{ id = 3267, chance = 36840 }, -- Dagger
	{ id = 3370, chance = 26320 }, -- Knight Armor
	{ id = 3028, chance = 20000 }, -- Small Diamond
	{ id = 239, chance = 5260 }, -- Great Health Potion
	{ id = 3275, chance = 5260 }, -- Double Axe
	{ id = 5926, chance = 5260 }, -- Pirate Backpack
	{ id = 9185, chance = 5260 }, -- Very Old Piece of Paper
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150 },
	{ name = "combat", interval = 4000, chance = 60, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -350, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 35,
	mitigation = 1.20,
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
