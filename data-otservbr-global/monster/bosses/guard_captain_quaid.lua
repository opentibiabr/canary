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
	{ id = 3029, chance = 100000 }, -- Small Sapphire
	{ id = 3035, chance = 1000, maxCount = 20 }, -- Platinum Coin
	{ id = 3037, chance = 1000 }, -- Yellow Gem
	{ id = 3039, chance = 1000 }, -- Red Gem
	{ id = 9058, chance = 1000 }, -- Gold Ingot
	{ id = 281, chance = 1000 }, -- Giant Shimmering Pearl
	{ id = 31678, chance = 1000 }, -- Cobra Crest
	{ id = 3041, chance = 1000 }, -- Blue Gem
	{ id = 3038, chance = 1000 }, -- Green Gem
	{ id = 830, chance = 1000 }, -- Terra Hood
	{ id = 3349, chance = 1000 }, -- Crossbow
	{ id = 3350, chance = 1000 }, -- Bow
	{ id = 3347, chance = 1000 }, -- Hunting Spear
	{ id = 16119, chance = 1000 }, -- Blue Crystal Shard
	{ id = 3287, chance = 1000, maxCount = 6 }, -- Throwing Star
	{ id = 16121, chance = 1000 }, -- Green Crystal Shard
	{ id = 9057, chance = 1000 }, -- Small Topaz
	{ id = 9302, chance = 1000 }, -- Sacred Tree Amulet
	{ id = 827, chance = 1000 }, -- Magma Monocle
	{ id = 3575, chance = 1000 }, -- Wood Cape
	{ id = 16163, chance = 1000 }, -- Crystal Crossbow
	{ id = 5741, chance = 1000 }, -- Skull Helmet
	{ id = 23529, chance = 1000 }, -- Ring of Blue Plasma
	{ id = 30394, chance = 1000 }, -- Cobra Boots
	{ id = 30393, chance = 1000 }, -- Cobra Crossbow
	{ id = 30397, chance = 1000 }, -- Cobra Hood
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
