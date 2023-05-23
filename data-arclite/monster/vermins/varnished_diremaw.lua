local mType = Game.createMonsterType("Varnished Diremaw")
local monster = {}

monster.description = "a varnished diremaw"
monster.experience = 5900
monster.outfit = {
	lookType = 1397,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 2090
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Dwelling of the Forgotten"
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 36688
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "*bluuuuuure*", yell = false},
	{text = "*slurp slurp ... slurp*", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 70000, maxCount = 18},
	{name = "terra rod", chance = 30090},
	{name = "emerald bangle", chance = 18580, maxCount = 1},
	{name = "brown crystal splinter", chance = 8850, maxCount = 3},
	{id = 3039, chance = 10620, maxCount = 1}, -- red gem
	{name = "green crystal splinter", chance = 6190, maxCount = 3},
	{name = "small diamond", chance = 9730, maxCount = 6},
	{name = "varnished diremaw legs", chance = 13270, maxCount = 4},
	{name = "violet crystal shard", chance = 9730, maxCount = 3},
	{name = "cyan crystal fragment", chance = 5310},
	{name = "varnished diremaw brainpan", chance = 2650},
	{name = "green gem", chance = 6190, maxCount = 1},
	{name = "small emerald", chance = 9730, maxCount = 5},
	{name = "green crystal shard", chance = 11500, maxCount = 3},
	{name = "hailstorm rod", chance = 6190},
	{name = "diamond sceptre", chance = 2650},
	{name = "wand of starstorm", chance = 2650},
	{name = "springsprout rod", chance = 7080},
	{name = "glacier shoes", chance = 2650},
	{name = "spellbook of warding", chance = 1770},
	{name = "fur armor", chance = 1640},
	{name = "wood cape", chance = 2650},
	{name = "haunted blade", chance = 1370},
	{name = "glacier kilt", chance = 880},
	{name = "crown shield", chance = 880}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_ICEDAMAGE, minDamage = -700, maxDamage = -750, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true}, -- avalanche
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_HOLYDAMAGE, minDamage = -730, maxDamage = -750, radius = 3, effect = CONST_ME_HOLYAREA, target = false},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_ICEDAMAGE, minDamage = -800, maxDamage = -850, range = 4, shootEffect = CONST_ANI_ICE, target = true},
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = -5},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 5},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
