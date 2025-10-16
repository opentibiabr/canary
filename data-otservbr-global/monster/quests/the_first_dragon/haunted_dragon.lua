local mType = Game.createMonsterType("Haunted Dragon")
local monster = {}

monster.description = "a haunted dragon"
monster.experience = 6500
monster.outfit = {
	lookType = 231,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1376
monster.Bestiary = {
	class = "Dragon",

	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 2,
	Locations = "The First Dragons Lair, fourth floor.",
}

monster.health = 6500
monster.maxHealth = 6500
monster.race = "undead"
monster.corpse = 6305
monster.speed = 140
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 179 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 2 }, -- platinum coin
	{ id = 10316, chance = 80000 }, -- unholy bone
	{ id = 24390, chance = 80000, maxCount = 2 }, -- ancient coin
	{ id = 239, chance = 80000, maxCount = 2 }, -- great health potion
	{ id = 3029, chance = 80000 }, -- small sapphire
	{ id = 7368, chance = 80000, maxCount = 5 }, -- assassin star
	{ id = 3027, chance = 23000, maxCount = 2 }, -- black pearl
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 5925, chance = 23000 }, -- hardened bone
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 3062, chance = 23000 }, -- mind stone
	{ id = 3085, chance = 23000 }, -- dragon necklace
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3383, chance = 5000 }, -- dark armor
	{ id = 3421, chance = 5000 }, -- dark shield
	{ id = 9058, chance = 5000 }, -- gold ingot
	{ id = 7430, chance = 5000 }, -- dragonbone staff
	{ id = 3061, chance = 5000 }, -- life crystal
	{ id = 6299, chance = 5000 }, -- death ring
	{ id = 10438, chance = 1000 }, -- spellweavers robe
	{ id = 7402, chance = 1000 }, -- dragon slayer
	{ id = 8061, chance = 260 }, -- skullcracker armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480 },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -400, range = 7, radius = 4, effect = CONST_ME_HITAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -125, maxDamage = -600, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -390, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -180, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -690, length = 8, spread = 3, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -700, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -200, radius = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "undead dragon curse", interval = 2000, chance = 10, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 58,
	mitigation = 1.60,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = -40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
