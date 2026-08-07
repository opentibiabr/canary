local mType = Game.createMonsterType("Shulgrax")
local monster = {}

monster.description = "Shulgrax"
monster.experience = 500000
monster.outfit = {
	lookType = 842,
	lookHead = 0,
	lookBody = 62,
	lookLegs = 2,
	lookFeet = 87,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.health = 40000
monster.maxHealth = 40000
monster.race = "undead"
monster.corpse = 22495
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1191,
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
	{ text = "DAMMMMNNNNAAATIONN!", yell = false },
	{ text = "I WILL FEAST ON YOUR SOUL!", yell = true },
	{ text = "YOU ARE ALL DAMNED!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 353 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 39 }, -- Platinum Coin
	{ id = 22516, chance = 100000 }, -- Silver Token
	{ id = 6499, chance = 83000 }, -- Demonic Essence
	{ id = 22194, chance = 69000, maxCount = 9 }, -- Opal
	{ id = 7642, chance = 66000, maxCount = 12 }, -- Great Spirit Potion
	{ id = 22193, chance = 60000, maxCount = 9 }, -- Onyx Chip
	{ id = 7643, chance = 57000, maxCount = 14 }, -- Ultimate Health Potion
	{ id = 6558, chance = 51000, maxCount = 9 }, -- Flask of Demonic Blood
	{ id = 238, chance = 49000, maxCount = 15 }, -- Great Mana Potion
	{ id = 6299, chance = 37000 }, -- Death Ring
	{ id = 281, chance = 29000 }, -- Giant Shimmering Pearl
	{ id = 3030, chance = 26000, maxCount = 8 }, -- Small Ruby
	{ id = 3032, chance = 23000, maxCount = 8 }, -- Small Emerald
	{ id = 3038, chance = 23000 }, -- Green Gem
	{ id = 3028, chance = 20000, maxCount = 8 }, -- Small Diamond
	{ id = 17828, chance = 20000 }, -- Pair of Iron Fists
	{ id = 3041, chance = 20000 }, -- Blue Gem
	{ id = 22727, chance = 17100 }, -- Rift Lance
	{ id = 3033, chance = 17100, maxCount = 9 }, -- Small Amethyst
	{ id = 822, chance = 17100 }, -- Lightning Legs
	{ id = 9057, chance = 14300, maxCount = 8 }, -- Small Topaz
	{ id = 3037, chance = 11400 }, -- Yellow Gem
	{ id = 22726, chance = 11400 }, -- Rift Shield
	{ id = 8082, chance = 11400 }, -- Underworld Rod
	{ id = 3039, chance = 11400 }, -- Red Gem
	{ id = 8092, chance = 8600 }, -- Wand of Starstorm
	{ id = 22867, chance = 8600 }, -- Rift Crossbow
	{ id = 7451, chance = 8600 }, -- Shadow Sceptre
	{ id = 816, chance = 8600 }, -- Lightning Pendant
	{ id = 3420, chance = 5700 }, -- Demon Shield
	{ id = 3366, chance = 2900 }, -- Magic Plate Armor
	{ id = 22866, chance = 2900 }, -- Rift Bow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1500, maxDamage = -2500 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1000, length = 10, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "speed", interval = 2000, chance = 25, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -700, radius = 5, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_FIREATTACK, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 6000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "shulgrax summon", interval = 5000, chance = 5, target = false },
	{ name = "speed", interval = 4000, chance = 80, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
