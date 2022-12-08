local mType = Game.createMonsterType("Sight of Surrender")
local monster = {}

monster.description = "a sight of surrender"
monster.experience = 17000
monster.outfit = {
	lookType = 583,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1012
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Dark Grounds, Guzzlemaw Valley (if less than 100 Blowing Horns tasks \z
		have been done the day before) and the Silencer Plateau (when Silencer Resonating Chambers are used there)."
	}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "undead"
monster.corpse = 20144
monster.speed = 170
monster.manaCost = 0

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
	{text = "BOW LOW!", yell = false},
	{text = "FEEL THE TRUE MEANING OF VANQUISH!", yell = false},
	{text = "HAHAHAHA DO YOU WANT TO AMUSE YOUR MASTER?", yell = false},
	{text = "NOW YOU WILL SURRENDER!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 15},
	{name = "might ring", chance = 8000},
	{name = "stone skin amulet", chance = 18000},
	{name = "hammer of wrath", chance = 1380},
	{name = "crystal mace", chance = 5500},
	{name = "magic plate armor", chance = 1380},
	{name = "crown legs", chance = 920},
	{name = "crusader helmet", chance = 920},
	{name = "tower shield", chance = 1380},
	{name = "steel boots", chance = 920},
	{name = "onyx flail", chance = 920},
	{name = "jade hammer", chance = 920},
	{name = "great mana potion", chance = 78000, maxCount = 5},
	{name = "great spirit potion", chance = 72000, maxCount = 5},
	{name = "ultimate health potion", chance = 30000, maxCount = 5},
	{name = "blue crystal shard", chance = 23000, maxCount = 3},
	{name = "violet crystal shard", chance = 32000, maxCount = 3},
	{name = "green crystal shard", chance = 21600, maxCount = 3},
	{name = "green crystal splinter", chance = 30000, maxCount = 5},
	{name = "brown crystal splinter", chance = 30410, maxCount = 5},
	{name = "blue crystal splinter", chance = 40000, maxCount = 5},
	{name = "cluster of solace", chance = 1800},
	{name = "sight of surrender's eye", chance = 100000},
	{name = "broken visor", chance = 100000},
	{id = 20208, chance = 460} -- string of mending
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1100},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_YELLOWENERGY, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -500, radius = 1, shootEffect = CONST_ANI_LARGEROCK, target = true}
}

monster.defenses = {
	defense = 70,
	armor = 70,
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 550, maxDamage = 1100, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 520, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 35},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 40},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
