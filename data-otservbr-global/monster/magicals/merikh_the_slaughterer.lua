local mType = Game.createMonsterType("Merikh the Slaughterer")
local monster = {}

monster.description = "Merikh the Slaughterer"
monster.experience = 1500
monster.outfit = {
	lookType = 103,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 2000
monster.maxHealth = 2000
monster.race = "blood"
monster.corpse = 6032
monster.speed = 90
monster.manaCost = 0

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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "green djinn", chance = 10, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Your death will be slow and painful.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 120 }, -- gold coin
	{ id = 5910, chance = 80000, maxCount = 4 }, -- green piece of cloth
	{ id = 7378, chance = 80000, maxCount = 3 }, -- royal spear
	{ id = 647, chance = 80000 }, -- seeds
	{ id = 3330, chance = 80000 }, -- heavy machete
	{ id = 2933, chance = 80000 }, -- small oil lamp
	{ id = 237, chance = 80000, maxCount = 3 }, -- strong mana potion
	{ id = 3584, chance = 80000, maxCount = 8 }, -- pear
	{ id = 10310, chance = 80000 }, -- shiny stone
	{ id = 3574, chance = 80000 }, -- mystic turban
	{ id = 11470, chance = 80000 }, -- jewelled belt
	{ id = 11486, chance = 80000 }, -- noble turban
	{ id = 3032, chance = 80000, maxCount = 2 }, -- small emerald
	{ id = 827, chance = 80000 }, -- magma monocle
	{ id = 3038, chance = 80000 }, -- green gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -304 },
	--fireball
	--heavy magic missile
	--sudden death
	--energy berserk
	--electrifies
}

monster.defenses = {
	defense = 0,
	armor = 0,
	mitigation = 1.29,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 1 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = -1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 1 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
