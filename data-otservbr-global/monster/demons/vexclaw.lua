local mType = Game.createMonsterType("Vexclaw")
local monster = {}

monster.description = "a vexclaw"
monster.experience = 6248
monster.outfit = {
	lookType = 854,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1197
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "The Dungeons of The Ruthless Seven.",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "fire"
monster.corpse = 22776
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Weakness must be culled!", yell = false },
	{ text = "Power is miiiiine!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 91632, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 91847, maxCount = 9 }, -- Platinum Coin
	{ id = 7642, chance = 19080, maxCount = 5 }, -- Great Spirit Potion
	{ id = 238, chance = 19458, maxCount = 5 }, -- Great Mana Potion
	{ id = 22728, chance = 16111 }, -- Vexclaw Talon
	{ id = 6499, chance = 15714 }, -- Demonic Essence
	{ id = 3731, chance = 15884, maxCount = 6 }, -- Fire Mushroom
	{ id = 7643, chance = 15642, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 9057, chance = 7397, maxCount = 5 }, -- Small Topaz
	{ id = 3032, chance = 8024, maxCount = 5 }, -- Small Emerald
	{ id = 3033, chance = 7988, maxCount = 5 }, -- Small Amethyst
	{ id = 3030, chance = 7316, maxCount = 5 }, -- Small Ruby
	{ id = 3037, chance = 3886 }, -- Yellow Gem
	{ id = 3039, chance = 3932 }, -- Red Gem
	{ id = 3284, chance = 3859 }, -- Ice Rapier
	{ id = 3320, chance = 2888 }, -- Fire Axe
	{ id = 3051, chance = 1840 }, -- Energy Ring
	{ id = 3281, chance = 1372 }, -- Giant Sword
	{ id = 3048, chance = 1365 }, -- Might Ring
	{ id = 22727, chance = 929 }, -- Rift Lance
	{ id = 3098, chance = 1176 }, -- Ring of Healing
	{ id = 3356, chance = 736 }, -- Devil Helmet
	{ id = 3055, chance = 615 }, -- Platinum Amulet
	{ id = 3364, chance = 328 }, -- Golden Legs
	{ id = 3420, chance = 529 }, -- Demon Shield
	{ id = 22866, chance = 380 }, -- Rift Bow
	{ id = 22726, chance = 484 }, -- Rift Shield
	{ id = 3414, chance = 360 }, -- Mastermind Shield
	{ id = 22867, chance = 276 }, -- Rift Crossbow
	{ id = 3366, chance = 74 }, -- Magic Plate Armor
	{ id = 7382, chance = 64 }, -- Demonrage Sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 75, attack = 150 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -120, range = 7, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -250, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "choking fear drown", interval = 2000, chance = 20, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -400, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -200, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "firefield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -490, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "energy strike", interval = 2000, chance = 10, minDamage = -210, maxDamage = -300, range = 1, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -300, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 180, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 75 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
