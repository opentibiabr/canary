local mType = Game.createMonsterType("Mega Dummy Roulette")
local monster = {}

monster.description = ""
monster.experience = 0
monster.outfit = {
	lookTypeEx = 1551,
}

monster.health = 100
monster.maxHealth = 100
monster.race = "undead"
monster.corpse = 0
monster.speed = 0
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
}

monster.flags = {
	summonable = false,
	attackable = false,
	hostile = false,
	convinceable = false,
	pushable = false,
	recompensaBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 20,
	healthHidden = true,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.immunities = {
	{ type = "physical", condition = true },
	{ type = "energy", condition = true },
	{ type = "fire", condition = true },
	{ type = "earth", condition = true },
	{ type = "ice", condition = true },
	{ type = "holy", condition = true },
	{ type = "death", condition = true },
	{ type = "paralyze", condition = true },
	{ type = "drunk", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
}

mType:register(monster)
