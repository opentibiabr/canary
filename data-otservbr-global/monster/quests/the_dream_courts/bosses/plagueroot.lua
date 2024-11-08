local mType = Game.createMonsterType("Plagueroot")
local monster = {}

monster.description = "Plagueroot"
monster.experience = 55000
monster.outfit = {
	lookType = 1121,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DreamCourtsBossDeath",
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "venom"
monster.corpse = 30022
monster.speed = 85
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1695,
	bossRace = RARITY_NEMESIS,
	storage = Storage.Quest.U12_00.TheDreamCourts.ArenaTimer,
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
	{ name = "platinum coin", chance = 100000, maxCount = 5 },
	{ name = "silver token", chance = 100000, maxCount = 3 },
	{ name = "mysterious remains", chance = 100000 },
	{ name = "huge chunk of crude iron", chance = 100000 },
	{ name = "piggy bank", chance = 100000 },
	{ name = "energy bar", chance = 100000 },
	{ name = "royal star", chance = 80000, maxCount = 184 },
	{ name = "ultimate mana potion", chance = 80000, maxCount = 22 },
	{ name = "supreme health potion", chance = 60000, maxCount = 13 },
	{ name = "gold token", chance = 60000, maxCount = 3 },
	{ id = 3039, chance = 60000 }, -- red gem
	{ name = "mastermind potion", chance = 40000, maxCount = 13 },
	{ name = "crunor idol", chance = 40000 },
	{ name = "bullseye potion", chance = 20000 },
	{ name = "ultimate spirit potion", chance = 20000 },
	{ name = "berserk potion", chance = 20000 },
	{ name = "gold ingot", chance = 20000 },
	{ name = "violet gem", chance = 20000 },
	{ name = "pomegranate", chance = 20000 },
	{ name = "blue gem", chance = 20000 },
	{ id = 282, chance = 20000 }, -- giant shimmering pearl
	{ name = "plagueroot offshoot", chance = 20000 },
	{ name = "skull staff", chance = 20000 },
	{ name = "platinum coin", chance = 100000 },
	{ name = "silver token", chance = 95920, maxCount = 5 },
	{ name = "piggy bank", chance = 93880 },
	{ name = "mysterious remains", chance = 91840 },
	{ name = "energy bar", chance = 87760 },
	{ name = "gold token", chance = 61220 },
	{ name = "ultimate spirit potion", chance = 59180, maxCount = 20 },
	{ name = "ultimate mana potion", chance = 57140, maxCount = 20 },
	{ name = "royal star", chance = 48980 },
	{ name = "supreme health potion", chance = 46940, maxCount = 20 },
	{ name = "yellow gem", chance = 40820, maxCount = 2 },
	{ name = "huge chunk of crude iron", chance = 38780 },
	{ name = "crystal coin", chance = 26530, maxCount = 3 },
	{ name = "mastermind potion", chance = 22450 },
	{ name = "gold ingot", chance = 22450 },
	{ name = "bullseye potion", chance = 20410 },
	{ name = "berserk potion", chance = 16329 },
	{ name = "skull staff", chance = 16329 },
	{ name = "pomegranate", chance = 16329 },
	{ id = 23542, chance = 14290 }, -- collar of blue plasma
	{ name = "blue gem", chance = 12240 },
	{ name = "green gem", chance = 12240 },
	{ id = 23529, chance = 10200 }, -- ring of blue plasma
	{ name = "violet gem", chance = 8160, maxCount = 2 },
	{ id = 23543, chance = 8160 }, -- collar of green plasma
	{ id = 23544, chance = 8160 }, -- collar of red plasma
	{ id = 23531, chance = 8160 }, -- ring of green plasma
	{ id = 23533, chance = 6120 }, -- ring of red plasma
	{ name = "chaos mace", chance = 6120 },
	{ name = "plagueroot offshoot", chance = 6120 },
	{ name = "magic sulphur", chance = 6120 },
	{ name = "living vine bow", chance = 4080 },
	{ name = "giant emerald", chance = 4080 },
	{ name = "soul stone", chance = 4080 },
	{ name = "living armor", chance = 4080 },
	{ name = "turquoise tendril lantern", chance = 2040 },
	{ name = "ring of the sky", chance = 2040 },
	{ name = "abyss hammer", chance = 2040 },
	{ id = 3341, chance = 3130 }, -- arcane staff
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 210, attack = -560 },
	-- fire
	{ name = "condition", type = CONDITION_FIRE, interval = 1000, chance = 7, minDamage = -200, maxDamage = -1000, range = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 1000, chance = 7, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -1050, radius = 6, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 1000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -20, maxDamage = -100, radius = 5, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "firefield", interval = 1000, chance = 4, radius = 8, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -650, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -600, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -600, length = 8, spread = 0, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 500, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 200, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 10, speedChange = 1800, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 1 },
	{ type = COMBAT_EARTHDAMAGE, percent = 120 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
