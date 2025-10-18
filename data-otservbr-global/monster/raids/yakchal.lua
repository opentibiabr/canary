local mType = Game.createMonsterType("Yakchal")
local monster = {}

monster.description = "Yakchal"
monster.experience = 4400
monster.outfit = {
	lookType = 149,
	lookHead = 9,
	lookBody = 0,
	lookLegs = 85,
	lookFeet = 85,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 336,
	bossRace = RARITY_NEMESIS,
}

monster.health = 5750
monster.maxHealth = 5750
monster.race = "blood"
monster.corpse = 18265
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
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
	staticAttackChance = 50,
	targetDistance = 4,
	runHealth = 100,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Ice Golem", chance = 13, interval = 1000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "YOU BETTER DIE TO MY MINIONS BECAUSE YOU'LL WISH YOU DID IF I COME FOR YOU!", yell = true },
	{ text = "DESTROY THE INFIDELS", yell = true },
	{ text = "You are mine!", yell = false },
	{ text = "I will make you all pay!", yell = false },
	{ text = "No one will stop my plans!", yell = false },
	{ text = "You are responsible for this!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 98130, maxCount = 224 }, -- Gold Coin
	{ id = 5912, chance = 77245 }, -- Blue Piece of Cloth
	{ id = 7440, chance = 61077 }, -- Mastermind Potion
	{ id = 9058, chance = 35542 }, -- Gold Ingot
	{ id = 7449, chance = 17365 }, -- Crystal Sword
	{ id = 3085, chance = 10630 }, -- Dragon Necklace
	{ id = 823, chance = 13130 }, -- Glacier Kilt
	{ id = 824, chance = 11880 }, -- Glacier Robe
	{ id = 238, chance = 10245 }, -- Great Mana Potion
	{ id = 7443, chance = 5000 }, -- Bullseye Potion
	{ id = 7439, chance = 3750 }, -- Berserk Potion
	{ id = 3324, chance = 6880 }, -- Skull Staff
	{ id = 7459, chance = 5630 }, -- Pair of Earmuffs
	{ id = 7410, chance = 3130 }, -- Queen's Sceptre
	{ id = 3052, chance = 5630 }, -- Life Ring
	{ id = 3079, chance = 1250 }, -- Boots of Haste
	{ id = 3732, chance = 630 }, -- Green Mushroom
	{ id = 3333, chance = 1000 }, -- Crystal Mace
	{ id = 7290, chance = 100000 }, -- Shard
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -389 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_ICEDAMAGE, minDamage = 0, maxDamage = -430, radius = 4, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 3000, chance = 34, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -300, range = 7, radius = 3, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_HITAREA, target = true },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -300, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 20,
	armor = 15,
	mitigation = 1.74,
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
