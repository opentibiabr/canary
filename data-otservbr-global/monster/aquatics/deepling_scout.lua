local mType = Game.createMonsterType("Deepling Scout")
local monster = {}

monster.description = "a deepling scout"
monster.experience = 160
monster.outfit = {
	lookType = 413,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 734
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Fiehonja, Sunken Mines near Dwarf Mines.",
}

monster.health = 240
monster.maxHealth = 240
monster.race = "blood"
monster.corpse = 12684
monster.speed = 65
monster.manaCost = 0

monster.faction = FACTION_DEEPLING
monster.enemyFactions = { FACTION_PLAYER, FACTION_DEATHLING }

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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 50,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Njaaarh!!", yell = false },
	{ text = "Begjone, intrjuder!!", yell = false },
	{ text = "Djon't djare stjare injo the eyes of the djeep!", yell = false },
	{ text = "Ljeave this sjacred pljace while you cjan", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 75960, maxCount = 50 }, -- Gold Coin
	{ id = 3347, chance = 15000, maxCount = 3 }, -- Hunting Spear
	{ id = 3052, chance = 2020 }, -- Life Ring
	{ id = 8895, chance = 960 }, -- Rusted Armor
	{ id = 12683, chance = 480 }, -- Heavy Trident
	{ id = 12730, chance = 300 }, -- Eye of a Deepling
	{ id = 5895, chance = 300 }, -- Fish Fin
	{ id = 9016, chance = 110 }, -- Flask of Rust Remover
	{ id = 3032, chance = 120 }, -- Small Emerald
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -105, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DROWNDAMAGE, minDamage = 0, maxDamage = -110, range = 7, shootEffect = CONST_ANI_SPEAR, effect = CONST_ME_LOSEENERGY, target = true },
}

monster.defenses = {
	defense = 10,
	armor = 7,
	mitigation = 0.56,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
