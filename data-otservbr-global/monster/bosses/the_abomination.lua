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
	{ id = 3031, chance = 100000 }, -- Gold Coin
	{ id = 3030, chance = 1000 }, -- Small Ruby
	{ id = 3032, chance = 1000 }, -- Small Emerald
	{ id = 3027, chance = 1000 }, -- Black Pearl
	{ id = 6499, chance = 1000 }, -- Demonic Essence
	{ id = 6299, chance = 1000 }, -- Death Ring
	{ id = 5944, chance = 1000 }, -- Soul Orb
	{ id = 8896, chance = 1000 }, -- Slightly Rusted Armor
	{ id = 36792, chance = 8955 }, -- Abomination's Eye
	{ id = 36791, chance = 2631 }, -- Abomination's Tail
	{ id = 36793, chance = 3448 }, -- Abomination's Tongue
	{ id = 36938, chance = 2631 }, -- Fiery Horseshoe
	{ id = 23373, chance = 32835, maxCount = 20 }, -- Ultimate Mana Potion
	{ id = 3036, chance = 2631 }, -- Violet Gem
	{ id = 3043, chance = 80597, maxCount = 39 }, -- Crystal Coin
	{ id = 7443, chance = 11940, maxCount = 19 }, -- Bullseye Potion
	{ id = 32625, chance = 2631 }, -- Amber with a Dragonfly
	{ id = 7439, chance = 17910, maxCount = 19 }, -- Berserk Potion
	{ id = 32624, chance = 2631 }, -- Amber with a Bug
	{ id = 7440, chance = 19402, maxCount = 19 }, -- Mastermind Potion
	{ id = 30060, chance = 5263 }, -- Giant Emerald
	{ id = 23375, chance = 23880, maxCount = 11 }, -- Supreme Health Potion
	{ id = 23374, chance = 23880, maxCount = 11 }, -- Ultimate Spirit Potion
	{ id = 30059, chance = 5970 }, -- Giant Ruby
	{ id = 30061, chance = 2631 }, -- Giant Sapphire
	{ id = 32769, chance = 2985 }, -- White Gem
	{ id = 34024, chance = 5263 }, -- Gruesome Fan
	{ id = 34025, chance = 2985 }, -- Diabolic Skull
	{ id = 34023, chance = 5263 }, -- Brooch of Embracement
	{ id = 33778, chance = 2631 }, -- Raw Watermelon Tourmaline
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
