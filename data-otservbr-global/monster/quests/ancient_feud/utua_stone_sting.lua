local mType = Game.createMonsterType("Utua Stone Sting")
local monster = {}

monster.description = "Utua Stone Sting"
monster.experience = 5100
monster.outfit = {
	lookType = 398,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1984,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 6400
monster.maxHealth = 6400
monster.race = "undead"
monster.corpse = 12512
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 60,
	random = 40,
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
}

monster.loot = {
	{ id = 34101, chance = 80000 }, -- utuas poison
	{ id = 3035, chance = 80000, maxCount = 9 }, -- platinum coin
	{ id = 7643, chance = 80000, maxCount = 3 }, -- ultimate health potion
	{ id = 9651, chance = 80000, maxCount = 3 }, -- scorpion tail
	{ id = 33778, chance = 80000 }, -- raw watermelon tourmaline
	{ id = 823, chance = 80000 }, -- glacier kilt
	{ id = 3333, chance = 80000 }, -- crystal mace
	{ id = 3010, chance = 80000 }, -- emerald bangle
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 7386, chance = 80000 }, -- mercenary sword
	{ id = 14040, chance = 80000 }, -- warriors axe
	{ id = 24391, chance = 80000 }, -- coral brooch
	{ id = 24392, chance = 80000 }, -- gemmed figurine
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 5741, chance = 80000 }, -- skull helmet
	{ id = 10438, chance = 80000 }, -- spellweavers robe
	{ id = 34258, chance = 80000 }, -- red silk flower
	{ id = 3366, chance = 80000 }, -- magic plate armor
	{ id = 3420, chance = 80000 }, -- demon shield
	{ id = 14043, chance = 80000 }, -- guardian axe
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 821, chance = 80000 }, -- magma legs
	{ id = 12546, chance = 80000 }, -- fist on a stick
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 7456, chance = 80000 }, -- noble axe
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 824, chance = 80000 }, -- glacier robe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300, condition = { type = CONDITION_POISON, totalDamage = 1000, interval = 4000 } },
	{ name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2000, chance = 30, minDamage = -200, maxDamage = -300, target = true, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA },
	{ name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2000, chance = 25, minDamage = -300, maxDamage = -450, radius = 3, length = 3, spread = 3, target = true, shootEffect = CONST_ANI_POISONARROW, effect = CONST_ME_POISONAREA },
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 4000, chance = 40, minDamage = 0, maxDamage = -400, length = 4, spread = 3, effect = CONST_ME_DRAWBLOOD },
}

monster.defenses = {
	defense = 0,
	armor = 42,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 60, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
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
