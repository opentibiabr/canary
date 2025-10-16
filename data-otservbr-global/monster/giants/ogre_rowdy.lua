local mType = Game.createMonsterType("Ogre Rowdy")
local monster = {}

monster.description = "an ogre rowdy"
monster.experience = 4200
monster.outfit = {
	lookType = 1213,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1821
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Kilmaresh Central Steppe, Kilmaresh Southern Steppe, Green Belt, Kilmaresh Mountains underground.",
}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 31531
monster.speed = 210
monster.manaCost = 0

monster.faction = FACTION_ANUMA
monster.enemyFactions = { FACTION_PLAYER, FACTION_FAFNAR }

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 763, chance = 23000, maxCount = 9 }, -- flaming arrow
	{ id = 3032, chance = 23000 }, -- small emerald
	{ id = 3071, chance = 23000 }, -- wand of inferno
	{ id = 8093, chance = 23000 }, -- wand of draconia
	{ id = 22189, chance = 23000 }, -- ogre nose ring
	{ id = 22191, chance = 23000 }, -- skull fetish
	{ id = 22188, chance = 23000 }, -- ogre ear stud
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 8016, chance = 5000, maxCount = 2 }, -- jalapeno pepper
	{ id = 16120, chance = 5000 }, -- violet crystal shard
	{ id = 16119, chance = 5000 }, -- blue crystal shard
	{ id = 16115, chance = 5000 }, -- wand of everblazing
	{ id = 22193, chance = 5000 }, -- onyx chip
	{ id = 22194, chance = 5000 }, -- opal
	{ id = 24962, chance = 5000 }, -- prismatic quartz
	{ id = 22172, chance = 1000 }, -- ogre choppa
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -400, range = 5, radius = 4, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -450, radius = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_FIREDAMAGE, minDamage = -280, maxDamage = -420, range = 3, shootEffect = CONST_ANI_FLAMMINGARROW, target = true },
}

monster.defenses = {
	defense = 98,
	armor = 98,
	mitigation = 2.63,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
