local mType = Game.createMonsterType("Cobra Assassin")
local monster = {}

monster.description = "a cobra assassin"
monster.experience = 6980
monster.outfit = {
	lookType = 1217,
	lookHead = 2,
	lookBody = 2,
	lookLegs = 77,
	lookFeet = 19,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1775
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Cobra Bastion.",
}

monster.health = 8200
monster.maxHealth = 8200
monster.race = "blood"
monster.corpse = 31547
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = false,
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
	{ text = "Hey, maybe you want to strike a deal... no?", yell = false },
	{ text = "Stand and deliver! Your money... AND your life actually!", yell = false },
	{ text = "You will not leave this place breathing!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 72000, maxCount = 9 }, -- Platinum Coin
	{ id = 22194, chance = 32000, maxCount = 5 }, -- Opal
	{ id = 3032, chance = 28000, maxCount = 3 }, -- Small Emerald
	{ id = 3291, chance = 23000 }, -- Knife
	{ id = 3307, chance = 16800 }, -- Scimitar
	{ id = 31678, chance = 14800 }, -- Cobra Crest
	{ id = 3084, chance = 13800 }, -- Protection Amulet
	{ id = 3338, chance = 8900 }, -- Bone Sword
	{ id = 3330, chance = 7800 }, -- Heavy Machete
	{ id = 16121, chance = 6600 }, -- Green Crystal Shard
	{ id = 3308, chance = 5300 }, -- Machete
	{ id = 9058, chance = 4500 }, -- Gold Ingot
	{ id = 3283, chance = 4500 }, -- Carlin Sword
	{ id = 16127, chance = 3300 }, -- Green Crystal Fragment
	{ id = 5944, chance = 2000 }, -- Soul Orb
	{ id = 16126, chance = 870 }, -- Red Crystal Fragment
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "wave t", interval = 2000, chance = 10, minDamage = -300, maxDamage = -380, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -500, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -500, length = 5, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.defenses = {
	defense = 81,
	armor = 81,
	mitigation = 2.22,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
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

mType.onSpawn = function(monster)
	monster:handleCobraOnSpawn()
end

mType:register(monster)
