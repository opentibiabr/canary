local mType = Game.createMonsterType("The Blazing Time Guardian")
local monster = {}

monster.description = "The Blazing Time Guardian"
monster.experience = 50000
monster.outfit = {
	lookType = 944,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "undead"
monster.corpse = 25085
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 5,
	color = 184,
}

monster.summon = {
	maxSummons = 8,
	summons = {
		{ name = "time waster", chance = 3, interval = 2000, count = 8 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3098, chance = 100000 }, -- Ring of Healing
	{ id = 3035, chance = 100000 }, -- Platinum Coin
	{ id = 3039, chance = 14285 }, -- Red Gem
	{ id = 7440, chance = 100000 }, -- Mastermind Potion
	{ id = 238, chance = 63265 }, -- Great Mana Potion
	{ id = 16121, chance = 57142 }, -- Green Crystal Shard
	{ id = 3031, chance = 100000 }, -- Gold Coin
	{ id = 11454, chance = 44897 }, -- Luminous Orb
	{ id = 7642, chance = 40816 }, -- Great Spirit Potion
	{ id = 3324, chance = 100000 }, -- Skull Staff
	{ id = 9057, chance = 24489 }, -- Small Topaz
	{ id = 22721, chance = 18367 }, -- Gold Token
	{ id = 16120, chance = 65306 }, -- Violet Crystal Shard
	{ id = 8076, chance = 4081 }, -- Spellscroll of Prophecies
	{ id = 5904, chance = 6122 }, -- Magic Sulphur
	{ id = 3030, chance = 10204 }, -- Small Ruby
	{ id = 281, chance = 12244 }, -- Giant Shimmering Pearl
	{ id = 22516, chance = 26530 }, -- Silver Token
	{ id = 16119, chance = 63265 }, -- Blue Crystal Shard
	{ id = 7643, chance = 53061 }, -- Ultimate Health Potion
	{ id = 3028, chance = 16326 }, -- Small Diamond
	{ id = 5892, chance = 18367 }, -- Huge Chunk of Crude Iron
	{ id = 7387, chance = 16326 }, -- Diamond Sceptre
	{ id = 20062, chance = 20408 }, -- Cluster of Solace
	{ id = 3037, chance = 20408 }, -- Yellow Gem
	{ id = 3081, chance = 40816 }, -- Stone Skin Amulet
	{ id = 3033, chance = 18367 }, -- Small Amethyst
	{ id = 24956, chance = 4081 }, -- Part of a Rune (Three)
	{ id = 3038, chance = 20408 }, -- Green Gem
	{ id = 3032, chance = 18367 }, -- Small Emerald
	{ id = 824, chance = 6122 }, -- Glacier Robe
	{ id = 10323, chance = 8333 }, -- Guardian Boots
	{ id = 7422, chance = 2777 }, -- Jade Hammer
	{ id = 24969, chance = 8333 }, -- Ancient Watch
	{ id = 3041, chance = 19444 }, -- Blue Gem
	{ id = 5809, chance = 5555 }, -- Soul Stone
	{ id = 823, chance = 2777 }, -- Glacier Kilt
	{ id = 7417, chance = 5555 }, -- Runed Sword
	{ id = 821, chance = 11111 }, -- Magma Legs
	{ id = 0, chance = 2777 }, -- Part of a Rune
	{ id = 12306, chance = 5555 }, -- Leather Whip
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 190, attack = 300 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -780, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -780, length = 9, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -780, length = 9, spread = 0, effect = CONST_ME_ENERGYAREA, target = false },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 20, minDamage = -2000, maxDamage = -2000, radius = 7, effect = CONST_ME_BLOCKHIT, target = false },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 20, minDamage = -2000, maxDamage = -2000, length = 9, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.defenses = {
	defense = 70,
	armor = 70,
	--	mitigation = ???,
	{ name = "time guardian lost time", interval = 2000, chance = 10, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.heals = {
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
