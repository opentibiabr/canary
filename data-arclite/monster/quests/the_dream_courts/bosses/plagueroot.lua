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
monster.corpse = 30022
monster.speed = 85
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.bosstiary = {
	bossRaceId = 1695,
	bossRace = RARITY_NEMESIS
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
}

monster.loot = {
	{name = "platinum coin", chance = 100000, maxCount = 5},
	{name = "piggy bank", chance = 100000},
	{name = "mysterious remains", chance = 100000},
	{name = "energy bar", chance = 100000},
	{name = "silver token", chance = 100000, maxCount = 3},
	{name = "gold token", chance = 22000, maxCount = 2},
	{name = "supreme health potion", chance = 23550},
	{name = "ultimate mana potion", chance = 25550},
	{name = "huge chunk of crude iron", chance = 27550},
	{name = "royal star", chance = 15770, maxCount = 100},
	{name = "green gem", chance = 12800, maxCount = 2},
	{name = "yellow gem", chance = 12000, maxCount = 2},
	{id= 3039, chance = 12700, maxCount = 2}, -- red gem
	{name = "bullseye potion", chance = 25000, maxCount = 10},
	{name = "pomegranate", chance = 8000},
	{name = "crystal coin", chance = 7700, maxCount = 2},
	{name = "skull staff", chance = 7650},
	{name = "chaos mace", chance = 2200},
	{name = "gold ingot", chance = 2800},
	{id = 23543, chance = 2500}, -- collar of green plasma
	{id = 281, chance = 2600}, -- giant shimmering pearl (green)
	{name = "blue gem", chance = 2500},
	{name = "violet gem", chance = 2300, maxCount = 2},
	{name = "living armor", chance = 1100},
	{name = "magic sulphur", chance = 1000},
	{name = "mastermind potion", chance = 800, maxCount = 10},
	{id = 23529, chance = 800}, -- ring of blue plasma
	{name = "ring of the sky", chance = 800},
	{name = "living vine bow", chance = 750},
	{name = "abyss hammer", chance = 700},
	{id = 23531, chance = 600}, -- ring of green plasma
	{name = "plagueroot offshoot", chance = 500},
	{name = "turquoise tendril lantern", chance = 400}
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
