local mType = Game.createMonsterType("Eradicator2")
local monster = {}

monster.name = "Eradicator"
monster.description = "Eradicator"
monster.experience = 50000
monster.outfit = {
	lookType = 875,
	lookHead = 94,
	lookBody = 3,
	lookLegs = 78,
	lookFeet = 94,
	lookAddons = 1,
	lookMount = 0,
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

monster.bosstiary = {
	bossRaceId = 1225,
	bossRace = RARITY_ARCHFOE,
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

monster.events = {
	"HeartBossDeath",
	"EradicatorTransform",
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
	{ id = 3031, chance = 100000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 100000, maxCount = 25 }, -- platinum coin
	{ id = 16121, chance = 8000, maxCount = 3 }, -- green crystal shard
	{ id = 238, chance = 8000, maxCount = 5 }, -- great mana potion
	{ id = 7642, chance = 8000, maxCount = 5 }, -- great spirit potion
	{ id = 3033, chance = 8000, maxCount = 5 }, -- small amethyst
	{ id = 3030, chance = 8000, maxCount = 5 }, -- small ruby
	{ id = 9057, chance = 8000, maxCount = 5 }, -- small topaz
	{ id = 7643, chance = 8000, maxCount = 10 }, -- ultimate health potion
	{ id = 16120, chance = 8000, maxCount = 3 }, -- violet crystal shard
	{ id = 23535, chance = 8000 }, -- energy bar
	{ id = 23520, chance = 8000 }, -- plasmatic lightning
	{ id = 23516, chance = 8000 }, -- instable proto matter
	{ id = 22721, chance = 100000 }, -- gold token
	{ id = 23509, chance = 100000 }, -- mysterious remains
	{ id = 23510, chance = 100000 }, -- odd organ
	{ id = 3041, chance = 6000 }, -- blue gem
	{ id = 3038, chance = 6000 }, -- green gem
	{ id = 8073, chance = 6000 }, -- spellbook of warding
	{ id = 3333, chance = 4000 }, -- crystal mace
	{ id = 23529, chance = 3500 }, -- ring of blue plasma
	{ id = 23531, chance = 3500 }, -- ring of green plasma
	{ id = 23533, chance = 3500 }, -- ring of red plasma
	{ id = 3554, chance = 5000, unique = true }, -- steel boots
	{ id = 8075, chance = 3000, unique = true }, -- spellbook of lost souls
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -1800 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -600, maxDamage = -1000, length = 8, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -450, maxDamage = -900, radius = 8, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HOLYDAMAGE, minDamage = -300, maxDamage = -600, radius = 4, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "big lifedrain wave", interval = 2000, chance = 20, minDamage = -700, maxDamage = -1000, target = false },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_HEALING, minDamage = 500, maxDamage = 1200, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
