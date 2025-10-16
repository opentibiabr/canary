local mType = Game.createMonsterType("Grand Chaplain Gaunder")
local monster = {}

monster.description = "Grand Chaplain Gaunder"
monster.experience = 14000
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 23,
	lookFeet = 105,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1579,
	bossRace = RARITY_BANE,
}

monster.health = 18000
monster.maxHealth = 18000
monster.race = "blood"
monster.corpse = 28733
monster.speed = 105
monster.manaCost = 0

monster.events = {
	"killingLibrary",
}

monster.changeTarget = {
	interval = 3000,
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
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
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
	{ text = "Witness the might of The Order of the Falcon!", yell = false },
	{ text = "Suffer, for you are disobedient!", yell = false },
}

monster.loot = {
	{ id = 3582, chance = 80000 }, -- ham
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 678, chance = 80000 }, -- small enchanted amethyst
	{ id = 5944, chance = 80000 }, -- soul orb
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 7365, chance = 80000 }, -- onyx arrow
	{ id = 7368, chance = 80000 }, -- assassin star
	{ id = 7452, chance = 80000 }, -- spiked squelcher
	{ id = 28822, chance = 80000 }, -- damaged armor plates
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 28723, chance = 80000 }, -- falcon longsword
	{ id = 28719, chance = 80000 }, -- falcon plate
	{ id = 28724, chance = 80000 }, -- falcon battleaxe
	{ id = 28725, chance = 80000 }, -- falcon mace
	{ id = 28721, chance = 80000 }, -- falcon shield
	{ id = 3033, chance = 80000 }, -- small amethyst
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3370, chance = 80000 }, -- knight armor
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 31925, chance = 80000 }, -- closed trap
	{ id = 3340, chance = 80000 }, -- heavy mace
	{ id = 6558, chance = 80000 }, -- flask of demonic blood
	{ id = 7413, chance = 80000 }, -- titan axe
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 28821, chance = 80000 }, -- patch of fine cloth
	{ id = 3360, chance = 80000 }, -- golden armor
	{ id = 3342, chance = 80000 }, -- war axe
	{ id = 28823, chance = 80000 }, -- falcon crest
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3019, chance = 80000 }, -- demonbone amulet
	{ id = 3414, chance = 80000 }, -- mastermind shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -850 },
	{ name = "combat", interval = 1500, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -380, maxDamage = -890, range = 4, radius = 4, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -290, maxDamage = -720, range = 7, shootEffect = CONST_ANI_ETHEREALSPEAR, target = false },
	{ name = "combat", interval = 1500, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -300, maxDamage = -1000, length = 8, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -700, range = 5, radius = 3, effect = CONST_ME_SMALLCLOUDS, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 82,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 10, speedChange = 220, effect = CONST_ME_POFF, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 80 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
