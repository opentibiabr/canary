local mType = Game.createMonsterType("Glooth Fairy")
local monster = {}

monster.description = "a glooth fairy"
monster.experience = 19000
monster.outfit = {
	lookType = 600,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 59000
monster.maxHealth = 59000
monster.race = "blood"
monster.corpse = 20992
monster.speed = 300
monster.manaCost = 490

monster.changeTarget = {
	interval = 4000,
	chance = 80
}

monster.bosstiary = {
	bossRaceId = 1058,
	bossRace = RARITY_BANE
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
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 199}, -- gold coin
	{id = 3035, chance = 37170, maxCount = 14}, -- platinum coin
	{id = 21103, chance = 14630}, -- glooth injection tube
	{id = 238, chance = 11270}, -- great mana potion
	{id = 21143, chance = 10550}, -- glooth sandwich
	{id = 9057, chance = 4320, maxCount = 2}, -- small topaz
	{id = 3032, chance = 3600, maxCount = 2}, -- small emerald
	{id = 21183, chance = 2400}, -- glooth amulet
	{id = 8775, chance = 1920}, -- gear wheel
	{id = 21180, chance = 1200}, -- glooth axe
	{id = 21158, chance = 1200}, -- glooth spear
	{id = 21167, chance = 1200}, -- heat core
	{id = 3037, chance = 960}, -- yellow gem
	{id = 21179, chance = 720}, -- glooth blade
	{id = 21178, chance = 480}, -- glooth club
	{id = 21165, chance = 480}, -- rubber cap
	{id = 3039, chance = 980}, -- red gem
	{id = 21292, chance = 480}, -- feedbag
	{id = 5880, chance = 980}, -- iron ore
	{id = 21144, chance = 280} -- bowl of glooth soup
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 210, attack = 260},
	-- fire
	{name ="condition", type = CONDITION_FIRE, interval = 1000, chance = 7, minDamage = -200, maxDamage = -1000, range = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_BLOCKHIT, target = false},
	{name ="combat", interval = 1000, chance = 7, type = COMBAT_PHYSICALDAMAGE, minDamage = -50, maxDamage = -150, radius = 6, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 1000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -20, maxDamage = -100, radius = 5, effect = CONST_ME_BLOCKHIT, target = false},
	{name ="firefield", interval = 1000, chance = 4, radius = 8, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -150, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 1000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -100, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 1000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -30, maxDamage = -100, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false}
}

monster.defenses = {
	defense = 150,
	armor = 165,
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 500, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 200, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 1000, chance = 10, speedChange = 1800, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 25},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
