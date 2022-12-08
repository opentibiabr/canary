local mType = Game.createMonsterType("Merikh the Slaughterer")
local monster = {}

monster.description = "a merikh the slaughterer"
monster.experience = 1500
monster.outfit = {
	lookType = 103,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 2000
monster.maxHealth = 2000
monster.race = "blood"
monster.corpse = 6032
monster.speed = 90
monster.manaCost = 0

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

monster.summon = {
	maxSummons = 2,
	summons = {
		{name = "green djinn", chance = 10, interval = 2000, count = 1}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Your death will be slow and painful.", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 97250, maxCount = 120},
	{name = "green piece of cloth", chance = 100000, maxCount = 4},
	{name = "noble turban", chance = 63900},
	{name = "heavy machete", chance = 41650},
	{name = "magma monocle", chance = 8400},
	{name = "seeds", chance = 100},
	{name = "jewelled belt", chance = 100000},
	{name = "shiny stone", chance = 58300},
	{name = "strong mana potion", chance = 41650, maxCount = 3},
	{name = "small emerald", chance = 2800, maxCount = 2},
	{name = "small oil lamp", chance = 100},
	{name = "royal spear", chance = 55550, maxCount = 3},
	{name = "mystic turban", chance = 36100},
	{name = "green gem", chance = 2800},
	{name = "pear", chance = 100, maxCount = 8}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -304}
	--fireball
	--heavy magic missile
	--sudden death
	--energy berserk
	--electrifies
}

monster.defenses = {
	defense = 0,
	armor = 0,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -1},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 1},
	{type = COMBAT_HOLYDAMAGE , percent = 1},
	{type = COMBAT_DEATHDAMAGE , percent = -1}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
