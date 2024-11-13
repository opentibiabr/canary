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
	{ id = 3043, chance = 59860, minCount = 1, maxCount = 3 }, -- crystal coin
	{ id = 23373, chance = 59860, minCount = 1, maxCount = 34 }, -- ultimate mana potion
	{ id = 7643, chance = 47890, minCount = 1, maxCount = 33 }, -- ultimate health potion
	{ id = 23374, chance = 28870, minCount = 2, maxCount = 19 }, -- ultimate spirit potion
	{ id = 7439, chance = 23940, minCount = 1, maxCount = 9 }, -- berserk potion
	{ id = 3035, chance = 23240, minCount = 2, maxCount = 19 }, -- platinum coin
	{ id = 7443, chance = 20420, minCount = 1, maxCount = 9 }, -- bullseye potion
	{ id = 7440, chance = 16900, minCount = 2, maxCount = 9 }, -- mastermind potion
	{ id = 35572, chance = 13380, minCount = 3, maxCount = 86 }, -- pirate coin
	{ id = 35508, chance = 7750 }, -- cheesy key
	{ id = 32623, chance = 4930 }, -- giant topaz
	{ id = 35571, chance = 4230 }, -- small treasure chest
	{ id = 35581, chance = 3520 }, -- golden cheese wedge
	{ id = 35580, chance = 3520 }, -- golden skull
	{ id = 32622, chance = 2820 }, -- giant amethyst
	{ id = 31911, chance = 2820 }, -- sea horse figurine
	{ id = 30059, chance = 2110 }, -- giant ruby
	{ id = 35579, chance = 2110 }, -- golden dustbin
	{ id = 35576, chance = 2110 }, -- plushie of tentugly
	{ id = 35611, chance = 2110 }, -- tentacle of tentugly
	{ id = 35578, chance = 1410 }, -- tiara
	{ id = 35610, chance = 700 }, -- tentugly's eye
	{ id = 35612, chance = 700 }, -- tentugly's jaws
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
