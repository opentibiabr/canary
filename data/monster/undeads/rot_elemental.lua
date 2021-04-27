local mType = Game.createMonsterType("Rot Elemental")
local monster = {}

monster.description = "a rot elemental"
monster.experience = 750
monster.outfit = {
	lookType = 615,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1055
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Rathleton Sewers, Glooth Factory, Lower Rathleton, Oramond/Western Plains, Jaccus Maxxen's Dungeon."
	}

monster.health = 850
monster.maxHealth = 850
monster.race = "venom"
monster.corpse = 23481
monster.speed = 230
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 2
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
	{text = "*glibb*", yell = false},
	{text = "*splib*", yell = false}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 80},
	{id = 2152, chance = 10390},
	{id = 7588, chance = 10310},
	{id = 7589, chance = 9990},
	{id = 23553, chance = 4320},
	{id = 2168, chance = 1630},
	{id = 2146, chance = 1110},
	{id = 9970, chance = 1140, maxCount = 2},
	{id = 2149, chance = 940, maxCount = 2},
	{id = 2155, chance = 80},
	{id = 23554, chance = 130},
	{id = 23551, chance = 60},
	{id = 23529, chance = 460}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 58, attack = 50, condition = {type = CONDITION_POISON, totalDamage = 280, interval = 4000}},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -250, range = 7, radius = 3, shootEffect = CONST_ANI_GLOOTHSPEAR, effect = CONST_ME_POISONAREA, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -230, length = 6, spread = 3, effect = CONST_ME_POISONAREA, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -200, maxDamage = -300, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true},
	{name ="rot elemental paralyze", interval = 2000, chance = 11, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 10,
	{name ="combat", interval = 2000, chance = 7, type = COMBAT_HEALING, minDamage = 40, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 9, speedChange = 470, effect = CONST_ME_SMOKE, target = false, duration = 7000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 30},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
