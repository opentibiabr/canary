local mType = Game.createMonsterType("Ocyakao")
local monster = {}

monster.description = "Ocyakao"
monster.experience = 490
monster.outfit = {
	lookType = 259,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 700
monster.maxHealth = 700
monster.race = "blood"
monster.corpse = 7320
monster.speed = 400
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 60000,
	chance = 60
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Chikuva!", yell = false},
	{text = "Grrrr! Kisavuta!", yell = false},
	{text = "Aiiee!", yell = false},
	{text = "Jinuma jamjam!", yell = false},
	{text = "Suvituka siq chuqua!", yell = false},
	{text = "Kiyosa sipaju!", yell = false}
}

monster.loot = {
	{id = 21400, chance = 200},
	{id = 2148, chance = 100000, maxCount = 20},
	{id = 2667, chance = 100000, maxCount = 5},
	{id = 2143, chance = 100000},
	{id = 5909, chance = 100000},
	{id = 2398, chance = 37500},
	{id = 21703, chance = 200, unique = true},
	{id = 2541, chance = 37570},
	{id = 7381, chance = 25050},
	{id = 7441, chance = 62570},
	{id = 7159, chance = 12500},
	{id = 2669, chance = 12520}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 25, attack = 50},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 70, maxDamage = -185, range = 7, radius = 3, shootEffect = CONST_ANI_SMALLSTONE, target = true}
}

monster.defenses = {
	defense = 10,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -15},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 40},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
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
