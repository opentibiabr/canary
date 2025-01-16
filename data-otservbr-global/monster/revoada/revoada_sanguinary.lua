local mType = Game.createMonsterType("Revoada Sanguinary")
local monster = {}

monster.description = "a Revoada Sanguinary"
monster.experience = 10000000
monster.outfit = {
	lookType = 1703,
}

monster.events = {
	"RevoadaSanguinaryDeath",
}

monster.health = 6000000
monster.maxHealth = 6000000
monster.race = "blood"
monster.corpse = 4240
monster.speed = 550
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
	chance = 30,
}

monster.bosstiary = {
	bossRaceId = 2467,
	bossRace = RARITY_BANE,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 50,
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
		{ name = "revoada minion warrior", chance = 20, interval = 4000, count = 4 },
		{ name = "revoada minion mage", chance = 14, interval = 3000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "YOU WON'T KNOW WHO HIT YOU, YOU'LL JUST FEEL IT!", yell = true },
	{ text = "FROM DEEP AWAKENING I CAME, INSATIABLE HUNGER FOR BLOOD. HIS SCREAMS WILL BE THE SYMPHONY OF MY DIVINE RESURRECTION!", yell = true },
	{ text = "MY DOMAIN IS THE REALM OF PAIN. YOUR BLOOD IS MY SOURCE OF POWER, AND KILLING IS MY REASON FOR EXISTING!", yell = true },
	{ text = "IN THE DARKNESS, I FOUND POWER. UNDER THE MOONLIGHT, I WILL HUNT EACH ONE OF YOU, DEVOURING YOUR SOULS!!", yell = true },
}

monster.loot = {
	{ id = 5903, chance = 15 }, -- ferumbras' hat
	{ id = 3439, chance = 100 }, -- phoenix shield
	{ id = 43895, chance = 110 }, -- bag you covet
	{ id = 34109, chance = 150 }, -- bag you desire
	{ id = 39546, chance = 1500 }, -- primal bag
	{ id = ITEM_SUPER_ROULETTE, chance = 100000, unique = true }, -- super roulette coin
	{ id = ITEM_REVOADA_COIN, chance = 60000, minCount = 100, maxCount = 500 }, -- revoada coin
	{ id = 3043, chance = 60000, minCount = 12, maxCount = 70 }, -- crystal coin
	{ id = 3035, chance = 100000, minCount = 30 }, -- Platinum Coin
	{ id = 23373, chance = 40000, maxCount = 120 }, -- Ultimate Mana Potion
	{ id = 7643, chance = 30000, maxCount = 120 }, -- Ultimate Health Potion
	{ id = 23374, chance = 30000, maxCount = 120 }, -- Ultimate Spirit Potion
	{ id = 32625, chance = 10000 }, -- Amber with a Dragonfly (200k)
	{ id = 30054, chance = 20000 }, -- Unicorn Figurine
	{ id = 31323, chance = 20000 }, -- Sea Horse Figurine
	{ id = 30060, chance = 10000 }, -- Giant Emerald
	{ id = 37608, chance = 666 }, -- Green Demon Armor
	{ id = 37609, chance = 666 }, -- Green Demon Helmet
	{ id = 37607, chance = 666 }, -- Green Demon Legs
	{ id = 37610, chance = 666 }, -- Green Demon Slippers
	{ id = 30053, chance = 666 }, -- Dragon Figurine
	{ id = 3309, chance = 16666 }, -- Thunder Hammer
	{ id = 3360, chance = 44000 }, -- golden armor
	{ id = 7423, chance = 58000 }, -- skullcrusher
	{ id = 3039, chance = 80000, minCount = 5, maxCount = 50 }, -- red gem
	{ id = 5944, chance = 8000, maxCount = 9, maxCount = 50 }, -- soul orb
	{ id = 5944, chance = 8000, maxCount = 9 }, -- soul orb
	{ id = 812, chance = 28000 }, -- terra legs
	{ name = "terra mantle", chance = 28000 },
	{ name = "small ruby", chance = 77430, maxCount = 90 },
	{ name = "small topaz", chance = 77470, maxCount = 90 },
	{ name = "demonic essence", chance = 14630, maxCount = 70 },
	{ name = "giant sword", chance = 34000 },
	{ name = "ice rapier", chance = 61550 },
	{ name = "golden sickle", chance = 91440 },
	{ name = "fire axe", chance = 35000 },
	{ name = "golden legs", chance = 15440 },
	{ id = 3366, chance = 15400 }, -- magic plate armor
	{ id = 22866, chance = 12500 }, -- rift bow
	{ id = 22867, chance = 14500 }, -- rift crossbow
	{ id = 3422, chance = 15 }, -- great shield
	{ name = "mastermind shield", chance = 64000 },
	{ name = "demonrage sword", chance = 57000 },
	{ name = "ring of the sky", chance = 14030 },
	{ name = "gold coin", chance = 9340, maxCount = 380 },
	{ name = "blue robe", chance = 51410 },
	{ name = "cherry", chance = 19000, maxCount = 70 },
	{ name = "luminous orb", chance = 60510 },
	{ name = "swamplair armor", chance = 33490 },
	{ name = "spellbook of mind control", chance = 51245 },
	{ name = "royal helmet", chance = 64340 },
	{ name = "dark lord's cape", chance = 42000 },
	{ name = "ironworker", chance = 25000 },
	{ name = "fireborn giant armor", chance = 38000 },
	{ name = "teddy bear", chance = 8000 },
	{ name = "demonbone", chance = 43000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 200, attack = 250 },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -1500, maxDamage = -4000, length = 8, spread = 0, effect = CONST_ME_GROUNDSHAKER },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -1500, maxDamage = -4000, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "combat", interval = 1000, chance = 7, type = COMBAT_MANADRAIN, minDamage = -800, maxDamage = -1900, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_LIFEDRAIN, minDamage = -1000, maxDamage = -2100, radius = 8, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -700, maxDamage = -1500, radius = 8, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -800, maxDamage = -3300, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -900, maxDamage = -1500, length = 8, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "drunk", interval = 1000, chance = 7, range = 7, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = false, duration = 10000 },
	{ name = "strength", interval = 1000, chance = 9, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "strength", interval = 1000, chance = 8, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "speed", interval = 1000, chance = 12, speedChange = -1100, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 60000 },
}

monster.defenses = {
	defense = 190,
	armor = 170,
	{ name = "combat", interval = 10000, chance = 15, type = COMBAT_HEALING, minDamage = 8000, maxDamage = 50000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_HEALING, minDamage = 4000, maxDamage = 9000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 8, speedChange = 1100, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "invisible", interval = 1000, chance = 4, effect = CONST_ME_MAGIC_BLUE },
	{ name = "invisible", interval = 1000, chance = 17, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 3 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 3 },
	{ type = COMBAT_EARTHDAMAGE, percent = 3 },
	{ type = COMBAT_FIREDAMAGE, percent = 3 },
	{ type = COMBAT_LIFEDRAIN, percent = 1 },
	{ type = COMBAT_MANADRAIN, percent = 1 },
	{ type = COMBAT_DROWNDAMAGE, percent = 1 },
	{ type = COMBAT_ICEDAMAGE, percent = 3 },
	{ type = COMBAT_HOLYDAMAGE, percent = 3 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType:register(monster)
