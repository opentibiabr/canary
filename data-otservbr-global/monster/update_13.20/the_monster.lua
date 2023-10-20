local mType = Game.createMonsterType("The Monster")
local monster = {}

monster.description = "the monster"
monster.experience = 30000
monster.outfit = {
	lookType = 1600,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 250000
monster.maxHealth = 250000
monster.race = "undead"
monster.corpse = 42247
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20
}

monster.bosstiary = {
	bossRaceId = 2299,
	bossRace = RARITY_ARCHFOE
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

monster.events = {
	"onDeath_randomTierDrops"
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
}

monster.voices = {
}

monster.loot = {
	{ name = "platinum coin", chance = 11139, maxCount = 33 },
	{ name = "ultimate health potion", chance = 14351, maxCount = 8 },
	{ name = "ultimate mana potion", chance = 6016, maxCount = 7 },
	{ name = "ultimate spirit potion", chance = 10617, maxCount = 3 },
	{ name = "berserk potion", chance = 9777, maxCount = 2 },
	{ name = "bullseye potion", chance = 9554, maxCount = 3 },
	{ name = "mastermind potion", chance = 6290, maxCount = 3 },
	{ name = "blue gem", chance = 12567, maxCount = 3 },
	{ name = "green gem", chance = 5175, maxCount = 3 },
	{ id = 3039, chance = 9872, maxCount = 4 }, -- red gem
	{ name = "violet gem", chance = 8385, maxCount = 3 },
	{ name = "yellow gem", chance = 5234, maxCount = 5 },
	{ name = "giant emerald", chance = 3720, maxCount = 1 },
	{ name = "giant topaz", chance = 1987, maxCount = 1 },
	{ name = "antler-horn helmet", chance = 1987, maxCount = 1 },
	{ name = "alchemist's boots", chance = 1460, maxCount = 1 },
	{ name = "alchemist's notepad", chance = 2111, maxCount = 1 },
	{ name = "mutant bone boots", chance = 2768, maxCount = 1 },
	{ name = "mutant bone kilt", chance = 3277, maxCount = 1 },
	{ name = "mutated skin armor", chance = 3652, maxCount = 1 },
	{ name = "mutated skin legs", chance = 2788, maxCount = 1 },
	{ name = "stitched mutant hide legs", chance = 1614, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -207, condition = { type = CONDITION_POISON, totalDamage = 4, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_LIFEDRAIN, minDamage = -90, maxDamage = -140, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 1000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -175, radius = 2, shootEffect = CONST_ANI_SMALLEARTH, target = false },
	{ name = "speed", interval = 3000, chance = 40, speedChange = -900, effect = CONST_ME_MAGIC_RED, target = true, duration = 20000 },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 3.27,
	{ name = "combat", type = COMBAT_HEALING, chance = 15, interval = 2000, minDamage = 450, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE },
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