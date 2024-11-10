local mType = Game.createMonsterType("Yaga the Crone")
local monster = {}

monster.description = "Yaga the Crone"
monster.experience = 375
monster.outfit = {
	lookType = 54,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 427,
	bossRace = RARITY_NEMESIS,
}

monster.health = 620
monster.maxHealth = 620
monster.race = "blood"
monster.corpse = 18306
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Where did I park my hut?", yell = false },
	{ text = "You will taste so sweet!", yell = false },
	{ text = "Hexipooh, bewitched are you!", yell = false },
}

monster.loot = {
	{ name = "cape", chance = 66000 },
	{ name = "broom", chance = 62500 },
	{ name = "cookie", chance = 62500, maxCount = 8 },
	{ name = "gold coin", chance = 29170, maxCount = 55 },
	{ name = "star herb", chance = 20833 },
	{ id = 3012, chance = 20833 }, -- wolf tooth chain
	{ name = "garlic necklace", chance = 8333 },
	{ name = "spellbook of mind control", chance = 8333 },
	{ name = "coat", chance = 4170 },
	{ name = "necrotic rod", chance = 4170 },
	{ name = "silver dagger", chance = 4170 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -50 },
	{ name = "combat", interval = 2500, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -30, maxDamage = -50, range = 5, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 3000, chance = 13, minDamage = -10, maxDamage = -10, range = 5, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "firefield", interval = 2000, chance = 13, range = 5, shootEffect = CONST_ANI_FIRE, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 15,
	--	mitigation = ???,
	{ name = "invisible", interval = 2000, chance = 18, effect = CONST_ME_MAGIC_RED },
	{ name = "outfit", interval = 4000, chance = 9, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000, outfitMonster = "green frog" },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 1 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
