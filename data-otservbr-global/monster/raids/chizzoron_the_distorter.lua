local mType = Game.createMonsterType("Chizzoron the Distorter")
local monster = {}

monster.description = "Chizzoron the Distorter"
monster.experience = 4000
monster.outfit = {
	lookType = 340,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 629,
	bossRace = RARITY_NEMESIS,
}

monster.health = 16000
monster.maxHealth = 16000
monster.race = "blood"
monster.corpse = 10399
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	rewardBoss = true,
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
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Lizard Dragon Priest", chance = 10, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Humanzzz! Leave Zzaion at onzzzze!", yell = false },
	{ text = "I pray to my mazzterzz, the mighty dragonzzz!", yell = false },
	{ text = "You are not worzzy to touch zzizz zzacred ground!", yell = false },
}

monster.loot = {
	{ id = 9058, chance = 71550, maxCount = 2 }, -- gold ingot
	{ id = 3031, chance = 69825, maxCount = 100 }, -- gold coin
	{ id = 3031, chance = 69825, maxCount = 10 }, -- gold coin
	{ id = 3032, chance = 5750 }, -- small emerald
	{ id = 5881, chance = 100000 }, -- lizard scale
	{ id = 3038, chance = 16300 }, -- green gem
	{ id = 3053, chance = 11025 }, -- time ring
	{ id = 239, chance = 5750 }, -- great health potion
	{ id = 3386, chance = 5750 }, -- dragon scale mail
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 60, attack = 130 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -430, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -874, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -646, radius = 3, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -148, maxDamage = -250, range = 7, effect = CONST_ME_MAGIC_RED, target = true },
}

monster.defenses = {
	defense = 85,
	armor = 70,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
