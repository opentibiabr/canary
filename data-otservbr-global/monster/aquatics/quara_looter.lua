local mType = Game.createMonsterType("Quara Looter")
local monster = {}

monster.description = "a quara looter"
monster.experience = 8650
monster.outfit = {
	lookType = 1741,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2543
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Podzilla Bottom, Podzilla Underwater",
}

monster.health = 11500
monster.maxHealth = 11500
monster.race = "undead"
monster.corpse = 48277
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 11,
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
	targetDistance = 3,
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
	{ text = "Krrrck!", yell = false },
	{ text = "Tchky!", yell = false },
	{ text = "<splatter>", yell = false },
}

monster.loot = {
	{ id = 48508, chance = 23000 }, -- amber souvenir
	{ id = 48509, chance = 23000 }, -- resinous fish fin
	{ id = 824, chance = 1000 }, -- glacier robe
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 823, chance = 1000 }, -- glacier kilt
	{ id = 11489, chance = 1000 }, -- mantassin tail
	{ id = 13990, chance = 1000 }, -- necklace of the deep
	{ id = 16163, chance = 260 }, -- crystal crossbow
	{ id = 22727, chance = 260 }, -- rift lance
	{ id = 45654, chance = 260 }, -- preserved light blue seed
	{ id = 45655, chance = 260 }, -- preserved violet seed
	{ id = 45656, chance = 260 }, -- preserved purple seed
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_ICEDAMAGE, minDamage = -400, maxDamage = -750, range = 7, shootEffect = CONST_ANI_SHIVERARROW, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "quarasmallicering", interval = 2000, chance = 16 },
	{ name = "podzillaphyschain", interval = 2000, chance = 15 },
}

monster.defenses = {
	defense = 95,
	armor = 95,
	mitigation = 2.75,
	{ name = "combat", interval = 2000, chance = 7, type = COMBAT_HEALING, minDamage = 600, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
