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
	{ id = 3031, chance = 80000, maxCount = 90 }, -- gold coin
	{ id = 25691, chance = 23000 }, -- wild flowers
	{ id = 25695, chance = 23000 }, -- dandelion seeds
	{ id = 25692, chance = 23000, maxCount = 2 }, -- fresh fruit
	{ id = 25696, chance = 23000 }, -- colourful snail shell
	{ id = 25735, chance = 23000, maxCount = 5 }, -- leaf star
	{ id = 3736, chance = 5000 }, -- star herb
	{ id = 3047, chance = 5000 }, -- magic light wand
	{ id = 238, chance = 5000 }, -- great mana potion
	{ id = 3658, chance = 5000 }, -- red rose
	{ id = 25737, chance = 5000, maxCount = 3 }, -- rainbow quartz
	{ id = 678, chance = 5000, maxCount = 2 }, -- small enchanted amethyst
	{ id = 3732, chance = 5000 }, -- green mushroom
	{ id = 237, chance = 1000 }, -- strong mana potion
	{ id = 25700, chance = 1000 }, -- dream blossom staff
	{ id = 25698, chance = 1000 }, -- butterfly ring
	{ id = 25699, chance = 260 }, -- wooden spellbook
	{ id = 9057, chance = 80000 }, -- small topaz
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
