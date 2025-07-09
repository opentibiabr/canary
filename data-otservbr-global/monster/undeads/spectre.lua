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
	{ id = 2949, chance = 9620 }, -- lyre
	{ name = "silver brooch", chance = 850 },
	{ name = "silver brooch", chance = 110 },
	{ id = 3019, chance = 110 }, -- demonbone amulet
	{ name = "gold coin", chance = 33000, maxCount = 100 },
	{ name = "gold coin", chance = 33000, maxCount = 100 },
	{ name = "gold coin", chance = 33000, maxCount = 97 },
	{ name = "platinum coin", chance = 3850, maxCount = 7 },
	{ id = 3049, chance = 190 }, -- stealth ring
	{ name = "wand of cosmic energy", chance = 9800 },
	{ name = "blank rune", chance = 30310, maxCount = 2 },
	{ id = 5909, chance = 3000 }, -- white piece of cloth
	{ name = "soul orb", chance = 6005 },
	{ id = 6299, chance = 280 }, -- death ring
	{ name = "demonic essence", chance = 6270 },
	{ name = "relic sword", chance = 700 },
	{ name = "great mana potion", chance = 920 },
	{ name = "shiny stone", chance = 1000 },
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
