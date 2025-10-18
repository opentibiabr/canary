local mType = Game.createMonsterType("Fleshslicer")
local monster = {}

monster.description = "Fleshslicer"
monster.experience = 5500
monster.outfit = {
	lookType = 457,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 858,
	bossRace = RARITY_BANE,
}

monster.health = 5700
monster.maxHealth = 5700
monster.race = "blood"
monster.corpse = 13870
monster.speed = 280
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 50,
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
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 172 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 3030, chance = 47370, maxCount = 5 }, -- Small Ruby
	{ id = 3026, chance = 23680, maxCount = 5 }, -- White Pearl
	{ id = 14083, chance = 100000, maxCount = 2 }, -- Compound Eye
	{ id = 14082, chance = 100000 }, -- Spidris Mandible
	{ id = 14753, chance = 60529, maxCount = 2 }, -- Dung Ball (Quest)
	{ id = 238, chance = 71050, maxCount = 2 }, -- Great Mana Potion
	{ id = 281, chance = 5260 }, -- Giant Shimmering Pearl
	{ id = 7643, chance = 28950 }, -- Ultimate Health Potion
	{ id = 3039, chance = 18420 }, -- Red Gem
	{ id = 3346, chance = 34210 }, -- Ripper Lance
	{ id = 7413, chance = 7890 }, -- Titan Axe
	{ id = 6299, chance = 5260 }, -- Death Ring
	{ id = 14246, chance = 2630 }, -- Hive Bow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -99 },
}

monster.defenses = {
	defense = 20,
	armor = 12,
	--	mitigation = ???,
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
