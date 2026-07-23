local mType = Game.createMonsterType("The Pale Worm")
local monster = {}

monster.description = "The Pale Worm"
monster.experience = 30000
monster.outfit = {
	lookType = 1272,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 420000
monster.maxHealth = 420000
monster.race = "undead"
monster.corpse = 32702
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"paleWormDeath",
	"FeasterOfSoulsBossDeath",
}

monster.changeTarget = {
	interval = 60000,
	chance = 0,
}

monster.bosstiary = {
	bossRaceId = 1881,
	bossRace = RARITY_ARCHFOE,
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
	runHealth = 1,
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
}

monster.loot = {
	{ id = 3043, chance = 99000, maxCount = 5 }, -- Crystal Coin
	{ id = 32771, chance = 54000, maxCount = 2 }, -- Moonstone
	{ id = 32770, chance = 44000, maxCount = 2 }, -- Diamond
	{ id = 23373, chance = 36000, maxCount = 11 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 32000, maxCount = 11 }, -- Supreme Health Potion
	{ id = 23374, chance = 30000, maxCount = 11 }, -- Ultimate Spirit Potion
	{ id = 32769, chance = 24000 }, -- White Gem
	{ id = 7443, chance = 22000, maxCount = 19 }, -- Bullseye Potion
	{ id = 7439, chance = 20000, maxCount = 19 }, -- Berserk Potion
	{ id = 32774, chance = 19200 }, -- Cursed Bone
	{ id = 32703, chance = 17200, maxCount = 4 }, -- Death Toll
	{ id = 32773, chance = 17200 }, -- Ivory Comb
	{ id = 7440, chance = 15200, maxCount = 18 }, -- Mastermind Potion
	{ id = 32772, chance = 14100 }, -- Silver Hand Mirror
	{ id = 32589, chance = 9100 }, -- Angel Figurine
	{ id = 49271, chance = 7100, maxCount = 19 }, -- Transcendence Potion
	{ id = 32625, chance = 6100 }, -- Amber with a Dragonfly
	{ id = 32626, chance = 6100 }, -- Amber (Item)
	{ id = 32629, chance = 5100 }, -- Spectral Scrap of Cloth
	{ id = 32624, chance = 3000 }, -- Amber with a Bug
	{ id = 32597, chance = 3000 }, -- Ravenous Circlet
	{ id = 32617, chance = 2000 }, -- Fabulous Legs
	{ id = 32598, chance = 2000 }, -- Pale Worm's Scalp
	{ id = 32616, chance = 2000 }, -- Phantasmal Axe
	{ id = 32623, chance = 2000 }, -- Giant Topaz
	{ id = 32619, chance = 1000 }, -- Pair of Nightmare Boots
	{ id = 32622, chance = 1000 }, -- Giant Amethyst
	{ id = 32621, chance = 1000 }, -- Ring of Souls
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 600, maxDamage = -1050, condition = { type = CONDITION_POISON, totalDamage = 4, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_LIFEDRAIN, minDamage = -900, maxDamage = -1400, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 1000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -1000, maxDamage = -1750, radius = 2, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "drunk", interval = 1000, chance = 70, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "strength", interval = 1000, chance = 60, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -900, length = 5, spread = 3, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -600, maxDamage = -1200, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "speed", interval = 3000, chance = 40, speedChange = -700, effect = CONST_ME_MAGIC_RED, target = true, duration = 20000 },
}

monster.defenses = {
	defense = 150,
	armor = 150,
	--	mitigation = ???,
	{ name = "speed", interval = 10000, chance = 40, speedChange = 510, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000 },
	{ name = "combat", interval = 5000, chance = 60, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
