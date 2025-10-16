local mType = Game.createMonsterType("Branchy Crawler")
local monster = {}

monster.description = "a branchy crawler"
monster.experience = 17860
monster.outfit = {
	lookType = 1297,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1931
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Rotten Wasteland.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 27000
monster.maxHealth = 27000
monster.race = "blood"
monster.corpse = 33809
monster.speed = 235
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	canPushCreatures = false,
	staticAttackChance = 90,
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
	{ text = "Bones are just sticks. They break easily.", yell = false },
	{ text = "Decay!", yell = false },
	{ text = "I'll make you crawl, too!", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 7643, chance = 23000, maxCount = 8 }, -- ultimate health potion
	{ id = 9058, chance = 23000 }, -- gold ingot
	{ id = 33938, chance = 23000 }, -- roots
	{ id = 812, chance = 5000 }, -- terra legs
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 33982, chance = 5000 }, -- crawlers essence
	{ id = 3038, chance = 1000 }, -- green gem
	{ id = 3041, chance = 1000 }, -- blue gem
	{ id = 3332, chance = 1000 }, -- hammer of wrath
	{ id = 7418, chance = 1000 }, -- nightmare blade
	{ id = 16163, chance = 1000 }, -- crystal crossbow
	{ id = 6553, chance = 260 }, -- ruthless axe
	{ id = 11657, chance = 260 }, -- twiceslicer
	{ id = 16160, chance = 260 }, -- crystalline sword
	{ id = 34109, chance = 260 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -950 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -1100, maxDamage = -1300, range = 7, shootEffect = CONST_ANI_PIERCINGBOLT, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_EARTHDAMAGE, minDamage = -1000, maxDamage = -1280, radius = 4, effect = CONST_ME_SMALLPLANTS, target = true },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_HOLYDAMAGE, minDamage = -1100, maxDamage = -1250, radius = 4, effect = CONST_ME_HOLYDAMAGE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HOLYDAMAGE, minDamage = -1100, maxDamage = -1400, range = 7, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "root", interval = 2000, chance = 1, target = true },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 3.04,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = -9 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval)
	monster:tryTeleportToPlayer("My growth is your death!")
end

mType:register(monster)
