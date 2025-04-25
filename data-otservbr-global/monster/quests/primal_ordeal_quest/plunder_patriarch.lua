local mType = Game.createMonsterType("Plunder Patriarch")
local monster = {}

monster.description = "plunder patriarch"
monster.experience = 0
monster.outfit = {
	lookType = 1567,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 20000
monster.maxHealth = 20000
monster.race = "undead"
monster.corpse = 39538
monster.speed = 40
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 5000,
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
	{ name = "primal bag", chance = 100000, unique = true },
	{ name = "crystal coin", chance = 100000, maxCount = 60 },
	{ name = "ultimate mana potion", chance = 32653, maxCount = 14 },
	{ name = "ultimate health potion", chance = 30612, maxCount = 14 },
	{ name = "bullseye potion", chance = 24490, maxCount = 5 },
	{ name = "berserk potion", chance = 22449, maxCount = 5 },
	{ name = "mastermind potion", chance = 18367, maxCount = 5 },
	{ name = "royal almandine", chance = 8322 },
	{ name = "raw watermelon tourmaline", chance = 7322 },
	{ name = "giant amethyst", chance = 6122 },
	{ name = "giant ruby", chance = 4082 },
	{ name = "giant emerald", chance = 4082 },
	{ name = "giant sapphire", chance = 2041 },
	{ name = "giant topaz", chance = 2041 },
	{ name = "amber with a bug", chance = 2450 },
	{ name = "amber with a dragonfly", chance = 2150 },
	{ name = "arboreal tome", chance = 100 },
	{ name = "arboreal crown", chance = 100 },
	{ name = "spiritthorn armor", id = 39147, chance = 100 },
	{ name = "spiritthorn helmet", id = 39148, chance = 100 },
	{ name = "alicorn headguard", chance = 100 },
	{ name = "alicorn quiver", chance = 100 },
	{ name = "arcanomancer regalia", chance = 100 },
	{ name = "arcanomancer folio", chance = 100 },
	{ id = 39183, chance = 100 }, -- name = "charged arcanomancer sigil"
	{ id = 39186, chance = 100 }, -- name = "charged arboreal ring"
	{ id = 39180, chance = 100 }, -- name = "charged alicorn ring"
	{ id = 39177, chance = 100 }, -- name = "charged spiritthorn ring"
}

monster.attacks = {
	{ name = "melee", interval = 200, chance = 20, minDamage = 0, maxDamage = -950 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -600, maxDamage = -1000, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -700, length = 5, spread = 2, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 0,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
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
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
