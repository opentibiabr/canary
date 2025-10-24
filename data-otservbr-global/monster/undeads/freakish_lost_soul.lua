local mType = Game.createMonsterType("Freakish Lost Soul")
local monster = {}

monster.description = "a freakish lost soul"
monster.experience = 7020
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 74,
	lookLegs = 0,
	lookFeet = 83,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1866
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Brain Grounds, Netherworld, Zarganash.",
}

monster.health = 7000
monster.maxHealth = 7000
monster.race = "undead"
monster.corpse = 32610
monster.speed = 260
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
	illusionable = true,
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
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 3 }, -- Platinum Coin
	{ id = 32227, chance = 44686 }, -- Lost Soul (Item)
	{ id = 32703, chance = 6037 }, -- Death Toll
	{ id = 3010, chance = 7223 }, -- Emerald Bangle
	{ id = 24392, chance = 5702 }, -- Gemmed Figurine
	{ id = 32698, chance = 3697 }, -- Ensouled Essence
	{ id = 32772, chance = 1547 }, -- Silver Hand Mirror
	{ id = 23529, chance = 1493 }, -- Ring of Blue Plasma
	{ id = 14247, chance = 643 }, -- Ornate Crossbow
	{ id = 16163, chance = 786 }, -- Crystal Crossbow
	{ id = 3081, chance = 330 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -500 },
	{ name = "combat", interval = 1700, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -550, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 1700, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -150, maxDamage = -550, length = 4, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1700, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -550, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1700, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -150, maxDamage = -550, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 85,
	mitigation = 2.60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 60 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 35 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
