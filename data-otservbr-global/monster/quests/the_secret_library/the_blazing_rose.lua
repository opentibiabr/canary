local mType = Game.createMonsterType("The Blazing Rose")
local monster = {}

monster.description = "The Blazing Rose"
monster.experience = 10000
monster.outfit = {
	lookType = 1068,
	lookHead = 114,
	lookBody = 113,
	lookLegs = 76,
	lookFeet = 79,
	lookAddons = 3,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1600,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "undead"
monster.corpse = 28794
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
	{ id = 3031, chance = 100000, maxCount = 378 }, -- Gold Coin
	{ id = 28495, chance = 100000 }, -- Perfume Flacon
	{ id = 3035, chance = 100000, maxCount = 10 }, -- Platinum Coin
	{ id = 21975, chance = 100000 }, -- Peacock Feather Fan
	{ id = 21974, chance = 100000 }, -- Golden Lotus Brooch
	{ id = 7368, chance = 54000, maxCount = 15 }, -- Assassin Star
	{ id = 6558, chance = 40000 }, -- Flask of Demonic Blood
	{ id = 6499, chance = 31000 }, -- Demonic Essence
	{ id = 3033, chance = 26000, maxCount = 3 }, -- Small Amethyst
	{ id = 5944, chance = 24000 }, -- Soul Orb
	{ id = 238, chance = 16100, maxCount = 5 }, -- Great Mana Potion
	{ id = 7642, chance = 14500, maxCount = 5 }, -- Great Spirit Potion
	{ id = 3039, chance = 14500 }, -- Red Gem
	{ id = 7643, chance = 11300, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 3070, chance = 11300 }, -- Moonlight Rod
	{ id = 3007, chance = 8100 }, -- Crystal Ring
	{ id = 9058, chance = 6500, maxCount = 3 }, -- Gold Ingot
	{ id = 8082, chance = 5600 }, -- Underworld Rod
	{ id = 3069, chance = 4800 }, -- Necrotic Rod
	{ id = 25759, chance = 4000, maxCount = 4 }, -- Royal Star
	{ id = 6299, chance = 3200 }, -- Death Ring
	{ id = 22516, chance = 2400 }, -- Silver Token
	{ id = 21981, chance = 2400 }, -- Oriental Shoes
	{ id = 3038, chance = 2400 }, -- Green Gem
	{ id = 826, chance = 1600 }, -- Magma Coat
	{ id = 3036, chance = 1600 }, -- Violet Gem
	{ id = 821, chance = 1600 }, -- Magma Legs
	{ id = 7404, chance = 810 }, -- Assassin Dagger
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
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
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
