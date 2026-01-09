local mType = Game.createMonsterType("Gaffir")
local monster = {}

monster.description = "Gaffir"
monster.experience = 25000
monster.outfit = {
	lookType = 1217,
	lookHead = 16,
	lookBody = 74,
	lookLegs = 94,
	lookFeet = 50,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1778,
	bossRace = RARITY_BANE,
}

monster.health = 48500
monster.maxHealth = 48500
monster.race = "blood"
monster.corpse = 31307
monster.speed = 95
monster.manaCost = 0

monster.events = {
	"UglyMonsterSpawn",
	"UglyMonsterCleanup",
	"grave_danger_death",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "Black Cobra", chance = 10, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3065, chance = 1000 }, -- Terra Rod
	{ id = 8084, chance = 1000 }, -- Springsprout Rod
	{ id = 3035, chance = 1000, maxCount = 17 }, -- Platinum Coin
	{ id = 7642, chance = 1000 }, -- Great Spirit Potion
	{ id = 8073, chance = 1000 }, -- Spellbook of Warding
	{ id = 3098, chance = 1000 }, -- Ring of Healing
	{ id = 3057, chance = 1000 }, -- Amulet of Loss
	{ id = 31678, chance = 1000 }, -- Cobra Crest
	{ id = 3030, chance = 13888 }, -- Small Ruby
	{ id = 3029, chance = 18376 }, -- Small Sapphire
	{ id = 3028, chance = 19444 }, -- Small Diamond
	{ id = 9057, chance = 18803 }, -- Small Topaz
	{ id = 30399, chance = 1000 }, -- Cobra Wand
	{ id = 30400, chance = 1000 }, -- Cobra Rod
	{ id = 3033, chance = 16239 }, -- Small Amethyst
	{ id = 3032, chance = 13247 }, -- Small Emerald
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -450, maxDamage = -650, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -580, length = 5, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 3000, chance = 14, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -750, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -620, radius = 4, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 3000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -320, maxDamage = -500, radius = 2, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 83,
	armor = 83,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
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
