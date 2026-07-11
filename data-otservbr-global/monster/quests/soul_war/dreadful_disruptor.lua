local mType = Game.createMonsterType("Dreadful Disruptor")
local monster = {}

monster.description = "Dreadful Disruptor"
monster.experience = 14000
monster.outfit = {
	lookType = 879,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 14000
monster.maxHealth = 14000
monster.race = "venom"
monster.corpse = 23478
monster.speed = 165
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1279,
	bossRace = RARITY_NEMESIS,
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
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 23515, chance = 100000 }, -- Dangerous Proto Matter
	{ id = 23520, chance = 100000 }, -- Plasmatic Lightning
	{ id = 3035, chance = 100000, maxCount = 24 }, -- Platinum Coin
	{ id = 3031, chance = 100000, maxCount = 93 }, -- Gold Coin
	{ id = 23506, chance = 100000 }, -- Plasma Pearls
	{ id = 23535, chance = 100000, maxCount = 5 }, -- Energy Bar
	{ id = 23545, chance = 100000, maxCount = 5 }, -- Energy Drink
	{ id = 23508, chance = 100000 }, -- Energy Vein
	{ id = 23533, chance = 50000 }, -- Ring of Red Plasma
	{ id = 23526, chance = 29000 }, -- Collar of Blue Plasma
	{ id = 239, chance = 29000, maxCount = 5 }, -- Great Health Potion
	{ id = 23543, chance = 25000 }, -- Collar of Green Plasma
	{ id = 7642, chance = 25000, maxCount = 5 }, -- Great Spirit Potion
	{ id = 238, chance = 21000, maxCount = 5 }, -- Great Mana Potion
	{ id = 23531, chance = 21000 }, -- Ring of Green Plasma
	{ id = 16120, chance = 16700, maxCount = 5 }, -- Violet Crystal Shard
	{ id = 23529, chance = 16700 }, -- Ring of Blue Plasma
	{ id = 16119, chance = 12500, maxCount = 5 }, -- Blue Crystal Shard
	{ id = 3039, chance = 12500 }, -- Red Gem
	{ id = 16124, chance = 8300, maxCount = 9 }, -- Blue Crystal Splinter
	{ id = 16126, chance = 8300 }, -- Red Crystal Fragment
	{ id = 822, chance = 4200 }, -- Lightning Legs
	{ id = 23544, chance = 4200 }, -- Collar of Red Plasma
	{ id = 3036, chance = 4200 }, -- Violet Gem
	{ id = 8092, chance = 4200 }, -- Wand of Starstorm
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{
		name = "combat",
		type = COMBAT_ENERGYDAMAGE,
		interval = 2000,
		chance = 20,
		minDamage = -400,
		maxDamage = -600,
		radius = 5,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_LIFEDRAIN,
		minDamage = -250,
		maxDamage = -400,
		range = 4,
		radius = 4,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{ name = "dread intruder wave", interval = 2000, chance = 25, minDamage = -350, maxDamage = -550, target = false },
}

monster.defenses = {
	defense = 52,
	armor = 53,
	mitigation = 1.46,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 25 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval) end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature) end

mType.onMove = function(monster, creature, fromPosition, toPosition) end

mType.onSay = function(monster, creature, type, message) end

mType:register(monster)
