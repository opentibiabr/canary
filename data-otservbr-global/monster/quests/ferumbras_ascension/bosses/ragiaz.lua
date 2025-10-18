local mType = Game.createMonsterType("Ragiaz")
local monster = {}

monster.description = "Ragiaz"
monster.experience = 500000
monster.outfit = {
	lookType = 862,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 19,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.bosstiary = {
	bossRaceId = 1180,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 280000
monster.maxHealth = 280000
monster.race = "undead"
monster.corpse = 22495
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3037, chance = 24528 }, -- Yellow Gem
	{ id = 3030, chance = 19642, maxCount = 5 }, -- Small Ruby
	{ id = 7426, chance = 12500 }, -- Amber Staff
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 16127, chance = 82142, maxCount = 4 }, -- Green Crystal Fragment
	{ id = 16125, chance = 75000, maxCount = 4 }, -- Cyan Crystal Fragment
	{ id = 7642, chance = 66071, maxCount = 10 }, -- Great Spirit Potion
	{ id = 3035, chance = 100000, maxCount = 25 }, -- Platinum Coin
	{ id = 22762, chance = 1000 }, -- Maimer
	{ id = 22758, chance = 1000 }, -- Death Gaze
	{ id = 22516, chance = 100000 }, -- Silver Token
	{ id = 22866, chance = 7692 }, -- Rift Bow
	{ id = 3033, chance = 12499 }, -- Small Amethyst
	{ id = 16126, chance = 69642 }, -- Red Crystal Fragment
	{ id = 6299, chance = 5128 }, -- Death Ring
	{ id = 6558, chance = 55357 }, -- Flask of Demonic Blood
	{ id = 7643, chance = 41071 }, -- Ultimate Health Potion
	{ id = 6499, chance = 69642 }, -- Demonic Essence
	{ id = 3038, chance = 17857 }, -- Green Gem
	{ id = 7420, chance = 1000 }, -- Reaper's Axe
	{ id = 3098, chance = 39285 }, -- Ring of Healing
	{ id = 238, chance = 60714 }, -- Great Mana Potion
	{ id = 281, chance = 14285 }, -- Giant Shimmering Pearl
	{ id = 22727, chance = 7142 }, -- Rift Lance
	{ id = 3324, chance = 12500 }, -- Skull Staff
	{ id = 3029, chance = 30188 }, -- Small Sapphire
	{ id = 22726, chance = 13207 }, -- Rift Shield
	{ id = 9057, chance = 13207 }, -- Small Topaz
	{ id = 3032, chance = 26415 }, -- Small Emerald
	{ id = 3039, chance = 22641 }, -- Red Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1400, maxDamage = -2300 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, range = 4, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_POFF, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -1000, maxDamage = -1200, length = 10, spread = 3, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -1500, maxDamage = -1900, length = 10, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, radius = 7, effect = CONST_ME_POFF, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 125,
	armor = 125,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = 600, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 4000 },
	{ name = "ragiaz transform", interval = 2000, chance = 8, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 90 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
