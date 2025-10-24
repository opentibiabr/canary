local mType = Game.createMonsterType("Jesse the Wicked")
local monster = {}

monster.description = "Jesse the Wicked"
monster.experience = 180
monster.outfit = {
	lookType = 134,
	lookHead = 95,
	lookBody = 95,
	lookLegs = 95,
	lookFeet = 113,
	lookAddons = 3,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 763,
	bossRace = RARITY_NEMESIS,
}

monster.health = 280
monster.maxHealth = 280
monster.race = "blood"
monster.corpse = 18153
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
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
	{ text = "That banker never saw it coming!", yell = false },
	{ text = "You will not take this gold from me!", yell = false },
	{ text = "KEEP YOUR HANDS OFF THAT BAG!", yell = true },
	{ text = "Kill him, men!", yell = false },
	{ text = "Take from the rich, keep it for yourself. That's my motto.", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 100 }, -- Platinum Coin
	{ id = 13429, chance = 100000 }, -- Bag with Stolen Gold
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
