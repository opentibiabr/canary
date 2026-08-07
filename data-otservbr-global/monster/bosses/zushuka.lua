local mType = Game.createMonsterType("Zushuka")
local monster = {}

monster.description = "zushuka" -- (immortal) // (mortal): lookType = 149, lookHead = 86, lookBody = 10, lookLegs = 11, lookFeet = 4, lookAddons = 0, lookMount = 0
monster.experience = 9000
monster.outfit = {
	lookType = 149,
	lookHead = 0,
	lookBody = 10,
	lookLegs = 0,
	lookFeet = 4,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 969,
	bossRace = RARITY_NEMESIS,
}

monster.health = 15000
monster.maxHealth = 15000
monster.race = "blood"
monster.corpse = 18265
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Cool down, will you?", yell = false },
	{ text = "And stay cool.", yell = false },
	{ text = "Your cold dead body will be a marvelous ice statue.", yell = false },
	{ text = "Pay for your ignorance!", yell = false },
	{ text = "Is this all you've got?", yell = false },
	{ text = "Freeze!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 352 }, -- Gold Coin
	{ id = 7642, chance = 50000, maxCount = 9 }, -- Great Spirit Potion
	{ id = 3035, chance = 39000 }, -- Platinum Coin
	{ id = 7449, chance = 33000 }, -- Crystal Sword
	{ id = 3574, chance = 28000 }, -- Mystic Turban
	{ id = 3052, chance = 28000 }, -- Life Ring
	{ id = 3284, chance = 28000 }, -- Ice Rapier
	{ id = 239, chance = 28000, maxCount = 9 }, -- Great Health Potion
	{ id = 7440, chance = 22000 }, -- Mastermind Potion
	{ id = 7290, chance = 16700 }, -- Shard
	{ id = 823, chance = 16700 }, -- Glacier Kilt
	{ id = 238, chance = 16700, maxCount = 7 }, -- Great Mana Potion
	{ id = 7443, chance = 16700 }, -- Bullseye Potion
	{ id = 3085, chance = 16700 }, -- Dragon Necklace
	{ id = 49271, chance = 11100 }, -- Transcendence Potion
	{ id = 9058, chance = 11100 }, -- Gold Ingot
	{ id = 819, chance = 11100 }, -- Glacier Shoes
	{ id = 815, chance = 11100 }, -- Glacier Amulet
	{ id = 7439, chance = 11100 }, -- Berserk Potion
	{ id = 7459, chance = 5600 }, -- Pair of Earmuffs
	{ id = 19366, chance = 5600 }, -- Icy Culottes
	{ id = 5911, chance = 5600 }, -- Red Piece of Cloth
	{ id = 3041, chance = 5600 }, -- Blue Gem
	{ id = 5912, chance = 5600 }, -- Blue Piece of Cloth
	{ id = 5909, chance = 5600 }, -- White Piece of Cloth
	{ id = 19083, chance = 86670 }, -- Silver Raid Token
	{ id = 3333, chance = 13330 }, -- Crystal Mace
	{ id = 3324, chance = 20000 }, -- Skull Staff
	{ id = 3079, chance = 6670 }, -- Boots of Haste
	{ id = 829, chance = 6670 }, -- Glacier Mask
	{ id = 824, chance = 13330 }, -- Glacier Robe
	{ id = 19365, chance = 6670 }, -- Trapped Lightning
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -560 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = 0, maxDamage = -100, length = 8, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = 0, maxDamage = -110, range = 7, shootEffect = CONST_ANI_SNOWBALL, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -300, maxDamage = -750, length = 8, spread = 0, effect = CONST_ME_ICEAREA, target = false },
	{ name = "outfit", interval = 2000, chance = 10, range = 7, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 4000, outfitItem = 7172 },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -330, range = 7, effect = CONST_ME_ICETORNADO, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	--	mitigation = ???,
	{ name = "combat", interval = 10000, chance = 1, type = COMBAT_HEALING, minDamage = 7500, maxDamage = 7515, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_HEALING, minDamage = 200, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
