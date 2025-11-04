local mType = Game.createMonsterType("Grand Canon Dominus")
local monster = {}

monster.description = "Grand Canon Dominus"
monster.experience = 11000
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 96,
	lookFeet = 105,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1584,
	bossRace = RARITY_BANE,
}

monster.health = 15000
monster.maxHealth = 15000
monster.race = "blood"
monster.corpse = 28737
monster.speed = 105
monster.manaCost = 0

monster.events = {
	"killingLibrary",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
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
	staticAttackChance = 70,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 86330, maxCount = 5 }, -- Platinum Coin
	{ id = 238, chance = 31775, maxCount = 3 }, -- Great Mana Potion
	{ id = 239, chance = 30256, maxCount = 3 }, -- Great Health Potion
	{ id = 9057, chance = 20329, maxCount = 2 }, -- Small Topaz
	{ id = 3028, chance = 19041, maxCount = 2 }, -- Small Diamond
	{ id = 678, chance = 64683, maxCount = 2 }, -- Small Enchanted Amethyst
	{ id = 7368, chance = 25583, maxCount = 10 }, -- Assassin Star
	{ id = 7365, chance = 16121, maxCount = 35 }, -- Onyx Arrow
	{ id = 3033, chance = 17990, maxCount = 2 }, -- Small Amethyst
	{ id = 3032, chance = 17869, maxCount = 2 }, -- Small Emerald
	{ id = 3030, chance = 22313, maxCount = 2 }, -- Small Ruby
	{ id = 28823, chance = 1518 }, -- Falcon Crest
	{ id = 3039, chance = 2338 }, -- Red Gem
	{ id = 28822, chance = 935 }, -- Damaged Armor Plates
	{ id = 3038, chance = 699 }, -- Green Gem
	{ id = 3036, chance = 1750 }, -- Violet Gem
	{ id = 3414, chance = 346 }, -- Mastermind Shield
	{ id = 28821, chance = 464 }, -- Patch of Fine Cloth
	{ id = 281, chance = 1636 }, -- Giant Shimmering Pearl
	{ id = 3360, chance = 210 }, -- Golden Armor
	{ id = 28718, chance = 1000 }, -- Falcon Bow
	{ id = 28717, chance = 1000 }, -- Falcon Wand
	{ id = 28719, chance = 1000 }, -- Falcon Plate
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -700 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -720, range = 7, shootEffect = CONST_ANI_ETHEREALSPEAR, target = false },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -100, maxDamage = -1000, length = 8, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -700, range = 5, radius = 3, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -700, range = 5, radius = 3, effect = CONST_ME_SMALLCLOUDS, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 82,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 10, speedChange = 220, effect = CONST_ME_POFF, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 60 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
