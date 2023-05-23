local mType = Game.createMonsterType("Mammoth")
local monster = {}

monster.description = "a mammoth"
monster.experience = 160
monster.outfit = {
	lookType = 199,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 260
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Formorgar Glacier, Tyrsung, around the Barbarian Settlements, Mammoth Shearing Factory, Chyllfroest."
	}

monster.health = 320
monster.maxHealth = 320
monster.race = "blood"
monster.corpse = 6074
monster.speed = 95
monster.manaCost = 500

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
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
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
	{text = "Troooooot!", yell = false},
	{text = "Hooooot-Toooooot!", yell = false},
	{text = "Tooooot.", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 90000, maxCount = 40},
	{name = "meat", chance = 39000},
	{name = "ham", chance = 30000, maxCount = 3},
	{name = "tusk shield", chance = 500},
	{name = "mammoth whopper", chance = 2800},
	{name = "furry club", chance = 500},
	{name = "thick fur", chance = 7280},
	{name = "mammoth tusk", chance = 7500, maxCount = 2}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110}
}

monster.defenses = {
	defense = 25,
	armor = 20
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
