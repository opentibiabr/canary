local mType = Game.createMonsterType("Lost Berserker")
local monster = {}

monster.description = "a lost berserker"
monster.experience = 4800
monster.outfit = {
	lookType = 496,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 888
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Warzones 2 and 3.",
}

monster.health = 5900
monster.maxHealth = 5900
monster.race = "blood"
monster.corpse = 16071
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	{ text = "Kill! Kiill! Kill!", yell = false },
	{ text = "Death! Death! Death!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 9 }, -- platinum coin
	{ id = 16123, chance = 23000, maxCount = 2 }, -- brown crystal splinter
	{ id = 3725, chance = 23000, maxCount = 2 }, -- brown mushroom
	{ id = 16142, chance = 23000, maxCount = 10 }, -- drill bolt
	{ id = 239, chance = 23000 }, -- great health potion
	{ id = 238, chance = 23000 }, -- great mana potion
	{ id = 16127, chance = 23000 }, -- green crystal fragment
	{ id = 5880, chance = 23000 }, -- iron ore
	{ id = 9057, chance = 23000, maxCount = 2 }, -- small topaz
	{ id = 16124, chance = 5000 }, -- blue crystal splinter
	{ id = 12600, chance = 5000 }, -- coal
	{ id = 3097, chance = 5000 }, -- dwarven ring
	{ id = 2995, chance = 5000 }, -- piggy bank
	{ id = 16120, chance = 5000 }, -- violet crystal shard
	{ id = 3429, chance = 1000 }, -- black shield
	{ id = 10422, chance = 5000 }, -- clay lump
	{ id = 3415, chance = 5000 }, -- guardian shield
	{ id = 3318, chance = 5000 }, -- knight axe
	{ id = 7427, chance = 1000 }, -- chaos mace
	{ id = 5904, chance = 1000 }, -- magic sulphur
	{ id = 7452, chance = 1000 }, -- spiked squelcher
	{ id = 813, chance = 1000 }, -- terra boots
	{ id = 3428, chance = 1000 }, -- tower shield
	{ id = 3320, chance = 1000 }, -- fire axe
	{ id = 3392, chance = 260 }, -- royal helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -501 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -300, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -250, range = 7, radius = 3, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -100, radius = 5, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -800, radius = 2, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 40,
	armor = 80,
	mitigation = 2.40,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
