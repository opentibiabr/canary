local mType = Game.createMonsterType("Twisted Pooka")
local monster = {}

monster.description = "a twisted pooka"
monster.experience = 600
monster.outfit = {
	lookType = 978,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1436
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Feyrist (nighttime) and its underground (all day).",
}

monster.health = 700
monster.maxHealth = 700
monster.race = "blood"
monster.corpse = 25827
monster.speed = 115
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 20,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "*sniff sniff* Mhmmm ... mortal flesh.", yell = false },
	{ text = "Hoppel-di-hopp!", yell = false },
	{ text = "I'll gnaw away your toes!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 125 }, -- Gold Coin
	{ id = 236, chance = 12165 }, -- Strong Health Potion
	{ id = 3595, chance = 20199, maxCount = 2 }, -- Carrot
	{ id = 3735, chance = 7098 }, -- Stone Herb
	{ id = 25693, chance = 9378 }, -- Shimmering Beetles
	{ id = 25694, chance = 9751 }, -- Fairy Wings
	{ id = 676, chance = 3240, maxCount = 2 }, -- Small Enchanted Ruby
	{ id = 1781, chance = 4696, maxCount = 5 }, -- Small Stone
	{ id = 3598, chance = 4227, maxCount = 5 }, -- Cookie
	{ id = 3726, chance = 2927 }, -- Orange Mushroom
	{ id = 24962, chance = 2656 }, -- Prismatic Quartz
	{ id = 3049, chance = 750 }, -- Stealth Ring
	{ id = 12311, chance = 126 }, -- Carrot on a Stick
	{ id = 9027, chance = 89 }, -- Crystal of Focus
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -50, range = 4, shootEffect = CONST_ANI_SMALLSTONE, effect = CONST_ME_STONES, target = true },
	-- earth damage
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -50, maxDamage = -100, range = 3, effect = CONST_ME_POISONAREA, target = true },
	{ name = "drunk", interval = 2000, chance = 11, length = 4, spread = 2, effect = CONST_ME_STUN, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 38,
	armor = 41,
	mitigation = 1.04,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 40, maxDamage = 60, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
