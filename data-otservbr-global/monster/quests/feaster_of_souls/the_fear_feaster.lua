local mType = Game.createMonsterType("The Fear Feaster")
local monster = {}

monster.description = "The Fear Feaster"
monster.experience = 13090
monster.outfit = {
	lookType = 1276,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 20000
monster.maxHealth = 20000
monster.race = "undead"
monster.corpse = 32737
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
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
}

monster.loot = {
	{name = "crystal coin", chance = 96080, maxCount = 2},
	{name = "white gem", chance = 52940, maxCount = 2},
	{name = "moonstone", chance = 52940, maxCount = 2},
	{name = "ultimate mana potion", chance = 43140, maxCount = 6},
	{name = "supreme health potion", chance = 29410, maxCount = 6},
	{name = "silver hand mirror", chance = 27450},
	{name = "berserk potion", chance = 23530, maxCount = 10},
	{name = "ultimate spirit potion", chance = 23530, maxCount = 6},
	{name = "bullseye potion", chance = 19610, maxCount = 10},
	{name = "mastermind potion", chance = 19610, maxCount = 10},
	{name = "death toll", chance = 13730, maxCount = 2},
	{name = "ivory comb", chance = 13730},
	{name = "angel figurine", chance = 11760},
	{name = "diamond", chance = 11760},
	{name = "cursed bone", chance = 7840},
	{name = "soulforged lantern", chance = 7840},
	{name = "grimace", chance = 5880},
	{name = "amber", chance = 5880},
	{name = "amber with a dragonfly", chance = 3920},
	{name = "ghost claw", chance = 1960},
	{name = "bloody tears", chance = 1500},
	{name = "ghost chestplate", chance = 150},
	{name = "spooky hood", chance = 150}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200},
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -680, range = 7, shootEffect = CONST_ANI_EARTHARROW, target = false},
	{name ="combat", interval = 1000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -575, length = 5, spread = 3, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 1000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = -230, maxDamage = -880, range = 7, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 82
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 30},
	{type = COMBAT_EARTHDAMAGE, percent = 80},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
