local mType = Game.createMonsterType("The Unwelcome")
local monster = {}

monster.description = "The Unwelcome"
monster.experience = 30000
monster.outfit = {
	lookType = 1277,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.bosstiary = {
	bossRaceId = 1868,
	bossRace = RARITY_ARCHFOE,
	storageCooldown = Storage.Quest.FeasterOfSouls.Bosses.TheUnwelcome.Timer
}

monster.events = {
	"wormShareHealth",
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "undead"
monster.corpse = 32741
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 70,
	health = 1,
	damage = 1
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
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 1,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Where... Where am I?", yell = false},
	{text = "Is that you, Tom?", yell = false},
	{text = "Phew, what an awful smell ... oh, that's me.", yell = false}
}

monster.loot = {
	{name = "crystal coin", chance = 96080, maxCount = 2},
	{name = "supreme health potion", chance = 29410, maxCount = 6},
	{name = "ultimate spirit potion", chance = 23530, maxCount = 6},
	{name = "bullseye potion", chance = 19610, maxCount = 10},
	{name = "cursed bone", chance = 7840},
	{name = "death toll", chance = 13730, maxCount = 1},
	{name = "diamond", chance = 11760, maxCount = 2},
	{name = "silver hand mirror", chance = 27450},
	{name = "giant amethyst", chance = 50200, maxCount = 1},
	{name = "moonstone", chance = 49578, maxCount = 1},
	{name = "ivory comb", chance = 13730},
	{name = "white gem", chance = 52940, maxCount = 1},
	{name = "soulforged lantern", chance = 7250},
	{name = "fabulous legs", chance = 345},
	{name = "soulful legs", chance = 325},
	{name = "ghost claw", chance = 1960},
	{name = "writhing brain", chance = 2544},
	{name = "writhing heart", chance = 2657},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 600, maxDamage = -1050, condition = {type = CONDITION_POISON, totalDamage = 4, interval = 4000}},
	{name ="combat", interval = 2000, chance = 100, type = COMBAT_LIFEDRAIN, minDamage = -900, maxDamage = -1400, effect = CONST_ME_MAGIC_RED, target = true},
	{name ="combat", interval = 1000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -1000, maxDamage = -1750, radius = 2, shootEffect = CONST_ANI_SMALLEARTH, target = false},
	{name ="strength", interval = 1000, chance = 60, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -900, length = 5, spread = 3, effect = CONST_ME_ENERGYHIT, target = false},
	{name ="combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -600, maxDamage = -1200, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true},
	{name ="speed", interval = 3000, chance = 40, speedChange = -700, effect = CONST_ME_MAGIC_RED, target = true, duration = 20000}
}

monster.defenses = {
	defense = 5,
	armor = 5,
	{name ="speed", interval = 10000, chance = 40, speedChange = 510, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000},
	{name ="summonstheunwelcome", interval = 20000, chance = 50, target = false},
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 95},
	{type = COMBAT_ENERGYDAMAGE, percent = 95},
	{type = COMBAT_EARTHDAMAGE, percent = 95},
	{type = COMBAT_FIREDAMAGE, percent = 95},
	{type = COMBAT_LIFEDRAIN, percent = 95},
	{type = COMBAT_MANADRAIN, percent = 95},
	{type = COMBAT_DROWNDAMAGE, percent = 95},
	{type = COMBAT_ICEDAMAGE, percent = 95},
	{type = COMBAT_HOLYDAMAGE , percent = 95},
	{type = COMBAT_DEATHDAMAGE , percent = -100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType.onThink = function(monster, interval)
end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature)
end

mType.onMove = function(monster, creature, fromPosition, toPosition)
end

mType.onSay = function(monster, creature, type, message)
end

mType:register(monster)
