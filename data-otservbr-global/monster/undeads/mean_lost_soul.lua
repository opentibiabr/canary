local mType = Game.createMonsterType("Mean Lost Soul")
local monster = {}

monster.description = "a mean lost soul"
monster.experience = 5580
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 14,
	lookLegs = 0,
	lookFeet = 83,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1865
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

monster.health = 5000
monster.maxHealth = 5000
monster.race = "undead"
monster.corpse = 32610
monster.speed = 250
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
    hasGroupedSpells = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "zz zzz zzz", yell = false },
	{ text = "Chew, chew, chew!", yell = false },
}

monster.loot = {
	{ name = "platinum coin", chance = 68090 },
	{ name = "lost soul", chance = 36220 },
	{ name = "death toll", chance = 4769 },
	{ name = "skull staff", chance = 5150 },
	{ name = "machete", chance = 4860 },
	{ name = "ensouled essence", chance = 3360 },
	{ name = "fire axe", chance = 1620 },
	{ name = "ivory comb", chance = 1650 },
	{ name = "mercenary sword", chance = 1450 },
	{ name = "haunted blade", chance = 1040 },
	{ name = "warrior's axe", chance = 1090 },
	{ name = "twiceslicer", chance = 479 },
}

monster.attacks = {    
	{ name = "melee", group = MONSTER_SPELL_GROUP_BASIC, chance = 100, minDamage = -0, maxDamage = -450 },	    
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK,  chance = 26, type = COMBAT_PHYSICALDAMAGE, minDamage = -0, maxDamage = -350, range = 4, shootEffect = CONST_ANI_DRILLBOLT, target = true },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK,  chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -540, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK,  chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -270, maxDamage = -360, length = 4, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },    
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK,  chance = 30, type = COMBAT_LIFEDRAIN, minDamage = -350, maxDamage = -550, range = 5, effect = CONST_ME_YELLOWENERGY, shootEffect = CONST_ANI_ENERGYBALL, target = true },    
}

monster.defenses = {
	defense = 40,
	armor = 80,
	mitigation = 2.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 55 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
