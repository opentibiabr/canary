local mType = Game.createMonsterType("Lloyd")
local monster = {}

monster.description = "Lloyd"
monster.experience = 50000
monster.outfit = {
	lookType = 940,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 64000
monster.maxHealth = 64000
monster.race = "venom"
monster.corpse = 24927
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20
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
	runHealth = 1,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.events = {
	"LloydPrepareDeath"
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
	{id = 3031, chance = 97000, maxCount = 200}, -- gold coin
	{id = 3035, chance = 90000, maxCount = 30}, -- platinum coin
	{id = 238, chance = 22120, maxCount = 3}, -- great mana potion
	{id = 7643, chance = 19500, maxCount = 3}, -- ultimate health potion
	{id = 3387, chance = 1000}, -- demon helmet
	{id = 16119, chance = 9660, maxCount = 5}, -- blue crystal shard
	{id = 16120, chance = 9660, maxCount = 5}, -- violet crystal shard
	{id = 16121, chance = 9660, maxCount = 5}, -- green crystal shard
	{id = 3032, chance = 9660, maxCount = 5}, -- small emerald
	{id = 3030, chance = 7360, maxCount = 5}, -- small ruby
	{id = 9057, chance = 7350, maxCount = 5}, -- small topaz
	{id = 3033, chance = 7150, maxCount = 5}, -- small amethyst
	{id = 5888, chance = 5888, maxCount = 2}, -- piece of hell steel
	{id = 5887, chance = 5909, maxCount = 2}, -- piece of royal steel
	{id = 7424, chance = 5000}, -- lunar staff
	{id = 3041, chance = 5000}, -- blue gem
	{id = 3038, chance = 5000}, -- green gem
	{id = 3037, chance = 5000}, -- yellow gem
	{id = 3079, chance = 5000}, -- boots of haste
	{id = 23542, chance = 5000}, -- collar of blue plasma
	{id = 5891, chance = 5000}, -- enchanted chicken wing
	{id = 822, chance = 5000}, -- lightning legs
	{id = 11454, chance = 5000}, -- luminous orb
	{id = 7440, chance = 5000}, -- mastermind potion
	{id = 5904, chance = 5000}, -- magic sulphur
	{id = 24959, chance = 500, unique = true}, -- part of a rune
	{id = 3098, chance = 1970}, -- ring of healing
	{id = 8092, chance = 1970}, -- wand of starstorm
	{id = 8072, chance = 1970}, -- spellbook of enlightenment
	{id = 10438, chance = 1970}, -- spellweaver's robe
	{id = 22727, chance = 1970}, -- rift lance
	{id = 22721, chance = 100000}, -- gold token
	{id = 22516, chance = 100000} -- silver token
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -1400},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -130, maxDamage = -460, length = 6, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="lloyd wave", interval = 2000, chance = 12, minDamage = -430, maxDamage = -560, target = false},
	{name ="lloyd wave2", interval = 2000, chance = 12, minDamage = -230, maxDamage = -460, target = false},
	{name ="lloyd wave3", interval = 2000, chance = 12, minDamage = -430, maxDamage = -660, target = false}
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 180, maxDamage = 250, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
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
