local mType = Game.createMonsterType("Terrorsleep")
local monster = {}

monster.description = "a terrorsleep"
monster.experience = 6900
monster.outfit = {
	lookType = 587,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1016
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Roshamuul Mines, Roshamuul Cistern.",
}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "blood"
monster.corpse = 20163
monster.speed = 180
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
	{ text = "Aktat Roshok! Marruk!", yell = false },
	{ text = "I will eat you in your sleep.", yell = false },
	{ text = "I am the darkness around you...", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 197 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 9 }, -- platinum coin
	{ id = 238, chance = 80000, maxCount = 2 }, -- great mana potion
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 3030, chance = 23000, maxCount = 3 }, -- small ruby
	{ id = 9057, chance = 23000, maxCount = 3 }, -- small topaz
	{ id = 16119, chance = 23000 }, -- blue crystal shard
	{ id = 20203, chance = 23000 }, -- trapped bad dream monster
	{ id = 20204, chance = 23000 }, -- bowl of terror sweat
	{ id = 16124, chance = 23000 }, -- blue crystal splinter
	{ id = 16125, chance = 23000 }, -- cyan crystal fragment
	{ id = 3032, chance = 23000, maxCount = 3 }, -- small emerald
	{ id = 3033, chance = 23000, maxCount = 3 }, -- small amethyst
	{ id = 20029, chance = 5000 }, -- broken dream
	{ id = 5912, chance = 5000 }, -- blue piece of cloth
	{ id = 5895, chance = 5000 }, -- fish fin
	{ id = 3369, chance = 5000 }, -- warrior helmet
	{ id = 5909, chance = 5000 }, -- white piece of cloth
	{ id = 3370, chance = 5000 }, -- knight armor
	{ id = 3567, chance = 5000 }, -- blue robe
	{ id = 3281, chance = 5000 }, -- giant sword
	{ id = 5911, chance = 1000 }, -- red piece of cloth
	{ id = 20062, chance = 1000 }, -- cluster of solace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 20, minDamage = -1000, maxDamage = -1500, radius = 7, effect = CONST_ME_YELLOW_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -300, radius = 5, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "feversleep skill reducer", interval = 2000, chance = 7, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -350, maxDamage = -500, length = 6, spread = 0, effect = CONST_ME_YELLOWENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -450, radius = 1, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 50,
	armor = 50,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 300, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	-- { name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_HITAREA },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 55 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
