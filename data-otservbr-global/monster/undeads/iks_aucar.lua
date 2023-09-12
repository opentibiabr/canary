local mType = Game.createMonsterType("Iks Aucar")
local monster = {}

monster.description = "an iks aucar"
monster.experience = 1150
monster.outfit = {
	lookType = 1587,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2344
monster.Bestiary = {
	class = "Iks",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "Iksupan",
}

monster.health = 1520
monster.maxHealth = 1520
monster.race = "blood"
monster.corpse = 42053
monster.speed = 105
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Chaahrrr!", yell = false },
	{ text = "Hrmmmh!", yell = false },
	{ text = "Cathach!!", yell = false },
	{ text = "Chaahrrr!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 100000, maxCount = 475 },
	{ name = "brown crystal splinter", chance = 15500 },
	{ name = "green crystal splinter", chance = 15060 },
	{ name = "small enchanted sapphire", chance = 10100 },
	{ name = "plate shield", chance = 8720 },
	{ name = "onyx chip", chance = 8060, maxCount = 2 },
	{ name = "opal", chance = 7260 },
	{ name = "small emerald", chance = 6820 },
	{ name = "war hammer", chance = 5620 },
	{ name = "strong health potion", chance = 5180, maxCount = 2 },
	{ name = "small ruby", chance = 4300, maxCount = 2 },
	{ name = "rotten feather", chance = 2170 },
	{ name = "ritual tooth", chance = 1330 },
	{ name = "gold-brocaded cloth", chance = 890 },
	{ name = "broken iks sandals", chance = 40 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250, effect = CONST_ME_PURPLEENERGY },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -75, maxDamage = -100, length = 7, spread = 0, effect = 216, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -160, range = 1, radius = 0, effect = CONST_ME_EXPLOSIONHIT, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 36,
	mitigation = 1.32,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
