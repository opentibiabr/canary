local mType = Game.createMonsterType("The Source of Corruption")
local monster = {}

monster.description = "The Source Of Corruption"
monster.experience = 0
monster.outfit = {
	lookType = 979,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1500,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 500000
monster.maxHealth = 500000
monster.race = "undead"
monster.corpse = 23567
monster.speed = 60
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20,
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
	canPushCreatures = false,
	staticAttackChance = 95,
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
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 30 }, -- Platinum Coin
	{ id = 3030, chance = 22137, maxCount = 20 }, -- Small Ruby
	{ id = 3029, chance = 17647, maxCount = 20 }, -- Small Sapphire
	{ id = 3033, chance = 20000, maxCount = 33 }, -- Small Amethyst
	{ id = 9057, chance = 25190, maxCount = 20 }, -- Small Topaz
	{ id = 3032, chance = 16296, maxCount = 23 }, -- Small Emerald
	{ id = 16120, chance = 3703, maxCount = 7 }, -- Violet Crystal Shard
	{ id = 236, chance = 1000, maxCount = 2 }, -- Strong Health Potion
	{ id = 238, chance = 60000, maxCount = 5 }, -- Great Mana Potion
	{ id = 7643, chance = 54411, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 7642, chance = 55555, maxCount = 8 }, -- Great Spirit Potion
	{ id = 239, chance = 1000, maxCount = 3 }, -- Great Health Potion
	{ id = 5888, chance = 100000, maxCount = 5 }, -- Piece of Hell Steel
	{ id = 23507, chance = 56617, maxCount = 10 }, -- Crystallized Anger
	{ id = 5904, chance = 100000, maxCount = 4 }, -- Magic Sulphur
	{ id = 22721, chance = 100000, maxCount = 4 }, -- Gold Token
	{ id = 22516, chance = 100000, maxCount = 3 }, -- Silver Token
	{ id = 5909, chance = 15267, maxCount = 4 }, -- White Piece of Cloth
	{ id = 22194, chance = 19083, maxCount = 2 }, -- Opal
	{ id = 23517, chance = 66176, maxCount = 11 }, -- Solid Rage
	{ id = 22193, chance = 100000 }, -- Onyx Chip
	{ id = 5906, chance = 14503 }, -- Demon Dust
	{ id = 3039, chance = 25925 }, -- Red Gem
	{ id = 3038, chance = 17557 }, -- Green Gem
	{ id = 281, chance = 19852 }, -- Giant Shimmering Pearl
	{ id = 5891, chance = 11111 }, -- Enchanted Chicken Wing
	{ id = 9632, chance = 100000 }, -- Ancient Stone
	{ id = 9058, chance = 25954 }, -- Gold Ingot
	{ id = 23533, chance = 11851 }, -- Ring of Red Plasma
	{ id = 3324, chance = 11428 }, -- Skull Staff
	{ id = 3356, chance = 3053 }, -- Devil Helmet
	{ id = 7437, chance = 13740 }, -- Sapphire Hammer
	{ id = 3340, chance = 952 }, -- Heavy Mace
	{ id = 8098, chance = 952 }, -- Demonwing Axe
	{ id = 9068, chance = 1526 }, -- Yalahari Figurine
	{ id = 7418, chance = 100000 }, -- Nightmare Blade
	{ id = 3037, chance = 31818 }, -- Yellow Gem
	{ id = 3041, chance = 18518 }, -- Blue Gem
	{ id = 8029, chance = 5343 }, -- Silkweaver Bow
	{ id = 20067, chance = 2290 }, -- Crude Umbral Slayer
	{ id = 20068, chance = 1904 }, -- Umbral Slayer
	{ id = 3036, chance = 8396 }, -- Violet Gem
	{ id = 24392, chance = 14503 }, -- Gemmed Figurine
	{ id = 22866, chance = 1000 }, -- Rift Bow
	{ id = 25360, chance = 1000 }, -- Heart of the Mountain (Item)
	{ id = 25361, chance = 1000 }, -- Blood of the Mountain (Item)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1500 },
	{ name = "source of corruption wave", interval = 2000, chance = 15, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
}

monster.reflects = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 15 },
	{ type = COMBAT_MANADRAIN, percent = 15 },
	{ type = COMBAT_DROWNDAMAGE, percent = 15 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
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
