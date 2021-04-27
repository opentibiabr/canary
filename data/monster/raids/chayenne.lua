local mType = Game.createMonsterType("Chayenne")
local monster = {}

monster.description = "Chayenne"
monster.experience = 0
monster.outfit = {
	lookType = 155,
	lookHead = 78,
	lookBody = 0,
	lookLegs = 105,
	lookFeet = 99,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 200000
monster.maxHealth = 200000
monster.race = "blood"
monster.corpse = 6081
monster.speed = 300
monster.manaCost = 0
monster.maxSummons = 0

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

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "We don't stop playing because we grow old, we grow old because we stop playing.", yell = false},
	{text = "Oooh dang, he's hot *-*", yell = false},
	{text = "Oh came on, take it easy.", yell = false},
	{text = "Work hard, play harder!", yell = false},
	{text = "They are doing WHAT with my quest?!", yell = false}
}

monster.loot = {
	{id = 6571, chance = 100000, maxCount = 2},
	{id = 7632, chance = 100000},
	{id = 16014, chance = 100000},
	{id = 16015, chance = 100000, unique = true}
}

monster.attacks = {
	{name ="melee", interval = 3000, chance = 100, skill = 300, attack = 150},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -1500, range = 1, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -1250, range = 7, effect = CONST_ME_MAGIC_RED, target = true}
}

monster.defenses = {
	defense = 20,
	armor = 15,
	{name ="combat", interval = 1000, chance = 1, type = COMBAT_HEALING, minDamage = 0, maxDamage = 10000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="combat", interval = 3500, chance = 30, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="outfit", interval = 2000, chance = 10, effect = CONST_ME_ENERGYHIT, target = false, duration = 10000, outfitMonster = "Devovorga"},
	{name ="outfit", interval = 2000, chance = 10, effect = CONST_ME_ENERGYHIT, target = false, duration = 10000, outfitMonster = "Chayenne"}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
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
