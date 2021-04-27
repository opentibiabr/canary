local mType = Game.createMonsterType("Earl Osam")
local monster = {}

monster.description = "Earl Osam"
monster.experience = 44200
monster.outfit = {
	lookType = 1223,
	lookHead = 95,
	lookBody = 38,
	lookLegs = 60,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "venom"
monster.corpse = 36434
monster.speed = 250
monster.manaCost = 0
monster.maxSummons = 5

monster.changeTarget = {
	interval = 4000,
	chance = 10
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

monster.summons = {
	{name = "Frozen Soul", chance = 20, interval = 2000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "platinum coin", minCount = 1, maxCount = 5, chance = 100000},
	{name = "crystal coin", minCount = 0, maxCount = 2, chance = 50000},
	{name = "supreme health potion", minCount = 0, maxCount = 6, chance = 35000},
	{name = "ultimate mana potion", minCount = 0, maxCount = 20, chance = 32000},
	{name = "ultimate spirit potion", minCount = 0, maxCount = 20, chance = 32000},
	{name = "bullseye potion", minCount = 0, maxCount = 10, chance = 12000},
	{name = "mastermind potion", minCount = 0, maxCount = 10, chance = 12000},
	{name = "berserk potion", minCount = 0, maxCount = 10, chance = 12000},
	{name = "piece of draconian steel", minCount = 0, maxCount = 3, chance = 9000},
	{name = "red gem", minCount = 0, maxCount = 2, chance = 12000},
	{name = "silver token", minCount = 0, maxCount = 2, chance = 9500},
	{id = 26198, chance = 5200},-- collar of blue plasma
	{id = 26200, chance = 5200},-- collar of red plasma
	{id = 26185, chance = 5000},-- ring of blue plasma
	{id = 26189, chance = 5000},-- ring of red plasma
	{name = "warrior helmet", chance = 11000},
	{name = "guardian axe", chance = 6400},
	{name = "gold ingot", minCount = 0, maxCount = 1, chance = 10000},
	{name = "young lich worm", chance = 5800},
	{name = "embrace of nature", chance = 1600},
	{name = "token of love", chance = 1200},
	{name = "rotten heart", chance = 1700},
	{name = "terra helmet", chance = 730},
	{name = "final judgement", chance = 440}
}

monster.attacks = {
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 3, effect = CONST_ME_ICEATTACK, target = false},
	{name ="combat", interval = 1800, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 2, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -260, maxDamage = -420, range = 3, effect = CONST_ME_BLUE_ENERGY_SPARK, target = true}
}

monster.defenses = {
	defense = 25,
	armor = 78,
	{name ="combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 350, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false}
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
