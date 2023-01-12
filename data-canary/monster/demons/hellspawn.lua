--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Hellspawn")
local monster = {}

monster.description = "a hellspawn"
monster.experience = 2550
monster.outfit = {
	lookType = 322,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 519
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Magician Quarter, Vengoth, Deeper Banuta, Formorgar Mines, Chyllfroest, Oramond Dungeon."
	}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "fire"
monster.corpse = 9009
monster.speed = 172
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15
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
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Your fragile bones are like toothpicks to me.", yell = false},
	{text = "You little weasel will not live to see another day.", yell = false},
	{text = "I'm just a messenger of what's yet to come.", yell = false},
	{text = "HRAAAAAAAAAAAAAAAARRRR!", yell = true},
	{text = "I'm taking you down with me!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 60000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 60000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 60000, maxCount = 36}, -- gold coin
	{id = 3282, chance = 10000}, -- morning star
	{id = 3369, chance = 1886}, -- warrior helmet
	{id = 3371, chance = 3030}, -- knight legs
	{id = 3724, chance = 7692, maxCount = 2}, -- red mushroom
	{id = 6499, chance = 9090}, -- demonic essence
	{id = 7368, chance = 9090, maxCount = 2}, -- assassin star
	{id = 7421, chance = 103}, -- onyx flail
	{id = 7439, chance = 934}, -- berserk potion
	{id = 7452, chance = 970}, -- spiked squelcher
	{id = 239, chance = 40333}, -- great health potion
	{id = 7643, chance = 9090}, -- ultimate health potion
	{id = 8895, chance = 3125}, -- rusted armor
	{id = 8896, chance = 3125}, -- slightly rusted armor
	{id = 9034, chance = 140}, -- dracoyle statue
	{id = 9056, chance = 151}, -- black skull
	{id = 9057, chance = 5882, maxCount = 3}, -- small topaz
	{id = 10304, chance = 20000} -- hellspawn tail
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -352},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -175, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = false},
	-- {name ="hellspawn soulfire", interval = 2000, chance = 10, range = 5, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 120, maxDamage = 230, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 270, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 80},
	{type = COMBAT_FIREDAMAGE, percent = 40},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
