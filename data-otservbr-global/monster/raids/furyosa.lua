local mType = Game.createMonsterType("Furyosa")
local monster = {}

monster.description = "Furyosa"
monster.experience = 11500
monster.outfit = {
	lookType = 149,
	lookHead = 94,
	lookBody = 79,
	lookLegs = 77,
	lookFeet = 3,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "blood"
monster.corpse = 18118
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 987,
	bossRace = RARITY_NEMESIS,
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Fury", chance = 10, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "MUHAHA!", yell = false },
	{ text = "Back in black!", yell = false },
	{ text = "Die!", yell = false },
	{ text = "Dieeee!", yell = false },
	{ text = "Caaarnaaage!", yell = false },
	{ text = "Ahhhhrrrr!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 363 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 25 }, -- platinum coin
	{ id = 8016, chance = 80000, maxCount = 9 }, -- jalapeno pepper
	{ id = 6093, chance = 80000 }, -- crystal ring
	{ id = 238, chance = 80000, maxCount = 5 }, -- great mana potion
	{ id = 19083, chance = 80000 }, -- silver raid token
	{ id = 3029, chance = 80000, maxCount = 5 }, -- small sapphire
	{ id = 5944, chance = 80000 }, -- soul orb
	{ id = 7368, chance = 80000, maxCount = 16 }, -- assassin star
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 7642, chance = 80000, maxCount = 9 }, -- great spirit potion
	{ id = 5911, chance = 80000 }, -- red piece of cloth
	{ id = 7643, chance = 80000, maxCount = 9 }, -- ultimate health potion
	{ id = 5909, chance = 80000 }, -- white piece of cloth
	{ id = 6558, chance = 80000 }, -- flask of demonic blood
	{ id = 6299, chance = 80000 }, -- death ring
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 826, chance = 80000 }, -- magma coat
	{ id = 821, chance = 80000 }, -- magma legs
	{ id = 3028, chance = 80000, maxCount = 9 }, -- small diamond
	{ id = 3030, chance = 80000, maxCount = 7 }, -- small ruby
	{ id = 9057, chance = 80000, maxCount = 8 }, -- small topaz
	{ id = 5914, chance = 80000 }, -- yellow piece of cloth
	{ id = 3439, chance = 80000 }, -- phoenix shield
	{ id = 19391, chance = 80000 }, -- furious frock
	{ id = 7404, chance = 80000 }, -- assassin dagger
	{ id = 7456, chance = 80000 }, -- noble axe
	{ id = 16115, chance = 80000 }, -- wand of everblazing
	{ id = 3364, chance = 80000 }, -- golden legs
	{ id = 3280, chance = 80000 }, -- fire sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -625 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -260, maxDamage = -310, radius = 6, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -210, length = 8, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -300, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -800, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -150, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "fury skill reducer", interval = 2000, chance = 5, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE },
	{ name = "combat", interval = 7000, chance = 20, type = COMBAT_HEALING, minDamage = 500, maxDamage = 700, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
