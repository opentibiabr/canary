local mType = Game.createMonsterType("Lady Tenebris")
local monster = {}

monster.description = "Lady Tenebris"
monster.experience = 50000
monster.outfit = {
	lookType = 433,
	lookHead = 57,
	lookBody = 95,
	lookLegs = 38,
	lookFeet = 94,
	lookAddons = 2,
	lookMount = 0
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "blood"
monster.corpse = 6560
monster.speed = 370
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	pet = false
}

monster.events = {
	"HealthForgotten"
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "May the embrace of darkness kill you!", yell = false}
}

monster.loot = {
	{id = 2148, chance = 10000, maxCount = 50},
	{id = 2152, chance = 10000, maxCount = 50},
	{id = 2150, chance = 10000, maxCount = 10},
	{id = 2145, chance = 10000, maxCount = 10},
	{id = 2147, chance = 10000, maxCount = 10},
	{id = 9970, chance = 10000, maxCount = 10},
	{id = 7590, chance = 10000, maxCount = 100},
	{id = 8472, chance = 10000, maxCount = 100},
	{id = 22396, chance = 2000, maxCount = 2},
	{id = 18413, chance = 2000, maxCount = 3},
	{id = 18415, chance = 5000, maxCount = 5},
	{id = 22396, chance = 2000, maxCount = 2},
	{id = 18414, chance = 5000, maxCount = 3},
	{id = 7632, chance = 6000},
	{id = 2155, chance = 2000},
	{id = 7440, chance = 2000},
	{id = 24851, chance = 2000},
	{id = 2156, chance = 1000},
	{id = 2123, chance = 2000},
	{id = 7451, chance = 2000},
	{id = 8903, chance = 1000},
	{id = 8901, chance = 1000},
	{id = 2436, chance = 1000},
	{id = 2154, chance = 1000},
	{id = 18390, chance = 1000},
	{id = 25377, chance = 100000},
	{id = 25172, chance = 100000},
	{id = 2453, chance = 200},
	{id = 27641, chance = 200},
	{id = 27642, chance = 200},
	{id = 25411, chance = 200},
	{id = 22422, chance = 200},
	{id = 27625, chance = 500, unique = true},
	{id = 2138, chance = 200},
	{id = 22423, chance = 200}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -800, maxDamage = -1300},
	{name ="combat", interval = 6000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -1200, maxDamage = -1500, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -600, radius = 4, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_SMALLCLOUDS, target = true},
	{name ="tenebris summon", interval = 2000, chance = 14, target = false},
	{name ="tenebris ultimate", interval = 15000, chance = 30, target = false}
}

monster.defenses = {
	defense = 65,
	armor = 55,
	{name ="combat", interval = 3000, chance = 25, type = COMBAT_HEALING, minDamage = 600, maxDamage = 2700, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 80},
	{type = COMBAT_DEATHDAMAGE , percent = 80}
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
