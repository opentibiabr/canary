local mType = Game.createMonsterType("World Devourer")
local monster = {}

monster.description = "World Devourer"
monster.experience = 77700
monster.outfit = {
	lookType = 875,
	lookHead = 82,
	lookBody = 79,
	lookLegs = 84,
	lookFeet = 94,
	lookAddons = 3,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1228,
	bossRace = RARITY_NEMESIS,
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "venom"
monster.corpse = 0
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
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 35 }, -- platinum coin
	{ id = 23545, chance = 80000, maxCount = 5 }, -- energy drink
	{ id = 23535, chance = 80000, maxCount = 5 }, -- energy bar
	{ id = 238, chance = 80000, maxCount = 10 }, -- great mana potion
	{ id = 7643, chance = 80000, maxCount = 10 }, -- ultimate health potion
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 16119, chance = 80000, maxCount = 3 }, -- blue crystal shard
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 9057, chance = 80000, maxCount = 20 }, -- small topaz
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 23507, chance = 80000 }, -- crystallized anger
	{ id = 39547, chance = 80000 }, -- energy vein
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23474, chance = 80000 }, -- tiara of power
	{ id = 23476, chance = 80000 }, -- void boots
	{ id = 22721, chance = 80000, maxCount = 23 }, -- gold token
	{ id = 23686, chance = 260 }, -- devourer core
	{ id = 23684, chance = 260 }, -- crackling egg
	{ id = 23685, chance = 260 }, -- menacing egg
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 7642, chance = 80000, maxCount = 10 }, -- great spirit potion
	{ id = 3029, chance = 80000 }, -- small sapphire
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 3364, chance = 80000 }, -- golden legs
	{ id = 828, chance = 80000 }, -- lightning headband
	{ id = 3033, chance = 80000 }, -- small amethyst
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 7426, chance = 80000 }, -- amber staff
	{ id = 8027, chance = 80000 }, -- composite hornbow
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 7428, chance = 80000 }, -- bonebreaker
	{ id = 8050, chance = 80000 }, -- crystalline armor
	{ id = 7417, chance = 80000 }, -- runed sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1600 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -800, length = 10, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -800, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -800, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_YELLOWENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -1200, length = 10, spread = 0, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, radius = 8, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
	{ name = "devourer summon", interval = 2000, chance = 25, target = false },
}

monster.defenses = {
	defense = 150,
	armor = 150,
	--	mitigation = ???,
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
