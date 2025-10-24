local mType = Game.createMonsterType("Rootthing Amber Shaper")
local monster = {}

monster.description = "a rootthing amber shaper"
monster.experience = 12400
monster.outfit = {
	lookType = 1762,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2539
monster.Bestiary = {
	class = "Plant",
	race = BESTY_RACE_PLANT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Podzilla Stalk",
}

monster.health = 15000
monster.maxHealth = 15000
monster.race = "venom"
monster.corpse = 48402
monster.speed = 185
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	{ text = "KNARR!", yell = false },
	{ text = "RATTLE!", yell = false },
	{ text = "CROAK!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 1000, maxCount = 37 }, -- Platinum Coin
	{ id = 48413, chance = 8683 }, -- Amber Sickle
	{ id = 48510, chance = 7626 }, -- Demon Root
	{ id = 48511, chance = 7625 }, -- Resin Parasite
	{ id = 3043, chance = 1670 }, -- Crystal Coin
	{ id = 7426, chance = 1692 }, -- Amber Staff
	{ id = 25699, chance = 1908 }, -- Wooden Spellbook
	{ id = 5741, chance = 1000 }, -- Skull Helmet
	{ id = 7422, chance = 670 }, -- Jade Hammer
	{ id = 32624, chance = 421 }, -- Amber with a Bug
	{ id = 32625, chance = 1000 }, -- Amber with a Dragonfly
	{ id = 32626, chance = 1000 }, -- Amber (Item)
	{ id = 45652, chance = 1000 }, -- Preserved Pink Seed
	{ id = 45653, chance = 1000 }, -- Preserved Red Seed
	{ id = 45657, chance = 1000 }, -- Preserved Yellow Seed
	{ id = 48505, chance = 1000 }, -- Preserved Dark Seed
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -550, maxDamage = -750, effect = CONST_ME_SMALLPLANTS, target = true },
	{ name = "combat", interval = 2500, chance = 17, type = COMBAT_PHYSICALDAMAGE, minDamage = -600, maxDamage = -800, radius = 2, effect = CONST_ME_STONES, target = true },
	{ name = "rotthingshaper", interval = 2000, chance = 18, target = false },
	{ name = "poison chain", interval = 2000, chance = 15, minDamage = -600, maxDamage = -900 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.75,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 500, maxDamage = 800, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
