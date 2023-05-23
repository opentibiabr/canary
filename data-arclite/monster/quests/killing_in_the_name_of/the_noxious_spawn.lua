local mType = Game.createMonsterType("The Noxious Spawn")
local monster = {}

monster.description = "The Noxious Spawn"
monster.experience = 6000
monster.outfit = {
	lookType = 220,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 9500
monster.maxHealth = 9500
monster.race = "venom"
monster.corpse = 4388
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	runHealth = 275,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I bring you deathhhh, mortalssss", yell = false}
}

monster.loot = {
	{id = 9694, chance = 100000}, -- snake skin
	{id = 10313, chance = 100000}, -- winged tail
	{id = 3035, chance = 80000, maxCount = 5}, -- platinum coin
	{id = 238, chance = 72000, maxCount = 4}, -- great mana potion
	{id = 3032, chance = 68000, maxCount = 5}, -- small emerald
	{id = 7386, chance = 45000}, -- mercenary sword
	{id = 3428, chance = 43000}, -- tower shield
	{id = 7456, chance = 39000}, -- noble axe
	{id = 2903, chance = 35000}, -- golden mug
	{id = 3381, chance = 29000}, -- crown armor
	{id = 7368, chance = 27000, maxCount = 78}, -- assassin star
	{id = 3732, chance = 19000}, -- green mushroom
	{id = 3052, chance = 13000}, -- life ring
	{id = 8074, chance = 13000}, -- spellbook of mind control
	{id = 3392, chance = 4000}, -- royal helmet
	{id = 8052, chance = 2000} -- swamplair armor
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250},
	{name ="speed", interval = 4000, chance = 20, speedChange = -370, range = 7, shootEffect = CONST_ANI_POISON, target = true, duration = 12000},
	{name ="combat", interval = 2000, chance = 7, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -550, length = 8, spread = 3, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -550, length = 8, spread = 3, effect = CONST_ME_SOUND_RED, target = false},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -300, range = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false},
	{name ="outfit", interval = 2000, chance = 11, range = 7, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 4000, outfitItem = 3976}
}

monster.defenses = {
	defense = 25,
	armor = 18,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 900, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
