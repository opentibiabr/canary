local mType = Game.createMonsterType("Drume")
local monster = {}

monster.description = "Drume"
monster.experience = 25000
monster.outfit = {
	lookType = 1317,
	lookHead = 38,
	lookBody = 76,
	lookLegs = 57,
	lookFeet = 114,
	lookAddons = 2,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1957,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 80000
monster.maxHealth = 80000
monster.race = "blood"
monster.corpse = 33973
monster.speed = 130
monster.manaCost = 0

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = { FACTION_LION, FACTION_PLAYER }

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "preceptor lazare", chance = 10, interval = 8000, count = 1 },
		{ name = "grand commander soeren", chance = 10, interval = 8000, count = 1 },
		{ name = "grand chaplain gaunder", chance = 10, interval = 8000, count = 1 },
	},
}

monster.changeTarget = {
	interval = 4000,
	chance = 25,
}

monster.strategiesTarget = {
	nearest = 50,
	health = 20,
	damage = 20,
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "I've studied the Cobras - I wield the secrets of the snake!", yell = false },
	{ text = "I am a true knight of the lion, you will never defeat the true order!", yell = false },
	{ text = "The Falcons will come to my aid in need!", yell = false },
}

monster.loot = {
	{ id = 23535, chance = 80000 }, -- energy bar
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 23375, chance = 80000, maxCount = 20 }, -- supreme health potion
	{ id = 23373, chance = 80000, maxCount = 14 }, -- ultimate mana potion
	{ id = 36706, chance = 80000, maxCount = 2 }, -- red gem
	{ id = 25759, chance = 80000, maxCount = 100 }, -- royal star
	{ id = 7443, chance = 80000, maxCount = 16 }, -- bullseye potion
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 812, chance = 80000 }, -- terra legs
	{ id = 811, chance = 80000 }, -- terra mantle
	{ id = 7439, chance = 80000, maxCount = 10 }, -- berserk potion
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 830, chance = 80000 }, -- terra hood
	{ id = 23374, chance = 80000, maxCount = 6 }, -- ultimate spirit potion
	{ id = 8082, chance = 80000 }, -- underworld rod
	{ id = 33778, chance = 80000 }, -- raw watermelon tourmaline
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 8094, chance = 80000 }, -- wand of voodoo
	{ id = 814, chance = 80000 }, -- terra amulet
	{ id = 3065, chance = 80000 }, -- terra rod
	{ id = 34158, chance = 80000 }, -- lion amulet
	{ id = 34253, chance = 80000 }, -- lion axe
	{ id = 34150, chance = 80000 }, -- lion longbow
	{ id = 34157, chance = 80000 }, -- lion plate
	{ id = 34156, chance = 80000 }, -- lion spangenhelm
	{ id = 34152, chance = 80000 }, -- lion wand
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 34153, chance = 80000 }, -- lion spellbook
	{ id = 34254, chance = 80000 }, -- lion hammer
	{ id = 34155, chance = 80000 }, -- lion longsword
	{ id = 34151, chance = 80000 }, -- lion rod
	{ id = 34154, chance = 80000 }, -- lion shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1100, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 2700, chance = 25, type = COMBAT_HOLYDAMAGE, minDamage = -850, maxDamage = -1150, length = 8, spread = 0, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 3100, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -800, maxDamage = -1200, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3300, chance = 22, type = COMBAT_DEATHDAMAGE, minDamage = -800, maxDamage = -1000, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3700, chance = 24, type = COMBAT_ICEDAMAGE, minDamage = -700, maxDamage = -900, length = 4, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "singlecloudchain", interval = 2100, chance = 34, minDamage = -600, maxDamage = -1100, range = 4, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 60,
	armor = 82,
	--	mitigation = ???,
	{ name = "combat", interval = 4000, chance = 40, type = COMBAT_HEALING, minDamage = 300, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 35 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
