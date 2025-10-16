local mType = Game.createMonsterType("Undead Elite Gladiator")
local monster = {}

monster.description = "an undead elite gladiator"
monster.experience = 5090
monster.outfit = {
	lookType = 306,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1675
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Deep Desert.",
}

monster.health = 8000
monster.maxHealth = 8000
monster.race = "undead"
monster.corpse = 8909
monster.speed = 150
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
	canWalkOnPoison = false,
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
	{ id = 3035, chance = 80000, maxCount = 40 }, -- platinum coin
	{ id = 8044, chance = 80000 }, -- belted cape
	{ id = 3287, chance = 23000, maxCount = 18 }, -- throwing star
	{ id = 3307, chance = 23000 }, -- scimitar
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 3318, chance = 23000 }, -- knight axe
	{ id = 3557, chance = 5000 }, -- plate legs
	{ id = 239, chance = 5000 }, -- great health potion
	{ id = 9656, chance = 5000 }, -- broken gladiator shield
	{ id = 5885, chance = 5000 }, -- flask of warriors sweat
	{ id = 3357, chance = 5000 }, -- plate armor
	{ id = 3347, chance = 5000 }, -- hunting spear
	{ id = 3265, chance = 5000 }, -- two handed sword
	{ id = 3084, chance = 5000 }, -- protection amulet
	{ id = 3384, chance = 5000 }, -- dark helmet
	{ id = 3049, chance = 1000 }, -- stealth ring
	{ id = 3391, chance = 260 }, -- crusader helmet
	{ id = 7383, chance = 260 }, -- relic sword
	{ id = 3081, chance = 260 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 100, maxDamage = 550 },
	{ name = "combat", interval = 1500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 300, maxDamage = 550, range = 7, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = false },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = 300, maxDamage = 500, range = 5, radius = 3, effect = CONST_ME_HITAREA, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 85,
	mitigation = 2.40,
	{ name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
