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
	{ name = "platinum coin", chance = 100000, maxCount = 9 },
	{ name = "knife", chance = 23000 },
	{ name = "cobra crest", chance = 15370 },
	{ id = 3307, chance = 16000 }, -- scimitar
	{ name = "carlin sword", chance = 4470 },
	{ name = "red crystal fragment", chance = 760 },
	{ name = "opal", chance = 31000, maxCount = 5 },
	{ name = "machete", chance = 5250 },
	{ name = "heavy machete", chance = 8040 },
	{ name = "green crystal shard", chance = 6970 },
	{ name = "green crystal fragment", chance = 3190 },
	{ name = "small emerald", chance = 27400, maxCount = 3 },
	{ name = "protection amulet", chance = 14000 },
	{ name = "bone sword", chance = 9080 },
	{ name = "gold ingot", chance = 4640 },
	{ name = "soul orb", chance = 1970 },

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "wave t", interval = 2000, chance = 10, minDamage = -300, maxDamage = -380, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -280, maxDamage = -400, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -400, length = 5, spread = 3, effect = CONST_ME_BLOCKHIT, target = false },
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

mType:register(monster)
