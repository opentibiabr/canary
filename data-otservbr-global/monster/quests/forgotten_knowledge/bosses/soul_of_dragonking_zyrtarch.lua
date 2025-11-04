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
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 25 }, -- Platinum Coin
	{ id = 16119, chance = 63513, maxCount = 3 }, -- Blue Crystal Shard
	{ id = 16121, chance = 60135, maxCount = 3 }, -- Green Crystal Shard
	{ id = 16120, chance = 62162, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 238, chance = 54054, maxCount = 10 }, -- Great Mana Potion
	{ id = 7642, chance = 54054, maxCount = 10 }, -- Great Spirit Potion
	{ id = 7643, chance = 52702, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 3033, chance = 18243, maxCount = 10 }, -- Small Amethyst
	{ id = 3028, chance = 21621, maxCount = 10 }, -- Small Diamond
	{ id = 3032, chance = 16216, maxCount = 10 }, -- Small Emerald
	{ id = 3030, chance = 22297, maxCount = 10 }, -- Small Ruby
	{ id = 9057, chance = 20945, maxCount = 10 }, -- Small Topaz
	{ id = 3037, chance = 18243 }, -- Yellow Gem
	{ id = 3041, chance = 21621 }, -- Blue Gem
	{ id = 3038, chance = 16216 }, -- Green Gem
	{ id = 3039, chance = 27027 }, -- Red Gem
	{ id = 11652, chance = 15540 }, -- Broken Key Ring
	{ id = 9067, chance = 16216 }, -- Crystal of Power
	{ id = 24967, chance = 1834 }, -- Dragon Crown
	{ id = 24938, chance = 1000 }, -- Dragon Tongue
	{ id = 7430, chance = 6756 }, -- Dragonbone Staff
	{ id = 4033, chance = 1834 }, -- Draken Boots
	{ id = 10388, chance = 5504 }, -- Drakinata
	{ id = 281, chance = 11486 }, -- Giant Shimmering Pearl
	{ id = 9058, chance = 19594 }, -- Gold Ingot
	{ id = 24968, chance = 4587 }, -- Golden Talon
	{ id = 5948, chance = 100000 }, -- Red Dragon Leather
	{ id = 5882, chance = 100000 }, -- Red Dragon Scale
	{ id = 5904, chance = 72297 }, -- Magic Sulphur
	{ id = 5889, chance = 79729 }, -- Piece of Draconian Steel
	{ id = 5887, chance = 4054 }, -- Piece of Royal Steel
	{ id = 8021, chance = 8108 }, -- Modified Crossbow
	{ id = 8074, chance = 14864 }, -- Spellbook of Mind Control
	{ id = 10391, chance = 4729 }, -- Drachaku
	{ id = 11688, chance = 1000 }, -- Shield of Corruption
	{ id = 3400, chance = 2884 }, -- Dragon Scale Helmet
	{ id = 3422, chance = 1000 }, -- Great Shield
	{ id = 11692, chance = 3614 }, -- Snake God's Sceptre
	{ id = 22516, chance = 22297 }, -- Silver Token
	{ id = 22721, chance = 27027 }, -- Gold Token
	{ id = 24955, chance = 2702 }, -- Part of a Rune (Two)
	{ id = 3386, chance = 4545 }, -- Dragon Scale Mail
	{ id = 8895, chance = 14189 }, -- Rusted Armor
	{ id = 8896, chance = 10135 }, -- Slightly Rusted Armor
	{ id = 3036, chance = 6730 }, -- Violet Gem
	{ id = 50259, chance = 6153 }, -- Zaoan Monk Robe
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
