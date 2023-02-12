local mType = Game.createMonsterType("The Duke Of The Depths")
local monster = {}

monster.description = "The Duke Of The Depths"
monster.experience = 40000
monster.outfit = {
	lookType = 1047,
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
monster.corpse = 27641
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 50
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
	{id = 3035, chance = 67610, maxCount = 58}, -- platinum coin
	{id = 3043, chance = 67610}, -- crystal coin
	{id = 16119, chance = 14710, maxCount = 4}, -- blue crystal shard
	{id = 3032, chance = 13160, maxCount = 12}, -- small emerald
	{id = 9057, chance = 11480, maxCount = 12}, -- small topaz
	{id = 3033, chance = 14520, maxCount = 12}, -- small amethyst
	{id = 238, chance = 14520, maxCount = 18}, -- great mana potion
	{id = 3028, chance = 14520, maxCount = 2}, -- small diamond
	{id = 3030, chance = 14520, maxCount = 12}, -- small ruby
	{id = 239, chance = 14520, maxCount = 8}, -- great health potion
	{id = 7642, chance = 14520, maxCount = 10}, -- great spirit potion
	{id = 7643, chance = 14520, maxCount = 8}, -- ultimate health potion
	{id = 7440, chance = 10060}, -- mastermind potion
	{id = 3039, chance = 14520}, -- red gem
	{id = 3037, chance = 14520}, -- yellow gem
	{id = 27619, chance = 10000}, -- giant tentacle
	{id = 8900, chance = 17230}, -- heavily rusted shield
	{id = 5892, chance = 14520}, -- huge chunk of crude iron
	{id = 3071, chance = 14520}, -- wand of inferno
	{id = 3320, chance = 15810}, -- fire axe
	{id = 3280, chance = 14520}, -- fire sword
	{id = 811, chance = 14520}, -- terra mantle
	{id = 11454, chance = 14520}, -- luminous orb
	{id = 3081, chance = 14520}, -- stone skin amulet
	{id = 8908, chance = 14520}, -- slightly rusted helmet
	{id = 5904, chance = 14520}, -- magic sulphur
	{id = 27657, chance = 1000}, -- crude wood planks
	{id = 27651, chance = 600}, -- gnome sword
	{id = 27649, chance = 510}, -- gnome legs
	{id = 27650, chance = 560}, -- gnome shield
	{id = 22721, chance = 580}, -- gold token
	{id = 27526, chance = 520}, -- mallet pommel
	{id = 27648, chance = 400} -- gnome armor
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -1000, range = 3, length = 6, spread = 8, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -1000, range = 3, length = 9, spread = 4, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -135, maxDamage = -1000, radius = 2, effect = CONST_ME_EXPLOSIONAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1000, radius = 8, effect = CONST_ME_HITAREA, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 40
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 60},
	{type = COMBAT_ENERGYDAMAGE, percent = 60},
	{type = COMBAT_EARTHDAMAGE, percent = 60},
	{type = COMBAT_FIREDAMAGE, percent = 100},
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

monster.heals = {
	{type = COMBAT_FIREDAMAGE, percent = 100},
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
