local mType = Game.createMonsterType("Outburst")
local monster = {}

monster.description = "Outburst"
monster.experience = 50000
monster.outfit = {
	lookType = 876,
	lookHead = 79,
	lookBody = 3,
	lookLegs = 94,
	lookFeet = 3,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "venom"
monster.corpse = 23564
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25
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

monster.events = {
	"HeartBossDeath",
	"OutburstCharge"
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
	{id = 3031, chance = 100000, maxCount = 200}, -- gold coin
	{id = 3035, chance = 100000, maxCount = 10}, -- platinum coin
	{id = 16119, chance = 8000, maxCount = 3}, -- blue crystal shard
	{id = 238, chance = 8000, maxCount = 10}, -- great mana potion
	{id = 16121, chance = 8000, maxCount = 3}, -- green crystal shard
	{id = 3033, chance = 8000, maxCount = 10}, -- small amethyst
	{id = 3029, chance = 8000, maxCount = 5}, -- small sapphire
	{id = 7643, chance = 8000, maxCount = 5}, -- ultimate health potion
	{id = 16120, chance = 8000, maxCount = 3}, -- violet crystal shard
	{id = 22721, chance = 100000}, -- gold token
	{id = 23509, chance = 100000}, -- mysterious remains
	{id = 3038, chance = 8000}, -- green gem
	{id = 7427, chance = 6000}, -- chaos mace
	{id = 23533, chance = 5000}, -- ring of red plasma
	{id = 23474, chance = 2000, unique = true}, -- tiara of power
	{id = 23477, chance = 2000, unique = true}, -- void boots
	{id = 16160, chance = 2000, unique = true} -- crystalline sword
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -1800},
	{name ="big energy purple wave", interval = 2000, chance = 25, minDamage = -700, maxDamage = -1300, target = false},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -600, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -800, maxDamage = -1300, length = 8, spread = 3, effect = CONST_ME_HITAREA, target = false},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -600, maxDamage = -900, length = 8, spread = 3, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="big skill reducer", interval = 2000, chance = 25, target = false},
	{name ="anomaly break", interval = 2000, chance = 40, target = false}
}

monster.defenses = {
	defense = 100,
	armor = 100
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
