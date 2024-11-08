local mType = Game.createMonsterType("Ghazbaran")
local monster = {}

monster.description = "Ghazbaran"
monster.experience = 15000
monster.outfit = {
	lookType = 12,
	lookHead = 0,
	lookBody = 85,
	lookLegs = 78,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 312,
	bossRace = RARITY_NEMESIS,
}

monster.health = 77000
monster.maxHealth = 77000
monster.race = "undead"
monster.corpse = 6068
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 3500,
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
		{ name = "Deathslicer", chance = 20, interval = 4000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "COME AND GIVE ME SOME AMUSEMENT", yell = true },
	{ text = "IS THAT THE BEST YOU HAVE TO OFFER, TIBIANS?", yell = true },
	{ text = "I AM GHAZBARAN OF THE TRIANGLE... AND I AM HERE TO CHALLENGE YOU ALL.", yell = true },
	{ text = "FLAWLESS VICTORY!", yell = true },
}

monster.loot = {
	{ name = "blue tome", chance = 20000 },
	{ name = "teddy bear", chance = 12500 },
	{ id = 3007, chance = 8333 }, -- crystal ring
	{ name = "white pearl", chance = 25000, maxCount = 15 },
	{ name = "black pearl", chance = 11111, maxCount = 14 },
	{ name = "small diamond", chance = 25000, maxCount = 5 },
	{ name = "small sapphire", chance = 25000, maxCount = 10 },
	{ name = "small emerald", chance = 25000, maxCount = 10 },
	{ name = "small amethyst", chance = 25000, maxCount = 17 },
	{ name = "talon", chance = 12500, maxCount = 7 },
	{ name = "platinum coin", chance = 100000, maxCount = 69 },
	{ name = "green gem", chance = 20000 },
	{ name = "blue gem", chance = 14285 },
	{ name = "might ring", chance = 12500 },
	{ id = 3049, chance = 12500 }, -- stealth ring
	{ name = "strange symbol", chance = 11111 },
	{ name = "life crystal", chance = 12500 },
	{ name = "mind stone", chance = 20000 },
	{ name = "gold ring", chance = 20000 },
	{ id = 3098, chance = 20000 }, -- ring of healing
	{ name = "twin axe", chance = 11111 },
	{ name = "golden armor", chance = 8333 },
	{ name = "magic plate armor", chance = 8333 },
	{ name = "demon shield", chance = 12500 },
	{ name = "golden boots", chance = 8333 },
	{ name = "demon horn", chance = 33333, maxCount = 2 },
	{ id = 6299, chance = 25000 }, -- death ring
	{ name = "demonic essence", chance = 100000 },
	{ name = "ruthless axe", chance = 14285 },
	{ name = "assassin star", chance = 12500, maxCount = 44 },
	{ name = "havoc blade", chance = 16666 },
	{ name = "ravenwing", chance = 14285 },
	{ name = "great mana potion", chance = 20000 },
	{ name = "great health potion", chance = 20000 },
	{ name = "glacier kilt", chance = 8333 },
	{ name = "great spirit potion", chance = 25000 },
	{ name = "ultimate health potion", chance = 25000 },
	{ name = "oceanborn leviathan armor", chance = 16666 },
	{ name = "frozen plate", chance = 8333 },
	{ name = "spellbook of warding", chance = 20000 },
	{ name = "spellbook of mind control", chance = 11111 },
	{ name = "spellbook of lost souls", chance = 16666 },
	{ name = "spellscroll of prophecies", chance = 25000 },
	{ name = "spellbook of dark mysteries", chance = 20000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2191 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -500, range = 7, radius = 6, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 3000, chance = 34, type = COMBAT_PHYSICALDAMAGE, minDamage = -120, maxDamage = -500, range = 7, radius = 1, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = true },
	{ name = "combat", interval = 4000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -800, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -480, range = 14, radius = 5, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -650, range = 7, radius = 13, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 4000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -600, radius = 14, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -750, range = 7, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 300, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 4000, chance = 80, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 1 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
