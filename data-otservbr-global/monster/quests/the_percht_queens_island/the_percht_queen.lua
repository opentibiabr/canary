local mType = Game.createMonsterType("The Percht Queen")
local monster = {}

monster.description = "The Percht Queen"
monster.experience = 500
monster.outfit = {
	lookTypeEx = 30341, -- (frozen)30340 // lookTypeEx = 30341 (thawed)
}

monster.bosstiary = {
	bossRaceId = 1744,
	bossRace = RARITY_NEMESIS,
}

monster.health = 15000
monster.maxHealth = 15000
monster.race = "undead"
monster.corpse = 30272
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
	chance = 60,
}

monster.strategiesTarget = {
	nearest = 20,
	random = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = false,
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
}

monster.loot = {
	{ name = "piggy bank", chance = 80000 },
	{ name = "royal star", chance = 80000, maxCount = 100 },
	{ name = "platinum coin", chance = 80000, maxCount = 5 },
	{ name = "energy bar", chance = 75000 },
	{ name = "supreme health potion", chance = 65000, maxCount = 20 },
	{ name = "huge chunk of crude iron", chance = 64000 },
	{ name = "mysterious remains", chance = 63000 },
	{ name = "ultimate spirit potion", chance = 62000, maxCount = 20 },
	{ name = "ultimate mana potion", chance = 61000, maxCount = 20 },
	{ name = "bullseye potion", chance = 25500, maxCount = 10 },
	{ name = "berserk potion", chance = 23000, maxCount = 3 },
	{ id = 3039, chance = 22500 }, -- red gem
	{ name = "soul stone", chance = 224000 },
	{ id = 30275, chance = 300 }, -- crown of the percht queen fire
	{ id = 30276, chance = 250 }, -- crown of the percht queen ice
	{ name = "flames of the percht queen", chance = 1800 },
	{ name = "small ladybug", chance = 24980 },
	{ name = "gold ingot", chance = 22480 },
	{ name = "crystal coin", chance = 24890, maxCount = 2 },
	{ id = 281, chance = 21580 }, -- giant shimmering pearl (green)
	{ name = "skull staff", chance = 19850 },
	{ name = "magic sulphur", chance = 25480 },
	{ name = "percht queen's frozen heart", chance = 26800 },
	{ name = "percht skull", chance = 800 },
	{ id = 30277, chance = 25840 }, -- icicle
	{ name = "silver token", chance = 5480, maxCount = 2 },
	{ name = "percht handkerchief", chance = 5808 },
	{ name = "ring of the sky", chance = 5100 },
	{ id = 23529, chance = 8486 }, -- ring of blue plasma
	{ name = "ice hatchet", chance = 5485 },
	{ id = 23533, chance = 4858 }, -- ring of red plasma
	{ id = 23531, chance = 3485 }, -- ring of green plasma
	{ name = "yellow gem", chance = 5485 },
	{ name = "violet gem", chance = 6485 },
	{ id = 23544, chance = 7848 }, -- collar of red plasma
	{ id = 23543, chance = 5485 }, -- collar of green plasma
	{ name = "green gem", chance = 5485 },
	{ name = "blue gem", chance = 5845 },
	{ id = 23542, chance = 5158 }, -- collar of blue plasma
	{ name = "golden horseshoe", chance = 2510 },
	{ name = "abyss hammer", chance = 1480 },
	{ name = "lucky pig", chance = 2540 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 70, type = COMBAT_ICEDAMAGE, minDamage = -400, maxDamage = -450, radius = 20, effect = CONST_ME_ICETORNADO, target = true },
	{ name = "combat", interval = 2000, chance = 55, type = COMBAT_ICEDAMAGE, minDamage = -350, maxDamage = -480, length = 20, spread = 2, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 79,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
