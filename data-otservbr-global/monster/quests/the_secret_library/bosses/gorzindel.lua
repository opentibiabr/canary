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
	{ id = 27934, chance = 80000 }, -- knowledgeable book
	{ id = 27933, chance = 80000 }, -- ominous book
	{ id = 27932, chance = 80000 }, -- sinister book
	{ id = 3043, chance = 80000, maxCount = 3 }, -- crystal coin
	{ id = 3035, chance = 80000, maxCount = 32 }, -- platinum coin
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3554, chance = 80000 }, -- steel boots
	{ id = 28832, chance = 80000 }, -- sulphurous demonbone
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 7419, chance = 80000 }, -- dreaded cleaver
	{ id = 3073, chance = 80000 }, -- wand of cosmic energy
	{ id = 7443, chance = 80000, maxCount = 2 }, -- bullseye potion
	{ id = 23374, chance = 80000, maxCount = 4 }, -- ultimate spirit potion
	{ id = 23373, chance = 80000 }, -- ultimate mana potion
	{ id = 5954, chance = 80000 }, -- demon horn
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 8902, chance = 80000 }, -- slightly rusted shield
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 22193, chance = 80000 }, -- onyx chip
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 28792, chance = 80000 }, -- sturdy book
	{ id = 7418, chance = 80000 }, -- nightmare blade
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 23511, chance = 80000 }, -- curious matter
	{ id = 23375, chance = 80000 }, -- supreme health potion
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 16117, chance = 80000 }, -- muck rod
	{ id = 3381, chance = 80000 }, -- crown armor
	{ id = 3041, chance = 80000 }, -- blue gem
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
