local mType = Game.createMonsterType("Tarbaz")
local monster = {}

monster.description = "Tarbaz"
monster.experience = 500000
monster.outfit = {
	lookType = 842,
	lookHead = 0,
	lookBody = 21,
	lookLegs = 19,
	lookFeet = 3,
	lookAddons = 2,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "undead"
monster.corpse = 22495
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1188,
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
	canPushCreatures = true,
	staticAttackChance = 90,
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
	{ text = "You are a failure.", yell = false },
}

monster.loot = {
	{ id = 22762, chance = 1000 }, -- Maimer
	{ id = 22757, chance = 2857 }, -- Shroud of Despair
	{ id = 22516, chance = 100000 }, -- Silver Token
	{ id = 3035, chance = 100000 }, -- Platinum Coin
	{ id = 22726, chance = 10909 }, -- Rift Shield
	{ id = 7427, chance = 10526 }, -- Chaos Mace
	{ id = 16119, chance = 50909 }, -- Blue Crystal Shard
	{ id = 238, chance = 54545 }, -- Great Mana Potion
	{ id = 3037, chance = 14545 }, -- Yellow Gem
	{ id = 16121, chance = 45454 }, -- Green Crystal Shard
	{ id = 3031, chance = 100000 }, -- Gold Coin
	{ id = 6558, chance = 49090 }, -- Flask of Demonic Blood
	{ id = 3051, chance = 34545 }, -- Energy Ring
	{ id = 7643, chance = 56363 }, -- Ultimate Health Potion
	{ id = 8082, chance = 10526 }, -- Underworld Rod
	{ id = 6499, chance = 76363 }, -- Demonic Essence
	{ id = 9057, chance = 27272 }, -- Small Topaz
	{ id = 7642, chance = 60000 }, -- Great Spirit Potion
	{ id = 3038, chance = 23636 }, -- Green Gem
	{ id = 16120, chance = 38181 }, -- Violet Crystal Shard
	{ id = 3032, chance = 23076 }, -- Small Emerald
	{ id = 3041, chance = 15384 }, -- Blue Gem
	{ id = 823, chance = 23076 }, -- Glacier Kilt
	{ id = 3039, chance = 26923 }, -- Red Gem
	{ id = 3028, chance = 17307 }, -- Small Diamond
	{ id = 824, chance = 13461 }, -- Glacier Robe
	{ id = 3326, chance = 9615 }, -- Epee
	{ id = 815, chance = 11538 }, -- Glacier Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1000, maxDamage = -2000 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1000, length = 10, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "speed", interval = 2000, chance = 25, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -700, radius = 5, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_FIREATTACK, target = false },
}

monster.defenses = {
	defense = 120,
	armor = 100,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 900, maxDamage = 3500, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "speed", interval = 3000, chance = 30, speedChange = 460, effect = CONST_ME_MAGIC_RED, target = false, duration = 7000 },
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
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
