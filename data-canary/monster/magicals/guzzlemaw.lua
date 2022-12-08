--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Guzzlemaw")
local monster = {}

monster.description = "a guzzlemaw"
monster.experience = 6050
monster.outfit = {
	lookType = 584,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1013
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Guzzlemaw Valley, and a single spawn in a tower in Upper Roshamuul \z
		(south of the Depot and west of the entrance to Roshamuul Prison)."
	}

monster.health = 6400
monster.maxHealth = 6400
monster.race = "blood"
monster.corpse = 20151
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 100}, -- gold coin
	{id = 3035, chance = 100000, maxCount = 7}, -- platinum coin
	{id = 3104, chance = 10700}, -- banana skin
	{id = 3110, chance = 10500}, -- piece of iron
	{id = 3111, chance = 9500}, -- fishbone
	{id = 3114, chance = 10400}, -- skull
	{id = 3115, chance = 9200}, -- bone
	{id = 3116, chance = 4500}, -- big bone
	{id = 3265, chance = 2700}, -- two handed sword
	{id = 3578, chance = 7000, maxCount = 3}, -- fish
	{id = 3582, chance = 10000}, -- ham
	{id = 5880, chance = 3000}, -- iron ore
	{id = 5895, chance = 5000}, -- fish fin
	{id = 5925, chance = 5700}, -- hardened bone
	{id = 5951, chance = 9400}, -- fish tail
	{id = 7404, chance = 1000}, -- assassin dagger
	{id = 7407, chance = 2000}, -- haunted blade
	{id = 7418, chance = 380}, -- nightmare blade
	{id = 238, chance = 17000, maxCount = 3}, -- great mana potion
	{id = 239, chance = 18500, maxCount = 2}, -- great health potion
	{id = 10389, chance = 1200}, -- sai
	{id = 16120, chance = 3000}, -- violet crystal shard
	{id = 16123, chance = 12000, maxCount = 2}, -- brown crystal splinter
	{id = 16126, chance = 7600}, -- red crystal fragment
	{id = 16279, chance = 12000}, -- crystal rubbish
	{id = 20062, chance = 920}, -- cluster of solace
	{id = 20198, chance = 15000}, -- frazzle tongue
	{id = 20199, chance = 14000} -- frazzle skin
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -499},
	-- bleed
	{name ="condition", type = CONDITION_BLEEDING, interval = 2000, chance = 10, minDamage = -500, maxDamage = -1000, radius = 3, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -900, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -500, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true},
	{name ="speed", interval = 2000, chance = 15, speedChange = -800, radius = 6, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false}
}

monster.defenses = {
	defense = 50,
	armor = 50,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 250, maxDamage = 425, effect = CONST_ME_HITBYPOISON, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 15},
	{type = COMBAT_FIREDAMAGE, percent = 5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 5},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
