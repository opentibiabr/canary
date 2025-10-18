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
	{ id = 3033, chance = 26230 }, -- Small Amethyst
	{ id = 3035, chance = 100000 }, -- Platinum Coin
	{ id = 3039, chance = 9840 }, -- Red Gem
	{ id = 3070, chance = 18030 }, -- Moonlight Rod
	{ id = 3031, chance = 100000 }, -- Gold Coin
	{ id = 21975, chance = 100000 }, -- Peacock Feather Fan
	{ id = 6558, chance = 37700 }, -- Flask of Demonic Blood
	{ id = 7368, chance = 42620 }, -- Assassin Star
	{ id = 6499, chance = 22950 }, -- Demonic Essence
	{ id = 7642, chance = 13110 }, -- Great Spirit Potion
	{ id = 21974, chance = 100000 }, -- Golden Lotus Brooch
	{ id = 3069, chance = 11480 }, -- Necrotic Rod
	{ id = 5944, chance = 18030 }, -- Soul Orb
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
