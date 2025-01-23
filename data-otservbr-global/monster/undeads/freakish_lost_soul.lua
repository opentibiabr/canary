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
	hasGroupedSpells = true,
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
	{ name = "platinum coin", chance = 10000, maxCount = 5 },
	{ name = "lost soul", chance = 45990 },
	{ name = "death toll", chance = 6250 },
	{ name = "emerald bangle", chance = 7530 },
	{ name = "gemmed figurine", chance = 5180 },
	{ name = "ensouled essence", chance = 3820 },
	{ id = 23529, chance = 1580 }, -- ring of blue plasma
	{ name = "silver hand mirror", chance = 1510 },
	{ name = "ornate crossbow", chance = 810 },
	{ name = "crystal crossbow", chance = 270 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -650 },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = -0, maxDamage = -400, range = 4, shootEffect = CONST_ANI_DRILLBOLT, target = true },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -600, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -620, length = 4, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 30, type = COMBAT_LIFEDRAIN, minDamage = -450, maxDamage = -850, range = 5, effect = CONST_ME_YELLOWENERGY, shootEffect = CONST_ANI_ENERGYBALL, target = true },
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
