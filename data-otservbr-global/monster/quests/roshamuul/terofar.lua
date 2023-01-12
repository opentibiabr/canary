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
	lookMount = 0
}

monster.health = 40000
monster.maxHealth = 40000
monster.race = "blood"
monster.corpse = 6068
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "IT TOOK AN ARMY OF YOUR KIND TO DEFEAT THE WARDEN. NOW YOU ARE ALONE!", yell = true},
	{text = "FEELS GOOD TO BE BACK IN ACTION!", yell = true},
	{text = "THE WARDS ARE FAILING! MY ESCAPE IS ONLY A MATTER OF TIME!!", yell = true},
	{text = "Terofar cast a greater death curse on you!", yell = true}
}

monster.loot = {
	{id = 20062, chance = 100000}, -- cluster of solace
	{id = 20264, chance = 100000}, -- unrealized dream
	{id = 20063, chance = 100000}, -- dream matter
	{id = 6499, chance = 100000}, -- demonic essence
	{id = 5954, chance = 100000}, -- demon horn
	{id = 20276, chance = 3560}, -- dream warden mask
	{id = 3031, chance = 100000, maxCount = 200}, -- gold coin
	{id = 3035, chance = 100000, maxCount = 50}, -- platinum coin
	{id = 238, chance = 33330, maxCount = 10}, -- great mana potion
	{id = 7643, chance = 3890, maxCount = 10}, -- ultimate health potion
	{id = 7642, chance = 2780, maxCount = 5}, -- great spirit potion
	{id = 16119, chance = 22220, maxCount = 8}, -- blue crystal shard
	{id = 16120, chance = 33330, maxCount = 8}, -- violet crystal shard
	{id = 16121, chance = 44440, maxCount = 8}, -- green crystal shard
	{id = 9058, chance = 16670}, -- gold ingot
	{id = 281, chance = 38890}, -- giant shimmering pearl (green)
	{id = 282, chance = 38890}, -- giant shimmering pearl (brown)
	{id = 3420, chance = 11110}, -- demon shield
	{id = 3415, chance = 22220}, -- guardian shield
	{id = 3419, chance = 11110}, -- crown shield
	{id = 3414, chance = 960}, -- mastermind shield
	{id = 8063, chance = 5560}, -- paladin armor
	{id = 8051, chance = 11110}, -- voltage armor
	{id = 8049, chance = 6110}, -- lavos armor
	{id = 3038, chance = 16670}, -- green gem
	{id = 3041, chance = 11110}, -- blue gem
	{id = 8054, chance = 410}, -- earthborn titan armor
	{id = 3366, chance = 610}, -- magic plate armor
	{id = 3554, chance = 910}, -- steel boots
	{id = 3392, chance = 910}, -- royal helmet
	{id = 813, chance = 2910}, -- terra boots
	{id = 3079, chance = 1910}, -- boots of haste
	{id = 5741, chance = 1910} -- skull helmet
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 180, attack = 100},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1500, length = 8, spread = 3, effect = CONST_ME_SMALLCLOUDS, target = false},
	{name ="combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -750, range = 7, radius = 1, shootEffect = CONST_ANI_WHIRLWINDAXE, target = true}
}

monster.defenses = {
	defense = 65,
	armor = 55,
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 300, maxDamage = 500, radius = 8, target = false},
	{name ="speed", interval = 2000, chance = 18, speedChange = 784, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 7000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
