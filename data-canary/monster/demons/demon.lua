--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Demon")
local monster = {}

monster.description = "a demon"
monster.experience = 6000
monster.outfit = {
	lookType = 35,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 35
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Hero Cave, Ferumbras' Citadel, Goroma, Ghostlands (Warlock area; unreachable), \z
		Liberty Bay (hidden underground passage; unreachable), Razzachai, deep in Pits of Inferno \z
		(found in every throneroom except Verminor's), deep Formorgar Mines, Demon Forge, \z
		Alchemist Quarter, Magician Quarter, Chyllfroest, Oramond Dungeon, Abandoned Sewers."
	}

monster.health = 8200
monster.maxHealth = 8200
monster.race = "fire"
monster.corpse = 5995
monster.speed = 128
monster.manaCost = 0
monster.maxSummons = 1

monster.changeTarget = {
	interval = 4000,
	chance = 20
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
	maxSummons = 1,
	summons = {
		{name = "fire elemental", chance = 10, interval = 2000}
	}
}

monster.sounds = {
	ticks = 5000,
	chance = 10,
	death = SOUND_EFFECT_TYPE_DEMON_DEATH,
	ids = {
		SOUND_EFFECT_TYPE_DEMON_BARK,
		SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_1
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Your soul will be mine!", yell = false},
	{text = "MUHAHAHAHA!", yell = false},
	{text = "CHAMEK ATH UTHUL ARAK!", yell = false},
	{text = "I SMELL FEEEEAAAAAR!", yell = false},
	{text = "Your resistance is futile!", yell = false}
}

monster.loot = {
	{id = 2848, chance = 1180}, -- purple tome
	{id = 3031, chance = 60000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 60000, maxCount = 100}, -- gold coin
	{id = 3032, chance = 9690, maxCount = 5}, -- small emerald
	{id = 3033, chance = 7250, maxCount = 5}, -- small amethyst
	{id = 3030, chance = 7430, maxCount = 5}, -- small ruby
	{id = 9057, chance = 7470, maxCount = 5}, -- small topaz
	{id = 3039, chance = 2220}, -- red gem
	{id = 6499, chance = 14630}, -- demonic essence
	{id = 3034, chance = 3430}, -- talon
	{id = 3035, chance = 90540, maxCount = 8}, -- platinum coin
	{id = 3048, chance = 1890}, -- might ring
	{id = 3049, chance = 2170}, -- stealth ring
	{id = 3055, chance = 680}, -- platinum amulet
	{id = 3060, chance = 2854}, -- orb
	{id = 3063, chance = 1050}, -- gold ring
	{id = 3098, chance = 1990}, -- ring of healing
	{id = 3281, chance = 1980}, -- giant sword
	{id = 3284, chance = 1550}, -- ice rapier
	{id = 3306, chance = 1440}, -- golden sickle
	{id = 3320, chance = 4030}, -- fire axe
	{id = 3356, chance = 1180}, -- devil helmet
	{id = 3364, chance = 440}, -- golden legs
	{id = 3366, chance = 130}, -- magic plate armor
	{id = 3414, chance = 480}, -- mastermind shield
	{id = 3420, chance = 740}, -- demon shield
	{id = 3731, chance = 19660, maxCount = 6}, -- fire mushroom
	{id = 5954, chance = 14920}, -- demon horn
	{id = 7368, chance = 12550, maxCount = 10}, -- assassin star
	{id = 7382, chance = 70}, -- demonrage sword
	{id = 7393, chance = 90}, -- demon trophy
	{id = 238, chance = 22220, maxCount = 3}, -- great mana potion
	{id = 7643, chance = 19540, maxCount = 3}, -- ultimate health potion
	{id = 7642, chance = 18510, maxCount = 3} -- great spirit potion
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -520},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -120, range = 7, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -250, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="firefield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -490, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -210, maxDamage = -300, range = 1, shootEffect = CONST_ANI_ENERGY, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -700, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000}
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 180, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 30}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
