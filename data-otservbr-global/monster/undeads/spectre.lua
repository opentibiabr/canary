local mType = Game.createMonsterType("Spectre")
local monster = {}

monster.description = "a spectre"
monster.experience = 2100
monster.outfit = {
	lookType = 235,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 286
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Pits of Inferno, The Crystal Caves and The Soul Well in The Inquisition Quest, \z
		Drefia Grim Reaper Dungeons, as well in Vengoth.",
}

monster.health = 1350
monster.maxHealth = 1350
monster.race = "undead"
monster.corpse = 6347
monster.speed = 140
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Revenge ... is so ... sweet.", yell = false },
	{ text = "Life...force! Feed me your... lifeforce", yell = false },
	{ text = "Mor... tals!", yell = false },
	{ text = "Buuuuuh", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 301 }, -- gold coin
	{ id = 3147, chance = 80000, maxCount = 2 }, -- blank rune
	{ id = 3073, chance = 23000 }, -- wand of cosmic energy
	{ id = 3260, chance = 23000 }, -- lyre
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 5944, chance = 23000 }, -- soul orb
	{ id = 3035, chance = 5000, maxCount = 7 }, -- platinum coin
	{ id = 5909, chance = 5000 }, -- white piece of cloth
	{ id = 10310, chance = 1000 }, -- shiny stone
	{ id = 238, chance = 1000 }, -- great mana potion
	{ id = 3017, chance = 1000 }, -- silver brooch
	{ id = 7383, chance = 1000 }, -- relic sword
	{ id = 6299, chance = 260 }, -- death ring
	{ id = 3049, chance = 260 }, -- stealth ring
	{ id = 3019, chance = 260 }, -- demonbone amulet
	{ id = 7451, chance = 260 }, -- shadow sceptre
	{ id = 3081, chance = 260 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -308, condition = { type = CONDITION_POISON, totalDamage = 300, interval = 4000 } },
	{ name = "drunk", interval = 2000, chance = 15, radius = 4, effect = CONST_ME_SOUND_PURPLE, target = false, duration = 6000 },
	{ name = "spectre drown", interval = 2000, chance = 15, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -400, range = 7, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -550, range = 7, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 40,
	mitigation = 1.04,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 700, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 290, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 90 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -8 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -8 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
