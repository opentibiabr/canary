local mType = Game.createMonsterType("Rupture")
local monster = {}

monster.description = "Rupture"
monster.experience = 112000
monster.outfit = {
	lookType = 875,
	lookHead = 77,
	lookBody = 79,
	lookLegs = 3,
	lookFeet = 85,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1225,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "venom"
monster.corpse = 23564
monster.speed = 225
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25,
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
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.events = {
	"RuptureResonance",
	"RuptureHeal",
	"HeartBossDeath",
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
	{ id = 22721, chance = 80000, maxCount = 4 }, -- gold token
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 23476, chance = 80000 }, -- void boots
	{ id = 23535, chance = 80000, maxCount = 3 }, -- energy bar
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 7643, chance = 80000, maxCount = 5 }, -- ultimate health potion
	{ id = 9057, chance = 80000, maxCount = 10 }, -- small topaz
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 23510, chance = 80000 }, -- odd organ
	{ id = 8050, chance = 80000 }, -- crystalline armor
	{ id = 23506, chance = 80000 }, -- plasma pearls
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 16119, chance = 80000, maxCount = 3 }, -- blue crystal shard
	{ id = 23474, chance = 80000 }, -- tiara of power
	{ id = 3029, chance = 80000 }, -- small sapphire
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 7426, chance = 80000 }, -- amber staff
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 828, chance = 80000 }, -- lightning headband
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 7451, chance = 80000 }, -- shadow sceptre
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 6553, chance = 80000 }, -- ruthless axe
	{ id = 7403, chance = 80000 }, -- berserker
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -250, maxDamage = -1000 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -350, maxDamage = -800, length = 10, spread = 0, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -300, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "rupture wave", interval = 2000, chance = 20, minDamage = -700, maxDamage = -1100, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -600, length = 9, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 400, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
