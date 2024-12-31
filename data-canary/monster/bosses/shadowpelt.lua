local mType = Game.createMonsterType("Shadowpelt")
local monster = {}

monster.description = "a shadowpelt"
monster.experience = 4000
monster.outfit = {
	lookType = 1040,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5000
monster.maxHealth = 5000
monster.race = "blood"
monster.corpse = 27722
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 11,
}

monster.bosstiary = {
	bossRaceId = 1561,
	bossRace = RARITY_ARCHFOE,
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
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Werebear", chance = 20, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The strength of bears will subdue the weak!", yell = false },
	{ text = "It was a mistake to enter my cave!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 13600000, maxCount = 200 },
	{ name = "gold coin", chance = 13600000, maxCount = 100 },
	{ name = "platinum coin", chance = 13600000, maxCount = 5 },
	{ name = "black pearl", chance = 13600000, maxCount = 2 },
	{ name = "ham", chance = 13600000, maxCount = 2 },
	{ name = "opal", chance = 13600000, maxCount = 2 },
	{ name = "small enchanted sapphire", chance = 13600000, maxCount = 2 },
	{ name = "bear paw", chance = 13600000, maxCount = 2 },
	{ name = "furry club", chance = 13600000 },
	{ id = 281, chance = 5000 }, -- giant shimmering pearl (green)
	{ name = "great health potion", chance = 13600000, maxCount = 5 },
	{ name = "honeycomb", chance = 13600000, maxCount = 2 },
	{ name = "spiked squelcher", chance = 13600000 },
	{ name = "ultimate health potion", chance = 13600000, maxCount = 5 },
	{ name = "werebear fur", chance = 13600000, maxCount = 2 },
	{ name = "werebear skull", chance = 13600000, maxCount = 2 },
	{ name = "dreaded cleaver", chance = 550 },
	{ name = "fur armor", chance = 550 },
	{ name = "relic sword", chance = 550 },
	{ name = "silver token", chance = 150 },
	{ id = 22103, chance = 150 }, -- werebear trophy
	{ name = "wolf backpack", chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 50, attack = 50 },
	{ name = "combat", interval = 100, chance = 22, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -310, radius = 3, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "outfit", interval = 1000, chance = 1, radius = 1, target = true, duration = 2000, outfitMonster = "Werebear" },
	{ name = "combat", interval = 100, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -200, radius = 3, effect = CONST_ME_SOUND_WHITE, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{ name = "combat", interval = 2000, chance = 7, type = COMBAT_HEALING, minDamage = 120, maxDamage = 310, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = 520, effect = CONST_ME_POFF, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
