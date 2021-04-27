local mType = Game.createMonsterType("Demon Skeleton")
local monster = {}

monster.description = "a demon skeleton"
monster.experience = 240
monster.outfit = {
	lookType = 37,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 37
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Triangle Tower, Hellgate, Draconia, Plains of Havoc, Pits of Inferno, Thais Ancient Temple, \z
		Fibula Dungeon, Mintwallin, Mount Sternum hidden cave, Drefia, Ghost Ship, Edron Hero Cave, Shadowthorn, \z
		Elvenbane, Ghostlands, Femor Hills, White Flower Temple, Isle of the Kings, Dark Cathedral, Ankrahmun Tombs, \z
		Ramoa, Helheim, Vengoth, Upper Spike, Lion's Rock."
	}

monster.health = 400
monster.maxHealth = 400
monster.race = "undead"
monster.corpse = 5963
monster.speed = 180
monster.manaCost = 620
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
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
}

monster.loot = {
	{id = 2050, chance = 5270},
	{name = "black pearl", chance = 2900},
	{name = "small ruby", chance = 1400},
	{name = "gold coin", chance = 97000, maxCount = 75},
	{name = "mind stone", chance = 520},
	{name = "mysterious fetish", chance = 690},
	{name = "throwing star", chance = 10000, maxCount = 3},
	{name = "battle hammer", chance = 4000},
	{name = "iron helmet", chance = 3450},
	{name = "battle shield", chance = 5000},
	{name = "guardian shield", chance = 100},
	{name = "health potion", chance = 10120, maxCount = 2},
	{name = "health potion", chance = 10000, maxCount = 2},
	{name = "mana potion", chance = 5300},
	{name = "demonic skeletal hand", chance = 12600}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -185},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -50, range = 1, radius = 1, effect = CONST_ME_SMALLCLOUDS, target = true}
}

monster.defenses = {
	defense = 30,
	armor = 30
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -25},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
