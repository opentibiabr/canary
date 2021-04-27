local mType = Game.createMonsterType("Stone Devourer")
local monster = {}

monster.description = "a stone devourer"
monster.experience = 2900
monster.outfit = {
	lookType = 486,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 879
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 1."
	}

monster.health = 4200
monster.maxHealth = 4200
monster.race = "undead"
monster.corpse = 18375
monster.speed = 300
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 1,
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
	{text = "Rumble!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 100},
	{name = "platinum coin", chance = 92000, maxCount = 7},
	{name = "stone skin amulet", chance = 2270},
	{name = "dwarven ring", chance = 2840},
	{name = "giant sword", chance = 570},
	{name = "crystal mace", chance = 850},
	{name = "war axe", chance = 920},
	{name = "sapphire hammer", chance = 1490},
	{name = "spiked squelcher", chance = 1490},
	{name = "glorious axe", chance = 3340},
	{name = "strong health potion", chance = 13840, maxCount = 2},
	{name = "strong mana potion", chance = 14900, maxCount = 2},
	{name = "great mana potion", chance = 15610, maxCount = 2},
	{name = "mana potion", chance = 15050, maxCount = 2},
	{name = "ultimate health potion", chance = 14410},
	{id = 8748, chance = 11360},
	{name = "ancient stone", chance = 12850},
	{name = "crystalline arrow", chance = 9940, maxCount = 10},
	{name = "green crystal splinter", chance = 6960},
	{name = "cyan crystal fragment", chance = 6810},
	{name = "stone nose", chance = 18679},
	{name = "crystalline spikes", chance = 16320}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -990},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -230, maxDamage = -460, range = 7, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_STONES, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -650, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -150, maxDamage = -260, length = 5, spread = 3, effect = CONST_ME_STONES, target = false}
}

monster.defenses = {
	defense = 35,
	armor = 35
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 1},
	{type = COMBAT_ENERGYDAMAGE, percent = 30},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 30},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = 1}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
