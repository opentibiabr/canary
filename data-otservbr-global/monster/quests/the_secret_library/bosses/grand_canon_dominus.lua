local mType = Game.createMonsterType("Grand Canon Dominus")
local monster = {}

monster.description = "Grand Canon Dominus"
monster.experience = 11000
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 96,
	lookFeet = 105,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1584,
	bossRace = RARITY_BANE,
}

monster.health = 15000
monster.maxHealth = 15000
monster.race = "blood"
monster.corpse = 28737
monster.speed = 105
monster.manaCost = 0

monster.events = {
	"killingLibrary",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 238, chance = 80000, maxCount = 3 }, -- great mana potion
	{ id = 239, chance = 80000, maxCount = 3 }, -- great health potion
	{ id = 9057, chance = 80000, maxCount = 2 }, -- small topaz
	{ id = 3028, chance = 80000, maxCount = 2 }, -- small diamond
	{ id = 678, chance = 80000, maxCount = 2 }, -- small enchanted amethyst
	{ id = 7368, chance = 80000, maxCount = 10 }, -- assassin star
	{ id = 7365, chance = 80000, maxCount = 35 }, -- onyx arrow
	{ id = 3033, chance = 80000, maxCount = 2 }, -- small amethyst
	{ id = 3032, chance = 80000, maxCount = 2 }, -- small emerald
	{ id = 3030, chance = 80000, maxCount = 2 }, -- small ruby
	{ id = 28823, chance = 80000 }, -- falcon crest
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 28822, chance = 80000 }, -- damaged armor plates
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3414, chance = 80000 }, -- mastermind shield
	{ id = 28821, chance = 80000 }, -- patch of fine cloth
	{ id = 3360, chance = 80000 }, -- golden armor
	{ id = 28718, chance = 80000 }, -- falcon bow
	{ id = 28717, chance = 80000 }, -- falcon wand
	{ id = 28719, chance = 80000 }, -- falcon plate
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -700 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -720, range = 7, shootEffect = CONST_ANI_ETHEREALSPEAR, target = false },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -100, maxDamage = -1000, length = 8, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -700, range = 5, radius = 3, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -700, range = 5, radius = 3, effect = CONST_ME_SMALLCLOUDS, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 82,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 10, speedChange = 220, effect = CONST_ME_POFF, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 60 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
