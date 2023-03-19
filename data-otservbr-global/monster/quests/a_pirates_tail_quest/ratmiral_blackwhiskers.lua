local mType = Game.createMonsterType("Ratmiral Blackwhiskers")
local monster = {}

monster.description = "Ratmiral Blackwhiskers"
monster.experience = 50000
monster.outfit = {
	lookType = 1377,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 220000
monster.maxHealth = 220000
monster.race = "blood"
monster.corpse = 35846
monster.speed = 115
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

monster.summon = {
	maxSummons = 4,
	summons = {
		{name = "elite pirat", chance = 30, interval = 1000},
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "crystal coin", chance = 10000, maxCount = 2},
	{name = "platinum coin", chance = 10000, maxCount = 20},
	{name = "ultimate health potion", chance = 7300, maxCount = 10},
	{name = "great spirit potion", chance = 7300, maxCount = 10},
	{name = "ultimate mana potion", chance = 7300, maxCount = 10},
	{name = "great mana potion", chance = 7300, maxCount = 10},
	{name = "great health potion", chance = 7300, maxCount = 10},
	{name = "berserk potion", chance = 7300, maxCount = 5},
	{name = "bullseye potion", chance = 7300, maxCount = 5},
	{name = "mastermind potion", chance = 7300, maxCount = 5},
	{name = "pirate coin", chance = 7300, maxCount = 55},
	{name = "small treasure chest", chance = 5400},
	{name = "golden dustbin", chance = 5400},
	{name = "ratmiral's hat", chance = 5400},
	{name = "golden cheese wedge", chance = 5400},
	{name = "cheesy membership card", chance = 5400},
	{name = "golden skull", chance = 5400},
	{name = "tiara", chance = 5400},
	{name = "amber", chance = 5400},
	{name = "scrubbing brush", chance = 1000},
	{name = "soap", chance = 750},
	{name = "exotic amulet", chance = 650},
	{name = "throwing axe", chance = 650},
	{name = "bast legs", chance = 650},
	{name = "jungle bow", chance = 650},
	{name = "jungle quiver", chance = 650},
	{name = "jungle flail", chance = 650},
	{name = "exotic legs", chance = 650},
	{name = "makeshift boots", chance = 650},
	{name = "make-do boots", chance = 650}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -270, maxDamage = -500},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -600, range = 7, shootEffect = CONST_ANI_WHIRLWINDCLUB, target = true},
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -600, radius = 4, effect = CONST_ME_MAGIC_RED, target = false},
	{name = "combat", interval = 2000, chance = 30, type = COMBAT_LIFEDRAIN, minDamage = -600, maxDamage = -1000, length = 4, spread = 0, effect = CONST_ME_SOUND_PURPLE, target = false}
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