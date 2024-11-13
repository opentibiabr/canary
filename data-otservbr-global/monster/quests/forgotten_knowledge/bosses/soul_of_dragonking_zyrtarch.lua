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
	{ id = 22721, chance = 100000 }, -- gold token
	{ id = 22516, chance = 100000 }, -- silver token
	{ id = 3031, chance = 97000, maxCount = 100 }, -- gold coin
	{ id = 3031, chance = 97000, maxCount = 100 }, -- gold coin
	{ id = 3037, chance = 1000 }, -- yellow gem
	{ id = 5882, chance = 5000 }, -- red dragon scale
	{ id = 5889, chance = 500 }, -- piece of draconian steel
	{ id = 9067, chance = 500 }, -- crystal of power
	{ id = 11688, chance = 300 }, -- shield of corruption
	{ id = 9057, chance = 3000, maxCount = 5 }, -- small topaz
	{ id = 3032, chance = 3000, maxCount = 5 }, -- small emerald
	{ id = 9058, chance = 500 }, -- gold ingot
	{ id = 10391, chance = 100 }, -- drachaku
	{ id = 3033, chance = 3000, maxCount = 5 }, -- small amethyst
	{ id = 8021, chance = 500 }, -- modified crossbow
	{ id = 3041, chance = 1000 }, -- blue gem
	{ id = 7642, chance = 3000, maxCount = 3 }, -- great spirit potion
	{ id = 3400, chance = 15, unique = true }, -- dragon scale helmet
	{ id = 3039, chance = 1000 }, -- red gem
	{ id = 16120, chance = 3000, maxCount = 5 }, -- violet crystal shard
	{ id = 16121, chance = 3000, maxCount = 5 }, -- green crystal shard
	{ id = 5887, chance = 500 }, -- piece of royal steel
	{ id = 238, chance = 3000, maxCount = 3 }, -- great mana potion
	{ id = 3038, chance = 1000 }, -- green gem
	{ id = 5948, chance = 5000 }, -- red dragon leather
	{ id = 5904, chance = 500 }, -- magic sulphur
	{ id = 24955, chance = 500, unique = true }, -- part of a rune
	{ id = 16119, chance = 3000, maxCount = 5 }, -- blue crystal shard
	{ id = 281, chance = 500 }, -- giant shimmering pearl (green)
	{ id = 7643, chance = 3000, maxCount = 3 }, -- ultimate health potion
	{ id = 8074, chance = 500 }, -- spellbook of mind control
	{ id = 11692, chance = 300, unique = true }, -- snake god's sceptre
	{ id = 3035, chance = 90000, maxCount = 6 }, -- platinum coin
	{ id = 3030, chance = 3000, maxCount = 5 }, -- small ruby
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
