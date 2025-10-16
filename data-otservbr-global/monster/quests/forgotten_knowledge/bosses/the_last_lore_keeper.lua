local mType = Game.createMonsterType("The Last Lore Keeper")
local monster = {}

monster.description = "the last lore keeper"
monster.experience = 45000
monster.outfit = {
	lookType = 939,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
}

monster.health = 750000
monster.maxHealth = 750000
monster.race = "undead"
monster.corpse = 0
monster.speed = 225
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1304,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 340,
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
	maxSummons = 6,
	summons = {
		{ name = "sword of vengeance", chance = 50, interval = 2000, count = 6 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 9632, chance = 80000 }, -- ancient stone
	{ id = 22193, chance = 80000 }, -- onyx chip
	{ id = 22721, chance = 80000, maxCount = 3 }, -- gold token
	{ id = 5880, chance = 80000, maxCount = 5 }, -- iron ore
	{ id = 5887, chance = 80000 }, -- piece of royal steel
	{ id = 3035, chance = 80000, maxCount = 35 }, -- platinum coin
	{ id = 22516, chance = 80000, maxCount = 4 }, -- silver token
	{ id = 16119, chance = 80000, maxCount = 6 }, -- blue crystal shard
	{ id = 16120, chance = 80000, maxCount = 10 }, -- violet crystal shard
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 238, chance = 80000, maxCount = 10 }, -- great mana potion
	{ id = 7643, chance = 80000, maxCount = 10 }, -- ultimate health potion
	{ id = 7642, chance = 80000, maxCount = 10 }, -- great spirit potion
	{ id = 3029, chance = 80000, maxCount = 20 }, -- small sapphire
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 3032, chance = 80000, maxCount = 20 }, -- small emerald
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 9660, chance = 80000 }, -- mystical hourglass
	{ id = 22194, chance = 80000, maxCount = 2 }, -- opal
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 9057, chance = 80000, maxCount = 20 }, -- small topaz
	{ id = 5909, chance = 80000, maxCount = 4 }, -- white piece of cloth
	{ id = 3030, chance = 80000, maxCount = 20 }, -- small ruby
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 3033, chance = 80000, maxCount = 20 }, -- small amethyst
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 5891, chance = 80000 }, -- enchanted chicken wing
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 7437, chance = 80000 }, -- sapphire hammer
	{ id = 8029, chance = 80000 }, -- silkweaver bow
	{ id = 8051, chance = 80000 }, -- voltage armor
	{ id = 3408, chance = 80000 }, -- bonelord helmet
	{ id = 8076, chance = 80000 }, -- spellscroll of prophecies
	{ id = 3360, chance = 80000 }, -- golden armor
	{ id = 3340, chance = 80000 }, -- heavy mace
	{ id = 7418, chance = 80000 }, -- nightmare blade
	{ id = 24975, chance = 80000 }, -- astral source
	{ id = 24971, chance = 80000 }, -- forbidden tome
	{ id = 24972, chance = 80000 }, -- key to knowledge
	{ id = 24976, chance = 80000 }, -- astral glyph
	{ id = 16160, chance = 80000 }, -- crystalline sword
	{ id = 20080, chance = 80000 }, -- umbral hammer
	{ id = 20079, chance = 80000 }, -- crude umbral hammer
	{ id = 5809, chance = 80000 }, -- soul stone
	{ id = 7450, chance = 80000 }, -- hammer of prophecy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 140, attack = 80 },
	{ name = "combat", interval = 2000, chance = 7, type = COMBAT_PHYSICALDAMAGE, minDamage = -650, maxDamage = -900, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -850, maxDamage = -2260, length = 10, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -640, maxDamage = -800, radius = 5, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -420, maxDamage = -954, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -640, maxDamage = -800, radius = 5, effect = CONST_ME_STONES, target = true },
	{ name = "medusa paralyze", interval = 2000, chance = 20, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 50,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 3000, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
