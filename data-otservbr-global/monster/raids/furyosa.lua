local mType = Game.createMonsterType("Furyosa")
local monster = {}

monster.description = "Furyosa"
monster.experience = 11500
monster.outfit = {
	lookType = 149,
	lookHead = 94,
	lookBody = 79,
	lookLegs = 77,
	lookFeet = 3,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "blood"
monster.corpse = 18118
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 987,
	bossRace = RARITY_NEMESIS,
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Fury", chance = 10, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "MUHAHA!", yell = false },
	{ text = "Back in black!", yell = false },
	{ text = "Die!", yell = false },
	{ text = "Dieeee!", yell = false },
	{ text = "Caaarnaaage!", yell = false },
	{ text = "Ahhhhrrrr!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 363 }, -- Gold Coin
	{ id = 3035, chance = 64704, maxCount = 25 }, -- Platinum Coin
	{ id = 8016, chance = 100000, maxCount = 9 }, -- Jalapeno Pepper
	{ id = 3007, chance = 59998 }, -- Crystal Ring
	{ id = 238, chance = 46668, maxCount = 5 }, -- Great Mana Potion
	{ id = 19083, chance = 42860 }, -- Silver Raid Token
	{ id = 3029, chance = 35295, maxCount = 5 }, -- Small Sapphire
	{ id = 5944, chance = 53334 }, -- Soul Orb
	{ id = 7368, chance = 21427, maxCount = 16 }, -- Assassin Star
	{ id = 9058, chance = 21427 }, -- Gold Ingot
	{ id = 7642, chance = 23528, maxCount = 9 }, -- Great Spirit Potion
	{ id = 5911, chance = 28570 }, -- Red Piece of Cloth
	{ id = 7643, chance = 35293, maxCount = 9 }, -- Ultimate Health Potion
	{ id = 5909, chance = 39999 }, -- White Piece of Cloth
	{ id = 6558, chance = 30002 }, -- Flask of Demonic Blood
	{ id = 6299, chance = 14290 }, -- Death Ring
	{ id = 6499, chance = 21430 }, -- Demonic Essence
	{ id = 826, chance = 14290 }, -- Magma Coat
	{ id = 821, chance = 1000 }, -- Magma Legs
	{ id = 3028, chance = 14287, maxCount = 9 }, -- Small Diamond
	{ id = 3030, chance = 14287, maxCount = 7 }, -- Small Ruby
	{ id = 9057, chance = 21430, maxCount = 8 }, -- Small Topaz
	{ id = 5914, chance = 14287 }, -- Yellow Piece of Cloth
	{ id = 3439, chance = 1000 }, -- Phoenix Shield
	{ id = 19391, chance = 33333 }, -- Furious Frock
	{ id = 7404, chance = 33333 }, -- Assassin Dagger
	{ id = 7456, chance = 33333 }, -- Noble Axe
	{ id = 16115, chance = 33333 }, -- Wand of Everblazing
	{ id = 3364, chance = 1000 }, -- Golden Legs
	{ id = 3280, chance = 1000 }, -- Fire Sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -625 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -260, maxDamage = -310, radius = 6, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -210, length = 8, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -300, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -800, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -150, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "fury skill reducer", interval = 2000, chance = 5, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE },
	{ name = "combat", interval = 7000, chance = 20, type = COMBAT_HEALING, minDamage = 500, maxDamage = 700, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
