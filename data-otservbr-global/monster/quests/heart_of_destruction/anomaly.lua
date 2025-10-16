local mType = Game.createMonsterType("Anomaly")
local monster = {}

monster.description = "anomaly"
monster.experience = 50000
monster.outfit = {
	lookType = 876,
	lookHead = 38,
	lookBody = 79,
	lookLegs = 76,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1219,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "venom"
monster.corpse = 23564
monster.speed = 200
monster.manaCost = 0

monster.events = {
	"AnomalyTransform",
	"HeartBossDeath",
}

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

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 23476, chance = 80000 }, -- void boots
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 8073, chance = 80000 }, -- spellbook of warding
	{ id = 9057, chance = 80000, maxCount = 10 }, -- small topaz
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 10 }, -- small diamond
	{ id = 7643, chance = 80000, maxCount = 5 }, -- ultimate health potion
	{ id = 23511, chance = 80000 }, -- curious matter
	{ id = 23519, chance = 80000 }, -- frozen lightning
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 7451, chance = 80000 }, -- shadow sceptre
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 22721, chance = 80000, maxCount = 7 }, -- gold token
	{ id = 6553, chance = 80000 }, -- ruthless axe
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 23474, chance = 80000 }, -- tiara of power
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 16119, chance = 80000 }, -- blue crystal shard
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 23545, chance = 80000 }, -- energy drink
	{ id = 828, chance = 80000 }, -- lightning headband
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 16160, chance = 80000 }, -- crystalline sword
	{ id = 825, chance = 80000 }, -- lightning robe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -1400 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -600, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "anomaly wave", interval = 2000, chance = 25, minDamage = -500, maxDamage = -900, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -600, maxDamage = -1000, length = 9, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -600, length = 9, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 150, maxDamage = 400, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
