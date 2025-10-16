local mType = Game.createMonsterType("Icecold Book")
local monster = {}

monster.description = "an icecold book"
monster.experience = 12750
monster.outfit = {
	lookType = 1061,
	lookHead = 87,
	lookBody = 85,
	lookLegs = 79,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1664
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library (ice section).",
}

monster.health = 21000
monster.maxHealth = 21000
monster.race = "ink"
monster.corpse = 28774
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	{ id = 3035, chance = 80000, maxCount = 8 }, -- platinum coin
	{ id = 28569, chance = 80000 }, -- book page
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 3029, chance = 80000, maxCount = 5 }, -- small sapphire
	{ id = 28567, chance = 23000 }, -- quill
	{ id = 9661, chance = 23000 }, -- frosty heart
	{ id = 28566, chance = 23000 }, -- silken bookmark
	{ id = 23373, chance = 23000 }, -- ultimate mana potion
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 7387, chance = 23000 }, -- diamond sceptre
	{ id = 3284, chance = 23000 }, -- ice rapier
	{ id = 829, chance = 23000 }, -- glacier mask
	{ id = 7437, chance = 5000 }, -- sapphire hammer
	{ id = 3333, chance = 5000 }, -- crystal mace
	{ id = 823, chance = 5000 }, -- glacier kilt
	{ id = 824, chance = 5000 }, -- glacier robe
	{ id = 819, chance = 5000 }, -- glacier shoes
	{ id = 3373, chance = 5000 }, -- strange helmet
	{ id = 7741, chance = 5000 }, -- ice cube
	{ id = 16118, chance = 1000 }, -- glacial rod
	{ id = 8050, chance = 1000 }, -- crystalline armor
	{ id = 9303, chance = 260 }, -- leviathans amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -700, maxDamage = -850, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -380, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -350, maxDamage = -980, length = 5, spread = 0, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_ICEDAMAGE, minDamage = -230, maxDamage = -880, range = 7, radius = 3, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICETORNADO, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 82,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
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
