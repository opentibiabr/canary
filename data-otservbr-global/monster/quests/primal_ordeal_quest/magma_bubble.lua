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
	{ id = 39544, chance = 80000 }, -- firefighting axe
	{ id = 23373, chance = 80000 }, -- ultimate mana potion
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 7443, chance = 80000 }, -- bullseye potion
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 32623, chance = 80000 }, -- giant topaz
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 23374, chance = 80000 }, -- ultimate spirit potion
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 39149, chance = 80000 }, -- alicorn headguard
	{ id = 39150, chance = 80000 }, -- alicorn quiver
	{ id = 39181, chance = 80000 }, -- charged alicorn ring
	{ id = 39153, chance = 80000 }, -- arboreal crown
	{ id = 39187, chance = 80000 }, -- charged arboreal ring
	{ id = 39154, chance = 80000 }, -- arboreal tome
	{ id = 39152, chance = 80000 }, -- arcanomancer folio
	{ id = 39151, chance = 80000 }, -- arcanomancer regalia
	{ id = 39184, chance = 80000 }, -- charged arcanomancer sigil
	{ id = 39040, chance = 80000 }, -- fiery tear
	{ id = 39543, chance = 80000 }, -- smoldering eye
	{ id = 39147, chance = 80000 }, -- spiritthorn armor
	{ id = 39148, chance = 80000 }, -- spiritthorn helmet
	{ id = 39178, chance = 80000 }, -- charged spiritthorn ring
	{ id = 39545, chance = 80000 }, -- portable flame
	{ id = 32622, chance = 80000 }, -- giant amethyst
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
