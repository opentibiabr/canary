local mType = Game.createMonsterType("The Diamond Blossom")
local monster = {}

monster.description = "The Diamond Blossom"
monster.experience = 10000
monster.outfit = {
	lookType = 1068,
	lookHead = 9,
	lookBody = 0,
	lookLegs = 86,
	lookFeet = 79,
	lookAddons = 3,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1598,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 20000
monster.maxHealth = 20000
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
	{ id = 3031, chance = 100000, maxCount = 370 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 10 }, -- Platinum Coin
	{ id = 21975, chance = 100000 }, -- Peacock Feather Fan
	{ id = 21974, chance = 100000 }, -- Golden Lotus Brooch
	{ id = 7368, chance = 50000, maxCount = 15 }, -- Assassin Star
	{ id = 6499, chance = 35000 }, -- Demonic Essence
	{ id = 6558, chance = 30000 }, -- Flask of Demonic Blood
	{ id = 3033, chance = 27000, maxCount = 3 }, -- Small Amethyst
	{ id = 5944, chance = 19200 }, -- Soul Orb
	{ id = 7642, chance = 17500, maxCount = 4 }, -- Great Spirit Potion
	{ id = 238, chance = 16700, maxCount = 5 }, -- Great Mana Potion
	{ id = 3070, chance = 16700 }, -- Moonlight Rod
	{ id = 7643, chance = 12500, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 3007, chance = 12500 }, -- Crystal Ring
	{ id = 3069, chance = 10000 }, -- Necrotic Rod
	{ id = 3039, chance = 9200 }, -- Red Gem
	{ id = 25759, chance = 7500, maxCount = 5 }, -- Royal Star
	{ id = 8082, chance = 6700 }, -- Underworld Rod
	{ id = 9058, chance = 4200, maxCount = 2 }, -- Gold Ingot
	{ id = 3038, chance = 4200 }, -- Green Gem
	{ id = 7404, chance = 2500 }, -- Assassin Dagger
	{ id = 21981, chance = 2500 }, -- Oriental Shoes
	{ id = 3036, chance = 1700 }, -- Violet Gem
	{ id = 6299, chance = 1700 }, -- Death Ring
	{ id = 22516, chance = 830 }, -- Silver Token
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
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
