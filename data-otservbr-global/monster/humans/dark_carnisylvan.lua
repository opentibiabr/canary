local mType = Game.createMonsterType("Dark Carnisylvan")
local monster = {}

monster.description = "a dark carnisylvan"
monster.experience = 4400
monster.outfit = {
	lookType = 1418,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 0,
	lookFeet = 19,
	lookAddons = 2,
	lookMount = 0
}

monster.raceId = 2109
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Forest of Life"
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "venom"
monster.corpse = 36892
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25
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
	{text = "Ssshhh!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 70000, maxCount = 19},
	{id = 3115, chance = 39690, maxCount = 1}, -- bone
	{name = "carnisylvan finger", chance = 17490, maxCount = 4},
	{name = "carnisylvan bark", chance = 11490, maxCount = 5},
	{name = "great mana potion", chance = 9660, maxCount = 4},
	{name = "underworld rod", chance = 4440},
	{name = "wand of starstorm", chance = 3660},
	{name = "hailstorm rod", chance = 3660},
	{name = "springsprout rod", chance = 2610},
	{id = 3059, chance = 2350}, -- spellbook
	{name = "spellbook of warding", chance = 3390},
	{name = "gold ring", chance = 780},
	{name = "butterfly ring", chance = 520},
	{name = "human teeth", chance = 1040}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300},
	{name ="combat", interval = 2700, chance = 40, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -500, range = 2, radius = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="combat", interval = 2000, chance = 70, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -450, range = 5, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_POISONAREA, target = true},
}

monster.defenses = {
	defense = 41,
	armor = 41,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 80, maxDamage = 210, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 10, speedChange = 330, effect = CONST_ME_HITAREA, target = false, duration = 8000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = -20},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 100},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
