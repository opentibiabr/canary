local mType = Game.createMonsterType("Ferumbras")
local monster = {}

monster.description = "Ferumbras"
monster.experience = 12000
monster.outfit = {
	lookType = 229,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 231,
	bossRace = RARITY_NEMESIS,
}

monster.health = 90000
monster.maxHealth = 90000
monster.race = "venom"
monster.corpse = 6078
monster.speed = 160
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
	targetDistance = 2,
	runHealth = 2500,
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
	maxSummons = 4,
	summons = {
		{ name = "Demon", chance = 12, interval = 3000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "NO ONE WILL STOP ME THIS TIME!", yell = true },
	{ text = "THE POWER IS MINE!", yell = true },
	{ text = "I returned from death and you dream about defeating me?", yell = false },
	{ text = "Witness the first seconds of my eternal world domination!", yell = false },
	{ text = "Even in my weakened state I will crush you all!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 270 }, -- gold coin
	{ id = 3027, chance = 80000, maxCount = 42 }, -- black pearl
	{ id = 3033, chance = 80000, maxCount = 76 }, -- small amethyst
	{ id = 3029, chance = 80000, maxCount = 92 }, -- small sapphire
	{ id = 3030, chance = 80000, maxCount = 49 }, -- small ruby
	{ id = 3026, chance = 80000, maxCount = 8 }, -- white pearl
	{ id = 3028, chance = 80000, maxCount = 90 }, -- small diamond
	{ id = 9057, chance = 80000, maxCount = 86 }, -- small topaz
	{ id = 3032, chance = 80000, maxCount = 100 }, -- small emerald
	{ id = 5944, chance = 80000, maxCount = 8 }, -- soul orb
	{ id = 9058, chance = 80000, maxCount = 2 }, -- gold ingot
	{ id = 3034, chance = 80000 }, -- talon
	{ id = 3066, chance = 80000 }, -- snakebite rod
	{ id = 3069, chance = 80000 }, -- necrotic rod
	{ id = 3063, chance = 80000 }, -- gold ring
	{ id = 3320, chance = 80000 }, -- fire axe
	{ id = 6093, chance = 80000 }, -- crystal ring
	{ id = 3051, chance = 80000 }, -- energy ring
	{ id = 3010, chance = 80000 }, -- emerald bangle
	{ id = 3062, chance = 80000 }, -- mind stone
	{ id = 3275, chance = 80000 }, -- double axe
	{ id = 3265, chance = 80000 }, -- two handed sword
	{ id = 3054, chance = 80000 }, -- silver amulet
	{ id = 3360, chance = 80000 }, -- golden armor
	{ id = 3364, chance = 80000 }, -- golden legs
	{ id = 3055, chance = 80000 }, -- platinum amulet
	{ id = 3079, chance = 80000 }, -- boots of haste
	{ id = 3356, chance = 80000 }, -- devil helmet
	{ id = 7422, chance = 80000 }, -- jade hammer
	{ id = 3414, chance = 80000 }, -- mastermind shield
	{ id = 2993, chance = 80000 }, -- teddy bear
	{ id = 3366, chance = 80000 }, -- magic plate armor
	{ id = 8074, chance = 80000 }, -- spellbook of mind control
	{ id = 8075, chance = 80000 }, -- spellbook of lost souls
	{ id = 8076, chance = 80000 }, -- spellscroll of prophecies
	{ id = 823, chance = 80000 }, -- glacier kilt
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 812, chance = 80000 }, -- terra legs
	{ id = 821, chance = 80000 }, -- magma legs
	{ id = 7407, chance = 80000 }, -- haunted blade
	{ id = 7414, chance = 80000 }, -- abyss hammer
	{ id = 7403, chance = 80000 }, -- berserker
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 7451, chance = 80000 }, -- shadow sceptre
	{ id = 7410, chance = 80000 }, -- queens sceptre
	{ id = 7411, chance = 80000 }, -- ornamented axe
	{ id = 7388, chance = 80000 }, -- vile axe
	{ id = 8041, chance = 80000 }, -- greenwood coat
	{ id = 8057, chance = 80000 }, -- divine plate
	{ id = 8102, chance = 80000 }, -- emerald sword
	{ id = 8100, chance = 80000 }, -- obsidian truncheon
	{ id = 8090, chance = 80000 }, -- spellbook of dark mysteries
	{ id = 7423, chance = 80000 }, -- skullcrusher
	{ id = 3422, chance = 80000 }, -- great shield
	{ id = 2852, chance = 80000 }, -- red tome
	{ id = 3439, chance = 80000 }, -- phoenix shield
	{ id = 8096, chance = 80000 }, -- hellforged axe
	{ id = 7435, chance = 80000 }, -- impaler
	{ id = 3442, chance = 80000 }, -- tempest shield
	{ id = 8040, chance = 80000 }, -- velvet mantle
	{ id = 7382, chance = 80000 }, -- demonrage sword
	{ id = 7416, chance = 80000 }, -- bloody edge
	{ id = 8098, chance = 80000 }, -- demonwing axe
	{ id = 7405, chance = 80000 }, -- havoc blade
	{ id = 7418, chance = 80000 }, -- nightmare blade
	{ id = 3420, chance = 80000 }, -- demon shield
	{ id = 7417, chance = 80000 }, -- runed sword
	{ id = 3303, chance = 80000 }, -- great axe
	{ id = 5903, chance = 80000 }, -- ferumbras hat
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3038, chance = 80000 }, -- green gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -500, maxDamage = -700, range = 7, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -450, length = 8, spread = 0, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 21, type = COMBAT_LIFEDRAIN, minDamage = -450, maxDamage = -500, radius = 6, effect = CONST_ME_POFF, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -20, maxDamage = -40, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -900, maxDamage = -1000, range = 4, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 18, minDamage = -300, maxDamage = -400, radius = 6, effect = CONST_ME_ENERGYHIT, target = false },
	-- fire
	{ name = "condition", type = CONDITION_FIRE, interval = 3000, chance = 20, minDamage = -500, maxDamage = -600, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
}

monster.defenses = {
	defense = 120,
	armor = 100,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 900, maxDamage = 1500, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "invisible", interval = 4000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 90 },
	{ type = COMBAT_EARTHDAMAGE, percent = 90 },
	{ type = COMBAT_FIREDAMAGE, percent = 90 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
