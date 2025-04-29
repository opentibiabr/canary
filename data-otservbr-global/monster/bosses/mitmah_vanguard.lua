local mType = Game.createMonsterType("Mitmah Vanguard")
local monster = {}

monster.description = "Mitmah Vanguard"
monster.experience = 300000
monster.outfit = {
	lookType = 1716,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2464,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 250000
monster.maxHealth = 250000
monster.race = "blood"
monster.corpse = 44687
monster.speed = 450
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20,
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
	staticAttackChance = 95,
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
	{ text = "Die, human. Now!", yell = true },
	{ text = "FEAR THE CURSE!", yell = true },
	{ text = "You're the intruder.", yell = true },
	{ text = "The Iks have always been ours.", yell = true },
	{ text = "NOW TREMBLE!", "GOT YOU NOW!", yell = true },
}

monster.loot = {
	{ name = "gold coin", chance = 895000, maxCount = 400 },
	{ name = "platinum coin", chance = 655000, maxCount = 15 },
	{ name = "crystal coin", chance = 325000, maxCount = 5 },
	{ name = "great health potion", chance = 288900, maxCount = 15 },
	{ name = "great mana potion", chance = 281500 },
	{ name = "great spirit potion", chance = 65337, maxCount = 45 },
	{ name = "ultimate health potion", chance = 214800, maxCount = 12 },
	{ name = "ultimate mana potion", chance = 155600, maxCount = 15 },
	{ name = "supreme health potion", chance = 33385, maxCount = 23 },
	{ name = "yellow gem", chance = 11604, maxCount = 5 },
	{ name = "blue gem", chance = 14144, maxCount = 5 },
	{ name = "green gem", chance = 11221, maxCount = 4 },
	{ name = "giant topaz", chance = 11191, maxCount = 1 },
	{ name = "giant emerald", chance = 11191, maxCount = 1 },
	{ name = "giant sapphire", chance = 11191, maxCount = 1 },
	{ name = "giant amethyst", chance = 12527, maxCount = 1 },
	{ name = "white gem", chance = 311100 },
	{ name = "yellow gem", chance = 251900 },
	{ name = "blue gem", chance = 222200 },
	{ name = "crystal of the mitmah", chance = 451900 },
	{ name = "broken mitmah necklace", chance = 548100 },
	{ name = "broken mitmah chestplate", chance = 44400 },
	{ name = "splintered mitmah gem", chance = 3700 },
	{ name = "stoic iks boots", chance = 500 },
	{ name = "stoic iks faulds", chance = 500 },
	{ name = "stoic iks casque", chance = 500 },
	{ name = "stoic iks cuirass", chance = 500 },
	{ name = "stoic iks chestplate", chance = 500 },
	{ name = "stoic iks sandals", chance = 500 },
	{ name = "stoic iks headpiece", chance = 500 },
	{ name = "stoic iks culet", chance = 500 },
}

monster.attacks = {
	{ name = "melee", interval = 1700, chance = 100, minDamage = -400, maxDamage = -856 },
	{ name = "melee", interval = 2500, chance = 100, minDamage = -500, maxDamage = -1256 },
	{ name = "hugeblackring", interval = 3500, chance = 20, minDamage = -700, maxDamage = -1500, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -4500, maxDamage = -6000, radius = 9, effect = CONST_ME_SLASH, target = false },
	{ name = "combat", interval = 2500, chance = 33, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -1500, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -600, maxDamage = -1000, length = 8, spread = 2, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 1000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -600, range = 7, radius = 2, shootEffect = CONST_ANI_BOLT, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 64,
	armor = 0,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
