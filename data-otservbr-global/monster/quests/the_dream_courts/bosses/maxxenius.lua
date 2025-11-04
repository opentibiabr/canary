local mType = Game.createMonsterType("Maxxenius")
local monster = {}

monster.description = "Maxxenius"
monster.experience = 55000
monster.outfit = {
	lookType = 1142,
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
monster.corpse = 30151
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
	bossRaceId = 1697,
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
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 3043, chance = 19047, maxCount = 3 }, -- Crystal Coin
	{ id = 9058, chance = 17460 }, -- Gold Ingot
	{ id = 7443, chance = 19047, maxCount = 10 }, -- Bullseye Potion
	{ id = 7440, chance = 18253, maxCount = 10 }, -- Mastermind Potion
	{ id = 25759, chance = 50793, maxCount = 100 }, -- Royal Star
	{ id = 23375, chance = 58730, maxCount = 20 }, -- Supreme Health Potion
	{ id = 23373, chance = 55555, maxCount = 14 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 53968, maxCount = 60 }, -- Ultimate Spirit Potion
	{ id = 30059, chance = 4285 }, -- Giant Ruby
	{ id = 30056, chance = 3968 }, -- Ornate Locket
	{ id = 22721, chance = 71428, maxCount = 2 }, -- Gold Token
	{ id = 22516, chance = 100000, maxCount = 3 }, -- Silver Token
	{ id = 281, chance = 15079 }, -- Giant Shimmering Pearl
	{ id = 30169, chance = 22222 }, -- Pomegranate
	{ id = 23535, chance = 100000 }, -- Energy Bar
	{ id = 7427, chance = 6349 }, -- Chaos Mace
	{ id = 23544, chance = 13492 }, -- Collar of Red Plasma
	{ id = 23543, chance = 12698 }, -- Collar of Green Plasma
	{ id = 281, chance = 15079 }, -- Giant Shimmering Pearl
	{ id = 3038, chance = 19047 }, -- Green Gem
	{ id = 3041, chance = 14285 }, -- Blue Gem
	{ id = 3037, chance = 42857 }, -- Yellow Gem
	{ id = 3036, chance = 7936 }, -- Violet Gem
	{ id = 5892, chance = 28571 }, -- Huge Chunk of Crude Iron
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 23529, chance = 4285 }, -- Ring of Blue Plasma
	{ id = 3324, chance = 11111 }, -- Skull Staff
	{ id = 29426, chance = 3968 }, -- Brain in a Jar
	{ id = 29425, chance = 5714 }, -- Energized Limb
	{ id = 29942, chance = 1785 }, -- Maxxenius Head
	{ id = 30171, chance = 1000 }, -- Purple Tendril Lantern
	{ id = 5904, chance = 14285 }, -- Magic Sulphur
	{ id = 5809, chance = 5555 }, -- Soul Stone
	{ id = 3006, chance = 7936 }, -- Ring of the Sky
	{ id = 23533, chance = 3174 }, -- Ring of Red Plasma
	{ id = 3039, chance = 35714 }, -- Red Gem
	{ id = 23526, chance = 16666 }, -- Collar of Blue Plasma
	{ id = 23531, chance = 8730 }, -- Ring of Green Plasma
	{ id = 7439, chance = 22222 }, -- Berserk Potion
	{ id = 7414, chance = 3174 }, -- Abyss Hammer
	{ id = 3341, chance = 1428 }, -- Arcane Staff
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -500, maxDamage = -1000 },
	{ name = "energy beam", interval = 2000, chance = 10, minDamage = -500, maxDamage = -1200, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "energy wave", interval = 2000, chance = 10, minDamage = -500, maxDamage = -1200, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 600 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.heals = {
	{ type = COMBAT_ENERGYDAMAGE, percent = 500 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
