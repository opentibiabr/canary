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
	{ id = 23476, 23477, chance = 18160 }, -- Void Boots
	{ id = 3041, chance = 19103 }, -- Blue Gem
	{ id = 3038, chance = 20990 }, -- Green Gem
	{ id = 8073, chance = 10613 }, -- Spellbook of Warding
	{ id = 9057, chance = 20047, maxCount = 10 }, -- Small Topaz
	{ id = 3033, chance = 17452, maxCount = 10 }, -- Small Amethyst
	{ id = 3028, chance = 20047, maxCount = 10 }, -- Small Diamond
	{ id = 7643, chance = 49528, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 23511, chance = 100000 }, -- Curious Matter
	{ id = 23519, chance = 100000 }, -- Frozen Lightning
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 16121, chance = 68396, maxCount = 3 }, -- Green Crystal Shard
	{ id = 16120, chance = 65330, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 7451, chance = 9905 }, -- Shadow Sceptre
	{ id = 23529, chance = 14858 }, -- Ring of Blue Plasma
	{ id = 23531, chance = 18160 }, -- Ring of Green Plasma
	{ id = 7642, chance = 54481, maxCount = 5 }, -- Great Spirit Potion
	{ id = 22721, chance = 100000, maxCount = 7 }, -- Gold Token
	{ id = 6553, chance = 2621 }, -- Ruthless Axe
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 23474, 23475, chance = 3301 }, -- Tiara of Power
	{ id = 3035, chance = 100000 }, -- Platinum Coin
	{ id = 7427, chance = 10377 }, -- Chaos Mace
	{ id = 16119, chance = 67216 }, -- Blue Crystal Shard
	{ id = 3030, chance = 25235 }, -- Small Ruby
	{ id = 3037, chance = 19103 }, -- Yellow Gem
	{ id = 23544, chance = 9198 }, -- Collar of Red Plasma
	{ id = 3032, chance = 17216 }, -- Small Emerald
	{ id = 23545, chance = 100000 }, -- Energy Drink
	{ id = 281, chance = 17924 }, -- Giant Shimmering Pearl
	{ id = 828, chance = 10377 }, -- Lightning Headband
	{ id = 822, chance = 6839 }, -- Lightning Legs
	{ id = 23533, chance = 16037 }, -- Ring of Red Plasma
	{ id = 3039, chance = 18160 }, -- Red Gem
	{ id = 238, chance = 61792 }, -- Great Mana Potion
	{ id = 23526, chance = 11556 }, -- Collar of Blue Plasma
	{ id = 23543, chance = 7547 }, -- Collar of Green Plasma
	{ id = 3036, chance = 4716 }, -- Violet Gem
	{ id = 16160, chance = 2594 }, -- Crystalline Sword
	{ id = 825, chance = 4009 }, -- Lightning Robe
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
