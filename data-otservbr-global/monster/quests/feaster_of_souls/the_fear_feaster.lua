local mType = Game.createMonsterType("The Fear Feaster")
local monster = {}

monster.description = "The Fear Feaster"
monster.experience = 30000
monster.outfit = {
	lookType = 1276,
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

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 32737
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
	chance = 0,
}

monster.bosstiary = {
	bossRaceId = 1873,
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
	{ id = 3043, chance = 99230, maxCount = 2 }, -- Crystal Coin
	{ id = 32769, chance = 55769, maxCount = 2 }, -- White Gem
	{ id = 32772, chance = 21153 }, -- Silver Hand Mirror
	{ id = 7443, chance = 24230, maxCount = 10 }, -- Bullseye Potion
	{ id = 7439, chance = 22692, maxCount = 10 }, -- Berserk Potion
	{ id = 7440, chance = 18846, maxCount = 10 }, -- Mastermind Potion
	{ id = 32703, chance = 15384, maxCount = 2 }, -- Death Toll
	{ id = 32771, chance = 50000, maxCount = 2 }, -- Moonstone
	{ id = 23375, chance = 30384, maxCount = 6 }, -- Supreme Health Potion
	{ id = 23374, chance = 30384, maxCount = 6 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 38461, maxCount = 6 }, -- Ultimate Mana Potion
	{ id = 32589, chance = 11538 }, -- Angel Figurine
	{ id = 32593, chance = 2702 }, -- Grimace
	{ id = 32626, chance = 4230 }, -- Amber (Item)
	{ id = 32625, chance = 2631 }, -- Amber with a Dragonfly
	{ id = 32774, chance = 13461 }, -- Cursed Bone
	{ id = 32773, chance = 10769 }, -- Ivory Comb
	{ id = 32594, chance = 1923 }, -- Bloody Tears
	{ id = 32770, chance = 17307 }, -- Diamond
	{ id = 32591, chance = 13461 }, -- Soulforged Lantern
	{ id = 32628, chance = 1801 }, -- Ghost Chestplate
	{ id = 32630, chance = 2307 }, -- Spooky Hood
	{ id = 32631, chance = 1973 }, -- Ghost Claw
	{ id = 32622, chance = 657 }, -- Giant Amethyst
	{ id = 32623, chance = 1801 }, -- Giant Topaz
	{ id = 32624, chance = 1153 }, -- Amber with a Bug
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
	defense = 170,
	armor = 160,
	--	mitigation = ???,
	{ name = "speed", interval = 10000, chance = 40, speedChange = 510, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000 },
	{ name = "combat", interval = 5000, chance = 60, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
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
