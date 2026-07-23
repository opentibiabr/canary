local mType = Game.createMonsterType("Vemiath")
local monster = {}

monster.description = "Vemiath"
monster.experience = 3250000
monster.outfit = {
	lookType = 1668,
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
	bossRaceId = 2365,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "undead"
monster.corpse = 44021
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

monster.summon = {}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The light... that... drains!", yell = false },
	{ text = "RAAAR!", yell = false },
	{ text = "WILL ... PUNISH ... YOU!", yell = false },
	{ text = "Darkness ... devours!", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 100000, maxCount = 99 }, -- Crystal Coin
	{ id = 23374, chance = 67000, maxCount = 203 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 50000, maxCount = 103 }, -- Ultimate Mana Potion
	{ id = 3039, chance = 46000, maxCount = 4 }, -- Red Gem
	{ id = 23375, chance = 46000, maxCount = 154 }, -- Supreme Health Potion
	{ id = 3041, chance = 42000, maxCount = 5 }, -- Blue Gem
	{ id = 32623, chance = 38000 }, -- Giant Topaz
	{ id = 32622, chance = 33000 }, -- Giant Amethyst
	{ id = 7439, chance = 33000, maxCount = 45 }, -- Berserk Potion
	{ id = 49271, chance = 29000, maxCount = 29 }, -- Transcendence Potion
	{ id = 3037, chance = 29000, maxCount = 4 }, -- Yellow Gem
	{ id = 30060, chance = 29000 }, -- Giant Emerald
	{ id = 3038, chance = 25000, maxCount = 4 }, -- Green Gem
	{ id = 9058, chance = 21000 }, -- Gold Ingot
	{ id = 7443, chance = 21000, maxCount = 43 }, -- Bullseye Potion
	{ id = 43967, chance = 21000 }, -- Vemiath's Infused Basalt
	{ id = 7440, chance = 16700, maxCount = 31 }, -- Mastermind Potion
	{ id = 3036, chance = 12500, maxCount = 3 }, -- Violet Gem
	{ id = 32769, chance = 8300, maxCount = 3 }, -- White Gem
	{ id = 30053, chance = 8300 }, -- Dragon Figurine
	{ id = 43961, chance = 4200 }, -- Darklight Figurine
	{ id = 43503, chance = 4200 }, -- The Essence of Vemiath
	{ id = 30054, chance = 4200 }, -- Unicorn Figurine
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1500, maxDamage = -2500 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1000, length = 10, spread = 3, effect = 244, target = false },
	{ name = "speed", interval = 2000, chance = 25, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -300, maxDamage = -700, radius = 5, effect = 243, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_FIREATTACK, target = false },
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
