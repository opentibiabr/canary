local mType = Game.createMonsterType("Malofur Mangrinder")
local monster = {}

monster.description = "Malofur Mangrinder"
monster.experience = 55000
monster.outfit = {
	lookType = 1120,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "blood"
monster.corpse = 30017
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1696,
	bossRace = RARITY_NEMESIS,
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
	{ text = "RAAAARGH! I'M MASHING YE TO DUST BOOM!", yell = true },
	{ text = "BOOOM!", yell = true },
	{ text = "BOOOOM!!!", yell = true },
	{ text = "BOOOOOM!!!", yell = true },
}

monster.loot = {
	{ id = 23535, chance = 100000 }, -- Energy Bar
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 22516, chance = 100000, maxCount = 4 }, -- Silver Token
	{ id = 22721, chance = 75000, maxCount = 3 }, -- Gold Token
	{ id = 23374, chance = 58000, maxCount = 36 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 54000, maxCount = 31 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 43000, maxCount = 26 }, -- Supreme Health Potion
	{ id = 3039, chance = 41000, maxCount = 2 }, -- Red Gem
	{ id = 25759, chance = 36000, maxCount = 188 }, -- Royal Star
	{ id = 5892, chance = 36000 }, -- Huge Chunk of Crude Iron
	{ id = 3037, chance = 35000, maxCount = 2 }, -- Yellow Gem
	{ id = 30169, chance = 22000 }, -- Pomegranate
	{ id = 3043, chance = 22000, maxCount = 3 }, -- Crystal Coin
	{ id = 3324, chance = 22000 }, -- Skull Staff
	{ id = 7439, chance = 22000, maxCount = 19 }, -- Berserk Potion
	{ id = 3041, chance = 17400 }, -- Blue Gem
	{ id = 7443, chance = 17400, maxCount = 19 }, -- Bullseye Potion
	{ id = 7440, chance = 15900, maxCount = 19 }, -- Mastermind Potion
	{ id = 3036, chance = 14500 }, -- Violet Gem
	{ id = 3038, chance = 14500, maxCount = 2 }, -- Green Gem
	{ id = 9058, chance = 11600 }, -- Gold Ingot
	{ id = 23533, chance = 10100 }, -- Ring of Red Plasma
	{ id = 23543, chance = 10100 }, -- Collar of Green Plasma
	{ id = 23526, chance = 10100 }, -- Collar of Blue Plasma
	{ id = 23531, chance = 8700 }, -- Ring of Green Plasma
	{ id = 23529, chance = 8700 }, -- Ring of Blue Plasma
	{ id = 5904, chance = 7200 }, -- Magic Sulphur
	{ id = 5809, chance = 5800 }, -- Soul Stone
	{ id = 3006, chance = 5800 }, -- Ring of the Sky
	{ id = 281, chance = 5800 }, -- Giant Shimmering Pearl
	{ id = 23544, chance = 5800 }, -- Collar of Red Plasma
	{ id = 7427, chance = 5800 }, -- Chaos Mace
	{ id = 29420, chance = 4300 }, -- Shoulder Plate
	{ id = 30088, chance = 4300 }, -- Malofur's Lunchbox
	{ id = 29419, chance = 2900 }, -- Resizer
	{ id = 30055, chance = 2900 }, -- Crunor Idol
	{ id = 7414, chance = 1400 }, -- Abyss Hammer
	{ id = 30060, chance = 1400 }, -- Giant Emerald
	{ id = 3341, chance = 1400 }, -- Arcane Staff
	{ id = 49271, chance = 1400 }, -- Transcendence Potion
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -2500, target = true }, -- basic attack
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -5500, effect = CONST_ME_GROUNDSHAKER, radius = 4, target = false }, -- groundshaker
}

monster.defenses = {
	defense = 60,
	armor = 60,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
