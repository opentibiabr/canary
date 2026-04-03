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
	{ id = 3035, chance = 100000, maxCount = 5 }, -- platinum coin
	{ id = 23535, chance = 15000 }, -- energy bar
	{ id = 23545, chance = 15000 }, -- energy drink
	{ id = 23516, chance = 15000 }, -- instable proto matter
	{ id = 239, chance = 12200 }, -- great health potion
	{ id = 238, chance = 12000 }, -- great mana potion
	{ id = 7642, chance = 11700 }, -- great spirit potion
	{ id = 23507, chance = 11500 }, -- crystallized anger
	{ id = 23511, chance = 10600 }, -- curious matter
	{ id = 23514, chance = 9600 }, -- volatile proto matter
	{ id = 23506, chance = 9600 }, -- plasma pearls
	{ id = 16124, chance = 7400, maxCount = 2 }, -- blue crystal splinter
	{ id = 16125, chance = 6500 }, -- cyan crystal fragment
	{ id = 16119, chance = 4400 }, -- blue crystal shard
	{ id = 16121, chance = 4100 }, -- green crystal shard
	{ id = 23544, chance = 4470 }, -- collar of red plasma
	{ id = 23542, chance = 4470 }, -- collar of blue plasma
	{ id = 50150, chance = 350 }, -- ring of orange plasma
	{ id = 50152, chance = 350 }, -- collar of orange plasma
	{ name = "spark sphere", chance = 14870 },
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
