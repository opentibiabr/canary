local mType = Game.createMonsterType("Dragon Hoard")
local monster = {}

monster.description = "Dragon Hoard"
monster.experience = 0
monster.outfit = {
	lookTypeEx = 5674,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"TwentyYearsACookBossDeath",
}

monster.bosstiary = {
	bossRace = RARITY_ARCHFOE,
	bossRaceId = 2466,
}

monster.health = 999999
monster.maxHealth = 999999
monster.race = "blood"
monster.corpse = 0
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 4,
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
	hostile = false,
	convinceable = false,
	pushable = false,
	boss = true,
	rewardBoss = true,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 100,
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

monster.loot = {
	{ id = 3043, chance = 100000, maxCount = 4 }, -- Crystal Coin
	{ id = 3031, chance = 100000, maxCount = 387 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 200 }, -- Platinum Coin
	{ id = 3041, chance = 34000, maxCount = 2 }, -- Blue Gem
	{ id = 32769, chance = 29000, maxCount = 2 }, -- White Gem
	{ id = 7441, chance = 26000 }, -- Ice Cube
	{ id = 6499, chance = 23000, maxCount = 2 }, -- Demonic Essence
	{ id = 3061, chance = 23000 }, -- Life Crystal
	{ id = 3037, chance = 20000, maxCount = 2 }, -- Yellow Gem
	{ id = 3373, chance = 17100 }, -- Strange Helmet
	{ id = 7430, chance = 14300 }, -- Dragonbone Staff
	{ id = 3280, chance = 14300 }, -- Fire Sword
	{ id = 3392, chance = 11400 }, -- Royal Helmet
	{ id = 3071, chance = 11400 }, -- Wand of Inferno
	{ id = 3297, chance = 8600 }, -- Serpent Sword
	{ id = 32622, chance = 8600 }, -- Giant Amethyst
	{ id = 7402, chance = 8600 }, -- Dragon Slayer
	{ id = 10388, chance = 8600, maxCount = 2 }, -- Drakinata
	{ id = 3428, chance = 5700 }, -- Tower Shield
	{ id = 7290, chance = 5700 }, -- Shard
	{ id = 10451, chance = 5700 }, -- Jade Hat
	{ id = 44751, chance = 5700 }, -- Gold-Scaled Sentinel
	{ id = 3301, chance = 5700 }, -- Broadsword
	{ id = 30060, chance = 2900 }, -- Giant Emerald
	{ id = 44750, chance = 2900 }, -- Exalted Seal
	{ id = 30061, chance = 2900 }, -- Giant Sapphire
	{ id = 44752, chance = 2900 }, -- Crystallised Blood
	{ id = 8057, chance = 2900 }, -- Divine Plate
	{ id = 32623, chance = 2900 }, -- Giant Topaz
}

monster.attacks = {}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
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
