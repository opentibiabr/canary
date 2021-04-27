local mType = Game.createMonsterType("Darkfang")
local monster = {}

monster.description = "a darkfang"
monster.experience = 4000
monster.outfit = {
	lookType = 308,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 4800
monster.maxHealth = 4800
monster.race = "blood"
monster.corpse = 20380
monster.speed = 250
monster.manaCost = 0
monster.maxSummons = 2

monster.changeTarget = {
	interval = 4000,
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
	staticAttackChance = 90,
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

monster.summons = {
	{name = "Gloom Wolf", chance = 20, interval = 2000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "The ferocity of wolves will frighten the fearful! Roarrr!", yell = false},
	{text = "You are my next meal! Grrr!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 13600000, maxCount = 100},
	{name = "gold coin", chance = 13600000, maxCount = 100},
	{name = "platinum coin", chance = 13600000, maxCount = 10},
	{name = "berserk potion", chance = 13600000, maxCount = 3},
	{name = "black pearl", chance = 13600000, maxCount = 3},
	{name = "onyx chip", chance = 13600000, maxCount = 5},
	{name = "small enchanted sapphire", chance = 13600000, maxCount = 10},
	{name = "ultimate health potion", chance = 13600000, maxCount = 5},
	{name = "platinum amulet", chance = 13600000},
	{name = "stone skin amulet", chance = 13600000},
	{id = 2169, chance = 13600000},
	{name = "troll green", chance = 13600000, maxCount = 2},
	{name = "werewolf fur", chance = 13600000, maxCount = 2},
	{name = "wolf paw", chance = 13600000, maxCount = 2},
	{name = "bonebreaker", chance = 400},
	{name = "dreaded cleaver", chance = 400},
	{name = "werewolf amulet", chance = 400},
	{name = "sai", chance = 250},
	{id = 7394, chance = 13600000},
	{name = "silver token", chance = 250},
	{name = "wolf backpack", chance = 100}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290},
	{name ="werewolf skill reducer", interval = 2000, chance = 15, range = 1, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -300, radius = 8, effect = CONST_ME_SOUND_RED, target = false},
	{name ="combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = 200, maxDamage = 340, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -600, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000}
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{name ="combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 345, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = 50},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
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
