local mType = Game.createMonsterType("A Weak Spot")
local monster = {}

monster.description = "A Weak Spot"
monster.experience = 0
monster.outfit = {
	lookTypeEx = 32726,
}

monster.events = {
	"paleWormShareHealth",
}

monster.health = 305000
monster.maxHealth = 305000
monster.race = "venom"
monster.corpse = 0
monster.speed = 0
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
	rewardBoss = false,
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
}


monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -400, maxDamage = -1000},
	{name ="aweakspotdeathue", interval = 4000, chance = 100, target = false},
	{name ="weakspotue1", interval = 60000, chance = 40, minDamage = -200, maxDamage = -250, target = false},
	{name ="weakspotue2", interval = 67000, chance = 30, minDamage = -501, maxDamage = -600, target = false},
	{name ="weakspotue3", interval = 70000, chance = 20, minDamage = -600, maxDamage = -800, target = false},
	{name ="weakspotue4", interval = 85000, chance = 25, minDamage = -800, maxDamage = -1200, target = false},
	{name ="weakspotue5", interval = 100000, chance = 10, minDamage = -1200, maxDamage = -4000, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 42,
	{name ="summonsaweakspot", interval = 5000, chance = 75, target = false},
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 15},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 30},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 25},
	{type = COMBAT_MANADRAIN, percent = 25},
	{type = COMBAT_DROWNDAMAGE, percent = 25},
	{type = COMBAT_ICEDAMAGE, percent = 25},
	{type = COMBAT_HOLYDAMAGE , percent = 15},
	{type = COMBAT_DEATHDAMAGE , percent = -100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType:register(monster)
