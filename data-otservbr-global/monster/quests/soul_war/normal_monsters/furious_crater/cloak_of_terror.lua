local mType = Game.createMonsterType("Cloak of Terror")
local monster = {}

monster.description = "a cloak of terror"
monster.experience = 19700
monster.outfit = {
	lookType = 1295,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1928
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Furious Crater.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
	"CloakOfTerrorHealthLoss",
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "undead"
monster.corpse = 33801
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
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
	{ text = "Power up!", yell = false },
	{ text = "Shocked to meet you.", yell = false },
	{ text = "You should be more positive!", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 56000 }, -- Crystal Coin
	{ id = 7643, chance = 14800, maxCount = 6 }, -- Ultimate Health Potion
	{ id = 9058, chance = 12000 }, -- Gold Ingot
	{ id = 33934, chance = 5600 }, -- Telescope Eye
	{ id = 8092, chance = 4700 }, -- Wand of Starstorm
	{ id = 3036, chance = 4100 }, -- Violet Gem
	{ id = 3071, chance = 3500 }, -- Wand of Inferno
	{ id = 16096, chance = 3200 }, -- Wand of Defiance
	{ id = 33935, chance = 3000 }, -- Crown (Plant)
	{ id = 3038, chance = 2900 }, -- Green Gem
	{ id = 8094, chance = 2700 }, -- Wand of Voodoo
	{ id = 3041, chance = 2500 }, -- Blue Gem
	{ id = 828, chance = 1500 }, -- Lightning Headband
	{ id = 34023, chance = 780 }, -- Brooch of Embracement
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000 },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -1100, maxDamage = -1350, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -1150, maxDamage = -1300, range = 7, radius = 4, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -1000, maxDamage = -1300, range = 7, shootEffect = CONST_ANI_SPECTRALBOLT, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 2000, chance = 24, type = COMBAT_HOLYDAMAGE, minDamage = -800, maxDamage = -1200, range = 7, radius = 3, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_YELLOW_ENERGY_SPARK, target = true },
	{ name = "destroy magic walls", interval = 1000, chance = 30 },
}

monster.defenses = {
	defense = 107,
	armor = 107,
	mitigation = 3.19,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 60 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval)
	monster:tryTeleportToPlayer("I am your terror!")
end

mType:register(monster)
