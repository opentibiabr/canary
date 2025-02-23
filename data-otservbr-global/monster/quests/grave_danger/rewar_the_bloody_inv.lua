local mType = Game.createMonsterType("Rewar The Bloody Inv")
local monster = {}

monster.name = "Rewar The Bloody"
monster.description = "a rewar the bloody"
monster.experience = 0
monster.outfit = {
	lookType = 633,
	lookHead = 79,
	lookBody = 94,
	lookLegs = 57,
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
	"rewar_the_bloody",
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
	rewardBoss = false,
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

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -800, maxDamage = -1200 },
	{ name = "combat", interval = 3000, chance = 46, type = COMBAT_DROWNDAMAGE, minDamage = -700, maxDamage = -800, length = 7, spread = 5, effect = CONST_ME_BUBBLES, target = false },
	{ name = "combat", interval = 5000, chance = 70, type = COMBAT_LIFEDRAIN, minDamage = -700, maxDamage = -900, length = 7, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 6000, chance = 46, type = COMBAT_EARTHDAMAGE, minDamage = -700, maxDamage = -800, length = 7, spread = 5, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	{ name = "combat", interval = 2000, chance = 54, type = COMBAT_HEALING, minDamage = 900, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
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
