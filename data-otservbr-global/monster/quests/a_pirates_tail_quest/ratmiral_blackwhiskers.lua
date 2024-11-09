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
	{ id = 3043, chance = 100000, minCount = 1, maxCount = 3 }, -- crystal coin
	{ id = 3035, chance = 55000, minCount = 1, maxCount = 39 }, -- platinum coin
	{ id = 7642, chance = 40000, minCount = 1, maxCount = 19 }, -- great spirit potion
	{ id = 7643, chance = 40000, minCount = 1, maxCount = 19 }, -- ultimate health potion
	{ id = 239, chance = 30000, minCount = 1, maxCount = 19 }, -- great health potion
	{ id = 238, chance = 30000, minCount = 1, maxCount = 19 }, -- great mana potion
	{ id = 23373, chance = 25000, minCount = 1, maxCount = 19 }, -- ultimate mana potion
	{ id = 7440, chance = 22000, minCount = 1, maxCount = 9 }, -- mastermind potion
	{ id = 7443, chance = 20000, minCount = 1, maxCount = 9 }, -- bullseye potion
	{ id = 35572, chance = 17000, minCount = 3, maxCount = 102 }, -- pirate coin
	{ id = 7439, chance = 16000, minCount = 1, maxCount = 9 }, -- berserk potion
	{ id = 35613, chance = 8000 }, -- ratmiral's hat
	{ id = 35571, chance = 7140 }, -- small treasure chest
	{ id = 35578, chance = 6250 }, -- tiara
	{ id = 35579, chance = 3570 }, -- golden dustbin
	{ id = 32626, chance = 2680 }, -- amber
	{ id = 35581, chance = 2680 }, -- golden cheese wedge
	{ id = 35595, chance = 2680 }, -- soap
	{ id = 35695, chance = 1790 }, -- scrubbing brush
	{ id = 35614, chance = 890 }, -- cheesy membership card
	{ id = 35523, chance = 890 }, -- exotic amulet
	{ id = 35515, chance = 890 }, -- throwing axe
	{ id = 35517, chance = 890 }, -- bast legs
	{ id = 35516, chance = 890 }, -- exotic legs
	{ id = 35518, chance = 890 }, -- jungle bow
	{ id = 35524, chance = 890 }, -- jungle quiver
	{ id = 35514, chance = 890 }, -- jungle flail
	{ id = 35521, chance = 890 }, -- jungle rod
	{ id = 35522, chance = 890 }, -- jungle wand
	{ id = 35519, chance = 890 }, -- makeshift boots
	{ id = 35520, chance = 890 }, -- make-do boots
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
