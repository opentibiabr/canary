local mType = Game.createMonsterType("Retching Horror")
local monster = {}

monster.description = "a retching horror"
monster.experience = 4100
monster.outfit = {
	lookType = 588,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1018
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "All over the surface of Upper Roshamuul and Nightmare Isles.",
}

monster.health = 5300
monster.maxHealth = 5300
monster.race = "fire"
monster.corpse = 20174
monster.speed = 180
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Wait for us, little maggot...", yell = false },
	{ text = "We will devour you...", yell = false },
	{ text = "My little beetles, go forth, eat, feast!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 9 }, -- platinum coin
	{ id = 20205, chance = 23000 }, -- goosebump leather
	{ id = 3725, chance = 23000, maxCount = 2 }, -- brown mushroom
	{ id = 20207, chance = 23000 }, -- pool of chitinous glue
	{ id = 239, chance = 23000 }, -- great health potion
	{ id = 238, chance = 23000 }, -- great mana potion
	{ id = 3344, chance = 5000 }, -- beastslayer axe
	{ id = 20029, chance = 5000 }, -- broken dream
	{ id = 8082, chance = 5000 }, -- underworld rod
	{ id = 7386, chance = 5000 }, -- mercenary sword
	{ id = 3419, chance = 5000 }, -- crown shield
	{ id = 7452, chance = 5000 }, -- spiked squelcher
	{ id = 8092, chance = 5000 }, -- wand of starstorm
	{ id = 3280, chance = 5000 }, -- fire sword
	{ id = 3428, chance = 1000 }, -- tower shield
	{ id = 7421, chance = 1000 }, -- onyx flail
	{ id = 7412, chance = 260 }, -- butchers axe
	{ id = 3554, chance = 260 }, -- steel boots
	{ id = 20062, chance = 260 }, -- cluster of solace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "drunk", interval = 2000, chance = 10, length = 4, spread = 0, effect = CONST_ME_MAGIC_GREEN, target = true, duration = 5000 },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -700, radius = 4, shootEffect = CONST_ANI_WHIRLWINDCLUB, effect = CONST_ME_STUN, target = true, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -110, radius = 4, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, radius = 1, shootEffect = CONST_ANI_SNIPERARROW, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -350, radius = 1, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 30,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -3 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 85 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
