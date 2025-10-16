local mType = Game.createMonsterType("Maxxenius")
local monster = {}

monster.description = "Maxxenius"
monster.experience = 55000
monster.outfit = {
	lookType = 1142,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "blood"
monster.corpse = 30151
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1697,
	bossRace = RARITY_NEMESIS,
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
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 3043, chance = 80000, maxCount = 3 }, -- crystal coin
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 7443, chance = 80000, maxCount = 10 }, -- bullseye potion
	{ id = 7440, chance = 80000, maxCount = 10 }, -- mastermind potion
	{ id = 25759, chance = 80000, maxCount = 100 }, -- royal star
	{ id = 23375, chance = 80000, maxCount = 20 }, -- supreme health potion
	{ id = 23373, chance = 80000, maxCount = 14 }, -- ultimate mana potion
	{ id = 23374, chance = 80000, maxCount = 60 }, -- ultimate spirit potion
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 30056, chance = 80000 }, -- ornate locket
	{ id = 22721, chance = 80000, maxCount = 2 }, -- gold token
	{ id = 22516, chance = 80000, maxCount = 3 }, -- silver token
	{ id = 30169, chance = 80000 }, -- pomegranate
	{ id = 23535, chance = 80000 }, -- energy bar
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 23528, chance = 80000 }, -- collar of red plasma
	{ id = 23527, chance = 80000 }, -- collar of green plasma
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 23509, chance = 80000 }, -- mysterious remains
	{ id = 2995, chance = 80000 }, -- piggy bank
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 29426, chance = 80000 }, -- brain in a jar
	{ id = 29425, chance = 80000 }, -- energized limb
	{ id = 29942, chance = 80000 }, -- maxxenius head
	{ id = 30171, chance = 80000 }, -- purple tendril lantern
	{ id = 5904, chance = 80000 }, -- magic sulphur
	{ id = 5809, chance = 80000 }, -- soul stone
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 23526, chance = 80000 }, -- collar of blue plasma
	{ id = 23531, chance = 80000 }, -- ring of green plasma
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 7414, chance = 80000 }, -- abyss hammer
	{ id = 19400, chance = 80000 }, -- arcane staff
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -500, maxDamage = -1000 },
	{ name = "energy beam", interval = 2000, chance = 10, minDamage = -500, maxDamage = -1200, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "energy wave", interval = 2000, chance = 10, minDamage = -500, maxDamage = -1200, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 600 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.heals = {
	{ type = COMBAT_ENERGYDAMAGE, percent = 500 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
