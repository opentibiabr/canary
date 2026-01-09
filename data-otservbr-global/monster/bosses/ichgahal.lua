local mType = Game.createMonsterType("Ichgahal")
local monster = {}

monster.description = "Ichgahal"
monster.experience = 3250000
monster.outfit = {
	lookType = 1665,
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
	bossRaceId = 2364,
	bossRace = RARITY_NEMESIS,
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "undead"
monster.corpse = 44018
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Rott!!", yell = false },
	{ text = "Putrefy!", yell = false },
	{ text = "Decay!", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 100000, maxCount = 124 }, -- Crystal Coin
	{ id = 3038, chance = 27906, maxCount = 5 }, -- Green Gem
	{ id = 3037, chance = 48148, maxCount = 5 }, -- Yellow Gem
	{ id = 3036, chance = 18518, maxCount = 4 }, -- Violet Gem
	{ id = 3039, chance = 33333, maxCount = 3 }, -- Red Gem
	{ id = 3041, chance = 27777, maxCount = 4 }, -- Blue Gem
	{ id = 32769, chance = 18518, maxCount = 3 }, -- White Gem
	{ id = 9058, chance = 18518 }, -- Gold Ingot
	{ id = 33778, chance = 33333, maxCount = 2 }, -- Raw Watermelon Tourmaline
	{ id = 32625, chance = 18518 }, -- Amber with a Dragonfly
	{ id = 32624, chance = 49999, maxCount = 2 }, -- Amber with a Bug
	{ id = 7439, chance = 22222, maxCount = 45 }, -- Berserk Potion
	{ id = 7443, chance = 24074, maxCount = 45 }, -- Bullseye Potion
	{ id = 7440, chance = 40740, maxCount = 45 }, -- Mastermind Potion
	{ id = 23375, chance = 48148, maxCount = 181 }, -- Supreme Health Potion
	{ id = 23374, chance = 61111, maxCount = 153 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 51851, maxCount = 179 }, -- Ultimate Mana Potion
	{ id = 43502, chance = 1000 }, -- The Essence of Ichgahal
	{ id = 30054, chance = 1000 }, -- Unicorn Figurine
	{ id = 43964, chance = 9259 }, -- Ichgahal's Fungal Infestation
	{ id = 43962, chance = 9090 }, -- Putrefactive Figurine
	{ id = 44048, chance = 1000 }, -- Spiritual Horseshoe
	{ id = 43899, chance = 1000 }, -- Cursed Wood
	{ id = 43860, chance = 1000 }, -- Bag You Covet
	{ id = 39038, chance = 1000 }, -- Royal Almandine
	{ id = 49271, chance = 16279, maxCount = 35 }, -- Transcendence Potion
	{ id = 30053, chance = 4651 }, -- Dragon Figurine
}

monster.attacks = {
	{ name = "melee", interval = 3000, chance = 100, minDamage = -1500, maxDamage = -2300 },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -700, maxDamage = -1000, length = 12, spread = 0, effect = 249, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -2600, maxDamage = -2300, length = 12, spread = 0, effect = 193, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -900, maxDamage = -1500, length = 6, spread = 0, effect = CONST_ME_FIREAREA, target = false },
	{ name = "speed", interval = 2000, chance = 35, speedChange = -600, radius = 8, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
}

monster.defenses = {
	defense = 105,
	armor = 105,
	{ name = "combat", interval = 3000, chance = 10, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1200, effect = 236, target = false },
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
