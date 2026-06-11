local mType = Game.createMonsterType("The Rootkraken")
local monster = {}

monster.name = "The Rootkraken"
monster.experience = 600000
monster.outfit = {
	lookType = 1765,
}

monster.bosstiary = {
	bossRaceId = 2528,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 360000
monster.maxHealth = 360000
monster.race = "venom"
monster.corpse = 49124
monster.speed = 180

monster.changeTarget = {
	interval = 4000,
	chance = 25,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	attackable = true,
	hostile = true,
	summonable = false,
	convinceable = false,
	illusionable = false,
	boss = true,
	rewardBoss = true,
	ignoreSpawnBlock = false,
	pushable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
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
	{ text = "", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 100000, maxCount = 3 }, -- crystal coin
	{ id = 3035, chance = 100000, maxCount = 100 }, -- platinum coin
	{ id = 32626, chance = 44444 }, -- amber
	{ id = 7643, chance = 42593, maxCount = 20 }, -- ultimate health potion
	{ id = 7642, chance = 42593, maxCount = 14 }, -- great spirit potion
	{ id = 238, chance = 31481, maxCount = 14 }, -- great mana potion
	{ id = 23375, chance = 31481, maxCount = 8 }, -- supreme health potion
	{ id = 23374, chance = 25926, maxCount = 15 }, -- ultimate spirit potion
	{ id = 237, chance = 25926, maxCount = 20 }, -- strong mana potion
	{ id = 3037, chance = 24074, maxCount = 2 }, -- yellow gem
	{ id = 32769, chance = 20370, maxCount = 2 }, -- white gem
	{ id = 47368, chance = 20000 }, -- amber slayer
	{ id = 47369, chance = 20000 }, -- amber greataxe
	{ id = 47370, chance = 20000 }, -- amber bludgeon
	{ id = 47374, chance = 20000 }, -- amber sabre
	{ id = 47375, chance = 20000 }, -- amber axe
	{ id = 47376, chance = 20000 }, -- amber cudgel
	{ id = 47377, chance = 20000 }, -- amber crossbow
	{ id = 50239, chance = 20000 }, -- amber kusarigama
	{ id = 32624, chance = 18519 }, -- amber with a bug
	{ id = 32625, chance = 18519 }, -- amber with a dragonfly
	{ id = 3041, chance = 18519, maxCount = 2 }, -- blue gem
	{ id = 32623, chance = 7407 }, -- giant topa
	{ id = 48516, chance = 5556 }, -- root tentacle
	{ id = 32622, chance = 5556 }, -- giant amethyst
	{ id = 30061, chance = 3704 }, -- giant sapphire
	{ id = 48517, chance = 1852 }, -- fish eye
	{ id = 30060, chance = 1852 }, -- giant emerald
	{ id = 48514, chance = 1852 }, -- strange inedible fruit
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -800, maxDamage = -1200 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_DEATHDAMAGE, minDamage = -450, maxDamage = -700, range = 6, shootEffect = CONST_ANI_DEATH, target = false },
}

monster.defenses = {
	defense = 85,
	armor = 85,
	mitigation = 2.00,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
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
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
