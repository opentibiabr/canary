local mType = Game.createMonsterType("Katex Blood Tongue")
local monster = {}

monster.description = "Katex Blood Tongue"
monster.experience = 5000
monster.outfit = {
	lookType = 1300,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 113,
	lookFeet = 113,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 6300
monster.maxHealth = 6300
monster.race = "blood"
monster.corpse = 34189
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0
}

monster.bosstiary = {
	bossRaceId = 1981,
	bossRace = RARITY_ARCHFOE,
	storageCooldown = Storage.Quest.U10_80.Grimvale.KatexTimer
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
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
	maxSummons = 1,
	summons = {
		{name = "werehyaena", chance = 50, interval = 5000, count = 1}
	}
}

monster.voices = {
	interval = 0,
	chance = 0
}

monster.loot = {
	{name = "platinum coin", chance = 32300, maxCount = 17},
	{name = "ultimate health potion", chance = 32300, maxCount = 5},
	{name = "gold ingot", chance = 2870},
	{name = "werehyaena nose", chance = 14800},
	{name = "werehyaena trophy", chance = 12000},
	{name = "katex' blood", chance = 12000},
	{name = "violet gem", chance = 510},
	{name = "werehyaena talisman", chance = 12000},
	{name = "demon shield", chance = 800},
	{name = "skull helmet", chance = 930},
	{name = "blue gem", chance = 560},
	{name = "gold ring", chance = 670},
	{name = "magic plate armor", chance = 140},
	{name = "demonrage sword", chance = 90},
	{name = "moonlight crystals", chance = 920},
	{name = "jade hammer", chance = 6200},
	{id = 23531, chance = 156}, -- ring of green plasma
	{name = "golden armor", chance = 18200},
	{name = "alloy legs", chance = 180},
	{name = "assassin dagger", chance = 2070},
	{name = "mastermind potion", chance = 750},
	{name = "ornate crossbow", chance = 2000},
	{name = "war axe", chance = 90},
	{name = "red silk flower", chance = 14800},
	{name = "raw watermelon tourmaline", chance = 960},
	{id = 282, chance = 14000, maxCount = 2} -- giant shimmering pearl (brown)
}

monster.attacks = {
	{name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, minDamage = -150, maxDamage = -300},
    {name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2000, chance = 17, minDamage = -350, maxDamage = -500, range = 5, radius = 4, target = true, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_GREEN_RINGS},
    {name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2000, chance = 15, minDamage = -300, maxDamage = -430, radius = 4, target = false, effect = CONST_ME_MORTAREA},
    {name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2000, chance = 13, minDamage = -250, maxDamage = -350, length = 3, spread = 0, effect = CONST_ME_MORTAREA}
}

monster.defenses = {
	{name = "speed", interval = 2000, chance = 15, speed = 200, duration = 5000, effect = CONST_ME_MAGIC_BLUE},
	defense = 0,
	armor = 38
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = true}
}

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType:register(monster)
