local mType = Game.createMonsterType("Blood Hand")
local monster = {}

monster.description = "a blood hand"
monster.experience = 750
monster.outfit = {
	lookType = 552,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 974
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

monster.health = 700
monster.maxHealth = 700
monster.race = "blood"
monster.corpse = 18940
monster.speed = 96
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Blood for the dark god!", yell = false },
	{ text = "Die, filth!", yell = false },
	{ text = "For the Blood God!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 135 }, -- Gold Coin
	{ id = 10320, chance = 10230 }, -- Book of Necromantic Rituals
	{ id = 18925, chance = 10090 }, -- Lancet
	{ id = 18926, chance = 7940 }, -- Horoscope
	{ id = 18928, chance = 15490 }, -- Blood Tincture in a Vial
	{ id = 18929, chance = 9900 }, -- Incantation Notes
	{ id = 18930, chance = 6259 }, -- Pieces of Magic Chalk
	{ id = 237, chance = 5960 }, -- Strong Mana Potion
	{ id = 3069, chance = 3170 }, -- Necrotic Rod
	{ id = 5909, chance = 969 }, -- White Piece of Cloth
	{ id = 3039, chance = 510 }, -- Red Gem
	{ id = 3574, chance = 1090 }, -- Mystic Turban
	{ id = 5911, chance = 620 }, -- Red Piece of Cloth
	{ id = 8072, chance = 980 }, -- Spellbook of Enlightenment
	{ id = 3079, chance = 120 }, -- Boots of Haste
	{ id = 3324, chance = 40 }, -- Skull Staff
	{ id = 7456, chance = 30 }, -- Noble Axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -158, condition = { type = CONDITION_POISON, totalDamage = 80, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -100, radius = 4, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -600, radius = 4, effect = CONST_ME_BLOCKHIT, target = true, duration = 15000 },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 15, minDamage = -120, maxDamage = -160, radius = 6, effect = CONST_ME_HITAREA, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 48,
	mitigation = 1.10,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 70, maxDamage = 90, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "effect", interval = 2000, chance = 10, radius = 1, effect = CONST_ME_INSECTS, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
