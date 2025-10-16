local mType = Game.createMonsterType("Minotaur Cult Follower")
local monster = {}

monster.description = "a minotaur cult follower"
monster.experience = 950
monster.outfit = {
	lookType = 25,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"MinotaurCultTaskDeath",
}

monster.raceId = 1508
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Minotaurs Cult Cave",
}

monster.health = 1600
monster.maxHealth = 1600
monster.race = "blood"
monster.corpse = 5969
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
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
	{ text = "We will rule!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 155 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 3 }, -- platinum coin
	{ id = 3582, chance = 80000 }, -- ham
	{ id = 21204, chance = 23000 }, -- cowbell
	{ id = 3410, chance = 23000 }, -- plate shield
	{ id = 9639, chance = 23000 }, -- cultish robe
	{ id = 3056, chance = 23000 }, -- bronze amulet
	{ id = 11472, chance = 23000, maxCount = 2 }, -- minotaur horn
	{ id = 21175, chance = 23000 }, -- mino shield
	{ id = 239, chance = 23000 }, -- great health potion
	{ id = 5878, chance = 23000 }, -- minotaur leather
	{ id = 3577, chance = 23000 }, -- meat
	{ id = 3098, chance = 5000 }, -- ring of healing
	{ id = 3030, chance = 5000, maxCount = 2 }, -- small ruby
	{ id = 3032, chance = 5000, maxCount = 2 }, -- small emerald
	{ id = 3033, chance = 5000, maxCount = 2 }, -- small amethyst
	{ id = 9057, chance = 5000, maxCount = 2 }, -- small topaz
	{ id = 21174, chance = 5000 }, -- mino lance
	{ id = 9058, chance = 1000 }, -- gold ingot
	{ id = 5911, chance = 1000 }, -- red piece of cloth
	{ id = 3369, chance = 1000 }, -- warrior helmet
	{ id = 3037, chance = 260 }, -- yellow gem
	{ id = 7401, chance = 260 }, -- minotaur trophy
	{ id = 36706, chance = 260 }, -- red gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -110, maxDamage = -210, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 32,
	mitigation = 1.24,
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
