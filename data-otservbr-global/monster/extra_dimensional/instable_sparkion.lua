local mType = Game.createMonsterType("Instable Sparkion")
local monster = {}

monster.description = "an instable sparkion"
monster.experience = 1350
monster.outfit = {
	lookType = 877,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1264
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

monster.health = 1900
monster.maxHealth = 1900
monster.race = "venom"
monster.corpse = 23388
monster.speed = 140
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
	{ text = "Zzing!", yell = false },
	{ text = "Frizzle!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99006, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 90769 }, -- Platinum Coin
	{ id = 16124, chance = 8395 }, -- Blue Crystal Splinter
	{ id = 16125, chance = 5239 }, -- Cyan Crystal Fragment
	{ id = 23502, chance = 8187 }, -- Sparkion Claw
	{ id = 23504, chance = 6682 }, -- Sparkion Legs
	{ id = 23505, chance = 5869 }, -- Sparkion Stings
	{ id = 23503, chance = 6289 }, -- Sparkion Tail
	{ id = 23535, chance = 4499 }, -- Energy Bar
	{ id = 23545, chance = 5751 }, -- Energy Drink
	{ id = 239, chance = 3816 }, -- Great Health Potion
	{ id = 238, chance = 5187 }, -- Great Mana Potion
	{ id = 7642, chance = 3704 }, -- Great Spirit Potion
	{ id = 16119, chance = 4615 }, -- Blue Crystal Shard
	{ id = 3029, chance = 6027, maxCount = 2 }, -- Small Sapphire
	{ id = 3073, chance = 845 }, -- Wand of Cosmic Energy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -350, length = 6, spread = 0, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -150, maxDamage = -200, range = 5, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 20, minDamage = -300, maxDamage = -600, range = 6, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_PURPLEENERGY, target = true },
}

monster.defenses = {
	defense = 35,
	armor = 37,
	mitigation = 1.18,
	{ name = "speed", interval = 2000, chance = 10, speedChange = 360, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 50, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 60 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
