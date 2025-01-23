local mType = Game.createMonsterType("Flimsy Lost Soul")
local monster = {}

monster.description = "a flimsy lost soul"
monster.experience = 4500
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 6,
	lookLegs = 0,
	lookFeet = 116,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1864
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

monster.health = 4000
monster.maxHealth = 4000
monster.race = "undead"
monster.corpse = 32610
monster.speed = 240
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
	{ text = "Woo woo!", yell = false },
	{ text = "cheeuu, cheeuuu!", yell = false },
	{ text = "Help! Help!", yell = false },
}

monster.loot = {
	{ name = "platinum coin", chance = 100000, maxCount = 2 },
	{ name = "lost soul", chance = 30120 },
	{ name = "wand of cosmic energy", chance = 6669 },
	{ name = "springsprout rod", chance = 4650 },
	{ name = "death toll", chance = 4000 },
	{ name = "terra rod", chance = 3640 },
	{ name = "hailstorm rod", chance = 3270 },
	{ name = "ensouled essence", chance = 2630 },
	{ name = "necklace of the deep", chance = 2049 },
	{ name = "cursed bone", chance = 1760 },
	{ name = "wand of starstorm", chance = 1760 },
	{ name = "glacial rod", chance = 1150 },
	{ name = "wand of voodoo", chance = 340 },
}

monster.attacks = {
	{ name = "melee", group = MONSTER_SPELL_GROUP_BASIC, chance = 100, minDamage = -0, maxDamage = -350 },	
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK,  chance = 18, type = COMBAT_DEATHDAMAGE, minDamage = -360, maxDamage = -500, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK,  chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -420, length = 4, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },    
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK,  chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -320, maxDamage = -400, range = 5, effect = CONST_ME_YELLOWENERGY, shootEffect = CONST_ANI_ENERGYBALL, target = true },    
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK,  chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -0, maxDamage = -450, range = 4, shootEffect = CONST_ANI_DRILLBOLT, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 79,
	mitigation = 2.22,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
