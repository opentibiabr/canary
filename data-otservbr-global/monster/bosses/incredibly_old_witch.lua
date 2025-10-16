local mType = Game.createMonsterType("Incredibly Old Witch")
local monster = {}

monster.description = "an incredibly old witch"
monster.experience = 0
monster.outfit = {
	lookType = 54,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 620
monster.maxHealth = 620
monster.race = "blood"
monster.corpse = 6081
monster.speed = 90
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 100,
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
	{ text = "Stupid people!", yell = false },
	{ text = "Everyone is so stupid!", yell = false },
	{ text = "Feel the wrath of the witch!", yell = false },
	{ text = "Oh how you will regret to have disturbed me!", yell = false },
	{ text = "I will teach them all to leave me alone!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "outfit", interval = 4000, chance = 12, range = 7, radius = 4, effect = CONST_ME_MAGIC_BLUE, target = true, duration = 2000, outfitMonster = "rat" },
	{ name = "outfit", interval = 4000, chance = 12, range = 7, radius = 4, effect = CONST_ME_MAGIC_BLUE, target = true, duration = 2000, outfitMonster = "chicken" },
	{ name = "outfit", interval = 4000, chance = 12, range = 7, radius = 4, effect = CONST_ME_MAGIC_BLUE, target = true, duration = 2000, outfitMonster = "green frog" },
	{ name = "outfit", interval = 4000, chance = 12, range = 7, radius = 4, effect = CONST_ME_MAGIC_BLUE, target = true, duration = 2000, outfitMonster = "bug" },
	{ name = "outfit", interval = 4000, chance = 12, range = 7, radius = 4, effect = CONST_ME_MAGIC_BLUE, target = true, duration = 2000, outfitMonster = "pig" },
	{ name = "outfit", interval = 4000, chance = 12, range = 7, radius = 4, effect = CONST_ME_MAGIC_BLUE, target = true, duration = 2000, outfitMonster = "kongra" },
	{ name = "outfit", interval = 4000, chance = 12, range = 7, radius = 4, effect = CONST_ME_MAGIC_BLUE, target = true, duration = 2000, outfitMonster = "dog" },
	{ name = "outfit", interval = 4000, chance = 12, range = 7, radius = 4, effect = CONST_ME_MAGIC_BLUE, target = true, duration = 2000, outfitMonster = "skunk" },
	{ name = "outfit", interval = 4000, chance = 12, range = 7, radius = 4, effect = CONST_ME_MAGIC_BLUE, target = true, duration = 2000, outfitMonster = "donkey" },
}

monster.defenses = {
	defense = 5,
	armor = 10,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
