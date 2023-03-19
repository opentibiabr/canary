local mType = Game.createMonsterType("Megasylvan Yselda")
local monster = {}

monster.description = "Megasylvan Yselda"
monster.experience = 20500
monster.outfit = {
	lookTypeEx = 36928,
}

monster.health = 190000
monster.maxHealth = 190000
monster.race = "blood"
monster.corpse = 36929
monster.speed = 0
monster.manaCost = 0

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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.summon = {
	maxSummons = 1,
	summons = {
		{name = "Carnisylvan Sapling", chance = 70, interval = 2000, count = 1}
	}
}

monster.loot = {
	{name = "crystal coin", chance = 10000, maxCount = 3},
	{name = "platinum coin", chance = 10000, maxCount = 24},
	{name = "supreme health potion", chance = 7300, maxCount = 11},
	{name = "ultimate mana potion", chance = 7300, maxCount = 3},
	{name = "ultimate spirit potion", chance = 7300, maxCount = 3},
	{name = "berserk potion", chance = 7300, maxCount = 16},
	{name = "mastermind potion", chance = 7300, maxCount = 5},
	{name = "bullseye potion", chance = 7300, maxCount = 16},
	{name = "violet gem", chance = 1200, maxCount = 1},
	{name = "yellow gem", chance = 1200, maxCount = 1},
	{id= 3039, chance = 1200, maxCount = 1},
	{name = "blue gem", chance = 1200, maxCount = 1},
	{name = "green gem", chance = 1200, maxCount = 1},
	{name = "giant emerald", chance = 1200, maxCount = 1},
	{name = "giant topaz", chance = 1200, maxCount = 1},
	{name = "terra mantle", chance = 700},
	{name = "terra legs", chance = 600},
	{name = "terra amulet", chance = 600},
	{name = "terra rod", chance = 400},
	{name = "terra hood", chance = 650},
	{name = "potato", chance = 650, maxCount = 2},
	{name = "bar of gold", chance = 650},
	{name = "curl of hair", chance = 650},
	{name = "old royal diary", chance = 650},
	{name = "megasylvan sapling", chance = 650}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -270, maxDamage = -500},
	{name ="combat", interval = 2000, chance = 70, type = COMBAT_EARTHDAMAGE, minDamage = -1000, maxDamage = -1200, length = 7, spread = 0, effect = CONST_ME_SMALLPLANTS, target = false},
	{name ="combat", interval = 2000, chance = 17, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -800, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = false},
	{name ="combat", interval = 2000, chance = 17, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -800, radius = 2, effect = CONST_ME_HITBYPOISON, target = false},
}

monster.defenses = {
	defense = 60,
	armor = 82,
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
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType:register(monster)