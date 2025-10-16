local mType = Game.createMonsterType("Mazzinor")
local monster = {}

monster.description = "Mazzinor"
monster.experience = 100000
monster.outfit = {
	lookType = 1062,
	lookHead = 85,
	lookBody = 7,
	lookLegs = 3,
	lookFeet = 15,
	lookAddons = 2,
	lookMount = 0,
}

monster.events = {
	"mazzinorDeath",
	"mazzinorHealth",
}

monster.bosstiary = {
	bossRaceId = 1605,
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
	{ id = 3043, chance = 80000, maxCount = 10 }, -- crystal coin
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 8902, chance = 80000 }, -- slightly rusted shield
	{ id = 3035, chance = 80000, maxCount = 39 }, -- platinum coin
	{ id = 7443, chance = 80000 }, -- bullseye potion
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 22516, chance = 80000, maxCount = 6 }, -- silver token
	{ id = 3028, chance = 80000, maxCount = 12 }, -- small diamond
	{ id = 3030, chance = 80000, maxCount = 12 }, -- small ruby
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 820, chance = 80000 }, -- lightning boots
	{ id = 5954, chance = 80000 }, -- demon horn
	{ id = 27933, chance = 80000 }, -- ominous book
	{ id = 23375, chance = 80000, maxCount = 4 }, -- supreme health potion
	{ id = 23374, chance = 80000, maxCount = 8 }, -- ultimate spirit potion
	{ id = 23373, chance = 80000, maxCount = 12 }, -- ultimate mana potion
	{ id = 8092, chance = 80000 }, -- wand of starstorm
	{ id = 22193, chance = 80000, maxCount = 12 }, -- onyx chip
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 22721, chance = 80000, maxCount = 4 }, -- gold token
	{ id = 28793, chance = 80000 }, -- epaulette
	{ id = 7419, chance = 80000 }, -- dreaded cleaver
	{ id = 12603, chance = 80000 }, -- wand of dimensions
	{ id = 23519, chance = 80000 }, -- frozen lightning
	{ id = 27934, chance = 80000 }, -- knowledgeable book
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 28830, chance = 80000 }, -- energized demonbone
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 825, chance = 80000 }, -- lightning robe
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3019, chance = 80000 }, -- demonbone amulet
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 8908, chance = 80000 }, -- slightly rusted helmet
	{ id = 16117, chance = 80000 }, -- muck rod
	{ id = 3033, chance = 80000 }, -- small amethyst
	{ id = 3041, chance = 80000 }, -- blue gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 80 },
	{ name = "divine missile", interval = 2000, chance = 10, minDamage = -135, maxDamage = -700, target = true },
	{ name = "berserk", interval = 2000, chance = 20, minDamage = -90, maxDamage = -500, range = 7, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -135, maxDamage = -280, range = 7, radius = 5, effect = CONST_ME_MAGIC_BLUE, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -210, maxDamage = -600, length = 8, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -210, maxDamage = -700, length = 8, spread = 0, effect = CONST_ME_HOLYAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
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
