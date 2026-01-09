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
	{ id = 3031, chance = 97295, maxCount = 376 }, -- Gold Coin
	{ id = 19083, chance = 86670 }, -- Silver Raid Token
	{ id = 7290, chance = 43243 }, -- Shard
	{ id = 7449, chance = 37839 }, -- Crystal Sword
	{ id = 7642, chance = 40540, maxCount = 9 }, -- Great Spirit Potion
	{ id = 7443, chance = 27025 }, -- Bullseye Potion
	{ id = 819, chance = 27027 }, -- Glacier Shoes
	{ id = 3284, chance = 40540 }, -- Ice Rapier
	{ id = 3052, chance = 37837 }, -- Life Ring
	{ id = 3035, chance = 35135 }, -- Platinum Coin
	{ id = 7439, chance = 21873 }, -- Berserk Potion
	{ id = 3041, chance = 18748 }, -- Blue Gem
	{ id = 7440, chance = 32431 }, -- Mastermind Potion
	{ id = 3574, chance = 27028 }, -- Mystic Turban
	{ id = 5909, chance = 21620 }, -- White Piece of Cloth
	{ id = 815, chance = 15625 }, -- Glacier Amulet
	{ id = 239, chance = 21873, maxCount = 9 }, -- Great Health Potion
	{ id = 238, chance = 29731, maxCount = 9 }, -- Great Mana Potion
	{ id = 5912, chance = 9373 }, -- Blue Piece of Cloth
	{ id = 3333, chance = 13330 }, -- Crystal Mace
	{ id = 3085, chance = 13512 }, -- Dragon Necklace
	{ id = 823, chance = 16214 }, -- Glacier Kilt
	{ id = 9058, chance = 18917 }, -- Gold Ingot
	{ id = 7459, chance = 13512 }, -- Pair of Earmuffs
	{ id = 3324, chance = 20000 }, -- Skull Staff
	{ id = 3079, chance = 6670 }, -- Boots of Haste
	{ id = 829, chance = 10002 }, -- Glacier Mask
	{ id = 824, chance = 14997 }, -- Glacier Robe
	{ id = 5911, chance = 8109 }, -- Red Piece of Cloth
	{ id = 19365, chance = 10002 }, -- Trapped Lightning
	{ id = 19366, chance = 9090 }, -- Icy Culottes
	{ id = 7410, chance = 1000 }, -- Queen's Sceptre
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
