local mType = Game.createMonsterType("Skeleton Elite Warrior")
local monster = {}

monster.description = "a skeleton elite warrior"
monster.experience = 4800
monster.outfit = {
	lookType = 298,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1674
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

monster.health = 7800
monster.maxHealth = 7800
monster.race = "undead"
monster.corpse = 8909
monster.speed = 155
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
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
    { name = "platinum coin", chance = 100000, maxCount = 15 },
    { id = 3115, chance = 50130 }, -- bone
    { name = "soul orb", chance = 25610, maxCount = 5 },
    { name = "white mushroom", chance = 25080, maxCount = 3 },
    { name = "pelvis bone", chance = 15660, maxCount = 3 },
    { name = "unholy bone", chance = 10230 },
    { name = "knight axe", chance = 6200 },
    { name = "mammoth whopper", chance = 5130 },
    { name = "bone toothpick", chance = 5000 },
    { name = "skull helmet", chance = 3130 },
    { name = "ruthless axe", chance = 380 },
    { name = "sword", chance = 1960 },
    { name = "brown mushroom", chance = 1950 },
    { name = "mace", chance = 1880 },
}

monster.attacks = {
	{ name = "melee", group = MONSTER_SPELL_GROUP_BASIC, chance = 100, minDamage = -0, maxDamage = -650 },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -500, range = 1, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -450, maxDamage = -550, range = 7, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 35,
	armor = 75,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
