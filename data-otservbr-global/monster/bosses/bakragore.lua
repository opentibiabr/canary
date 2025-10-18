local mType = Game.createMonsterType("Bakragore")
local monster = {}

monster.description = "Bakragore"
monster.experience = 15000000
monster.outfit = {
	lookType = 1671,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"RottenBloodBakragoreDeath",
}

monster.bosstiary = {
	bossRaceId = 2367,
	bossRace = RARITY_NEMESIS,
}

monster.health = 660000
monster.maxHealth = 660000
monster.race = "undead"
monster.corpse = 44012
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
	maxSummons = 2,
	summons = {
		{ name = "Elder Bloodjaw", chance = 20, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Light ... darkens!", yell = false },
	{ text = "Light .. the ... darkness!", yell = false },
	{ text = "Darkness ... is ... light!", yell = false },
	{ text = "WILL ... PUNISH ... YOU!", yell = false },
	{ text = "RAAAR!", yell = false },
}

monster.loot = {
	{ id = 43946, chance = 1000 }, -- Abridged Promotion Scroll
	{ id = 43950, chance = 1000 }, -- Advanced Promotion Scroll
	{ id = 43860, chance = 1000 }, -- Bag You Covet
	{ id = 43968, chance = 12000 }, -- Bakragore's Amalgamation
	{ id = 43947, chance = 1000 }, -- Basic Promotion Scroll
	{ id = 7439, chance = 32000, maxCount = 81 }, -- Berserk Potion
	{ id = 3041, chance = 8000, maxCount = 9 }, -- Blue Gem
	{ id = 7443, chance = 8000, maxCount = 28 }, -- Bullseye Potion
	{ id = 3043, chance = 100000, maxCount = 168 }, -- Crystal Coin
	{ id = 43961, chance = 1000 }, -- Darklight Figurine
	{ id = 30053, chance = 16000 }, -- Dragon Figurine
	{ id = 43949, chance = 1000 }, -- Extended Promotion Scroll
	{ id = 39040, chance = 8000 }, -- Fiery Tear
	{ id = 43963, chance = 1000 }, -- Figurine of Bakragore
	{ id = 32622, chance = 24000, maxCount = 3 }, -- Giant Amethyst
	{ id = 30061, chance = 36000, maxCount = 6 }, -- Giant Sapphire
	{ id = 30059, chance = 24000, maxCount = 6 }, -- Giant Ruby
	{ id = 43962, chance = 1000 }, -- Putrefactive Figurine
	{ id = 43948, chance = 1000 }, -- Revised Promotion Scroll
	{ id = 23373, chance = 64000, maxCount = 37 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 52000, maxCount = 200 }, -- Ultimate Spirit Potion
	{ id = 3036, chance = 28000, maxCount = 6 }, -- Violet Gem
	{ id = 3037, chance = 28000, maxCount = 7 }, -- Yellow Gem
	{ id = 39037, chance = 1000 }, -- Cobalt Ridge
	{ id = 7440, chance = 16000, maxCount = 67 }, -- Mastermind Potion
	{ id = 3038, chance = 20000, maxCount = 8 }, -- Green Gem
	{ id = 32623, chance = 36000, maxCount = 6 }, -- Giant Topaz
	{ id = 3039, chance = 16000, maxCount = 3 }, -- Red Gem
	{ id = 23375, chance = 40000, maxCount = 110 }, -- Supreme Health Potion
	{ id = 44048, chance = 4000 }, -- Spiritual Horseshoe
	{ id = 49271, chance = 12000, maxCount = 61 }, -- Transcendence Potion
	{ id = 30060, chance = 44000, maxCount = 4 }, -- Giant Emerald
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -3000 },
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_ICEDAMAGE, minDamage = -900, maxDamage = -1100, range = 7, radius = 7, shootEffect = CONST_ANI_ICE, effect = 243, target = true },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -1000, length = 8, spread = 0, effect = 252, target = false },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -1000, maxDamage = -2000, length = 8, spread = 0, effect = 249, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ICEDAMAGE, minDamage = -950, maxDamage = -2400, range = 7, radius = 3, shootEffect = 37, effect = 240, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -1000, maxDamage = -2500, length = 8, spread = 0, effect = 244, target = false },
}

monster.defenses = {
	defense = 135,
	armor = 135,
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_HEALING, minDamage = 2500, maxDamage = 3500, effect = 236, target = false },
	{ name = "speed", interval = 4000, chance = 80, speedChange = 700, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
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
