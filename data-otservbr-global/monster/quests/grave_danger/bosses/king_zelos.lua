local mType = Game.createMonsterType("King Zelos")
local monster = {}

monster.description = "King Zelos"
monster.experience = 75000
monster.outfit = {
	lookType = 1224,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 480000
monster.maxHealth = 480000
monster.race = "venom"
monster.corpse = 31611
monster.speed = 212

monster.events = {
	"zelos_damage",
	"zelos_init",
	"grave_danger_death",
}

monster.bosstiary = {
	bossRaceId = 1784,
	bossRace = RARITY_ARCHFOE,
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.loot = {
	{ id = 3043, chance = 80000, maxCount = 12 }, -- crystal coin
	{ id = 22516, chance = 80000, maxCount = 4 }, -- silver token
	{ id = 22721, chance = 80000, maxCount = 3 }, -- gold token
	{ id = 23374, chance = 80000, maxCount = 14 }, -- ultimate spirit potion
	{ id = 23373, chance = 80000, maxCount = 14 }, -- ultimate mana potion
	{ id = 23375, chance = 80000, maxCount = 14 }, -- supreme health potion
	{ id = 5909, chance = 80000, maxCount = 4 }, -- white piece of cloth
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 7439, chance = 80000, maxCount = 10 }, -- berserk potion
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 3037, chance = 80000, maxCount = 2 }, -- yellow gem
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 14112, chance = 80000 }, -- bar of gold
	{ id = 3381, chance = 80000 }, -- crown armor
	{ id = 5885, chance = 80000 }, -- flask of warriors sweat
	{ id = 11674, chance = 80000 }, -- cobra crown
	{ id = 2852, chance = 80000 }, -- red tome
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 825, chance = 80000 }, -- lightning robe
	{ id = 811, chance = 80000 }, -- terra mantle
	{ id = 3079, chance = 80000 }, -- boots of haste
	{ id = 31580, chance = 80000 }, -- mortal mace
	{ id = 31582, chance = 80000 }, -- galea mortis
	{ id = 31581, chance = 80000 }, -- bow of cataclysm
	{ id = 31737, chance = 80000 }, -- shadow cowl
	{ id = 31583, chance = 80000 }, -- toga mortis
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 824, chance = 80000 }, -- glacier robe
	{ id = 31588, chance = 80000 }, -- ancient liche bone
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 31589, chance = 80000 }, -- rotten heart
	{ id = 31590, chance = 80000 }, -- young lich worm
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 826, chance = 80000 }, -- magma coat
	{ id = 12543, chance = 80000 }, -- golden hyaena pendant
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 7414, chance = 80000 }, -- abyss hammer
	{ id = 30056, chance = 80000 }, -- ornate locket
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 5884, chance = 80000 }, -- spirit container
	{ id = 24392, chance = 80000 }, -- gemmed figurine
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, minDamage = -900, maxDamage = -2700 },
	{ name = "combat", type = COMBAT_FIREDAMAGE, interval = 2000, chance = 15, length = 8, spread = 0, minDamage = -1200, maxDamage = -3200, effect = CONST_ME_HITBYFIRE },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 10, length = 8, spread = 0, minDamage = -600, maxDamage = -1600, effect = CONST_ME_SMALLCLOUDS },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2000, chance = 30, radius = 6, minDamage = -1200, maxDamage = -1500, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2000, chance = 20, length = 8, minDamage = -1700, maxDamage = -2000, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 130,
	armor = 130,
	{ name = "combat", type = COMBAT_HEALING, chance = 15, interval = 2000, minDamage = 1450, maxDamage = 5350, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 3 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "invisible", condition = true },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Feel the power of death unleashed!", yell = false },
	{ text = "I will rule again and my realm of death will span the world!", yell = false },
	{ text = "My lich-knights will conquer this world for me!", yell = false },
}

mType:register(monster)
