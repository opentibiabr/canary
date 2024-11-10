local mType = Game.createMonsterType("Ragiaz")
local monster = {}

monster.description = "Ragiaz"
monster.experience = 500000
monster.outfit = {
	lookType = 862,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 19,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.bosstiary = {
	bossRaceId = 1180,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 280000
monster.maxHealth = 280000
monster.race = "undead"
monster.corpse = 22495
monster.speed = 170
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
	{ id = 22516, chance = 1000000 }, -- silver token
	{ id = 6558, chance = 10000 }, -- flask of demonic blood
	{ id = 6558, chance = 10000 }, -- flask of demonic blood
	{ id = 6558, chance = 10000 }, -- flask of demonic blood
	{ id = 6558, chance = 10000 }, -- flask of demonic blood
	{ id = 6558, chance = 10000 }, -- flask of demonic blood
	{ id = 3037, chance = 1000 }, -- yellow gem
	{ id = 16125, chance = 3000, maxCount = 5 }, -- cyan crystal fragment
	{ id = 16126, chance = 3000, maxCount = 5 }, -- red crystal fragment
	{ id = 16127, chance = 3000, maxCount = 5 }, -- green crystal fragment
	{ id = 3026, chance = 3000, maxCount = 8 }, -- white pearl
	{ id = 3029, chance = 3000, maxCount = 9 }, -- small sapphire
	{ id = 3031, chance = 98000, maxCount = 200 }, -- gold coin
	{ id = 3033, chance = 3000, maxCount = 5 }, -- small amethyst
	{ id = 3035, chance = 8000, maxCount = 58 }, -- platinum coin
	{ id = 3038, chance = 1000 }, -- green gem
	{ id = 3039, chance = 1000 }, -- red gem
	{ id = 3041, chance = 1000 }, -- blue gem
	{ id = 3324, chance = 4000 }, -- skull staff
	{ id = 22758, chance = 100, unique = true }, -- death gaze
	{ id = 22866, chance = 700 }, -- rift bow
	{ id = 22867, chance = 700 }, -- rift crossbow
	{ id = 6499, chance = 11000 }, -- demonic essence
	{ id = 7420, chance = 500 }, -- reaper's axe
	{ id = 7426, chance = 4000 }, -- amber staff
	{ id = 238, chance = 3000, maxCount = 5 }, -- great mana potion
	{ id = 239, chance = 3100, maxCount = 5 }, -- great health potion
	{ id = 281, chance = 3000, maxCount = 5 }, -- giant shimmering pearl (green)
	{ id = 282, chance = 3000, maxCount = 5 }, -- giant shimmering pearl (brown)
	{ id = 7642, chance = 3100, maxCount = 5 }, -- great spirit potion
	{ id = 7643, chance = 3000, maxCount = 5 }, -- ultimate health potion
	{ id = 9057, chance = 3000, maxCount = 8 }, -- small topaz
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1400, maxDamage = -2300 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, range = 4, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_POFF, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -1000, maxDamage = -1200, length = 10, spread = 3, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -1500, maxDamage = -1900, length = 10, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, radius = 7, effect = CONST_ME_POFF, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 125,
	armor = 125,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = 600, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 4000 },
	{ name = "ragiaz transform", interval = 2000, chance = 8, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 90 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
