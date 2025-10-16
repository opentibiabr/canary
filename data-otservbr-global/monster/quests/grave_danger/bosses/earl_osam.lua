local mType = Game.createMonsterType("Earl Osam")
local monster = {}

monster.description = "Earl Osam"
monster.experience = 55000
monster.outfit = {
	lookType = 1223,
	lookHead = 113,
	lookBody = 0,
	lookLegs = 79,
	lookFeet = 95,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"earl_osam_transform",
	"grave_danger_death",
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "venom"
monster.corpse = 31599
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1757,
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
	maxSummons = 4,
	summons = {
		{ name = "Frozen Soul", chance = 50, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I ... will ... get ... you ... all!", yell = false },
	{ text = "I ... will ... rise ... again!", yell = false },
}

monster.loot = {
	{ id = 22516, chance = 80000, maxCount = 2 }, -- silver token
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 23374, chance = 80000, maxCount = 20 }, -- ultimate spirit potion
	{ id = 23373, chance = 80000, maxCount = 20 }, -- ultimate mana potion
	{ id = 23375, chance = 80000, maxCount = 20 }, -- supreme health potion
	{ id = 3043, chance = 80000, maxCount = 3 }, -- crystal coin
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 5889, chance = 80000, maxCount = 3 }, -- piece of draconian steel
	{ id = 3037, chance = 80000, maxCount = 2 }, -- yellow gem
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 3038, chance = 80000, maxCount = 2 }, -- green gem
	{ id = 14043, chance = 80000 }, -- guardian axe
	{ id = 7439, chance = 80000, maxCount = 10 }, -- berserk potion
	{ id = 829, chance = 80000 }, -- glacier mask
	{ id = 3369, chance = 80000 }, -- warrior helmet
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 5888, chance = 80000, maxCount = 4 }, -- piece of hell steel
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 31590, chance = 80000 }, -- young lich worm
	{ id = 31577, chance = 80000 }, -- terra helmet
	{ id = 31579, chance = 80000 }, -- embrace of nature
	{ id = 31738, chance = 80000 }, -- final judgement
	{ id = 31589, chance = 80000 }, -- rotten heart
	{ id = 31594, chance = 80000 }, -- token of love
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 31588, chance = 80000 }, -- ancient liche bone
	{ id = 31578, chance = 80000 }, -- bear skin
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 30060, chance = 80000 }, -- giant emerald
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "ice chain", interval = 2500, chance = 25, minDamage = -260, maxDamage = -360, range = 3, target = true },
	{ name = "combat", interval = 3500, chance = 37, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 2, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 350, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
