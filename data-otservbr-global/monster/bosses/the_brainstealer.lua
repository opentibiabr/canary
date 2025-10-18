local mType = Game.createMonsterType("The Brainstealer")
local monster = {}

monster.description = "The Brainstealer"
monster.experience = 72000
monster.outfit = {
	lookType = 1412,
	lookHead = 94,
	lookBody = 88,
	lookLegs = 88,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2055,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = monster.health
monster.race = "undead"
monster.corpse = 36843
monster.speed = 425

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "brain parasite", chance = 20, interval = 4000, count = 1 },
	},
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.loot = {
	{ id = 7439, chance = 18407 }, -- Berserk Potion
	{ id = 7443, chance = 17412 }, -- Bullseye Potion
	{ id = 3043, chance = 100000 }, -- Crystal Coin
	{ id = 7440, chance = 18905 }, -- Mastermind Potion
	{ id = 32771, chance = 40298 }, -- Moonstone
	{ id = 23373, chance = 41293 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 24875 }, -- Ultimate Spirit Potion
	{ id = 3036, chance = 7462 }, -- Violet Gem
	{ id = 32769, chance = 43781 }, -- White Gem
	{ id = 23375, chance = 33830 }, -- Supreme Health Potion
	{ id = 3035, chance = 52238 }, -- Platinum Coin
	{ id = 7643, chance = 42786 }, -- Ultimate Health Potion
	{ id = 30061, chance = 1875 }, -- Giant Sapphire
	{ id = 34025, chance = 3482 }, -- Diabolic Skull
	{ id = 238, chance = 23880 }, -- Great Mana Potion
	{ id = 239, chance = 24875 }, -- Great Health Potion
	{ id = 36794, chance = 9950 }, -- Brainstealer's Tissue
	{ id = 36795, chance = 2985 }, -- Brainstealer's Brain
	{ id = 36796, chance = 1388 }, -- Brainstealer's Brainwave
	{ id = 36835, chance = 3980 }, -- Eldritch Crystal
	{ id = 36667, chance = 1136 }, -- Eldritch Breeches
	{ id = 36670, chance = 1136 }, -- Eldritch Cowl
	{ id = 36671, chance = 1000 }, -- Eldritch Hood
	{ id = 36664, chance = 1000 }, -- Eldritch Bow
	{ id = 36666, chance = 1000 }, -- Eldritch Quiver
	{ id = 36657, chance = 2272 }, -- Eldritch Claymore
	{ id = 36661, chance = 1000 }, -- Eldritch Greataxe
	{ id = 36659, chance = 1000 }, -- Eldritch Warmace
	{ id = 36656, chance = 1000 }, -- Eldritch Shield
	{ id = 36663, chance = 1000 }, -- Eldritch Cuirass
	{ id = 36672, chance = 1000 }, -- Eldritch Folio
	{ id = 36673, chance = 1000 }, -- Eldritch Tome
	{ id = 36674, chance = 1000 }, -- Eldritch Rod
	{ id = 36668, chance = 2439 }, -- Eldritch Wand
	{ id = 50169, chance = 1000 }, -- Eldritch Crescent Moon Spade
	{ id = 36658, chance = 1000 }, -- Gilded Eldritch Claymore
	{ id = 36662, chance = 1000 }, -- Gilded Eldritch Greataxe
	{ id = 36660, chance = 1000 }, -- Gilded Eldritch Warmace
	{ id = 36669, chance = 1000 }, -- Gilded Eldritch Wand
	{ id = 36675, chance = 1000 }, -- Gilded Eldritch Rod
	{ id = 36665, chance = 1000 }, -- Gilded Eldritch Bow
	{ id = 50170, chance = 1000 }, -- Gilded Eldritch Crescent Moon Spade
	{ id = 30059, chance = 2777 }, -- Giant Ruby
	{ id = 50266, chance = 1000 }, -- Eldritch Monk Boots
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, minDamage = 0, maxDamage = -900 },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2000, chance = 20, radius = 4, minDamage = -1200, maxDamage = -1900, effect = CONST_ME_MORTAREA, shootEffect = CONST_ANI_SUDDENDEATH, target = true, range = 7 },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 20, radius = 4, minDamage = -700, maxDamage = -1000, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 10, length = 8, spread = 0, minDamage = -1200, maxDamage = -1600, effect = CONST_ME_ELECTRICALSPARK },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 3.27,
	{ name = "combat", type = COMBAT_HEALING, chance = 15, interval = 2000, minDamage = 1450, maxDamage = 5350, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 3 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "invisible", condition = true },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Feel the power of death unleashed!", yell = false },
	{ text = "I will rule again and my realm of death will span the world!", yell = false },
	{ text = "My lich-knights will conquer this world for me!", yell = false },
}

mType:register(monster)
