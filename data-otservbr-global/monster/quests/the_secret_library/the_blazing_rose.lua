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
	{ id = 28495, chance = 100000 }, -- Perfume Flacon
	{ id = 3033, chance = 28570 }, -- Small Amethyst
	{ id = 3035, chance = 100000 }, -- Platinum Coin
	{ id = 3039, chance = 12860 }, -- Red Gem
	{ id = 5944, chance = 31430 }, -- Soul Orb
	{ id = 3031, chance = 100000 }, -- Gold Coin
	{ id = 21975, chance = 100000 }, -- Peacock Feather Fan
	{ id = 6558, chance = 48570 }, -- Flask of Demonic Blood
	{ id = 7368, chance = 58569 }, -- Assassin Star
	{ id = 21981, chance = 2860 }, -- Oriental Shoes
	{ id = 7642, chance = 14290 }, -- Great Spirit Potion
	{ id = 6499, chance = 20000 }, -- Demonic Essence
	{ id = 3007, chance = 7140 }, -- Crystal Ring
	{ id = 21974, chance = 100000 }, -- Golden Lotus Brooch
	{ id = 3070, chance = 11430 }, -- Moonlight Rod
	{ id = 7643, chance = 11430 }, -- Ultimate Health Potion
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
