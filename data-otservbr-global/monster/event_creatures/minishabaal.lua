local mType = Game.createMonsterType("Minishabaal")
local monster = {}

monster.description = "Minishabaal"
monster.experience = 4000
monster.outfit = {
	lookType = 237,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 6000
monster.maxHealth = 6000
monster.race = "blood"
monster.corpse = 6363
monster.speed = 350
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
	targetDistance = 4,
	runHealth = 350,
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
	maxSummons = 3,
	summons = {
		{ name = "Diabolic Imp", chance = 40, interval = 2000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I had Princess Lumelia as breakfast", yell = false },
	{ text = "Naaa-Nana-Naaa-Naaa!", yell = false },
	{ text = "My brother will come and get you for this!", yell = false },
	{ text = "Get them Fluffy!", yell = false },
	{ text = "He He He", yell = false },
	{ text = "Pftt, Ferumbras such an upstart.", yell = false },
	{ text = "My dragon is not that old, it's just second hand.", yell = false },
	{ text = "My other dragon is a red one.", yell = false },
	{ text = "When I am big I want to become the ruthless eighth.", yell = false },
	{ text = "Muahaha!", yell = false },
	{ text = "WHERE'S FLUFFY?", yell = true },
	{ text = "COME HERE FLUFFY", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 1000, maxCount = 150 }, -- Gold Coin
	{ id = 3451, chance = 1000 }, -- Pitchfork
	{ id = 3320, chance = 1000 }, -- Fire Axe
	{ id = 5944, chance = 1000 }, -- Soul Orb
	{ id = 6499, chance = 1000 }, -- Demonic Essence
	{ id = 3033, chance = 1000 }, -- Small Amethyst
	{ id = 0, chance = 1000, maxCount = 5 }, -- Surprise Bag
	{ id = 3382, chance = 1000 }, -- Crown Legs
	{ id = 3420, chance = 1000 }, -- Demon Shield
	{ id = 3415, chance = 1000 }, -- Guardian Shield
	{ id = 3019, chance = 1000 }, -- Demonbone Amulet
	{ id = 3364, chance = 1000 }, -- Golden Legs
	{ id = 3442, chance = 1000 }, -- Tempest Shield
	{ id = 3387, chance = 1000 }, -- Demon Helmet
	{ id = 6299, chance = 1000 }, -- Death Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 70, attack = 95 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -80, maxDamage = -350, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 3000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -120, maxDamage = -500, range = 7, radius = 2, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 1.60,
	{ name = "combat", interval = 1000, chance = 50, type = COMBAT_HEALING, minDamage = 155, maxDamage = 255, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 12, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
	{ name = "invisible", interval = 4000, chance = 50, effect = CONST_ME_MAGIC_RED },
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
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
