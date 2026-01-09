local mType = Game.createMonsterType("Gorger Inferniarch")
local monster = {}

monster.description = "a gorger inferniarch"
monster.experience = 7180
monster.outfit = {
	lookType = 1797,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2604
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Azzilon Castle.",
}

monster.health = 9450
monster.maxHealth = 9450
monster.race = "fire"
monster.corpse = 50010
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
	{ text = "Kar Ath... Ul", yell = true },
	{ text = "Rezzz Kor ... Urrrgh!", yell = true },
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 24 }, -- Platinum Coin
	{ id = 3029, chance = 3880, maxCount = 3 }, -- Small Sapphire
	{ id = 3093, chance = 2540 }, -- Club Ring
	{ id = 7452, chance = 3460 }, -- Spiked Squelcher
	{ id = 49909, chance = 2700 }, -- Demonic Core Essence
	{ id = 50059, chance = 1670 }, -- Gorger Antlers
	{ id = 3053, chance = 350 }, -- Time Ring
	{ id = 49894, chance = 459 }, -- Demonic Matter
	{ id = 49908, chance = 950 }, -- Mummified Demon Finger
	{ id = 3040, chance = 390 }, -- Gold Nugget
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -199, maxDamage = -503 },
	{ name = "extended fire chain", interval = 3000, chance = 15, minDamage = -1, maxDamage = -400, range = 7 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -1, maxDamage = -500, effect = CONST_ME_REAPER, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -1, maxDamage = -500, radius = 6, effect = CONST_ME_BLACKSMOKE, target = false }, -- death ball
}

monster.defenses = {
	defense = 15,
	armor = 74,
	mitigation = 1.99,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
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
