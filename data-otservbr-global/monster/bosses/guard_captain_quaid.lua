local mType = Game.createMonsterType("Guard Captain Quaid")
local monster = {}

monster.description = "Guard Captain Quaid"
monster.experience = 28000
monster.outfit = {
	lookType = 1217,
	lookHead = 38,
	lookBody = 20,
	lookLegs = 21,
	lookFeet = 2,
	lookAddons = 2,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1791,
	bossRace = RARITY_BANE,
}

monster.health = 55000
monster.maxHealth = 55000
monster.race = "blood"
monster.corpse = 31654
monster.speed = 92
monster.manaCost = 0

monster.events = {
	"UglyMonsterSpawn",
	"UglyMonsterCleanup",
	"grave_danger_death",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	targetDistance = 4,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3029, chance = 80000 }, -- small sapphire
	{ id = 3035, chance = 80000, maxCount = 20 }, -- platinum coin
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 9058, chance = 23000 }, -- gold ingot
	{ id = 31678, chance = 23000 }, -- cobra crest
	{ id = 3041, chance = 23000 }, -- blue gem
	{ id = 3038, chance = 23000 }, -- green gem
	{ id = 830, chance = 5000 }, -- terra hood
	{ id = 3349, chance = 5000 }, -- crossbow
	{ id = 3350, chance = 5000 }, -- bow
	{ id = 3347, chance = 1000 }, -- hunting spear
	{ id = 16119, chance = 5000 }, -- blue crystal shard
	{ id = 3287, chance = 5000, maxCount = 6 }, -- throwing star
	{ id = 16121, chance = 5000 }, -- green crystal shard
	{ id = 9057, chance = 1000 }, -- small topaz
	{ id = 9302, chance = 1000 }, -- sacred tree amulet
	{ id = 827, chance = 1000 }, -- magma monocle
	{ id = 3575, chance = 1000 }, -- wood cape
	{ id = 16163, chance = 1000 }, -- crystal crossbow
	{ id = 5741, chance = 1000 }, -- skull helmet
	{ id = 23529, chance = 1000 }, -- ring of blue plasma
	{ id = 30394, chance = 260 }, -- cobra boots
	{ id = 30393, chance = 260 }, -- cobra crossbow
	{ id = 30397, chance = 260 }, -- cobra hood
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -580 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -620, radius = 4, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_PHYSICALDAMAGE, minDamage = -450, maxDamage = -700, shootEffect = CONST_ANI_THROWINGKNIFE, target = true },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -550, length = 5, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -400, maxDamage = -550, radius = 1, shootEffect = CONST_ANI_BURSTARROW, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -480, length = 5, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -450, radius = 3, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 86,
	armor = 86,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
