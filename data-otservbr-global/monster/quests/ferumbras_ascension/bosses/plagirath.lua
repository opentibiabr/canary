local mType = Game.createMonsterType("Plagirath")
local monster = {}

monster.description = "Plagirath"
monster.experience = 500000
monster.outfit = {
	lookType = 862,
	lookHead = 84,
	lookBody = 62,
	lookLegs = 60,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.bosstiary = {
	bossRaceId = 1199,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "venom"
monster.corpse = 22495
monster.speed = 160
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
	{ text = "I CAN SENSE YOUR BODY ROTTING!", yell = true },
	{ text = "WITHER AND DIE!", yell = true },
	{ text = "COME AND RECEIVE MY GIFTS!!", yell = true },
	{ text = "DEATH AND DECAY!", yell = true },
}

monster.loot = {
	{ id = 22516, chance = 1000000 }, -- silver token
	{ id = 10389, chance = 3000 }, -- sai
	{ id = 16117, chance = 1820 }, -- muck rod
	{ id = 16125, chance = 23000, maxCount = 6 }, -- cyan crystal fragment
	{ id = 16126, chance = 23000, maxCount = 6 }, -- red crystal fragment
	{ id = 16127, chance = 23000, maxCount = 6 }, -- green crystal fragment
	{ id = 3026, chance = 12000, maxCount = 8 }, -- white pearl
	{ id = 3029, chance = 12000, maxCount = 9 }, -- small sapphire
	{ id = 3031, chance = 98000, maxCount = 200 }, -- gold coin
	{ id = 3033, chance = 10000, maxCount = 5 }, -- small amethyst
	{ id = 3035, chance = 8000, maxCount = 58 }, -- platinum coin
	{ id = 22727, chance = 800 }, -- rift lance
	{ id = 22759, chance = 500, unique = true }, -- plague bite
	{ id = 22866, chance = 800 }, -- rift bow
	{ id = 22867, chance = 800 }, -- rift crossbow
	{ id = 6499, chance = 11000 }, -- demonic essence
	{ id = 7386, chance = 5000 }, -- mercenary sword
	{ id = 281, chance = 14000, maxCount = 5 }, -- giant shimmering pearl (green)
	{ id = 282, chance = 14000, maxCount = 5 }, -- giant shimmering pearl (brown)
	{ id = 814, chance = 5000 }, -- terra amulet
	{ id = 7643, chance = 23000, maxCount = 15 }, -- ultimate health potion
	{ id = 8073, chance = 4000 }, -- spellbook of warding
	{ id = 9057, chance = 10000, maxCount = 8 }, -- small topaz
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1300, maxDamage = -2250 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -900, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, range = 4, radius = 4, effect = CONST_ME_POFF, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -1000, maxDamage = -1200, length = 10, spread = 3, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -1500, maxDamage = -1900, length = 10, spread = 3, effect = CONST_ME_POFF, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000 },
	{ name = "plagirath bog", interval = 20000, chance = 25, target = false },
}

monster.defenses = {
	defense = 125,
	armor = 125,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 3000, maxDamage = 4000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 30, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
	{ name = "plagirath summon", interval = 2000, chance = 15, target = false },
	{ name = "plagirath heal", interval = 2000, chance = 17, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
