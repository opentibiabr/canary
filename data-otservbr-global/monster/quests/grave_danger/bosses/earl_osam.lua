local mType = Game.createMonsterType("Earl Osam")
local monster = {}

monster.description = "Earl Osam"
monster.experience = 55000
monster.outfit = {
	lookType = 1223,
	lookHead = 113,
	lookBody = 0,
	lookLegs = 79,
	lookFeet = 95,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"earl_osam_transform",
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
	bossRaceId = 1757,
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
	maxSummons = 4,
	summons = {
		{ name = "Frozen Soul", chance = 50, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I ... will ... get ... you ... all!", yell = false },
	{ text = "I ... will ... rise ... again!", yell = false },
}

monster.loot = {
	{ id = 22516, chance = 100000, maxCount = 2 }, -- Silver Token
	{ id = 3035, chance = 99730, maxCount = 5 }, -- Platinum Coin
	{ id = 23374, chance = 59299, maxCount = 20 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 58221, maxCount = 20 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 51482, maxCount = 20 }, -- Supreme Health Potion
	{ id = 3043, chance = 19407, maxCount = 3 }, -- Crystal Coin
	{ id = 3041, chance = 22911 }, -- Blue Gem
	{ id = 5889, chance = 18598, maxCount = 3 }, -- Piece of Draconian Steel
	{ id = 3037, chance = 36388, maxCount = 2 }, -- Yellow Gem
	{ id = 7443, chance = 18059, maxCount = 10 }, -- Bullseye Potion
	{ id = 23543, chance = 11859 }, -- Collar of Green Plasma
	{ id = 3038, chance = 16981, maxCount = 2 }, -- Green Gem
	{ id = 14043, chance = 19676 }, -- Guardian Axe
	{ id = 7439, chance = 23180, maxCount = 10 }, -- Berserk Potion
	{ id = 829, chance = 12129 }, -- Glacier Mask
	{ id = 3369, chance = 15633 }, -- Warrior Helmet
	{ id = 23526, chance = 10512 }, -- Collar of Blue Plasma
	{ id = 7440, chance = 22641, maxCount = 10 }, -- Mastermind Potion
	{ id = 3039, chance = 35579 }, -- Red Gem
	{ id = 23544, chance = 8355 }, -- Collar of Red Plasma
	{ id = 9058, chance = 11320 }, -- Gold Ingot
	{ id = 5888, chance = 17520, maxCount = 4 }, -- Piece of Hell Steel
	{ id = 23531, chance = 5929 }, -- Ring of Green Plasma
	{ id = 23533, chance = 8894 }, -- Ring of Red Plasma
	{ id = 3036, chance = 10242 }, -- Violet Gem
	{ id = 31590, chance = 9703 }, -- Young Lich Worm
	{ id = 31577, chance = 1000 }, -- Terra Helmet
	{ id = 31579, chance = 1886 }, -- Embrace of Nature
	{ id = 31738, chance = 833 }, -- Final Judgement
	{ id = 31589, chance = 4312 }, -- Rotten Heart
	{ id = 31594, chance = 1195 }, -- Token of Love
	{ id = 23529, chance = 7816 }, -- Ring of Blue Plasma
	{ id = 31588, chance = 5929 }, -- Ancient Liche Bone
	{ id = 31578, chance = 1298 }, -- Bear Skin
	{ id = 30061, chance = 2695 }, -- Giant Sapphire
	{ id = 30060, chance = 2964 }, -- Giant Emerald
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "ice chain", interval = 2500, chance = 25, minDamage = -260, maxDamage = -360, range = 3, target = true },
	{ name = "combat", interval = 3500, chance = 37, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 2, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 350, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
