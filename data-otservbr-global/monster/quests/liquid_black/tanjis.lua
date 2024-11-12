local mType = Game.createMonsterType("Tanjis")
local monster = {}

monster.description = "Tanjis"
monster.experience = 15000
monster.outfit = {
	lookType = 446,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DeeplingBossDeath",
}

monster.bosstiary = {
	bossRaceId = 775,
	bossRace = RARITY_BANE,
}

monster.health = 30000
monster.maxHealth = 30000
monster.race = "blood"
monster.corpse = 13801
monster.speed = 280
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 50,
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
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 60,
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
	{ text = "JAU QJELL, JAKHN JEH KENH!!", yell = true },
}

monster.loot = {
	{ name = "depth ocrea", chance = 1200 },
	{ name = "ornate mace", chance = 1100, unique = true },
	{ name = "ornate shield", chance = 1100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_MANADRAIN, minDamage = -200, maxDamage = -600, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_CARNIPHILA, target = true },
	{ name = "combat", interval = 3500, chance = 27, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -400, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 3500, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -400, range = 1, radius = 1, target = true },
	{ name = "combat", interval = 2300, chance = 11, type = COMBAT_DROWNDAMAGE, minDamage = -200, maxDamage = -500, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_WATERSPLASH, target = true },
	{ name = "combat", interval = 2300, chance = 14, type = COMBAT_MANADRAIN, minDamage = -200, maxDamage = -600, range = 7, radius = 7, effect = CONST_ME_BUBBLES, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -400, range = 7, radius = 1, shootEffect = CONST_ANI_LARGEROCK, target = true },
	{ name = "combat", interval = 1200, chance = 7, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -500, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "speed", interval = 2150, chance = 16, speedChange = -600, range = 7, radius = 1, target = true, duration = 15000 },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 40, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
