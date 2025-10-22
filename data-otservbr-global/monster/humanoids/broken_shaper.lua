local mType = Game.createMonsterType("Broken Shaper")
local monster = {}

monster.description = "a broken shaper"
monster.experience = 1800
monster.outfit = {
	lookType = 932,
	lookHead = 94,
	lookBody = 76,
	lookLegs = 0,
	lookFeet = 82,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1321
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Astral Shaper Dungeon, Astral Shaper Ruins, Old Masonry",
}

monster.health = 2200
monster.maxHealth = 2200
monster.race = "blood"
monster.corpse = 25068
monster.speed = 155
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{ text = "<grunt>", yell = false },
	{ text = "Raar!!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100320, maxCount = 165 }, -- gold coin
	{ id = 3035, chance = 70320, maxCount = 2 }, -- platinum coin
	{ id = 24383, chance = 20000, maxCount = 2 }, -- cave turnip
	{ id = 24384, chance = 17000 }, -- ancient belt buckle
	{ id = 24385, chance = 20000 }, -- cracked alabaster vase
	{ id = 24386, chance = 13000 }, -- rhino horn carving
	{ id = 24390, chance = 4000 }, -- ancient coin
	{ id = 3147, chance = 15000 }, -- blank rune
	{ id = 3577, chance = 50320, maxCount = 2 }, -- meat
	{ id = 5021, chance = 5000, maxCount = 2 }, -- orichalcum pearl
	{ id = 5912, chance = 1000, maxCount = 2 }, -- blue piece of cloth
	{ id = 5913, chance = 5000, maxCount = 2 }, -- brown piece of cloth
	{ id = 5914, chance = 2000, maxCount = 2 }, -- yellow piece of cloth
	{ id = 3079, chance = 230 }, -- boots of haste
	{ id = 239, chance = 7000 }, -- great health potion
	{ id = 3284, chance = 1000 }, -- ice rapier
	{ id = 3046, chance = 1000 }, -- magic light wand
	{ id = 22193, chance = 4200 }, -- onyx chip
	{ id = 3098, chance = 2000 }, -- ring of healing
	{ id = 3030, chance = 3000 }, -- small ruby
	{ id = 3029, chance = 5000 }, -- small sapphire
	{ id = 3725, chance = 6500, maxCount = 5 }, -- brown mushroom
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -150, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = true },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, length = 5, spread = 0, effect = CONST_ME_SOUND_RED, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 37,
	mitigation = 1.46,
	{ name = "speed", interval = 2000, chance = 10, speedChange = 336, effect = CONST_ME_MAGIC_RED, target = false, duration = 2000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 0, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
