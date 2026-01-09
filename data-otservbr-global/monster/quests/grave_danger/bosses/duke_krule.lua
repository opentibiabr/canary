local mType = Game.createMonsterType("Duke Krule")
local monster = {}

monster.description = "Duke Krule"
monster.experience = 55000
monster.outfit = {
	lookType = 1221,
	lookHead = 8,
	lookBody = 8,
	lookLegs = 19,
	lookFeet = 79,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"grave_danger_death",
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "venom"
monster.corpse = 31599
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1758,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Soul Scourge", chance = 20, interval = 2000, count = 4 },
	},
}

monster.loot = {
	{ id = 3035, chance = 97395, maxCount = 5 }, -- Platinum Coin
	{ id = 3043, chance = 18229, maxCount = 2 }, -- Crystal Coin
	{ id = 23373, chance = 55989, maxCount = 20 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 53906, maxCount = 20 }, -- Supreme Health Potion
	{ id = 23374, chance = 55989, maxCount = 14 }, -- Ultimate Spirit Potion
	{ id = 5888, chance = 25520, maxCount = 4 }, -- Piece of Hell Steel
	{ id = 7439, chance = 16406, maxCount = 10 }, -- Berserk Potion
	{ id = 7440, chance = 20572, maxCount = 10 }, -- Mastermind Potion
	{ id = 7443, chance = 20312, maxCount = 10 }, -- Bullseye Potion
	{ id = 9058, chance = 11979 }, -- Gold Ingot
	{ id = 830, chance = 8333 }, -- Terra Hood
	{ id = 3037, chance = 34635 }, -- Yellow Gem
	{ id = 3041, chance = 19791 }, -- Blue Gem
	{ id = 3038, chance = 17968 }, -- Green Gem
	{ id = 3039, chance = 36718 }, -- Red Gem
	{ id = 3036, chance = 11458 }, -- Violet Gem
	{ id = 23544, chance = 9114 }, -- Collar of Red Plasma
	{ id = 23526, chance = 9114 }, -- Collar of Blue Plasma
	{ id = 23543, chance = 10416 }, -- Collar of Green Plasma
	{ id = 23533, chance = 5729 }, -- Ring of Red Plasma
	{ id = 23529, chance = 7291 }, -- Ring of Blue Plasma
	{ id = 23531, chance = 8072 }, -- Ring of Green Plasma
	{ id = 3391, chance = 18750 }, -- Crusader Helmet
	{ id = 5885, chance = 16927 }, -- Flask of Warrior's Sweat
	{ id = 7427, chance = 19270 }, -- Chaos Mace
	{ id = 31590, chance = 9114 }, -- Young Lich Worm
	{ id = 31588, chance = 5468 }, -- Ancient Liche Bone
	{ id = 22516, chance = 100000, maxCount = 3 }, -- Silver Token
	{ id = 30060, chance = 2083 }, -- Giant Emerald
	{ id = 30061, chance = 4427 }, -- Giant Sapphire
	{ id = 30059, chance = 1250 }, -- Giant Ruby
	{ id = 31579, chance = 2645 }, -- Embrace of Nature
	{ id = 31589, chance = 4687 }, -- Rotten Heart
	{ id = 31595, chance = 625 }, -- Noble Amulet
	{ id = 31578, chance = 1562 }, -- Bear Skin
	{ id = 31577, chance = 1562 }, -- Terra Helmet
	{ id = 31738, chance = 1000 }, -- Final Judgement
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 3500, chance = 37, type = COMBAT_PHYSICALDAMAGE, minDamage = -700, maxDamage = -1200, length = 7, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 4200, chance = 40, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -500, radius = 9, effect = CONST_ME_HITBYFIRE, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HEALING, minDamage = 150, maxDamage = 350, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
