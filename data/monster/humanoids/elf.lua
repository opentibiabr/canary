local mType = Game.createMonsterType("Elf")
local monster = {}

monster.description = "an elf"
monster.experience = 42
monster.outfit = {
	lookType = 62,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 62
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Yalahar Foreigner Quarter and Trade Quarter, Maze of Lost Souls, Orc Fort (unreachable), \z
		Hellgate, Shadowthorn, Ab'Dendriel elf caves, Elvenbane, north of Thais."
	}

monster.health = 100
monster.maxHealth = 100
monster.race = "blood"
monster.corpse = 6003
monster.speed = 190
monster.manaCost = 320
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
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
	{text = "Ulathil beia Thratha!", yell = false},
	{text = "Bahaha aka!", yell = false},
	{text = "You are not welcome here.", yell = false},
	{text = "Flee as long as you can.", yell = false},
	{text = "Death to the Defilers!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 44000, maxCount = 30},
	{name = "longsword", chance = 10800},
	{name = "studded helmet", chance = 13500},
	{name = "studded armor", chance = 8960},
	{name = "plate shield", chance = 9300},
	{name = "arrow", chance = 7060, maxCount = 3},
	{name = "leather boots", chance = 11410},
	{id = 5921, chance = 940},
	{name = "plum", chance = 20000, maxCount = 2},
	{name = "elvish talisman", chance = 2100}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -15},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -25, range = 7, shootEffect = CONST_ANI_ARROW, target = false}
}

monster.defenses = {
	defense = 10,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = -1}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
