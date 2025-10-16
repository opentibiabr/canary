local mType = Game.createMonsterType("Thornfire Wolf")
local monster = {}

monster.description = "a thornfire wolf"
monster.experience = 200
monster.outfit = {
	lookType = 414,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 739
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 5,
	FirstUnlock = 2,
	SecondUnlock = 3,
	CharmsPoints = 50,
	Stars = 3,
	Occurrence = 3,
	Locations = "Shadowthorn.",
}

monster.health = 600
monster.maxHealth = 600
monster.race = "venom"
monster.corpse = 12717
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 5,
	color = 206,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Hfffff!", yell = false },
	{ text = "Rrrrrr!", yell = false },
	{ text = "Graaawwwr!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 53 }, -- gold coin
	{ id = 3577, chance = 80000 }, -- meat
	{ id = 763, chance = 23000, maxCount = 8 }, -- flaming arrow
	{ id = 5897, chance = 5000 }, -- wolf paw
	{ id = 3028, chance = 1000 }, -- small diamond
	{ id = 3071, chance = 1000 }, -- wand of inferno
	{ id = 9636, chance = 1000 }, -- fiery heart
	{ id = 3280, chance = 260 }, -- fire sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -68 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -35, maxDamage = -70, range = 1, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -30, maxDamage = -70, range = 7, radius = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "firefield", interval = 2000, chance = 10, range = 7, radius = 2, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 18,
	mitigation = 0.64,
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 220, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
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
