local mType = Game.createMonsterType("Falcon Paladin")
local monster = {}

monster.description = "a falcon paladin"
monster.experience = 6900
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 38,
	lookFeet = 105,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1647
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Falcon Bastion.",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 28861
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
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
	{ text = "Uuunngh!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 89000, maxCount = 6 }, -- Platinum Coin
	{ id = 3032, chance = 49000, maxCount = 2 }, -- Small Emerald
	{ id = 3028, chance = 48000, maxCount = 2 }, -- Small Diamond
	{ id = 3033, chance = 48000, maxCount = 2 }, -- Small Amethyst
	{ id = 7642, chance = 47000, maxCount = 2 }, -- Great Spirit Potion
	{ id = 7368, chance = 29000, maxCount = 10 }, -- Assassin Star
	{ id = 3030, chance = 24000, maxCount = 2 }, -- Small Ruby
	{ id = 9057, chance = 23000, maxCount = 2 }, -- Small Topaz
	{ id = 7365, chance = 16500, maxCount = 15 }, -- Onyx Arrow
	{ id = 3039, chance = 8100 }, -- Red Gem
	{ id = 3038, chance = 6400 }, -- Green Gem
	{ id = 3036, chance = 5900 }, -- Violet Gem
	{ id = 281, chance = 2600 }, -- Giant Shimmering Pearl (Green)
	{ id = 28822, chance = 1300 }, -- Damaged Armor Plates
	{ id = 28823, chance = 970 }, -- Falcon Crest
	{ id = 3414, chance = 480 }, -- Mastermind Shield
	{ id = 3360, chance = 350 }, -- Golden Armor
	{ id = 3081, chance = 27 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250 },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -550, range = 5, shootEffect = CONST_ANI_ROYALSPEAR, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = 500, range = 5, shootEffect = CONST_ANI_BOLT, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -350, maxDamage = -450, range = 7, radius = 2, shootEffect = CONST_ANI_POWERBOLT, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -350, length = 5, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 82,
	mitigation = 2.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
