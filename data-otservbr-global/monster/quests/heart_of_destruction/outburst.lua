local mType = Game.createMonsterType("Outburst")
local monster = {}

monster.description = "Outburst"
monster.experience = 50000
monster.outfit = {
	lookType = 876,
	lookHead = 79,
	lookBody = 3,
	lookLegs = 94,
	lookFeet = 3,
	lookAddons = 3,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1227,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "venom"
monster.corpse = 23564
monster.speed = 250
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
	"OutburstCharge",
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
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3029, chance = 80000, maxCount = 10 }, -- small sapphire
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 238, chance = 80000, maxCount = 5 }, -- great mana potion
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 16119, chance = 80000, maxCount = 3 }, -- blue crystal shard
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 828, chance = 80000 }, -- lightning headband
	{ id = 23516, chance = 80000 }, -- instable proto matter
	{ id = 23523, chance = 80000 }, -- energy ball
	{ id = 22721, chance = 80000, maxCount = 7 }, -- gold token
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 23474, chance = 80000 }, -- tiara of power
	{ id = 23476, chance = 80000 }, -- void boots
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 23545, chance = 80000 }, -- energy drink
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 8027, chance = 80000 }, -- composite hornbow
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 7426, chance = 80000 }, -- amber staff
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 7428, chance = 80000 }, -- bonebreaker
	{ id = 825, chance = 80000 }, -- lightning robe
	{ id = 3342, chance = 80000 }, -- war axe
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 16160, chance = 80000 }, -- crystalline sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -1800 },
	{ name = "big energy purple wave", interval = 2000, chance = 25, minDamage = -700, maxDamage = -1300, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -600, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -800, maxDamage = -1300, length = 8, spread = 0, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -600, maxDamage = -900, length = 8, spread = 0, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "big skill reducer", interval = 2000, chance = 25, target = false },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
