local mType = Game.createMonsterType("Soul-Broken Harbinger")
local monster = {}

monster.description = "a Soul-Broken Harbinger"
monster.experience = 5800
monster.outfit = {
	lookType = 1137,
	lookHead = 85,
	lookBody = 10,
	lookLegs = 16,
	lookFeet = 83,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 1734
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Court of Winter."
	}

monster.health = 6300
monster.maxHealth = 6300
monster.race = "blood"
monster.corpse = 30137
monster.speed = 210
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
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 12},
	{id = 30058, chance = 15750, maxCount = 3}, -- ice flower
	{name = "dream essence egg", chance = 13700},
	{name = "elvish talisman", chance = 4790},
	{name = "knight legs", chance = 4450},
	{name = "glacier kilt", chance = 4110},
	{name = "glacier shoes", chance = 3770},
	{name = "ice rapier", chance = 3770},
	{name = "spellbook of mind control", chance = 2400},
	{name = "crown shield", chance = 1710},
	{name = "wood cape", chance = 1710},
	{id = 23529, chance = 1370}, -- ring of blue plasma
	{name = "tower shield", chance = 680},
	{id = 23543, chance = 680} -- collar of green plasma
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -120, range = 7, shootEffect = CONST_ANI_ARROW, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.reflects = {
	{type = COMBAT_ICEDAMAGE, percent = 70}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 55},
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
