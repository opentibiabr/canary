local mType = Game.createMonsterType("Minotaur Cult Zealot")
local monster = {}

monster.description = "a minotaur cult zealot"
monster.experience = 1350
monster.outfit = {
	lookType = 29,
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

monster.raceId = 1510
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

monster.health = 1800
monster.maxHealth = 1800
monster.race = "blood"
monster.corpse = 5983
monster.speed = 125
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
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 150 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 3 }, -- platinum coin
	{ id = 11473, chance = 23000 }, -- purple robe
	{ id = 3066, chance = 23000 }, -- snakebite rod
	{ id = 237, chance = 23000, maxCount = 3 }, -- strong mana potion
	{ id = 9639, chance = 23000 }, -- cultish robe
	{ id = 7425, chance = 23000 }, -- taurus mace
	{ id = 5878, chance = 5000 }, -- minotaur leather
	{ id = 3033, chance = 5000, maxCount = 2 }, -- small amethyst
	{ id = 3032, chance = 5000, maxCount = 2 }, -- small emerald
	{ id = 3028, chance = 5000, maxCount = 2 }, -- small diamond
	{ id = 3029, chance = 5000, maxCount = 2 }, -- small sapphire
	{ id = 11472, chance = 5000, maxCount = 2 }, -- minotaur horn
	{ id = 5911, chance = 5000 }, -- red piece of cloth
	{ id = 9057, chance = 5000, maxCount = 2 }, -- small topaz
	{ id = 3030, chance = 5000, maxCount = 2 }, -- small ruby
	{ id = 3037, chance = 1000 }, -- yellow gem
	{ id = 36706, chance = 1000 }, -- red gem
	{ id = 7401, chance = 260 }, -- minotaur trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -340 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -90, maxDamage = -320, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 35,
	mitigation = 1.37,
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
