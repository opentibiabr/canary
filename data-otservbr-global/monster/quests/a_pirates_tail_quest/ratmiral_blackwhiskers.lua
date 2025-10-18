local mType = Game.createMonsterType("Ratmiral Blackwhiskers")
local monster = {}

monster.description = "Ratmiral Blackwhiskers"
monster.experience = 50000
monster.outfit = {
	lookType = 1377,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 220000
monster.maxHealth = 220000
monster.race = "blood"
monster.corpse = 35846
monster.speed = 115
monster.manaCost = 0

monster.events = {
	"RatmiralBlackwhiskersDeath",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 2006,
	bossRace = RARITY_ARCHFOE,
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

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "elite pirat", chance = 30, interval = 1000 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3043, chance = 100000, maxCount = 3 }, -- Crystal Coin
	{ id = 3035, chance = 50836, maxCount = 36 }, -- Platinum Coin
	{ id = 7440, chance = 17056, maxCount = 10 }, -- Mastermind Potion
	{ id = 7443, chance = 18060, maxCount = 10 }, -- Bullseye Potion
	{ id = 238, chance = 30100, maxCount = 10 }, -- Great Mana Potion
	{ id = 239, chance = 31772, maxCount = 14 }, -- Great Health Potion
	{ id = 23373, chance = 28428, maxCount = 18 }, -- Ultimate Mana Potion
	{ id = 7642, chance = 38127, maxCount = 15 }, -- Great Spirit Potion
	{ id = 7643, chance = 37792, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 7439, chance = 17056, maxCount = 5 }, -- Berserk Potion
	{ id = 35572, chance = 18060, maxCount = 100 }, -- Pirate Coin
	{ id = 35580, chance = 3012, maxCount = 5 }, -- Golden Skull
	{ id = 35613, chance = 7357 }, -- Ratmiral's Hat
	{ id = 35614, chance = 3010 }, -- Cheesy Membership Card
	{ id = 35581, chance = 3010 }, -- Golden Cheese Wedge
	{ id = 32626, chance = 2252 }, -- Amber (Item)
	{ id = 35579, chance = 5351 }, -- Golden Dustbin
	{ id = 35578, chance = 4013 }, -- Tiara
	{ id = 35571, chance = 6020 }, -- Small Treasure Chest
	{ id = 35595, chance = 2006 }, -- Soap
	{ id = 35695, chance = 2006 }, -- Scrubbing Brush
	{ id = 35520, chance = 1000 }, -- Make-Do Boots
	{ id = 35519, chance = 1000 }, -- Makeshift Boots
	{ id = 35516, chance = 1000 }, -- Exotic Legs
	{ id = 35517, chance = 1000 }, -- Bast Legs
	{ id = 35523, chance = 1123 }, -- Exotic Amulet
	{ id = 35515, chance = 1123 }, -- Throwing Axe
	{ id = 35518, chance = 1000 }, -- Jungle Bow
	{ id = 35514, chance = 1000 }, -- Jungle Flail
	{ id = 35524, chance = 1000 }, -- Jungle Quiver
	{ id = 35521, chance = 1000 }, -- Jungle Rod
	{ id = 35522, chance = 751 }, -- Jungle Wand
	{ id = 50186, chance = 1000 }, -- Jungle Survivor Legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -270, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -600, range = 7, shootEffect = CONST_ANI_WHIRLWINDCLUB, target = true },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -600, radius = 4, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_LIFEDRAIN, minDamage = -600, maxDamage = -1000, length = 4, spread = 0, effect = CONST_ME_SOUND_PURPLE, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
