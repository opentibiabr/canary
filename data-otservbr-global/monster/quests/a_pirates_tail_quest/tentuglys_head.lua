local mType = Game.createMonsterType("Tentugly's Head")
local monster = {}

monster.description = "Tentugly's Head"
monster.experience = 40000
monster.outfit = {
	lookTypeEx = 35105,
}

monster.bosstiary = {
	bossRaceId = 2238,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "blood"
monster.corpse = 35600
monster.speed = 0
monster.manaCost = 0

monster.events = {
	"TentuglysHeadDeath",
}

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
	rewardBoss = true,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 70,
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
	{ id = 35508, chance = 80000 }, -- cheesy key
	{ id = 3043, chance = 80000, maxCount = 3 }, -- crystal coin
	{ id = 3035, chance = 80000, maxCount = 19 }, -- platinum coin
	{ id = 23373, chance = 80000, maxCount = 38 }, -- ultimate mana potion
	{ id = 7643, chance = 80000, maxCount = 37 }, -- ultimate health potion
	{ id = 23374, chance = 80000, maxCount = 19 }, -- ultimate spirit potion
	{ id = 35572, chance = 80000, maxCount = 99 }, -- pirate coin
	{ id = 7443, chance = 80000, maxCount = 9 }, -- bullseye potion
	{ id = 7439, chance = 80000, maxCount = 9 }, -- berserk potion
	{ id = 7440, chance = 80000, maxCount = 9 }, -- mastermind potion
	{ id = 35578, chance = 80000 }, -- tiara
	{ id = 31323, chance = 80000 }, -- sea horse figurine
	{ id = 35571, chance = 80000 }, -- small treasure chest
	{ id = 32622, chance = 80000 }, -- giant amethyst
	{ id = 32623, chance = 80000 }, -- giant topaz
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 35580, chance = 80000 }, -- golden skull
	{ id = 35579, chance = 80000 }, -- golden dustbin
	{ id = 35581, chance = 80000 }, -- golden cheese wedge
	{ id = 35611, chance = 80000 }, -- tentacle of tentugly
	{ id = 35610, chance = 80000 }, -- tentuglys eye
	{ id = 35612, chance = 1000 }, -- tentuglys jaws
	{ id = 35576, chance = 260 }, -- plushie of tentugly
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", type = COMBAT_ENERGYDAMAGE, interval = 2000, chance = 40, minDamage = -100, maxDamage = -400, range = 5, radius = 4, target = true, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_GHOSTLY_BITE },
	{ name = "energy waveT", interval = 2000, chance = 30, minDamage = 0, maxDamage = -250 },
	{ name = "combat", type = COMBAT_ENERGYDAMAGE, interval = 2000, chance = 50, minDamage = -100, maxDamage = -300, radius = 5, effect = CONST_ME_LOSEENERGY },
}

monster.defenses = {
	defense = 60,
	armor = 82,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = -30 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
