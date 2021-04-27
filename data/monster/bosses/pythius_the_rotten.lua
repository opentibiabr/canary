local mType = Game.createMonsterType("Pythius The Rotten")
local monster = {}

monster.description = "Pythius The Rotten"
monster.experience = 7000
monster.outfit = {
	lookType = 231,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "undead"
monster.corpse = 7349
monster.speed = 350
monster.manaCost = 0
monster.maxSummons = 2

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
	{name = "Undead Gladiator", chance = 10, interval = 1000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "YOU'LL NEVER GET MY TREASURE!", yell = true},
	{text = "MINIONS, MEET YOUR NEW BROTHER!", yell = true},
	{text = "YOU WILL REGRET THAT YOU ARE BORN!", yell = true},
	{text = "YOU MADE A HUGE WASTE!", yell = true}
}

monster.loot = {
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -475},
	{name ="combat", interval = 2000, chance = 16, type = COMBAT_PHYSICALDAMAGE, minDamage = -165, maxDamage = -200, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 2000, chance = 17, type = COMBAT_EARTHDAMAGE, minDamage = -55, maxDamage = -155, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true},
	{name ="combat", interval = 2500, chance = 14, type = COMBAT_EARTHDAMAGE, minDamage = -333, maxDamage = -413, length = 8, spread = 3, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 2500, chance = 22, type = COMBAT_MANADRAIN, minDamage = -85, maxDamage = -110, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, target = true},
	{name ="speed", interval = 2000, chance = 20, speedChange = -300, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true, duration = 30000},
	-- curse
	{name ="condition", type = CONDITION_CURSED, interval = 2000, chance = 15, range = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true}
}

monster.defenses = {
	defense = 45,
	armor = 40
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
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
