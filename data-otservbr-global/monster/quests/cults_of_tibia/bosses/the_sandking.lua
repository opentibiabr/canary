local mType = Game.createMonsterType("The Sandking")
local monster = {}

monster.description = "The Sandking"
monster.experience = 0
monster.outfit = {
	lookType = 1013,
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
	bossRaceId = 1444,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "venom"
monster.corpse = 25866
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 30,
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
	canPushCreatures = false,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "CRRRK!", yell = true },
}

monster.loot = {
	{ name = "small amethyst", chance = 21000, maxCount = 10 },
	{ name = "small emerald", chance = 19000, maxCount = 10 },
	{ id = 3039, chance = 12000 }, -- red gem
	{ name = "platinum coin", chance = 68299, maxCount = 30 },
	{ name = "gold coin", chance = 100000, maxCount = 200 },
	{ name = "small diamond", chance = 21000, maxCount = 10 },
	{ name = "green gem", chance = 12000 },
	{ name = "luminous orb", chance = 35000 },
	{ name = "great mana potion", chance = 31230, maxCount = 10 },
	{ name = "ultimate health potion", chance = 28230, maxCount = 10 },
	{ name = "cobra crown", chance = 400 },
	{ name = "silver token", chance = 2500 },
	{ name = "gold token", chance = 1532 },
	{ name = "small topaz", chance = 11520, maxCount = 10 },
	{ name = "blue gem", chance = 21892 },
	{ name = "yellow gem", chance = 29460 },
	{ name = "magic sulphur", chance = 18920 },
	{ id = 7440, chance = 2000 }, -- mastermind potion
	{ id = 20062, chance = 12000, maxCount = 2 }, -- cluster of solace
	{ name = "hailstorm rod", chance = 3470 },
	{ id = 3036, chance = 1000 }, -- violet gem
	{ id = 3098, chance = 20000 }, -- ring of healing
	{ id = 3030, chance = 7360, maxCount = 10 }, -- small ruby
	{ id = 281, chance = 28540 }, -- giant shimmering pearl (green)
	{ name = "skull staff", chance = 13790 },
	{ name = "grasshopper legs", chance = 13790 },
	{ name = "huge chunk of crude iron", chance = 10000, maxCount = 2 },
	{ id = 7404, chance = 430 }, -- assassin dagger
	{ name = "runed sword", chance = 6666 },
	{ name = "djinn blade", chance = 200 },
	{ id = 16121, chance = 10000, maxCount = 3 }, -- green crystal shard
	{ id = 16120, chance = 10000, maxCount = 3 }, -- violet crystal shard
	{ id = 16119, chance = 10000, maxCount = 3 }, -- blue crystal shard
	{ id = 7642, chance = 4800 }, -- great spirit potion
	{ id = 16161, chance = 7030 }, -- crystalline axe
	{ id = 3341, chance = 200 }, -- arcane staff
	{ name = "heart of the mountain", chance = 400 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -500, range = 4, radius = 4, effect = CONST_ME_STONES, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -650, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
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
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
