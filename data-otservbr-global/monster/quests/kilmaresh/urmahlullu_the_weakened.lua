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
	{ id = 3035, chance = 80000, maxCount = 9 }, -- platinum coin
	{ id = 23535, chance = 80000 }, -- energy bar
	{ id = 23375, chance = 80000, maxCount = 20 }, -- supreme health potion
	{ id = 23373, chance = 80000, maxCount = 20 }, -- ultimate mana potion
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 23374, chance = 80000, maxCount = 7 }, -- ultimate spirit potion
	{ id = 36706, chance = 80000, maxCount = 2 }, -- red gem
	{ id = 761, chance = 80000, maxCount = 100 }, -- flash arrow
	{ id = 25759, chance = 80000, maxCount = 100 }, -- royal star
	{ id = 816, chance = 80000 }, -- lightning pendant
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 7439, chance = 80000, maxCount = 12 }, -- berserk potion
	{ id = 826, chance = 80000 }, -- magma coat
	{ id = 3041, chance = 80000, maxCount = 2 }, -- blue gem
	{ id = 3043, chance = 80000, maxCount = 3 }, -- crystal coin
	{ id = 817, chance = 80000 }, -- magma amulet
	{ id = 7440, chance = 80000, maxCount = 18 }, -- mastermind potion
	{ id = 30403, chance = 80000 }, -- enchanted theurgic amulet
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 22516, chance = 80000, maxCount = 5 }, -- silver token
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 827, chance = 80000 }, -- magma monocle
	{ id = 31306, chance = 80000 }, -- ring of secret thoughts
	{ id = 31623, chance = 80000 }, -- urmahlullus mane
	{ id = 31624, chance = 80000 }, -- urmahlullus paw
	{ id = 31622, chance = 80000 }, -- urmahlullus tail
	{ id = 31614, chance = 80000 }, -- tagralt blade
	{ id = 30323, chance = 80000 }, -- rainbow necklace
	{ id = 31617, chance = 80000 }, -- winged boots
	{ id = 31572, chance = 80000 }, -- blue and golden cordon
	{ id = 31575, chance = 80000 }, -- golden bijou
	{ id = 31573, chance = 80000 }, -- sun medal
	{ id = 31625, chance = 80000 }, -- winged backpack
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 31557, chance = 80000 }, -- enchanted blister ring
	{ id = 31574, chance = 80000 }, -- sunray emblem
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
