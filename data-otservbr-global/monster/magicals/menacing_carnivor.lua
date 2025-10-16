local mType = Game.createMonsterType("Menacing Carnivor")
local monster = {}

monster.description = "a menacing carnivor"
monster.experience = 2112
monster.outfit = {
	lookType = 1138,
	lookHead = 86,
	lookBody = 51,
	lookLegs = 83,
	lookFeet = 91,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1723
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Carnivora's Rocks.",
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 30103
monster.speed = 170
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 5,
	color = 184,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 8 }, -- platinum coin
	{ id = 3282, chance = 23000 }, -- morning star
	{ id = 23373, chance = 23000 }, -- ultimate mana potion
	{ id = 29347, chance = 23000 }, -- violet glass plate
	{ id = 3030, chance = 5000 }, -- small ruby
	{ id = 3065, chance = 5000 }, -- terra rod
	{ id = 7449, chance = 5000 }, -- crystal sword
	{ id = 676, chance = 5000 }, -- small enchanted ruby
	{ id = 812, chance = 5000 }, -- terra legs
	{ id = 3297, chance = 5000 }, -- serpent sword
	{ id = 3308, chance = 5000 }, -- machete
	{ id = 3330, chance = 5000 }, -- heavy machete
	{ id = 3371, chance = 5000 }, -- knight legs
	{ id = 8092, chance = 5000 }, -- wand of starstorm
	{ id = 8094, chance = 5000 }, -- wand of voodoo
	{ id = 16127, chance = 5000 }, -- green crystal fragment
	{ id = 22193, chance = 5000 }, -- onyx chip
	{ id = 24961, chance = 5000 }, -- tiger eye
	{ id = 3353, chance = 1000 }, -- iron helmet
	{ id = 22194, chance = 1000 }, -- opal
	{ id = 3075, chance = 1000 }, -- wand of dragonbreath
	{ id = 3072, chance = 1000 }, -- wand of decay
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -180, length = 4, spread = 0, effect = CONST_ME_SMOKE, target = false },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -200, length = 4, spread = 0, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -150, maxDamage = -330, radius = 4, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 0,
	armor = 68,
	mitigation = 1.88,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.reflects = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
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
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
