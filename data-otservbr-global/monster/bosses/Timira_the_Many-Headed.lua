local mType = Game.createMonsterType("Timira the Many-Headed")
local monster = {}

monster.description = "Timira the Many-Headed"
monster.experience = 45500
monster.outfit = {
	lookType = 1542,
	lookHead = 114,
	lookBody = 74,
	lookLegs = 10,
	lookFeet = 79,
	lookAddons = 2,
	lookMount = 0
}

monster.health = 595000
monster.maxHealth = 595000
monster.race = "blood"
monster.corpse = 39712
monster.speed = 685
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
}

monster.bosstiary = {
	bossRaceId = 2250,
	bossRace = RARITY_ARCHFOE,
	storageCooldown = Storage.Quest.U12_90.WithinTheTides.TimiraTheManyHeadedTimer
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	 
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
	{name = "naga basin", chance = 5300, maxcount = 1},
	{name = "crystal coin", chance = 7000, maxcount = 35},
	{name = "giant amethyst", chance = 7000, maxcount = 1},
	{name = "giant sapphire", chance = 7000, maxcount = 1},
	{name = "ultimate mana potion", chance = 7000, maxcount = 14},
	{name = "mastermind potion", chance = 7000, maxcount = 1},
	{name = "bullseye potion", chance = 7000, maxcount = 1},
	{name = "giant emerald", chance = 7000, maxcount = 1},
	{name = "ultimate health potion", chance = 7000, maxcount = 1},
	{name = "berserk potion", chance = 7000, maxcount = 1},
	{name = "giant ruby", chance = 7000, maxcount = 1},
	{name = "piece of timira's sensors", chance = 7000, maxcount = 1},
	{name = "one of timira's many heads", chance = 7000, maxcount = 1},
	{name = "frostflower boots", chance = 300, maxcount = 1},
	{id = 39233, chance = 7000, maxcount = 1},
	{name = "dawnfire sherwani", chance = 300, maxcount = 1},
	{name = "naga crossbow", chance = 200, maxcount = 1},
	{name = "feverbloom boots", chance = 300, maxcount = 1},
	{name = "naga club", chance = 450, maxcount = 1},
	{name = "midnight tunic", chance = 300, maxcount = 1},
	{name = "giant topaz", chance = 7000, maxcount = 1},
	{name = "dawnfire pantaloons", chance = 300, maxcount = 1},
	{name = "midnight sarong", chance = 500, maxcount = 1},
	{name = "naga quiver", chance = 250, maxcount = 1},
	{name = "naga rod", chance = 350, maxcount = 1},
	{name = "naga sword", chance = 350, maxcount = 1},
	{name = "naga wand", chance = 350, maxcount = 1}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -800},
	{name ="combat", interval = 1500, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -700, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, target = true},
	{name ="combat", interval = 1500, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -650, length = 4, spread = 3, effect = CONST_ME_ENERGYHIT, target = false},
	{name ="combat", interval = 1500, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -80, maxDamage = -550, radius = 4, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 1500, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -80, maxDamage = -550, radius = 4, effect = CONST_ME_FIREAREA, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 82,
	{name ="combat", interval = 1000, chance = 9, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 2500, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="combat", interval = 1000, chance = 17, type = COMBAT_HEALING, minDamage = 600, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 1000, chance = 5, speedChange = 1901, effect = CONST_ME_MAGIC_RED, target = false, duration = 7000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = 50},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 40},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 40},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 40}
}

monster.immunities = {
	{type = "paralyze", condition = false},
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
