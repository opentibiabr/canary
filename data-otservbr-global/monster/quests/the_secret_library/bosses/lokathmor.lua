local mType = Game.createMonsterType("Lokathmor")
local monster = {}

monster.description = "Lokathmor"
monster.experience = 100000
monster.outfit = {
	lookType = 1062,
	lookHead = 22,
	lookBody = 57,
	lookLegs = 79,
	lookFeet = 77,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"lokathmorDeath",
}

monster.bosstiary = {
	bossRaceId = 1574,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 7893
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4,
}

monster.strategiesTarget = {
	nearest = 100,
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
	staticAttackChance = 98,
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

monster.summon = {
	maxSummons = 5,
	summons = {
		{ name = "demon blood", chance = 10, interval = 2000, count = 5 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 28792, chance = 80000 }, -- sturdy book
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 27933, chance = 80000 }, -- ominous book
	{ id = 27934, chance = 80000 }, -- knowledgeable book
	{ id = 7642, chance = 80000, maxCount = 4 }, -- great spirit potion
	{ id = 23374, chance = 80000, maxCount = 4 }, -- ultimate spirit potion
	{ id = 7643, chance = 80000, maxCount = 4 }, -- ultimate health potion
	{ id = 23373, chance = 80000, maxCount = 8 }, -- ultimate mana potion
	{ id = 7439, chance = 80000, maxCount = 2 }, -- berserk potion
	{ id = 3073, chance = 80000 }, -- wand of cosmic energy
	{ id = 3071, chance = 80000 }, -- wand of inferno
	{ id = 7419, chance = 80000 }, -- dreaded cleaver
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 3035, chance = 80000, maxCount = 58 }, -- platinum coin
	{ id = 3043, chance = 80000, maxCount = 4 }, -- crystal coin
	{ id = 22193, chance = 80000, maxCount = 12 }, -- onyx chip
	{ id = 3033, chance = 80000, maxCount = 12 }, -- small amethyst
	{ id = 3032, chance = 80000, maxCount = 12 }, -- small emerald
	{ id = 3028, chance = 80000, maxCount = 12 }, -- small diamond
	{ id = 3079, chance = 80000 }, -- boots of haste
	{ id = 22516, chance = 80000, maxCount = 6 }, -- silver token
	{ id = 22721, chance = 80000, maxCount = 5 }, -- gold token
	{ id = 5954, chance = 80000 }, -- demon horn
	{ id = 7440, chance = 80000, maxCount = 2 }, -- mastermind potion
	{ id = 8908, chance = 80000 }, -- slightly rusted helmet
	{ id = 10438, chance = 80000 }, -- spellweavers robe
	{ id = 7407, chance = 80000 }, -- haunted blade
	{ id = 7443, chance = 80000 }, -- bullseye potion
	{ id = 8902, chance = 80000 }, -- slightly rusted shield
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 23507, chance = 80000 }, -- crystallized anger
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 28829, chance = 80000 }, -- rotten demonbone
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 150, attack = 250 },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_LIFEDRAIN, minDamage = -1100, maxDamage = -2800, range = 7, radius = 5, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_DRAWBLOOD, target = true },
	{ name = "combat", interval = 1000, chance = 8, type = COMBAT_DEATHDAMAGE, minDamage = -800, maxDamage = -1900, radius = 9, effect = CONST_ME_MORTAREA, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 5000, chance = 18, minDamage = -1100, maxDamage = -2500, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -1000, maxDamage = -255, range = 7, radius = 6, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -90, maxDamage = -200, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONAREA, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
