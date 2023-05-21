local mType = Game.createMonsterType("Glooth Anemone")
local monster = {}

monster.description = "a glooth anemone"
monster.experience = 1755
monster.outfit = {
	lookType = 604,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1042
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Rathleton Sewers, Underground Glooth Factory, Jaccus Maxxen's Dungeon."
	}

monster.health = 2400
monster.maxHealth = 2400
monster.race = "venom"
monster.corpse = 20988
monster.speed = 90
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 3
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
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "*shglib*", yell = false}
}

monster.loot = {
	{id = 21144, chance = 3190}, -- bowl of glooth soup
	{id = 21197, chance = 2020}, -- slimy leaf tentacle
	{id = 3732, chance = 3180}, -- green mushroom
	{id = 21183, chance = 320}, -- glooth amulet
	{id = 3031, chance = 100000, maxCount = 170}, -- gold coin
	{id = 236, chance = 6690, maxCount = 2}, -- strong health potion
	{id = 237, chance = 6690, maxCount = 2}, -- strong mana potion
	{id = 7643, chance = 960}, -- ultimate health potion
	{id = 3035, chance = 57320, maxCount = 3}, -- platinum coin
	{id = 9057, chance = 1240, maxCount = 3}, -- small topaz
	{id = 3032, chance = 1600, maxCount = 3}, -- small emerald
	{id = 3030, chance = 1150, maxCount = 3}, -- small ruby
	{id = 21164, chance = 140}, -- glooth cape
	{id = 21172, chance = 700}, -- glooth whip
	{id = 21179, chance = 120}, -- glooth blade
	{id = 21178, chance = 370}, -- glooth club
	{id = 21180, chance = 240}, -- glooth axe
	{id = 21158, chance = 370} -- glooth spear
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 60, attack = 50},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -200, range = 7, radius = 4, shootEffect = CONST_ANI_GLOOTHSPEAR, effect = CONST_ME_HITBYPOISON, target = true},
	{name ="combat", interval = 2000, chance = 7, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -100, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_MAGIC_RED, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, radius = 5, effect = CONST_ME_MAGIC_RED, target = false}
}

monster.defenses = {
	defense = 25,
	armor = 15,
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="glooth anemone summon", interval = 2000, chance = 14, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 35}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
