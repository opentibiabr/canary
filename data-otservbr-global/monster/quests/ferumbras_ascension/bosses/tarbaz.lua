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
	{ id = 3031, chance = 100000, maxCount = 369 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 45 }, -- Platinum Coin
	{ id = 22516, chance = 100000 }, -- Silver Token
	{ id = 6499, chance = 79000 }, -- Demonic Essence
	{ id = 7643, chance = 58000, maxCount = 13 }, -- Ultimate Health Potion
	{ id = 7642, chance = 58000, maxCount = 10 }, -- Great Spirit Potion
	{ id = 238, chance = 55000, maxCount = 12 }, -- Great Mana Potion
	{ id = 16119, chance = 53000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 6558, chance = 47000, maxCount = 8 }, -- Flask of Demonic Blood
	{ id = 16120, chance = 45000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 16121, chance = 45000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 3051, chance = 32000 }, -- Energy Ring
	{ id = 823, chance = 26000 }, -- Glacier Kilt
	{ id = 3038, chance = 26000 }, -- Green Gem
	{ id = 3032, chance = 24000, maxCount = 8 }, -- Small Emerald
	{ id = 3041, chance = 21000 }, -- Blue Gem
	{ id = 3030, chance = 21000, maxCount = 9 }, -- Small Ruby
	{ id = 3033, chance = 21000, maxCount = 9 }, -- Small Amethyst
	{ id = 9057, chance = 18400, maxCount = 9 }, -- Small Topaz
	{ id = 3039, chance = 18400 }, -- Red Gem
	{ id = 281, chance = 15800 }, -- Giant Shimmering Pearl
	{ id = 3028, chance = 15800, maxCount = 9 }, -- Small Diamond
	{ id = 3037, chance = 10500 }, -- Yellow Gem
	{ id = 22726, chance = 10500 }, -- Rift Shield
	{ id = 22727, chance = 10500 }, -- Rift Lance
	{ id = 815, chance = 10500 }, -- Glacier Amulet
	{ id = 3036, chance = 7900 }, -- Violet Gem
	{ id = 22867, chance = 7900 }, -- Rift Crossbow
	{ id = 8082, chance = 7900 }, -- Underworld Rod
	{ id = 824, chance = 7900 }, -- Glacier Robe
	{ id = 7421, chance = 5300 }, -- Onyx Flail
	{ id = 3326, chance = 5300 }, -- Epee
	{ id = 22866, chance = 5300 }, -- Rift Bow
	{ id = 7427, chance = 5300 }, -- Chaos Mace
	{ id = 6553, chance = 2600 }, -- Ruthless Axe
	{ id = 3414, chance = 2600 }, -- Mastermind Shield
	{ id = 7414, chance = 2600 }, -- Abyss Hammer
	{ id = 22757, chance = 2600 }, -- Shroud of Despair
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
