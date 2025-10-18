local mType = Game.createMonsterType("Control Tower")
local monster = {}

monster.description = "a control tower"
monster.experience = 3000
monster.outfit = {
	lookTypeEx = 20894,
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "venom"
monster.corpse = 21940
monster.speed = 0
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 73540, maxCount = 5 }, -- Platinum Coin
	{ id = 21168, chance = 530 }, -- Alloy Legs
	{ id = 9016, chance = 2650 }, -- Flask of Rust Remover
	{ id = 21170, chance = 4760 }, -- Gearwheel Chain
	{ id = 3554, chance = 1060 }, -- Steel Boots
	{ id = 21167, chance = 2120 }, -- Heat Core
	{ id = 9654, chance = 3170 }, -- War Crystal
	{ id = 238, chance = 10050 }, -- Great Mana Potion
	{ id = 239, chance = 11110 }, -- Great Health Potion
	{ id = 8775, chance = 2650 }, -- Gear Wheel
	{ id = 5880, chance = 1060 }, -- Iron Ore
	{ id = 7440, chance = 1060 }, -- Mastermind Potion
	{ id = 9063, chance = 1589 }, -- Crystal Pedestal (Red)
	{ id = 21169, chance = 2120 }, -- Metal Spats
	{ id = 21171, chance = 1589 }, -- Metal Bat
	{ id = 7428, chance = 530 }, -- Bonebreaker
}

monster.defenses = {
	defense = 10,
	armor = 10,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 55 },
	{ type = COMBAT_EARTHDAMAGE, percent = 55 },
	{ type = COMBAT_FIREDAMAGE, percent = 55 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 55 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
