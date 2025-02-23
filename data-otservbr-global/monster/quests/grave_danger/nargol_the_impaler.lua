local mType = Game.createMonsterType("Nargol The Impaler")
local monster = {}

monster.description = "a nargol the impaler"
monster.experience = 0
monster.outfit = {
	lookType = 1222,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 94,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 250000
monster.maxHealth = 250000
monster.race = "venom"
monster.corpse = 0
monster.speed = 250
monster.manaCost = 0
monster.maxSummons = 0

monster.events = {
	"nargol_death",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	pet = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -800, maxDamage = -1200 },
	{ name = "combat", interval = 6000, chance = 56, type = COMBAT_EARTHDAMAGE, minDamage = -1000, maxDamage = -1200, length = 7, spread = 5, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 5000, chance = 70, type = COMBAT_LIFEDRAIN, minDamage = -700, maxDamage = -900, length = 7, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	{ name = "combat", interval = 2000, chance = 55, type = COMBAT_HEALING, minDamage = 350, maxDamage = 950, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

monster.heals = {
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
}

mType.onThink = function(monster, interval) end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature) end

mType.onMove = function(monster, creature, fromPosition, toPosition) end

mType.onSay = function(monster, creature, type, message) end

mType:register(monster)
