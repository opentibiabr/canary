local mType = Game.createMonsterType("Werehyaena Shaman")
local monster = {}

monster.description = "a werehyaena shaman"
monster.experience = 2200
monster.outfit = {
	lookType = 1300,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 94,
	lookFeet = 95,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1964
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "This monster you can find in Hyaena Lairs."
	}
	
monster.health = 2500
monster.maxHealth = monster.health
monster.race = "blood"
monster.corpse = 39024
monster.speed = 110
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0
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
	runHealth = 30,
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
	interval = 0,
	chance = 0
}

monster.loot = {
	{name = "platinum coin", chance = 100000},
	{name = "great mana potion", chance = 20070},
	{name = "werehyaena nose", chance = 15550},
	{name = "small amethyst", chance = 10840},
	{name = "green crystal splinter", chance = 9120},
	{name = "hailstorm rod", chance = 6430},
	{name = "doublet", chance = 5390},
	{name = "brown crystal splinter", chance = 5030},
	{name = "wand of starstorm", chance = 4920},
	{name = "small enchanted emerald", chance = 4630},
	{name = "sword ring", chance = 4490},
	{name = "wand of voodoo", chance = 3990},
	{name = "protection amulet", chance = 2660},
	{name = "werehyaena talisman", chance = 650},
	{name = "moonlight crystals", chance = 610},
	{name = "werehyaena trophy", chance = 140}
}

monster.attacks = {
	{name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2*1000, minDamage = 0, maxDamage = -260},
    {name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2*1000, chance = 10, minDamage = -280, maxDamage = -325, radius = 3, effect = CONST_ME_HITBYPOISON},
    {name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2*1000, chance = 17, minDamage = -280, maxDamage = -315, range = 5, radius = 4, target = true, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_GREEN_RINGS},
    {name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2*1000, chance = 15, minDamage = -370, maxDamage = -430, range = 5, radius = 1, target = true, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA},
    {name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2*1000, chance = 13, minDamage = -280, maxDamage = -325, length = 3, spread = 0, effect = CONST_ME_MORTAREA}
}

monster.defenses = {
	{name = "speed", interval = 2*1000, chance = 15, speed = 200, duration = 5*1000, effect = CONST_ME_MAGIC_BLUE},
	defense = 0,
	armor = 38
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 60},
	{type = COMBAT_FIREDAMAGE, percent = 75},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -20},
	{type = COMBAT_HOLYDAMAGE , percent = 95},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = true}
}

mType:register(monster)
