local mType = Game.createMonsterType("Grand Commander Soeren")
local monster = {}

monster.description = "Grand Commander Soeren"
monster.experience = 10000
monster.outfit = {
	lookType = 1071,
	lookHead = 38,
	lookBody = 94,
	lookLegs = 38,
	lookFeet = 86,
	lookAddons = 2,
	lookMount = 0
}

monster.health = 17000
monster.maxHealth = 17000
monster.race = "blood"
monster.corpse = 32426
monster.speed = 210
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
}

monster.strategiesTarget = {
	nearest = 100,
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
	staticAttackChance = 70,
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
	{name = "Small Enchanted Amethyst", chance = 15000, maxCount = 3},--done
	{name = "Platinum Coin", chance = 50000, maxCount = 3},--done
	{name = "Great Health Potion", chance = 50000, maxCount = 3},--done
	{name = "Small Ruby", chance = 12700, maxCount = 3},--done
	{name = "Onyx Arrow", chance = 30000, maxCount = 3},--done
	{name = "Golden Armor", chance = 1000},
	{name = "Green Gem", chance = 1300},--done
	{name = "Damaged Armor Plates", chance = 1800, maxCount = 3},--done
	{name = "Falcon Crest", chance = 400, maxCount = 3},--done
	{name = "Patch of Fine Cloth", chance = 2500},--done
	{name = "Falcon Coif", chance = 200},--done
	{name = "Falcon Bow", chance = 200}--done
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -700},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -720, range = 7, shootEffect = CONST_ANI_ROYALSPEAR, target = false},
	{name ="combat", interval = 1000, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -500, maxDamage = -1000, length = 8, spread = 3, effect = CONST_ME_BLOCKHIT, target = false}
}

monster.defenses = {
	defense = 50,
	armor = 82,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 650, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
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
