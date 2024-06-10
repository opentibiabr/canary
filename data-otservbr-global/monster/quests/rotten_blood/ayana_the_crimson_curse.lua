local mType = Game.createMonsterType("Ayana the crimson curse")
local monster = {}

monster.description = "Ayana the crimson curse"
monster.experience = 12400
monster.outfit = {
	lookType = 1647,
	lookHead = 132,
	lookBody = 132,
	lookLegs = 57,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 17000
monster.maxHealth = 17000
monster.race = "undead"
monster.corpse = 44039
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 2404,
	bossRace = RARITY_NEMESIS,
}
monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 800,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {}

monster.loot = {
	{ name = "gold coin", chance = 100000, maxCount = 197 },
	{ name = "platinum coin", chance = 100000, maxCount = 5 },
	{ name = "amulet of loss", chance = 120 },
	{ name = "gold ring", chance = 1870 },
	{ name = "hailstorm rod", chance = 10000 },
	{ name = "garlic necklace", chance = 2050 },
	{ name = "blank rune", chance = 26250, maxCount = 2 },
	{ name = "golden sickle", chance = 350 },
	{ name = "skull staff", chance = 1520 },
	{ name = "scythe", chance = 3000 },
	{ name = "bunch of wheat", chance = 50000 },
	{ name = "soul orb", chance = 23720 },
	{ id = 6299, chance = 1410 },
	{ id = 43916, chance = 4000 },
	{ id = 43729, chance = 22000, maxCount = 3 },
	{ id = 43738, chance = 9000 },
	{ id = 43849, chance = 10000 },
	{ id = 43857, chance = 7000 },
	{ name = "demonic essence", chance = 28000 },
	{ name = "assassin star", chance = 5900, maxCount = 10 },
	{ name = "great mana potion", chance = 31360, maxCount = 3 },
	{ id = 281, chance = 4450 },
	{ id = 282, chance = 4450 },
	{ name = "seeds", chance = 4300 },
	{ name = "terra mantle", chance = 1050 },
	{ name = "terra legs", chance = 2500 },
	{ name = "ultimate health potion", chance = 14720, maxCount = 2 },
	{ name = "gold ingot", chance = 5270 },
	{ name = "bundle of cursed straw", chance = 15000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 75, attack = 100 },
	{ name = "combat", interval = 1000, chance = 8, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -500, radius = 9, effect = CONST_ME_MORTAREA, target = false },
	{ name = "speed", interval = 1000, chance = 12, speedChange = -250, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 60000 },
	{ name = "strength", interval = 1000, chance = 10, minDamage = -300, maxDamage = -750, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 3000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -500, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = 244, target = true },
	{ name = "combat", interval = 3000, chance = 8, type = COMBAT_HOLYDAMAGE, minDamage = -300, maxDamage = -450, radius = 10, effect = 246, target = false },
}

monster.defenses = {
	defense = 110,
	armor = 110,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 90 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 90 },
	{ type = COMBAT_DEATHDAMAGE, percent = 90 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
