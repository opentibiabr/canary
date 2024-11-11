local mType = Game.createMonsterType("Warlord Ruzad")
local monster = {}

monster.description = "Warlord Ruzad"
monster.experience = 1700
monster.outfit = {
	lookType = 2,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 419,
	bossRace = RARITY_NEMESIS,
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 6008
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Orc Berserker", chance = 30, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Gadarat Ulderek!", yell = false },
	{ text = "Ruzad buta bana!", yell = false },
	{ text = "Rahi Gosh!", yell = false },
	{ text = "Ikem rambo zambo!", yell = false },
}

monster.loot = {
	{ id = 11479, chance = 25000 }, -- orc leather
	{ id = 3031, chance = 18500, maxCount = 45 }, -- gold coin
	{ id = 3287, chance = 14500, maxCount = 18 }, -- throwing star
	{ id = 3578, chance = 11300, maxCount = 2 }, -- fish
	{ id = 3316, chance = 5700 }, -- orcish axe
	{ id = 3347, chance = 5700 }, -- hunting spear
	{ id = 3357, chance = 5610 }, -- plate armor
	{ id = 3557, chance = 4680 }, -- plate legs
	{ id = 3307, chance = 4050 }, -- scimitar
	{ id = 3084, chance = 2690 }, -- protection amulet
	{ id = 3265, chance = 2200 }, -- two handed sword
	{ id = 3384, chance = 1900 }, -- dark helmet
	{ id = 818, chance = 750 }, -- magma boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
}

monster.defenses = {
	defense = 35,
	armor = 32,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 1 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
