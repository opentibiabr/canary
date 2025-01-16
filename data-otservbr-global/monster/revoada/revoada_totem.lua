local mType = Game.createMonsterType("Taberna Totem")
local monster = {}

monster.description = "a Taberna Totem"
monster.experience = 500000
monster.outfit = {
	lookType = 1716,
}

monster.events = {
	"RevoadaTotemDeath",
}

monster.health = 500000
monster.maxHealth = 500000
monster.race = "blood"
monster.corpse = 21940
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
	chance = 30,
}

monster.bosstiary = {
	bossRaceId = 2468,
	bossRace = RARITY_BANE,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 20,
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
	targetDistance = 5,
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
	maxSummons = 3,
	summons = {
		{ name = "totem minion", chance = 30, interval = 6000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I WILL BRING YOU WITH ME!!", yell = true },
	{ text = "YOU WILL NOT KNOW WHO HIT YOU, YOU WILL JUST FEEL IT!", yell = true },
	{ text = "MY DOMAIN IS THE KINGDOM OF PAIN. YOUR BLOOD IS MY SOURCE OF POWER, AND KILLING IS MY REASON FOR EXISTING!", yell = true },
	{ text = "IN THE DARKNESS, I FOUND POWER. UNDER THE MOONLIGHT, I WILL HUNT EACH ONE OF YOU, DEVOURING YOUR SOULS!!", yell = true },
}

monster.loot = {
	{ id = 5903, chance = 1 }, -- ferumbras' hat
	{ id = 3439, chance = 15 }, -- phoenix shield
	{ id = 43895, chance = 5 }, -- bag you covet
	{ id = 34109, chance = 6 }, -- bag you desire
	{ id = 39546, chance = 10 }, -- primal bag
	{ id = ITEM_REVOADA_COIN, chance = 60000, minCount = 50, maxCount = 200 }, -- revoada coin
	{ id = 3043, chance = 60000, minCount = 7, maxCount = 50 }, -- crystal coin
	{ id = 3035, chance = 100000, minCount = 40 }, -- Platinum Coin
	{ id = 23373, chance = 30000, maxCount = 100 }, -- Ultimate Mana Potion
	{ id = 7643, chance = 30000, maxCount = 100 }, -- Ultimate Health Potion
	{ id = 23374, chance = 30000, maxCount = 100 }, -- Ultimate Spirit Potion
	{ id = 32625, chance = 10000 }, -- Amber with a Dragonfly (200k)
	{ id = 3309, chance = 666 }, -- Thunder Hammer
	{ id = 3039, chance = 80000, minCount = 5, maxCount = 50 }, -- red gem
	{ id = 5944, chance = 8000, maxCount = 9, maxCount = 50 }, -- soul orb
	{ name = "small ruby", chance = 77430, maxCount = 65 },
	{ name = "small topaz", chance = 77470, maxCount = 65 },
	{ name = "demonic essence", chance = 14630, maxCount = 70 },
	{ name = "ice rapier", chance = 51550 },
	{ name = "mastermind shield", chance = 64000 },
	{ name = "demonrage sword", chance = 47000 },
	{ name = "ring of the sky", chance = 44030 },
	{ name = "cherry", chance = 67000, maxCount = 300 },
	{ name = "teddy bear", chance = 8000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 500, skill = 85, attack = 440 },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 200, minDamage = -350, maxDamage = -820, radius = 6, effect = CONST_ME_POISONAREA, target = false },
	{ name = "ferumbras electrify", interval = 2000, chance = 1800, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_MANADRAIN, minDamage = -300, maxDamage = -1200, radius = 9, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 2000, chance = 60, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -1000, radius = 6, effect = CONST_ME_POFF, target = false },
	{ name = "ferumbras soulfire", interval = 2000, chance = 20, range = 7, target = false },
	{ name = "combat", interval = 2000, chance = 800, type = COMBAT_LIFEDRAIN, minDamage = -420, maxDamage = -900, length = 8, spread = 0, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 5000, chance = 1200, type = CONST_ME_HITAREA, minDamage = -650, maxDamage = -1200, range = 5, radius = 7, effect = CONST_ME_HITAREA, target = false },
}

monster.defenses = {
	defense = 115,
	armor = 90,
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 200, maxDamage = 1400, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 3 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 3 },
	{ type = COMBAT_EARTHDAMAGE, percent = 3 },
	{ type = COMBAT_FIREDAMAGE, percent = 3 },
	{ type = COMBAT_LIFEDRAIN, percent = 1 },
	{ type = COMBAT_MANADRAIN, percent = 1 },
	{ type = COMBAT_DROWNDAMAGE, percent = 3 },
	{ type = COMBAT_ICEDAMAGE, percent = 3 },
	{ type = COMBAT_HOLYDAMAGE, percent = 3 },
	{ type = COMBAT_DEATHDAMAGE, percent = 3 },
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
