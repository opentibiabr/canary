local mType = Game.createMonsterType("Werelion")
local monster = {}

monster.description = "a werelion"
monster.experience = 2200
monster.outfit = {
	lookType = 1301,
	lookHead = 58,
	lookBody = 2,
	lookLegs = 94,
	lookFeet = 10,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1965
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Lion Sanctum.",
}

monster.health = 2800
monster.maxHealth = 2800
monster.race = "blood"
monster.corpse = 33825
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	runHealth = 5,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 3383, chance = 23000 }, -- dark armor
	{ id = 676, chance = 23000 }, -- small enchanted ruby
	{ id = 3577, chance = 23000 }, -- meat
	{ id = 7449, chance = 23000 }, -- crystal sword
	{ id = 9691, chance = 23000 }, -- lions mane
	{ id = 22083, chance = 23000 }, -- moonlight crystals
	{ id = 3017, chance = 5000 }, -- silver brooch
	{ id = 3028, chance = 5000 }, -- small diamond
	{ id = 3279, chance = 5000 }, -- war hammer
	{ id = 3379, chance = 5000 }, -- doublet
	{ id = 3421, chance = 5000 }, -- dark shield
	{ id = 7413, chance = 5000 }, -- titan axe
	{ id = 7452, chance = 5000 }, -- spiked squelcher
	{ id = 7454, chance = 5000 }, -- glorious axe
	{ id = 8042, chance = 5000 }, -- spirit cloak
	{ id = 22193, chance = 5000 }, -- onyx chip
	{ id = 24391, chance = 5000 }, -- coral brooch
	{ id = 25737, chance = 5000 }, -- rainbow quartz
	{ id = 33945, chance = 5000 }, -- ivory carving
	{ id = 7456, chance = 1000 }, -- noble axe
	{ id = 34008, chance = 260 }, -- white silk flower
	{ id = 33781, chance = 260 }, -- lion figurine
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "werelion wave", interval = 2000, chance = 20, minDamage = -150, maxDamage = -250, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -300, maxDamage = -410, range = 3, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -170, maxDamage = -350, range = 3, shootEffect = CONST_ANI_HOLY, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 38,
	mitigation = 0.91,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 45 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
