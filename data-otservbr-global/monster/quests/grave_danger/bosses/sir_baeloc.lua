local mType = Game.createMonsterType("Sir Baeloc")
local monster = {}

monster.description = "Sir Baeloc"
monster.experience = 55000
monster.outfit = {
	lookType = 1222,
	lookHead = 57,
	lookBody = 81,
	lookLegs = 3,
	lookFeet = 93,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "venom"
monster.corpse = 31599
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"BossHealthCheck",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1755,
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
	maxSummons = 3,
	summons = {
		{ name = "Retainer of Baeloc", chance = 20, interval = 2000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 22516, chance = 80000, maxCount = 2 }, -- silver token
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 23374, chance = 80000, maxCount = 20 }, -- ultimate spirit potion
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 5888, chance = 80000, maxCount = 4 }, -- piece of hell steel
	{ id = 23375, chance = 80000, maxCount = 20 }, -- supreme health potion
	{ id = 23373, chance = 80000, maxCount = 20 }, -- ultimate mana potion
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 3371, chance = 80000 }, -- knight legs
	{ id = 827, chance = 80000 }, -- magma monocle
	{ id = 31588, chance = 80000 }, -- ancient liche bone
	{ id = 7439, chance = 80000, maxCount = 10 }, -- berserk potion
	{ id = 5887, chance = 80000 }, -- piece of royal steel
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 31590, chance = 80000 }, -- young lich worm
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 31738, chance = 80000 }, -- final judgement
	{ id = 31577, chance = 80000 }, -- terra helmet
	{ id = 31592, chance = 80000 }, -- signet ring
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 31578, chance = 80000 }, -- bear skin
	{ id = 31589, chance = 80000 }, -- rotten heart
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 30059, chance = 80000 }, -- giant ruby
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 3100, chance = 37, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 0, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "combat", interval = 2500, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -625, range = 5, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_DRAWBLOOD, target = true },
	{ name = "combat", interval = 2700, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -180, maxDamage = -250, range = 1, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 350, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 35 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
