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
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 3043, chance = 20689 }, -- Crystal Coin
	{ id = 23374, chance = 56321, maxCount = 6 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 54022, maxCount = 14 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 45977, maxCount = 6 }, -- Supreme Health Potion
	{ id = 281, chance = 8045 }, -- Giant Shimmering Pearl
	{ id = 3039, chance = 37931 }, -- Red Gem
	{ id = 3041, chance = 16091 }, -- Blue Gem
	{ id = 23529, chance = 11494 }, -- Ring of Blue Plasma
	{ id = 7443, chance = 20689, maxCount = 10 }, -- Bullseye Potion
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 23535, chance = 100000 }, -- Energy Bar
	{ id = 23543, chance = 14942 }, -- Collar of Green Plasma
	{ id = 3006, chance = 8045 }, -- Ring of the Sky
	{ id = 22516, chance = 100000, maxCount = 2 }, -- Silver Token
	{ id = 22721, chance = 78160, maxCount = 2 }, -- Gold Token
	{ id = 30055, chance = 4597 }, -- Crunor Idol
	{ id = 29419, chance = 3333 }, -- Resizer
	{ id = 29420, chance = 6896 }, -- Shoulder Plate
	{ id = 30088, chance = 5747 }, -- Malofur's Lunchbox
	{ id = 30169, chance = 22988 }, -- Pomegranate
	{ id = 7427, chance = 6896 }, -- Chaos Mace
	{ id = 7440, chance = 17241 }, -- Mastermind Potion
	{ id = 9058, chance = 14942 }, -- Gold Ingot
	{ id = 3037, chance = 37931 }, -- Yellow Gem
	{ id = 23544, chance = 6896 }, -- Collar of Red Plasma
	{ id = 25759, chance = 36781 }, -- Royal Star
	{ id = 5892, chance = 31034 }, -- Huge Chunk of Crude Iron
	{ id = 7439, chance = 20689 }, -- Berserk Potion
	{ id = 3324, chance = 21839 }, -- Skull Staff
	{ id = 7414, chance = 2298 }, -- Abyss Hammer
	{ id = 3038, chance = 13793 }, -- Green Gem
	{ id = 23526, chance = 8045 }, -- Collar of Blue Plasma
	{ id = 3341, chance = 3703 }, -- Arcane Staff
	{ id = 5904, chance = 9195 }, -- Magic Sulphur
	{ id = 5809, chance = 5747 }, -- Soul Stone
	{ id = 3036, chance = 12643 }, -- Violet Gem
	{ id = 23531, chance = 6896 }, -- Ring of Green Plasma
	{ id = 23533, chance = 9195 }, -- Ring of Red Plasma
	{ id = 30060, chance = 3448 }, -- Giant Emerald
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
