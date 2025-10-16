local mType = Game.createMonsterType("Ogre Ruffian")
local monster = {}

monster.description = "an ogre ruffian"
monster.experience = 5000
monster.outfit = {
	lookType = 1212,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1820
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Kilmaresh Central Steppe, Kilmaresh Southern Steppe, Green Belt, Kilmaresh Mountains underground.",
}

monster.health = 5500
monster.maxHealth = 5500
monster.race = "blood"
monster.corpse = 31527
monster.speed = 215
monster.manaCost = 0

monster.faction = FACTION_ANUMA
monster.enemyFactions = { FACTION_PLAYER, FACTION_FAFNAR }

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	staticAttackChance = 70,
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
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 22188, chance = 23000 }, -- ogre ear stud
	{ id = 22189, chance = 23000 }, -- ogre nose ring
	{ id = 3577, chance = 23000 }, -- meat
	{ id = 3029, chance = 23000 }, -- small sapphire
	{ id = 3032, chance = 23000 }, -- small emerald
	{ id = 677, chance = 5000, maxCount = 2 }, -- small enchanted emerald
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 3081, chance = 5000 }, -- stone skin amulet
	{ id = 3279, chance = 5000 }, -- war hammer
	{ id = 7387, chance = 5000 }, -- diamond sceptre
	{ id = 16122, chance = 5000 }, -- green crystal splinter
	{ id = 16125, chance = 5000 }, -- cyan crystal fragment
	{ id = 17828, chance = 5000 }, -- pair of iron fists
	{ id = 22191, chance = 5000 }, -- skull fetish
	{ id = 21169, chance = 5000 }, -- metal spats
	{ id = 22193, chance = 5000 }, -- onyx chip
	{ id = 22171, chance = 1000 }, -- ogre klubba
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -450, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -350, range = 4, radius = 5, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_POFF, target = true },
}

monster.defenses = {
	defense = 102,
	armor = 102,
	mitigation = 2.72,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
