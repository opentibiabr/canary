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
	{ name = "platinum coin", chance = 5000, maxCount = 24 },
	{ name = "spiked squelcher", chance = 1500 },
	{ id = 3053, chance = 800 }, -- time ring
	{ id = 3040, chance = 4761 }, -- gold nugget
	{ name = "small sapphire", chance = 1500, maxCount = 3 },
	{ name = "demonic core essence", chance = 100 },
	{ name = "demonic matter", chance = 4761 },
	{ id = 3093, chance = 1000 }, -- club ring
	{ name = "gorger antlers", chance = 1000 },
	{ name = "mummified demon finger", chance = 155 },
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
