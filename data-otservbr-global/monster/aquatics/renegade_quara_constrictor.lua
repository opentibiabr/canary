local mType = Game.createMonsterType("Renegade Quara Constrictor")
local monster = {}

monster.description = "a renegade quara constrictor"
monster.experience = 1250
monster.outfit = {
	lookType = 46,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1097
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Seacrest Grounds when Seacrest Serpents are not spawning.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 6065
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 20,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ name = "platinum coin", chance = 79280, maxCount = 3 },
	{ name = "quara tentacle", chance = 15240 },
	{ name = "mind stone", chance = 6880 },
	{ id = 3098, chance = 5580 }, -- ring of healing
	{ name = "great mana potion", chance = 5390, maxCount = 5 },
	{ name = "shrimp", chance = 5300, maxCount = 4 },
	{ name = "small amethyst", chance = 5200, maxCount = 2 },
	{ name = "small ruby", chance = 4650, maxCount = 2 },
	{ name = "assassin star", chance = 4460, maxCount = 7 },
	{ name = "vortex bolt", chance = 3720, maxCount = 10 },
	{ name = "violet crystal shard", chance = 1210 },
	{ name = "northwind rod", chance = 740 },
	{ name = "fish fin", chance = 370 },
	{ name = "piggy bank", chance = 190 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 60, attack = 40, effect = CONST_ME_DRAWBLOOD },
	{ name = "quara constrictor freeze", interval = 2000, chance = 10, target = false },
	{ name = "quara constrictor electrify", interval = 2000, chance = 10, range = 1, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 35,
	mitigation = 1.04,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 150, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
