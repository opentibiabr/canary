local mType = Game.createMonsterType("Orc Cult Priest")
local monster = {}

monster.description = "an orc cult priest"
monster.experience = 1000
monster.outfit = {
	lookType = 6,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1504
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "Edron Orc Cave.",
}

monster.health = 1300
monster.maxHealth = 1300
monster.race = "blood"
monster.corpse = 5978
monster.speed = 70
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
	{ text = "We will crush all oposition!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 1816 }, -- Gold Coin
	{ id = 11478, chance = 13690 }, -- Shamanic Hood
	{ id = 236, chance = 15250 }, -- Strong Health Potion
	{ id = 9639, chance = 10200 }, -- Cultish Robe
	{ id = 5910, chance = 10820 }, -- Green Piece of Cloth
	{ id = 3030, chance = 12210, maxCount = 6 }, -- Small Ruby
	{ id = 3078, chance = 9440 }, -- Mysterious Fetish
	{ id = 11479, chance = 8610 }, -- Orc Leather
	{ id = 11452, chance = 8680 }, -- Broken Shamanic Staff
	{ id = 10196, chance = 5260 }, -- Orc Tooth
	{ id = 3027, chance = 2660, maxCount = 2 }, -- Black Pearl
	{ id = 23986, chance = 1800 }, -- Heavy Old Tome
	{ id = 3072, chance = 860 }, -- Wand of Decay
	{ id = 7439, chance = 830 }, -- Berserk Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -310, range = 7, shootEffect = CONST_ANI_ENERGYBALL, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -250, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "outfit", interval = 4000, chance = 15, target = true, duration = 30000, outfitMonster = "orc warlord" },
	{ name = "outfit", interval = 4000, chance = 10, target = true, duration = 30000, outfitMonster = "orc shaman" },
	{ name = "outfit", interval = 4000, chance = 20, target = true, duration = 30000, outfitMonster = "orc" },
}

monster.defenses = {
	defense = 27,
	armor = 27,
	mitigation = 1.18,
	{ name = "heal monster", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
