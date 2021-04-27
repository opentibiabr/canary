local mType = Game.createMonsterType("Sharpclaw")
local monster = {}

monster.description = "a sharpclaw"
monster.experience = 3000
monster.outfit = {
	lookType = 1031,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3300
monster.maxHealth = 3300
monster.race = "blood"
monster.corpse = 24723
monster.speed = 250
monster.manaCost = 0
monster.maxSummons = 2

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

monster.summons = {
	{name = "Werebadger", chance = 20, interval = 2000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "The toughness of badgers will outlast the hostile!", yell = false},
	{text = "Never underestimate a badger!", yell = false}
}

monster.loot = {
	{name = "Gold Coin", chance = 13600000, maxCount = 100},
	{name = "Gold Coin", chance = 13600000, maxCount = 100},
	{name = "Platinum Coin", chance = 13600000, maxCount = 10},
	{name = "Brown Mushroom", chance = 13600000, maxCount = 9},
	{name = "Onyx Chip", chance = 13600000, maxCount = 9},
	{name = "Small Enchanted Amethyst", chance = 13600000, maxCount = 9},
	{name = "Beetroot", chance = 13600000, maxCount = 9},
	{name = "Great Mana Potion", chance = 13600000, maxCount = 9},
	{name = "Platinum Amulet", chance = 13600000},
	{name = "Ring of Healing", chance = 13600000},
	{name = "Troll Green", chance = 13600000, maxCount = 9},
	{name = "Ultimate Mana Potion", chance = 13600000, maxCount = 9},
	{name = "Werebadger Claws", chance = 13600000, maxCount = 9},
	{name = "Werebadger Skull", chance = 13600000, maxCount = 9},
	{name = "Badger Boots", chance = 400},
	{name = "Underworld Rod", chance = 400},
	{name = "Wand of Voodoo", chance = 400},
	{name = "Wolf Backpack", chance = 250}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290},
	{name ="combat", interval = 1000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 100, maxDamage = 720, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -600, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000},
	{name ="combat", interval = 1000, chance = 14, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -700, length = 5, spread = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="outfit", interval = 1000, chance = 1, radius = 1, target = true, duration = 2000, outfitMonster = "Werebadger"},
	{name ="ghastly dragon curse", interval = 2000, chance = 5, range = 1, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{name ="combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 345, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="invisible", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = 70},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
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
