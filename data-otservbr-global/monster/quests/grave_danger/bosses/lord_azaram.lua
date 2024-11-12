local mType = Game.createMonsterType("Lord Azaram")
local monster = {}

monster.description = "Lord Azaram"
monster.experience = 55000
monster.outfit = {
	lookType = 1223,
	lookHead = 19,
	lookBody = 2,
	lookLegs = 94,
	lookFeet = 81,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"GraveDangerBossDeath",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "venom"
monster.corpse = 31599
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1756,
	bossRace = RARITY_ARCHFOE,
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

monster.summon = {
	maxSummons = 5,
	summons = {
		{ name = "Condensed Sins", chance = 50, interval = 2000, count = 5 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ name = "platinum coin", minCount = 1, maxCount = 5, chance = 100000 },
	{ name = "crystal coin", minCount = 0, maxCount = 2, chance = 50000 },
	{ name = "supreme health potion", minCount = 0, maxCount = 6, chance = 35000 },
	{ name = "ultimate mana potion", minCount = 0, maxCount = 20, chance = 32000 },
	{ name = "ultimate spirit potion", minCount = 0, maxCount = 20, chance = 32000 },
	{ name = "bullseye potion", minCount = 0, maxCount = 10, chance = 12000 },
	{ name = "berserk potion", minCount = 0, maxCount = 10, chance = 12000 },
	{ name = "piece of hell steel", minCount = 0, maxCount = 4, chance = 9000 },
	{ id = 3039, minCount = 0, maxCount = 2, chance = 12000 }, -- red gem
	{ name = "blue gem", minCount = 0, maxCount = 2, chance = 12000 },
	{ name = "silver token", minCount = 0, maxCount = 2, chance = 9500 },
	{ name = "ancient liche bone", chance = 5200 },
	{ id = 23542, chance = 5200 }, -- collar of blue plasma
	{ id = 23544, chance = 5200 }, -- collar of red plasma
	{ id = 23543, chance = 5200 }, -- collar of green plasma
	{ name = "giant sapphire", chance = 7000 },
	{ name = "haunted blade", chance = 9000 },
	{ name = "huge chunk of crude iron", chance = 4500 },
	{ name = "knight armor", chance = 15000 },
	{ name = "violet gem", minCount = 0, maxCount = 1, chance = 10000 },
	{ name = "yellow gem", minCount = 0, maxCount = 1, chance = 10000 },
	{ id = 23531, chance = 5000 }, -- ring of green plasma
	{ id = 23533, chance = 5000 }, -- ring of red plasma
	{ name = "young lich worm", chance = 5800 },
	{ name = "bear skin", chance = 1600 },
	{ name = "noble cape", chance = 1500 },
	{ name = "terra helmet", chance = 720 },
	{ name = "final judgement", chance = 410 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000, effect = CONST_ME_DRAWBLOOD },
	{ name = "lord azaram wave", interval = 3500, chance = 50, minDamage = -360, maxDamage = -900 },
	{ name = "combat", interval = 2700, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -1200, length = 7, spread = 0, effect = CONST_ME_STONES, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
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
