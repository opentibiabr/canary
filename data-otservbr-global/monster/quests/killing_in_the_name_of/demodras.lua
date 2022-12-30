local mType = Game.createMonsterType("Demodras")
local monster = {}

monster.description = "Demodras"
monster.experience = 6000
monster.outfit = {
	lookType = 204,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 5984
monster.speed = 197
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
	runHealth = 300,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{name = "Dragon", chance = 17, interval = 1000, count = 2}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I WILL SET THE WORLD ON FIRE!", yell = true},
	{text = "I WILL PROTECT MY BROOD!", yell = true}
}

monster.loot = {
	{id = 3035, chance = 99150, maxCount = 10}, -- platinum coin
	{id = 5919, chance = 100000}, -- dragon claw
	{id = 3732, chance = 25650, maxCount = 7}, -- green mushroom
	{id = 3029, chance = 12000}, -- small sapphire
	{id = 238, chance = 9500}, -- great mana potion
	{id = 7365, chance = 4250, maxCount = 5}, -- onyx arrow
	{id = 3061, chance = 850}, -- life crystal
	{id = 3450, chance = 19650, maxCount = 10}, -- power bolt
	{id = 3051, chance = 10250}, -- energy ring
	{id = 239, chance = 9500}, -- great health potion
	{id = 3386, chance = 1700}, -- dragon scale mail
	{id = 3583, chance = 75200, maxCount = 10}, -- dragon ham
	{id = 5948, chance = 13700}, -- red dragon leather
	{id = 2842, chance = 10250}, -- book (gemmed)
	{id = 2903, chance = 6000}, -- golden mug
	{id = 3280, chance = 1700} -- fire sword
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -160, maxDamage = -600},
	{name ="combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -350, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="firefield", interval = 1000, chance = 10, range = 7, radius = 6, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 4000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -550, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false}
}

monster.defenses = {
	defense = 25,
	armor = 45,
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 400, maxDamage = 700, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
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
