local mType = Game.createMonsterType("The Souldespoiler")
local monster = {}

monster.description = "The Souldespoiler"
monster.experience = 0
monster.outfit = {
	lookType = 875,
	lookHead = 11,
	lookBody = 0,
	lookLegs = 94,
	lookFeet = 95,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "blood"
monster.corpse = 26220
monster.speed = 250
monster.manaCost = 0
monster.maxSummons = 5

monster.changeTarget = {
	interval = 6000,
	chance = 30
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
	staticAttackChance = 95,
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
	{name = "Freed Soul", chance = 5, interval = 5000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Urrg! I will not lose this soul!", yell = false},
	{text = "All souls shall be mine alone!", yell = false}
}

monster.loot = {
	{name = "curious matter", chance = 8920, maxCount = 10},
	{name = "spark sphere", chance = 21200, maxCount = 10},
	{id = 7633, chance = 26900},
	{name = "wand of defiance", chance = 8920},
	{name = "rift lance", chance = 13200},
	{name = "rift crossbow", chance = 7620},
	{name = "haunted blade", chance = 9700},
	{name = "silver token", chance = 2320},
	{name = "gold token", chance = 1532},
	{name = "sapphire hammer", chance = 14000},
	{name = "gold coin", chance = 100000, maxCount = 200},
	{name = "platinum coin", chance = 29840, maxCount = 35},
	{name = "wand of defiance", chance = 8723},
	{name = "yellow gem", chance = 29460},
	{name = "blue gem", chance = 21892},
	{name = "medusa shield", chance = 7270},
	{name = "underworld rod", chance = 9510},
	{name = "mysterious remains", chance = 100000},
	{name = "prismatic quartz", chance = 13390, maxCount = 10},
	{name = "small diamond", chance = 12760, maxCount = 10},
	{name = "small amethyst", chance = 14700, maxCount = 10},
	{name = "small topaz", chance = 11520, maxCount = 10},
	{name = "small sapphire", chance = 13790, maxCount = 10},
	{name = "small emerald", chance = 14700, maxCount = 10},
	{name = "small amethyst", chance = 12259, maxCount = 10},
	{name = "odd organ", chance = 100000},
	{name = "energy bar", chance = 16872, maxCount = 3},
	{name = "ultimate health potion", chance = 27652, maxCount = 10},
	{name = "great mana potion", chance = 33721, maxCount = 10},
	{name = "great spirit potion", chance = 25690, maxCount = 10},
	{name = "blade of corruption", chance = 3775},
	{name = "magma boots", chance = 15890},
	{name = "spellbook of lost souls", chance = 7890},
	{name = "shield of corruption", chance = 150},
	{name = "plasma pearls", chance = 100000},
	{name = "spiked squelcher", chance = 16892, maxCount = 2}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -783},
	{name ="combat", interval = 2000, chance = 60, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -181, range = 7, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true},
	{name ="combat", interval = 2000, chance = 50, type = COMBAT_ENERGYDAMAGE, minDamage = -210, maxDamage = -538, length = 7, spread = 2, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="combat", interval = 3000, chance = 30, type = COMBAT_DROWNDAMAGE, minDamage = -125, maxDamage = -640, length = 9, spread = 3, effect = CONST_ME_LOSEENERGY, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 100, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 7000, effect = CONST_ME_MAGIC_BLUE, target = false}
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
