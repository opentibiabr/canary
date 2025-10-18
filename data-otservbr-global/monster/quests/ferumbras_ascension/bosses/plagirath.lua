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
	{ id = 22516, chance = 100000 }, -- Silver Token
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 6499, chance = 73529 }, -- Demonic Essence
	{ id = 3033, chance = 22727, maxCount = 5 }, -- Small Amethyst
	{ id = 7642, chance = 54411, maxCount = 5 }, -- Great Spirit Potion
	{ id = 3038, chance = 27941 }, -- Green Gem
	{ id = 3039, chance = 21212 }, -- Red Gem
	{ id = 3035, chance = 100000, maxCount = 25 }, -- Platinum Coin
	{ id = 3028, chance = 22058 }, -- Small Diamond
	{ id = 811, chance = 12698 }, -- Terra Mantle
	{ id = 812, chance = 16666 }, -- Terra Legs
	{ id = 16125, chance = 80882, maxCount = 6 }, -- Cyan Crystal Fragment
	{ id = 16127, chance = 74242, maxCount = 6 }, -- Green Crystal Fragment
	{ id = 16126, chance = 77941, maxCount = 6 }, -- Red Crystal Fragment
	{ id = 238, chance = 57142, maxCount = 5 }, -- Great Mana Potion
	{ id = 7643, chance = 58823, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 22759, chance = 1000 }, -- Plague Bite
	{ id = 22762, chance = 1000 }, -- Maimer
	{ id = 22726, chance = 10526 }, -- Rift Shield
	{ id = 3098, chance = 36363 }, -- Ring of Healing
	{ id = 3032, chance = 16666 }, -- Small Emerald
	{ id = 16117, chance = 6976 }, -- Muck Rod
	{ id = 281, chance = 9090 }, -- Giant Shimmering Pearl
	{ id = 6558, chance = 46969 }, -- Flask of Demonic Blood
	{ id = 3030, chance = 10606 }, -- Small Ruby
	{ id = 10389, chance = 7894 }, -- Traditional Sai
	{ id = 8073, chance = 6557 }, -- Spellbook of Warding
	{ id = 22727, chance = 6557 }, -- Rift Lance
	{ id = 9057, chance = 29508 }, -- Small Topaz
	{ id = 3037, chance = 27868 }, -- Yellow Gem
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
