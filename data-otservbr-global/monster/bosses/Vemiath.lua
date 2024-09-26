local mType = Game.createMonsterType("Vemiath")
local monster = {}

monster.description = "Vemiath"
monster.experience = 180000
monster.outfit = {
	lookType = 1668,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "undead"
monster.corpse = 44021
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20
}

monster.bosstiary = {
	bossRaceId = 2365,
	bossRace = RARITY_NEMESIS
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.events = {"RottenbloodBossDeath"}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
}

monster.voices = {
}

monster.loot = {
	{id = 3043, chance = 10000, maxCount = 40}, 
	{id = 16124, chance = 10000, maxCount = 15},
	{id = 7368, chance = 10000, maxCount = 100}, 
	{id = 6499, chance = 1000, maxCount = 2}, 
	{id = 7643, chance = 10000, maxCount = 10}, 
	{id = 31990, chance = 15000, maxCount = 4},
	{id = 238, chance = 10000, maxCount = 10}, 
	{id = 7642, chance = 10000, maxCount = 10},
	{id = 43854, chance = 18500, maxCount = 2},
	{id = 43853, chance = 300, maxCount = 1}, --darklight core
	{id = 43967, chance = 500},
	{id = 43961, chance = 1000},
	{id = 44008, chance = 500, maxCount = 1}, --moonlight ipomea's stamen.
	{id = 43855, chance = 500}, --darklight heart
	{id = 43503, chance = 10000, maxCount = 2},
	{id = 23267, chance = 10000, maxCount = 5},
	{id = 43900, chance = 1000, maxCount = 1},
	{id = 43852, chance = 22000, maxCount = 4},
	{id = 43736, chance = 14500},
	{id = 22866, chance = 2700}, 
	{id = 22867, chance = 1700}, 
	{id = 6499, chance = 11000}, 
	{id = 7420, chance = 900},
	{id = 22721, chance = 100000},
	{id = 7426, chance = 4000}, 
	{name = "amber with a bug", chance = 11000},
	{name = "ogre scepta", chance = 9000},
	{name = "golden legs", chance = 4500},
	{name = "demon helmet", chance = 1000},
	{name = "dark trinity mace", chance = 900},
	{name = "fireborn giant armor", chance = 3000},
	{name = "triple bolt crossbow", chance  = 600},

}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -1500, maxDamage = -2500},
	{name ="combat", interval = 3000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1000, length = 10, spread = 3, effect = 244, target = false},
	{name ="speed", interval = 2000, chance = 45, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000},
	{name ="combat", interval = 1500, chance = 45, type = COMBAT_ICEDAMAGE, minDamage = -600, maxDamage = -900, radius = 5, effect = 243, target = false},
	{name ="combat", interval = 2000, chance = 43, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -900, length = 10, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_FIREDAMAGE, minDamage = -600, maxDamage = -1000, length = 8, spread = 3, effect = CONST_ME_FIREATTACK, target = false}
}

monster.defenses = {
	defense = 105,
	armor = 105,
	{name ="combat", interval = 3000, chance = 10, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1500, effect = CONST_ME_MAGIC_BLUE, target = false},
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 15},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 15},
	{type = COMBAT_FIREDAMAGE, percent = 15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 15},
	{type = COMBAT_HOLYDAMAGE , percent = 15},
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