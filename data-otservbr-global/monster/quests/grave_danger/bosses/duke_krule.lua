local mType = Game.createMonsterType("Duke Krule")
local monster = {}

monster.description = "Duke Krule"
monster.experience = 55000
monster.outfit = {
	lookType = 1221,
	lookHead = 8,
	lookBody = 8,
	lookLegs = 19,
	lookFeet = 79,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
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
	bossRaceId = 1758,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Soul Scourge", chance = 20, interval = 2000, count = 4 },
	},
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 3043, chance = 80000, maxCount = 2 }, -- crystal coin
	{ id = 23373, chance = 80000, maxCount = 20 }, -- ultimate mana potion
	{ id = 23375, chance = 80000, maxCount = 20 }, -- supreme health potion
	{ id = 23374, chance = 80000, maxCount = 14 }, -- ultimate spirit potion
	{ id = 5888, chance = 80000, maxCount = 4 }, -- piece of hell steel
	{ id = 7439, chance = 80000, maxCount = 10 }, -- berserk potion
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 830, chance = 80000 }, -- terra hood
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 3391, chance = 80000 }, -- crusader helmet
	{ id = 5885, chance = 80000 }, -- flask of warriors sweat
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 31590, chance = 80000 }, -- young lich worm
	{ id = 31588, chance = 80000 }, -- ancient liche bone
	{ id = 22516, chance = 80000, maxCount = 3 }, -- silver token
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 31579, chance = 80000 }, -- embrace of nature
	{ id = 31589, chance = 1000 }, -- rotten heart
	{ id = 31595, chance = 1000 }, -- noble amulet
	{ id = 31578, chance = 1000 }, -- bear skin
	{ id = 31577, chance = 1000 }, -- terra helmet
	{ id = 31738, chance = 260 }, -- final judgement
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 3500, chance = 37, type = COMBAT_PHYSICALDAMAGE, minDamage = -700, maxDamage = -1200, length = 7, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 4200, chance = 40, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -500, radius = 9, effect = CONST_ME_HITBYFIRE, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HEALING, minDamage = 150, maxDamage = 350, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
