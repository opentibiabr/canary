local mType = Game.createMonsterType("Plagirath")
local monster = {}

monster.description = "Plagirath"
monster.experience = 500000
monster.outfit = {
	lookType = 862,
	lookHead = 84,
	lookBody = 62,
	lookLegs = 60,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.bosstiary = {
	bossRaceId = 1199,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "venom"
monster.corpse = 22495
monster.speed = 160
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
	{ text = "I CAN SENSE YOUR BODY ROTTING!", yell = true },
	{ text = "WITHER AND DIE!", yell = true },
	{ text = "COME AND RECEIVE MY GIFTS!!", yell = true },
	{ text = "DEATH AND DECAY!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 390 }, -- Gold Coin
	{ id = 22516, chance = 100000 }, -- Silver Token
	{ id = 3035, chance = 100000, maxCount = 36 }, -- Platinum Coin
	{ id = 16125, chance = 77000, maxCount = 11 }, -- Cyan Crystal Fragment
	{ id = 16126, chance = 77000, maxCount = 11 }, -- Red Crystal Fragment
	{ id = 6499, chance = 70000 }, -- Demonic Essence
	{ id = 16127, chance = 67000, maxCount = 11 }, -- Green Crystal Fragment
	{ id = 7643, chance = 58000, maxCount = 18 }, -- Ultimate Health Potion
	{ id = 6558, chance = 56000, maxCount = 9 }, -- Flask of Demonic Blood
	{ id = 7642, chance = 51000, maxCount = 11 }, -- Great Spirit Potion
	{ id = 238, chance = 49000, maxCount = 13 }, -- Great Mana Potion
	{ id = 9057, chance = 33000, maxCount = 9 }, -- Small Topaz
	{ id = 3038, chance = 33000 }, -- Green Gem
	{ id = 3033, chance = 28000, maxCount = 9 }, -- Small Amethyst
	{ id = 3098, chance = 26000 }, -- Ring of Healing
	{ id = 3037, chance = 23000 }, -- Yellow Gem
	{ id = 3039, chance = 16300 }, -- Red Gem
	{ id = 811, chance = 14000 }, -- Terra Mantle
	{ id = 812, chance = 14000 }, -- Terra Legs
	{ id = 3041, chance = 14000 }, -- Blue Gem
	{ id = 3028, chance = 14000, maxCount = 8 }, -- Small Diamond
	{ id = 3032, chance = 11600, maxCount = 9 }, -- Small Emerald
	{ id = 3030, chance = 11600, maxCount = 9 }, -- Small Ruby
	{ id = 7388, chance = 9300 }, -- Vile Axe
	{ id = 22726, chance = 9300 }, -- Rift Shield
	{ id = 281, chance = 9300 }, -- Giant Shimmering Pearl
	{ id = 10389, chance = 7000 }, -- Traditional Sai
	{ id = 814, chance = 7000 }, -- Terra Amulet
	{ id = 22727, chance = 7000 }, -- Rift Lance
	{ id = 16117, chance = 4700 }, -- Muck Rod
	{ id = 11657, chance = 4700 }, -- Twiceslicer
	{ id = 8073, chance = 4700 }, -- Spellbook of Warding
	{ id = 22866, chance = 2300 }, -- Rift Bow
	{ id = 22867, chance = 2300 }, -- Rift Crossbow
	{ id = 7386, chance = 2300 }, -- Mercenary Sword
	{ id = 3036, chance = 2300 }, -- Violet Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1300, maxDamage = -2250 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -900, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, range = 4, radius = 4, effect = CONST_ME_POFF, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -1000, maxDamage = -1200, length = 10, spread = 3, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -1500, maxDamage = -1900, length = 10, spread = 3, effect = CONST_ME_POFF, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000 },
	{ name = "plagirath bog", interval = 20000, chance = 25, target = false },
}

monster.defenses = {
	defense = 125,
	armor = 125,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 3000, maxDamage = 4000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 30, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
	{ name = "plagirath summon", interval = 2000, chance = 15, target = false },
	{ name = "plagirath heal", interval = 2000, chance = 17, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
