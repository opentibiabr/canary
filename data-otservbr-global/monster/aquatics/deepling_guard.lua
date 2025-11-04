local mType = Game.createMonsterType("Deepling Guard")
local monster = {}

monster.description = "a deepling guard"
monster.experience = 2100
monster.outfit = {
	lookType = 442,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 770
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Fiehonja. During Deeplings stage 1 around 10 spawns exist. \z
		Also may spawn during the gemcutting mission. Many more spawns in almost all areas of Deepling stage 2 and 3.",
}

monster.health = 1900
monster.maxHealth = 1900
monster.race = "blood"
monster.corpse = 13750
monster.speed = 135
monster.manaCost = 0

monster.faction = FACTION_DEEPLING
monster.enemyFactions = { FACTION_PLAYER, FACTION_DEATHLING }

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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 20,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "QJELL NETA NA!!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 180 }, -- Gold Coin
	{ id = 3035, chance = 70190, maxCount = 2 }, -- Platinum Coin
	{ id = 238, chance = 15050, maxCount = 3 }, -- Great Mana Potion
	{ id = 239, chance = 15100, maxCount = 3 }, -- Great Health Potion
	{ id = 12730, chance = 9850 }, -- Eye of a Deepling
	{ id = 14010, chance = 12020 }, -- Deepling Guard Belt Buckle
	{ id = 14011, chance = 15010 }, -- Deepling Breaktime Snack
	{ id = 14044, chance = 8940 }, -- Deepling Claw
	{ id = 3029, chance = 2880, maxCount = 3 }, -- Small Sapphire
	{ id = 12683, chance = 1500 }, -- Heavy Trident
	{ id = 14043, chance = 870 }, -- Guardian Axe
	{ id = 14250, chance = 720 }, -- Deepling Squelcher
	{ id = 14247, chance = 410 }, -- Ornate Crossbow
	{ id = 14248, chance = 310 }, -- Deepling Backpack
	{ id = 14142, chance = 20 }, -- Foxtail
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DROWNDAMAGE, minDamage = -100, maxDamage = -150, range = 7, shootEffect = CONST_ANI_SPEAR, effect = CONST_ME_LOSEENERGY, target = true },
}

monster.defenses = {
	defense = 35,
	armor = 53,
	mitigation = 1.57,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 100, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
