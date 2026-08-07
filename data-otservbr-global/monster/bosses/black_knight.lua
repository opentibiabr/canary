local mType = Game.createMonsterType("Black Knight")
local monster = {}

monster.description = "Black Knight"
monster.experience = 1600
monster.outfit = {
	lookType = 131,
	lookHead = 95,
	lookBody = 95,
	lookLegs = 95,
	lookFeet = 95,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"BlackKnightDeath",
}

monster.bosstiary = {
	bossRaceId = 46,
	bossRace = RARITY_BANE,
}

monster.health = 1800
monster.maxHealth = 1800
monster.race = "blood"
monster.corpse = 18074
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	{ text = "NO PRISONERS!", yell = true },
	{ text = "By Bolg's blood!", yell = false },
	{ text = "You're no match for me!", yell = false },
	{ text = "NO MERCY!", yell = true },
	{ text = "MINE!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 49000, maxCount = 143 }, -- Gold Coin
	{ id = 3277, chance = 30000, maxCount = 3 }, -- Spear
	{ id = 3602, chance = 20000, maxCount = 2 }, -- Brown Bread
	{ id = 3003, chance = 14500 }, -- Rope
	{ id = 3372, chance = 13100 }, -- Brass Legs
	{ id = 3269, chance = 12800 }, -- Halberd
	{ id = 3357, chance = 10800 }, -- Plate Armor
	{ id = 3351, chance = 10300 }, -- Steel Helmet
	{ id = 3265, chance = 9500 }, -- Two Handed Sword
	{ id = 3305, chance = 7000 }, -- Battle Hammer
	{ id = 3369, chance = 4600 }, -- Warrior Helmet
	{ id = 3318, chance = 2700 }, -- Knight Axe
	{ id = 3384, chance = 2300 }, -- Dark Helmet
	{ id = 3383, chance = 2000 }, -- Dark Armor
	{ id = 3371, chance = 1000 }, -- Knight Legs
	{ id = 3370, chance = 860 }, -- Knight Armor
	{ id = 3016, chance = 760 }, -- Ruby Necklace
	{ id = 822, chance = 570 }, -- Lightning Legs
	{ id = 3079, chance = 420 }, -- Boots of Haste
	{ id = 3302, chance = 310 }, -- Dragon Lance
	{ id = 2995, chance = 100 }, -- Piggy Bank
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_SPEAR, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 42,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 95 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = -8 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
