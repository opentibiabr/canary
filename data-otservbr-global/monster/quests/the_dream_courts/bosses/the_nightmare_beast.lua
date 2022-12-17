local mType = Game.createMonsterType("The Nightmare Beast")
local monster = {}

monster.description = "a The Nightmare Beast"
monster.experience = 255000
monster.outfit = {
	lookType = 1144,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 550000
monster.maxHealth = 550000
monster.race = "blood"
monster.corpse = 30159
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
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
	{name = "platinum coin", chance = 100000, maxCount = 5},
	{name = "piggy bank", chance = 100000},
	{name = "mysterious remains", chance = 100000},
	{name = "energy bar", chance = 100000},
	{name = "silver token", chance = 97120, maxCount = 4},
	{name = "gold token", chance = 76980, maxCount = 3},
	{name = "ultimate spirit potion", chance = 63310, maxCount = 14},
	{name = "supreme health potion", chance = 53240, maxCount = 6},
	{name = "ultimate spirit potion", chance = 47480, maxCount = 20},
	{name = "huge chunk of crude iron", chance = 40290},
	{id= 3039, chance = 32370}, -- red gem
	{name = "yellow gem", chance = 28780},
	{name = "royal star", chance = 25900, maxCount = 100},
	{name = "berserk potion", chance = 24460, maxCount = 10},
	{name = "blue gem", chance = 18710},
	{name = "mastermind potion", chance = 17990, maxCount = 10},
	{name = "green gem", chance = 17270},
	{name = "crystal coin", chance = 17270},
	{name = "skull staff", chance = 16550},
	{name = "bullseye potion", chance = 13670, maxCount = 10},
	{name = "ice shield", chance = 13670},
	{name = "chaos mace", chance = 13670},
	{name = "gold ingot", chance = 12950},
	{id = 282, chance = 10790}, -- giant shimmering pearl (brown)
	{id = 23544, chance = 10070}, -- collar of red plasma
	{id = 23542, chance = 9350}, -- collar of blue plasma
	{id = 23531, chance = 8630}, -- ring of green plasma
	{name = "ring of the sky", chance = 8630},
	{id = 23543, chance = 7910}, -- collar of green plasma
	{name = "beast's nightmare-cushion", chance = 6470},
	{name = "violet gem", chance = 6470},
	{name = "magic sulphur", chance = 6470},
	{name = "purple tendril lantern", chance = 5760},
	{id = 23529, chance = 5040}, -- ring of blue plasma
	{id = 23533, chance = 5040}, -- ring of red plasma
	{name = "soul stone", chance = 5040},
	{name = "dragon figurine", chance = 5040},
	{name = "giant sapphire", chance = 4320},
	{name = "giant emerald", chance = 4320},
	{name = "turquoise tendril lantern", chance = 2880},
	{name = "dark whispers", chance = 2880},
	{id = 3341, chance = 2880}, -- arcane staff
	{name = "giant ruby", chance = 2880},
	{name = "abyss hammer", chance = 2160},
	{id = 30342, chance = 2160}, -- enchanted sleep shawl
	{name = "unicorn figurine", chance = 1000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250}
}

monster.defenses = {
	defense = 20,
	armor = 20
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
