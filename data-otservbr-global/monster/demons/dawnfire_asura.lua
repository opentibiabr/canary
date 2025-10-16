local mType = Game.createMonsterType("Dawnfire Asura")
local monster = {}

monster.description = "a dawnfire asura"
monster.experience = 4100
monster.outfit = {
	lookType = 150,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1134
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Asura Palace.",
}

monster.health = 2900
monster.maxHealth = 2900
monster.race = "blood"
monster.corpse = 21987
monster.speed = 140
monster.manaCost = 0

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
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
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
	{ text = "May the flames consume you!", yell = false },
	{ text = "Encounter the flames of destiny!", yell = false },
	{ text = "Fire and destruction!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 9 }, -- platinum coin
	{ id = 6558, chance = 80000, maxCount = 2 }, -- flask of demonic blood
	{ id = 5944, chance = 23000 }, -- soul orb
	{ id = 21974, chance = 23000 }, -- golden lotus brooch
	{ id = 21975, chance = 23000 }, -- peacock feather fan
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 3030, chance = 23000 }, -- small ruby
	{ id = 3028, chance = 5000 }, -- small diamond
	{ id = 3032, chance = 5000 }, -- small emerald
	{ id = 9057, chance = 5000 }, -- small topaz
	{ id = 3033, chance = 5000 }, -- small amethyst
	{ id = 3574, chance = 5000 }, -- mystic turban
	{ id = 5911, chance = 5000 }, -- red piece of cloth
	{ id = 3071, chance = 5000 }, -- wand of inferno
	{ id = 3078, chance = 5000 }, -- mysterious fetish
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 8043, chance = 5000 }, -- focus cape
	{ id = 826, chance = 1000 }, -- magma coat
	{ id = 3016, chance = 1000 }, -- ruby necklace
	{ id = 6299, chance = 1000 }, -- death ring
	{ id = 21981, chance = 260 }, -- oriental shoes
	{ id = 3041, chance = 260 }, -- blue gem
	{ id = 8074, chance = 260 }, -- spellbook of mind control
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -269 },
	{ name = "combat", interval = 3700, chance = 17, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -300, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 3200, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -350, radius = 4, range = 5, target = true, effect = CONST_ME_MORTAREA },
	{ name = "combat", interval = 2700, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -95, maxDamage = -180, range = 3, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -800, radius = 1, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_SLEEP, target = true, duration = 15000 },
}

monster.defenses = {
	defense = 55,
	armor = 48,
	mitigation = 1.46,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
