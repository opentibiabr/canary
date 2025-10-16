local mType = Game.createMonsterType("Rage Squid")
local monster = {}

monster.description = "a rage squid"
monster.experience = 16300
monster.outfit = {
	lookType = 1059,
	lookHead = 94,
	lookBody = 78,
	lookLegs = 79,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1668
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library (fire section).",
}

monster.health = 17000
monster.maxHealth = 17000
monster.race = "undead"
monster.corpse = 28782
monster.speed = 215
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 6 }, -- platinum coin
	{ id = 7643, chance = 80000, maxCount = 3 }, -- ultimate health potion
	{ id = 238, chance = 23000, maxCount = 3 }, -- great mana potion
	{ id = 7642, chance = 23000, maxCount = 3 }, -- great spirit potion
	{ id = 28570, chance = 23000 }, -- glowing rune
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 3731, chance = 23000, maxCount = 6 }, -- fire mushroom
	{ id = 9057, chance = 23000, maxCount = 5 }, -- small topaz
	{ id = 3030, chance = 23000, maxCount = 5 }, -- small ruby
	{ id = 3033, chance = 23000, maxCount = 5 }, -- small amethyst
	{ id = 3032, chance = 23000, maxCount = 5 }, -- small emerald
	{ id = 3320, chance = 23000 }, -- fire axe
	{ id = 3281, chance = 5000 }, -- giant sword
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3034, chance = 5000 }, -- talon
	{ id = 21194, chance = 5000 }, -- slime heart
	{ id = 3060, chance = 5000 }, -- orb
	{ id = 3048, chance = 5000 }, -- might ring
	{ id = 9663, chance = 5000 }, -- piece of dead brain
	{ id = 3420, chance = 5000 }, -- demon shield
	{ id = 3055, chance = 5000 }, -- platinum amulet
	{ id = 7382, chance = 5000 }, -- demonrage sword
	{ id = 2848, chance = 1000 }, -- purple tome
	{ id = 3356, chance = 1000 }, -- devil helmet
	{ id = 3366, chance = 260 }, -- magic plate armor
	{ id = 16115, chance = 260 }, -- wand of everblazing
	{ id = 7393, chance = 260 }, -- demon trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -280, range = 7, shootEffect = CONST_ANI_FLAMMINGARROW, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -380, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -175, maxDamage = -200, length = 5, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -475, radius = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -475, radius = 2, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
