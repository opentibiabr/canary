local mType = Game.createMonsterType("Maxxenius")
local monster = {}

monster.description = "a Maxxenius"
monster.experience = 55000
monster.outfit = {
	lookType = 1142,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 20000
monster.maxHealth = 20000
monster.race = "blood"
monster.corpse = 30151
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.bosstiary = {
	bossRaceId = 1697,
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
	{name = "mysterious remains", chance = 100000},
	{name = "piggy bank", chance = 100000},
	{name = "brain in a jar", chance = 100000},
	{name = "maxxenius head", chance = 100000},
	{name = "silver token", chance = 100000, maxCount = 3},
	{name = "energy bar", chance = 100000},
	{name = "crystal coin", chance = 13790},
	{name = "gold ingot", chance = 17240},
	{name = "bullseye potion", chance = 24114, maxCount = 10},
	{name = "mastermind potion", chance = 17240, maxCount = 10},
	{name = "royal star", chance = 100000, maxCount = 100},
	{name = "supreme health potion", chance = 41380, maxCount = 20},
	{name = "ultimate spirit potion", chance = 48280, maxCount = 60},
	{name = "ultimate mana potion", chance = 68970, maxCount = 14},
	{name = "giant ruby", chance = 3450},
	{name = "ornate locket", chance = 3450},
	{name = "gold token", chance = 68970, maxCount = 2},
	{id = 281, chance = 28540}, -- giant shimmering pearl (green)
	{name = "pomegranate", chance = 24140},
	{name = "chaos mace", chance = 6900},
	{id = 23528, chance = 17240}, -- collar of red plasma
	{id = 23543, chance = 13790}, -- collar of green plasma
	{name = "green gem", chance = 31030},
	{name = "yellow gem", chance = 31030},
	{name = "violet gem", chance = 6900},
	{name = "blue gem", chance = 10340},
	{name = "huge chunk of crude iron", chance = 17240},
	{id = 23529, chance = 3450}, -- ring of blue plasma
	{name = "skull staff", chance = 13790},
	{name = "energized limb", chance = 3450},
	{name = "purple tendril lantern", chance = 1500}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000},
	{name ="energy beam", interval = 2000, chance = 10, minDamage = -500, maxDamage = -1200, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="energy wave", interval = 2000, chance = 10, minDamage = -500, maxDamage = -1200, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false}
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.heals = {
	{type = COMBAT_ENERGYDAMAGE, percent = 500}
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
