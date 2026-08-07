local mType = Game.createMonsterType("Glooth Golem")
local monster = {}

monster.description = "a glooth golem"
monster.experience = 1606
monster.outfit = {
	lookType = 600,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1038
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Glooth Factory, Underground Glooth Factory, Rathleton Sewers, Jaccus Maxxens Dungeon, \z
		Oramond Dungeon (depending on Magistrate votes).",
}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "venom"
monster.corpse = 20972
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	{ text = "*slosh*", yell = false },
	{ text = "*clank*", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 59000, maxCount = 4 }, -- Platinum Coin
	{ id = 21103, chance = 15100 }, -- Glooth Injection Tube
	{ id = 238, chance = 12100 }, -- Great Mana Potion
	{ id = 21143, chance = 10200 }, -- Glooth Sandwich
	{ id = 3032, chance = 8100, maxCount = 4 }, -- Small Emerald
	{ id = 9057, chance = 7800, maxCount = 4 }, -- Small Topaz
	{ id = 7643, chance = 5000 }, -- Ultimate Health Potion
	{ id = 21755, chance = 3100 }, -- Bronze Gear Wheel
	{ id = 5880, chance = 2000 }, -- Iron Ore
	{ id = 8775, chance = 1800 }, -- Gear Wheel
	{ id = 21180, chance = 1500 }, -- Glooth Axe
	{ id = 21158, chance = 1500 }, -- Glooth Spear
	{ id = 21183, chance = 1500 }, -- Glooth Amulet
	{ id = 21179, chance = 1500 }, -- Glooth Blade
	{ id = 21167, chance = 1400 }, -- Heat Core
	{ id = 21178, chance = 1100 }, -- Glooth Club
	{ id = 21165, chance = 1000 }, -- Rubber Cap
	{ id = 21170, chance = 940 }, -- Gearwheel Chain
	{ id = 3037, chance = 740 }, -- Yellow Gem
	{ id = 3038, chance = 73 }, -- Green Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 60, attack = 50 },
	{ name = "melee", interval = 2000, chance = 2, skill = 86, attack = 100 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -125, maxDamage = -245, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "war golem skill reducer", interval = 2000, chance = 16, target = false },
	{ name = "war golem electrify", interval = 2000, chance = 9, range = 7, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 43,
	mitigation = 1.37,
	{ name = "speed", interval = 2000, chance = 13, speedChange = 404, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
