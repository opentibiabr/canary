local mType = Game.createMonsterType("Grynch Clan Goblin")
local monster = {}

monster.description = "a grynch clan goblin"
monster.experience = 4
monster.outfit = {
	lookType = 61,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 393
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 5,
	FirstUnlock = 2,
	SecondUnlock = 3,
	CharmsPoints = 10,
	Stars = 1,
	Occurrence = 3,
	Locations = "They do not have a set respawn spot. They are announced to be stealing presents from a \z
			random Tibian city and spawn in the aforetold city. \z
			There are two or three messages that appear on each raid and three massive spawns of goblins.",
}

monster.health = 80
monster.maxHealth = 80
monster.race = "blood"
monster.corpse = 6002
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	hostile = false,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 0,
	targetDistance = 11,
	runHealth = 80,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "T'was not me hand in your pocket!", yell = false },
	{ text = "Look! Cool stuff in house. Let's get it!", yell = false },
	{ text = "Uhh! Nobody home! <chuckle>", yell = false },
	{ text = "Me just borrowed it!", yell = false },
	{ text = "Me no steal! Me found it!", yell = false },
	{ text = "Me had it for five minutes. It's family heirloom now!", yell = false },
	{ text = "Nice human won't hurt little, good goblin?", yell = false },
	{ text = "Gimmegimme!", yell = false },
	{ text = "Invite me in you lovely house plx!", yell = false },
	{ text = "Other Goblin stole it!", yell = false },
	{ text = "All presents mine!", yell = false },
	{ text = "Me got ugly ones purse", yell = false },
	{ text = "Free itans plz!", yell = false },
	{ text = "Not me! Not me!", yell = false },
	{ text = "Guys, help me here! Guys? Guys???", yell = false },
	{ text = "That only much dust in me pocket! Honest!", yell = false },
	{ text = "Can me have your stuff?", yell = false },
	{ text = "Halp, Big dumb one is after me!", yell = false },
	{ text = "Uh, So many shiny things!", yell = false },
	{ text = "Utani hur hur hur!", yell = false },
	{ text = "Mee? Stealing? Never!!!", yell = false },
	{ text = "Oh what fun it is to steal a one-horse open sleigh!", yell = false },
	{ text = "Must have it! Must have it!", yell = false },
	{ text = "Where me put me lockpick?", yell = false },
	{ text = "Catch me if you can!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 16 }, -- gold coin
	{ id = 6496, chance = 80000 }, -- christmas present bag
	{ id = 2992, chance = 23000, maxCount = 3 }, -- snowball
	{ id = 3598, chance = 23000, maxCount = 5 }, -- cookie
	{ id = 3585, chance = 23000, maxCount = 3 }, -- red apple
	{ id = 6276, chance = 5000 }, -- lump of cake dough
	{ id = 3586, chance = 5000, maxCount = 2 }, -- orange
	{ id = 836, chance = 5000, maxCount = 4 }, -- walnut
	{ id = 841, chance = 1000, maxCount = 5 }, -- peanut
	{ id = 2875, chance = 1000 }, -- bottle
	{ id = 3572, chance = 1000 }, -- scarf
	{ id = 3599, chance = 1000, maxCount = 3 }, -- candy cane
	{ id = 25087, chance = 1000, maxCount = 2 }, -- egg
	{ id = 4871, chance = 1000 }, -- explorer brooch
	{ id = 5894, chance = 1000, maxCount = 3 }, -- bat wing
	{ id = 10207, chance = 1000 }, -- snowman package
	{ id = 3590, chance = 260, maxCount = 4 }, -- cherry
	{ id = 6393, chance = 260 }, -- cream cake
	{ id = 3258, chance = 260 }, -- lute
	{ id = 3147, chance = 260 }, -- blank rune
	{ id = 3047, chance = 260 }, -- magic light wand
	{ id = 6500, chance = 260 }, -- gingerbreadman
	{ id = 5890, chance = 260, maxCount = 3 }, -- chicken feather
	{ id = 5902, chance = 260 }, -- honeycomb
	{ id = 6392, chance = 260 }, -- valentines cake
	{ id = 2906, chance = 260 }, -- watch
	{ id = 3454, chance = 260 }, -- broom
	{ id = 2995, chance = 260 }, -- piggy bank
	{ id = 33784, chance = 260 }, -- mirror
	{ id = 2392, chance = 260 }, -- small white pillow
	{ id = 24841, chance = 260 }, -- flower bowl
	{ id = 3042, chance = 260 }, -- scarab coin
	{ id = 5021, chance = 260 }, -- orichalcum pearl
	{ id = 31366, chance = 260 }, -- rope
}

monster.attacks = {}

monster.defenses = {
	defense = 12,
	armor = 5,
	mitigation = 0.25,
	{ name = "speed", interval = 1000, chance = 15, speedChange = 500, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
