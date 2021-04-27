local mType = Game.createMonsterType("Plagueroot")
local monster = {}

monster.description = "a Plagueroot"
monster.experience = 55000
monster.outfit = {
	lookType = 1121,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 20000
monster.maxHealth = 20000
monster.race = "venom"
monster.corpse = 34660
monster.speed = 170
monster.manaCost = 0
monster.maxSummons = 0

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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
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

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 5},
	{name = "Piggy Bank", chance = 100000},
	{name = "Mysterious Remains", chance = 100000},
	{name = "Energy Bar", chance = 100000},
	{name = "Silver Token", chance = 100000, maxCount = 3},
	{name = "Gold Token", chance = 22000, maxCount = 2},
	{name = "Supreme Health Potion", chance = 23550},
	{name = "Ultimate Mana Potion", chance = 25550},
	{name = "Huge Chunk of Crude Iron", chance = 27550},
	{name = "Royal Star", chance = 15770, maxCount = 100},
	{name = "Green Gem", chance = 12800, maxCount = 2},
	{name = "Yellow Gem", chance = 12000, maxCount = 2},
	{name = "Red Gem", chance = 12700, maxCount = 2},
	{name = "Bullseye Potion", chance = 25000, maxCount = 10},
	{name = "Pomegranate", chance = 8000},
	{name = "Crystal Coin", chance = 7700, maxCount = 2},
	{name = "Skull Staff", chance = 7650},
	{name = "Chaos Mace", chance = 2200},
	{name = "Gold Ingot", chance = 2800},
	{id = 26199, chance = 2500},
	{id = 7632, chance = 2600},
	{name = "Blue Gem", chance = 2500},
	{name = "Violet Gem", chance = 2300, maxCount = 2},
	{name = "Living Armor", chance = 1100},
	{name = "Magic Sulphur", chance = 1000},
	{name = "Mastermind Potion", chance = 800, maxCount = 10},
	{id = 26185, chance = 800},
	{name = "Ring of the Sky", chance = 800},
	{name = "Living Vine Bow", chance = 750},
	{name = "Abyss Hammer", chance = 700},
	{id = 26187, chance = 600},
	{name = "Plagueroot Offshoot", chance = 500},
	{name = "Turquoise Tendril Lantern", chance = 400}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 210, attack = 260},
	-- fire
	{name ="condition", type = CONDITION_FIRE, interval = 1000, chance = 7, minDamage = -200, maxDamage = -1000, range = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_BLOCKHIT, target = false},
	{name ="combat", interval = 1000, chance = 7, type = COMBAT_PHYSICALDAMAGE, minDamage = -50, maxDamage = -150, radius = 6, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 1000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -20, maxDamage = -100, radius = 5, effect = CONST_ME_BLOCKHIT, target = false},
	{name ="firefield", interval = 1000, chance = 4, radius = 8, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -150, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="combat", interval = 1000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -100, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 1000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -30, maxDamage = -100, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false}
}

monster.defenses = {
	defense = 150,
	armor = 165,
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 500, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 200, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 1000, chance = 10, speedChange = 1800, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 220},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.heals = {
	{type = COMBAT_EARTHDAMAGE, percent = 500}
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
