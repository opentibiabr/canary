local mType = Game.createMonsterType("Lost Basher")
local monster = {}

monster.description = "a lost basher"
monster.experience = 1800
monster.outfit = {
	lookType = 538,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 925
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Caves of the Lost, Lower Spike and in the Lost Dwarf version of the Forsaken Mine."
	}

monster.health = 2600
monster.maxHealth = 2600
monster.race = "blood"
monster.corpse = 19963
monster.speed = 260
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
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
	{text = "Yhouuuu!", yell = false}
}

monster.loot = {
	{name = "piggy bank", chance = 4450},
	{name = "gold coin", chance = 60000, maxCount = 100},
	{name = "platinum coin", chance = 70000, maxCount = 2},
	{name = "fire axe", chance = 310},
	{name = "war axe", chance = 120},
	{name = "knight legs", chance = 310},
	{name = "black shield", chance = 3710},
	{name = "brown mushroom", chance = 15170, maxCount = 2},
	{name = "iron ore", chance = 5280},
	{name = "chaos mace", chance = 160},
	{name = "spiked squelcher", chance = 420},
	{name = "great mana potion", chance = 11240},
	{name = "terra boots", chance = 780},
	{name = "ultimate health potion", chance = 10250},
	{name = "small topaz", chance = 10200},
	{id = 13757, chance = 21130},
	{name = "blue crystal shard", chance = 840},
	{name = "lost basher's spike", chance = 17260},
	{name = "lost basher's spike", chance = 14380},
	{name = "bloody dwarven beard", chance = 1730},
	{name = "pair of iron fists", chance = 1410},
	{name = "buckle", chance = 10930},
	{name = "bonecarving knife", chance = 7320},
	{name = "basalt fetish", chance = 8800},
	{name = "basalt figurine", chance = 9470}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -351},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -220, range = 7, radius = 3, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONAREA, target = true},
	{name ="drunk", interval = 2000, chance = 15, radius = 4, shootEffect = CONST_ANI_WHIRLWINDCLUB, effect = CONST_ME_SOUND_RED, target = true, duration = 6000},
	{name ="speed", interval = 2000, chance = 15, speedChange = -650, radius = 2, effect = CONST_ME_ENERGYHIT, target = false, duration = 15000}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 250, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 40},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 1},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 1}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
