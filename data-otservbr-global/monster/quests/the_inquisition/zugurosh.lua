local mType = Game.createMonsterType("Zugurosh")
local monster = {}

monster.description = "Zugurosh"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 3,
	lookBody = 18,
	lookLegs = 19,
	lookFeet = 91,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.bosstiary = {
	bossRaceId = 434,
	bossRace = RARITY_BANE,
}

monster.health = 90500
monster.maxHealth = 90500
monster.race = "fire"
monster.corpse = 7893
monster.speed = 165
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 15,
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
	canPushCreatures = true,
	staticAttackChance = 85,
	targetDistance = 1,
	runHealth = 4500,
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
	{ text = "You will run out of resources soon enough!", yell = false },
	{ text = "One little mistake and you're all are mine!", yell = false },
	{ text = "I sense your strength fading!", yell = false },
	{ text = "I know you will show a weakness!", yell = false },
	{ text = "Your fear will make you prone to mistakes!", yell = false },
}

monster.loot = {
	{ id = 6499, chance = 100000 }, -- Demonic Essence
	{ id = 3031, chance = 100000, maxCount = 195 }, -- Gold Coin
	{ id = 8899, chance = 52000 }, -- Slightly Rusted Legs
	{ id = 8896, chance = 48000 }, -- Slightly Rusted Armor
	{ id = 7642, chance = 26000 }, -- Great Spirit Potion
	{ id = 238, chance = 26000 }, -- Great Mana Potion
	{ id = 239, chance = 25000 }, -- Great Health Potion
	{ id = 7643, chance = 24000 }, -- Ultimate Health Potion
	{ id = 3035, chance = 21000, maxCount = 30 }, -- Platinum Coin
	{ id = 5944, chance = 21000, maxCount = 10 }, -- Soul Orb
	{ id = 9058, chance = 21000 }, -- Gold Ingot
	{ id = 6104, chance = 21000 }, -- Jewel Case
	{ id = 3017, chance = 19700 }, -- Silver Brooch
	{ id = 3034, chance = 18600, maxCount = 30 }, -- Talon
	{ id = 5911, chance = 17100, maxCount = 10 }, -- Red Piece of Cloth
	{ id = 5912, chance = 15800, maxCount = 10 }, -- Blue Piece of Cloth
	{ id = 5909, chance = 14700, maxCount = 10 }, -- White Piece of Cloth
	{ id = 5913, chance = 14300, maxCount = 10 }, -- Brown Piece of Cloth
	{ id = 5910, chance = 14000, maxCount = 10 }, -- Green Piece of Cloth
	{ id = 5914, chance = 13900, maxCount = 10 }, -- Yellow Piece of Cloth
	{ id = 5954, chance = 9300, maxCount = 2 }, -- Demon Horn
	{ id = 3079, chance = 8900 }, -- Boots of Haste
	{ id = 3057, chance = 5000 }, -- Amulet of Loss
	{ id = 3554, chance = 4800 }, -- Steel Boots
	{ id = 3555, chance = 1200 }, -- Golden Boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -500, range = 4, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -500, length = 7, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -100, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = false },
	-- fire
	{ name = "condition", type = CONDITION_FIRE, interval = 3000, chance = 20, minDamage = -10, maxDamage = -10, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_MANADRAIN, minDamage = -60, maxDamage = -200, radius = 5, effect = CONST_ME_WATERSPLASH, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 45,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 40, maxDamage = 60, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 400, maxDamage = 600, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "invisible", interval = 1000, chance = 5, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
