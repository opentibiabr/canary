local mType = Game.createMonsterType("Ghulosh")
local monster = {}

monster.description = "Ghulosh"
monster.experience = 45000
monster.outfit = {
	lookType = 1062,
	lookHead = 78,
	lookBody = 113,
	lookLegs = 94,
	lookFeet = 18,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"ghuloshThink",
}

monster.bosstiary = {
	bossRaceId = 1608,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 26133
monster.speed = 50
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
	staticAttackChance = 98,
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
	{ id = 3043, chance = 100000, maxCount = 11 }, -- Crystal Coin
	{ id = 3035, chance = 100000, maxCount = 61 }, -- Platinum Coin
	{ id = 3081, chance = 100000 }, -- Stone Skin Amulet
	{ id = 22516, chance = 83000, maxCount = 10 }, -- Silver Token
	{ id = 23374, chance = 83000, maxCount = 16 }, -- Ultimate Spirit Potion
	{ id = 3028, chance = 67000, maxCount = 14 }, -- Small Diamond
	{ id = 23375, chance = 67000, maxCount = 13 }, -- Supreme Health Potion
	{ id = 7440, chance = 67000, maxCount = 2 }, -- Mastermind Potion
	{ id = 22193, chance = 50000, maxCount = 11 }, -- Onyx Chip
	{ id = 8908, chance = 50000 }, -- Slightly Rusted Helmet
	{ id = 5904, chance = 50000, maxCount = 2 }, -- Magic Sulphur
	{ id = 7412, chance = 50000 }, -- Butcher's Axe
	{ id = 6499, chance = 50000, maxCount = 7 }, -- Demonic Essence
	{ id = 3037, chance = 33000 }, -- Yellow Gem
	{ id = 23517, chance = 33000 }, -- Solid Rage
	{ id = 3039, chance = 33000 }, -- Red Gem
	{ id = 7443, chance = 33000 }, -- Bullseye Potion
	{ id = 7419, chance = 33000 }, -- Dreaded Cleaver
	{ id = 7439, chance = 33000 }, -- Berserk Potion
	{ id = 8902, chance = 16700 }, -- Slightly Rusted Shield
	{ id = 7421, chance = 16700 }, -- Onyx Flail
	{ id = 3032, chance = 16700, maxCount = 23 }, -- Small Emerald
	{ id = 9057, chance = 16700, maxCount = 11 }, -- Small Topaz
	{ id = 23373, chance = 16700 }, -- Ultimate Mana Potion
	{ id = 16117, chance = 16700 }, -- Muck Rod
	{ id = 3038, chance = 16700 }, -- Green Gem
	{ id = 7386, chance = 16700 }, -- Mercenary Sword
	{ id = 3041, chance = 16700 }, -- Blue Gem
	{ id = 22721, chance = 16700, maxCount = 6 }, -- Gold Token
	{ id = 8094, chance = 16700 }, -- Wand of Voodoo
}

monster.attacks = {
	{ name = "melee", interval = 1000, chance = 100, skill = 150, attack = 280 },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -900, maxDamage = -1500, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -210, maxDamage = -600, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -210, maxDamage = -600, range = 7, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_LIFEDRAIN, minDamage = -1500, maxDamage = -2000, range = 7, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
