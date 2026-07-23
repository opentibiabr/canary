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
	{ id = 3035, chance = 100000, maxCount = 10 }, -- Platinum Coin
	{ id = 50056, chance = 77000 }, -- Brinebrute Claw
	{ id = 7642, chance = 75000, maxCount = 5 }, -- Great Spirit Potion
	{ id = 16122, chance = 20000 }, -- Green Crystal Splinter
	{ id = 3043, chance = 17900 }, -- Crystal Coin
	{ id = 16119, chance = 17700, maxCount = 2 }, -- Blue Crystal Shard
	{ id = 16123, chance = 17000 }, -- Brown Crystal Splinter
	{ id = 16124, chance = 16500 }, -- Blue Crystal Splinter
	{ id = 16120, chance = 14500, maxCount = 2 }, -- Violet Crystal Shard
	{ id = 16121, chance = 13500, maxCount = 2 }, -- Green Crystal Shard
	{ id = 3039, chance = 7400 }, -- Red Gem
	{ id = 3029, chance = 6900, maxCount = 4 }, -- Small Sapphire
	{ id = 7643, chance = 5700, maxCount = 3 }, -- Ultimate Health Potion
	{ id = 49909, chance = 2900 }, -- Demonic Core Essence
	{ id = 3048, chance = 2900 }, -- Might Ring
	{ id = 3281, chance = 2100 }, -- Giant Sword
	{ id = 50101, chance = 2100 }, -- Bloodstained Scythe
	{ id = 3038, chance = 1700 }, -- Green Gem
	{ id = 3098, chance = 1700 }, -- Ring of Healing
	{ id = 3081, chance = 1400 }, -- Stone Skin Amulet
	{ id = 49894, chance = 1200 }, -- Demonic Matter
	{ id = 3063, chance = 650 }, -- Gold Ring
	{ id = 3391, chance = 650 }, -- Crusader Helmet
	{ id = 49908, chance = 520 }, -- Mummified Demon Finger
	{ id = 3420, chance = 260 }, -- Demon Shield
	{ id = 7382, chance = 180 }, -- Demonrage Sword
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
