local mType = Game.createMonsterType("Shadow Pupil")
local monster = {}

monster.description = "a shadow pupil"
monster.experience = 410
monster.outfit = {
	lookType = 551,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 960
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Drefia.",
}

monster.health = 450
monster.maxHealth = 450
monster.race = "blood"
monster.corpse = 18937
monster.speed = 85
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Skeleton", chance = 10, interval = 2000, count = 4 },
		{ name = "Ghost", chance = 5, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "When I'm finished with you, you'll be a shadow of your former self.", yell = false },
	{ text = "Come forth from the shadows, my minions...", yell = false },
	{ text = "The shadows follow your every step...", yell = false },
	{ text = "The shadows will swallow you...", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 65 }, -- Gold Coin
	{ id = 10320, chance = 7690 }, -- Book of Necromantic Rituals
	{ id = 18926, chance = 14990 }, -- Horoscope
	{ id = 18929, chance = 9500 }, -- Incantation Notes
	{ id = 3725, chance = 4620 }, -- Brown Mushroom
	{ id = 18930, chance = 4620 }, -- Pieces of Magic Chalk
	{ id = 3574, chance = 570 }, -- Mystic Turban
	{ id = 237, chance = 500 }, -- Strong Mana Potion
	{ id = 3311, chance = 320 }, -- Clerical Mace
	{ id = 8072, chance = 180 }, -- Spellbook of Enlightenment
	{ id = 3079, chance = 20 }, -- Boots of Haste
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -70, condition = { type = CONDITION_POISON, totalDamage = 90, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -60, maxDamage = -80, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -60, radius = 3, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 32,
	mitigation = 1.04,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
