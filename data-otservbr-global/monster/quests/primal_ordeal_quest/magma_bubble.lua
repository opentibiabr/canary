local mType = Game.createMonsterType("Magma Bubble")
local monster = {}

monster.description = "magma bubble"
monster.experience = 80000
monster.outfit = {
	lookType = 1413,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 36843
monster.speed = 40
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20
}

monster.bosstiary = {
	bossRaceId = 2242,
	bossRace = RARITY_ARCHFOE,
	storageCooldown = Storage.Quest.U12_90.PrimalOrdeal.Bosses.MagmaBubbleTimer
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
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
}

monster.loot = {
	{ name = "crystal coin",chance = 100000, maxCount = 60},
	{ name = "ultimate mana potion", chance = 32653, maxCount = 14},
	{ name = "ultimate health potion",chance = 30612, maxCount = 14},
	{ name = "bullseye potion",chance = 24490, maxCount = 5},
	{ name = "berserk potion",chance = 22449, maxCount = 5},
	{ name = "mastermind potion",chance = 18367, maxCount = 5},
	{ name = "giant amethyst", chance = 6122},
	{ name = "giant ruby", chance = 4082},
	{ name = "giant emerald", chance = 4082},
	{ name = "giant sapphire", chance = 2041},
	{ name = "giant topaz", chance = 2041},
	{ name = "arboreal tome", chance = 250},
	{ name = "arboreal crown", chance = 250},
	{ name = "spiritthorn armor", id = 39147, chance = 250 },
	{ name = "spiritthorn helmet", id = 39148, chance = 250 },
	{ name = "alicorn headguard", chance = 250 },
	{ name = "alicorn quiver", chance = 250 },
	{ name = "arcanomancer regalia", chance = 250 },
	{ name = "arcanomancer folio", chance = 250 },
	{ id = 39183, chance = 250 }, -- name = "charged arcanomancer sigil"
	{ id = 39186, chance = 250 }, -- name = "charged arboreal ring"
	{ id = 39180, chance = 250 }, -- name = "charged alicorn ring"
	{ id = 39177, chance = 250 }, -- name = "charged spiritthorn ring"
}

monster.attacks = {
	{name ="melee", interval = 200, chance = 20, minDamage = 0, maxDamage = -650},
	{name ="combat", interval = 200, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -1500, target = false},
	{name ="combat", interval = 500, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -2100, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = true},
	{name ="combat", interval = 500, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -2600, radius = 8, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -1000, maxDamage = -2000, target = true},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_FIREDAMAGE, minDamage = -1500, maxDamage = -2000, length = 8, spread = 0, effect = CONST_ME_FIREAREA, target = false}
}

monster.defenses = {
	defense = 65,
	armor = 55,
	{name ="combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent =  0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
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
