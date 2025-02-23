local mType = Game.createMonsterType("Angry Sugar Fairy")
local monster = {}

monster.description = "an angry sugar fairy"
monster.experience = 3100
monster.outfit = {
	lookType = 1747,
	lookHead = 16,
	lookBody = 5,
	lookLegs = 54,
	lookFeet = 93,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2552
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Dessert Dungeons, Candy Carnival.",
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "undead"
monster.corpse = 48340
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Don't trample the beautiful sprinkles! That makes me angry!", yell = false },
	{ text = "No sweet sugar jewellery for you, intruder!", yell = false },
	{ text = "This is not the Candy Carnival! You should leave!", yell = false },
}

monster.loot = {
	{ name = "platinum coin", chance = 93020, maxCount = 11 },
	{ name = "small enchanted emerald", chance = 8830, maxCount = 4 },
	{ name = "wild flowers", chance = 7410 },
	{ name = "small enchanted sapphire", chance = 5860, maxCount = 4 },
	{ name = "green crystal splinter", chance = 5820 },
	{ name = "violet crystal shard", chance = 4040 },
	{ name = "small enchanted ruby", chance = 3840, maxCount = 3 },
	{ name = "wand of cosmic energy", chance = 3770 },
	{ name = "white pearl", chance = 2710, maxCount = 3 },
	{ name = "prismatic quartz", chance = 2320 },
	{ name = "ruby necklace", chance = 1890 },
	{ name = "wafer paper flower", chance = 1650 },
	{ name = "spellbook of enlightenment", chance = 960 },
	{ name = "butterfly ring", chance = 760 },
	{ name = "milk chocolate coin", chance = 760, maxCount = 10 },
	{ id = 3098, chance = 730 }, -- ring of healing
	{ name = "hibiscus dress", chance = 360 },
	{ id = 3040, chance = 230 }, -- gold nugget
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110 },
	{ name = "combat", interval = 2000, chance = 20, minDamage = -100, maxDamage = -230, range = 6, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "combat", interval = 2000, chance = 20, minDamage = -130, maxDamage = -280, range = 5, radius = 3, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ELECTRICALSPARK, target = true },
}

monster.defenses = {
	defense = 37,
	armor = 37,
	mitigation = 1.10,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 100, maxDamage = 200, effect = CONST_ME_CACAO, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 40 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
