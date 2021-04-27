local mType = Game.createMonsterType("Grimeleech")
local monster = {}

monster.description = "a grimeleech"
monster.experience = 7216
monster.outfit = {
	lookType = 855,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1196
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "The Dungeons of The Ruthless Seven."
	}

monster.health = 9500
monster.maxHealth = 9500
monster.race = "undead"
monster.corpse = 25436
monster.speed = 340
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 3000,
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
	illusionable = true,
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
	{text = "Death... Taste!", yell = true}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 197},
	{name = "platinum coin", chance = 100000, maxCount = 8},
	{name = "great mana potion", chance = 34850, maxCount = 3},
	{name = "great health potion", chance = 34290, maxCount = 3},
	{name = "great spirit potion", chance = 30860, maxCount = 3},
	{name = "concentrated demonic blood", chance = 23400, maxCount = 3},
	{name = "demonic essence", chance = 19240},
	{name = "some grimeleech wings", chance = 19080},
	{name = "fire mushroom", chance = 15360, maxCount = 5},
	{name = "green mushroom", chance = 14800, maxCount = 5},
	{name = "small diamond", chance = 11290, maxCount = 5},
	{name = "small ruby", chance = 10750, maxCount = 5},
	{name = "small topaz", chance = 9660, maxCount = 5},
	{name = "small amethyst", chance = 9640, maxCount = 5},
	{name = "underworld rod", chance = 6890},
	{name = "wand of voodoo", chance = 4810},
	{name = "red gem", chance = 3930},
	{name = "yellow gem", chance = 2900},
	{name = "devil helmet", chance = 1360},
	{name = "magma legs", chance = 1150},
	{name = "demon shield", chance = 1010},
	{name = "nightmare blade", chance = 930},
	{name = "blue gem", chance = 780},
	{name = "rift crossbow", chance = 720},
	{name = "steel boots", chance = 640},
	{name = "rift shield", chance = 620},
	{name = "rift lance", chance = 580},
	{name = "rift bow", chance = 370},
	{name = "abyss hammer", chance = 210},
	{name = "vile axe", chance = 180},
	{name = "magic plate armor", chance = 60}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 70, attack = 80},
	{name ="melee", interval = 2000, chance = 2, skill = 153, attack = 100},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_PHYSICALDAMAGE, minDamage = 100, maxDamage = -565, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -220, length = 8, spread = 3, target = false},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -225, maxDamage = -375, radius = 4, target = false},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -300, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONAREA, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 16, type = COMBAT_HEALING, minDamage = 130, maxDamage = 205, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="effect", interval = 2000, chance = 9, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="effect", interval = 2000, chance = 10, target = false},
	{name ="speed", interval = 2000, chance = 12, speedChange = 532, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 65},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 80}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
