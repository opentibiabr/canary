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
	"azaram_health",
	"azaram_summon",
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
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 22516, chance = 80000, maxCount = 2 }, -- silver token
	{ id = 23374, chance = 80000, maxCount = 20 }, -- ultimate spirit potion
	{ id = 23373, chance = 80000, maxCount = 14 }, -- ultimate mana potion
	{ id = 23375, chance = 80000, maxCount = 14 }, -- supreme health potion
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3370, chance = 80000 }, -- knight armor
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 5888, chance = 80000, maxCount = 4 }, -- piece of hell steel
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 7439, chance = 80000, maxCount = 10 }, -- berserk potion
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 3038, chance = 80000, maxCount = 2 }, -- green gem
	{ id = 828, chance = 80000 }, -- lightning headband
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 31578, chance = 80000 }, -- bear skin
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 31590, chance = 80000 }, -- young lich worm
	{ id = 31579, chance = 80000 }, -- embrace of nature
	{ id = 31578, chance = 80000 }, -- bear skin
	{ id = 31577, chance = 80000 }, -- terra helmet
	{ id = 31588, chance = 80000 }, -- ancient liche bone
	{ id = 31589, chance = 80000 }, -- rotten heart
	{ id = 31738, chance = 80000 }, -- final judgement
	{ id = 31593, chance = 80000 }, -- noble cape
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 7407, chance = 80000 }, -- haunted blade
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 30061, chance = 80000 }, -- giant sapphire
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
