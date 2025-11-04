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
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 22516, chance = 100000, maxCount = 2 }, -- Silver Token
	{ id = 23374, chance = 57291, maxCount = 20 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 58333, maxCount = 14 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 55208, maxCount = 14 }, -- Supreme Health Potion
	{ id = 7443, chance = 21354, maxCount = 10 }, -- Bullseye Potion
	{ id = 3041, chance = 21875 }, -- Blue Gem
	{ id = 3039, chance = 33333 }, -- Red Gem
	{ id = 3370, chance = 20833 }, -- Knight Armor
	{ id = 7440, chance = 21875, maxCount = 10 }, -- Mastermind Potion
	{ id = 5888, chance = 31770, maxCount = 4 }, -- Piece of Hell Steel
	{ id = 3037, chance = 31250 }, -- Yellow Gem
	{ id = 7439, chance = 17708, maxCount = 10 }, -- Berserk Potion
	{ id = 23543, chance = 11458 }, -- Collar of Green Plasma
	{ id = 3038, chance = 22916, maxCount = 2 }, -- Green Gem
	{ id = 828, chance = 11979 }, -- Lightning Headband
	{ id = 23531, chance = 5208 }, -- Ring of Green Plasma
	{ id = 31578, chance = 3645 }, -- Bear Skin
	{ id = 23526, chance = 8333 }, -- Collar of Blue Plasma
	{ id = 3043, chance = 24479 }, -- Crystal Coin
	{ id = 30059, chance = 1818 }, -- Giant Ruby
	{ id = 9058, chance = 18229 }, -- Gold Ingot
	{ id = 3036, chance = 6770 }, -- Violet Gem
	{ id = 31590, chance = 10416 }, -- Young Lich Worm
	{ id = 31579, chance = 3076 }, -- Embrace of Nature
	{ id = 31578, chance = 3645 }, -- Bear Skin
	{ id = 31577, chance = 3076 }, -- Terra Helmet
	{ id = 31588, chance = 5729 }, -- Ancient Liche Bone
	{ id = 31589, chance = 5208 }, -- Rotten Heart
	{ id = 31738, chance = 1000 }, -- Final Judgement
	{ id = 31593, chance = 1388 }, -- Noble Cape
	{ id = 23544, chance = 11458 }, -- Collar of Red Plasma
	{ id = 23529, chance = 7291 }, -- Ring of Blue Plasma
	{ id = 23533, chance = 8854 }, -- Ring of Red Plasma
	{ id = 5892, chance = 6770 }, -- Huge Chunk of Crude Iron
	{ id = 7407, chance = 13541 }, -- Haunted Blade
	{ id = 30060, chance = 1818 }, -- Giant Emerald
	{ id = 30061, chance = 3645 }, -- Giant Sapphire
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
