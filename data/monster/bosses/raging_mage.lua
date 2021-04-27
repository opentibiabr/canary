local mType = Game.createMonsterType("Raging mage")
local monster = {}

monster.description = "a raging mage"
monster.experience = 3250
monster.outfit = {
	lookType = 416,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 13834
monster.speed = 200
monster.manaCost = 0
monster.maxSummons = 1

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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 300,
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
	{name = "Golden Servant", chance = 50, interval = 2000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Behold the all permeating powers I draw from this gate!!", yell = false},
	{text = "ENERGY!!", yell = false},
	{text = "I WILL RETURN!! My death will just be a door to await my homecoming, my physical hull will be... my... argh...", yell = false}
}

monster.loot = {
	{id = 2148, chance = 97000, maxCount = 169},
	{id = 2152, chance = 77400, maxCount = 9},
	{id = 5911, chance = 31100},
	{id = 7591, chance = 26830, maxCount = 5},
	{id = 7590, chance = 23170, maxCount = 5},
	{id = 2178, chance = 9760},
	{id = 7443, chance = 6710, maxCount = 2},
	{id = 8871, chance = 4880},
	{id = 2165, chance = 4880},
	{id = 12410, chance = 4270},
	{id = 2792, chance = 3600, maxCount = 4},
	{id = 7368, chance = 1830, maxCount = 7},
	{id = 2124, chance = 1830},
	{id = 2123, chance = 1830},
	{id = 2146, chance = 1830, maxCount = 5},
	{id = 13940, chance = 1220},
	{id = 2114, chance = 1220},
	{id = 9958, chance = 1220},
	{id = 2195, chance = 610},
	{id = 9980, chance = 610},
	{id = 5741, chance = 610},
	{id = 8902, chance = 610}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -50},
	{name ="thunderstorm", interval = 2000, chance = 35, minDamage = -100, maxDamage = -200, range = 7, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -200, range = 7, target = false},
	{name ="energyfield", interval = 2000, chance = 15, range = 7, radius = 2, shootEffect = CONST_ANI_ENERGY, target = true}
}

monster.defenses = {
	defense = 25,
	armor = 25
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -25},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
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
