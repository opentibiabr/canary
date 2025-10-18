local mType = Game.createMonsterType("The Dread Maiden")
local monster = {}

monster.description = "The Dread Maiden"
monster.experience = 72000
monster.outfit = {
	lookType = 1278,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"FeasterOfSoulsBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1872,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 32744
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
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
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
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
	{ text = "You will be mine for eternity!", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 99512, maxCount = 2 }, -- Crystal Coin
	{ id = 32769, chance = 42439 }, -- White Gem
	{ id = 32771, chance = 47804, maxCount = 2 }, -- Moonstone
	{ id = 23375, chance = 30731, maxCount = 6 }, -- Supreme Health Potion
	{ id = 23374, chance = 40975, maxCount = 6 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 27804, maxCount = 6 }, -- Ultimate Mana Potion
	{ id = 7439, chance = 16097, maxCount = 10 }, -- Berserk Potion
	{ id = 7440, chance = 18048, maxCount = 10 }, -- Mastermind Potion
	{ id = 7443, chance = 17073, maxCount = 10 }, -- Bullseye Potion
	{ id = 32770, chance = 41463 }, -- Diamond
	{ id = 32622, chance = 3414 }, -- Giant Amethyst
	{ id = 32773, chance = 12682 }, -- Ivory Comb
	{ id = 32774, chance = 8780 }, -- Cursed Bone
	{ id = 32589, chance = 9268 }, -- Angel Figurine
	{ id = 32772, chance = 13170 }, -- Silver Hand Mirror
	{ id = 32703, chance = 10731, maxCount = 2 }, -- Death Toll
	{ id = 32595, chance = 4878 }, -- Jagged Sickle
	{ id = 32626, chance = 5853 }, -- Amber (Item)
	{ id = 32625, chance = 2941 }, -- Amber with a Dragonfly
	{ id = 32624, chance = 2824 }, -- Amber with a Bug
	{ id = 32591, chance = 13559 }, -- Soulforged Lantern
	{ id = 32630, chance = 3902 }, -- Spooky Hood
	{ id = 32619, chance = 1219 }, -- Pair of Nightmare Boots
	{ id = 32631, chance = 2259 }, -- Ghost Claw
	{ id = 32596, chance = 2439 }, -- Dark Bell (Silver)
	{ id = 32623, chance = 2941 }, -- Giant Topaz
	{ id = 50185, chance = 1000 }, -- Jade Legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -600, condition = { type = CONDITION_POISON, totalDamage = 4, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -350, maxDamage = -750, radius = 4, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 4000, chance = 50, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -1500, length = 7, effect = CONST_ME_POFF, target = false },
	{ name = "dread rcircle", interval = 2000, chance = 40, minDamage = -400, maxDamage = -1000 },
}

monster.defenses = {
	defense = 170,
	armor = 170,
	--	mitigation = ???,
	{ name = "speed", interval = 10000, chance = 40, speedChange = 510, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000 },
	{ name = "combat", interval = 5000, chance = 60, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
