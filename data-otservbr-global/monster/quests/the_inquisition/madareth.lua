local mType = Game.createMonsterType("Madareth")
local monster = {}

monster.description = "Madareth"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 77,
	lookBody = 78,
	lookLegs = 80,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.bosstiary = {
	bossRaceId = 414,
	bossRace = RARITY_BANE,
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "fire"
monster.corpse = 7893
monster.speed = 165
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 85,
	targetDistance = 1,
	runHealth = 1200,
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
	{ text = "I am going to play with yourself!", yell = false },
	{ text = "Feel my wrath!", yell = false },
	{ text = "No one matches my battle prowess!", yell = false },
	{ text = "You will all die!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 150 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 5954, chance = 80000, maxCount = 2 }, -- demon horn
	{ id = 3028, chance = 80000, maxCount = 2 }, -- small diamond
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 8896, chance = 80000 }, -- slightly rusted armor
	{ id = 8899, chance = 80000 }, -- slightly rusted legs
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 7443, chance = 80000 }, -- bullseye potion
	{ id = 3092, chance = 80000 }, -- axe ring
	{ id = 6299, chance = 80000 }, -- death ring
	{ id = 3091, chance = 80000 }, -- sword ring
	{ id = 3093, chance = 80000 }, -- club ring
	{ id = 3097, chance = 80000 }, -- dwarven ring
	{ id = 3052, chance = 80000 }, -- life ring
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 3053, chance = 80000 }, -- time ring
	{ id = 3071, chance = 80000 }, -- wand of inferno
	{ id = 8092, chance = 80000 }, -- wand of starstorm
	{ id = 8094, chance = 80000 }, -- wand of voodoo
	{ id = 8082, chance = 80000 }, -- underworld rod
	{ id = 3067, chance = 80000 }, -- hailstorm rod
	{ id = 8084, chance = 80000 }, -- springsprout rod
	{ id = 3260, chance = 80000 }, -- lyre
	{ id = 3047, chance = 80000 }, -- magic light wand
	{ id = 3262, chance = 80000 }, -- wooden flute
	{ id = 3258, chance = 80000 }, -- lute
	{ id = 2966, chance = 80000 }, -- war drum
	{ id = 2958, chance = 80000 }, -- war horn
	{ id = 2965, chance = 80000 }, -- didgeridoo
	{ id = 7416, chance = 80000 }, -- bloody edge
	{ id = 7449, chance = 80000 }, -- crystal sword
	{ id = 7386, chance = 80000 }, -- mercenary sword
	{ id = 7383, chance = 80000 }, -- relic sword
	{ id = 7404, chance = 80000 }, -- assassin dagger
	{ id = 7418, chance = 80000 }, -- nightmare blade
	{ id = 7407, chance = 80000 }, -- haunted blade
	{ id = 3265, chance = 80000 }, -- two handed sword
	{ id = 3284, chance = 80000 }, -- ice rapier
	{ id = 3079, chance = 80000 }, -- boots of haste
	{ id = 3387, chance = 80000 }, -- demon helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -180, maxDamage = -660, radius = 4, effect = CONST_ME_PURPLEENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -850, length = 5, spread = 2, effect = CONST_ME_BLACKSMOKE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -200, radius = 4, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -250, radius = 5, effect = CONST_ME_MAGIC_RED, target = true },
}

monster.defenses = {
	defense = 46,
	armor = 48,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 14, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 99 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -1 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 95 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
