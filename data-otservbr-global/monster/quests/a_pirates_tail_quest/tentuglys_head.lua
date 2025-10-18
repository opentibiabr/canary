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
	{ id = 35508, chance = 22673 }, -- Cheesy Key
	{ id = 3043, chance = 63007, maxCount = 3 }, -- Crystal Coin
	{ id = 3035, chance = 22911, maxCount = 19 }, -- Platinum Coin
	{ id = 23373, chance = 62052, maxCount = 38 }, -- Ultimate Mana Potion
	{ id = 7643, chance = 52505, maxCount = 37 }, -- Ultimate Health Potion
	{ id = 23374, chance = 24821, maxCount = 19 }, -- Ultimate Spirit Potion
	{ id = 35572, chance = 15990, maxCount = 99 }, -- Pirate Coin
	{ id = 7443, chance = 18854, maxCount = 9 }, -- Bullseye Potion
	{ id = 7439, chance = 19809, maxCount = 9 }, -- Berserk Potion
	{ id = 7440, chance = 19809, maxCount = 9 }, -- Mastermind Potion
	{ id = 49271, chance = 1000, maxCount = 9 }, -- Transcendence Potion
	{ id = 35578, chance = 1670 }, -- Tiara
	{ id = 31323, chance = 2577 }, -- Sea Horse Figurine
	{ id = 35571, chance = 5727 }, -- Small Treasure Chest
	{ id = 32622, chance = 3579 }, -- Giant Amethyst
	{ id = 32623, chance = 5250 }, -- Giant Topaz
	{ id = 30059, chance = 2625 }, -- Giant Ruby
	{ id = 35580, chance = 2386 }, -- Golden Skull
	{ id = 35579, chance = 3102 }, -- Golden Dustbin
	{ id = 35581, chance = 2863 }, -- Golden Cheese Wedge
	{ id = 35611, chance = 2863 }, -- Tentacle of Tentugly
	{ id = 35610, chance = 2863 }, -- Tentugly's Eye
	{ id = 35612, chance = 515 }, -- Tentugly's Jaws
	{ id = 35576, chance = 1670 }, -- Plushie of Tentugly
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
