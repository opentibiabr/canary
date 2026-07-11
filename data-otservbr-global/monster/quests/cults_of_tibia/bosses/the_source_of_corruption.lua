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
	{ id = 9632, chance = 100000 }, -- Ancient Stone
	{ id = 3035, chance = 100000, maxCount = 49 }, -- Platinum Coin
	{ id = 22516, chance = 100000, maxCount = 3 }, -- Silver Token
	{ id = 22193, chance = 100000 }, -- Onyx Chip
	{ id = 5888, chance = 100000, maxCount = 9 }, -- Piece of Hell Steel
	{ id = 3031, chance = 100000, maxCount = 387 }, -- Gold Coin
	{ id = 5904, chance = 100000, maxCount = 5 }, -- Magic Sulphur
	{ id = 22721, chance = 100000, maxCount = 4 }, -- Gold Token
	{ id = 23517, chance = 66000, maxCount = 21 }, -- Solid Rage
	{ id = 7642, chance = 60000, maxCount = 14 }, -- Great Spirit Potion
	{ id = 238, chance = 59000, maxCount = 16 }, -- Great Mana Potion
	{ id = 23507, chance = 58000, maxCount = 19 }, -- Crystallized Anger
	{ id = 7643, chance = 52000, maxCount = 13 }, -- Ultimate Health Potion
	{ id = 3037, chance = 31000 }, -- Yellow Gem
	{ id = 3039, chance = 27000 }, -- Red Gem
	{ id = 9057, chance = 26000, maxCount = 37 }, -- Small Topaz
	{ id = 9058, chance = 25000 }, -- Gold Ingot
	{ id = 3030, chance = 20000, maxCount = 37 }, -- Small Ruby
	{ id = 22194, chance = 20000, maxCount = 3 }, -- Opal
	{ id = 3038, chance = 19000 }, -- Green Gem
	{ id = 3029, chance = 19000, maxCount = 35 }, -- Small Sapphire
	{ id = 3033, chance = 18100, maxCount = 39 }, -- Small Amethyst
	{ id = 3032, chance = 17100, maxCount = 37 }, -- Small Emerald
	{ id = 281, chance = 17100 }, -- Giant Shimmering Pearl
	{ id = 3041, chance = 16200 }, -- Blue Gem
	{ id = 5906, chance = 16200 }, -- Demon Dust
	{ id = 5909, chance = 16200, maxCount = 7 }, -- White Piece of Cloth
	{ id = 24392, chance = 14300, maxCount = 5 }, -- Gemmed Figurine
	{ id = 23533, chance = 12400 }, -- Ring of Red Plasma
	{ id = 3324, chance = 11400 }, -- Skull Staff
	{ id = 7437, chance = 11400 }, -- Sapphire Hammer
	{ id = 5891, chance = 11400 }, -- Enchanted Chicken Wing
	{ id = 3036, chance = 6700 }, -- Violet Gem
	{ id = 8029, chance = 3800 }, -- Silkweaver Bow
	{ id = 16120, chance = 2900, maxCount = 13 }, -- Violet Crystal Shard
	{ id = 3356, chance = 2900 }, -- Devil Helmet
	{ id = 20067, chance = 1900 }, -- Crude Umbral Slayer
	{ id = 20068, chance = 1900 }, -- Umbral Slayer
	{ id = 3366, chance = 950 }, -- Magic Plate Armor
	{ id = 8061, chance = 950 }, -- Skullcracker Armor
	{ id = 16115, chance = 950 }, -- Wand of Everblazing
	{ id = 3340, chance = 950 }, -- Heavy Mace
	{ id = 16160, chance = 950 }, -- Crystalline Sword
	{ id = 8098, chance = 950 }, -- Demonwing Axe
	{ id = 9068, chance = 950 }, -- Yalahari Figurine
	{ id = 7418, chance = 100000 }, -- Nightmare Blade
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
