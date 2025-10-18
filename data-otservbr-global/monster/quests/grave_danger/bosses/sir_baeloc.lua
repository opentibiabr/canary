local mType = Game.createMonsterType("Sir Baeloc")
local monster = {}

monster.description = "Sir Baeloc"
monster.experience = 55000
monster.outfit = {
	lookType = 1222,
	lookHead = 57,
	lookBody = 81,
	lookLegs = 3,
	lookFeet = 93,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "venom"
monster.corpse = 31599
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"BossHealthCheck",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1755,
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
	maxSummons = 3,
	summons = {
		{ name = "Retainer of Baeloc", chance = 20, interval = 2000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 22516, chance = 100000, maxCount = 2 }, -- Silver Token
	{ id = 3035, chance = 99585, maxCount = 5 }, -- Platinum Coin
	{ id = 23374, chance = 51037, maxCount = 20 }, -- Ultimate Spirit Potion
	{ id = 3038, chance = 15767 }, -- Green Gem
	{ id = 9058, chance = 13278 }, -- Gold Ingot
	{ id = 5888, chance = 26556, maxCount = 4 }, -- Piece of Hell Steel
	{ id = 23375, chance = 57261, maxCount = 20 }, -- Supreme Health Potion
	{ id = 23373, chance = 56431, maxCount = 20 }, -- Ultimate Mana Potion
	{ id = 3041, chance = 19087 }, -- Blue Gem
	{ id = 7443, chance = 21576, maxCount = 10 }, -- Bullseye Potion
	{ id = 23526, chance = 11618 }, -- Collar of Blue Plasma
	{ id = 3371, chance = 19502 }, -- Knight Legs
	{ id = 827, chance = 9128 }, -- Magma Monocle
	{ id = 31588, chance = 6224 }, -- Ancient Liche Bone
	{ id = 7439, chance = 19917, maxCount = 10 }, -- Berserk Potion
	{ id = 5887, chance = 16597 }, -- Piece of Royal Steel
	{ id = 3039, chance = 39419 }, -- Red Gem
	{ id = 23533, chance = 7468 }, -- Ring of Red Plasma
	{ id = 3324, chance = 21576 }, -- Skull Staff
	{ id = 3037, chance = 37759 }, -- Yellow Gem
	{ id = 31590, chance = 12448 }, -- Young Lich Worm
	{ id = 23543, chance = 12448 }, -- Collar of Green Plasma
	{ id = 23544, chance = 8298 }, -- Collar of Red Plasma
	{ id = 3043, chance = 15767 }, -- Crystal Coin
	{ id = 7440, chance = 14522, maxCount = 10 }, -- Mastermind Potion
	{ id = 23529, chance = 7883 }, -- Ring of Blue Plasma
	{ id = 3036, chance = 5809 }, -- Violet Gem
	{ id = 31738, chance = 1333 }, -- Final Judgement
	{ id = 31577, chance = 2255 }, -- Terra Helmet
	{ id = 31592, chance = 1204 }, -- Signet Ring
	{ id = 23531, chance = 5394 }, -- Ring of Green Plasma
	{ id = 31578, chance = 1092 }, -- Bear Skin
	{ id = 31589, chance = 4149 }, -- Rotten Heart
	{ id = 30060, chance = 4216 }, -- Giant Emerald
	{ id = 30061, chance = 4216 }, -- Giant Sapphire
	{ id = 30059, chance = 3012 }, -- Giant Ruby
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 3100, chance = 37, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 0, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "combat", interval = 2500, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -625, range = 5, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_DRAWBLOOD, target = true },
	{ name = "combat", interval = 2700, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -180, maxDamage = -250, range = 1, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 78,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 350, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 35 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
