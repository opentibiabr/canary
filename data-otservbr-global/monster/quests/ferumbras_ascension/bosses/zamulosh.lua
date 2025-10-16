local mType = Game.createMonsterType("Zamulosh")
local monster = {}

monster.description = "Zamulosh"
monster.experience = 500000
monster.outfit = {
	lookType = 862,
	lookHead = 16,
	lookBody = 12,
	lookLegs = 73,
	lookFeet = 55,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 22495
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1181,
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
	canPushCreatures = false,
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

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "Zamulosh2", chance = 100, interval = 1000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I AM ZAMULOSH!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 101 }, -- gold coin
	{ id = 16124, chance = 80000, maxCount = 6 }, -- blue crystal splinter
	{ id = 16123, chance = 80000, maxCount = 6 }, -- brown crystal splinter
	{ id = 238, chance = 80000, maxCount = 5 }, -- great mana potion
	{ id = 16122, chance = 80000, maxCount = 6 }, -- green crystal splinter
	{ id = 3033, chance = 80000, maxCount = 5 }, -- small amethyst
	{ id = 3030, chance = 80000, maxCount = 5 }, -- small ruby
	{ id = 7643, chance = 80000, maxCount = 5 }, -- ultimate health potion
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 8050, chance = 80000 }, -- crystalline armor
	{ id = 3035, chance = 80000, maxCount = 25 }, -- platinum coin
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3053, chance = 80000 }, -- time ring
	{ id = 3049, chance = 80000 }, -- stealth ring
	{ id = 22726, chance = 80000 }, -- rift shield
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22755, chance = 80000 }, -- book of lies
	{ id = 22762, chance = 80000 }, -- maimer
	{ id = 6558, chance = 80000 }, -- flask of demonic blood
	{ id = 3029, chance = 80000 }, -- small sapphire
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 8074, chance = 80000 }, -- spellbook of mind control
	{ id = 22867, chance = 80000 }, -- rift crossbow
}

monster.attacks = {
	{ name = "melee", interval = 3000, chance = 100, minDamage = -1500, maxDamage = -2300 },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -800, length = 12, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -2600, maxDamage = -3300, length = 12, spread = 3, effect = CONST_ME_TELEPORT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -900, maxDamage = -1500, length = 6, spread = 2, effect = CONST_ME_FIREAREA, target = false },
	{ name = "speed", interval = 2000, chance = 35, speedChange = -600, radius = 8, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 220, maxDamage = 535, effect = CONST_ME_YELLOW_RINGS, target = false },
	{ name = "zamulosh invisible", interval = 2000, chance = 25 },
	{ name = "zamulosh tp", interval = 2000, chance = 15, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -1 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
