local mType = Game.createMonsterType("The Monster")
local monster = {}

monster.description = "The Monster"
monster.experience = 400000
monster.outfit = {
	lookType = 1600,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 355000
monster.maxHealth = 355000
monster.race = "blood"
monster.corpse = 42247
monster.speed = 350
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0
}

monster.bosstiary = {
	bossRaceId = 2299,
	bossRace = RARITY_ARCHFOE,
	storageCooldown = Storage.Quest.U13_10.CradleOfMonsters.Bosses.TheMonsterTimer
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.events = {
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "platinum coin", chance = 7000, maxcount = 30},
	{name = "ultimate health potion", chance = 7000, maxcount = 7},
	{name = "ultimate mana potion", chance = 7000, maxcount = 5},
	{name = "ultimate spirit potion", chance = 7000, maxcount = 4},
	{name = "mastermind potion", chance = 7000, maxcount = 3},
	{name = "berserk potion", chance = 7000, maxcount = 3},
	{name = "bullseye potion", chance = 7000, maxcount = 3},
	{name = "yellow gem", chance = 7000, maxcount = 5},
	{id = 3039, chance = 7000, maxcount = 2},
	{name = "blue gem", chance = 7000, maxcount = 1},
	{name = "green gem", chance = 7000, maxcount = 1},
	{name = "violet gem", chance = 7000, maxcount = 1},
	{name = "giant amethyst", chance = 7000, maxcount = 1},
	{name = "giant topaz", chance = 7000, maxcount = 1},
	{name = "giant emerald", chance = 7000, maxcount = 1},
	{id = 33778, chance = 7000, maxcount = 1},
	{name = "alchemist's notepad", chance = 570, maxcount = 1},
	{name = "antler-horn helmet", chance = 570, maxcount = 1},
	{name = "mutant bone kilt", chance = 570, maxcount = 1},
	{name = "mutated skin armor", chance = 570, maxcount = 1},
	{name = "mutated skin legs", chance = 570, maxcount = 1},
	{name = "stitched mutant hide legs", chance = 570, maxcount = 1},
	{name = "alchemist's boots", chance = 570, maxcount = 1},
	{name = "mutant bone boots", chance = 570, maxcount = 1}
}

monster.attacks = {	
		{name ="melee", interval = 1700, chance = 100, minDamage = -1500, maxDamage = -2500, effect = 244},
		{name ="combat", interval = 1800, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -900, maxDamage = -2000, length = 4, spread = 0, effect = CONST_ME_HITBYFIRE, target = false},
		{name ="combat", interval = 1800, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -900, maxDamage = -2000, length = 4, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false},
		{name ="combat", interval = 1400, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, radius = 5, effect = CONST_ME_SLASH, target = false},
		{name ="combat", interval = 1800, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_STONE_STORM, target = false},
		{name ="combat", interval = 1700, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -900, maxDamage = -1300, length = 8, spread = 3, effect = CONST_ME_BLACKSMOKE, target = false}

}


monster.defenses = {
	defense = 64,
	armor = 52,
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
