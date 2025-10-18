local mType = Game.createMonsterType("Gorzindel")
local monster = {}

monster.description = "Gorzindel"
monster.experience = 100000
monster.outfit = {
	lookType = 1062,
	lookHead = 94,
	lookBody = 81,
	lookLegs = 10,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"gorzindelHealth",
}

monster.bosstiary = {
	bossRaceId = 1591,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 22495
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4,
}

monster.strategiesTarget = {
	nearest = 100,
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
	{ id = 27934, chance = 1000 }, -- Knowledgeable Book
	{ id = 27933, chance = 3846 }, -- Ominous Book
	{ id = 27932, chance = 11538 }, -- Sinister Book
	{ id = 3043, chance = 81818, maxCount = 3 }, -- Crystal Coin
	{ id = 3035, chance = 100000, maxCount = 32 }, -- Platinum Coin
	{ id = 3036, chance = 3846 }, -- Violet Gem
	{ id = 3554, chance = 19354 }, -- Steel Boots
	{ id = 28832, chance = 1000 }, -- Sulphurous Demonbone
	{ id = 7427, chance = 33333 }, -- Chaos Mace
	{ id = 7419, chance = 42424 }, -- Dreaded Cleaver
	{ id = 3073, chance = 87878 }, -- Wand of Cosmic Energy
	{ id = 7443, chance = 38709, maxCount = 2 }, -- Bullseye Potion
	{ id = 23374, chance = 69696, maxCount = 4 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 60606 }, -- Ultimate Mana Potion
	{ id = 5954, chance = 45454 }, -- Demon Horn
	{ id = 7440, chance = 42424 }, -- Mastermind Potion
	{ id = 8902, chance = 15151 }, -- Slightly Rusted Shield
	{ id = 3037, chance = 12121 }, -- Yellow Gem
	{ id = 3081, chance = 100000 }, -- Stone Skin Amulet
	{ id = 22193, chance = 54545 }, -- Onyx Chip
	{ id = 7439, chance = 42424 }, -- Berserk Potion
	{ id = 9057, chance = 27272 }, -- Small Topaz
	{ id = 22516, chance = 84848 }, -- Silver Token
	{ id = 3028, chance = 39285 }, -- Small Diamond
	{ id = 3038, chance = 24242 }, -- Green Gem
	{ id = 28792, chance = 1000 }, -- Sturdy Book
	{ id = 7418, chance = 3846 }, -- Nightmare Blade
	{ id = 5904, chance = 23076 }, -- Magic Sulphur
	{ id = 3030, chance = 22580 }, -- Small Ruby
	{ id = 23511, chance = 41935 }, -- Curious Matter
	{ id = 23375, chance = 51612 }, -- Supreme Health Potion
	{ id = 22721, chance = 22580 }, -- Gold Token
	{ id = 16117, chance = 6451 }, -- Muck Rod
	{ id = 3381, chance = 15384 }, -- Crown Armor
	{ id = 3041, chance = 32258 }, -- Blue Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 100, attack = 100 },
	{ name = "melee", interval = 2000, chance = 15, minDamage = -600, maxDamage = -2800 },
	{ name = "melee", interval = 1000, chance = 15, minDamage = -800, maxDamage = -1300 },
	{ name = "melee", interval = 1000, chance = 15, minDamage = -800, maxDamage = -1000 },
	{ name = "melee", interval = 1000, chance = 15, minDamage = -200, maxDamage = -800 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -600, radius = 9, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 33,
	armor = 28,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
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
