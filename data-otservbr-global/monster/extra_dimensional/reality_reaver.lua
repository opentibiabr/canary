local mType = Game.createMonsterType("Reality Reaver")
local monster = {}

monster.description = "a reality reaver"
monster.experience = 2480
monster.outfit = {
	lookType = 879,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1224
monster.Bestiary = {
	class = "Extra Dimensional",
	race = BESTY_RACE_EXTRA_DIMENSIONAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Otherworld."
	}

monster.health = 3900
monster.maxHealth = 3900
monster.race = "venom"
monster.corpse = 23412
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25
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
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Ssshhh!", yell = false}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 100}, -- gold coin
	{id = 3035, chance = 100000, maxCount = 6}, -- platinum coin
	{id = 23545, chance = 15000}, -- energy drink
	{id = 23535, chance = 15000}, -- energy bar
	{id = 23508, chance = 15000}, -- energy vein
	{id = 23520, chance = 14700}, -- plasmatic lightning
	{id = 7642, chance = 11400, maxCount = 2}, -- great spirit potion
	{id = 238, chance = 10300, maxCount = 2}, -- great mana potion
	{id = 239, chance = 9700, maxCount = 2}, -- great health potion
	{id = 23506, chance = 9700}, -- plasma pearls
	{id = 23515, chance = 9600}, -- dangerous proto matter
	{id = 16124, chance = 7900}, -- blue crystal splinter
	{id = 16126, chance = 6000}, -- red crystal fragment
	{id = 16120, chance = 4400}, -- violet crystal shard
	{id = 16119, chance = 4000}, -- blue crystal shard
	{id = 3039, chance = 2600}, -- red gem
	{id = 23543, chance = 630}, -- collar of green plasma
	{id = 828, chance = 520}, -- lightning headband
	{id = 3036, chance = 370}, -- violet gem
	{id = 23529, chance = 370}, -- ring of blue plasma
	{id = 23544, chance = 300}, -- collar of red plasma
	{id = 23531, chance = 220} -- ring of green plasma
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -180, maxDamage = -400, range = 5, radius = 5, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_PURPLEENERGY, target = true},
	{name ="reality reaver wave", interval = 2000, chance = 20, minDamage = -200, maxDamage = -500, target = false},
	-- energy damage
	{name ="condition", type = CONDITION_ENERGY, interval = 2000, chance = 20, minDamage = -400, maxDamage = -800, radius = 5, effect = CONST_ME_STUN, target = false}
}

monster.defenses = {
	defense = 50,
	armor = 50,
	{name ="invisible", interval = 2000, chance = 15, effect = CONST_ME_POFF},
	{name ="speed", interval = 2000, chance = 10, speedChange = 380, effect = CONST_ME_HITAREA, target = false, duration = 8000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 85},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
