local mType = Game.createMonsterType("True Frost Flower Asura")
local monster = {}

monster.description = "a true frost flower asura"
monster.experience = 7069
monster.outfit = {
	lookType = 1068,
	lookHead = 9,
	lookBody = 0,
	lookLegs = 86,
	lookFeet = 9,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1622
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Asura Palace, Asura Vaults",
}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "blood"
monster.corpse = 28667
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
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
	staticAttackChance = 80,
	targetDistance = 3,
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
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 7 }, -- platinum coin
	{ id = 239, chance = 23000, maxCount = 2 }, -- great health potion
	{ id = 675, chance = 23000, maxCount = 3 }, -- small enchanted sapphire
	{ id = 3017, chance = 23000 }, -- silver brooch
	{ id = 3026, chance = 23000, maxCount = 2 }, -- white pearl
	{ id = 3027, chance = 23000, maxCount = 2 }, -- black pearl
	{ id = 3028, chance = 23000, maxCount = 3 }, -- small diamond
	{ id = 3029, chance = 23000, maxCount = 3 }, -- small sapphire
	{ id = 3030, chance = 23000, maxCount = 2 }, -- small ruby
	{ id = 3032, chance = 23000, maxCount = 5 }, -- small emerald
	{ id = 3043, chance = 23000 }, -- crystal coin
	{ id = 5944, chance = 23000 }, -- soul orb
	{ id = 6499, chance = 23000, maxCount = 3 }, -- demonic essence
	{ id = 6558, chance = 23000 }, -- flask of demonic blood
	{ id = 7368, chance = 23000, maxCount = 4 }, -- assassin star
	{ id = 9057, chance = 23000, maxCount = 2 }, -- small topaz
	{ id = 21974, chance = 23000 }, -- golden lotus brooch
	{ id = 21975, chance = 23000 }, -- peacock feather fan
	{ id = 6093, chance = 5000 }, -- crystal ring
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 3054, chance = 5000 }, -- silver amulet
	{ id = 3067, chance = 5000 }, -- hailstorm rod
	{ id = 3403, chance = 5000 }, -- tribal mask
	{ id = 3567, chance = 5000 }, -- blue robe
	{ id = 8074, chance = 5000 }, -- spellbook of mind control
	{ id = 8083, chance = 5000 }, -- northwind rod
	{ id = 9058, chance = 5000 }, -- gold ingot
	{ id = 25759, chance = 5000, maxCount = 3 }, -- royal star
	{ id = 7404, chance = 1000 }, -- assassin dagger
	{ id = 8061, chance = 1000 }, -- skullcracker armor
	{ id = 21981, chance = 1000, maxCount = 2 }, -- oriental shoes
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500, condition = { type = CONDITION_FREEZING, totalDamage = 400, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -250, range = 7, target = false },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -550, maxDamage = -780, length = 8, spread = 0, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -300, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -100, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 55,
	armor = 72,
	mitigation = 2.11,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
