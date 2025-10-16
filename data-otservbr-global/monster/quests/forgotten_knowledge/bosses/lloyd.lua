local mType = Game.createMonsterType("Lloyd")
local monster = {}

monster.description = "Lloyd"
monster.experience = 50000
monster.outfit = {
	lookType = 940,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
	"LloydPrepareDeath",
}

monster.bosstiary = {
	bossRaceId = 1329,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 64000
monster.maxHealth = 64000
monster.race = "venom"
monster.corpse = 24927
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	runHealth = 1,
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
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 238, chance = 80000, maxCount = 10 }, -- great mana potion
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 7643, chance = 80000, maxCount = 10 }, -- ultimate health potion
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 16119, chance = 80000, maxCount = 3 }, -- blue crystal shard
	{ id = 5888, chance = 80000, maxCount = 2 }, -- piece of hell steel
	{ id = 5887, chance = 80000, maxCount = 2 }, -- piece of royal steel
	{ id = 5909, chance = 80000, maxCount = 3 }, -- white piece of cloth
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 10 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 10 }, -- small emerald
	{ id = 3030, chance = 80000, maxCount = 10 }, -- small ruby
	{ id = 9057, chance = 80000, maxCount = 10 }, -- small topaz
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 11454, chance = 80000 }, -- luminous orb
	{ id = 3079, chance = 80000 }, -- boots of haste
	{ id = 22727, chance = 80000 }, -- rift lance
	{ id = 7424, chance = 80000 }, -- lunar staff
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 8895, chance = 80000 }, -- rusted armor
	{ id = 8092, chance = 80000 }, -- wand of starstorm
	{ id = 3387, chance = 80000 }, -- demon helmet
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 8072, chance = 80000 }, -- spellbook of enlightenment
	{ id = 8073, chance = 80000 }, -- spellbook of warding
	{ id = 10438, chance = 80000 }, -- spellweavers robe
	{ id = 5891, chance = 80000 }, -- enchanted chicken wing
	{ id = 24393, chance = 80000 }, -- pillow backpack
	{ id = 22516, chance = 80000, maxCount = 2 }, -- silver token
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 3036, chance = 80000 }, -- violet gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -1400 },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -330, maxDamage = -660, length = 6, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "lloyd wave", interval = 2000, chance = 12, minDamage = -430, maxDamage = -560, target = false },
	{ name = "lloyd wave2", interval = 2000, chance = 12, minDamage = -230, maxDamage = -460, target = false },
	{ name = "lloyd wave3", interval = 2000, chance = 12, minDamage = -430, maxDamage = -660, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 55,
	mitigation = 2.35,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 180, maxDamage = 250, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
