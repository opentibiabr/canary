local mType = Game.createMonsterType("Urmahlullu the Weakened")
local monster = {}

monster.description = "Urmahlullu the Weakened"
monster.experience = 55000
monster.outfit = {
	lookType = 1197,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1811,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 100000
monster.maxHealth = 512000
monster.race = "blood"
monster.corpse = 31413
monster.speed = 95
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	staticAttackChance = 70,
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
	{ text = "You will regret this!", yell = false },
	{ text = "Now you have to die!", yell = false },
}

monster.loot = {
	{ name = "platinum coin", chance = 100000, maxCount = 9 },
	{ name = "green gem", chance = 100000, maxCount = 2 },
	{ name = "energy bar", chance = 100000 },
	{ name = "ultimate mana potion", chance = 73080, maxCount = 31 },
	{ name = "supreme health potion", chance = 53850, maxCount = 28 },
	{ id = 3039, chance = 53850, maxCount = 2 }, -- red gem
	{ name = "lightning pendant", chance = 30770 },
	{ name = "berserk potion", chance = 23080, maxCount = 15 },
	{ name = "bullseye potion", chance = 23080, maxCount = 15 },
	{ name = "magma coat", chance = 23080 },
	{ name = "royal star", chance = 19230, maxCount = 168 },
	{ name = "flash arrow", chance = 19230, maxCount = 175 },
	{ name = "ultimate spirit potion", chance = 19230, maxCount = 8 },
	{ name = "magma amulet", chance = 19230 },
	{ name = "gold ingot", chance = 19230 },
	{ name = "blue gem", chance = 15380 },
	{ name = "magma monocle", chance = 15380 },
	{ name = "yellow gem", chance = 15380 },
	{ name = "crystal coin", chance = 11540, maxCount = 5 },
	{ name = "silver token", chance = 7690, maxCount = 5 },
	{ name = "violet gem", chance = 7690 },
	{ name = "urmahlullu's paw", chance = 7690 },
	{ id = 281, chance = 7690 }, -- giant shimmering pearl
	{ name = "mastermind potion", chance = 3850 },
	{ name = "tagralt blade", chance = 1850 },
	{ name = "giant sapphire", chance = 3850 },
	{ id = 31263, chance = 3850 }, -- ring of secret thoughts
	{ name = "sunray emblem", chance = 3850 },
	{ name = "urmahlullu's mane", chance = 3850 },
	{ name = "winged boots", chance = 1850 },
	{ name = "urmahlullu's tail", chance = 6980 },
	{ name = "lightning legs", chance = 6400 },
	{ name = "giant emerald", chance = 3490 },
	{ name = "giant ruby", chance = 3490 },
	{ id = 30403, chance = 1740 }, -- enchanted theurgic amulet
	{ name = "sun medal", chance = 580 },
	{ name = "golden bijou", chance = 580 },
	{ name = "winged backpack", chance = 250 },
	{ name = "rainbow necklace", chance = 1160 },
	{ id = 30403, chance = 160 }, -- enchanted theurgic amulet
	{ name = "sun medal", chance = 160 },
	{ name = "sunray emblem", chance = 160 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -50, maxDamage = -1100 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, radius = 4, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -550, maxDamage = -800, radius = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "urmahlulluring", interval = 2000, chance = 18, minDamage = -450, maxDamage = -600, target = false },
}

monster.defenses = {
	defense = 84,
	armor = 84,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
