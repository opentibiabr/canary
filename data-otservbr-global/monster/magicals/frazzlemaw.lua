local mType = Game.createMonsterType("Frazzlemaw")
local monster = {}

monster.description = "a frazzlemaw"
monster.experience = 3740
monster.outfit = {
	lookType = 594,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"RoshamuulKillsDeath",
}

monster.raceId = 1022
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Lower Roshamuul, Guzzlemaw Valley, the entrance to Upper Roshamuul.",
}

monster.health = 4100
monster.maxHealth = 4100
monster.race = "blood"
monster.corpse = 20233
monster.speed = 200
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
	rewardBoss = false,
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
	{ text = "Mwaaahgod! Overmwaaaaah! *gurgle*", yell = false },
	{ text = "Mwaaaahnducate youuuuuu *gurgle*, mwaaah!", yell = false },
	{ text = "MMMWAHMWAHMWAHMWAAAAH!", yell = true },
	{ text = "Mmmwhamwhamwhah, mwaaah!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 90252, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 95586, maxCount = 7 }, -- Platinum Coin
	{ id = 238, chance = 13271, maxCount = 3 }, -- Great Mana Potion
	{ id = 239, chance = 13547, maxCount = 2 }, -- Great Health Potion
	{ id = 20199, chance = 13922 }, -- Frazzle Skin
	{ id = 20198, chance = 16486 }, -- Frazzle Tongue
	{ id = 16123, chance = 13619 }, -- Brown Crystal Splinter
	{ id = 3114, chance = 10796 }, -- Skull (Item)
	{ id = 5951, chance = 9345 }, -- Fish Tail
	{ id = 3104, chance = 8981 }, -- Banana Skin
	{ id = 3110, chance = 8876 }, -- Piece of Iron
	{ id = 3111, chance = 9373 }, -- Fishbone
	{ id = 3125, chance = 8983 }, -- Remains of a Fish
	{ id = 3115, chance = 9135 }, -- Bone
	{ id = 16279, chance = 9130 }, -- Crystal Rubbish
	{ id = 3578, chance = 5780, maxCount = 3 }, -- Fish
	{ id = 16126, chance = 4549 }, -- Red Crystal Fragment
	{ id = 3582, chance = 5290, maxCount = 2 }, -- Ham
	{ id = 3116, chance = 4350 }, -- Big Bone
	{ id = 5895, chance = 4621 }, -- Fish Fin
	{ id = 5925, chance = 4672 }, -- Hardened Bone
	{ id = 16120, chance = 2789 }, -- Violet Crystal Shard
	{ id = 5880, chance = 2852 }, -- Iron Ore
	{ id = 7407, chance = 1770 }, -- Haunted Blade
	{ id = 3265, chance = 2598 }, -- Two Handed Sword
	{ id = 9058, chance = 2226 }, -- Gold Ingot
	{ id = 10389, chance = 200 }, -- Traditional Sai
	{ id = 7418, chance = 659 }, -- Nightmare Blade
	{ id = 7404, chance = 774 }, -- Assassin Dagger
	{ id = 20062, chance = 435 }, -- Cluster of Solace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 10, minDamage = -300, maxDamage = -400, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -700, length = 5, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -400, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -80, maxDamage = -150, radius = 4, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 74,
	mitigation = 2.31,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 425, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
