local mType = Game.createMonsterType("The Mutated Pumpkin")
local monster = {}

monster.description = "The Mutated Pumpkin"
monster.experience = 30000
monster.outfit = {
	lookType = 292,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 500000
monster.maxHealth = 500000
monster.race = "undead"
monster.corpse = 8960
monster.speed = 400
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	staticAttackChance = 85,
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
	{text = "I had the Halloween Hare for breakfast!", yell = false},
	{text = "Your soul will be mine...wait, wrong line", yell = false},
	{text = "Trick or treat? I saw death!", yell = false},
	{text = "No wait! Don't kill me! It's me, your friend!", yell = false},
	{text = "Bunnies, bah! I'm the real thing!", yell = false},
	{text = "Muahahahaha!", yell = false},
	{text = "I've come to avenge all those mutilated pumpkins!", yell = false},
	{text = "Wait until I get you!", yell = false},
	{text = "Fear the spirit of Halloween!", yell = false}
}

monster.loot = {
	{name = "pumpkin", chance = 100000},
	{name = "yummy gummy worm", chance = 100000, maxCount = 20},
	{id = 2688, chance = 1000, maxCount = 50},
	{id = 6569, chance = 1000, maxCount = 50},
	{name = "spiderwebs", chance = 1000},
	{id = 9006, chance = 1000},
	{id = 6492, chance = 1000},
	{id = 6526, chance = 1000},
	{name = "bar of chocolate", chance = 1000},
	{id = 6570, chance = 1000},
	{id = 6571, chance = 1000},
	{id = 2096, chance = 1000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 105, attack = 85},
	{name ="combat", interval = 3000, chance = 18, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -300, range = 7, effect = CONST_ME_MAGIC_RED, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -300, radius = 7, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 3000, chance = 14, type = COMBAT_ENERGYDAMAGE, minDamage = -40, maxDamage = -300, radius = 7, effect = CONST_ME_ENERGYHIT, target = false},
	{name ="combat", interval = 1000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -300, radius = 8, effect = CONST_ME_POFF, target = false},
	{name ="combat", interval = 3000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -300, length = 8, spread = 3, effect = CONST_ME_PLANTATTACK, target = false},
	{name ="combat", interval = 1000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -400, length = 6, spread = 3, effect = CONST_ME_HITBYPOISON, target = false},
	{name ="outfit", interval = 1000, chance = 2, radius = 8, effect = CONST_ME_LOSEENERGY, target = false, duration = 5000, outfitMonster = "The Mutated Pumpkin"}
}

monster.defenses = {
	defense = 60,
	armor = 60,
	{name ="combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 2900, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
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
