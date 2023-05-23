local mType = Game.createMonsterType("Midnight Asura")
local monster = {}

monster.description = "a midnight asura"
monster.experience = 4100
monster.outfit = {
	lookType = 150,
	lookHead = 0,
	lookBody = 114,
	lookLegs = 90,
	lookFeet = 90,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 1135
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Asura Palace."
	}

monster.health = 3100
monster.maxHealth = 3100
monster.race = "blood"
monster.corpse = 21988
monster.speed = 120
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
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Death and Darkness!", yell = false},
	{text = "Embrace the night!", yell = false},
	{text = "May night fall upon you!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 97000, maxCount = 242}, -- gold coin
	{id = 3035, chance = 18200, maxCount = 6}, -- platinum coin
	{id = 7368, chance = 2000, maxCount = 2}, -- assassin star
	{id = 3027, chance = 2000}, -- black pearl
	{id = 6558, chance = 2000}, -- flask of demonic blood
	{id = 6499, chance = 2210}, -- demonic essence
	{id = 3028, chance = 800, maxCount = 3}, -- small diamond
	{id = 3032, chance = 900, maxCount = 3}, -- small emerald
	{id = 3030, chance = 650, maxCount = 3}, -- small ruby
	{id = 3029, chance = 580, maxCount = 3}, -- small sapphire
	{id = 9057, chance = 580, maxCount = 3}, -- small topaz
	{id = 239, chance = 700}, -- great health potion
	{id = 3026, chance = 560}, -- white pearl
	{id = 7404, chance = 130}, -- assassin dagger
	{id = 3041, chance = 320}, -- blue gem
	{id = 3567, chance = 300}, -- blue robe
	{id = 9058, chance = 300}, -- gold ingot
	{id = 21974, chance = 300}, -- golden lotus brooch
	{id = 3070, chance = 300}, -- moonlight rod
	{id = 3069, chance = 90}, -- necrotic rod
	{id = 21981, chance = 80}, -- oriental shoes
	{id = 21975, chance = 200}, -- peacock feather fan
	{id = 8061, chance = 90}, -- skullcracker armor
	{id = 3017, chance = 100}, -- silver brooch
	{id = 3054, chance = 100}, -- silver amulet
	{id = 5944, chance = 100}, -- soul orb
	{id = 8074, chance = 100}, -- spellbook of mind control
	{id = 3403, chance = 100}, -- tribal mask
	{id = 8082, chance = 70}, -- underworld rod
	{id = 3037, chance = 100} -- yellow gem
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -269},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -70, range = 7, target = false},
	{name ="firefield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -200, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="energy strike", interval = 2000, chance = 10, minDamage = -10, maxDamage = -100, range = 1, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -100, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000}
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
