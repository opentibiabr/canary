local mType = Game.createMonsterType("Arachir the Ancient One")
local monster = {}

monster.description = "Arachir the Ancient One"
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
	bossRaceId = 478,
	bossRace = RARITY_NEMESIS,
}

monster.health = 1600
monster.maxHealth = 1600
monster.race = "undead"
monster.corpse = 8109
monster.speed = 143
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
	maxSummons = 2,
	summons = {
		{ name = "Lich", chance = 100, interval = 9000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I was the shadow that haunted the cradle of humanity!", yell = false },
	{ text = "Your worthles existence will nourish something greater!", yell = false },
	{ text = "I exist since eons and you want to defy me?", yell = false },
	{ text = "Can you feel the passage of time, mortal?", yell = false },
}

monster.loot = {
	{ id = 8192, chance = 100000 }, -- Vampire Lord Token
	{ id = 3031, chance = 100000, maxCount = 98 }, -- Gold Coin
	{ id = 3035, chance = 10094, maxCount = 5 }, -- Platinum Coin
	{ id = 3027, chance = 970 }, -- Black Pearl
	{ id = 11449, chance = 100000 }, -- Blood Preservation
	{ id = 236, chance = 20185 }, -- Strong Health Potion
	{ id = 3098, chance = 11926 }, -- Ring of Healing
	{ id = 3114, chance = 8260 }, -- Skull (Item)
	{ id = 3434, chance = 9176 }, -- Vampire Shield
	{ id = 7416, chance = 970 }, -- Bloody Edge
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 70, attack = 95 },
	{ name = "combat", interval = 9000, chance = 100, type = COMBAT_DEATHDAMAGE, minDamage = -120, maxDamage = -300, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -120, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	mitigation = 1.04,
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_HEALING, minDamage = 100, maxDamage = 235, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 3000, chance = 25, effect = CONST_ME_MAGIC_BLUE },
	{ name = "outfit", interval = 4500, chance = 30, target = false, duration = 4000, outfitMonster = "bat" },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -1 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
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
