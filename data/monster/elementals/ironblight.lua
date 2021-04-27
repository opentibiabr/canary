local mType = Game.createMonsterType("Ironblight")
local monster = {}

monster.description = "an ironblight"
monster.experience = 4400
monster.outfit = {
	lookType = 498,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 890
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 3."
	}

monster.health = 6600
monster.maxHealth = 6600
monster.race = "undead"
monster.corpse = 17424
monster.speed = 286
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 260,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Clonk!", yell = false},
	{text = "Yowl!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 199},
	{name = "small emerald", chance = 10890, maxCount = 3},
	{name = "small amethyst", chance = 15020, maxCount = 3},
	{name = "platinum coin", chance = 100000, maxCount = 8},
	{name = "red gem", chance = 3510},
	{name = "blue gem", chance = 480},
	{name = "epee", chance = 480},
	{name = "magic sulphur", chance = 830},
	{name = "sapphire hammer", chance = 480},
	{name = "great mana potion", chance = 17640},
	{name = "terra legs", chance = 1110},
	{name = "ultimate health potion", chance = 18330},
	{name = "composite hornbow", chance = 210},
	{name = "springsprout rod", chance = 1720},
	{name = "crystal of balance", chance = 4480},
	{name = "crystal of power", chance = 2480},
	{name = "war crystal", chance = 21230},
	{name = "shiny stone", chance = 15230},
	{name = "jade hat", chance = 210},
	{name = "glacial rod", chance = 960},
	{name = "green crystal shard", chance = 5720},
	{name = "brown crystal splinter", chance = 12610, maxCount = 2},
	{name = "red crystal fragment", chance = 10540},
	{name = "crystalline spikes", chance = 18400}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -460, maxDamage = -480, radius = 6, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -260, maxDamage = -350, length = 7, spread = 3, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -180, maxDamage = -250, radius = 2, shootEffect = CONST_ANI_GREENSTAR, effect = CONST_ME_BIGPLANTS, target = true},
	{name ="speed", interval = 2000, chance = 10, speedChange = -800, length = 5, spread = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 30000}
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{name ="invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 25},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 60},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
