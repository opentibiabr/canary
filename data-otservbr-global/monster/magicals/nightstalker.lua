local mType = Game.createMonsterType("Nightstalker")
local monster = {}

monster.description = "a Nightstalker"
monster.experience = 500
monster.outfit = {
	lookType = 320,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 520
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Cemetery Quarter, Vengoth Castle, Vandura Mountain, Robson Isle.",
}

monster.health = 700
monster.maxHealth = 700
monster.race = "undead"
monster.corpse = 9001
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 0,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The sunlight is so depressing.", yell = false },
	{ text = "Come with me, my child.", yell = false },
	{ text = "I've been in the shadow under your bed last night.", yell = false },
	{ text = "You never know what hides in the night.", yell = false },
	{ text = "I remember your face - and I know where you sleep.", yell = false },
	{ text = "Only the sweetest and cruelest dreams for you, my love.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 89960, maxCount = 110 }, -- Gold Coin
	{ id = 237, chance = 1500 }, -- Strong Mana Potion
	{ id = 3740, chance = 5031 }, -- Shadow Herb
	{ id = 3007, chance = 846 }, -- Crystal Ring
	{ id = 3084, chance = 941 }, -- Protection Amulet
	{ id = 8042, chance = 585 }, -- Spirit Cloak
	{ id = 3055, chance = 162 }, -- Platinum Amulet
	{ id = 3079, chance = 86 }, -- Boots of Haste
	{ id = 7407, chance = 208 }, -- Haunted Blade
	{ id = 7427, chance = 52 }, -- Chaos Mace
	{ id = 9028, chance = 145 }, -- Crystal of Balance
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -90, condition = { type = CONDITION_POISON, totalDamage = 80, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -60, maxDamage = -170, range = 7, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "nightstalker paralyze", interval = 2000, chance = 15, range = 7, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 40,
	mitigation = 1.18,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 240, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_YELLOW_RINGS },
	{ name = "outfit", interval = 5000, chance = 10, target = false, duration = 4000, outfitMonster = "nightstalker" },
	{ name = "outfit", interval = 5000, chance = 10, target = false, duration = 4000, outfitMonster = "werewolf" },
	{ name = "outfit", interval = 5000, chance = 10, target = false, duration = 4000, outfitMonster = "the count" },
	{ name = "outfit", interval = 5000, chance = 10, target = false, duration = 4000, outfitMonster = "grim reaper" },
	{ name = "outfit", interval = 5000, chance = 10, target = false, duration = 4000, outfitMonster = "tarantula" },
	{ name = "outfit", interval = 5000, chance = 1, target = false, duration = 4000, outfitMonster = "ferumbras" },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
