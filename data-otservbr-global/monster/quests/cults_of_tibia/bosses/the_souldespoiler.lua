local mType = Game.createMonsterType("The Souldespoiler")
local monster = {}

monster.description = "The Souldespoiler"
monster.experience = 50000
monster.outfit = {
	lookType = 875,
	lookHead = 0,
	lookBody = 3,
	lookLegs = 77,
	lookFeet = 81,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1422,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "blood"
monster.corpse = 23564
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 6000,
	chance = 30,
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

monster.summon = {
	maxSummons = 5,
	summons = {
		{ name = "Freed Soul", chance = 5, interval = 5000, count = 5 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Stop freeing the souls! They are mine alone!", yell = false },
	{ text = "The souls shall not escape me! ", yell = false },
	{ text = " You will be mine!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 23535, chance = 80000, maxCount = 5 }, -- energy bar
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 10 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 10 }, -- small emerald
	{ id = 9057, chance = 80000, maxCount = 10 }, -- small topaz
	{ id = 23510, chance = 80000 }, -- odd organ
	{ id = 23506, chance = 80000 }, -- plasma pearls
	{ id = 24962, chance = 80000, maxCount = 10 }, -- prismatic quartz
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 23511, chance = 80000, maxCount = 10 }, -- curious matter
	{ id = 23518, chance = 80000, maxCount = 10 }, -- spark sphere
	{ id = 7643, chance = 80000, maxCount = 5 }, -- ultimate health potion
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 238, chance = 80000, maxCount = 5 }, -- great mana potion
	{ id = 7437, chance = 80000 }, -- sapphire hammer
	{ id = 7407, chance = 80000 }, -- haunted blade
	{ id = 7452, chance = 80000, maxCount = 2 }, -- spiked squelcher
	{ id = 16096, chance = 80000 }, -- wand of defiance
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 7435, chance = 80000 }, -- impaler
	{ id = 11688, chance = 80000 }, -- shield of corruption
	{ id = 3029, chance = 80000 }, -- small sapphire
	{ id = 8072, chance = 80000 }, -- spellbook of enlightenment
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3436, chance = 80000 }, -- medusa shield
	{ id = 818, chance = 80000 }, -- magma boots
	{ id = 8082, chance = 80000 }, -- underworld rod
	{ id = 7419, chance = 80000 }, -- dreaded cleaver
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 22727, chance = 80000 }, -- rift lance
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -783 },
	{ name = "combat", interval = 2000, chance = 60, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -181, range = 7, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_ENERGYDAMAGE, minDamage = -210, maxDamage = -538, length = 7, spread = 2, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_DROWNDAMAGE, minDamage = -125, maxDamage = -640, length = 9, spread = 0, effect = CONST_ME_LOSEENERGY, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 7000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
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
