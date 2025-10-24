local mType = Game.createMonsterType("Barbarian Bloodwalker")
local monster = {}

monster.description = "a barbarian bloodwalker"
monster.experience = 195
monster.outfit = {
	lookType = 255,
	lookHead = 114,
	lookBody = 113,
	lookLegs = 132,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 323
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Krimhorn, Bittermor, Ragnir, Arena and Zoo Quarter inside the Arena.",
}

monster.health = 305
monster.maxHealth = 305
monster.race = "blood"
monster.corpse = 18054
monster.speed = 118
monster.manaCost = 590

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
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "YAAAHEEE!", yell = true },
	{ text = "SLAUGHTER!", yell = true },
	{ text = "CARNAGE!", yell = true },
	{ text = "You can run but you can't hide", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 55170, maxCount = 12 }, -- Gold Coin
	{ id = 2914, chance = 8430 }, -- Lamp
	{ id = 3266, chance = 5861 }, -- Battle Axe
	{ id = 3269, chance = 6785 }, -- Halberd
	{ id = 3352, chance = 10662 }, -- Chain Helmet
	{ id = 3358, chance = 10082 }, -- Chain Armor
	{ id = 3582, chance = 4587 }, -- Ham
	{ id = 266, chance = 1038 }, -- Health Potion
	{ id = 5911, chance = 528 }, -- Red Piece of Cloth
	{ id = 3344, chance = 295 }, -- Beastslayer Axe
	{ id = 7290, chance = 310 }, -- Shard
	{ id = 7457, chance = 64 }, -- Fur Boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240 },
}

monster.defenses = {
	defense = 0,
	armor = 9,
	mitigation = 0.25,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 240, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
