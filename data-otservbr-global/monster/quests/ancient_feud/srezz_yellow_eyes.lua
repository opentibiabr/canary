local mType = Game.createMonsterType("Srezz Yellow Eyes")
local monster = {}

monster.description = "Srezz Yellow Eyes"
monster.experience = 4800
monster.outfit = {
	lookType = 220,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1983,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 6200
monster.maxHealth = 6200
monster.race = "venom"
monster.corpse = 6061
monster.speed = 117
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 30,
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
	staticAttackChance = 80,
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
	{ id = 3035, chance = 100000, minCount = 1, maxCount = 17 }, -- platinum coin
	{ id = 7643, chance = 100000, minCount = 1, maxCount = 5 }, -- ultimate health potion
	{ id = 9694, chance = 25560, minCount = 1, maxCount = 3 }, -- snake skin
	{ id = 7440, chance = 17780 }, -- mastermind potion
	{ id = 9058, chance = 16110 }, -- gold ingot
	{ id = 16119, chance = 10560 }, -- blue crystal shard
	{ id = 282, chance = 10560 }, -- giant shimmering pearl (brown)
	{ id = 3027, chance = 10000 }, -- black pearl
	{ id = 3036, chance = 8330 }, -- violet gem
	{ id = 3038, chance = 7220 }, -- green gem
	{ id = 3041, chance = 6670 }, -- blue gem
	{ id = 24392, chance = 5560 }, -- gemmed figurine
	{ id = 10313, chance = 5000 }, -- winged tail
	{ id = 823, chance = 4440 }, -- glacier kilt
	{ id = 34103, chance = 3890 }, -- srezz' eye
	{ id = 5741, chance = 3330 }, -- skull helmet
	{ id = 824, chance = 2780 }, -- glacier robe
	{ id = 3342, chance = 2220 }, -- war axe
	{ id = 23531, chance = 1670 }, -- ring of green plasma
	{ id = 3281, chance = 1110 }, -- giant sword
	{ id = 7382, chance = 560 }, -- demonrage sword
	{ id = 3040, chance = 560 }, -- gold nugget
	{ id = 34258, chance = 360 }, -- red silk flower
	{ id = 33778, chance = 360 }, -- raw watermelon tourmaline
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -200 },
	{ name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2000, chance = 20, minDamage = -400, maxDamage = -500, range = 5, radius = 3, spread = 3, target = true, shootEffect = CONST_ANI_POISON, effect = CONST_ME_YELLOW_RINGS },
	{ name = "lleech waveT", interval = 2000, chance = 30, minDamage = -200, maxDamage = -300 },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 30, minDamage = -200, maxDamage = -300, length = 5, spread = 3, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 70, minDamage = -200, maxDamage = -350, radius = 4, target = false, effect = CONST_ME_DRAWBLOOD },
}

monster.defenses = {
	defense = 35,
	armor = 35,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 340, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
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
