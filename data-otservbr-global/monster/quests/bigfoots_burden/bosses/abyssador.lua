local mType = Game.createMonsterType("Abyssador")
local monster = {}

monster.description = "Abyssador"
monster.experience = 50000
monster.outfit = {
	lookType = 495,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 340000
monster.maxHealth = 340000
monster.race = "blood"
monster.corpse = 16067
monster.speed = 230
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 10
}

monster.bosstiary = {
	bossRaceId = 887,
	bossRace = RARITY_ARCHFOE,
	storageCooldown = Storage.BigfootBurden.BossWarzone3
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "*** STEALTH ***", yell = false},
	{text = "*** TIME ***", yell = false},
	{text = "*** IMPORTANT ***", yell = false},
	{text = "*** BRAINS *** SMALL ***", yell = false},
	{text = "*** DEATH ***", yell = false},
	{text = "*** FIRE *** HOME *** VICTORY ***", yell = false},
	{text = "*** EXISTENCE *** FUTILE ***", yell = false}
}

monster.loot = {
	{id = 16206, chance = 100000}, -- abyssador's lash
	{id = 16163, chance = 8333}, -- crystal crossbow
	{id = 16161, chance = 7333}, -- crystalline axe
	{id = 16175, chance = 5333}, -- shiny blade
	{id = 16160, chance = 6666}, -- crystalline sword
	{id = 16164, chance = 6263}, -- mycological bow
	{id = 16155, chance = 2754}, -- decorative ribbon
	{id = 16162, chance = 2754} -- mycological mace
}

monster.attacks = {
	{name ="melee", interval = 3000, chance = 100, skill = 300, attack = 150},
	-- energy damage
	{name ="condition", type = CONDITION_ENERGY, interval = 1000, chance = 10, minDamage = -800, maxDamage = -800, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_SMALLPLANTS, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -1600, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false},
	{name ="abyssador poison wave", interval = 1000, chance = 20, minDamage = -1000, maxDamage = -1800, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 15,
	{name ="combat", interval = 1000, chance = 1, type = COMBAT_HEALING, minDamage = 0, maxDamage = 300000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="combat", interval = 5000, chance = 30, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="invisible", interval = 2000, chance = 25, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 15},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
