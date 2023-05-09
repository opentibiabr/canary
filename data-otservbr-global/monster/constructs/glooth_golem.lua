local mType = Game.createMonsterType("Glooth Golem")
local monster = {}

monster.description = "a glooth golem"
monster.experience = 1606
monster.outfit = {
	lookType = 600,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1038
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Glooth Factory, Underground Glooth Factory, Rathleton Sewers, Jaccus Maxxens Dungeon, \z
		Oramond Dungeon (depending on Magistrate votes)."
	}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "venom"
monster.corpse = 20972
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	canWalkOnFire = false,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "*slosh*", yell = false},
	{text = "*clank*", yell = false}
}

monster.loot = {
	{id = 5880, chance = 530}, -- iron ore
	{id = 21183, chance = 720}, -- glooth amulet
	{id = 21170, chance = 1720}, -- gearwheel chain
	{id = 21165, chance = 370}, -- rubber cap
	{id = 3031, chance = 100000, maxCount = 200}, -- gold coin
	{id = 21755, chance = 1470}, -- bronze gear wheel
	{id = 8775, chance = 690}, -- gear wheel
	{id = 21143, chance = 1970}, -- glooth sandwich
	{id = 3035, chance = 6010, maxCount = 4}, -- platinum coin
	{id = 21103, chance = 2840}, -- glooth injection tube
	{id = 7643, chance = 4470}, -- ultimate health potion
	{id = 238, chance = 9280}, -- great mana potion
	{id = 21167, chance = 690}, -- heat core
	{id = 21179, chance = 440}, -- glooth blade
	{id = 21178, chance = 230}, -- glooth club
	{id = 21180, chance = 290}, -- glooth axe
	{id = 3037, chance = 730}, -- yellow gem
	{id = 9057, chance = 1560, maxCount = 4}, -- small topaz
	{id = 3032, chance = 1590, maxCount = 4} -- small emerald
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 60, attack = 50},
	{name ="melee", interval = 2000, chance = 2, skill = 86, attack = 100},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -125, maxDamage = -245, range = 7, shootEffect = CONST_ANI_ENERGY, target = false},
	{name ="war golem skill reducer", interval = 2000, chance = 16, target = false},
	{name ="war golem electrify", interval = 2000, chance = 9, range = 7, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{name ="speed", interval = 2000, chance = 13, speedChange = 404, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 5},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 15},
	{type = COMBAT_DEATHDAMAGE , percent = 30}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
