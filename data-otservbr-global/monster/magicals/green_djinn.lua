local mType = Game.createMonsterType("Green Djinn")
local monster = {}

monster.description = "a green djinn"
monster.experience = 215
monster.outfit = {
	lookType = 51,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 51
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Mal'ouquah, Oasis Tomb, under the Ankrahmun Library Tomb, \z
		Serpentine Tower last floor behind the Magic Walls, Deeper Banuta, Goroma underground, Magician Quarter.",
}

monster.health = 330
monster.maxHealth = 330
monster.race = "blood"
monster.corpse = 6016
monster.speed = 110
monster.manaCost = 0

monster.faction = FACTION_EFREET
monster.enemyFactions = { FACTION_PLAYER, FACTION_MARID }

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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
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
	{ text = "I grant you a deathwish!", yell = false },
	{ text = "Muahahahahaha", yell = false },
	{ text = "I wish you a merry trip to hell!", yell = false },
	{ text = "Good wishes are for fairytales", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 87418, maxCount = 115 }, -- Gold Coin
	{ id = 3607, chance = 25397 }, -- Cheese
	{ id = 2831, chance = 3105 }, -- Book (Green)
	{ id = 3032, chance = 5614, maxCount = 4 }, -- Small Emerald
	{ id = 5910, chance = 1544 }, -- Green Piece of Cloth
	{ id = 7378, chance = 5199, maxCount = 2 }, -- Royal Spear
	{ id = 11456, chance = 2120 }, -- Dirty Turban
	{ id = 2933, chance = 5938 }, -- Small Oil Lamp
	{ id = 3661, chance = 8283 }, -- Grave Flower
	{ id = 268, chance = 603 }, -- Mana Potion
	{ id = 3574, chance = 213 }, -- Mystic Turban
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -45, maxDamage = -80, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -50, maxDamage = -105, range = 7, radius = 1, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, target = false, duration = 5000 },
	{ name = "outfit", interval = 2000, chance = 1, range = 7, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 4000, outfitMonster = "rat" },
	{ name = "djinn electrify", interval = 2000, chance = 15, range = 5, target = false },
	{ name = "djinn cancel invisibility", interval = 2000, chance = 10, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 15,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -13 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
