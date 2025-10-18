local mType = Game.createMonsterType("Foam Stalker")
local monster = {}

monster.description = "a foam stalker"
monster.experience = 3120
monster.outfit = {
	lookType = 1562,
}

monster.raceId = 2259
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Great Pearl Fan Reef",
}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 39344
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 2,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "splash", yell = false },
	{ text = "gurgle", yell = false },
	{ text = "dribble", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 20 }, -- Platinum Coin
	{ id = 237, chance = 7234 }, -- Strong Mana Potion
	{ id = 819, chance = 6505 }, -- Glacier Shoes
	{ id = 3026, chance = 6883 }, -- White Pearl
	{ id = 3027, chance = 6163 }, -- Black Pearl
	{ id = 3125, chance = 7435 }, -- Remains of a Fish
	{ id = 3130, chance = 7901 }, -- Twigs
	{ id = 3269, chance = 12663 }, -- Halberd
	{ id = 3271, chance = 7495 }, -- Spike Sword
	{ id = 3289, chance = 7524 }, -- Staff
	{ id = 3292, chance = 7860 }, -- Combat Knife
	{ id = 5021, chance = 6948 }, -- Orichalcum Pearl
	{ id = 39406, chance = 4620 }, -- Coral Branch
	{ id = 39407, chance = 5347 }, -- Flotsam
	{ id = 281, chance = 2619 }, -- Giant Shimmering Pearl (Green)
	{ id = 813, chance = 2435 }, -- Terra Boots
	{ id = 3028, chance = 3620 }, -- Small Diamond
	{ id = 3032, chance = 4050, maxCount = 2 }, -- Small Emerald
	{ id = 5944, chance = 5347 }, -- Soul Orb
	{ id = 3036, chance = 560 }, -- Violet Gem
	{ id = 3371, chance = 1517 }, -- Knight Legs
	{ id = 7386, chance = 1271 }, -- Mercenary Sword
	{ id = 50152, chance = 1000 }, -- Collar of Orange Plasma
	{ id = 3048, chance = 960 }, -- Might Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -300 },
	{ name = "foamsplash", interval = 5000, chance = 50, minDamage = -100, maxDamage = -300 },
	{ name = "combat", interval = 2500, chance = 35, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -300, length = 6, spread = 0, effect = CONST_ME_LOSEENERGY },
	{ name = "combat", interval = 2000, chance = 45, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -300, range = 4, radius = 1, target = true, effect = CONST_ME_ICEATTACK, shootEffect = CONST_ANI_ICE },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -300, radius = 4, target = false, effect = CONST_ME_ICEAREA },
}

monster.defenses = {
	defense = 64,
	armor = 64,
	mitigation = 1.74,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 80, maxDamage = 113 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
