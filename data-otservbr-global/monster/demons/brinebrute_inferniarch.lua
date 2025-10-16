local mType = Game.createMonsterType("Brinebrute Inferniarch")
local monster = {}

monster.description = "a brinebrute inferniarch"
monster.experience = 20300
monster.outfit = {
	lookType = 1794,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2601
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Azzilon Castle Catacombs.",
}

monster.health = 32000
monster.maxHealth = 32000
monster.race = "fire"
monster.corpse = 49998
monster.speed = 160
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
	staticAttackChance = 80,
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Garrr...Garrr!", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 40 }, -- platinum coin
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 50056, chance = 80000 }, -- brinebrute claw
	{ id = 3029, chance = 23000, maxCount = 4 }, -- small sapphire
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 16119, chance = 23000, maxCount = 2 }, -- blue crystal shard
	{ id = 16120, chance = 23000, maxCount = 2 }, -- violet crystal shard
	{ id = 16121, chance = 23000, maxCount = 2 }, -- green crystal shard
	{ id = 16122, chance = 23000 }, -- green crystal splinter
	{ id = 16123, chance = 23000 }, -- brown crystal splinter
	{ id = 16124, chance = 23000 }, -- blue crystal splinter
	{ id = 3038, chance = 5000 }, -- green gem
	{ id = 3048, chance = 5000 }, -- might ring
	{ id = 3081, chance = 5000 }, -- stone skin amulet
	{ id = 3098, chance = 5000 }, -- ring of healing
	{ id = 3281, chance = 5000 }, -- giant sword
	{ id = 7643, chance = 5000, maxCount = 3 }, -- ultimate health potion
	{ id = 49894, chance = 5000 }, -- demonic matter
	{ id = 49909, chance = 5000 }, -- demonic core essence
	{ id = 50101, chance = 5000 }, -- bloodstained scythe
	{ id = 3063, chance = 1000 }, -- gold ring
	{ id = 49908, chance = 1000 }, -- mummified demon finger
	{ id = 3391, chance = 260 }, -- crusader helmet
	{ id = 3420, chance = 260 }, -- demon shield
	{ id = 7382, chance = 260 }, -- demonrage sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -520, maxDamage = -600 },
}

monster.defenses = {
	defense = 15,
	armor = 80,
	mitigation = 2.45,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
