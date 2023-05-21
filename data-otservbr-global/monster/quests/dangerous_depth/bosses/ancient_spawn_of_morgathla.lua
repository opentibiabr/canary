local mType = Game.createMonsterType("Ancient Spawn of Morgathla")
local monster = {}

monster.description = "an ancient spawn of morgathla"
monster.experience = 2400
monster.outfit = {
	lookType = 1055,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "blood"
monster.corpse = 21004
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4
}

monster.bosstiary = {
	bossRaceId = 1551, -- or 1554 need test
	bossRace = RARITY_ARCHFOE
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
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I'm the one who puts the cute into execute!", yell = false},
	{text = "I'm here to punish!", yell = false},
	{text = "Justice is swift and unavoidable!", yell = false},
	{text = "I'll bring justice!", yell = false},
	{text = "There is excellence in execution!", yell = false},
	{text = "Your sentence is death!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 198}, -- gold coin
	{id = 3035, chance = 67610, maxCount = 3}, -- platinum coin
	{id = 9058, chance = 390}, -- gold ingot
	{id = 5911, chance = 3230}, -- red piece of cloth
	{id = 5878, chance = 14710}, -- minotaur leather
	{id = 11472, chance = 6580, maxCount = 2}, -- minotaur horn
	{id = 21201, chance = 13160}, -- execowtioner mask
	{id = 239, chance = 11480}, -- great health potion
	{id = 238, chance = 10060}, -- great mana potion
	{id = 3577, chance = 7230}, -- meat
	{id = 9057, chance = 5810, maxCount = 2}, -- small topaz
	{id = 3030, chance = 4520, maxCount = 2}, -- small ruby
	{id = 7412, chance = 900}, -- butcher's axe
	{id = 3381, chance = 770}, -- crown armor
	{id = 21176, chance = 1420}, -- execowtioner axe
	{id = 3318, chance = 770}, -- knight axe
	{id = 7413, chance = 390}, -- titan axe
	{id = 7401, chance = 520} -- minotaur trophy
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 90, attack = 80},
	{name ="combat", interval = 2000, chance = 8, type = COMBAT_LIFEDRAIN, minDamage = -135, maxDamage = -280, range = 7, radius = 5, shootEffect = CONST_ANI_WHIRLWINDAXE, target = true},
	{name ="combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -90, maxDamage = -200, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONAREA, target = true}
}

monster.defenses = {
	defense = 40,
	armor = 40
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 1},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
