local mType = Game.createMonsterType("Azerus")
local monster = {}

monster.description = "Azerus"
monster.experience = 6000
monster.outfit = {
	lookType = 309,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"AzerusDeath",
}

monster.health = 26000
monster.maxHealth = 26000
monster.race = "blood"
monster.corpse = 0
monster.speed = 143
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 85,
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

monster.summon = {
	maxSummons = 10,
	summons = {
		{ name = "Rift Worm", interval = 30, chance = 3000, count = 8 },
		{ name = "Rift Brood", interval = 30, chance = 3000, count = 8 },
		{ name = "Rift Scythe", interval = 30, chance = 3000, count = 8 },
		{ name = "War Golem", interval = 30, chance = 3000, count = 5 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The ultimate will finally consume this unworthy existence!", yell = false },
	{ text = "My masters and I will tear down barriers and join the ultimate in its realm!", yell = false },
	{ text = "The power of the Yalahari will all be mine!", yell = false },
	{ text = "We will open the rift for a new time to come!", yell = false },
	{ text = "He who has returned from beyond has taught me secrets you can't even grasp!", yell = false },
	{ text = "The end of times has come!", yell = false },
	{ text = "The great machinator will make his entrance soon!", yell = false },
	{ text = "You might scratch my shields but they will never break!", yell = false },
	{ text = "You can't hope to penetrate my shields!", yell = false },
	{ text = "Do you really think you could beat me?", yell = false },
	{ text = "Even without Yalahari shields, I'm still invincible!", yell = false },
	{ text = "Creation must be undone! We will join the ultimate in the annihiliverse!", yell = false },
	{ text = "The rift is tearing at me, I can't control it much longer ... Master, where are you?", yell = false },
	{ text = "Even gods are HIS pawns and HE laughs about creation! And you are trying to stop his minions?", yell = false },
	{ text = "Don't you understand? Gods, Yalarahi, Humans we are all doing HIS bidding all the time!", yell = false },
}

monster.loot = {

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -3800, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_BIGCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -524, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -1050, length = 8, spread = 0, effect = CONST_ME_FIREATTACK, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 40,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 11, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
