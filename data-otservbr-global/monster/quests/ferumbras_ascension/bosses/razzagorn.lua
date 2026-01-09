local mType = Game.createMonsterType("Razzagorn")
local monster = {}

monster.description = "Razzagorn"
monster.experience = 500000
monster.outfit = {
	lookType = 842,
	lookHead = 78,
	lookBody = 94,
	lookLegs = 13,
	lookFeet = 126,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.bosstiary = {
	bossRaceId = 1177,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "fire"
monster.corpse = 22495
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Eruption of Destruction", chance = 15, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "YOUR FUTILE ATTACKS ONLY FEED MY RAGE!", yell = false },
	{ text = "YOU-ARE-WEAK!!", yell = false },
	{ text = "DEEESTRUCTIOOON!!", yell = false },
}

monster.loot = {
	{ id = 22762, chance = 1000 }, -- Maimer
	{ id = 3422, chance = 1000 }, -- Great Shield
	{ id = 22754, chance = 1000 }, -- Visage of the End Days
	{ id = 22727, chance = 9090 }, -- Rift Lance
	{ id = 3039, chance = 21818 }, -- Red Gem
	{ id = 3032, chance = 23636, maxCount = 5 }, -- Small Emerald
	{ id = 238, chance = 67272, maxCount = 5 }, -- Great Mana Potion
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 22194, chance = 100000, maxCount = 5 }, -- Opal
	{ id = 22193, chance = 100000, maxCount = 5 }, -- Onyx Chip
	{ id = 7642, chance = 50909, maxCount = 5 }, -- Great Spirit Potion
	{ id = 6499, chance = 78181 }, -- Demonic Essence
	{ id = 3035, chance = 100000, maxCount = 25 }, -- Platinum Coin
	{ id = 22516, chance = 100000 }, -- Silver Token
	{ id = 6558, chance = 52727 }, -- Flask of Demonic Blood
	{ id = 7643, chance = 52727 }, -- Ultimate Health Potion
	{ id = 3041, chance = 25454 }, -- Blue Gem
	{ id = 3028, chance = 25454 }, -- Small Diamond
	{ id = 3036, chance = 10909 }, -- Violet Gem
	{ id = 3030, chance = 20000 }, -- Small Ruby
	{ id = 5021, chance = 16363 }, -- Orichalcum Pearl
	{ id = 22867, chance = 7894 }, -- Rift Crossbow
	{ id = 3038, chance = 15789 }, -- Green Gem
	{ id = 3029, chance = 17647 }, -- Small Sapphire
	{ id = 7443, chance = 5882 }, -- Bullseye Potion
	{ id = 3037, chance = 33333 }, -- Yellow Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1000, maxDamage = -2000 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1000, length = 10, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "speed", interval = 2000, chance = 25, speedChange = -600, radius = 7, effect = CONST_ME_GREEN_RINGS, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -700, radius = 7, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -700, radius = 5, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -1500, maxDamage = -1800, length = 12, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 145,
	armor = 188,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 3000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 8, speedChange = 480, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
	{ name = "razzagorn summon", interval = 2000, chance = 3, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
