local mType = Game.createMonsterType("Hellspawn")
local monster = {}

monster.description = "a hellspawn"
monster.experience = 2550
monster.outfit = {
	lookType = 322,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 519
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Magician Quarter, Vengoth, Deeper Banuta, Formorgar Minese, Chyllfroest, Oramond Dungeon, Asura Palace, Asura Vaults.",
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "fire"
monster.corpse = 9009
monster.speed = 172
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
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
	{ text = "Your fragile bones are like toothpicks to me.", yell = false },
	{ text = "You little weasel will not live to see another day.", yell = false },
	{ text = "I'm just a messenger of what's yet to come.", yell = false },
	{ text = "HRAAAAAAAAAAAAAAAARRRR!", yell = true },
	{ text = "I'm taking you down with me!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 95897, maxCount = 236 }, -- Gold Coin
	{ id = 239, chance = 37899 }, -- Great Health Potion
	{ id = 10304, chance = 19899 }, -- Hellspawn Tail
	{ id = 3413, chance = 9813 }, -- Battle Shield
	{ id = 3282, chance = 9544 }, -- Morning Star
	{ id = 7368, chance = 14529, maxCount = 2 }, -- Assassin Star
	{ id = 7643, chance = 10159 }, -- Ultimate Health Potion
	{ id = 6499, chance = 9493 }, -- Demonic Essence
	{ id = 3724, chance = 11627, maxCount = 2 }, -- Red Mushroom
	{ id = 9057, chance = 8973, maxCount = 3 }, -- Small Topaz
	{ id = 8895, chance = 2681 }, -- Rusted Armor
	{ id = 3371, chance = 2899 }, -- Knight Legs
	{ id = 3369, chance = 1912 }, -- Warrior Helmet
	{ id = 7452, chance = 821 }, -- Spiked Squelcher
	{ id = 7439, chance = 839 }, -- Berserk Potion
	{ id = 8896, chance = 283 }, -- Slightly Rusted Armor
	{ id = 9056, chance = 212 }, -- Black Skull (Item)
	{ id = 9035, chance = 127 }, -- Dracoyle Statue
	{ id = 7421, chance = 127 }, -- Onyx Flail
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -352 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -175, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = false },
	{ name = "hellspawn soulfire", interval = 2000, chance = 10, range = 5, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 44,
	mitigation = 1.32,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 120, maxDamage = 230, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 270, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
