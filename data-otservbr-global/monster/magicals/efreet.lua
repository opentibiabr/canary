local mType = Game.createMonsterType("Efreet")
local monster = {}

monster.description = "an efreet"
monster.experience = 410
monster.outfit = {
	lookType = 103,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 103
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Mal'ouquah, Deeper Banuta, Goromas Cult Cave (in the classroom), Magician Quarter.",
}

monster.health = 550
monster.maxHealth = 550
monster.race = "blood"
monster.corpse = 6032
monster.speed = 117
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "green djinn", chance = 10, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I grant you a deathwish!", yell = false },
	{ text = "I wish you a merry trip to hell!", yell = false },
	{ text = "Good wishes are for fairytales", yell = false },
	{ text = "Muhahahaha!", yell = false },
	{ text = "Tell me your last wish!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 98039, maxCount = 130 }, -- Gold Coin
	{ id = 11470, chance = 7750 }, -- Jewelled Belt
	{ id = 3584, chance = 19619, maxCount = 5 }, -- Pear
	{ id = 7378, chance = 16491, maxCount = 3 }, -- Royal Spear
	{ id = 3032, chance = 7045 }, -- Small Emerald
	{ id = 237, chance = 9863 }, -- Strong Mana Potion
	{ id = 5910, chance = 3550 }, -- Green Piece of Cloth
	{ id = 2647, chance = 2395 }, -- Green Tapestry
	{ id = 3330, chance = 15120 }, -- Heavy Machete
	{ id = 3071, chance = 692 }, -- Wand of Inferno
	{ id = 11486, chance = 1020 }, -- Noble Turban
	{ id = 827, chance = 497 }, -- Magma Monocle
	{ id = 3574, chance = 190 }, -- Mystic Turban
	{ id = 2933, chance = 10089 }, -- Small Oil Lamp
	{ id = 3038, chance = 110 }, -- Green Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -40, maxDamage = -110, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -30, maxDamage = -90, radius = 3, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -65, maxDamage = -120, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -650, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, target = false, duration = 6000 },
	{ name = "outfit", interval = 2000, chance = 1, range = 7, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 4000, outfitMonster = "rat" },
	{ name = "djinn electrify", interval = 2000, chance = 15, range = 5, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 24,
	mitigation = 0.91,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 60 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 90 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -8 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
