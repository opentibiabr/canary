local mType = Game.createMonsterType("Ravenous Hunger")
local monster = {}

monster.description = "Ravenous Hunger"
monster.experience = 0
monster.outfit = {
	lookType = 556,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1427,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 100000
monster.maxHealth = 100000
monster.race = "blood"
monster.corpse = 6323
monster.speed = 140
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
	staticAttackChance = 95,
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
	maxSummons = 4,
	summons = {
		{ name = "Mutated Bat", chance = 100, interval = 2000, count = 1 },
		{ name = "Mutated Bat", chance = 100, interval = 2000, count = 1 },
		{ name = "Mutated Bat", chance = 100, interval = 2000, count = 1 },
		{ name = "Mutated Bat", chance = 100, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "SU-*burp* SUFFEEER!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 3028, chance = 80000, maxCount = 10 }, -- small diamond
	{ id = 3029, chance = 80000, maxCount = 10 }, -- small sapphire
	{ id = 3032, chance = 80000, maxCount = 10 }, -- small emerald
	{ id = 7643, chance = 80000, maxCount = 5 }, -- ultimate health potion
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 238, chance = 80000, maxCount = 5 }, -- great mana potion
	{ id = 23535, chance = 80000, maxCount = 5 }, -- energy bar
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 21981, chance = 80000 }, -- oriental shoes
	{ id = 11652, chance = 80000 }, -- broken key ring
	{ id = 25743, chance = 80000 }, -- bed of nails
	{ id = 25744, chance = 80000 }, -- torn shirt
	{ id = 16117, chance = 80000 }, -- muck rod
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 25742, chance = 80000 }, -- fig leaf
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 9302, chance = 80000 }, -- sacred tree amulet
	{ id = 11454, chance = 80000 }, -- luminous orb
	{ id = 11674, chance = 80000 }, -- cobra crown
	{ id = 3575, chance = 80000 }, -- wood cape
	{ id = 25699, chance = 80000 }, -- wooden spellbook
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 3401, chance = 80000 }, -- elven legs
	{ id = 3399, chance = 80000 }, -- elven mail
	{ id = 3033, chance = 80000 }, -- small amethyst
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 811, chance = 80000 }, -- terra mantle
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 10451, chance = 80000 }, -- jade hat
	{ id = 813, chance = 80000 }, -- terra boots
	{ id = 7463, chance = 80000 }, -- mammoth fur cape
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3079, chance = 80000 }, -- boots of haste
	{ id = 8050, chance = 80000 }, -- crystalline armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
}

monster.defenses = {
	defense = 50,
	armor = 35,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
