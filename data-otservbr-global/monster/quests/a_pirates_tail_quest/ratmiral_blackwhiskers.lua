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
	{ id = 3043, chance = 80000, maxCount = 3 }, -- crystal coin
	{ id = 3035, chance = 80000, maxCount = 36 }, -- platinum coin
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 238, chance = 80000, maxCount = 10 }, -- great mana potion
	{ id = 239, chance = 80000, maxCount = 14 }, -- great health potion
	{ id = 23373, chance = 80000, maxCount = 18 }, -- ultimate mana potion
	{ id = 7642, chance = 80000, maxCount = 15 }, -- great spirit potion
	{ id = 7643, chance = 80000, maxCount = 10 }, -- ultimate health potion
	{ id = 7439, chance = 80000, maxCount = 5 }, -- berserk potion
	{ id = 35572, chance = 80000, maxCount = 100 }, -- pirate coin
	{ id = 35580, chance = 80000, maxCount = 5 }, -- golden skull
	{ id = 35613, chance = 5000 }, -- ratmirals hat
	{ id = 35614, chance = 1000 }, -- cheesy membership card
	{ id = 35581, chance = 5000 }, -- golden cheese wedge
	{ id = 35579, chance = 80000 }, -- golden dustbin
	{ id = 35578, chance = 80000 }, -- tiara
	{ id = 35571, chance = 1000 }, -- small treasure chest
	{ id = 35595, chance = 1000 }, -- soap
	{ id = 35695, chance = 1000 }, -- scrubbing brush
	{ id = 35520, chance = 260 }, -- makedo boots
	{ id = 35519, chance = 260 }, -- makeshift boots
	{ id = 35516, chance = 260 }, -- exotic legs
	{ id = 35517, chance = 260 }, -- bast legs
	{ id = 35523, chance = 260 }, -- exotic amulet
	{ id = 35515, chance = 260 }, -- throwing axe
	{ id = 35518, chance = 260 }, -- jungle bow
	{ id = 35514, chance = 260 }, -- jungle flail
	{ id = 35524, chance = 260 }, -- jungle quiver
	{ id = 35521, chance = 260 }, -- jungle rod
	{ id = 35522, chance = 260 }, -- jungle wand
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
