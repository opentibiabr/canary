local mType = Game.createMonsterType("Murcion")
local monster = {}

monster.description = "Murcion"
monster.experience = 3250000
monster.outfit = {
	lookType = 1664,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"RottenBloodBossDeath",
}

monster.bosstiary = {
	bossRaceId = 2362,
	bossRace = RARITY_NEMESIS,
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "undead"
monster.corpse = 44015
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20,
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
	staticAttackChance = 98,
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

monster.summon = {
	maxSummons = 8,
	summons = {
		{ name = "Mushroom", chance = 30, interval = 5000, count = 8 },
	},
}

monster.voices = {}

monster.loot = {
	{ id = 3043, chance = 100000, maxCount = 97 }, -- Crystal Coin
	{ id = 23373, chance = 59000, maxCount = 194 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 59000, maxCount = 168 }, -- Ultimate Spirit Potion
	{ id = 7443, chance = 53000, maxCount = 46 }, -- Bullseye Potion
	{ id = 23375, chance = 35000, maxCount = 168 }, -- Supreme Health Potion
	{ id = 3039, chance = 35000, maxCount = 4 }, -- Red Gem
	{ id = 32624, chance = 35000, maxCount = 3 }, -- Amber with a Bug
	{ id = 30060, chance = 35000 }, -- Giant Emerald
	{ id = 3038, chance = 29000, maxCount = 2 }, -- Green Gem
	{ id = 9058, chance = 29000 }, -- Gold Ingot
	{ id = 3041, chance = 29000, maxCount = 4 }, -- Blue Gem
	{ id = 32625, chance = 29000 }, -- Amber with a Dragonfly
	{ id = 3037, chance = 24000, maxCount = 5 }, -- Yellow Gem
	{ id = 32769, chance = 17600, maxCount = 2 }, -- White Gem
	{ id = 49271, chance = 17600, maxCount = 37 }, -- Transcendence Potion
	{ id = 7440, chance = 17600, maxCount = 25 }, -- Mastermind Potion
	{ id = 3036, chance = 11800, maxCount = 4 }, -- Violet Gem
	{ id = 7439, chance = 11800, maxCount = 45 }, -- Berserk Potion
	{ id = 44048, chance = 5900 }, -- Spiritual Horseshoe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1400, maxDamage = -2300 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -500, maxDamage = -900, range = 4, radius = 4, shootEffect = 31, effect = 248, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -1000, maxDamage = -1200, length = 10, spread = 0, effect = 53, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -1500, maxDamage = -1900, length = 10, spread = 0, effect = 158, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, radius = 7, effect = CONST_ME_POFF, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 105,
	armor = 105,
	{ name = "combat", interval = 3000, chance = 10, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1500, effect = 236, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
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
