local mType = Game.createMonsterType("The Unarmored Voidborn")
local monster = {}

monster.description = "The Unarmored Voidborn"
monster.experience = 15000
monster.outfit = {
	lookType = 987,
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
	bossRaceId = 1406,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 250000
monster.maxHealth = 250000
monster.race = "undead"
monster.corpse = 26133
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 50,
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
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 23535, chance = 80000, maxCount = 5 }, -- energy bar
	{ id = 238, chance = 80000, maxCount = 5 }, -- great mana potion
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 7643, chance = 80000, maxCount = 5 }, -- ultimate health potion
	{ id = 3029, chance = 80000, maxCount = 10 }, -- small sapphire
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 22191, chance = 80000 }, -- skull fetish
	{ id = 7786, chance = 80000 }, -- orc tusk
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 830, chance = 80000 }, -- terra hood
	{ id = 5887, chance = 80000 }, -- piece of royal steel
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 812, chance = 80000 }, -- terra legs
	{ id = 21171, chance = 80000 }, -- metal bat
	{ id = 7428, chance = 80000 }, -- bonebreaker
	{ id = 7388, chance = 80000 }, -- vile axe
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 23531, chance = 80000 }, -- ring of green plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -400, length = 7, spread = 5, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -440, radius = 5, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 50,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -300 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -255 },
	{ type = COMBAT_EARTHDAMAGE, percent = -255 },
	{ type = COMBAT_FIREDAMAGE, percent = -255 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -300 },
	{ type = COMBAT_HOLYDAMAGE, percent = -300 },
	{ type = COMBAT_DEATHDAMAGE, percent = -300 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
