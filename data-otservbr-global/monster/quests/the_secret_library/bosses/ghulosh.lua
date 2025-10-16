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
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 9057, chance = 80000, maxCount = 12 }, -- small topaz
	{ id = 7412, chance = 80000 }, -- butchers axe
	{ id = 3043, chance = 80000, maxCount = 5 }, -- crystal coin
	{ id = 5954, chance = 80000 }, -- demon horn
	{ id = 23374, chance = 80000, maxCount = 4 }, -- ultimate spirit potion
	{ id = 23375, chance = 80000, maxCount = 8 }, -- supreme health potion
	{ id = 3035, chance = 80000, maxCount = 39 }, -- platinum coin
	{ id = 7440, chance = 80000, maxCount = 2 }, -- mastermind potion
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 23517, chance = 80000 }, -- solid rage
	{ id = 7443, chance = 80000 }, -- bullseye potion
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 22516, chance = 80000, maxCount = 6 }, -- silver token
	{ id = 28820, chance = 80000 }, -- ornate tome
	{ id = 27934, chance = 80000 }, -- knowledgeable book
	{ id = 28831, chance = 80000 }, -- unliving demonbone
	{ id = 28793, chance = 80000 }, -- epaulette
	{ id = 8075, chance = 80000 }, -- spellbook of lost souls
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 23373, chance = 80000 }, -- ultimate mana potion
	{ id = 3033, chance = 80000 }, -- small amethyst
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 7386, chance = 80000 }, -- mercenary sword
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 7419, chance = 80000 }, -- dreaded cleaver
	{ id = 22193, chance = 80000 }, -- onyx chip
	{ id = 8908, chance = 80000 }, -- slightly rusted helmet
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 27932, chance = 80000 }, -- sinister book
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 8902, chance = 80000 }, -- slightly rusted shield
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 27933, chance = 80000 }, -- ominous book
	{ id = 8094, chance = 80000 }, -- wand of voodoo
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
