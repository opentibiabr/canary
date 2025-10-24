local mType = Game.createMonsterType("Instable Breach Brood")
local monster = {}

monster.description = "an instable breach brood"
monster.experience = 1100
monster.outfit = {
	lookType = 878,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1265
monster.Bestiary = {
	class = "Extra Dimensional",
	race = BESTY_RACE_EXTRA_DIMENSIONAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Otherworld Dwarf Bridge",
}

monster.health = 2200
monster.maxHealth = 2200
monster.race = "venom"
monster.corpse = 23392
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Hisss!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99540, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 69780, maxCount = 2 }, -- Platinum Coin
	{ id = 23506, chance = 10110 }, -- Plasma Pearls
	{ id = 23521, chance = 9910 }, -- Crystal Bone
	{ id = 23545, chance = 5320 }, -- Energy Drink
	{ id = 7642, chance = 5030 }, -- Great Spirit Potion
	{ id = 239, chance = 4680 }, -- Great Health Potion
	{ id = 238, chance = 5060 }, -- Great Mana Potion
	{ id = 16121, chance = 3709 }, -- Green Crystal Shard
	{ id = 23535, chance = 4920 }, -- Energy Bar
	{ id = 16125, chance = 3010 }, -- Cyan Crystal Fragment
	{ id = 16124, chance = 4019 }, -- Blue Crystal Splinter
	{ id = 16119, chance = 2110 }, -- Blue Crystal Shard
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -160, maxDamage = -250, range = 6, shootEffect = CONST_ANI_FLASHARROW, effect = CONST_ME_STUN, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -200, radius = 5, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "breach brood reducer", interval = 2000, chance = 20, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 43,
	mitigation = 1.32,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 75 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
