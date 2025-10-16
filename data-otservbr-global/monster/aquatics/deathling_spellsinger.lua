local mType = Game.createMonsterType("Deathling Spellsinger")
local monster = {}

monster.description = "a deathling spellsinger"
monster.experience = 6400
monster.outfit = {
	lookType = 1088,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1677
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Ancient Ancestorial Grounds and Sunken Temple.",
}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "blood"
monster.corpse = 28851
monster.speed = 155
monster.manaCost = 0

monster.faction = FACTION_DEATHLING
monster.enemyFactions = { FACTION_PLAYER, FACTION_DEEPLING }

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
	canPushCreatures = true,
	staticAttackChance = 60,
	targetDistance = 1,
	runHealth = 20,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = 'BOQOL"°', yell = false },
	{ text = 'QOL" VBOXCL°', yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 14 }, -- platinum coin
	{ id = 15793, chance = 80000, maxCount = 25 }, -- crystalline arrow
	{ id = 3032, chance = 23000, maxCount = 14 }, -- small emerald
	{ id = 14085, chance = 23000 }, -- deepling filet
	{ id = 14013, chance = 23000 }, -- deeptags
	{ id = 14041, chance = 23000 }, -- deepling ridge
	{ id = 238, chance = 23000 }, -- great mana potion
	{ id = 14012, chance = 23000 }, -- deepling warts
	{ id = 239, chance = 23000 }, -- great health potion
	{ id = 14252, chance = 23000, maxCount = 25 }, -- vortex bolt
	{ id = 12730, chance = 23000 }, -- eye of a deepling
	{ id = 12683, chance = 5000 }, -- heavy trident
	{ id = 14040, chance = 5000 }, -- warriors axe
	{ id = 14042, chance = 5000 }, -- warriors shield
	{ id = 5895, chance = 5000 }, -- fish fin
	{ id = 3052, chance = 5000 }, -- life ring
	{ id = 675, chance = 5000 }, -- small enchanted sapphire
	{ id = 13990, chance = 260 }, -- necklace of the deep
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -400, range = 5, shootEffect = CONST_ANI_HUNTINGSPEAR, target = false },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -150, maxDamage = -300, range = 5, shootEffect = CONST_ANI_LARGEROCK, target = false },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -400, maxDamage = -700, length = 8, spread = 0, effect = CONST_ME_HOLYAREA, target = false },
}

monster.defenses = {
	defense = 72,
	armor = 72,
	mitigation = 1.88,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
