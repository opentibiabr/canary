local mType = Game.createMonsterType("Mazoran")
local monster = {}

monster.description = "Mazoran"
monster.experience = 500000
monster.outfit = {
	lookType = 842,
	lookHead = 77,
	lookBody = 79,
	lookLegs = 78,
	lookFeet = 94,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.bosstiary = {
	bossRaceId = 1186,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "fire"
monster.corpse = 22495
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	runHealth = 1,
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
	{ id = 22516, chance = 1000000 }, -- silver token
	{ id = 16125, chance = 23000, maxCount = 5 }, -- cyan crystal fragment
	{ id = 16126, chance = 23000, maxCount = 5 }, -- red crystal fragment
	{ id = 16127, chance = 23000, maxCount = 5 }, -- green crystal fragment
	{ id = 3026, chance = 12000, maxCount = 8 }, -- white pearl
	{ id = 3029, chance = 12000, maxCount = 9 }, -- small sapphire
	{ id = 3031, chance = 98000, maxCount = 200 }, -- gold coin
	{ id = 3033, chance = 10000, maxCount = 5 }, -- small amethyst
	{ id = 3035, chance = 8000, maxCount = 58 }, -- platinum coin
	{ id = 3038, chance = 1000 }, -- green gem
	{ id = 3041, chance = 1000 }, -- blue gem
	{ id = 3051, chance = 4000 }, -- energy ring
	{ id = 3320, chance = 3000 }, -- fire axe
	{ id = 22760, chance = 500 }, -- impaler of the igniter
	{ id = 3442, chance = 500, unique = true }, -- tempest shield
	{ id = 22866, chance = 500 }, -- rift bow
	{ id = 22867, chance = 500 }, -- rift crossbow
	{ id = 6499, chance = 11000 }, -- demonic essence
	{ id = 7382, chance = 1000 }, -- demonrage sword
	{ id = 238, chance = 23000, maxCount = 5 }, -- great mana potion
	{ id = 281, chance = 14000, maxCount = 5 }, -- giant shimmering pearl (green)
	{ id = 282, chance = 14000, maxCount = 5 }, -- giant shimmering pearl (brown)
	{ id = 817, chance = 1000 }, -- magma amulet
	{ id = 821, chance = 1000 }, -- magma legs
	{ id = 826, chance = 1000 }, -- magma coat
	{ id = 7642, chance = 46100, maxCount = 5 }, -- great spirit potion
	{ id = 7643, chance = 23000, maxCount = 5 }, -- ultimate health potion
	{ id = 9057, chance = 10000, maxCount = 8 }, -- small topaz
	{ id = 9058, chance = 3000 }, -- gold ingot
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1500, maxDamage = -2500 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1000, length = 10, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "speed", interval = 2000, chance = 25, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -700, radius = 5, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_FIREATTACK, target = false },
}

monster.defenses = {
	defense = 125,
	armor = 125,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 2090, maxDamage = 4500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 35, speedChange = 700, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 6000 },
	{ name = "mazoran fire", interval = 30000, chance = 45, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
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
