local mType = Game.createMonsterType("Utua Stone Sting")
local monster = {}

monster.description = "Utua Stone Sting"
monster.experience = 5100
monster.outfit = {
	lookType = 398,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 6400
monster.maxHealth = 6400
monster.race = "undead"
monster.corpse = 12512
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.bosstiary = {
	bossRaceId = 1984,
	bossRace = RARITY_ARCHFOE,
	storageCooldown = Storage.Quest.U10_80.Grimvale.UtuaTimer
}

monster.strategiesTarget = {
	nearest = 60,
	random = 40,
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
	{name = "platinum coin", chance = 92590, maxCount = 17},
	{name = "ultimate health potion", chance = 1100, maxCount = 5},
	{name = "scorpion tail", chance = 10750, maxCount = 5},
	{name = "emerald bangle", chance = 5100},
	{name = "lightning legs", chance = 4620},
	{name = "utua's poison", chance = 1820},
	{name = "violet gem", chance = 5100},
	{name = "coral brooch", chance = 4620},
	{name = "glacier kilt", chance = 1820},
	{name = "crystal mace", chance = 5100},
	{name = "gemmed figurine", chance = 4620},
	{name = "skull helmet", chance = 1820},
	{name = "warrior's axe", chance = 5100},
	{name = "gold ingot", chance = 4620},
	{name = "green gem", chance = 1820},
	{name = "mercenary sword", chance = 5100},
	{name = "chaos mace", chance = 4620},
	{name = "demon shield", chance = 1820},
	{name = "guardian axe", chance = 4620},
	{name = "spellweaver's robe", chance = 1820},
	{name = "glacier robe", chance = 5100},
	{name = "noble axe", chance = 4620},
	{name = "magic plate armor", chance = 1820},
	{name = "mastermind potion", chance = 4620},
	{id = 23531, chance = 156}, -- ring of green plasma
	{name = "magma legs", chance = 5100},
	{name = "raw watermelon tourmaline", chance = 4620},
	{name = "red silk flower", chance = 1820},
	{name = "fist on a stick", chance = 220}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -300, condition = {type = CONDITION_POISON, totalDamage = 1000, interval = 4000}},
	{name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2000, chance = 17, minDamage = -200, maxDamage = -300, range = 5, radius = 4, target = true, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_GREEN_RINGS},
	{name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2000, chance = 100, minDamage = -300, maxDamage = -450, range = 5, radius = 1, target = true, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS},
	{name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 100, minDamage = -200, maxDamage = -400, length = 4, spread = 2, effect = CONST_ME_DRAWBLOOD}
}

monster.defenses = {
	defense = 0,
	armor = 42,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 60, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 25},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
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
