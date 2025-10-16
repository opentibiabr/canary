local mType = Game.createMonsterType("Glooth Fairy")
local monster = {}

monster.description = "Glooth Fairy"
monster.experience = 19000
monster.outfit = {
	lookType = 600,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1058,
	bossRace = RARITY_BANE,
}

monster.health = 59000
monster.maxHealth = 59000
monster.race = "blood"
monster.corpse = 20972
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 80,
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
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 239, chance = 80000, maxCount = 5 }, -- great health potion
	{ id = 238, chance = 80000, maxCount = 5 }, -- great mana potion
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 21103, chance = 80000, maxCount = 3 }, -- glooth injection tube
	{ id = 21144, chance = 80000, maxCount = 5 }, -- bowl of glooth soup
	{ id = 21143, chance = 80000, maxCount = 5 }, -- glooth sandwich
	{ id = 21146, chance = 80000, maxCount = 5 }, -- glooth steak
	{ id = 3033, chance = 80000, maxCount = 5 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 5 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 5 }, -- small emerald
	{ id = 3030, chance = 80000, maxCount = 5 }, -- small ruby
	{ id = 9057, chance = 80000, maxCount = 5 }, -- small topaz
	{ id = 3029, chance = 80000, maxCount = 5 }, -- small sapphire
	{ id = 5880, chance = 80000 }, -- iron ore
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 8775, chance = 80000 }, -- gear wheel
	{ id = 21180, chance = 80000 }, -- glooth axe
	{ id = 21178, chance = 80000 }, -- glooth club
	{ id = 21179, chance = 80000 }, -- glooth blade
	{ id = 21183, chance = 80000 }, -- glooth amulet
	{ id = 21158, chance = 80000 }, -- glooth spear
	{ id = 21164, chance = 80000 }, -- glooth cape
	{ id = 21165, chance = 80000 }, -- rubber cap
	{ id = 21167, chance = 80000 }, -- heat core
	{ id = 21292, chance = 80000 }, -- feedbag
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1900 },
	{ name = "combat", interval = 1000, chance = 7, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -4000, radius = 6, effect = CONST_ME_ENERGYHIT, target = false }, -- blue energy ultimate explosion
	{ name = "war golem skill reducer", interval = 2000, chance = 10, target = false }, -- reduces shield "yellow stars beam"
	{ name = "glooth fairy skill reducer", interval = 2000, chance = 5, target = false }, -- reduces magic level "great energy beam"
	{ name = "speed", interval = 2000, chance = 20, speedChange = -400, radius = 6, effect = CONST_ME_POISONAREA, target = true, duration = 60000 }, -- paralyze, poison ultimate explosion
}

monster.defenses = {
	defense = 150,
	armor = 165,
	mitigation = 2.37,
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 1000, chance = 1, type = COMBAT_HEALING, minDamage = 7500, maxDamage = 8000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
