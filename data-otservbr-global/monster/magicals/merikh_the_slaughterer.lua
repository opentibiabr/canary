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
	{ id = 5910, chance = 100000, maxCount = 4 }, -- Green Piece of Cloth
	{ id = 11470, chance = 100000 }, -- Jewelled Belt
	{ id = 3031, chance = 97000, maxCount = 121 }, -- Gold Coin
	{ id = 11486, chance = 64000 }, -- Noble Turban
	{ id = 10310, chance = 58000 }, -- Shiny Stone
	{ id = 7378, chance = 56000, maxCount = 3 }, -- Royal Spear
	{ id = 3330, chance = 42000 }, -- Heavy Machete
	{ id = 237, chance = 42000, maxCount = 3 }, -- Strong Mana Potion
	{ id = 3574, chance = 36000 }, -- Mystic Turban
	{ id = 827, chance = 8300 }, -- Magma Monocle
	{ id = 3038, chance = 2800 }, -- Green Gem
	{ id = 3032, chance = 2800, maxCount = 2 }, -- Small Emerald
	{ id = 647, chance = 16670 }, -- Seeds
	{ id = 2933, chance = 16670 }, -- Small Oil Lamp
	{ id = 3584, chance = 100000, maxCount = 8 }, -- Pear
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
