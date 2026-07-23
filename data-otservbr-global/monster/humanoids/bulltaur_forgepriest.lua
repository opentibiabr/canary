local mType = Game.createMonsterType("Bulltaur Forgepriest")
local monster = {}

monster.description = "a Bulltaur Forgepriest"
monster.experience = 6400
monster.outfit = {
	lookType = 1719,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 6840
monster.maxHealth = 6840
monster.race = "blood"
monster.corpse = 44717
monster.speed = 73
monster.manaCost = 0

monster.raceId = 2449
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Bulltaurs Lair",
}

monster.changeTarget = {
	interval = 2000,
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
	{ text = "What a chance to try out my latest work!", yell = false },
	{ text = "May the forge be with me!", yell = false },
	{ text = "The forge-fire will cleanse you!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 54000, maxCount = 45 }, -- Platinum Coin
	{ id = 44736, chance = 16700 }, -- Bulltaur Horn
	{ id = 9057, chance = 9900, maxCount = 3 }, -- Small Topaz
	{ id = 44741, chance = 8000 }, -- Staff Piece
	{ id = 44742, chance = 3600 }, -- Idol of the Forge
	{ id = 9058, chance = 2500 }, -- Gold Ingot
	{ id = 5944, chance = 1500 }, -- Soul Orb
	{ id = 16096, chance = 1400 }, -- Wand of Defiance
	{ id = 3041, chance = 960 }, -- Blue Gem
	{ id = 825, chance = 960 }, -- Lightning Robe
	{ id = 8074, chance = 730 }, -- Spellbook of Mind Control
	{ id = 3040, chance = 650 }, -- Gold Nugget
	{ id = 32769, chance = 500 }, -- White Gem
	{ id = 3081, chance = 500 }, -- Stone Skin Amulet
	{ id = 3036, chance = 380 }, -- Violet Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -270, maxDamage = -300 },
	{ name = "bulltaurewave", interval = 2000, chance = 20, minDamage = -350, maxDamage = -500 },
	{ name = "bulltaur explosion", interval = 2000, chance = 20, minDamage = -550, maxDamage = -650 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -280, maxDamage = -380, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_PURPLESMOKE, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -420, shootEffect = CONST_ANI_ENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -450, range = 4, radius = 3, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_SOUND_RED, target = true },
}

monster.defenses = {
	defense = 73,
	armor = 73,
	mitigation = 2.05,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
