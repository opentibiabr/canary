local mType = Game.createMonsterType("Tyrn")
local monster = {}

monster.description = "Tyrn"
monster.experience = 6900
monster.outfit = {
	lookType = 562,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 966,
	bossRace = RARITY_NEMESIS,
}

monster.health = 12000
monster.maxHealth = 12000
monster.race = "blood"
monster.corpse = 18970
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{ text = "GRRR", yell = true },
	{ text = "GRROARR", yell = true },
}

monster.loot = {
	{ id = 19083, chance = 5000 }, -- silver raid token
	{ id = 19361, chance = 3000 }, -- sun mirror
	{ id = 3583, chance = 55000, maxCount = 3 }, -- dragon ham
	{ id = 3155, chance = 15000 }, -- sudden death rune
	{ id = 3031, chance = 100000, maxCount = 50 }, -- gold coin
	{ id = 3035, chance = 60000, maxCount = 8 }, -- platinum coin
	{ id = 7368, chance = 30000, maxCount = 5 }, -- assassin star
	{ id = 236, chance = 25000, maxCount = 5 }, -- strong health potion
	{ id = 237, chance = 25000, maxCount = 5 }, -- strong mana potion
	{ id = 9665, chance = 100000 }, -- wyrm scale
	{ id = 3039, chance = 9000 }, -- red gem
	{ id = 3037, chance = 9000 }, -- yellow gem
	{ id = 3036, chance = 9000 }, -- violet gem
	{ id = 3415, chance = 9000 }, -- guardian shield
	{ id = 8045, chance = 9000 }, -- hibiscus dress
	{ id = 3028, chance = 15000, maxCount = 5 }, -- small diamond
	{ id = 3033, chance = 15000, maxCount = 5 }, -- small amethyst
	{ id = 3032, chance = 15000, maxCount = 5 }, -- small emerald
	{ id = 3029, chance = 15000, maxCount = 5 }, -- small sapphire
	{ id = 9057, chance = 15000, maxCount = 5 }, -- small topaz
	{ id = 3030, chance = 15000, maxCount = 5 }, -- small ruby
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 70, attack = 130 },
	{ name = "drunk", interval = 2000, chance = 8, radius = 8, effect = CONST_ME_SOUND_YELLOW, target = false, duration = 25000 },
	{ name = "combat", interval = 2000, chance = 33, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -190, range = 7, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -300, range = 7, radius = 4, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "tyrn electrify", interval = 2000, chance = 11, target = false },
	{ name = "tyrn skill reducer", interval = 2000, chance = 14, target = false },
}

monster.defenses = {
	defense = 68,
	armor = 58,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 33, type = COMBAT_HEALING, minDamage = 200, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 11, effect = CONST_ME_ENERGYHIT },
	{ name = "tyrn heal", interval = 1000, chance = 100, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
