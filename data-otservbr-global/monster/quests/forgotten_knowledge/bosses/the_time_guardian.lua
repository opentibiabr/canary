local mType = Game.createMonsterType("The Time Guardian")
local monster = {}

monster.description = "The Time Guardian"
monster.experience = 50000
monster.outfit = {
	lookType = 945,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "undead"
monster.corpse = 25085
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
}

monster.bosstiary = {
	bossRaceId = 1290,
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
	{ text = "This place is sacred!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 30 }, -- Platinum Coin
	{ id = 16120, chance = 68750, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 16121, chance = 62500, maxCount = 3 }, -- Green Crystal Shard
	{ id = 16119, chance = 68750, maxCount = 3 }, -- Blue Crystal Shard
	{ id = 7643, chance = 45833, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 238, chance = 52083, maxCount = 5 }, -- Great Mana Potion
	{ id = 7642, chance = 58333, maxCount = 10 }, -- Great Spirit Potion
	{ id = 3030, chance = 14583, maxCount = 10 }, -- Small Ruby
	{ id = 3033, chance = 8695, maxCount = 10 }, -- Small Amethyst
	{ id = 3028, chance = 18750, maxCount = 10 }, -- Small Diamond
	{ id = 9057, chance = 27083, maxCount = 10 }, -- Small Topaz
	{ id = 24969, chance = 8000 }, -- Ancient Watch
	{ id = 3037, chance = 18750 }, -- Yellow Gem
	{ id = 3041, chance = 17073 }, -- Blue Gem
	{ id = 3038, chance = 17073 }, -- Green Gem
	{ id = 3036, chance = 7317 }, -- Violet Gem
	{ id = 7439, chance = 1000 }, -- Berserk Potion
	{ id = 7440, chance = 100000 }, -- Mastermind Potion
	{ id = 24970, chance = 1000 }, -- Frozen Time
	{ id = 10323, chance = 9756 }, -- Guardian Boots
	{ id = 12306, chance = 4347 }, -- Leather Whip
	{ id = 3081, chance = 33333 }, -- Stone Skin Amulet
	{ id = 3098, chance = 100000 }, -- Ring of Healing
	{ id = 11454, chance = 33333 }, -- Luminous Orb
	{ id = 5809, chance = 8695 }, -- Soul Stone
	{ id = 5904, chance = 18750 }, -- Magic Sulphur
	{ id = 821, chance = 4347 }, -- Magma Legs
	{ id = 3324, chance = 100000 }, -- Skull Staff
	{ id = 24956, chance = 4347 }, -- Part of a Rune (Three)
	{ id = 3439, chance = 4878 }, -- Phoenix Shield
	{ id = 22516, chance = 29166 }, -- Silver Token
	{ id = 22721, chance = 20833 }, -- Gold Token
	{ id = 7417, chance = 5555 }, -- Runed Sword
	{ id = 8076, chance = 1000 }, -- Spellscroll of Prophecies
	{ id = 20062, chance = 27083 }, -- Cluster of Solace
	{ id = 3032, chance = 20833 }, -- Small Emerald
	{ id = 281, chance = 17073 }, -- Giant Shimmering Pearl
	{ id = 7387, chance = 17073 }, -- Diamond Sceptre
	{ id = 824, chance = 7317 }, -- Glacier Robe
	{ id = 3039, chance = 16666 }, -- Red Gem
	{ id = 823, chance = 7317 }, -- Glacier Kilt
	{ id = 5892, chance = 10416 }, -- Huge Chunk of Crude Iron
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 190, attack = 300 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -780, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -780, length = 9, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -780, length = 9, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 20, minDamage = -2000, maxDamage = -2000, radius = 7, effect = CONST_ME_BLOCKHIT, target = false },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 20, minDamage = -2000, maxDamage = -2000, length = 9, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.defenses = {
	defense = 70,
	armor = 70,
	--	mitigation = ???,
	{ name = "time guardian", interval = 2000, chance = 10, target = false },
	{ name = "time guardiann", interval = 2000, chance = 10, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
	{ type = COMBAT_LIFEDRAIN, percent = 80 },
	{ type = COMBAT_MANADRAIN, percent = 80 },
	{ type = COMBAT_DROWNDAMAGE, percent = 80 },
	{ type = COMBAT_ICEDAMAGE, percent = 80 },
	{ type = COMBAT_HOLYDAMAGE, percent = 80 },
	{ type = COMBAT_DEATHDAMAGE, percent = 80 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
