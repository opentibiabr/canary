local mType = Game.createMonsterType("Golgordan")
local monster = {}

monster.description = "Golgordan"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 52,
	lookBody = 99,
	lookLegs = 52,
	lookFeet = 91,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.bosstiary = {
	bossRaceId = 416,
	bossRace = RARITY_BANE,
}

monster.health = 40000
monster.maxHealth = 40000
monster.race = "fire"
monster.corpse = 7893
monster.speed = 195
monster.manaCost = 0

monster.changeTarget = {
	interval = 7000,
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
	canPushCreatures = true,
	staticAttackChance = 85,
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
	{ text = "Latrivan, you fool!", yell = false },
	{ text = "We are the right hand and the left hand of the seven!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 262 }, -- gold coin
	{ id = 239, chance = 80000, maxCount = 2 }, -- great health potion
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 3047, chance = 80000 }, -- magic light wand
	{ id = 3275, chance = 80000 }, -- double axe
	{ id = 3033, chance = 80000, maxCount = 20 }, -- small amethyst
	{ id = 3063, chance = 80000 }, -- gold ring
	{ id = 3290, chance = 80000 }, -- silver dagger
	{ id = 3029, chance = 80000, maxCount = 10 }, -- small sapphire
	{ id = 3049, chance = 80000 }, -- stealth ring
	{ id = 3051, chance = 80000 }, -- energy ring
	{ id = 3027, chance = 80000, maxCount = 15 }, -- black pearl
	{ id = 3054, chance = 80000 }, -- silver amulet
	{ id = 3032, chance = 80000, maxCount = 10 }, -- small emerald
	{ id = 3356, chance = 80000 }, -- devil helmet
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 3320, chance = 80000 }, -- fire axe
	{ id = 3420, chance = 80000 }, -- demon shield
	{ id = 3026, chance = 80000, maxCount = 15 }, -- white pearl
	{ id = 7365, chance = 80000, maxCount = 8 }, -- onyx arrow
	{ id = 3028, chance = 80000, maxCount = 5 }, -- small diamond
	{ id = 3281, chance = 80000 }, -- giant sword
	{ id = 3284, chance = 80000 }, -- ice rapier
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 6299, chance = 80000 }, -- death ring
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 3062, chance = 80000 }, -- mind stone
	{ id = 3084, chance = 80000 }, -- protection amulet
	{ id = 3070, chance = 80000 }, -- moonlight rod
	{ id = 3048, chance = 80000 }, -- might ring
	{ id = 3066, chance = 80000 }, -- snakebite rod
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 22196, chance = 80000 }, -- crystal ball
	{ id = 3072, chance = 80000 }, -- wand of decay
	{ id = 3069, chance = 80000 }, -- necrotic rod
	{ id = 7368, chance = 80000, maxCount = 6 }, -- assassin star
	{ id = 3306, chance = 80000 }, -- golden sickle
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3414, chance = 80000 }, -- mastermind shield
	{ id = 3079, chance = 80000 }, -- boots of haste
	{ id = 3364, chance = 80000 }, -- golden legs
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 9179, chance = 80000 }, -- voodoo doll
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -60, maxDamage = -200, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 1000, chance = 11, minDamage = -30, maxDamage = -30, length = 5, spread = 3, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -50, maxDamage = -600, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -600, range = 4, radius = 1, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -600, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 1000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -50, maxDamage = -60, radius = 6, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 54,
	armor = 48,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -1 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
