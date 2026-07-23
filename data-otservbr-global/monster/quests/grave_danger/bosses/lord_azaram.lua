local mType = Game.createMonsterType("Lord Azaram")
local monster = {}

monster.description = "Lord Azaram"
monster.experience = 55000
monster.outfit = {
	lookType = 1223,
	lookHead = 19,
	lookBody = 2,
	lookLegs = 94,
	lookFeet = 81,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"azaram_health",
	"azaram_summon",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "venom"
monster.corpse = 31599
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1756,
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

monster.summon = {
	maxSummons = 5,
	summons = {
		{ name = "Condensed Sins", chance = 50, interval = 2000, count = 5 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 22516, chance = 100000, maxCount = 3 }, -- Silver Token
	{ id = 23373, chance = 63000, maxCount = 32 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 61000, maxCount = 32 }, -- Supreme Health Potion
	{ id = 23374, chance = 48000, maxCount = 34 }, -- Ultimate Spirit Potion
	{ id = 3039, chance = 38000, maxCount = 2 }, -- Red Gem
	{ id = 3037, chance = 33000, maxCount = 2 }, -- Yellow Gem
	{ id = 5888, chance = 30000, maxCount = 7 }, -- Piece of Hell Steel
	{ id = 3043, chance = 22000, maxCount = 3 }, -- Crystal Coin
	{ id = 3370, chance = 21000 }, -- Knight Armor
	{ id = 7440, chance = 21000, maxCount = 19 }, -- Mastermind Potion
	{ id = 7407, chance = 19200 }, -- Haunted Blade
	{ id = 3038, chance = 18200 }, -- Green Gem
	{ id = 7443, chance = 18200, maxCount = 18 }, -- Bullseye Potion
	{ id = 3041, chance = 18200, maxCount = 2 }, -- Blue Gem
	{ id = 9058, chance = 16200 }, -- Gold Ingot
	{ id = 7439, chance = 16200, maxCount = 19 }, -- Berserk Potion
	{ id = 23544, chance = 13100 }, -- Collar of Red Plasma
	{ id = 31590, chance = 11100 }, -- Young Lich Worm
	{ id = 23533, chance = 10100 }, -- Ring of Red Plasma
	{ id = 23543, chance = 9100 }, -- Collar of Green Plasma
	{ id = 5892, chance = 8100 }, -- Huge Chunk of Crude Iron
	{ id = 23531, chance = 8100 }, -- Ring of Green Plasma
	{ id = 31588, chance = 8100 }, -- Ancient Liche Bone
	{ id = 23526, chance = 7100 }, -- Collar of Blue Plasma
	{ id = 3036, chance = 7100 }, -- Violet Gem
	{ id = 49271, chance = 6100, maxCount = 13 }, -- Transcendence Potion
	{ id = 31589, chance = 5100 }, -- Rotten Heart
	{ id = 30061, chance = 5100 }, -- Giant Sapphire
	{ id = 31578, chance = 4000 }, -- Bear Skin
	{ id = 23529, chance = 4000 }, -- Ring of Blue Plasma
	{ id = 828, chance = 3000 }, -- Lightning Headband
	{ id = 31593, chance = 2000 }, -- Noble Cape
	{ id = 30059, chance = 2000 }, -- Giant Ruby
	{ id = 31579, chance = 2000 }, -- Embrace of Nature
	{ id = 31577, chance = 2000 }, -- Terra Helmet
	{ id = 30060, chance = 1000 }, -- Giant Emerald
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000, effect = CONST_ME_DRAWBLOOD },
	{ name = "lord azaram wave", interval = 3500, chance = 50, minDamage = -360, maxDamage = -900 },
	{ name = "combat", interval = 2700, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -1200, length = 7, spread = 0, effect = CONST_ME_STONES, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
