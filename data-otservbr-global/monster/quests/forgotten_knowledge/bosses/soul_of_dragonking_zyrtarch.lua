local mType = Game.createMonsterType("Soul of Dragonking Zyrtarch")
local monster = {}

monster.description = "soul of Dragonking Zyrtarch"
monster.experience = 70000
monster.outfit = {
	lookType = 938,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1289,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 150000
monster.maxHealth = 150000
monster.race = "fire"
monster.corpse = 25065
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	{ text = "What have you done!?", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 25 }, -- platinum coin
	{ id = 16119, chance = 80000, maxCount = 3 }, -- blue crystal shard
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 238, chance = 80000, maxCount = 10 }, -- great mana potion
	{ id = 7642, chance = 80000, maxCount = 10 }, -- great spirit potion
	{ id = 7643, chance = 80000, maxCount = 10 }, -- ultimate health potion
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 10 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 10 }, -- small emerald
	{ id = 3030, chance = 80000, maxCount = 10 }, -- small ruby
	{ id = 9057, chance = 80000, maxCount = 10 }, -- small topaz
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 11652, chance = 80000 }, -- broken key ring
	{ id = 9067, chance = 80000 }, -- crystal of power
	{ id = 24967, chance = 80000 }, -- dragon crown
	{ id = 24938, chance = 80000 }, -- dragon tongue
	{ id = 7430, chance = 80000 }, -- dragonbone staff
	{ id = 4033, chance = 80000 }, -- draken boots
	{ id = 10388, chance = 80000 }, -- drakinata
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 24968, chance = 80000 }, -- golden talon
	{ id = 5948, chance = 80000 }, -- red dragon leather
	{ id = 5882, chance = 80000 }, -- red dragon scale
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 5889, chance = 80000 }, -- piece of draconian steel
	{ id = 5887, chance = 80000 }, -- piece of royal steel
	{ id = 8021, chance = 80000 }, -- modified crossbow
	{ id = 8074, chance = 80000 }, -- spellbook of mind control
	{ id = 10391, chance = 1000 }, -- drachaku
	{ id = 11688, chance = 1000 }, -- shield of corruption
	{ id = 3400, chance = 260 }, -- dragon scale helmet
	{ id = 3422, chance = 260 }, -- great shield
	{ id = 11692, chance = 260 }, -- snake gods sceptre
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 3386, chance = 80000 }, -- dragon scale mail
	{ id = 8895, chance = 80000 }, -- rusted armor
	{ id = 8896, chance = 80000 }, -- slightly rusted armor
	{ id = 3036, chance = 80000 }, -- violet gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 112, attack = 85 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -110, maxDamage = -495, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -110, maxDamage = -495, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -110, maxDamage = -495, radius = 8, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "charged energy elemental electrify", interval = 2000, chance = 15, minDamage = -1100, maxDamage = -1100, radius = 5, effect = CONST_ME_YELLOWENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 4, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 4, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -710, maxDamage = -895, length = 9, spread = 3, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 64,
	armor = 52,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 450, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
