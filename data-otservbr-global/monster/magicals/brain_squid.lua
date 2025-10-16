local mType = Game.createMonsterType("Brain Squid")
local monster = {}

monster.description = "a brain squid"
monster.experience = 17672
monster.outfit = {
	lookType = 1059,
	lookHead = 17,
	lookBody = 41,
	lookLegs = 77,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1653
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library (energy section).",
}

monster.health = 18000
monster.maxHealth = 18000
monster.race = "undead"
monster.corpse = 28582
monster.speed = 215
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	{ text = "tzzzz tzzzzz tzzzzz", yell = false },
	{ text = "tzuuuumme tzuuummmmee", yell = false },
}

monster.loot = {
	{ id = 16120, chance = 80000, maxCount = 4 }, -- violet crystal shard
	{ id = 3035, chance = 80000, maxCount = 20 }, -- platinum coin
	{ id = 28570, chance = 23000, maxCount = 4 }, -- glowing rune
	{ id = 23516, chance = 23000 }, -- instable proto matter
	{ id = 23523, chance = 23000 }, -- energy ball
	{ id = 23535, chance = 23000 }, -- energy bar
	{ id = 23545, chance = 23000 }, -- energy drink
	{ id = 23510, chance = 23000 }, -- odd organ
	{ id = 23519, chance = 23000 }, -- frozen lightning
	{ id = 3030, chance = 23000, maxCount = 6 }, -- small ruby
	{ id = 16124, chance = 23000 }, -- blue crystal splinter
	{ id = 23373, chance = 23000 }, -- ultimate mana potion
	{ id = 3036, chance = 23000 }, -- violet gem
	{ id = 16125, chance = 5000 }, -- cyan crystal fragment
	{ id = 9663, chance = 5000 }, -- piece of dead brain
	{ id = 16096, chance = 5000 }, -- wand of defiance
	{ id = 828, chance = 5000, maxCount = 2 }, -- lightning headband
	{ id = 816, chance = 5000 }, -- lightning pendant
	{ id = 21194, chance = 5000 }, -- slime heart
	{ id = 23528, chance = 5000 }, -- collar of red plasma
	{ id = 23526, chance = 5000 }, -- collar of blue plasma
	{ id = 23533, chance = 5000 }, -- ring of red plasma
	{ id = 23529, chance = 5000 }, -- ring of blue plasma
	{ id = 23531, chance = 5000 }, -- ring of green plasma
	{ id = 23527, chance = 1000 }, -- collar of green plasma
	{ id = 3048, chance = 1000 }, -- might ring
	{ id = 10438, chance = 260 }, -- spellweavers robe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -470, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -505, radius = 3, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 78,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
