local mType = Game.createMonsterType("Elf Arcanist")
local monster = {}

monster.description = "an elf arcanist"
monster.experience = 175
monster.outfit = {
	lookType = 63,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 63
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Yalahar Foreigner Quarter, Demona, Shadowthorn, northwest of Ab'Dendriel, Maze of Lost Souls, \z
		Cyclopolis, Elvenbane, near Mount Sternum.",
}

monster.health = 220
monster.maxHealth = 220
monster.race = "blood"
monster.corpse = 6011
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I'll bring balance upon you!", yell = false },
	{ text = "Vihil Ealuel!", yell = false },
	{ text = "For the Daughter of the Stars!", yell = false },
	{ text = "Tha'shi Cenath!", yell = false },
	{ text = "Feel my wrath!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 47 }, -- gold coin
	{ id = 2815, chance = 80000 }, -- scroll
	{ id = 3593, chance = 80000 }, -- melon
	{ id = 3147, chance = 80000 }, -- blank rune
	{ id = 3600, chance = 80000 }, -- bread
	{ id = 9635, chance = 80000 }, -- elvish talisman
	{ id = 11465, chance = 80000 }, -- elven astral observer
	{ id = 3563, chance = 80000 }, -- green tunic
	{ id = 3447, chance = 80000, maxCount = 3 }, -- arrow
	{ id = 3738, chance = 5000 }, -- sling herb
	{ id = 266, chance = 5000 }, -- health potion
	{ id = 237, chance = 5000 }, -- strong mana potion
	{ id = 2917, chance = 5000 }, -- candlestick
	{ id = 5922, chance = 5000 }, -- holy orchid
	{ id = 3082, chance = 5000 }, -- elven amulet
	{ id = 3073, chance = 1000 }, -- wand of cosmic energy
	{ id = 28568, chance = 1000 }, -- inkwell
	{ id = 3551, chance = 1000 }, -- sandals
	{ id = 3061, chance = 1000 }, -- life crystal
	{ id = 3661, chance = 1000 }, -- grave flower
	{ id = 3037, chance = 260 }, -- yellow gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -35 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -70, range = 7, shootEffect = CONST_ANI_ARROW, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -30, maxDamage = -50, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -70, maxDamage = -85, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 0.51,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 40, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
