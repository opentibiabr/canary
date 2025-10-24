local mType = Game.createMonsterType("Tentacle of the Deep Terror")
local monster = {}

monster.description = "a tentacle of the Deep Terror"
monster.experience = 0
monster.outfit = {
	lookType = 681,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 25500
monster.maxHealth = 25500
monster.race = "venom"
monster.corpse = 0
monster.speed = 175
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 800,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.events = {
	"TentacleDeep",
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
	{ id = 3035, chance = 100000 }, -- Platinum Coin
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 88, attack = 100 },
	{ name = "blightwalker curse", interval = 2000, chance = 10, target = false },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_LIFEDRAIN, minDamage = -65, maxDamage = -135, radius = 4, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "drunk", interval = 2000, chance = 20, radius = 7, effect = CONST_ME_HITBYPOISON, target = false, duration = 35000 },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 225, maxDamage = 850, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
