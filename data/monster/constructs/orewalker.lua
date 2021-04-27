local mType = Game.createMonsterType("Orewalker")
local monster = {}

monster.description = "an orewalker"
monster.experience = 4800
monster.outfit = {
	lookType = 490,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 883
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 3."
	}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "undead"
monster.corpse = 17256
monster.speed = 380
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 80,
	random = 20,
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
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "CLONK!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 50000, maxCount = 100},
	{name = "gold coin", chance = 50000, maxCount = 98},
	{name = "platinum coin", chance = 100000, maxCount = 10},
	{name = "yellow gem", chance = 1030},
	{name = "dwarven ring", chance = 4660},
	{name = "knight legs", chance = 1910},
	{name = "crown armor", chance = 370},
	{name = "crown helmet", chance = 890},
	{name = "iron ore", chance = 15000},
	{name = "magic sulphur", chance = 3000},
	{name = "titan axe", chance = 2600},
	{name = "glorious axe", chance = 1870},
	{name = "strong health potion", chance = 15600, maxCount = 2},
	{name = "strong mana potion", chance = 14000, maxCount = 2},
	{name = "great mana potion", chance = 14000, maxCount = 2},
	{name = "mana potion", chance = 14000, maxCount = 4},
	{name = "ultimate health potion", chance = 9500, maxCount = 2},
	{name = "crystalline armor", chance = 560},
	{name = "small topaz", chance = 16500, maxCount = 3},
	{name = "shiny stone", chance = 13700},
	{name = "sulphurous stone", chance = 20700},
	{name = "wand of defiance", chance = 1300},
	{name = "green crystal shard", chance = 8000},
	{name = "blue crystal splinter", chance = 16000, maxCount = 2},
	{name = "cyan crystal fragment", chance = 13000},
	{name = "pulverized ore", chance = 20500},
	{name = "vein of ore", chance = 15000},
	{name = "prismatic bolt", chance = 15500, maxCount = 5},
	{name = "crystal crossbow", chance = 300}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300},
	{name ="orewalker wave", interval = 2000, chance = 15, minDamage = -296, maxDamage = -700, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1500, length = 6, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -800, maxDamage = -1080, radius = 3, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_SMALLPLANTS, target = true},
	{name ="drunk", interval = 2000, chance = 15, radius = 4, effect = CONST_ME_SOUND_PURPLE, target = false, duration = 6000},
	{name ="speed", interval = 2000, chance = 15, speedChange = -800, radius = 2, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000}
}

monster.defenses = {
	defense = 45,
	armor = 45
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 5},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 65},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 5},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
