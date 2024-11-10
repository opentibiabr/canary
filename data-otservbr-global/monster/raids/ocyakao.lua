local mType = Game.createMonsterType("Ocyakao")
local monster = {}

monster.description = "Ocyakao"
monster.experience = 490
monster.outfit = {
	lookType = 259,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 970,
	bossRace = RARITY_NEMESIS,
}

monster.health = 700
monster.maxHealth = 700
monster.race = "blood"
monster.corpse = 7320
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
	chance = 60,
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
	canPushCreatures = false,
	staticAttackChance = 80,
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
	{ text = "Chikuva!", yell = false },
	{ text = "Jinuma jamjam!", yell = false },
	{ text = "Grrrr! Kisavuta!", yell = false },
	{ text = "Suvituka siq chuqua!", yell = false },
	{ text = "Kiyosa sipaju!", yell = false },
	{ text = "Aiiee!", yell = false },
}

monster.loot = {
	{ id = 19083, chance = 200 }, -- silver raid token
	{ id = 3031, chance = 100000, maxCount = 20 }, -- gold coin
	{ id = 3578, chance = 100000, maxCount = 5 }, -- fish
	{ id = 3026, chance = 100000 }, -- white pearl
	{ id = 5909, chance = 100000 }, -- white piece of cloth
	{ id = 3286, chance = 37500 }, -- mace
	{ id = 19369, chance = 200, unique = true }, -- eye of the storm
	{ id = 3441, chance = 37570 }, -- bone shield
	{ id = 7381, chance = 25050 }, -- mammoth whopper
	{ id = 7441, chance = 62570 }, -- ice cube
	{ id = 7159, chance = 12500 }, -- green perch
	{ id = 3580, chance = 12520 }, -- northern pike
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 25, attack = 50 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 70, maxDamage = -185, range = 7, radius = 3, shootEffect = CONST_ANI_SMALLSTONE, effect = CONST_ME_HITAREA, target = true },
}

monster.defenses = {
	defense = 10,
	armor = 10,
	mitigation = 0.99,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
