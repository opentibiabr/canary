local mType = Game.createMonsterType("Falcon Knight")
local monster = {}

monster.description = "a falcon knight"
monster.experience = 6300
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 38,
	lookFeet = 105,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1646
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

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 28621
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
	{ text = "Mmmhaarrrgh!", yell = false },
}

monster.loot = {
	{ id = 3582, chance = 84000, maxCount = 3 }, -- Ham
	{ id = 5944, chance = 41000 }, -- Soul Orb
	{ id = 239, chance = 34000, maxCount = 3 }, -- Great Health Potion
	{ id = 238, chance = 32000, maxCount = 3 }, -- Great Mana Potion
	{ id = 3033, chance = 30000, maxCount = 3 }, -- Small Amethyst
	{ id = 7368, chance = 30000, maxCount = 10 }, -- Assassin Star
	{ id = 6558, chance = 30000, maxCount = 4 }, -- Flask of Demonic Blood
	{ id = 3030, chance = 18700, maxCount = 3 }, -- Small Ruby
	{ id = 7365, chance = 18700, maxCount = 15 }, -- Onyx Arrow
	{ id = 3032, chance = 18100, maxCount = 3 }, -- Small Emerald
	{ id = 3028, chance = 17300, maxCount = 3 }, -- Small Diamond
	{ id = 9057, chance = 6100, maxCount = 3 }, -- Small Topaz
	{ id = 281, chance = 3600 }, -- Giant Shimmering Pearl (Green)
	{ id = 7413, chance = 3300 }, -- Titan Axe
	{ id = 3370, chance = 2400 }, -- Knight Armor
	{ id = 7452, chance = 2200 }, -- Spiked Squelcher
	{ id = 28823, chance = 1500 }, -- Falcon Crest
	{ id = 3036, chance = 1400 }, -- Violet Gem
	{ id = 3038, chance = 1200 }, -- Green Gem
	{ id = 3360, chance = 1200 }, -- Golden Armor
	{ id = 28822, chance = 1100 }, -- Damaged Armor Plates
	{ id = 3342, chance = 860 }, -- War Axe
	{ id = 3414, chance = 600 }, -- Mastermind Shield
	{ id = 3481, chance = 480 }, -- Closed Trap
	{ id = 3340, chance = 360 }, -- Heavy Mace
	{ id = 3019, chance = 160 }, -- Demonbone Amulet
	{ id = 3081, chance = 60 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -500, radius = 2, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -290, maxDamage = -360, length = 5, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.defenses = {
	defense = 86,
	armor = 86,
	mitigation = 2.37,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
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
