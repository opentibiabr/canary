local mType = Game.createMonsterType("Magma Bubble")
local monster = {}

monster.description = "magma bubble"
monster.experience = 80000
monster.outfit = {
	lookType = 1413,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"MagmaBubbleDeath",
	"ThePrimeOrdealBossDeath",
}

monster.bosstiary = {
	bossRaceId = 2242,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 450000
monster.maxHealth = 450000
monster.race = "undead"
monster.corpse = 36847
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 39544, chance = 1000 }, -- Firefighting Axe
	{ id = 23373, chance = 53225 }, -- Ultimate Mana Potion
	{ id = 3043, chance = 100000 }, -- Crystal Coin
	{ id = 7440, chance = 29032 }, -- Mastermind Potion
	{ id = 7443, chance = 25806 }, -- Bullseye Potion
	{ id = 30060, chance = 25806 }, -- Giant Emerald
	{ id = 32623, chance = 9677 }, -- Giant Topaz
	{ id = 7643, chance = 27419 }, -- Ultimate Health Potion
	{ id = 7439, chance = 41935 }, -- Berserk Potion
	{ id = 23374, chance = 19354 }, -- Ultimate Spirit Potion
	{ id = 30061, chance = 25806 }, -- Giant Sapphire
	{ id = 39149, chance = 1000 }, -- Alicorn Headguard
	{ id = 39150, chance = 1000 }, -- Alicorn Quiver
	{ id = 39180, chance = 1000 }, -- Charged Alicorn Ring
	{ id = 39153, chance = 1000 }, -- Arboreal Crown
	{ id = 39186, chance = 1000 }, -- Charged Arboreal Ring
	{ id = 39154, chance = 1000 }, -- Arboreal Tome
	{ id = 39152, chance = 1000 }, -- Arcanomancer Folio
	{ id = 39151, chance = 1000 }, -- Arcanomancer Regalia
	{ id = 39183, chance = 1000 }, -- Charged Arcanomancer Sigil
	{ id = 39040, chance = 4838 }, -- Fiery Tear
	{ id = 39543, chance = 29032 }, -- Smoldering Eye
	{ id = 39147, chance = 1000 }, -- Spiritthorn Armor
	{ id = 39148, chance = 1000 }, -- Spiritthorn Helmet
	{ id = 39177, chance = 1000 }, -- Charged Spiritthorn Ring
	{ id = 39545, chance = 1000 }, -- Portable Flame
	{ id = 32622, chance = 32258 }, -- Giant Amethyst
	{ id = 50188, chance = 1000 }, -- Ethereal Coned Hat
	{ id = 50147, chance = 1000 }, -- Charged Ethereal Ring
	{ id = 49271, chance = 5128, maxCount = 6 }, -- Transcendence Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -275, maxDamage = -750 },
	{ name = "combat", interval = 2000, chance = 75, type = COMBAT_FIREDAMAGE, minDamage = -725, maxDamage = -1000, radius = 3, range = 8, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = true },
	{ name = "combat", interval = 3700, chance = 37, type = COMBAT_FIREDAMAGE, minDamage = -1700, maxDamage = -2750, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 3100, chance = 27, type = COMBAT_FIREDAMAGE, minDamage = -1000, maxDamage = -2000, range = 8, effect = CONST_ME_FIREAREA, shootEffect = CONST_ANI_FIRE, target = true },
}

monster.defenses = {
	defense = 65,
	armor = 0,
	mitigation = 2.0,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
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
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
