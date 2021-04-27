local mType = Game.createMonsterType("Phantasm")
local monster = {}

monster.description = "a phantasm"
monster.experience = 4400
monster.outfit = {
	lookType = 241,
	lookHead = 20,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 292
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, The Inquisition Quest, Deeper Banuta."
	}

monster.health = 3950
monster.maxHealth = 3950
monster.race = "undead"
monster.corpse = 6344
monster.speed = 340
monster.manaCost = 0
monster.maxSummons = 4

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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 350,
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

monster.summons = {
	{name = "Phantasm Summon", chance = 20, interval = 2000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Oh my, you forgot to put your pants on!", yell = false},
	{text = "Weeheeheeheehee!", yell = false},
	{text = "Its nothing but a dream.", yell = false},
	{text = "Dream a little dream with me!", yell = false},
	{text = "Give in.", yell = false}
}

monster.loot = {
	{name = "small ruby", chance = 12160, maxCount = 3},
	{name = "gold coin", chance = 30000, maxCount = 100},
	{name = "gold coin", chance = 30000, maxCount = 100},
	{name = "gold coin", chance = 28000, maxCount = 33},
	{name = "small emerald", chance = 10190, maxCount = 3},
	{name = "small amethyst", chance = 14570, maxCount = 3},
	{name = "platinum coin", chance = 87730, maxCount = 4},
	{name = "stealth ring", chance = 550},
	{name = "blank rune", chance = 22500, maxCount = 2},
	{name = "crown armor", chance = 660},
	{name = "shadow herb", chance = 26930, maxCount = 2},
	{id = 6300, chance = 330},
	{name = "demonic essence", chance = 16320},
	{name = "abyss hammer", chance = 110},
	{name = "shadow sceptre", chance = 550},
	{name = "great mana potion", chance = 32750, maxCount = 2},
	{name = "ultimate health potion", chance = 14680},
	{name = "small topaz", chance = 12810, maxCount = 3}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -475},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -610, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -5, maxDamage = -80, radius = 3, effect = CONST_ME_YELLOW_RINGS, target = false},
	{name ="phantasm drown", interval = 2000, chance = 15, target = false},
	{name ="drunk", interval = 2000, chance = 15, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000}
}

monster.defenses = {
	defense = 0,
	armor = 0,
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 228, maxDamage = 449, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 10, speedChange = 500, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000},
	{name ="invisible", interval = 2000, chance = 25, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
