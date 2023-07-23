local mType = Game.createMonsterType("Timira the Many-Headed")
local monster = {}

monster.name = "Timira The Many-Headed"
monster.description = "Timira the Many-Headed"
monster.experience = 78000
monster.outfit = {
	lookType = 1542,
}

monster.health = 200000
monster.maxHealth = 200000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 39712
monster.speed = 400
monster.summonCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25
}

monster.flags = {
	attackable = true,
	hostile = true,
	summonable = false,
	convinceable = false,
	illusionable = false,
	boss = true,
	ignoreSpawnBlock = false,
	pushable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	healthHidden = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	rewardBoss = true
}

monster.bosstiary = {
	bossRaceId = 2250,
	bossRace = RARITY_ARCHFOE,
	storageCooldown = Storage.Marapur.Timira
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -800, maxDamage = -1600},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_FIREDAMAGE, minDamage = -700, maxDamage = -1200, radius = 7, target = false, effect = CONST_ME_HITBYFIRE},
	{name ="combat", interval = 1800, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -700, maxDamage = -1500, range = 7, radius = 1, target = true, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT},
	{name ="combat", interval = 3000, chance = 30, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -700, effect = CONST_ME_PURPLEENERGY}
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.loot = {
	{name="crystal coin",chance = 100000, maxCount = 22},
	{name="ultimate mana potion", chance = 32653, maxCount = 14},
	{name="ultimate health potion",chance = 30612, maxCount = 14},
	{name= "bullseye potion",chance = 24490, maxCount = 5},
	{name= "berserk potion",chance = 22449, maxCount = 5},
	{id = 39233, chance = 5000},
	{name = "mastermind potion",chance = 18367, maxCount = 5},
	{name = "naga basin", chance = 12245},
	{name = "piece of timira's sensors", chance = 10204},
	{name = "giant amethyst", chance = 6122},
	{name = "giant ruby", chance = 4082},
	{name = "giant emerald", chance = 4082},
	{name = "one of timira's many heads", chance = 2041},
	{name = "giant sapphire", chance = 2041},
	{name = "giant topaz", chance = 2041},
	{name = "dawnfire sherwani", chance = 200},
	{name = "frostflower boots", chance = 200},
	{name = "Midnight Tunic", chance = 200},
	{name = "Midnight Sarong", chance = 200},
	{name = "Naga Sword", chance = 200},
	{name = "Naga Axe", chance = 200},
	{name = "Naga Club", chance = 200},
	{name = "Naga Wand", chance = 200},
	{name = "Naga Rod", chance = 200},
	{name = "Naga Crossbow", chance = 200}
}

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType:register(monster)
