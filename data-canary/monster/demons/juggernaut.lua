--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Juggernaut")
local monster = {}

monster.description = "a juggernaut"
monster.experience = 11200
monster.outfit = {
	lookType = 244,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 296
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Deep in Pits of Inferno (Apocalypse's throne room), The Dark Path, \z
		The Blood Halls, The Vats, The Hive, The Shadow Nexus, a room deep in Formorgar Mines, Roshamuul Prison, Oramond Dungeon, Grounds of Destruction."
	}

monster.health = 20000
monster.maxHealth = 20000
monster.race = "blood"
monster.corpse = 6335
monster.speed = 170
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 60,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{text = "RAAARRR!", yell = false},
	{text = "GRRRRRR!", yell = false},
	{text = "WAHHHH!", yell = false}
}

monster.loot = {
	{id = 3019, chance = 550}, -- demonbone amulet
	{id = 3030, chance = 20000, maxCount = 4}, -- small ruby
	{id = 3031, chance = 100000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 100000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 100000, maxCount = 100}, -- gold coin
	{id = 3031, chance = 100000, maxCount = 100}, -- gold coin
	{id = 3032, chance = 20000, maxCount = 5}, -- small emerald
	{id = 3035, chance = 100000, maxCount = 15}, -- platinum coin
	{id = 3036, chance = 830}, -- violet gem
	{id = 3038, chance = 869}, -- green gem
	{id = 3039, chance = 13850}, -- red gem
	{id = 3322, chance = 9000}, -- dragon hammer
	{id = 3340, chance = 400}, -- heavy mace
	{id = 3342, chance = 400}, -- war axe
	{id = 3360, chance = 550}, -- golden armor
	{id = 3364, chance = 500}, -- golden legs
	{id = 3370, chance = 4990}, -- knight armor
	{id = 3414, chance = 800}, -- mastermind shield
	{id = 3481, chance = 280}, -- closed trap
	{id = 3582, chance = 60000, maxCount = 8}, -- ham
	{id = 5944, chance = 33333}, -- soul orb
	{id = 6499, chance = 45333}, -- demonic essence
	{id = 6558, chance = 25000, maxCount = 4}, -- concentrated demonic blood
	{id = 7365, chance = 11111, maxCount = 15}, -- onyx arrow
	{id = 7368, chance = 25000, maxCount = 10}, -- assassin star
	{id = 7413, chance = 4430}, -- titan axe
	{id = 7452, chance = 7761}, -- spiked squelcher
	{id = 238, chance = 35000}, -- great mana potion
	{id = 239, chance = 32000}, -- great health potion
	{id = 8061, chance = 400}, -- skullcracker armor
	{id = 9058, chance = 7692, maxCount = 2} -- gold ingot
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1470},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -780, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false}
}

monster.defenses = {
	defense = 60,
	armor = 60,
	{name ="speed", interval = 2000, chance = 15, speedChange = 520, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 40},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
