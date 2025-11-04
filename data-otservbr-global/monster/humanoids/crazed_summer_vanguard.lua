local mType = Game.createMonsterType("Crazed Summer Vanguard")
local monster = {}

monster.description = "a crazed summer vanguard"
monster.experience = 5000
monster.outfit = {
	lookType = 1137,
	lookHead = 114,
	lookBody = 93,
	lookLegs = 3,
	lookFeet = 83,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1732
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Court of Summer, Dream Labyrinth.",
}

monster.health = 5500
monster.maxHealth = 5500
monster.race = "blood"
monster.corpse = 30077
monster.speed = 195
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
	{ text = "I see colours, all colours! Or are these just illusions?", yell = false },
	{ text = "La di da di doo!!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 88812, maxCount = 13 }, -- Platinum Coin
	{ id = 11465, chance = 32141 }, -- Elven Astral Observer
	{ id = 30005, chance = 8177 }, -- Dream Essence Egg
	{ id = 8044, chance = 11915 }, -- Belted Cape
	{ id = 3265, chance = 7697 }, -- Two Handed Sword
	{ id = 647, chance = 9046 }, -- Seeds
	{ id = 3307, chance = 6726 }, -- Scimitar
	{ id = 3291, chance = 7346 }, -- Knife
	{ id = 3085, chance = 7487 }, -- Dragon Necklace
	{ id = 817, chance = 5842 }, -- Magma Amulet
	{ id = 3075, chance = 5853 }, -- Wand of Dragonbreath
	{ id = 8093, chance = 5060 }, -- Wand of Draconia
	{ id = 818, chance = 4494 }, -- Magma Boots
	{ id = 29995, chance = 848 }, -- Sun Fruit
	{ id = 7443, chance = 389 }, -- Bullseye Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2500, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -300, length = 3, spread = 0, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -300, radius = 1, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 3500, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -300, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -300, radius = 3, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "sparks chain", interval = 4500, chance = 20, minDamage = -100, maxDamage = -250, range = 3, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 77,
	mitigation = 2.05,
}

monster.reflects = {
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
