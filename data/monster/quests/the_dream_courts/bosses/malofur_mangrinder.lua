local mType = Game.createMonsterType("Malofur Mangrinder")
local monster = {}

monster.description = "Malofur Mangrinder"
monster.experience = 55000
monster.outfit = {
	lookType = 1120,
	lookHead = 19,
	lookBody = 22,
	lookLegs = 76,
	lookFeet = 22,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 200000
monster.maxHealth = 200000
monster.race = "blood"
monster.corpse = 34655
monster.speed = 250
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
	{text = "RAAAARGH! I'M MASHING YE TO DUST BOOM!", yell = false},
	{text = "BOOOM!", yell = false},
	{text = "BOOOOM!!!", yell = false},
	{text = "BOOOOOM!!!", yell = false}
}

monster.loot = {
	{name = "Ultimate Spirit Potion", chance = 50000, maxCount = 6},
	{name = "Crystal Coin", chance = 50000},
	{name = "Ultimate Mana Potion", chance = 50000, maxCount = 14},
	{name = "Supreme Health Potion", chance = 50000, maxCount = 6},
	{name = "Gold Token", chance = 50000, maxCount = 2},
	{name = "Silver Token", chance = 100000, maxCount = 2},
	{id = 7632, chance = 100000},
	{name = "Green Gem", chance = 100000},
	{name = "Red Gem", chance = 50000},
	{name = "Blue Gem", chance = 100000},
	{id = 26185, chance = 50000},
	{name = "Platinum Coin", chance = 50000, maxCount = 5},
	{name = "Bullseye Potion", chance = 50000, maxCount = 10},
	{name = "Piggy Bank", chance = 100000},
	{name = "Mysterious Remains", chance = 100000},
	{name = "Energy Bar", chance = 100000},
	{id = 26199, chance = 50000},
	{name = "Ring of the Sky", chance = 100000},
	{name = "Crunor Idol", chance = 100000},
	{name = "Resizer", chance = 100000},
	{name = "Shoulder Plate", chance = 100000},
	{name = "Malofur's Lunchbox", chance = 100000},
	{name = "Pomegranate", chance = 50000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5}
}

monster.defenses = {
	defense = 20,
	armor = 20
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 20},
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
