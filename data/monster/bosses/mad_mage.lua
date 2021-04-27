local mType = Game.createMonsterType("Mad Mage")
local monster = {}

monster.description = "a mad mage"
monster.experience = 1800
monster.outfit = {
	lookType = 394,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 2500
monster.maxHealth = 2500
monster.race = "blood"
monster.corpse = 13603
monster.speed = 240
monster.manaCost = 0
monster.maxSummons = 1

monster.changeTarget = {
	interval = 5000,
	chance = 30
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
	targetDistance = 4,
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

monster.summons = {
	{name = "Golden Servant", chance = 10, interval = 1000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Did it not come to your mind that I placed them here for a reason?", yell = false},
	{text = "Now I have to create new servants! Do you want to spread this pest beyond these safe walls?", yell = false},
	{text = "What have you done!", yell = false}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 340},
	{id = 2152, chance = 48000, maxCount = 5},
	{id = 7589, chance = 21000, maxCount = 5},
	{id = 7588, chance = 17000, maxCount = 5},
	{id = 2178, chance = 9000},
	{id = 2165, chance = 6000},
	{id = 7368, chance = 4000, maxCount = 4},
	{id = 2792, chance = 4000, maxCount = 3},
	{id = 5911, chance = 5000},
	{id = 2150, chance = 4000, maxCount = 3},
	{id = 13756, chance = 1680, unique = true},
	{id = 7443, chance = 1100},
	{id = 9941, chance = 740},
	{id = 2195, chance = 2370},
	{id = 12410, chance = 370},
	{id = 2114, chance = 1370},
	{id = 2123, chance = 1370},
	{id = 8901, chance = 2370}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -30},
	{name ="combat", interval = 1000, chance = 12, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 1400, chance = 24, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -120, range = 6, shootEffect = CONST_ANI_ICE, target = false},
	{name ="firefield", interval = 1600, chance = 20, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -200, radius = 4, effect = CONST_ME_BIGCLOUDS, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 35, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -20},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
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
