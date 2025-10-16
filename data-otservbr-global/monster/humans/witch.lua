local mType = Game.createMonsterType("Witch")
local monster = {}

monster.description = "a witch"
monster.experience = 120
monster.outfit = {
	lookType = 54,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 54
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Vandura, west of the Dwarf Mines in a small house, Amazon Tower north of Carlin, \z
		Triangle Tower, Temple of Xayepocax, Green Claw Swamp and Amazon Camp (Venore), \z
		Dark Cathedral (2 levels underground), Goroma Volcano (underground), west from Necromant House, \z
		Mammoth Shearing Factory, Trade Quarter in Yalahar, The Witches' Cliff (only accessible during a quest).",
}

monster.health = 300
monster.maxHealth = 300
monster.race = "blood"
monster.corpse = 18254
monster.speed = 102
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 30,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{ text = "Herba budinia ex!", yell = false },
	{ text = "Horax Pokti!", yell = false },
	{ text = "Hihihihi!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 40 }, -- gold coin
	{ id = 3598, chance = 80000, maxCount = 8 }, -- cookie
	{ id = 3736, chance = 23000 }, -- star herb
	{ id = 9652, chance = 23000 }, -- witch broom
	{ id = 5940, chance = 23000 }, -- wolf tooth chain
	{ id = 3552, chance = 5000 }, -- leather boots
	{ id = 3565, chance = 5000 }, -- cape
	{ id = 3083, chance = 5000 }, -- garlic necklace
	{ id = 3293, chance = 5000 }, -- sickle
	{ id = 3562, chance = 5000 }, -- coat
	{ id = 12548, chance = 1000 }, -- bag of apple slices
	{ id = 3069, chance = 1000 }, -- necrotic rod
	{ id = 3290, chance = 1000 }, -- silver dagger
	{ id = 9653, chance = 260 }, -- witch hat
	{ id = 10294, chance = 260 }, -- stuffed toad
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -20 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -30, maxDamage = -75, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "firefield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "outfit", interval = 2000, chance = 1, range = 5, target = true, duration = 2000, outfitMonster = "green frog" },
}

monster.defenses = {
	defense = 15,
	armor = 8,
	mitigation = 0.30,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
