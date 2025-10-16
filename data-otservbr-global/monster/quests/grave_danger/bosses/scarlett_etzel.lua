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
	{ id = 3035, chance = 80000, maxCount = 9 }, -- platinum coin
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 22516, chance = 80000, maxCount = 6 }, -- silver token
	{ id = 30396, chance = 260 }, -- cobra axe
	{ id = 30395, chance = 260 }, -- cobra club
	{ id = 30393, chance = 260 }, -- cobra crossbow
	{ id = 30397, chance = 260 }, -- cobra hood
	{ id = 30400, chance = 260 }, -- cobra rod
	{ id = 30398, chance = 260 }, -- cobra sword
	{ id = 30399, chance = 260 }, -- cobra wand
	{ id = 23375, chance = 80000, maxCount = 31 }, -- supreme health potion
	{ id = 23373, chance = 80000, maxCount = 30 }, -- ultimate mana potion
	{ id = 23374, chance = 80000, maxCount = 11 }, -- ultimate spirit potion
	{ id = 7439, chance = 80000, maxCount = 19 }, -- berserk potion
	{ id = 7443, chance = 80000, maxCount = 18 }, -- bullseye potion
	{ id = 7440, chance = 80000, maxCount = 19 }, -- mastermind potion
	{ id = 3036, chance = 80000, maxCount = 2 }, -- violet gem
	{ id = 3041, chance = 80000, maxCount = 2 }, -- blue gem
	{ id = 3038, chance = 80000, maxCount = 2 }, -- green gem
	{ id = 3037, chance = 80000, maxCount = 2 }, -- yellow gem
	{ id = 36706, chance = 80000, maxCount = 2 }, -- red gem
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 817, chance = 80000 }, -- magma amulet
	{ id = 827, chance = 80000 }, -- magma monocle
	{ id = 826, chance = 80000 }, -- magma coat
	{ id = 25759, chance = 80000, maxCount = 100 }, -- royal star
	{ id = 814, chance = 80000 }, -- terra amulet
	{ id = 830, chance = 80000 }, -- terra hood
	{ id = 811, chance = 80000 }, -- terra mantle
	{ id = 812, chance = 80000 }, -- terra legs
	{ id = 3065, chance = 80000 }, -- terra rod
	{ id = 23535, chance = 80000 }, -- energy bar
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
