local mType = Game.createMonsterType("Feroxa")
local monster = {}

monster.description = "Feroxa"
monster.experience = 0
monster.outfit = {
	lookType = 158,
	lookHead = 57,
	lookBody = 76,
	lookLegs = 77,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 100000
monster.maxHealth = 100000
monster.race = "blood"
monster.corpse = 0
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 2,
}

monster.bosstiary = {
	bossRaceId = 1149,
	bossRace = RARITY_NEMESIS,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.events = {
	"FeroxaTransform",
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
	{ id = 3035, chance = 80000, maxCount = 20 }, -- platinum coin
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 7643, chance = 80000, maxCount = 5 }, -- ultimate health potion
	{ id = 238, chance = 80000, maxCount = 2 }, -- great mana potion
	{ id = 16126, chance = 80000 }, -- red crystal fragment
	{ id = 16124, chance = 80000 }, -- blue crystal splinter
	{ id = 3028, chance = 80000, maxCount = 5 }, -- small diamond
	{ id = 16120, chance = 80000 }, -- violet crystal shard
	{ id = 16119, chance = 80000, maxCount = 5 }, -- blue crystal shard
	{ id = 7419, chance = 80000 }, -- dreaded cleaver
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 22083, chance = 80000, maxCount = 6 }, -- moonlight crystals
	{ id = 22060, chance = 80000 }, -- werewolf amulet
	{ id = 22104, chance = 80000 }, -- trophy of feroxa
	{ id = 22084, chance = 80000 }, -- wolf backpack
	{ id = 22062, chance = 80000 }, -- werewolf helmet
	{ id = 22086, chance = 80000 }, -- badger boots
	{ id = 22085, chance = 80000 }, -- fur armor
	{ id = 7436, chance = 80000 }, -- angelic axe
	{ id = 8061, chance = 80000 }, -- skullcracker armor
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 3079, chance = 80000 }, -- boots of haste
	{ id = 16123, chance = 80000 }, -- brown crystal splinter
	{ id = 16121, chance = 80000 }, -- green crystal shard
	{ id = 3070, chance = 80000 }, -- moonlight rod
	{ id = 22087, chance = 80000 }, -- wereboar loincloth
	{ id = 8082, chance = 80000 }, -- underworld rod
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 3029, chance = 80000 }, -- small sapphire
	{ id = 3326, chance = 80000 }, -- epee
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 16122, chance = 80000 }, -- green crystal splinter
	{ id = 3033, chance = 80000 }, -- small amethyst
	{ id = 8094, chance = 80000 }, -- wand of voodoo
	{ id = 7428, chance = 80000 }, -- bonebreaker
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 7454, chance = 80000 }, -- glorious axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1400, maxDamage = -1800 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1250, radius = 6, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -700, maxDamage = -1250, radius = 5, effect = CONST_ME_ICETORNADO, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -700, maxDamage = -1250, range = 6, shootEffect = CONST_ANI_ARROW, effect = CONST_ME_EXPLOSIONAREA, target = true },
}

monster.defenses = {
	defense = 55,
	armor = 50,
	{ name = "speed", interval = 2000, chance = 12, speedChange = 1250, effect = CONST_ME_THUNDER, target = false, duration = 10000 },
	{ name = "feroxa summon", interval = 2000, chance = 20, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
