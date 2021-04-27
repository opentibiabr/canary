local mType = Game.createMonsterType("Werewolf")
local monster = {}

monster.description = "a werewolf"
monster.experience = 1900
monster.outfit = {
	lookType = 308,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 510
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Vengoth Castle, Vengoth Werewolf Cave, Grimvale, were-beasts cave south-west of Edron."
	}

monster.health = 1955
monster.maxHealth = 1955
monster.race = "blood"
monster.corpse = 20380
monster.speed = 280
monster.manaCost = 0
monster.maxSummons = 2

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summons = {
	{name = "war wolf", chance = 40, interval = 2000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "GRRR", yell = true},
	{text = "GRROARR", yell = true}
}

monster.loot = {
	{id = 2148, chance = 98000, maxCount = 230},
	{id = 2169, chance = 800},
	{name = "platinum amulet", chance = 870},
	{name = "stone skin amulet", chance = 1000},
	{name = "halberd", chance = 3000},
	{name = "epee", chance = 560},
	{name = "plate shield", chance = 10340},
	{name = "brown mushroom", chance = 6940},
	{name = "troll green", chance = 1900},
	{name = "wolf paw", chance = 5200},
	{name = "relic sword", chance = 480},
	{name = "dreaded cleaver", chance = 160},
	{name = "bonebreaker", chance = 400},
	{name = "berserk potion", chance = 1200},
	{name = "strong health potion", chance = 5000},
	{name = "ultimate health potion", chance = 2400},
	{id = 9809, chance = 210},
	{id = 24708, chance = 15000},
	{name = "werewolf fur", chance = 10650}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350},
	{name ="outfit", interval = 2000, chance = 1, radius = 1, effect = CONST_ME_SOUND_BLUE, target = true, duration = 2000, outfitMonster = "werewolf"},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -200, length = 4, spread = 2, effect = CONST_ME_SOUND_RED, target = false},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, radius = 3, effect = CONST_ME_SOUND_WHITE, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, radius = 1, effect = CONST_ME_SOUND_GREEN, target = false},
	{name ="werewolf skill reducer", interval = 2000, chance = 15, range = 1, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 120, maxDamage = 225, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 400, range = 7, effect = CONST_ME_SOUND_PURPLE, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 65},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
