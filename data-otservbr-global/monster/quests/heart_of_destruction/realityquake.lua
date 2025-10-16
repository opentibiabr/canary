local mType = Game.createMonsterType("Realityquake")
local monster = {}

monster.description = "Realityquake"
monster.experience = 20000
monster.outfit = {
	lookTypeEx = 1949,
}

monster.bosstiary = {
	bossRaceId = 1218,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 110000
monster.maxHealth = 110000
monster.race = "venom"
monster.corpse = 23567
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
	chance = 20,
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
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3035, chance = 80000, maxCount = 25 }, -- platinum coin
	{ id = 23535, chance = 80000, maxCount = 5 }, -- energy bar
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 23507, chance = 80000 }, -- crystallized anger
	{ id = 7418, chance = 80000 }, -- nightmare blade
	{ id = 22721, chance = 80000, maxCount = 7 }, -- gold token
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 23474, chance = 80000 }, -- tiara of power
	{ id = 23476, chance = 80000 }, -- void boots
	{ id = 3029, chance = 80000 }, -- small sapphire
	{ id = 16119, chance = 80000 }, -- blue crystal shard
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 825, chance = 80000 }, -- lightning robe
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 16120, chance = 80000 }, -- violet crystal shard
	{ id = 3333, chance = 80000 }, -- crystal mace
	{ id = 3033, chance = 80000 }, -- small amethyst
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 7388, chance = 80000 }, -- vile axe
	{ id = 39547, chance = 80000 }, -- energy vein
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 16121, chance = 80000 }, -- green crystal shard
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3073, chance = 80000 }, -- wand of cosmic energy
	{ id = 828, chance = 80000 }, -- lightning headband
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 8050, chance = 80000 }, -- crystalline armor
	{ id = 3364, chance = 80000 }, -- golden legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -400, maxDamage = -1000 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -350, maxDamage = -800, length = 10, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -800, length = 10, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -240, maxDamage = -600, radius = 5, effect = CONST_ME_POFF, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HOLYDAMAGE, minDamage = -240, maxDamage = -600, radius = 5, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -450, length = 4, spread = 2, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -240, maxDamage = -600, radius = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, radius = 8, effect = CONST_ME_POFF, target = false },
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
