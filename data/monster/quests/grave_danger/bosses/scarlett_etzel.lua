local mType = Game.createMonsterType("Scarlett Etzel")
local monster = {}

monster.description = "a scarlett etzel"
monster.experience = 20000
monster.outfit = {
	lookType = 1201,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 30000
monster.maxHealth = 30000
monster.race = "blood"
monster.corpse = 36288
monster.speed = 175
monster.manaCost = 0
monster.maxSummons = 0

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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
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
	{name = "Energy Bar", chance = 100000},
	{name = "Platinum Coin", chance = 87000, maxCount = 5},
	{name = "Green Gem", chance = 85000},
	{name = "Supreme Health Potion", chance = 53700, maxCount = 14},
	{name = "Ultimate Mana Potion", chance = 48150, maxCount = 20},
	{name = "Red Gem", chance = 42500},
	{name = "Ultimate Spirit Potion", chance = 34000, maxCount = 6},
	{name = "Yellow Gem", chance = 29600, maxCount = 2},
	{name = "Royal Star", chance = 26600, maxCount = 100},
	{id = 7632, chance = 24000},
	{name = "Berserk Potion", chance = 20300, maxCount = 10},
	{name = "Blue Gem", chance = 18500, maxCount = 2},
	{name = "Bullseye Potion", chance = 18500, maxCount = 10},
	{name = "Magma Coat", chance = 16600},
	{name = "Terra Rod", chance = 1100},
	{name = "Crystal Coin", chance = 9200},
	{name = "Violet Gem", chance = 9000},
	{name = "Terra Legs", chance = 8500},
	{name = "Terra Hood", chance = 7400},
	{name = "Terra Mantle", chance = 7250},
	{name = "Magma Amulet", chance = 5500},
	{name = "Silver Token", chance = 6000, maxCount = 4},
	{name = "Gold Ingot", chance = 5000},
	{name = "Terra Amulet", chance = 4800},
	{name = "Giant Sapphire", chance = 4800},
	{name = "Magma Monocle", chance = 3700},
	{name = "Cobra Club", chance = 700},
	{name = "Cobra Axe", chance = 600},
	{name = "Cobra Crossbow", chance = 600},
	{name = "Cobra Hood", chance = 400},
	{name = "Cobra Rod", chance = 650},
	{name = "Cobra Sword", chance = 650},
	{name = "Cobra Wand", chance = 650},
	{name = "The Cobra Amulet", chance = 350}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600},
	{name ="sudden death", interval = 2000, chance = 16, minDamage = -400, maxDamage = -600, target = true},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_HOLYDAMAGE, minDamage = -450, maxDamage = -640, length = 7, spread = 3, effect = CONST_ME_HOLYAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -480, maxDamage = -630, radius = 5, effect = CONST_ME_EXPLOSIONHIT, target = false}
}

monster.defenses = {
	defense = 88,
	armor = 88
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
