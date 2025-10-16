local mType = Game.createMonsterType("Brachiodemon")
local monster = {}

monster.description = "a brachiodemon"
monster.experience = 15770
monster.outfit = {
	lookType = 1299,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1930
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Claustrophobic Inferno.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "blood"
monster.corpse = 33817
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	canPushCreatures = false,
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
	{ text = "Feel the heat!", yell = false },
	{ text = "Hand over your life.", yell = false },
	{ text = "I can give you a hand... or two.", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 7643, chance = 23000, maxCount = 4 }, -- ultimate health potion
	{ id = 33936, chance = 23000 }, -- hand
	{ id = 3324, chance = 5000 }, -- skull staff
	{ id = 3326, chance = 5000 }, -- epee
	{ id = 3333, chance = 5000 }, -- crystal mace
	{ id = 7456, chance = 5000 }, -- noble axe
	{ id = 3320, chance = 1000 }, -- fire axe
	{ id = 7404, chance = 1000 }, -- assassin dagger
	{ id = 7422, chance = 1000 }, -- jade hammer
	{ id = 8074, chance = 1000 }, -- spellbook of mind control
	{ id = 23531, chance = 1000 }, -- ring of green plasma
	{ id = 3392, chance = 260 }, -- royal helmet
	{ id = 3414, chance = 260 }, -- mastermind shield
	{ id = 7412, chance = 260 }, -- butchers axe
	{ id = 16160, chance = 260 }, -- crystalline sword
	{ id = 21168, chance = 260 }, -- alloy legs
	{ id = 21171, chance = 260 }, -- metal bat
	{ id = 34025, chance = 260 }, -- diabolic skull
	{ id = 34109, chance = 260 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -950 },
	{ name = "combat", interval = 2000, chance = 24, type = COMBAT_FIREDAMAGE, minDamage = -1100, maxDamage = -1550, radius = 4, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_DEATHDAMAGE, minDamage = -900, maxDamage = -1280, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -1150, maxDamage = -1460, range = 7, effect = CONST_ANI_SUDDENDEATH, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -950, maxDamage = -1100, range = 7, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "destroy magic walls", interval = 1000, chance = 30 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.75,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = -35 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval)
	monster:tryTeleportToPlayer("Burn in hell!")
end

mType:register(monster)
