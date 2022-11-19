local mType = Game.createMonsterType("Foam Stalker")
local monster = {}

monster.description = "a foam stalker"
monster.experience = 3120
monster.outfit = {
	lookType = 1562,
}

monster.raceId = 2259
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Great Pearl Fan Reef"
}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 39344
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 2,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "splash", yell = false},
	{text = "gurgle", yell = false},
	{text = "dribble", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -30},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 80},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -300},
	{name ="foamsplash", interval = 5000, chance = 50, minDamage = -100, maxDamage = -300},
	{name ="combat", interval = 2500, chance = 35, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -300, length = 6, spread = 0, effect = CONST_ME_LOSEENERGY},
	{name ="combat", interval = 2000, chance = 45, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -300, range = 4, radius = 1, target = true, effect = CONST_ME_ICEATTACK, shootEffect = CONST_ANI_ICE},
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -300, radius = 4, target = false, effect = CONST_ME_ICEAREA}
}

monster.defenses = {
	defense = 64,
	armor = 64,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 80, maxDamage = 113}
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 50},
	{name = "halberd", chance = 11025},
	{name = "strong mana potion", chance = 9728},
	{name = "orichalcum pearl", chance = 9728},
	{name = "spike sword", chance = 8301},
	{name = "combat knife", chance = 7004},
	{name = "flotsam", chance = 6874},
	{name = "white pearl", chance = 6485},
	{id = 3130, chance = 6355}, -- twigs
	{id = 3289, chance = 6355}, -- staff
	{name = "remains of a fish", chance = 5966},
	{name = "glacier shoes", chance = 5707},
	{name = "coral branch", chance = 4929},
	{name = "soul orb", chance = 4929},
	{id = 3027, chance = 4669}, -- black pearl
	{name = "small diamond", chance = 3891},
	{name = "small emerald", chance = 3243, maxCount = 2},
	{id = 281, chance = 2205}, -- giant shimmering pearl (green)
	{name = "terra boots", chance = 5075},
	{name = "mercenary sword", chance = 4167},
	{name = "knight legs", chance = 3649},
	{name = "violet gem", chance = 3389}
}

mType:register(monster)