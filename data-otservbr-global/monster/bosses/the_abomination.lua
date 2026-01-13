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
	{ text = "I AM THE ESSENCE OF DEATH!", yell = true },
	{ text = "YOU CAN NOT ESCAPE ME!", yell = true },
	{ text = "DESTRUCTION!", yell = true },
	{ text = "DRUIDS! ... LIKE ... DRUID FLAVOUR!", yell = true },
	{ text = "WILL EAT DRUIDS!", yell = true },
	{ text = "KNIGHTS! ... DELICIOUS KNIGHTS!", yell = true },
	{ text = "WILL EAT KNIGHTS!", yell = true },
	{ text = "PALADINS!... TASTY!", yell = true },
	{ text = "WILL EAT PALADINS!", yell = true },
	{ text = "SORCERERS! ... MUST EAT SORCERERS!", yell = true },
	{ text = "WILL EAT SORCERERS!", yell = true },
	{ text = "HUNGER ... SO ... GREAT! YOU ALL .. WILL .... DIE!!!", yell = true },
	{ text = "DIIIIEEEEE!", yell = true },
}

monster.loot = {
	{ name = "gold coin", chance = 74230, maxCount = 10 },
	{ name = "bullseye potion", chance = 74230, maxCount = 10 },
	{ name = "mastermind potion", chance = 74230, maxCount = 10 },
	{ name = "berserk potion", chance = 74230, maxCount = 17 },
	{ name = "ultimate mana potion", chance = 74230, maxCount = 20 },
	{ name = "ultimate spirit potion", chance = 74230, maxCount = 8 },
	{ name = "supreme health potion", chance = 74230, maxCount = 8 },
	{ name = "goblet of gloom", chance = 7000, maxCount = 1 },
	{ name = "violet gem", chance = 7000, maxCount = 1 },
	{ name = "gruesome fan", chance = 7000, maxCount = 1 },
	{ name = "crystal coin", chance = 7000, maxCount = 200 },
	{ name = "amber with a dragonfly", chance = 7000, maxCount = 1 },
	{ name = "abomination's tongue", chance = 7000, maxCount = 1 },
	{ name = "abomination's eye", chance = 7000, maxCount = 1 },
	{ name = "abomination's tail", chance = 7000, maxCount = 1 },
	{ name = "brooch of embracement", chance = 7000, maxCount = 1 },
	{ name = "giant amethyst", chance = 7000, maxCount = 1 },
	{ name = "giant topaz", chance = 7000, maxCount = 1 },
	{ name = "raw watermelon tourmaline", chance = 7000, maxCount = 1 },
	{ name = "fiery horseshoe", chance = 5990, maxCount = 1 },
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
