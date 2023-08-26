local mType = Game.createMonsterType("Two-Headed Turtle")
local monster = {}

monster.description = "a two-headed turtle"
monster.experience = 2930
monster.outfit = {
	lookType = 1535,
}

monster.raceId = 2258
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Great Pearl Fan Reef"
}

monster.health = 5010
monster.maxHealth = 5010
monster.race = "blood"
monster.corpse = 39212
monster.speed = 170
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{text = "Krk! Krk!", yell = false},
	{text = "BONK!", yell = false}
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
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = -20},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -300},
	{name ="combat", interval = 2500, chance = 35, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -300, radius = 4, target = false, effect = CONST_ME_ENERGYHIT},
	{name ="combat", interval = 2000, chance = 35, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -300, radius = 3, target = true, effect = CONST_ME_GHOSTLYBITE},
	{name ="combat", interval = 3000, chance = 45, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -300, range = 1, radius = 1, target = true, effect = CONST_ME_EXPLOSIONAREA}
}

monster.defenses = {
	defense = 72,
	armor = 72
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 80},
	{name = "great health potion", chance = 15701},
	{name = "two-headed turtle heads", chance = 15000},
	{name = "strong mana potion", chance = 13373},
	{name = "hydrophytes", chance = 9552},
	{id = 1047, chance = 6388}, -- bone
	{name = "glacier shoes", chance = 6239},
	{id = 281, chance = 3582}, -- giant shimmering pearl (green)
	{name = "small tropical fish", chance = 3582},
	{name = "coral brooch", chance = 3343},
	{name = "silver brooch", chance = 2507},
	{name = "lightning headband", chance = 6448},
	{name = "knight legs", chance = 7269},
	{name = "gemmed figurine", chance = 2090},
	{name = "emerald bangle", chance = 1373},
	{name = "terra amulet", chance = 1373},
	{id = 3040, chance = 1313}, -- "gold nugget"
	{name = "spellbook of enlightenment", chance = 6134},
	{id = 3565, chance = 1015}, -- "cape"
	{id = 10422, chance = 657}, -- "clay lump"
	{name = "white gem", chance = 418}
}

mType:register(monster)