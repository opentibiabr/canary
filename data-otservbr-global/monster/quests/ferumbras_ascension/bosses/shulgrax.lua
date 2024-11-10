local mType = Game.createMonsterType("Shulgrax")
local monster = {}

monster.description = "Shulgrax"
monster.experience = 500000
monster.outfit = {
	lookType = 842,
	lookHead = 0,
	lookBody = 62,
	lookLegs = 2,
	lookFeet = 87,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.health = 40000
monster.maxHealth = 40000
monster.race = "undead"
monster.corpse = 22495
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1191,
	bossRace = RARITY_ARCHFOE,
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
	{ text = "DAMMMMNNNNAAATIONN!", yell = false },
	{ text = "I WILL FEAST ON YOUR SOUL!", yell = true },
	{ text = "YOU ARE ALL DAMNED!", yell = true },
}

monster.loot = {
	{ id = 22516, chance = 1000000 }, -- silver token
	{ id = 6558, chance = 10000 }, -- flask of demonic blood
	{ id = 6558, chance = 10000 }, -- flask of demonic blood
	{ id = 6558, chance = 10000 }, -- flask of demonic blood
	{ id = 6558, chance = 10000 }, -- flask of demonic blood
	{ id = 6558, chance = 10000 }, -- flask of demonic blood
	{ id = 17838, chance = 1800 }, -- unknown item
	{ id = 3019, chance = 1000 }, -- demonbone amulet
	{ id = 3026, chance = 12000, maxCount = 8 }, -- white pearl
	{ id = 3029, chance = 12000, maxCount = 9 }, -- small sapphire
	{ id = 3031, chance = 98000, maxCount = 200 }, -- gold coin
	{ id = 3033, chance = 10000, maxCount = 5 }, -- small amethyst
	{ id = 3035, chance = 8000, maxCount = 58 }, -- platinum coin
	{ id = 3036, chance = 1000 }, -- violet gem
	{ id = 3037, chance = 1000 }, -- yellow gem
	{ id = 3038, chance = 1000 }, -- green gem
	{ id = 3039, chance = 1000 }, -- red gem
	{ id = 3366, chance = 700 }, -- magic plate armor
	{ id = 22193, chance = 46100, maxCount = 5 }, -- onyx chip
	{ id = 22194, chance = 46100, maxCount = 5 }, -- opal
	{ id = 22726, chance = 700 }, -- rift shield
	{ id = 22727, chance = 700 }, -- rift lance
	{ id = 22756, chance = 500, unique = true }, -- treader of torment
	{ id = 22867, chance = 700 }, -- rift crossbow
	{ id = 5021, chance = 46100, maxCount = 5 }, -- orichalcum pearl
	{ id = 6299, chance = 1300 }, -- death ring
	{ id = 6499, chance = 11000 }, -- demonic essence
	{ id = 7416, chance = 1000 }, -- bloody edge
	{ id = 7419, chance = 1300 }, -- dreaded cleaver
	{ id = 7427, chance = 1000 }, -- chaos mace
	{ id = 7451, chance = 1900 }, -- shadow sceptre
	{ id = 238, chance = 23000, maxCount = 5 }, -- great mana potion
	{ id = 281, chance = 14000, maxCount = 5 }, -- giant shimmering pearl (green)
	{ id = 282, chance = 14000, maxCount = 5 }, -- giant shimmering pearl (brown)
	{ id = 816, chance = 1000 }, -- lightning pendant
	{ id = 822, chance = 1000 }, -- lightning legs
	{ id = 7642, chance = 46100, maxCount = 10 }, -- great spirit potion
	{ id = 7643, chance = 23000, maxCount = 5 }, -- ultimate health potion
	{ id = 9057, chance = 10000, maxCount = 5 }, -- small topaz
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
	defense = 65,
	armor = 55,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 6000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "shulgrax summon", interval = 5000, chance = 5, target = false },
	{ name = "speed", interval = 4000, chance = 80, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
