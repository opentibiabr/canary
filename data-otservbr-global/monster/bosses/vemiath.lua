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
	{ id = 3043, chance = 80000, maxCount = 125 }, -- crystal coin
	{ id = 23373, chance = 80000, maxCount = 211 }, -- ultimate mana potion
	{ id = 23374, chance = 80000, maxCount = 35 }, -- ultimate spirit potion
	{ id = 23375, chance = 80000, maxCount = 179 }, -- supreme health potion
	{ id = 7443, chance = 80000, maxCount = 42 }, -- bullseye potion
	{ id = 7439, chance = 80000, maxCount = 45 }, -- berserk potion
	{ id = 7440, chance = 80000, maxCount = 44 }, -- mastermind potion
	{ id = 3041, chance = 80000, maxCount = 5 }, -- blue gem
	{ id = 3038, chance = 80000, maxCount = 5 }, -- green gem
	{ id = 36706, chance = 80000, maxCount = 5 }, -- red gem
	{ id = 3037, chance = 80000, maxCount = 5 }, -- yellow gem
	{ id = 3036, chance = 80000, maxCount = 5 }, -- violet gem
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 32623, chance = 80000 }, -- giant topaz
	{ id = 32622, chance = 80000 }, -- giant amethyst
	{ id = 33778, chance = 80000 }, -- raw watermelon tourmaline
	{ id = 30053, chance = 80000 }, -- dragon figurine
	{ id = 43895, chance = 80000 }, -- bag you covet
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
