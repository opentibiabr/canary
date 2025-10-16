local mType = Game.createMonsterType("Terofar")
local monster = {}

monster.description = "Terofar"
monster.experience = 24000
monster.outfit = {
	lookType = 12,
	lookHead = 19,
	lookBody = 0,
	lookLegs = 77,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 40000
monster.maxHealth = 40000
monster.race = "blood"
monster.corpse = 6068
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25,
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
	{ text = "Terofar cast a greater death curse on you!", yell = false },
	{ text = "IT TOOK AN ARMY OF YOUR KIND TO DEFEAT THE WARDEN. NOW YOU ARE ALONE!", yell = true },
	{ text = "THE WARDS ARE FAILING! MY ESCAPE IS ONLY A MATTER OF TIME!!", yell = true },
	{ text = "FEELS GOOD TO BE BACK IN ACTION!", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 58 }, -- platinum coin
	{ id = 3033, chance = 80000, maxCount = 9 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 4 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 25 }, -- small emerald
	{ id = 3030, chance = 80000, maxCount = 20 }, -- small ruby
	{ id = 3029, chance = 80000, maxCount = 17 }, -- small sapphire
	{ id = 9057, chance = 80000, maxCount = 12 }, -- small topaz
	{ id = 16119, chance = 80000, maxCount = 8 }, -- blue crystal shard
	{ id = 16120, chance = 80000, maxCount = 7 }, -- violet crystal shard
	{ id = 16121, chance = 80000, maxCount = 6 }, -- green crystal shard
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 20062, chance = 80000 }, -- cluster of solace
	{ id = 5954, chance = 80000 }, -- demon horn
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 238, chance = 80000, maxCount = 4 }, -- great mana potion
	{ id = 7643, chance = 80000, maxCount = 4 }, -- ultimate health potion
	{ id = 20276, chance = 80000 }, -- dream warden mask
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 3415, chance = 80000 }, -- guardian shield
	{ id = 3419, chance = 80000 }, -- crown shield
	{ id = 3420, chance = 80000 }, -- demon shield
	{ id = 5741, chance = 80000 }, -- skull helmet
	{ id = 3392, chance = 80000 }, -- royal helmet
	{ id = 8063, chance = 80000 }, -- paladin armor
	{ id = 813, chance = 80000 }, -- terra boots
	{ id = 3554, chance = 80000 }, -- steel boots
	{ id = 3079, chance = 80000 }, -- boots of haste
	{ id = 8051, chance = 80000 }, -- voltage armor
	{ id = 8054, chance = 80000 }, -- earthborn titan armor
	{ id = 8049, chance = 80000 }, -- lavos armor
	{ id = 20264, chance = 80000 }, -- unrealized dream
	{ id = 20063, chance = 80000 }, -- dream matter
	{ id = 3366, chance = 80000 }, -- magic plate armor
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 3414, chance = 80000 }, -- mastermind shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 180, attack = 100 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1500, length = 8, spread = 0, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -750, range = 7, radius = 1, shootEffect = CONST_ANI_WHIRLWINDAXE, target = true },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 300, maxDamage = 500, radius = 8, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 18, speedChange = 784, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
