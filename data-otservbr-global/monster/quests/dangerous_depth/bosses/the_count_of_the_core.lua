local mType = Game.createMonsterType("The Count Of The Core")
local monster = {}

monster.description = "The Count Of The Core"
monster.experience = 40000
monster.outfit = {
	lookType = 1046,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "blood"
monster.corpse = 27637
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 10
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
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Sluuuurp! Sluuuuurp!", yell = false},
	{text = "Shluush!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 10000, maxCount = 36},
	{name = "great mana potion", chance = 10000, maxCount = 18},
	{name = "great spirit potion", chance = 10000, maxCount = 10},
	{name = "green crystal shard", chance = 10000, maxCount = 4},
	{name = "huge chunk of crude iron", chance = 10000, maxCount = 2},
	{name = "magic sulphur", chance = 10000, maxCount = 2},
	{name = "mastermind potion", chance = 10000, maxCount = 2},
	{name = "small amethyst", chance = 10000, maxCount = 10},
	{name = "small diamond", chance = 10000, maxCount = 10},
	{name = "small emerald", chance = 10000, maxCount = 12},
	{name = "small ruby", chance = 10000, maxCount = 10},
	{name = "small topaz", chance = 10000, maxCount = 10},
	{name = "ultimate health potion", chance = 10000, maxCount = 5},
	{name = "amber staff", chance = 10000},
	{name = "blue gem", chance = 10000},
	{id = 27626, chance = 10000}, -- chitinous mouth
	{name = "crystal coin", chance = 10000},
	{name = "crystalline armor", chance = 5000},
	{name = "dragon necklace", chance = 10000},
	{name = "fire axe", chance = 10000},
	{name = "fire sword", chance = 10000},
	{id = 281, chance = 10000}, -- giant shimmering pearl (green)
	{name = "giant sword", chance = 10000},
	{name = "guardian axe", chance = 10000},
	{name = "gold token", chance = 10000},
	{name = "green gem", chance = 10000},
	{name = "harpoon of a giant snail", chance = 10000},
	{name = "huge spiky snail shell", chance = 10000},
	{name = "luminous orb", chance = 10000},
	{id= 3039, chance = 10000}, -- red gem
	{name = "silver token", chance = 1000},
	{name = "stone skin amulet", chance = 1000},
	{name = "twiceslicer", chance = 1000},
	{name = "wand of inferno", chance = 1000},
	{name = "yellow gem", chance = 1000},
	{name = "candle stump", chance = 1000},
	{name = "gnome shield", chance = 1000},
	{name = "gnome sword", chance = 1000},
	{name = "mallet handle", chance = 1000},
	{name = "tinged pot", chance = 1000},
	{name = "gnome helmet", chance = 100}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1500},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1500, range = 3, length = 9, spread = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1500, range = 3, length = 9, spread = 4, effect = CONST_ME_SMALLCLOUDS, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1500, radius = 8, effect = CONST_ME_HITAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1500, radius = 8, effect = CONST_ME_BLACKSMOKE, target = false}
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 60},
	{type = COMBAT_ENERGYDAMAGE, percent = 60},
	{type = COMBAT_EARTHDAMAGE, percent = 60},
	{type = COMBAT_FIREDAMAGE, percent = -100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 60},
	{type = COMBAT_HOLYDAMAGE , percent = 60},
	{type = COMBAT_DEATHDAMAGE , percent = 60}
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
