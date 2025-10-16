local mType = Game.createMonsterType("Energetic Book")
local monster = {}

monster.description = "an energetic book"
monster.experience = 12034
monster.outfit = {
	lookType = 1061,
	lookHead = 15,
	lookBody = 91,
	lookLegs = 85,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1665
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

monster.health = 18500
monster.maxHealth = 18500
monster.race = "ink"
monster.corpse = 28778
monster.speed = 220
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
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Flood the room with curious energy!", yell = false },
	{ text = "zup zup zup zuuuuup!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 35 }, -- platinum coin
	{ id = 28569, chance = 80000, maxCount = 8 }, -- book page
	{ id = 28570, chance = 80000, maxCount = 6 }, -- glowing rune
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 23373, chance = 23000 }, -- ultimate mana potion
	{ id = 23523, chance = 23000 }, -- energy ball
	{ id = 28566, chance = 23000 }, -- silken bookmark
	{ id = 816, chance = 5000 }, -- lightning pendant
	{ id = 820, chance = 5000 }, -- lightning boots
	{ id = 822, chance = 5000 }, -- lightning legs
	{ id = 828, chance = 5000 }, -- lightning headband
	{ id = 16096, chance = 5000 }, -- wand of defiance
	{ id = 10438, chance = 1000 }, -- spellweavers robe
	{ id = 7407, chance = 1000 }, -- haunted blade
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -680, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -505, radius = 3, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 1500, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -700, length = 8, spread = 0, effect = CONST_ME_STUN, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 82,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
