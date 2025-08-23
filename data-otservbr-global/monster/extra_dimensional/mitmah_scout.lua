local mType = Game.createMonsterType("Mitmah Scout")
local monster = {}

monster.description = "a mitmah scout"
monster.experience = 3230
monster.outfit = {
	lookType = 1709,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2460
monster.Bestiary = {
	class = "Extra Dimensional",
	race = BESTY_RACE_EXTRA_DIMENSIONAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Iksupan Waterways",
}

monster.health = 3940
monster.maxHealth = 3940
monster.race = "venom"
monster.corpse = 44666
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 15,
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
	critChance = 3,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{ text = "Die for us!", yell = false },
	{ text = "Humans ought to be extinct!", yell = false },
	{ text = "This belongs to us now!", yell = false },
}

monster.loot = {
	{ name = "platinum coin", chance = 100000, maxCount = 10 },
	{ name = "broken mitmah necklace", chance = 17180 },
	{ name = "brown crystal splinter", chance = 7620 },
	{ id = 281, chance = 7400 }, -- giant shimmering pearl
	{ name = "green crystal splinter", chance = 6890 },
	{ name = "strong health potion", chance = 6170, maxCount = 3 },
	{ name = "opal", chance = 4080 },
	{ name = "onyx chip", chance = 3670 },
	{ name = "gold ingot", chance = 2880 },
	{ id = 3037, chance = 2450 }, -- yellow gem
	{ name = "prismatic quartz", chance = 2410 },
	{ name = "ruby necklace", chance = 1810 },
	{ name = "gold-brocaded cloth", chance = 1340 },
	{ name = "drill bolt", chance = 1270, maxCount = 10 },
	{ id = 3040, chance = 320 }, -- gold nugget
	{ name = "ornate crossbow", chance = 140 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -400, radius = 4, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -400, range = 5, shootEffect = CONST_ANI_POWERBOLT, effect = CONST_ME_ENERGYAREA, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 45,
	mitigation = 2.02,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 50, maxDamage = 180, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
