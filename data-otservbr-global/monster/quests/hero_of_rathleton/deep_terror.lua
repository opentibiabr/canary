local mType = Game.createMonsterType("Deep Terror")
local monster = {}

monster.description = "Deep Terror"
monster.experience = 35000
monster.outfit = {
	lookType = 676,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"RathletonBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1087,
	bossRace = RARITY_BANE,
}

monster.health = 100000
monster.maxHealth = 100000
monster.race = "blood"
monster.corpse = 21900
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
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
}

monster.loot = {
	{ id = 21899, chance = 10000, unique = true }, -- glooth glider tubes and wires
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 130, attack = 100 },
	{ name = "combat", interval = 2000, chance = 32, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -400, radius = 8, effect = CONST_ME_CARNIPHILA, target = false },
	{ name = "combat", interval = 2000, chance = 19, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -700, range = 7, radius = 3, shootEffect = CONST_ANI_POISON, effect = CONST_ME_CARNIPHILA, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -1000, length = 7, spread = 0, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 22,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 11, type = COMBAT_HEALING, minDamage = 500, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
