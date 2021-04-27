local mType = Game.createMonsterType("Blood Hand")
local monster = {}

monster.description = "a blood hand"
monster.experience = 750
monster.outfit = {
	lookType = 552,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 974
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Drefia."
	}

monster.health = 700
monster.maxHealth = 700
monster.race = "blood"
monster.corpse = 21257
monster.speed = 192
monster.manaCost = 0
monster.maxSummons = 0

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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
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
	{text = "Blood for the dark god!", yell = false},
	{text = "For the Blood God!", yell = false},
	{text = "Die, filth!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 130},
	{name = "necrotic rod", chance = 3000},
	{name = "boots of haste", chance = 210},
	{name = "skull staff", chance = 130},
	{name = "mystic turban", chance = 790},
	{name = "white piece of cloth", chance = 840},
	{name = "red piece of cloth", chance = 500},
	{name = "noble axe", chance = 10},
	{name = "strong mana potion", chance = 5590},
	{name = "spellbook of enlightenment", chance = 790},
	{name = "book of necromantic rituals", chance = 9340},
	{name = "red gem", chance = 710},
	{name = "lancet", chance = 10680},
	{name = "horoscope", chance = 7950},
	{name = "blood tincture in a vial", chance = 15460},
	{name = "incantation notes", chance = 8820},
	{name = "pieces of magic chalk", chance = 6120}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -158, condition = {type = CONDITION_POISON, totalDamage = 80, interval = 4000}},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -100, radius = 4, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="speed", interval = 2000, chance = 10, speedChange = -600, radius = 4, effect = CONST_ME_BLOCKHIT, target = true, duration = 15000},
	-- bleed
	{name ="condition", type = CONDITION_BLEEDING, interval = 2000, chance = 15, minDamage = -120, maxDamage = -160, radius = 6, effect = CONST_ME_HITAREA, target = false}
}

monster.defenses = {
	defense = 25,
	armor = 25,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 70, maxDamage = 90, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="effect", interval = 2000, chance = 10, radius = 1, effect = CONST_ME_INSECTS, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 5},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
