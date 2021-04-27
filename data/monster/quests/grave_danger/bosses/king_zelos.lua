local mType = Game.createMonsterType("King Zelos")
local monster = {}

monster.description = "King Zelos"
monster.experience = 251300
monster.outfit = {
	lookType = 1224,
	lookHead = 10,
	lookBody = 19,
	lookLegs = 19,
	lookFeet = 19,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 125000
monster.maxHealth = monster.health
monster.race = "venom"
monster.corpse = 36443
monster.speed = 425
monster.maxSummons = 6

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.loot = {
	{name = "platinum coin", minCount = 1, maxCount = 5, chance = 100000},
	{name = "crystal coin", minCount = 0, maxCount = 5, chance = 50000},
	{name = "supreme health potion", minCount = 0, maxCount = 20, chance = 45000},
	{name = "ultimate mana potion", minCount = 0, maxCount = 6, chance = 42000},
	{name = "ultimate spirit potion", minCount = 0, maxCount = 14, chance = 42000},
	{name = "bullseye potion", minCount = 0, maxCount = 10, chance = 22000},
	{name = "berserk potion", minCount = 0, maxCount = 10, chance = 22000},
	{name = "gold token", minCount = 0, maxCount = 3, chance = 18000},
	{name = "silver token", minCount = 0, maxCount = 3, chance = 25000},
	{name = "green gem", chance = 19000},
	{name = "red gem", chance = 18500},
	{name = "yellow gem", chance = 18500},
	{name = "giant sapphire", chance = 16800},
	{name = "collar of green plasma", chance = 15200},
	{name = "magma coat", chance = 15200},
	{name = "gold ingot", minCount = 0, maxCount = 1, chance = 18000},
	{name = "red tome", chance = 18200},
	{id = 26185, chance = 12000},-- ring of blue plasma
	{id = 26189, chance = 12000},-- ring of red plasma
	{name = "young lich worm", chance = 5500},
	{name = "mortal mace", chance = 1300},
	{name = "golden hyena pendant", chance = 1100},
	{name = "bow of cataclysm", chance = 600},
	{name = "galea mortis", chance = 550},
	{name = "shadow cowl", chance = 530},
	{name = "toga mortis", chance = 500},
}

monster.attacks = {
	{name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, minDamage = -900, maxDamage = -2700},
	{name = "combat", type = COMBAT_FIREDAMAGE, interval = 2000, chance = 15, length = 8, spread = 0, minDamage = -1200, maxDamage = -3200, effect = CONST_ME_HITBYFIRE},
	{name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 10, length = 8, spread = 3, minDamage = -600, maxDamage = -1600, effect = CONST_ME_SMALLCLOUDS},
}

monster.defenses = {
	defense = 78,
	armor = 78,
	{name = "combat", type = COMBAT_HEALING, chance = 15, interval = 2000, minDamage = 1450, maxDamage = 5350, effect = CONST_ME_MAGIC_BLUE},
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 3},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "invisible", condition = true},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Feel the power of death unleashed!", yell = false},
	{text = "I will rule again and my realm of death will span the world!", yell = false},
	{text = "My lich-knights will conquer this world for me!", yell = false},
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