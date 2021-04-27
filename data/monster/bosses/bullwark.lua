local mType = Game.createMonsterType("Bullwark")
local monster = {}

monster.description = "Bullwark"
monster.experience = 16725
monster.outfit = {
	lookType = 607,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 65000
monster.maxHealth = 65000
monster.race = "blood"
monster.corpse = 23367
monster.speed = 300
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 3
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
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 200},
	{name = "platinum coin", chance = 80000, maxCount = 5},
	{name = "great health potion", chance = 40000, maxCount = 5},
	{name = "great mana potion", chance = 40000, maxCount = 5},
	{name = "great spirit potion", chance = 40000, maxCount = 5},
	{name = "ham", chance = 35250, maxCount = 5},
	{name = "meat", chance = 35250, maxCount = 5},
	{name = "minotaur leather", chance = 26500, maxCount = 2},
	{name = "moohtant horn", chance = 21000, maxCount = 2},
	{name = "small diamond", chance = 17900, maxCount = 5},
	{name = "small emerald", chance = 16350, maxCount = 5},
	{name = "small ruby", chance = 15500, maxCount = 5},
	{name = "small sapphire", chance = 14200, maxCount = 5},
	{name = "giant pacifier", chance = 1920},
	{name = "moohtant cudgel", chance = 1800},
	{name = "red piece of cloth", chance = 1500},
	{name = "yellow gem", chance = 1200},
	{name = "one hit wonder", chance = 350}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 180, attack = 200},
	{name ="combat", interval = 2000, chance = 19, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -400, radius = 6, effect = CONST_ME_MAGIC_RED, target = false},
	-- bleed
	{name ="condition", type = CONDITION_BLEEDING, interval = 2000, chance = 9, minDamage = -400, maxDamage = -600, radius = 8, effect = CONST_ME_ICEATTACK, target = false},
	{name ="combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -400, range = 7, radius = 6, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -400, range = 7, radius = 4, shootEffect = CONST_ANI_WHIRLWINDCLUB, effect = CONST_ME_EXPLOSIONHIT, target = true},
	{name ="bullwark paralyze", interval = 2000, chance = 6, target = false}
}

monster.defenses = {
	defense = 66,
	armor = 48,
	{name ="combat", interval = 2000, chance = 1, type = COMBAT_HEALING, minDamage = 4000, maxDamage = 6000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 11, speedChange = 660, effect = CONST_ME_HITAREA, target = false, duration = 7000},
	{name ="bullwark summon", interval = 2000, chance = 9, target = false}
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
