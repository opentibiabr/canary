local mType = Game.createMonsterType("Kroazur")
local monster = {}

monster.description = "Kroazur"
monster.experience = 2700
monster.outfit = {
	lookType = 842,
	lookHead = 0,
	lookBody = 114,
	lookLegs = 94,
	lookFeet = 80,
	lookAddons = 2,
	lookMount = 0,
}

monster.events = {
	"ThreatenedDreamsNightmareMonstersDeath",
}

monster.bosstiary = {
	bossRaceId = 1515,
	bossRace = RARITY_BANE,
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "undead"
monster.corpse = 6324
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	staticAttackChance = 98,
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
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 348 }, -- Gold Coin
	{ id = 16126, chance = 100000, maxCount = 3 }, -- Red Crystal Fragment
	{ id = 3035, chance = 100000, maxCount = 7 }, -- Platinum Coin
	{ id = 25694, chance = 100000, maxCount = 3 }, -- Fairy Wings
	{ id = 236, chance = 91000, maxCount = 2 }, -- Strong Health Potion
	{ id = 239, chance = 74000, maxCount = 3 }, -- Great Health Potion
	{ id = 24390, chance = 53000, maxCount = 3 }, -- Ancient Coin
	{ id = 48239, chance = 47000 }, -- Matcha Turtle
	{ id = 48278, chance = 47000 }, -- Tattered Piece of Paper
	{ id = 24392, chance = 33000 }, -- Gemmed Figurine
	{ id = 676, chance = 28000, maxCount = 5 }, -- Small Enchanted Ruby
	{ id = 677, chance = 25000, maxCount = 5 }, -- Small Enchanted Emerald
	{ id = 678, chance = 25000, maxCount = 5 }, -- Small Enchanted Amethyst
	{ id = 675, chance = 23000, maxCount = 5 }, -- Small Enchanted Sapphire
	{ id = 22516, chance = 9600 }, -- Silver Token
	{ id = 20062, chance = 8100 }, -- Cluster of Solace
	{ id = 9058, chance = 8100 }, -- Gold Ingot
	{ id = 7368, chance = 6000, maxCount = 8 }, -- Assassin Star
	{ id = 22721, chance = 4900 }, -- Gold Token
	{ id = 7418, chance = 3500 }, -- Nightmare Blade
}

monster.attacks = {
	{ name = "melee", interval = 200, chance = 20, minDamage = 0, maxDamage = -650 },
	{ name = "combat", interval = 200, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -500, target = false },
	{ name = "combat", interval = 500, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -300, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 500, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -300, radius = 8, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 55 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
