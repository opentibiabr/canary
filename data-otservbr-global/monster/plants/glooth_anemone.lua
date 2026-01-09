local mType = Game.createMonsterType("Glooth Anemone")
local monster = {}

monster.description = "a glooth anemone"
monster.experience = 1755
monster.outfit = {
	lookType = 604,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1042
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Rathleton Sewers, Underground Glooth Factory, Jaccus Maxxen's Dungeon.",
}

monster.health = 2400
monster.maxHealth = 2400
monster.race = "venom"
monster.corpse = 20988
monster.speed = 90
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 3,
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
	{ text = "*shglib*", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99989, maxCount = 175 }, -- Gold Coin
	{ id = 3035, chance = 50724, maxCount = 3 }, -- Platinum Coin
	{ id = 21197, chance = 16881 }, -- Slimy Leaf Tentacle
	{ id = 21144, chance = 9877 }, -- Bowl of Glooth Soup
	{ id = 9057, chance = 6508, maxCount = 4 }, -- Small Topaz
	{ id = 3032, chance = 6405, maxCount = 4 }, -- Small Emerald
	{ id = 3030, chance = 7961, maxCount = 4 }, -- Small Ruby
	{ id = 237, chance = 8767, maxCount = 2 }, -- Strong Mana Potion
	{ id = 236, chance = 7005, maxCount = 2 }, -- Strong Health Potion
	{ id = 21172, chance = 3674 }, -- Glooth Whip
	{ id = 3732, chance = 3037 }, -- Green Mushroom
	{ id = 7643, chance = 1635 }, -- Ultimate Health Potion
	{ id = 21180, chance = 815 }, -- Glooth Axe
	{ id = 21183, chance = 730 }, -- Glooth Amulet
	{ id = 21178, chance = 1472 }, -- Glooth Club
	{ id = 21158, chance = 892 }, -- Glooth Spear
	{ id = 21179, chance = 867 }, -- Glooth Blade
	{ id = 21164, chance = 698 }, -- Glooth Cape
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 60, attack = 50 },
	{ name = "combat", interval = 2000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -200, range = 7, radius = 4, shootEffect = CONST_ANI_GLOOTHSPEAR, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 2000, chance = 7, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -100, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, radius = 5, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 42,
	mitigation = 1.02,
	{ name = "combat", interval = 2000, chance = 9, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "glooth anemone summon", interval = 2000, chance = 14, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 35 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
