local mType = Game.createMonsterType("Crystalcrusher")
local monster = {}

monster.description = "a crystalcrusher"
monster.experience = 500
monster.outfit = {
	lookType = 511,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"MiddleSpikeDeath",
}

monster.raceId = 869
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Crystal Grounds, Mushroom Farms, Middle Spike.",
}

monster.health = 570
monster.maxHealth = 570
monster.race = "venom"
monster.corpse = 16197
monster.speed = 195
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Creak!", yell = false },
	{ text = "Crackle!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 84650, maxCount = 90 }, -- Gold Coin
	{ id = 15793, chance = 4930, maxCount = 3 }, -- Crystalline Arrow
	{ id = 16122, chance = 5060 }, -- Green Crystal Splinter
	{ id = 16123, chance = 5080 }, -- Brown Crystal Splinter
	{ id = 16124, chance = 4970 }, -- Blue Crystal Splinter
	{ id = 16138, chance = 3680 }, -- Crystalline Spikes
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -167 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -110, maxDamage = -260, radius = 3, effect = CONST_ME_GREEN_RINGS, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 48,
	mitigation = 1.29,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 5, maxDamage = 15, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 129, maxDamage = 175, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -3 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
