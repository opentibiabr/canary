--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Fury")
local monster = {}

monster.description = "a fury"
monster.experience = 3600
monster.outfit = {
	lookType = 149,
	lookHead = 94,
	lookBody = 77,
	lookLegs = 96,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 291
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno (Apocalypse's Throne Room), The Inquisition Quest \z
		(The Shadow Nexus, Battlefield), Vengoth, Fury Dungeon, Oramond Fury Dungeon, The Extension Site."
	}

monster.health = 4100
monster.maxHealth = 4100
monster.race = "blood"
monster.corpse = 18118
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
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
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Ahhhhrrrr!", yell = false},
	{text = "Waaaaah!", yell = false},
	{text = "Caaarnaaage!", yell = false},
	{text = "Dieee!", yell = false}
}

monster.loot = {
	{id = 3007, chance = 410}, -- crystal ring
	{id = 3031, chance = 30000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 30000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 38000, maxCount = 69}, -- gold coin
	{id = 3035, chance = 2800, maxCount = 4}, -- platinum coin
	{id = 3065, chance = 20000}, -- terra rod
	{id = 3364, chance = 130}, -- golden legs
	{id = 3554, chance = 790}, -- steel boots
	{id = 5021, chance = 1500, maxCount = 4}, -- orichalcum pearl
	{id = 5911, chance = 4000}, -- red piece of cloth
	{id = 5944, chance = 21500}, -- soul orb
	{id = 5944, chance = 50}, -- soul orb
	{id = 6300, chance = 60}, -- death ring
	{id = 6499, chance = 22500}, -- demonic essence
	{id = 6558, chance = 35000, maxCount = 3}, -- concentrated demonic blood
	{id = 7404, chance = 660}, -- assassin dagger
	{id = 7456, chance = 2000}, -- noble axe
	{id = 239, chance = 10500}, -- great health potion
	{id = 8016, chance = 29280, maxCount = 4} -- jalapeno pepper
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -510},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -300, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONAREA, target = false},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -120, maxDamage = -700, length = 8, spread = 3, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -120, maxDamage = -300, radius = 4, target = false},
	-- {name ="fury skill reducer", interval = 2000, chance = 5, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -120, maxDamage = -300, radius = 3, effect = CONST_ME_HITAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -125, maxDamage = -250, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -800, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false, duration = 30000}
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{name ="speed", interval = 2000, chance = 15, speedChange = 800, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 30},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
