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
	{ name = "crystal coin", chance = 100000, maxCount = 60 },
	{ name = "ultimate mana potion", chance = 32653, maxCount = 14 },
	{ name = "ultimate health potion", chance = 30612, maxCount = 14 },
	{ name = "bullseye potion", chance = 24490, maxCount = 5 },
	{ name = "berserk potion", chance = 22449, maxCount = 5 },
	{ name = "mastermind potion", chance = 18367, maxCount = 5 },
	{ name = "giant amethyst", chance = 6122 },
	{ name = "giant ruby", chance = 4082 },
	{ name = "giant emerald", chance = 4082 },
	{ name = "giant sapphire", chance = 2041 },
	{ name = "giant topaz", chance = 2041 },
	{ name = "fiery tear", chance = 1000 },
	{ name = "arboreal tome", chance = 250 },
	{ name = "arboreal crown", chance = 250 },
	{ name = "spiritthorn armor", id = 39147, chance = 250 },
	{ name = "spiritthorn helmet", id = 39148, chance = 250 },
	{ name = "alicorn headguard", chance = 250 },
	{ name = "alicorn quiver", chance = 250 },
	{ name = "arcanomancer regalia", chance = 250 },
	{ name = "arcanomancer folio", chance = 250 },
	{ id = 39183, chance = 250 }, -- name = "charged arcanomancer sigil"
	{ id = 39186, chance = 250 }, -- name = "charged arboreal ring"
	{ id = 39180, chance = 250 }, -- name = "charged alicorn ring"
	{ id = 39177, chance = 250 }, -- name = "charged spiritthorn ring"
	{ name = "portable flame", chance = 250 },
	{ name = "firefighting axe", chance = 250 },
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
