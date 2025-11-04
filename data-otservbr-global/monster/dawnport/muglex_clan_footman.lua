local mType = Game.createMonsterType("Muglex Clan Footman")
local monster = {}

monster.description = "a muglex clan footman"
monster.experience = 25
monster.outfit = {
	lookType = 61,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"MorrisGoblinDeath",
}

monster.health = 50
monster.maxHealth = 50
monster.race = "blood"
monster.corpse = 6002
monster.speed = 60
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
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
	{ id = 3031, chance = 100000, maxCount = 6 }, -- Gold Coin
	{ id = 3267, chance = 17237 }, -- Dagger
	{ id = 3578, chance = 16333 }, -- Fish
	{ id = 1781, chance = 14931 }, -- Small Stone
	{ id = 3294, chance = 10618 }, -- Short Sword
	{ id = 3337, chance = 9617 }, -- Bone Club
	{ id = 3462, chance = 8914 }, -- Small Axe
	{ id = 3361, chance = 5811 }, -- Leather Armor
	{ id = 3355, chance = 3003 }, -- Leather Helmet
	{ id = 3115, chance = 1502 }, -- Bone
	{ id = 3120, chance = 799 }, -- Mouldy Cheese
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 10, attack = 10 },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -22, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = false },
}

monster.defenses = {
	defense = 4,
	armor = 2,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
