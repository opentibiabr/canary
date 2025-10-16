local mType = Game.createMonsterType("Eradicator")
local monster = {}

monster.description = "Eradicator"
monster.experience = 50000
monster.outfit = {
	lookType = 875,
	lookHead = 79,
	lookBody = 3,
	lookLegs = 114,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1226,
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
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 3333, chance = 80000 }, -- crystal mace
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 23518, chance = 80000 }, -- spark sphere
	{ id = 23520, chance = 80000 }, -- plasmatic lightning
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 22721, chance = 80000, maxCount = 7 }, -- gold token
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 23474, chance = 80000 }, -- tiara of power
	{ id = 23476, chance = 80000 }, -- void boots
	{ id = 8073, chance = 80000 }, -- spellbook of warding
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 16119, chance = 80000 }, -- blue crystal shard
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 8075, chance = 80000 }, -- spellbook of lost souls
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 23535, chance = 80000 }, -- energy bar
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 7426, chance = 80000 }, -- amber staff
	{ id = 3554, chance = 80000 }, -- steel boots
	{ id = 8050, chance = 80000 }, -- crystalline armor
	{ id = 7388, chance = 80000 }, -- vile axe
	{ id = 7421, chance = 80000 }, -- onyx flail
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -1800 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -600, maxDamage = -1000, length = 8, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -600, maxDamage = -1000, length = 8, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -450, maxDamage = -900, radius = 8, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "big energy wave", interval = 2000, chance = 20, minDamage = -700, maxDamage = -1000, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -600, radius = 4, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "anomaly break", interval = 2000, chance = 40, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 50 },
	{ type = COMBAT_MANADRAIN, percent = 50 },
	{ type = COMBAT_DROWNDAMAGE, percent = 50 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
