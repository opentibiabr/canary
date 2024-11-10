local mType = Game.createMonsterType("Ghulosh")
local monster = {}

monster.description = "Ghulosh"
monster.experience = 45000
monster.outfit = {
	lookType = 1062,
	lookHead = 78,
	lookBody = 113,
	lookLegs = 94,
	lookFeet = 18,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"ghuloshThink",
}

monster.bosstiary = {
	bossRaceId = 1608,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 26133
monster.speed = 50
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4,
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
	staticAttackChance = 98,
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

monster.loot = {
	{ name = "platinum coin", chance = 90000, maxCount = 53 },
	{ name = "crystal coin", chance = 90000, maxCount = 12 },
	{ name = "great spirit potion", chance = 90000, maxCount = 8 },
	{ name = "supreme health potion", chance = 90000, maxCount = 8 },
	{ name = "ultimate mana potion", chance = 90000, maxCount = 10 },
	{ name = "ultimate spirit potion", chance = 90000, maxCount = 8 },
	{ name = "silver token", chance = 90000, maxCount = 6 },
	{ name = "bullseye potion", chance = 90000 },
	{ name = "demon horn", chance = 90000 },
	{ name = "magic sulphur", chance = 90000 },
	{ id = 3039, chance = 90000 }, -- red gem
	{ name = "stone skin amulet", chance = 90000 },
	{ name = "yellow gem", chance = 90000 },
	{ name = "wand of voodoo", chance = 90000 },
	{ name = "mastermind potion", chance = 30000, maxCount = 2 },
	{ name = "onyx chip", chance = 30000, maxCount = 12 },
	{ name = "small diamond", chance = 30000, maxCount = 12 },
	{ name = "small emerald", chance = 30000, maxCount = 12 },
	{ name = "small ruby", chance = 30000, maxCount = 12 },
	{ name = "small topaz", chance = 30000, maxCount = 12 },
	{ name = "blue gem", chance = 30000 },
	{ name = "solid rage", chance = 30000 },
	{ name = "gold token", chance = 1000 },
	{ name = "butcher's axe", chance = 1000 },
	{ name = "dreaded cleaver", chance = 1000 },
	{ name = "mercenary sword", chance = 1000 },
	{ id = 28341, chance = 1000 }, -- tessellated wall
	{ name = "slightly rusted shield", chance = 5880 },
	{ name = "slightly rusted helmet", chance = 35290 },
	{ name = "epaulette", chance = 500 },
	{ name = "giant emerald", chance = 500 },
	{ name = "unliving demonbone", chance = 500 },
}

monster.attacks = {
	{ name = "melee", interval = 1000, chance = 100, skill = 150, attack = 280 },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -900, maxDamage = -1500, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -210, maxDamage = -600, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -210, maxDamage = -600, range = 7, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_LIFEDRAIN, minDamage = -1500, maxDamage = -2000, range = 7, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
