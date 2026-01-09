local mType = Game.createMonsterType("Minotaur Amazon")
local monster = {}

monster.description = "a minotaur amazon"
monster.experience = 2200
monster.outfit = {
	lookType = 608,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1045
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Underground Glooth Factory, Oramond Minotaur Camp, Oramond Dungeon",
}

monster.health = 2600
monster.maxHealth = 2600
monster.race = "blood"
monster.corpse = 21000
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 11,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 240,
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
	{ text = "I'll protect the herd!", yell = false },
	{ text = "Never surrender!", yell = false },
	{ text = "You won't hurt us!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 199 }, -- Gold Coin
	{ id = 3035, chance = 65269, maxCount = 3 }, -- Platinum Coin
	{ id = 3582, chance = 59670 }, -- Ham
	{ id = 21204, chance = 19610 }, -- Cowbell
	{ id = 5878, chance = 16300 }, -- Minotaur Leather
	{ id = 238, chance = 7170 }, -- Great Mana Potion
	{ id = 239, chance = 6920 }, -- Great Health Potion
	{ id = 3577, chance = 7020 }, -- Meat
	{ id = 11472, chance = 5060, maxCount = 2 }, -- Minotaur Horn
	{ id = 3033, chance = 4890, maxCount = 2 }, -- Small Amethyst
	{ id = 3030, chance = 5070, maxCount = 2 }, -- Small Ruby
	{ id = 9057, chance = 5180, maxCount = 2 }, -- Small Topaz
	{ id = 3032, chance = 4520, maxCount = 2 }, -- Small Emerald
	{ id = 21175, chance = 3800 }, -- Mino Shield
	{ id = 7368, chance = 3010, maxCount = 5 }, -- Assassin Star
	{ id = 3098, chance = 2580 }, -- Ring of Healing
	{ id = 21174, chance = 1690 }, -- Mino Lance
	{ id = 3081, chance = 830 }, -- Stone Skin Amulet
	{ id = 3369, chance = 700 }, -- Warrior Helmet
	{ id = 5911, chance = 560 }, -- Red Piece of Cloth
	{ id = 7443, chance = 870 }, -- Bullseye Potion
	{ id = 3037, chance = 590 }, -- Yellow Gem
	{ id = 3039, chance = 480 }, -- Red Gem
	{ id = 9058, chance = 600 }, -- Gold Ingot
	{ id = 7401, chance = 260 }, -- Minotaur Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 50, attack = 50 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -305, length = 8, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -150, radius = 4, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -150, range = 7, shootEffect = CONST_ANI_HUNTINGSPEAR, effect = CONST_ME_EXPLOSIONAREA, target = false },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 40, minDamage = -300, maxDamage = -400, radius = 4, effect = CONST_ME_DRAWBLOOD, shootEffect = CONST_ANI_THROWINGKNIFE, target = true },
	{ name = "minotaur amazon paralyze", interval = 2000, chance = 15, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 37,
	mitigation = 1.18,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
