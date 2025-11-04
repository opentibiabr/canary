local mType = Game.createMonsterType("The Enraged Thorn Knight")
local monster = {}

monster.description = "the enraged Thorn Knight"
monster.experience = 30000
monster.outfit = {
	lookType = 512,
	lookHead = 81,
	lookBody = 121,
	lookLegs = 121,
	lookFeet = 121,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
	"HealthForgotten",
}

monster.bosstiary = {
	bossRaceId = 1297,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 90000
monster.maxHealth = 90000
monster.race = "blood"
monster.corpse = 111
monster.speed = 175
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
	runHealth = 15,
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
	{ text = "You've killed my only friend!", yell = false },
	{ text = "You will pay for this!", yell = false },
	{ text = "NOOOOO!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 99328, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 99328, maxCount = 30 }, -- Platinum Coin
	{ id = 16119, chance = 66442, maxCount = 3 }, -- Blue Crystal Shard
	{ id = 16121, chance = 67114, maxCount = 3 }, -- Green Crystal Shard
	{ id = 16120, chance = 71812, maxCount = 3 }, -- Violet Crystal Shard
	{ id = 238, chance = 57046, maxCount = 10 }, -- Great Mana Potion
	{ id = 7642, chance = 53691, maxCount = 10 }, -- Great Spirit Potion
	{ id = 7643, chance = 56375, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 5887, chance = 3333, maxCount = 2 }, -- Piece of Royal Steel
	{ id = 3033, chance = 24161, maxCount = 10 }, -- Small Amethyst
	{ id = 3028, chance = 19463, maxCount = 10 }, -- Small Diamond
	{ id = 3032, chance = 20805, maxCount = 10 }, -- Small Emerald
	{ id = 3030, chance = 16107, maxCount = 10 }, -- Small Ruby
	{ id = 9057, chance = 14093, maxCount = 10 }, -- Small Topaz
	{ id = 7439, chance = 53020 }, -- Berserk Potion
	{ id = 7443, chance = 46979 }, -- Bullseye Potion
	{ id = 3041, chance = 20134 }, -- Blue Gem
	{ id = 3038, chance = 17449 }, -- Green Gem
	{ id = 3039, chance = 21476 }, -- Red Gem
	{ id = 3037, chance = 14765 }, -- Yellow Gem
	{ id = 3295, chance = 1000 }, -- Bright Sword
	{ id = 6499, chance = 20805 }, -- Demonic Essence
	{ id = 7453, chance = 2631 }, -- Executioner
	{ id = 24966, chance = 2127 }, -- Forbidden Fruit
	{ id = 281, chance = 13422 }, -- Giant Shimmering Pearl
	{ id = 5014, chance = 2500 }, -- Mandrake
	{ id = 3436, chance = 8724 }, -- Medusa Shield
	{ id = 3098, chance = 83146 }, -- Ring of Healing
	{ id = 9302, chance = 35570 }, -- Sacred Tree Amulet
	{ id = 5875, chance = 3947 }, -- Sniper Gloves
	{ id = 5884, chance = 7382 }, -- Spirit Container
	{ id = 8052, chance = 4697 }, -- Swamplair Armor
	{ id = 20203, chance = 36912 }, -- Trapped Bad Dream Monster
	{ id = 24965, chance = 1960 }, -- Thorn Seed
	{ id = 24954, chance = 3355 }, -- Part of a Rune (One)
	{ id = 22516, chance = 20134 }, -- Silver Token
	{ id = 22721, chance = 27516 }, -- Gold Token
	{ id = 5910, chance = 20805 }, -- Green Piece of Cloth
	{ id = 7407, chance = 6040 }, -- Haunted Blade
	{ id = 3318, chance = 100000 }, -- Knight Axe
	{ id = 3392, chance = 6711 }, -- Royal Helmet
	{ id = 8895, chance = 19463 }, -- Rusted Armor
	{ id = 7452, chance = 7382 }, -- Spiked Squelcher
	{ id = 5885, chance = 3333 }, -- Flask of Warrior's Sweat
	{ id = 3036, chance = 7382 }, -- Violet Gem
	{ id = 6553, chance = 1960 }, -- Ruthless Axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -600, maxDamage = -1000 },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -700, length = 4, spread = 0, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_MANADRAIN, minDamage = -1400, maxDamage = -1700, length = 9, spread = 0, effect = CONST_ME_CARNIPHILA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -700, length = 9, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -250, radius = 10, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 1550, maxDamage = 2550, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 12, speedChange = 620, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

monster.heals = {
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

mType:register(monster)
