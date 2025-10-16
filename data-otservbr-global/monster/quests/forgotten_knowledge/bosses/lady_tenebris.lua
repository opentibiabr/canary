local mType = Game.createMonsterType("Lady Tenebris")
local monster = {}

monster.description = "Lady Tenebris"
monster.experience = 50000
monster.outfit = {
	lookType = 433,
	lookHead = 76,
	lookBody = 95,
	lookLegs = 38,
	lookFeet = 94,
	lookAddons = 2,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
	"HealthForgotten",
}

monster.bosstiary = {
	bossRaceId = 1315,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "blood"
monster.corpse = 6560
monster.speed = 185
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	canPushCreatures = true,
	staticAttackChance = 98,
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
	{ text = "May the embrace of darkness kill you!", yell = false },
	{ text = "I'm the one and only mistress of shadows!", yell = false },
	{ text = "Blackout!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 369 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 47 }, -- platinum coin
	{ id = 3032, chance = 80000, maxCount = 19 }, -- small emerald
	{ id = 3033, chance = 80000, maxCount = 18 }, -- small amethyst
	{ id = 9057, chance = 80000, maxCount = 18 }, -- small topaz
	{ id = 3028, chance = 80000, maxCount = 16 }, -- small diamond
	{ id = 3030, chance = 80000, maxCount = 19 }, -- small ruby
	{ id = 238, chance = 80000, maxCount = 15 }, -- great mana potion
	{ id = 7642, chance = 80000, maxCount = 12 }, -- great spirit potion
	{ id = 7643, chance = 80000, maxCount = 18 }, -- ultimate health potion
	{ id = 16119, chance = 80000, maxCount = 5 }, -- blue crystal shard
	{ id = 16121, chance = 80000, maxCount = 5 }, -- green crystal shard
	{ id = 16120, chance = 80000, maxCount = 5 }, -- violet crystal shard
	{ id = 20062, chance = 80000, maxCount = 3 }, -- cluster of solace
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 22195, chance = 80000 }, -- onyx pendant
	{ id = 16096, chance = 80000 }, -- wand of defiance
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 3021, chance = 80000 }, -- sapphire amulet
	{ id = 8073, chance = 80000 }, -- spellbook of warding
	{ id = 7414, chance = 80000 }, -- abyss hammer
	{ id = 10438, chance = 80000 }, -- spellweavers robe
	{ id = 19400, chance = 80000 }, -- arcane staff
	{ id = 8075, chance = 80000 }, -- spellbook of lost souls
	{ id = 7451, chance = 80000 }, -- shadow sceptre
	{ id = 24973, chance = 80000 }, -- shadow mask
	{ id = 24974, chance = 80000 }, -- shadow paint
	{ id = 20088, chance = 80000 }, -- crude umbral spellbook
	{ id = 20089, chance = 80000 }, -- umbral spellbook
	{ id = 22755, chance = 260 }, -- book of lies
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -800, maxDamage = -1800 },
	{ name = "combat", interval = 6000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -1200, maxDamage = -1500, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -600, radius = 4, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "tenebris summon", interval = 2000, chance = 14, target = false },
	{ name = "tenebris ultimate", interval = 15000, chance = 30, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 25, type = COMBAT_HEALING, minDamage = 600, maxDamage = 2700, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 60 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
