local mType = Game.createMonsterType("Wereboar")
local monster = {}

monster.description = "a wereboar"
monster.experience = 2000
monster.outfit = {
	lookType = 721,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1143
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Grimvale underground, were-beasts cave south-west of Edron and in the Last Sanctum east of Cormaya."
	}

monster.health = 2200
monster.maxHealth = 2200
monster.race = "blood"
monster.corpse = 22066
monster.speed = 150
monster.manaCost = 0

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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 275,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "GRUNT", yell = false}
}

monster.loot = {
	{id = 3031, chance = 97000, maxCount = 242}, -- gold coin
	{id = 3035, chance = 18200, maxCount = 5}, -- platinum coin
	{id = 676, chance = 5000, maxCount = 2}, -- small enchanted ruby
	{id = 3725, chance = 2000}, -- brown mushroom
	{id = 7643, chance = 2210}, -- ultimate health potion
	{id = 236, chance = 1200}, -- strong health potion
	{id = 22053, chance = 1900}, -- wereboar hooves
	{id = 22087, chance = 950}, -- wereboar loincloth
	{id = 22054, chance = 780}, -- wereboar tusks
	{id = 7439, chance = 700}, -- berserk potion
	{id = 7432, chance = 360}, -- furry club
	{id = 3081, chance = 430}, -- stone skin amulet
	{id = 7419, chance = 320}, -- dreaded cleaver
	{id = 22085, chance = 200}, -- fur armor
	{id = 22102, chance = 200}, -- wereboar trophy
	{id = 22060, chance = 200}, -- werewolf amulet
	{id = 22083, chance = 200} -- moonlight crystals
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 50, attack = 60, condition = {type = CONDITION_POISON, totalDamage = 140, interval = 4000}},
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -385},
	{name ="speed", interval = 4000, chance = 20, radius = 7, effect = CONST_ME_POFF, target = true}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 50},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 5},
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
