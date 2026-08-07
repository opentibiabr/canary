local mType = Game.createMonsterType("The Rootkraken")
local monster = {}

monster.name = "The Rootkraken"
monster.experience = 600000
monster.outfit = {
	lookType = 1765,
}

monster.bosstiary = {
	bossRaceId = 2528,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 360000
monster.maxHealth = 360000
monster.race = "venom"
monster.corpse = 49124
monster.speed = 180

monster.changeTarget = {
	interval = 4000,
	chance = 25,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	attackable = true,
	hostile = true,
	summonable = false,
	convinceable = false,
	illusionable = false,
	boss = true,
	rewardBoss = true,
	ignoreSpawnBlock = false,
	pushable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
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
	{ text = "", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 100000, maxCount = 3 }, -- Crystal Coin
	{ id = 3035, chance = 100000, maxCount = 100 }, -- Platinum Coin
	{ id = 7643, chance = 46000, maxCount = 20 }, -- Ultimate Health Potion
	{ id = 7642, chance = 44000, maxCount = 14 }, -- Great Spirit Potion
	{ id = 32626, chance = 41000 }, -- Amber (Item)
	{ id = 238, chance = 32000, maxCount = 14 }, -- Great Mana Potion
	{ id = 23375, chance = 31000, maxCount = 8 }, -- Supreme Health Potion
	{ id = 237, chance = 24000, maxCount = 20 }, -- Strong Mana Potion
	{ id = 3041, chance = 24000, maxCount = 2 }, -- Blue Gem
	{ id = 32624, chance = 24000 }, -- Amber with a Bug
	{ id = 23374, chance = 24000, maxCount = 15 }, -- Ultimate Spirit Potion
	{ id = 3037, chance = 22000, maxCount = 2 }, -- Yellow Gem
	{ id = 32769, chance = 20000, maxCount = 2 }, -- White Gem
	{ id = 32625, chance = 18600 }, -- Amber with a Dragonfly
	{ id = 32623, chance = 6800 }, -- Giant Topaz
	{ id = 50152, chance = 6800 }, -- Collar of Orange Plasma
	{ id = 48516, chance = 6800 }, -- Root Tentacle
	{ id = 32622, chance = 5100 }, -- Giant Amethyst
	{ id = 30061, chance = 3400 }, -- Giant Sapphire
	{ id = 30060, chance = 1700 }, -- Giant Emerald
	{ id = 48517, chance = 1700 }, -- Fish Eye
	{ id = 46628, chance = 1700 }, -- Amber Crusher
	{ id = 48514, chance = 1700 }, -- Strange Inedible Fruit
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -800, maxDamage = -1200 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_DEATHDAMAGE, minDamage = -450, maxDamage = -700, range = 6, shootEffect = CONST_ANI_DEATH, target = false },
}

monster.defenses = {
	defense = 85,
	armor = 85,
	mitigation = 2.00,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
