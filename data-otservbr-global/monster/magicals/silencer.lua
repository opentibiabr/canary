local mType = Game.createMonsterType("Silencer")
local monster = {}

monster.description = "a silencer"
monster.experience = 5100
monster.outfit = {
	lookType = 585,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"RoshamuulKillsDeath",
}

monster.raceId = 1014
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "All over the Roshamuul surface and Nightmare Isles.",
}

monster.health = 5400
monster.maxHealth = 5400
monster.race = "blood"
monster.corpse = 20155
monster.speed = 235
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5,
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
	{ text = "Prrrroooaaaah!!! PRROAAAH!!", yell = false },
	{ text = "PRRRROOOOOAAAAAHHHH!!!", yell = true },
	{ text = "HUUUSSSSSSSSH!!", yell = true },
	{ text = "Hussssssh!!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 8 }, -- platinum coin
	{ id = 20200, chance = 23000 }, -- silencer claws
	{ id = 7368, chance = 23000, maxCount = 10 }, -- assassin star
	{ id = 20201, chance = 23000 }, -- silencer resonating chamber
	{ id = 3421, chance = 5000 }, -- dark shield
	{ id = 7454, chance = 5000 }, -- glorious axe
	{ id = 7413, chance = 5000 }, -- titan axe
	{ id = 7407, chance = 5000 }, -- haunted blade
	{ id = 3049, chance = 5000 }, -- stealth ring
	{ id = 812, chance = 1000 }, -- terra legs
	{ id = 7387, chance = 1000 }, -- diamond sceptre
	{ id = 813, chance = 1000 }, -- terra boots
	{ id = 7451, chance = 1000 }, -- shadow sceptre
	{ id = 3079, chance = 260 }, -- boots of haste
	{ id = 20062, chance = 260 }, -- cluster of solace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -315, condition = { type = CONDITION_POISON, totalDamage = 600, interval = 4000 } },
	{ name = "silencer skill reducer", interval = 2000, chance = 10, range = 3, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -40, maxDamage = -150, radius = 4, shootEffect = CONST_ANI_ONYXARROW, effect = CONST_ME_MAGIC_RED, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 71,
	mitigation = 1.82,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 450, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 220, maxDamage = 425, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 65 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
