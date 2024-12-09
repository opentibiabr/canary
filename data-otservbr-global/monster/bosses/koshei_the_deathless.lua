local mType = Game.createMonsterType("Koshei the Deathless")
local monster = {}

monster.description = "Koshei the Deathless"
monster.experience = 0
monster.outfit = {
	lookType = 99,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "undead"
monster.corpse = 7538
monster.speed = 195
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
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "bonebeast", chance = 21, interval = 1000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Your pain will be beyond imagination!", yell = false },
	{ text = "You can't defeat me! I will resurrect and take your soul!", yell = false },
	{ text = "Death is my ally!", yell = false },
	{ text = "Welcome to my domain visitor!", yell = false },
	{ text = "You will be my toy on the other side!", yell = false },
	{ text = "What a disgusting smell of life!", yell = false },
	{ text = "You will endure agony beyond thy death!", yell = false },
	{ text = "Ahhh, your life energy tastes so delicious!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -170, condition = { type = CONDITION_POISON, totalDamage = 300, interval = 4000 } },
	{ name = "combat", interval = 3000, chance = 9, type = COMBAT_LIFEDRAIN, minDamage = -60, maxDamage = -250, range = 1, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 1000, chance = 11, type = COMBAT_LIFEDRAIN, minDamage = -70, maxDamage = -135, radius = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 9, type = COMBAT_DEATHDAMAGE, minDamage = -50, maxDamage = -140, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	-- curse
	{ name = "condition", type = CONDITION_CURSED, interval = 3000, chance = 15, minDamage = -54, maxDamage = -54, range = 1, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -900, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 30000 },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 30, type = COMBAT_HEALING, minDamage = 150, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 90 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
