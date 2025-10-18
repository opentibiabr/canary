local mType = Game.createMonsterType("Frost Giantess")
local monster = {}

monster.description = "a frost giantess"
monster.experience = 150
monster.outfit = {
	lookType = 265,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 334
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Tyrsung (in the Jotunar mountain), Formorgar Glacier (single spawn), \z
		Mammoth Shearing Factory, Chyllfroest.",
}

monster.health = 275
monster.maxHealth = 275
monster.race = "blood"
monster.corpse = 7330
monster.speed = 97
monster.manaCost = 490

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 60,
	targetDistance = 4,
	runHealth = 0,
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
	{ text = "Ymirs Mjalle!", yell = false },
	{ text = "No run so much, must stay fat!", yell = false },
	{ text = "Hï¿½rre Sjan Flan!", yell = false },
	{ text = "Damned fast food.", yell = false },
	{ text = "Come kiss the cook!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 82020, maxCount = 40 }, -- Gold Coin
	{ id = 3582, chance = 19498, maxCount = 2 }, -- Ham
	{ id = 1781, chance = 18955, maxCount = 3 }, -- Small Stone
	{ id = 3294, chance = 6924 }, -- Short Sword
	{ id = 3413, chance = 2238 }, -- Battle Shield
	{ id = 9658, chance = 5081 }, -- Frost Giant Pelt
	{ id = 7441, chance = 2429 }, -- Ice Cube
	{ id = 268, chance = 778 }, -- Mana Potion
	{ id = 3093, chance = 167 }, -- Club Ring
	{ id = 3384, chance = 186 }, -- Dark Helmet
	{ id = 7290, chance = 91 }, -- Shard
	{ id = 7460, chance = 280 }, -- Norse Shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -60 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -90, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -3 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
