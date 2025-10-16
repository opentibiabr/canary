local mType = Game.createMonsterType("Ancient Spawn of Morgathla")
local monster = {}

monster.description = "Ancient Spawn Of Morgathla"
monster.experience = 70000
monster.outfit = {
	lookType = 1055,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1551,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 900000
monster.maxHealth = 900000
monster.race = "blood"
monster.corpse = 21004
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 7440, chance = 80000, maxCount = 4 }, -- mastermind potion
	{ id = 3035, chance = 80000, maxCount = 350 }, -- platinum coin
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 16119, chance = 80000, maxCount = 6 }, -- blue crystal shard
	{ id = 3328, chance = 80000 }, -- daramian waraxe
	{ id = 16120, chance = 80000, maxCount = 6 }, -- violet crystal shard
	{ id = 9632, chance = 80000, maxCount = 3 }, -- ancient stone
	{ id = 7642, chance = 80000, maxCount = 24 }, -- great spirit potion
	{ id = 16121, chance = 80000, maxCount = 6 }, -- green crystal shard
	{ id = 22193, chance = 80000, maxCount = 3 }, -- onyx chip
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 8084, chance = 80000 }, -- springsprout rod
	{ id = 238, chance = 80000, maxCount = 24 }, -- great mana potion
	{ id = 5892, chance = 80000, maxCount = 6 }, -- huge chunk of crude iron
	{ id = 11454, chance = 80000 }, -- luminous orb
	{ id = 3018, chance = 80000 }, -- scarab amulet
	{ id = 830, chance = 80000 }, -- terra hood
	{ id = 7643, chance = 80000, maxCount = 24 }, -- ultimate health potion
	{ id = 3037, chance = 80000, maxCount = 2 }, -- yellow gem
	{ id = 3041, chance = 80000, maxCount = 2 }, -- blue gem
	{ id = 7428, chance = 80000 }, -- bonebreaker
	{ id = 3339, chance = 80000 }, -- djinn blade
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 36706, chance = 80000, maxCount = 2 }, -- red gem
	{ id = 3042, chance = 80000, maxCount = 50 }, -- scarab coin
	{ id = 3440, chance = 80000 }, -- scarab shield
	{ id = 3033, chance = 80000, maxCount = 20 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 20 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 20 }, -- small emerald
	{ id = 3030, chance = 80000, maxCount = 20 }, -- small ruby
	{ id = 9057, chance = 80000, maxCount = 20 }, -- small topaz
	{ id = 8082, chance = 80000 }, -- underworld rod
	{ id = 27655, chance = 80000 }, -- plan for a makeshift armour
	{ id = 27657, chance = 80000 }, -- crude wood planks
	{ id = 27656, chance = 80000 }, -- tinged pot
	{ id = 8054, chance = 80000 }, -- earthborn titan armor
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 812, chance = 80000 }, -- terra legs
	{ id = 9631, chance = 80000 }, -- scarab pincers
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 5891, chance = 80000 }, -- enchanted chicken wing
	{ id = 811, chance = 80000 }, -- terra mantle
	{ id = 3047, chance = 80000 }, -- magic light wand
	{ id = 12304, chance = 80000 }, -- maxilla maximus
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 13998, chance = 80000 }, -- depth scutum
	{ id = 22746, chance = 80000 }, -- ancient amulet
	{ id = 14042, chance = 80000 }, -- warriors shield
	{ id = 21981, chance = 80000 }, -- oriental shoes
	{ id = 27605, chance = 80000 }, -- candle stump
	{ id = 7382, chance = 80000 }, -- demonrage sword
	{ id = 3331, chance = 80000 }, -- ravagers axe
	{ id = 12509, chance = 80000 }, -- scorpion sceptre
	{ id = 8053, chance = 80000 }, -- fireborn giant armor
	{ id = 8062, chance = 80000 }, -- robe of the underworld
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 80 },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_LIFEDRAIN, minDamage = -135, maxDamage = -280, range = 7, radius = 5, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_HITAREA, target = true },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -90, maxDamage = -200, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONAREA, target = true },
}

monster.defenses = {
	defense = 190,
	armor = 190,
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
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
