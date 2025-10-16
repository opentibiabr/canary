local mType = Game.createMonsterType("Iks Ahpututu")
local monster = {}

monster.description = "an iks ahpututu"
monster.experience = 1700
monster.outfit = {
	lookType = 1590,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2349
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5,
	FirstUnlock = 1,
	SecondUnlock = 2,
	CharmsPoints = 50,
	Stars = 3,
	Occurrence = 0,
	Locations = "Iksupan",
}

monster.health = 1630
monster.maxHealth = 1630
monster.race = "blood"
monster.corpse = 42065
monster.speed = 110
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
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 237, chance = 23000 }, -- strong mana potion
	{ id = 24961, chance = 23000 }, -- tiger eye
	{ id = 3029, chance = 5000 }, -- small sapphire
	{ id = 3081, chance = 5000 }, -- stone skin amulet
	{ id = 22194, chance = 5000 }, -- opal
	{ id = 8072, chance = 1000 }, -- spellbook of enlightenment
	{ id = 9058, chance = 1000 }, -- gold ingot
	{ id = 40531, chance = 260 }, -- broken iks faulds
	{ id = 40532, chance = 260 }, -- broken iks headpiece
	{ id = 40534, chance = 260 }, -- broken iks sandals
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -235 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -120, maxDamage = -250, range = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 34,
	mitigation = 1.26,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
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
