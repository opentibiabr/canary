local mType = Game.createMonsterType("Drume")
local monster = {}

monster.description = "Drume"
monster.experience = 25000
monster.outfit = {
	lookType = 1317,
	lookHead = 38,
	lookBody = 76,
	lookLegs = 57,
	lookFeet = 114,
	lookAddons = 2,
	lookMount = 0
}

monster.health = 35000
monster.maxHealth = 35000
monster.race = "blood"
monster.corpse = 33973
monster.speed = 130

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = {FACTION_LION, FACTION_PLAYER}

monster.summon = {
	maxSummons = 3,
	summons = {
		{name = "preceptor lazare", chance = 10, interval = 8000, count = 1},
		{name = "grand commander soeren", chance = 10, interval = 8000, count = 1},
		{name = "grand chaplain gaunder", chance = 10, interval = 8000, count = 1}
	}
}

monster.changeTarget = {
	interval = 4000,
	chance = 25
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
	{name = "energy bar", chance = 100000},
	{name = "platinum coin", chance = 100000, maxCount = 5},
	{name = "supreme health potion", chance = 57831, maxCount = 20},
	{name = "ultimate mana potion", chance = 55723, maxCount = 20},
	{name = "yellow gem", chance = 35843, maxCount = 2},
	{id= 3039, chance = 35542, maxCount = 2}, -- red gem
	{name = "ultimate spirit potion", chance = 31627, maxCount = 6},
	{name = "royal star", chance = 31325, maxCount = 100},
	{name = "bullseye potion", chance = 22590, maxCount = 10},
	{name = "berserk potion", chance = 21988, maxCount = 10},
	{name = "blue gem", chance = 21687, maxCount = 2},
	{name = "mastermind potion", chance = 17771, maxCount = 10},
	{name = "green gem", chance = 17470, maxCount = 2},
	{id = 281, chance = 15060}, -- giant shimmering pearl (green)
	{name = "gold ingot", chance = 13253},
	{name = "terra rod", chance = 11145},
	{name = "crystal coin", chance = 10241},
	{name = "stone skin amulet", chance = 10241},
	{name = "silver token", chance = 8735, maxCount = 3},
	{name = "terra legs", chance = 8735},
	{name = "terra mantle", chance = 7831},
	{name = "raw watermelon tourmaline", chance = 7229},
	{name = "wand of voodoo", chance = 6024},
	{name = "violet gem", chance = 5723},
	{name = "terra hood", chance = 4819},
	{name = "terra amulet", chance = 4518},
	{name = "giant sapphire", chance = 4217},
	{name = "giant ruby", chance = 3012},
	{name = "underworld rod", chance = 2410},
	{name = "lion spangenhelm", chance = 90},
	{name = "lion plate", chance = 90},
	{name = "lion shield", chance = 90},
	{name = "lion longsword", chance = 90},
	{name = "lion hammer", chance = 90},
	{name = "lion axe", chance = 90},
	{name = "lion longbow", chance = 90},
	{name = "lion spellbook", chance = 90},
	{name = "lion wand", chance = 90},
	{name = "lion amulet", chance = 90},
	{name = "lion rod", chance = 90}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900, effect = CONST_ME_DRAWBLOOD},
	{name ="combat", interval = 6000, chance = 25, type = COMBAT_HOLYDAMAGE, minDamage = -650, maxDamage = -950, length = 8, spread = 3, effect = CONST_ME_HOLYAREA, target = false},
	{name ="combat", interval = 2750, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -1000, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2500, chance = 22, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -800, radius = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 3300, chance = 24, type = COMBAT_ICEDAMAGE, minDamage = -500, maxDamage = -700, length = 4, spread = 0, effect = CONST_ME_ICEATTACK, target = false},
	{name ="singlecloudchain", interval = 6000, chance = 34, minDamage = -400, maxDamage = -900, range = 4, effect = CONST_ME_ENERGYHIT, target = true}
}

monster.defenses = {
	defense = 60,
	armor = 82,
	{name ="combat", interval = 4000, chance = 40, type = COMBAT_HEALING, minDamage = 300, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = -20},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
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
