local mType = Game.createMonsterType("Lloyd")
local monster = {}

monster.description = "Lloyd"
monster.experience = 50000
monster.outfit = {
	lookType = 940,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 64000
monster.maxHealth = 64000
monster.race = "venom"
monster.corpse = 27595
monster.speed = 400
monster.manaCost = 0
monster.maxSummons = 0

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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 1,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.events = {
	"LloydPrepareDeath"
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{id = 2148, chance = 97000, maxCount = 200},
	{id = 2152, chance = 90000, maxCount = 30},
	{id = 7590, chance = 22120, maxCount = 3},
	{id = 8473, chance = 19500, maxCount = 3},
	{id = 2493, chance = 1000},
	{id = 18413, chance = 9660, maxCount = 5},
	{id = 18414, chance = 9660, maxCount = 5},
	{id = 18415, chance = 9660, maxCount = 5},
	{id = 2149, chance = 9660, maxCount = 5},
	{id = 2147, chance = 7360, maxCount = 5},
	{id = 9970, chance = 7350, maxCount = 5},
	{id = 2150, chance = 7150, maxCount = 5},
	{id = 5888, chance = 5888, maxCount = 2},
	{id = 5887, chance = 5909, maxCount = 2},
	{id = 7424, chance = 5000},
	{id = 2158, chance = 5000},
	{id = 2155, chance = 5000},
	{id = 2154, chance = 5000},
	{id = 2195, chance = 5000},
	{id = 26182, chance = 5000},
	{id = 5891, chance = 5000},
	{id = 7895, chance = 5000},
	{id = 12410, chance = 5000},
	{id = 7440, chance = 5000},
	{id = 5904, chance = 5000},
	{id = 27627, chance = 500, unique = true},
	{id = 2214, chance = 1970},
	{id = 8920, chance = 1970},
	{id = 8900, chance = 1970},
	{id = 11355, chance = 1970},
	{id = 25383, chance = 1970},
	{id = 25377, chance = 100000},
	{id = 25172, chance = 100000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -1400},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -130, maxDamage = -460, length = 6, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="lloyd wave", interval = 2000, chance = 12, minDamage = -430, maxDamage = -560, target = false},
	{name ="lloyd wave2", interval = 2000, chance = 12, minDamage = -230, maxDamage = -460, target = false},
	{name ="lloyd wave3", interval = 2000, chance = 12, minDamage = -430, maxDamage = -660, target = false}
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 180, maxDamage = 250, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType.onThink = function(monster, interval)
end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature)
end

mType.onMove = function(monster, creature, fromPosition, toPosition)
end

mType.onSay = function(monster, creature, type, message)
end

mType:register(monster)
