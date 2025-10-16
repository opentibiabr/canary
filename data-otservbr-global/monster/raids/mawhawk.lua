local mType = Game.createMonsterType("Mawhawk")
local monster = {}

monster.description = "Mawhawk"
monster.experience = 14000
monster.outfit = {
	lookType = 595,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1028,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 45000
monster.maxHealth = 45000
monster.race = "blood"
monster.corpse = 20295
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Better flee now!", yell = false },
	{ text = "Watch my maws!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 101 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 25 }, -- platinum coin
	{ id = 16124, chance = 80000, maxCount = 5 }, -- blue crystal splinter
	{ id = 16123, chance = 80000, maxCount = 5 }, -- brown crystal splinter
	{ id = 5895, chance = 80000 }, -- fish fin
	{ id = 20198, chance = 80000 }, -- frazzle tongue
	{ id = 16122, chance = 80000, maxCount = 5 }, -- green crystal splinter
	{ id = 20062, chance = 80000, maxCount = 2 }, -- cluster of solace
	{ id = 20264, chance = 80000, maxCount = 2 }, -- unrealized dream
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 3280, chance = 80000 }, -- fire sword
	{ id = 5911, chance = 80000 }, -- red piece of cloth
	{ id = 7407, chance = 80000 }, -- haunted blade
	{ id = 7418, chance = 80000 }, -- nightmare blade
	{ id = 7404, chance = 80000 }, -- assassin dagger
	{ id = 16119, chance = 80000 }, -- blue crystal shard
	{ id = 5880, chance = 80000 }, -- iron ore
	{ id = 16121, chance = 80000 }, -- green crystal shard
	{ id = 5925, chance = 80000 }, -- hardened bone
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 90 },
	{ name = "combat", interval = 1800, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -685, length = 7, spread = 0, effect = CONST_ME_STONES, target = false },
	{ name = "combat", interval = 2000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = -250, maxDamage = -590, radius = 6, effect = CONST_ME_BIGPLANTS, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 55,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
