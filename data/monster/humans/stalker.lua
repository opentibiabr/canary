local mType = Game.createMonsterType("Stalker")
local monster = {}

monster.description = "a stalker"
monster.experience = 90
monster.outfit = {
	lookType = 128,
	lookHead = 78,
	lookBody = 116,
	lookLegs = 95,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 72
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Triangle Tower, Drefia, Edron Hero Cave in the Warlock room, White Flower Temple, \z
		Ghostlands, Shadow Tomb, Ancient Ruins Tomb, Tarpit Tomb, Stone Tomb, Mountain Tomb, Peninsula Tomb, \z
		Oasis Tomb, Yalahar Trade Quarter and Isle of the Kings."
	}

monster.health = 120
monster.maxHealth = 120
monster.race = "blood"
monster.corpse = 20511
monster.speed = 260
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 60,
	random = 40,
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
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "gold coin", chance = 13000, maxCount = 8},
	{name = "blank rune", chance = 8670},
	{name = "throwing knife", chance = 11170, maxCount = 2},
	{name = "katana", chance = 530},
	{name = "obsidian lance", chance = 1210},
	{name = "brass legs", chance = 3500},
	{name = "brass legs", chance = 5510},
	{name = "miraculum", chance = 1550}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -70},
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -20, maxDamage = -30, range = 1, effect = CONST_ME_MAGIC_RED, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="invisible", interval = 2000, chance = 40, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -20},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
