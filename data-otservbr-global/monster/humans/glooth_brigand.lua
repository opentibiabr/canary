local mType = Game.createMonsterType("Glooth Brigand")
local monster = {}

monster.description = "a glooth brigand"
monster.experience = 1900
monster.outfit = {
	lookType = 137,
	lookHead = 114,
	lookBody = 114,
	lookLegs = 110,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1120
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Underground Glooth Factory.",
}

monster.health = 2400
monster.maxHealth = 2400
monster.race = "blood"
monster.corpse = 21888
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 5,
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
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
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
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 3 }, -- platinum coin
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 21146, chance = 80000 }, -- glooth steak
	{ id = 21816, chance = 80000 }, -- tainted glooth capsule
	{ id = 21814, chance = 80000 }, -- glooth capsule
	{ id = 21203, chance = 80000, maxCount = 2 }, -- glooth bag
	{ id = 21179, chance = 80000 }, -- glooth blade
	{ id = 21165, chance = 80000 }, -- rubber cap
	{ id = 813, chance = 80000 }, -- terra boots
	{ id = 21143, chance = 80000 }, -- glooth sandwich
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 830, chance = 80000 }, -- terra hood
	{ id = 811, chance = 80000 }, -- terra mantle
	{ id = 814, chance = 80000 }, -- terra amulet
	{ id = 7386, chance = 80000 }, -- mercenary sword
	{ id = 812, chance = 80000 }, -- terra legs
	{ id = 21183, chance = 80000 }, -- glooth amulet
	{ id = 21180, chance = 80000 }, -- glooth axe
	{ id = 21178, chance = 80000 }, -- glooth club
	{ id = 21158, chance = 80000 }, -- glooth spear
	{ id = 21167, chance = 80000 }, -- heat core
	{ id = 7412, chance = 80000 }, -- butchers axe
	{ id = 7419, chance = 80000 }, -- dreaded cleaver
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 80, attack = 68 },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = -40, maxDamage = -200, range = 8, shootEffect = CONST_ANI_ARROW, target = false },
}

monster.defenses = {
	defense = 26,
	armor = 51,
	mitigation = 1.74,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 200, maxDamage = 245, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
