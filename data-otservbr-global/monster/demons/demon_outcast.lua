local mType = Game.createMonsterType("Demon Outcast")
local monster = {}

monster.description = "a demon outcast"
monster.experience = 6200
monster.outfit = {
	lookType = 590,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1019
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Roshamuul Prison.",
}

monster.health = 6900
monster.maxHealth = 6900
monster.race = "blood"
monster.corpse = 20215
monster.speed = 148
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
		{ name = "energy elemental", chance = 10, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Back in the evil business!", yell = false },
	{ text = "This prison break will have casualties!", yell = false },
	{ text = "At last someone to hurt", yell = false },
	{ text = "No one will imprison me again!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 6 }, -- platinum coin
	{ id = 3731, chance = 23000, maxCount = 6 }, -- fire mushroom
	{ id = 7643, chance = 23000, maxCount = 3 }, -- ultimate health potion
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 3028, chance = 23000, maxCount = 5 }, -- small diamond
	{ id = 3030, chance = 23000, maxCount = 5 }, -- small ruby
	{ id = 3029, chance = 23000, maxCount = 5 }, -- small sapphire
	{ id = 9057, chance = 23000, maxCount = 5 }, -- small topaz
	{ id = 3032, chance = 23000, maxCount = 5 }, -- small emerald
	{ id = 7368, chance = 23000, maxCount = 10 }, -- assassin star
	{ id = 3098, chance = 5000 }, -- ring of healing
	{ id = 3281, chance = 5000 }, -- giant sword
	{ id = 3049, chance = 5000 }, -- stealth ring
	{ id = 3419, chance = 1000 }, -- crown shield
	{ id = 3048, chance = 1000 }, -- might ring
	{ id = 3284, chance = 1000 }, -- ice rapier
	{ id = 3055, chance = 1000 }, -- platinum amulet
	{ id = 3391, chance = 1000 }, -- crusader helmet
	{ id = 3356, chance = 1000 }, -- devil helmet
	{ id = 6068, chance = 1000 }, -- demon dust
	{ id = 20062, chance = 1000 }, -- cluster of solace
	{ id = 3420, chance = 260 }, -- demon shield
	{ id = 3381, chance = 260 }, -- crown armor
	{ id = 7382, chance = 260 }, -- demonrage sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -450, length = 6, spread = 0, effect = CONST_ME_PURPLEENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -350, maxDamage = -550, length = 8, spread = 0, effect = CONST_ME_YELLOWENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -250, radius = 3, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "demon outcast skill reducer", interval = 2000, chance = 10, range = 5, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -80, maxDamage = -150, radius = 4, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 49,
	mitigation = 1.60,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 425, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -8 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -6 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
