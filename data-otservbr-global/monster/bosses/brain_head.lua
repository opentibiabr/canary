local mType = Game.createMonsterType("Brain Head")
local monster = {}

monster.description = "Brain Head"
monster.experience = 0
monster.outfit = {
	lookTypeEx = 32418,
}

monster.health = 75000
monster.maxHealth = monster.health
monster.race = "undead"
monster.corpse = 32272
monster.speed = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1862,
	bossRace = RARITY_ARCHFOE,
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
	{ id = 3043, chance = 100000, maxCount = 3 }, -- Crystal Coin
	{ id = 32770, chance = 58000, maxCount = 2 }, -- Diamond
	{ id = 32769, chance = 51000, maxCount = 2 }, -- White Gem
	{ id = 23373, chance = 36000, maxCount = 10 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 32000, maxCount = 11 }, -- Ultimate Spirit Potion
	{ id = 23375, chance = 32000, maxCount = 10 }, -- Supreme Health Potion
	{ id = 32774, chance = 31000 }, -- Cursed Bone
	{ id = 7439, chance = 20000, maxCount = 18 }, -- Berserk Potion
	{ id = 7443, chance = 18600, maxCount = 18 }, -- Bullseye Potion
	{ id = 32772, chance = 16900 }, -- Silver Hand Mirror
	{ id = 32703, chance = 10200, maxCount = 2 }, -- Death Toll
	{ id = 32773, chance = 6800 }, -- Ivory Comb
	{ id = 7440, chance = 6800, maxCount = 14 }, -- Mastermind Potion
	{ id = 32771, chance = 5100 }, -- Moonstone
	{ id = 32622, chance = 5100 }, -- Giant Amethyst
	{ id = 49271, chance = 5100, maxCount = 18 }, -- Transcendence Potion
	{ id = 32589, chance = 5100 }, -- Angel Figurine
	{ id = 32580, chance = 1700 }, -- Brain Head's Right Hemisphere
	{ id = 32623, chance = 1700 }, -- Giant Topaz
	{ id = 32625, chance = 1700 }, -- Amber with a Dragonfly
	{ id = 32626, chance = 1700 }, -- Amber (Item)
	{ id = 32630, chance = 1700 }, -- Spooky Hood
}

monster.attacks = {
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2000, chance = 80, minDamage = -700, maxDamage = -1200, effect = CONST_ME_MORTAREA, shootEffect = CONST_ANI_SUDDENDEATH, target = true, range = 7 },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 20, length = 8, spread = 0, minDamage = -900, maxDamage = -1300, effect = CONST_ME_ELECTRICALSPARK },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 3.27,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
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
