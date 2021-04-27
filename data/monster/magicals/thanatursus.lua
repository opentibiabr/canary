local mType = Game.createMonsterType("Thanatursus")
local monster = {}

monster.description = "a Thanatursus"
monster.experience = 6300
monster.outfit = {
	lookType = 1134,
	lookHead = 19,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1728
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Haunted Temple, Court of Winter, Dream Labyrinth."
	}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "blood"
monster.corpse = 34707
monster.speed = 400
monster.manaCost = 0
monster.maxSummons = 0

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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Uuuuuuuuuaaaaaarg!!!", yell = false},
	{text = "Nobody will ever escape from this place, muwahaha!!!", yell = false}
}

monster.loot = {
	{name = "Platinum Coin", chance = 100000, maxCount = 17},
	{name = "Meat", chance = 90000, maxCount = 3},
	{name = "Great Spirit Potion", chance = 50000, maxCount = 3},
	{name = "Ultimate Health Potion", chance = 50000},
	{name = "Essence of a Bad Dream", chance = 17000},
	{name = "Knight Axe", chance = 14000},
	{name = "Mino Shield", chance = 12000},
	{name = "Terra Boots", chance = 7000},
	{name = "Terra Hood", chance = 6400},
	{name = "Beastslayer Axe", chance = 500},
	{name = "Black Shield", chance = 3500},
	{name = "Bloody Pincers", chance = 4200},
	{name = "Dark Shield", chance = 1500},
	{name = "Obsidian Lance", chance = 1500},
	{name = "Sickle", chance = 1100},
	{name = "Titan Axe", chance = 1100},
	{name = "Wand of Cosmic Energy", chance = 400},
	{name = "Wand of Defiance", chance = 400},
	{name = "Warrior's Axe", chance = 400},
	{name = "Warrior's Shield", chance = 400}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -450},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -250, maxDamage = -400, radius = 3, effect = CONST_ME_HOLYAREA, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -280, maxDamage = -450, length = 4, spread = 3, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -400, radius = 6, effect = CONST_ME_BLOCKHIT, target = true}
}

monster.defenses = {
	defense = 25,
	armor = 78,
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_HEALING, minDamage = 150, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -30},
	{type = COMBAT_ENERGYDAMAGE, percent = -50},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
