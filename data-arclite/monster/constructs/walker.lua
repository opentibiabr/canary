local mType = Game.createMonsterType("Walker")
local monster = {}

monster.description = "a walker"
monster.experience = 2200
monster.outfit = {
	lookType = 605,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1043
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "A few spawns in the Underground Glooth Factory, Glooth Factory, and Rathleton Sewers."
	}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "venom"
monster.corpse = 20972
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
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
	{id = 21198, chance = 3548}, -- metal toe
	{id = 21170, chance = 1490}, -- gearwheel chain
	{id = 3031, chance = 100000, maxCount = 200}, -- gold coin
	{id = 3035, chance = 51610, maxCount = 3}, -- platinum coin
	{id = 9057, chance = 16130, maxCount = 3}, -- small topaz
	{id = 3032, chance = 6450, maxCount = 2}, -- small emerald
	{id = 7642, chance = 3230}, -- great spirit potion
	{id = 239, chance = 3230}, -- great health potion
	{id = 238, chance = 2300}, -- great mana potion
	{id = 21169, chance = 1780}, -- metal spats
	{id = 3554, chance = 450} -- steel boots
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 70, attack = 50},
	{name ="walker skill reducer", interval = 2000, chance = 21, target = false},
	{name ="combat", interval = 2000, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -125, maxDamage = -245, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 40
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 5},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 50},
	{type = COMBAT_FIREDAMAGE, percent = 35},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 5},
	{type = COMBAT_HOLYDAMAGE , percent = 40},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
