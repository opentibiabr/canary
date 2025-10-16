local mType = Game.createMonsterType("Spellreaper Inferniarch")
local monster = {}

monster.description = "a spellreaper inferniarch"
monster.experience = 8350
monster.outfit = {
	lookType = 1792,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2599
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Azzilon Castle Catacombs.",
}

monster.health = 11800
monster.maxHealth = 11800
monster.race = "fire"
monster.corpse = 49990
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "CHA..RAK!", yell = true },
	{ text = "Garrr!", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 34 }, -- platinum coin
	{ id = 3030, chance = 23000, maxCount = 4 }, -- small ruby
	{ id = 3731, chance = 23000 }, -- fire mushroom
	{ id = 3027, chance = 5000 }, -- black pearl
	{ id = 3071, chance = 5000 }, -- wand of inferno
	{ id = 24962, chance = 5000 }, -- prismatic quartz
	{ id = 49909, chance = 5000 }, -- demonic core essence
	{ id = 8074, chance = 1000 }, -- spellbook of mind control
	{ id = 49894, chance = 1000 }, -- demonic matter
	{ id = 49908, chance = 1000 }, -- mummified demon finger
	{ id = 50054, chance = 1000 }, -- spellreaper staff totem
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -150, maxDamage = -450, range = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 74,
	mitigation = 2.13,
}

monster.elements = {
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
