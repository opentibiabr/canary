local mType = Game.createMonsterType("Srezz Yellow Eyes")
local monster = {}

monster.description = "Srezz Yellow Eyes"
monster.experience = 4800
monster.outfit = {
	lookType = 220,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 6200
monster.maxHealth = 6200
monster.race = "venom"
monster.corpse = 6061
monster.speed = 117
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.bosstiary = {
	bossRaceId = 1983,
	bossRace = RARITY_ARCHFOE,
	storageCooldown = Storage.Quest.U10_80.Grimvale.SrezzTimer
}

monster.strategiesTarget = {
	nearest = 70,
	health = 30,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 275,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10
}

monster.loot = {
	{name = "platinum coin", chance = 32300, maxCount = 17},
	{name = "ultimate health potion", chance = 32300, maxCount = 5},
	{name = "gold ingot", chance = 2870},
	{name = "snake skin", chance = 14800},
	{name = "mastermind potion", chance = 12000},
	{id = 282, chance = 14000, maxCount = 2}, -- giant shimmering pearl (brown)
	{name = "blue crystal shard", chance = 800},
	{name = "black pearl", chance = 930},
	{name = "winged tail", chance = 560},
	{name = "srezz' eye", chance = 670},
	{name = "violet gem", chance = 510},
	{name = "gemmed figurine", chance = 140},
	{name = "green gem", chance = 920},
	{name = "blue gem", chance = 6200},
	{name = "glacier robe", chance = 18200},
	{name = "glacier kilt", chance = 180},
	{name = "giant sword", chance = 2070},
	{name = "skull helmet", chance = 750},
	{name = "war axe", chance = 2000},
	{name = "demonrage sword", chance = 90},
	{id = 23531, chance = 156}, -- ring of green plasma
	{id = 3040, chance = 90}, -- gold nugget
	{name = "red silk flower", chance = 14800},
	{name = "raw watermelon tourmaline", chance = 960}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200},
	{name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2000, chance = 40, minDamage = -400, maxDamage = -500, range = 5, radius = 4, target = true, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_GREEN_RINGS},
	{name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 30, minDamage = -200, maxDamage = -300, length = 4, spread = 2, effect = CONST_ME_DRAWBLOOD},
	{name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 70, minDamage = -200, maxDamage = -350, radius = 4, effect = CONST_ME_DRAWBLOOD}
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 340, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
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
