local mType = Game.createMonsterType("Mutated Bat")
local monster = {}

monster.description = "a mutated bat"
monster.experience = 615
monster.outfit = {
	lookType = 307,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 509
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Cemetery Quarter (around 10 underground on the west side along with banshees, \z
		and 4 bats on the church roof), Alchemist Quarter (4 found on top of roofs), \z
		Arena and Zoo Quarter (2 under the arena with other mutated creatures), \z
		Razzachai, Northern Zao Plantations, Souleater Mountains, Middle Spike, Vengoth and Vengoth Castle."
	}

monster.health = 900
monster.maxHealth = 900
monster.race = "blood"
monster.corpse = 9829
monster.speed = 186
monster.manaCost = 0
monster.maxSummons = 0

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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
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
	{text = "Shriiiiiek", yell = false}
}

monster.loot = {
	{name = "black pearl", chance = 720, maxCount = 3},
	{name = "gold coin", chance = 53000, maxCount = 50},
	{name = "gold coin", chance = 40000, maxCount = 70},
	{name = "small amethyst", chance = 500, maxCount = 2},
	{name = "energy ring", chance = 990},
	{name = "battle shield", chance = 7760},
	{name = "black shield", chance = 70},
	{name = "star herb", chance = 7260},
	{name = "star herb", chance = 5060},
	{name = "bat wing", chance = 4900, maxCount = 2},
	{name = "mercenary sword", chance = 110},
	{id = 9808, chance = 12530},
	{id = 9809, chance = 12530, maxCount = 2},
	{name = "batwing hat", chance = 80},
	{name = "mutated bat ear", chance = 4900}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -168, condition = {type = CONDITION_POISON, totalDamage = 120, interval = 4000}},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -70, maxDamage = -180, range = 7, shootEffect = CONST_ANI_POISON, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_DROWNDAMAGE, minDamage = -30, maxDamage = -90, radius = 6, effect = CONST_ME_SOUND_WHITE, target = false},
	{name ="mutated bat curse", interval = 2000, chance = 10, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -190, maxDamage = -240, length = 4, spread = 3, effect = CONST_ME_POISONAREA, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
