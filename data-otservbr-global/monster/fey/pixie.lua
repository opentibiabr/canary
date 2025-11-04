local mType = Game.createMonsterType("Pixie")
local monster = {}

monster.description = "a pixie"
monster.experience = 700
monster.outfit = {
	lookType = 982,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1438
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Feyrist.",
}

monster.health = 770
monster.maxHealth = 770
monster.race = "blood"
monster.corpse = 25811
monster.speed = 120
monster.manaCost = 450

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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 20,
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
	{ text = "Glamour, glitter, glistering things! Do you have any of those?", yell = false },
	{ text = "Sweet dreams!", yell = false },
	{ text = "You might be a threat! I'm sorry but I can't allow you to linger here.", yell = false },
	{ text = "Let's try a step or two!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 60360, maxCount = 90 }, -- Gold Coin
	{ id = 25691, chance = 17950 }, -- Wild Flowers
	{ id = 25695, chance = 14840 }, -- Dandelion Seeds
	{ id = 25692, chance = 9790, maxCount = 2 }, -- Fresh Fruit
	{ id = 25696, chance = 9720 }, -- Colourful Snail Shell
	{ id = 25735, chance = 8790, maxCount = 5 }, -- Leaf Star
	{ id = 3736, chance = 4980 }, -- Star Herb
	{ id = 3046, chance = 4560 }, -- Magic Light Wand
	{ id = 238, chance = 3250 }, -- Great Mana Potion
	{ id = 3658, chance = 3120 }, -- Red Rose
	{ id = 25737, chance = 3020, maxCount = 3 }, -- Rainbow Quartz
	{ id = 678, chance = 2070, maxCount = 2 }, -- Small Enchanted Amethyst
	{ id = 3732, chance = 1660 }, -- Green Mushroom
	{ id = 237, chance = 850 }, -- Strong Mana Potion
	{ id = 25700, chance = 550 }, -- Dream Blossom Staff
	{ id = 25698, chance = 630 }, -- Butterfly Ring
	{ id = 25699, chance = 350 }, -- Wooden Spellbook
	{ id = 9057, chance = 1000 }, -- Small Topaz
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -85, maxDamage = -135, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "speed", interval = 2000, chance = 11, speedChange = -440, length = 4, spread = 2, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 7000 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -100, range = 4, shootEffect = CONST_ANI_LEAFSTAR, target = false },
	{ name = "pixie skill reducer", interval = 2000, chance = 20, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 50,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 40, maxDamage = 75, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 60 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 60 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
