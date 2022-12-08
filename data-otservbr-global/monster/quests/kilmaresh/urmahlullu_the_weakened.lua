local mType = Game.createMonsterType("Urmahlullu the Weakened")
local monster = {}

monster.description = "urmahlullu the weakened"
monster.experience = 85000
monster.outfit = {
	lookType = 1197,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 100000
monster.maxHealth = 512000
monster.race = "blood"
monster.corpse = 31413
monster.speed = 95
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.events = {
	"WeakenedDeath"
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "You will regret this!", yell = false}
}

monster.loot = {
	{name = "platinum coin", chance = 96000, maxCount = 6},
	{name = "ultimate mana potion", chance = 51000, maxCount = 20},
	{id= 3039, chance = 39000, maxCount = 2}, -- red gem
	{name = "berserk potion", chance = 15000, maxCount = 10},
	{name = "flash arrow", chance = 30000, maxCount = 100},
	{name = "crystal coin", chance = 12000, maxCount = 3},
	{name = "silver token", chance = 9000, maxCount = 3},
	{name = "mastermind potion", chance = 12000, maxCount = 10},
	{name = "supreme health potion", chance = 51000, maxCount = 20},
	{name = "ultimate spirit potion", chance = 42000, maxCount = 20},
	{name = "royal star", chance = 30000, maxCount = 100},
	{name = "bullseye potion", chance = 18000, maxCount = 10},
	{name = "lightning pendant", chance = 27000},
	{name = "giant ruby", chance = 6000},
	{name = "urmahlullu's mane", chance = 6000},
	{name = "urmahlullu's paw", chance = 6000},
	{name = "urmahlullu's tail", chance = 6000},
	{name = "tagralt blade", chance = 500},
	{name = "winged boots", chance = 500},
	{name = "energy bar", chance = 93000},
	{name = "yellow gem", chance = 46000},
	{name = "green gem", chance = 21000},
	{name = "magma coat", chance = 6000},
	{id = 281, chance = 12000}, -- giant shimmering pearl (green)
	{name = "violet gem", chance = 6000},
	{name = "magma monocle", chance = 3000},
	{id = 31557, chance = 3000}, -- blister ring
	{name = "blue gem", chance = 12000},
	{name = "magma amulet", chance = 12000},
	{name = "gold ingot", chance = 9000},
	{name = "giant emerald", chance = 6000},
	{id = 31263, chance = 100000}, -- ring of secret thoughts
	{name = "giant sapphire", chance = 6000},
	{name = "winged backpack", chance = 250},
	{name = "rainbow necklace", chance = 160},
	{id = 30403, chance = 160}, -- enchanted theurgic amulet
	{name = "sun medal", chance = 160},
	{name = "sunray emblem", chance = 160}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -50, maxDamage = -1100},
	{name ="combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, radius = 4, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -550, maxDamage = -800, radius = 3, effect = CONST_ME_FIREAREA, target = false},
	{name ="urmahlulluring", interval = 2000, chance = 18, minDamage = -450, maxDamage = -600, target = false}
}

monster.defenses = {
	defense = 84,
	armor = 84
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 40},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
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
