local mType = Game.createMonsterType("Zevelon Duskbringer")
local monster = {}

monster.description = "Zevelon Duskbringer"
monster.experience = 1800
monster.outfit = {
	lookType = 287,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 475,
	bossRace = RARITY_NEMESIS,
}

monster.health = 1400
monster.maxHealth = 1400
monster.race = "undead"
monster.corpse = 8109
monster.speed = 155
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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

monster.summon = {
	maxSummons = 3,
	summons = {
		{ name = "Vampire", chance = 40, interval = 3000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I want Your Blood", yell = false },
	{ text = "Come Here!", yell = false },
	{ text = "I will be still around when my 'noble' race is gone.", yell = false },
	{ text = "Human blood is not suitable for drinking!", yell = false },
	{ text = "Human blood is a hardly suitable drink.", yell = false },
	{ text = "Your short live is coming to an end.", yell = false },
	{ text = "Ashari Mortals. Come and stay forever!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 97 }, -- Gold Coin
	{ id = 3035, chance = 6200, maxCount = 5 }, -- Platinum Coin
	{ id = 3114, chance = 6980 }, -- Skull (Item)
	{ id = 3027, chance = 780 }, -- Black Pearl
	{ id = 236, chance = 16149 }, -- Strong Health Potion
	{ id = 3098, chance = 3880 }, -- Ring of Healing
	{ id = 3434, chance = 10850 }, -- Vampire Shield
	{ id = 7419, chance = 3081 }, -- Dreaded Cleaver
	{ id = 8192, chance = 50384 }, -- Vampire Lord Token
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 65, attack = 75 },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -200, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "speed", interval = 2000, chance = 15, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_HEALING, minDamage = 100, maxDamage = 235, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 3000, chance = 25, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
