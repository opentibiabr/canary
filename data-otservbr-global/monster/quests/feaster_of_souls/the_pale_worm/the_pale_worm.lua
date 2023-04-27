local mType = Game.createMonsterType("The Pale Worm")
local monster = {}

monster.description = "The Pale Worm"
monster.experience = 150000
monster.outfit = {
	lookType = 1272,
}

monster.events = {
	"paleWormShareHealth",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "venom"
monster.corpse = 32702
monster.speed = 200
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
}

monster.bosstiary = {
	bossRaceId = 1881,
	bossRace = RARITY_ARCHFOE,
	storageCooldown = Storage.Quest.FeasterOfSouls.Bosses.ThePaleWorm.Timer
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
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
	{name = "crystal coin", chance = 100000, maxCount = 3},
	{name = "mastermind potion", chance = 19417, maxCount = 10},
	{name = "supreme health potion", chance = 27184, maxCount = 6},
	{name = "diamond", chance = 41748, maxCount = 2},
	{name = "moonstone", chance = 43689, maxCount = 2},
	{name = "pale worm's scalp", chance = 1000},
	{name = "silver hand mirror", chance = 14563},
	{name = "white gem", chance = 14563, maxCount = 1},
	{name = "fabulous legs", chance = 500},
	{name = "ghost chestplate", chance = 480},
	{name = "pair of nightmare boots", chance = 580},
	{name = "phantasmal axe", chance = 600},
	{id = 32636, chance = 700},
	{name = "soulful legs", chance = 495},
	{name = "spectral scrap of cloth", chance = 800},
	{name = "ghost backpack", chance = 250},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -400, maxDamage = -1000},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -500, maxDamage = -800, length = 5, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -600, maxDamage = -750, radius = 5, range = 7, effect = CONST_ME_FIREAREA, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -500, radius = 5, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -600, maxDamage = -750, length = 5, effect = CONST_ME_HITBYPOISON, target = false},
}

monster.defenses = {
	defense = 40,
	armor = 82,
	{name ="summonsthepaleworm", interval = 5000, chance = 50, target = false},
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

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType:register(monster)
