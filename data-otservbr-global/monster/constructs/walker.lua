local mType = Game.createMonsterType("Walker")
local monster = {}

monster.description = "a walker"
monster.experience = 2200
monster.outfit = {
	lookType = 605,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1043
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "A few spawns in the Underground Glooth Factory, Glooth Factory, and Rathleton Sewers.",
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "venom"
monster.corpse = 20972
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "*clop clop*", yell = false },
	{ text = "*slosh*", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 199 }, -- Gold Coin
	{ id = 3035, chance = 51190, maxCount = 3 }, -- Platinum Coin
	{ id = 21198, chance = 20700 }, -- Metal Toe
	{ id = 239, chance = 7820 }, -- Great Health Potion
	{ id = 7642, chance = 7219 }, -- Great Spirit Potion
	{ id = 9057, chance = 10590 }, -- Small Topaz
	{ id = 3033, chance = 5120 }, -- Small Amethyst
	{ id = 3032, chance = 4320 }, -- Small Emerald
	{ id = 21169, chance = 3530 }, -- Metal Spats
	{ id = 21170, chance = 2029 }, -- Gearwheel Chain
	{ id = 3333, chance = 600 }, -- Crystal Mace
	{ id = 3554, chance = 480 }, -- Steel Boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 70, attack = 50 },
	{ name = "walker skill reducer", interval = 2000, chance = 21, target = false },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -125, maxDamage = -245, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 47,
	mitigation = 1.62,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
