local mType = Game.createMonsterType("Lavafungus")
local monster = {}

monster.description = "a lavafungus"
monster.experience = 6200
monster.outfit = {
	lookType = 1405,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 2095
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Grotto of the Lost"
}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "blood"
monster.corpse = 36764
monster.speed = 115
monster.manaCost = 0

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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Kazzzzzzuuum!", yell = false},
	{text = "Fissziss!", yell = false},
	{text = "Zzzzzooom!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 70000, maxCount = 22},
	{name = "terra rod", chance = 41860, maxCount = 1},
	{name = "lavafungus ring", chance = 9300, maxCount = 4},
	{id = 3039, chance = 9300, maxCount = 1}, -- red gem
	{name = "hailstorm rod", chance = 4650},
	{name = "blue crystal shard", chance = 4000},
	{name = "violet gem", chance = 4650},
	{name = "wand of inferno", chance = 4650},
	{name = "green gem", chance = 9300},
	{name = "lavafungus head", chance = 4650},
	{name = "cyan crystal fragment", chance = 4650},
	{name = "violet crystal shard", chance = 3650},
	{name = "red crystal fragment", chance = 4650},
	{name = "rainbow quartz", chance = 6980},
	{name = "onyx chip", chance = 4650},
	{name = "yellow gem", chance = 2330},
	{name = "green crystal fragment", chance = 9300},
	{name = "metal spats", chance = 6980},
	{name = "spellbook of warding", chance = 2500},
	{name = "magma amulet", chance = 2330},
	{name = "focus cape", chance = 2330},
	{name = "wand of starstorm", chance = 2330},
	{name = "crystal mace", chance = 1700},
	{id = 3097, chance = 2330} -- dwarven ring
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -810},
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_DEATHDAMAGE, minDamage = -560, maxDamage = -650, length = 6, spread = 0, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2750, chance = 40, type = COMBAT_FIREDAMAGE, minDamage = -490, maxDamage = -720, range = 5, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 2750, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -720, maxDamage = -810, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="lavafungus ring", interval = 2000, chance = 20, minDamage = -450, maxDamage = -610},
	{name ="lavafungus x wave", interval = 2000, chance = 10, minDamage = -640, maxDamage = -730},
}

monster.defenses = {
	defense = 70,
	armor = 70,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 270, maxDamage = 530, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 100},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
