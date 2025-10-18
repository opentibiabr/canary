local mType = Game.createMonsterType("Omrafir")
local monster = {}

monster.description = "Omrafir"
monster.experience = 50000
monster.outfit = {
	lookType = 12,
	lookHead = 78,
	lookBody = 3,
	lookLegs = 79,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1011,
	bossRace = RARITY_NEMESIS,
}

monster.health = 322000
monster.maxHealth = 322000
monster.race = "fire"
monster.corpse = 6068
monster.speed = 240
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

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "FIRST I'LL OBLITERATE YOU THEN I BURN THIS PRISON DOWN!!", yell = true },
	{ text = "I'M TOO HOT FOR YOU TO HANDLE!", yell = true },
	{ text = "FREEDOM FOR THE PRINCES!", yell = true },
	{ text = "OMRAFIR INHALES DEEPLY!", yell = true },
	{ text = "OMRAFIR BREATHES INFERNAL FIRE", yell = true },
	{ text = "THE POWER OF HIS INTERNAL FIRE RENEWS OMRAFIR!", yell = true },
	{ text = "I WILL RULE WHEN THE NEW ORDER IS ESTABLISHED!", yell = true },
	{ text = "INFERNATIL! COME HERE AND FIGHT ME YOU COWARD!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 25000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 97500, maxCount = 20 }, -- Platinum Coin
	{ id = 20063, chance = 90000, maxCount = 2 }, -- Dream Matter
	{ id = 20264, chance = 90000, maxCount = 3 }, -- Unrealized Dream
	{ id = 6499, chance = 92500 }, -- Demonic Essence
	{ id = 16119, chance = 25000, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 16125, chance = 40000, maxCount = 3 }, -- Cyan Crystal Fragment
	{ id = 16126, chance = 15000, maxCount = 3 }, -- Red Crystal Fragment
	{ id = 281, chance = 30000 }, -- Giant Shimmering Pearl
	{ id = 7642, chance = 37500, maxCount = 8 }, -- Great Spirit Potion
	{ id = 16127, chance = 40000, maxCount = 3 }, -- Green Crystal Fragment
	{ id = 16120, chance = 20000, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 7643, chance = 35000, maxCount = 8 }, -- Ultimate Health Potion
	{ id = 20062, chance = 85000, maxCount = 4 }, -- Cluster of Solace
	{ id = 5954, chance = 30000 }, -- Demon Horn
	{ id = 3038, chance = 30000 }, -- Green Gem
	{ id = 820, chance = 12500 }, -- Lightning Boots
	{ id = 238, chance = 25000, maxCount = 8 }, -- Great Mana Potion
	{ id = 20278, chance = 7500 }, -- Demonic Tapestry
	{ id = 3098, chance = 15000 }, -- Ring of Healing
	{ id = 20276, chance = 8000 }, -- Dream Warden Mask
	{ id = 20274, chance = 8000 }, -- Nightmare Horn
	{ id = 20279, chance = 12500 }, -- Eye Pod
	{ id = 825, chance = 16000 }, -- Lightning Robe
	{ id = 7456, chance = 12500 }, -- Noble Axe
	{ id = 3554, chance = 6250 }, -- Steel Boots
	{ id = 5741, chance = 8000 }, -- Skull Helmet
	{ id = 16121, chance = 25000, maxCount = 5 }, -- Green Crystal Shard
	{ id = 20282, chance = 10000 }, -- Nightmare Hook
	{ id = 8050, chance = 6250 }, -- Crystalline Armor
	{ id = 20277, chance = 6451 }, -- Psychedelic Tapestry
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 392, attack = 500 },
	{ name = "omrafir wave", interval = 2000, chance = 17, minDamage = -500, maxDamage = -1000, target = false },
	{ name = "omrafir beam", interval = 2000, chance = 15, minDamage = -7000, maxDamage = -10000, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -1000, maxDamage = -3000, length = 10, spread = 3, effect = CONST_ME_FIREATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -400, radius = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 19, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -300, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, radius = 1, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = true },
	{ name = "firefield", interval = 2000, chance = 12, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true },
}

monster.defenses = {
	defense = 165,
	armor = 155,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_HEALING, minDamage = 440, maxDamage = 800, target = false },
	{ name = "omrafir summon", interval = 2000, chance = 50, target = false },
	{ name = "omrafir healing 2", interval = 2000, chance = 20, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
