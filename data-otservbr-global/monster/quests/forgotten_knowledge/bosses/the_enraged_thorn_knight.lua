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
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 16119, chance = 80000, maxCount = 3 }, -- blue crystal shard
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 238, chance = 80000, maxCount = 10 }, -- great mana potion
	{ id = 7642, chance = 80000, maxCount = 10 }, -- great spirit potion
	{ id = 7643, chance = 80000, maxCount = 5 }, -- ultimate health potion
	{ id = 5887, chance = 80000, maxCount = 2 }, -- piece of royal steel
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 10 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 10 }, -- small emerald
	{ id = 3030, chance = 80000, maxCount = 10 }, -- small ruby
	{ id = 9057, chance = 80000, maxCount = 10 }, -- small topaz
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 7443, chance = 80000 }, -- bullseye potion
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3295, chance = 80000 }, -- bright sword
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 7453, chance = 80000 }, -- executioner
	{ id = 24966, chance = 80000 }, -- forbidden fruit
	{ id = 5014, chance = 80000 }, -- mandrake
	{ id = 3436, chance = 80000 }, -- medusa shield
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 9302, chance = 80000 }, -- sacred tree amulet
	{ id = 5875, chance = 80000 }, -- sniper gloves
	{ id = 5884, chance = 80000 }, -- spirit container
	{ id = 8052, chance = 80000 }, -- swamplair armor
	{ id = 20203, chance = 80000 }, -- trapped bad dream monster
	{ id = 24965, chance = 1000 }, -- thorn seed
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 5910, chance = 80000 }, -- green piece of cloth
	{ id = 7407, chance = 80000 }, -- haunted blade
	{ id = 3318, chance = 80000 }, -- knight axe
	{ id = 3392, chance = 80000 }, -- royal helmet
	{ id = 8895, chance = 80000 }, -- rusted armor
	{ id = 7452, chance = 80000 }, -- spiked squelcher
	{ id = 5885, chance = 80000 }, -- flask of warriors sweat
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 6553, chance = 80000 }, -- ruthless axe
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
