local mType = Game.createMonsterType("The Lily of Night")
local monster = {}

monster.description = "The Lily of Night"
monster.experience = 10000
monster.outfit = {
	lookType = 1068,
	lookHead = 0,
	lookBody = 57,
	lookLegs = 90,
	lookFeet = 79,
	lookAddons = 2,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1602,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 19000
monster.maxHealth = 19000
monster.race = "undead"
monster.corpse = 28802
monster.speed = 175
monster.manaCost = 0

monster.events = {
	"AsurasMechanic",
}

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.strategiesTarget = {
	nearest = 100,
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
	{ id = 3031, chance = 100000, maxCount = 382 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 10 }, -- Platinum Coin
	{ id = 21975, chance = 100000 }, -- Peacock Feather Fan
	{ id = 21974, chance = 100000 }, -- Golden Lotus Brooch
	{ id = 7368, chance = 39000, maxCount = 15 }, -- Assassin Star
	{ id = 6558, chance = 36000 }, -- Flask of Demonic Blood
	{ id = 3033, chance = 29000, maxCount = 3 }, -- Small Amethyst
	{ id = 6499, chance = 29000 }, -- Demonic Essence
	{ id = 5944, chance = 23000 }, -- Soul Orb
	{ id = 238, chance = 22000, maxCount = 5 }, -- Great Mana Potion
	{ id = 3070, chance = 18800 }, -- Moonlight Rod
	{ id = 7642, chance = 15200, maxCount = 5 }, -- Great Spirit Potion
	{ id = 7643, chance = 13400, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 3039, chance = 9800 }, -- Red Gem
	{ id = 3007, chance = 8900 }, -- Crystal Ring
	{ id = 3069, chance = 8000 }, -- Necrotic Rod
	{ id = 9058, chance = 7100, maxCount = 3 }, -- Gold Ingot
	{ id = 8082, chance = 4500 }, -- Underworld Rod
	{ id = 3036, chance = 4500 }, -- Violet Gem
	{ id = 7404, chance = 3600 }, -- Assassin Dagger
	{ id = 3038, chance = 2700 }, -- Green Gem
	{ id = 21981, chance = 2700 }, -- Oriental Shoes
	{ id = 25759, chance = 2700, maxCount = 4 }, -- Royal Star
	{ id = 6299, chance = 1800 }, -- Death Ring
	{ id = 826, chance = 1800 }, -- Magma Coat
	{ id = 821, chance = 890 }, -- Magma Legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -180, range = 7, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -175, length = 3, spread = 0, effect = CONST_ME_POFF, target = false },
}

monster.defenses = {
	defense = 33,
	armor = 28,
	--	mitigation = ???,
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
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
