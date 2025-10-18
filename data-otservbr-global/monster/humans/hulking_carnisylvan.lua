local mType = Game.createMonsterType("Hulking Carnisylvan")
local monster = {}

monster.description = "a hulking carnisylvan"
monster.experience = 4700
monster.outfit = {
	lookType = 1418,
	lookHead = 21,
	lookBody = 3,
	lookLegs = 20,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2107
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Forest of Life.",
}

monster.health = 8600
monster.maxHealth = 8600
monster.race = "blood"
monster.corpse = 36881
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
	canPushCreatures = false,
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
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 19 }, -- Platinum Coin
	{ id = 3115, chance = 26151 }, -- Bone
	{ id = 239, chance = 13266, maxCount = 2 }, -- Great Health Potion
	{ id = 830, chance = 7253 }, -- Terra Hood
	{ id = 36805, chance = 10968 }, -- Carnisylvan Finger
	{ id = 36806, chance = 12846 }, -- Carnisylvan Bark
	{ id = 813, chance = 4854 }, -- Terra Boots
	{ id = 828, chance = 3835 }, -- Lightning Headband
	{ id = 3279, chance = 2756 }, -- War Hammer
	{ id = 3318, chance = 4169 }, -- Knight Axe
	{ id = 3326, chance = 3961 }, -- Epee
	{ id = 7387, chance = 3964 }, -- Diamond Sceptre
	{ id = 7430, chance = 4042 }, -- Dragonbone Staff
	{ id = 36807, chance = 616 }, -- Human Teeth
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 60, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -450, range = 5, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_POISONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -600, maxDamage = -800, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -400, length = 4, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
}

monster.defenses = {
	defense = 51,
	armor = 51,
	mitigation = 1.32,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
