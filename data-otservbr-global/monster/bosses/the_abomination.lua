local mType = Game.createMonsterType("The Abomination")
local monster = {}

monster.description = "The Abomination"
monster.experience = 1500000
monster.outfit = {
	lookType = 1393,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 373,
	bossRace = RARITY_NEMESIS,
}

monster.health = 750000
monster.maxHealth = 750000
monster.race = "venom"
monster.corpse = 36612
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	{ text = "ANIHILATION!", yell = true },
	{ text = "DEATH IS INEVITABLE!", yell = true },
	{ text = "DESTRUCTION!", yell = true },
	{ text = "I AM THE ESSENCE OF DEATH!", yell = true },
	{ text = "YOU CAN NOT ESCAPE ME!", yell = true },
	{ text = "DRUIDS! ... LIKE ... DRUID FLAVOUR!", yell = true },
	{ text = "WILL EAT DRUIDS!", yell = true },
	{ text = "KNIGHTS! ... DELICIOUS KNIGHTS!", yell = true },
	{ text = "WILL EAT KNIGHTS!", yell = true },
	{ text = "PALADINS!... TASTY!", yell = true },
	{ text = "WILL EAT PALADINS!", yell = true },
	{ text = "SORCERERS! ... MUST EAT SORCERERS!", yell = true },
	{ text = "WILL EAT SORCERERS!", yell = true },
	{ text = "HUNGER ... SO ... GREAT! YOU ALL .. WILL .... DIE!!!", yell = true },
	{ text = "PAIN!", yell = true },
	{ text = "DIIIIEEEEE!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 3027, chance = 80000 }, -- black pearl
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 6299, chance = 80000 }, -- death ring
	{ id = 5944, chance = 80000 }, -- soul orb
	{ id = 8896, chance = 80000 }, -- slightly rusted armor
	{ id = 36792, chance = 80000 }, -- abominations eye
	{ id = 36791, chance = 80000 }, -- abominations tail
	{ id = 36793, chance = 80000 }, -- abominations tongue
	{ id = 36938, chance = 80000 }, -- fiery horseshoe
	{ id = 23373, chance = 80000, maxCount = 20 }, -- ultimate mana potion
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3043, chance = 80000, maxCount = 39 }, -- crystal coin
	{ id = 7443, chance = 80000, maxCount = 19 }, -- bullseye potion
	{ id = 32625, chance = 80000 }, -- amber with a dragonfly
	{ id = 7439, chance = 80000, maxCount = 19 }, -- berserk potion
	{ id = 32624, chance = 80000 }, -- amber with a bug
	{ id = 7440, chance = 80000, maxCount = 19 }, -- mastermind potion
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 23375, chance = 80000, maxCount = 11 }, -- supreme health potion
	{ id = 23374, chance = 80000, maxCount = 11 }, -- ultimate spirit potion
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 32769, chance = 80000 }, -- white gem
	{ id = 34024, chance = 80000 }, -- gruesome fan
	{ id = 34025, chance = 80000 }, -- diabolic skull
	{ id = 34023, chance = 80000 }, -- brooch of embracement
	{ id = 33778, chance = 80000 }, -- raw watermelon tourmaline
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 120 },
	{ name = "speed", interval = 1000, chance = 12, speedChange = -800, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 10000 },
	{ name = "combat", interval = 1000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -650, radius = 4, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 1000, chance = 11, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -900, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_SOUND_GREEN, target = true },
	{ name = "combat", interval = 2000, chance = 19, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -850, length = 7, spread = 0, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 75, type = COMBAT_HEALING, minDamage = 505, maxDamage = 605, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
