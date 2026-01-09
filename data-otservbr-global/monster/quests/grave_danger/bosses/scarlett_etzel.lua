local mType = Game.createMonsterType("Scarlett Etzel")
local monster = {}

monster.description = "Scarlett Etzel"
monster.experience = 20000
monster.outfit = {
	lookType = 1201,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"scarlettThink",
	"scarlettHealth",
	"grave_danger_death",
}

monster.bosstiary = {
	bossRaceId = 1804,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 30000
monster.maxHealth = 30000
monster.race = "blood"
monster.corpse = 31453
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	{ text = "Galthen... is that you? ", yell = false },
	{ text = " Where... have you been all that time? ", yell = false },
	{ text = " What...? How dare you? Give me that back! ", yell = false },
	{ text = " Aaaaaaah!!!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 279765, maxCount = 9 }, -- Platinum Coin
	{ id = 3043, chance = 26196 }, -- Crystal Coin
	{ id = 22516, chance = 28364, maxCount = 6 }, -- Silver Token
	{ id = 30396, chance = 448 }, -- Cobra Axe
	{ id = 30395, chance = 1644 }, -- Cobra Club
	{ id = 30393, chance = 986 }, -- Cobra Crossbow
	{ id = 30397, chance = 328 }, -- Cobra Hood
	{ id = 30400, chance = 317 }, -- Cobra Rod
	{ id = 30398, chance = 317 }, -- Cobra Sword
	{ id = 30399, chance = 1000 }, -- Cobra Wand
	{ id = 50167, chance = 1000 }, -- Cobra Bo
	{ id = 31631, chance = 1000 }, -- The Cobra Amulet
	{ id = 23375, chance = 149412, maxCount = 31 }, -- Supreme Health Potion
	{ id = 23373, chance = 158175, maxCount = 30 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 95483, maxCount = 11 }, -- Ultimate Spirit Potion
	{ id = 7439, chance = 53658, maxCount = 19 }, -- Berserk Potion
	{ id = 7443, chance = 56820, maxCount = 18 }, -- Bullseye Potion
	{ id = 7440, chance = 53839, maxCount = 19 }, -- Mastermind Potion
	{ id = 49271, chance = 9154, maxCount = 19 }, -- Transcendence Potion
	{ id = 3036, chance = 25293, maxCount = 2 }, -- Violet Gem
	{ id = 3041, chance = 51490, maxCount = 2 }, -- Blue Gem
	{ id = 3038, chance = 279584, maxCount = 2 }, -- Green Gem
	{ id = 3037, chance = 97199, maxCount = 2 }, -- Yellow Gem
	{ id = 3039, chance = 103252, maxCount = 2 }, -- Red Gem
	{ id = 30059, chance = 13167 }, -- Giant Ruby
	{ id = 30061, chance = 19152 }, -- Giant Sapphire
	{ id = 9058, chance = 38663 }, -- Gold Ingot
	{ id = 281, chance = 41553 }, -- Giant Shimmering Pearl
	{ id = 817, chance = 30352 }, -- Magma Amulet
	{ id = 827, chance = 32068 }, -- Magma Monocle
	{ id = 826, chance = 41824 }, -- Magma Coat
	{ id = 25759, chance = 84643, maxCount = 100 }, -- Royal Star
	{ id = 814, chance = 10930 }, -- Terra Amulet
	{ id = 830, chance = 15718 }, -- Terra Hood
	{ id = 811, chance = 22493 }, -- Terra Mantle
	{ id = 812, chance = 20686 }, -- Terra Legs
	{ id = 3065, chance = 34056 }, -- Terra Rod
	{ id = 23535, chance = 279765 }, -- Energy Bar
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1200 },
	{ name = "sudden death rune", interval = 2000, chance = 16, minDamage = -400, maxDamage = -600, target = true },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_HOLYDAMAGE, minDamage = -450, maxDamage = -640, length = 7, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -480, maxDamage = -800, radius = 5, effect = CONST_ME_EXPLOSIONHIT, target = false },
}

monster.defenses = {
	defense = 88,
	armor = 88,
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
