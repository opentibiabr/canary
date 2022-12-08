local mType = Game.createMonsterType("True Midnight Asura")
local monster = {}

monster.description = "a true midnight asura"
monster.experience = 7313
monster.outfit = {
	lookType = 1068,
	lookHead = 0,
	lookBody = 76,
	lookLegs = 53,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 1621
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Asura Palace."
	}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 28617
monster.speed = 170
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
	{id = 3026, chance = 660}, -- white pearl
	{id = 7404, chance = 430}, -- assassin dagger
	{id = 3041, chance = 3420}, -- blue gem
	{id = 3567, chance = 3400}, -- blue robe
	{id = 9058, chance = 400}, -- gold ingot
	{id = 21974, chance = 600}, -- golden lotus brooch
	{id = 3070, chance = 630}, -- moonlight rod
	{id = 3069, chance = 690}, -- necrotic rod
	{id = 21981, chance = 480}, -- oriental shoes
	{id = 21975, chance = 500}, -- peacock feather fan
	{id = 8061, chance = 400}, -- skullcracker armor
	{id = 3017, chance = 600}, -- silver brooch
	{id = 3054, chance = 600}, -- silver amulet
	{id = 5944, chance = 600}, -- soul orb
	{id = 8074, chance = 400}, -- spellbook of mind control
	{id = 3403, chance = 400}, -- tribal mask
	{id = 8082, chance = 400}, -- underworld rod
	{id = 3037, chance = 400} -- yellow gem
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -269},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -70, range = 7, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = 100, maxDamage = 400, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = 100, maxDamage = 400, length = 8, spread = 3, effect = CONST_ME_BLACKSMOKE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -100, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000},
	{name ="drunk", interval = 2000, chance = 10, range = 3, radius = 4, effect = CONST_ME_STUN, target = true, duration = 4000}
}

monster.defenses = {
	defense = 55,
	armor = 75,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000},
	{name ="invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE}
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
