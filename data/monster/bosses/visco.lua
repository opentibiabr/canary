local mType = Game.createMonsterType("Mutated Visco")
local monster = {}

monster.description = "a mutated visco"
monster.experience = 9800
monster.outfit = {
	lookType = 554,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "blood"
monster.corpse = 18949
monster.speed = 290
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 1500,
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
	{text = "I'm Zulazza, and you won't forget me that fazzt.", yell = false},
	{text = "Oh, HE will take revenge on zzizz azzault when you zztep in front of HIZZ fazze!", yell = false}
}

monster.loot = {
	{id = 239, chance = 30500},
	{id = 3035, chance = 41325, maxCount = 30},
	{id = 3031, chance = 49650, maxCount = 100},
	{id = 8894, chance = 50500},
	{id = 9058, chance = 33000, maxCount = 4},
	{id = 3041, chance = 30500},
	{id = 3038, chance = 20500},
	{id = 7643, chance = 10500},
	{id = 10201, chance = 5500},
	{id = 5944, chance = 19250, maxCount = 4},
	{id = 3428, chance = 15500},
	{id = 7366, chance = 8100, maxCount = 67},
	{id = 281, chance = 28000, maxCount = 2},
	{id = 3037, chance = 15500},
	{id = 3039, chance = 10500},
	{id = 7440, chance = 10500},
	{id = 3036, chance = 25500},
	{id = 238, chance = 20500},
	{id = 8054, chance = 5500},
	{id = 3414, chance = 5500},
	{id = 3010, chance = 10500},
	{id = 8063, chance = 5500},
	{id = 3415, chance = 5500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 200, attack = 200},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -1500, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -1300, radius = 3, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -130, range = 7, effect = CONST_ME_MAGIC_GREEN, target = true},
	{name ="speed", interval = 2000, chance = 20, speedChange = -500, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000}
}

monster.defenses = {
	defense = 119,
	armor = 96,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 3000, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 70},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = 30}
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
