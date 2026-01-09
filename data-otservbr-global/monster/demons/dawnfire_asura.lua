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
	{ id = 3031, chance = 85809, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 92775, maxCount = 9 }, -- Platinum Coin
	{ id = 6558, chance = 26129, maxCount = 2 }, -- Flask of Demonic Blood
	{ id = 5944, chance = 17291 }, -- Soul Orb
	{ id = 21974, chance = 15328 }, -- Golden Lotus Brooch
	{ id = 21975, chance = 14113 }, -- Peacock Feather Fan
	{ id = 6499, chance = 13403 }, -- Demonic Essence
	{ id = 238, chance = 10389, maxCount = 2 }, -- Great Mana Potion
	{ id = 3030, chance = 7091 }, -- Small Ruby
	{ id = 3028, chance = 4034 }, -- Small Diamond
	{ id = 3032, chance = 3991 }, -- Small Emerald
	{ id = 9057, chance = 3889 }, -- Small Topaz
	{ id = 3033, chance = 3880 }, -- Small Amethyst
	{ id = 3574, chance = 2622 }, -- Mystic Turban
	{ id = 5911, chance = 2489 }, -- Red Piece of Cloth
	{ id = 3071, chance = 1315 }, -- Wand of Inferno
	{ id = 3078, chance = 1203 }, -- Mysterious Fetish
	{ id = 3039, chance = 1122 }, -- Red Gem
	{ id = 8043, chance = 1149 }, -- Focus Cape
	{ id = 826, chance = 719 }, -- Magma Coat
	{ id = 3016, chance = 872 }, -- Ruby Necklace
	{ id = 6299, chance = 467 }, -- Death Ring
	{ id = 21981, chance = 335 }, -- Oriental Shoes
	{ id = 3041, chance = 298 }, -- Blue Gem
	{ id = 8074, chance = 217 }, -- Spellbook of Mind Control
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
