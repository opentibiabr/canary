local mType = Game.createMonsterType("Tentuglys Head")
local monster = {}

monster.description = "a tentuglys head"
monster.experience = 40000
monster.outfit = {
	lookTypeEx = 35105
}

monster.health = 0 --?
monster.maxHealth = 0 --?
monster.race = "blood"
monster.corpse = 35600
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 10,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = true,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.loot = {
	{name = "crystal coin", chance = 68480, maxCount =2},
	{name = "ultimate health potion", chance = 59780, maxCount =20},
	{name = "ultimate mana potion", chance = 59780, maxCount =20},
 	{name = "platinum coin", chance = 23910, maxCount =10},
	{name = "ultimate spirit potion", chance = 23910, maxCount =10},
	{name = "mastermind potion", chance = 19570, maxCount =5},
	{name = "berserk potion", chance = 18480, maxCount =5},
	{name = "bullseye potion", chance = 1630, maxCount =5},
	{name = "pirate coin", chance = 15220, maxCount =50},
	{name = "small treasure chest", chance = 8700},
	{name = "golden dustbin", chance = 6520},
	{name = "giant amethyst", chance = 5430},
	{name = "giant ruby", chance = 4350},
	{name = "tentugly's eye", chance = 4350},
	{name = "tiara", chance = 4350},
	{name = "giant topaz", chance = 3260},
	{name = "golden skull", chance = 3260},
	{name = "golden cheese wedge", chance = 2170},
	{name = "tentacle of tentugly", chance = 2170},
	{name = "plushie of tentugly", chance = 1090}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -700},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -160, maxDamage = -250, range = 6, shootEffect = CONST_ANI_ENERGYBALL, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DROWNDAMAGE, minDamage = -150, maxDamage = -180, radius = 8, effect = CONST_ME_WATERSPLASH, target = false},
	{name ="condition", type = CONDITION_DROWN, interval = 2000, chance = 10, minDamage = -180, maxDamage = -300, radius = 8, effect = CONST_ME_WATERSPLASH, target = false},
}

monster.defenses = {
	defense = 80,
	armor = 0
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 70},
	{type = COMBAT_EARTHDAMAGE, percent = -130},
	{type = COMBAT_FIREDAMAGE, percent = -120},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
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
