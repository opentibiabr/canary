local mType = Game.createMonsterType("Juggernaut")
local monster = {}

monster.description = "a juggernaut"
monster.experience = 11200
monster.outfit = {
	lookType = 244,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 296
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Deep in Pits of Inferno (Apocalypse's throne room), The Dark Path, The Blood Halls, \z
	The Vats, The Hive, The Shadow Nexus, a room deep in Formorgar Mines, Roshamuul Prison, \z
	Oramond Dungeon, Grounds of Destruction and Halls of Ascension.",
}

monster.health = 18000
monster.maxHealth = 18000
monster.race = "blood"
monster.corpse = 6335
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
	staticAttackChance = 60,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "RAAARRR!", yell = true },
	{ text = "GRRRRRR!", yell = true },
	{ text = "WAHHHH!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 194 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 15 }, -- platinum coin
	{ id = 3582, chance = 80000, maxCount = 8 }, -- ham
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 5944, chance = 23000 }, -- soul orb
	{ id = 238, chance = 23000, maxCount = 3 }, -- great mana potion
	{ id = 239, chance = 23000, maxCount = 3 }, -- great health potion
	{ id = 7365, chance = 23000, maxCount = 15 }, -- onyx arrow
	{ id = 7368, chance = 23000, maxCount = 10 }, -- assassin star
	{ id = 6558, chance = 23000, maxCount = 4 }, -- flask of demonic blood
	{ id = 9057, chance = 23000, maxCount = 5 }, -- small topaz
	{ id = 3030, chance = 23000, maxCount = 5 }, -- small ruby
	{ id = 3033, chance = 23000, maxCount = 5 }, -- small amethyst
	{ id = 3032, chance = 23000, maxCount = 5 }, -- small emerald
	{ id = 3028, chance = 23000, maxCount = 5 }, -- small diamond
	{ id = 36706, chance = 23000 }, -- red gem
	{ id = 9058, chance = 23000, maxCount = 2 }, -- gold ingot
	{ id = 7452, chance = 5000 }, -- spiked squelcher
	{ id = 7413, chance = 5000 }, -- titan axe
	{ id = 3370, chance = 5000 }, -- knight armor
	{ id = 3038, chance = 5000 }, -- green gem
	{ id = 3342, chance = 5000 }, -- war axe
	{ id = 3036, chance = 1000 }, -- violet gem
	{ id = 3360, chance = 1000 }, -- golden armor
	{ id = 3414, chance = 260 }, -- mastermind shield
	{ id = 3019, chance = 260 }, -- demonbone amulet
	{ id = 31925, chance = 260 }, -- closed trap
	{ id = 3340, chance = 260 }, -- heavy mace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1470 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -780, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 70,
	mitigation = 1.74,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 520, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
