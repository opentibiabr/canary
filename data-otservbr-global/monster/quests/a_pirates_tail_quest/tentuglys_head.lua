local mType = Game.createMonsterType("Tentugly's Head")
local monster = {}

monster.description = "Tentugly's Head"
monster.experience = 40000
monster.outfit = {
	lookTypeEx = 35105,
}

monster.events = {
	"TentuglysHeadDeath"
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "blood"
monster.corpse = 35600
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.bosstiary = {
	bossRaceId = 2238,
	bossRace = RARITY_ARCHFOE,
	storageCooldown = Storage.Quest.U12_60.APiratesTail.TentuglyTimer
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
	{name = "crystal coin", chance = 10000, maxCount = 3},
	{name = "platinum coin", chance = 10000, maxCount = 10},
	{name = "ultimate health potion", chance = 7300, maxCount = 11},
	{name = "ultimate mana potion", chance = 7300, maxCount = 3},
	{name = "ultimate spirit potion", chance = 7300, maxCount = 3},
	{name = "berserk potion", chance = 7300, maxCount = 5},
	{name = "mastermind potion", chance = 7300, maxCount = 5},
	{name = "bullseye potion", chance = 7300, maxCount = 5},
	{name = "pirate coin", chance = 7300, maxCount = 50},
	{name = "cheesy key", chance = 700},
	{name = "small treasure chest", chance = 700},
	{name = "giant amethyst", chance = 600},
	{name = "tentugly's eye", chance = 600},
	{name = "giant ruby", chance = 400},
	{name = "golden dustbin", chance = 650},
	{name = "tentacle of tentugly", chance = 650, maxCount = 2},
	{name = "tiara", chance = 650},
	{name = "giant topaz", chance = 650},
	{name = "golden cheese wedge", chance = 650},
	{name = "golden skull", chance = 650},
	{name = "plushie of tentugly", chance = 650},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -700},
	{name = "combat", type = COMBAT_ENERGYDAMAGE, interval = 2000, chance = 40, minDamage = -400, maxDamage = -500, range = 5, radius = 4, target = true, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_GHOSTLY_BITE},
	{name = "combat", type = COMBAT_ENERGYDAMAGE, interval = 2000, chance = 30, minDamage = -300, maxDamage = -500, length = 7, effect = CONST_ME_LOSEENERGY},
	{name = "combat", type = COMBAT_ENERGYDAMAGE, interval = 2000, chance = 70, minDamage = -300, maxDamage = -500, radius = 4, effect = CONST_ME_LOSEENERGY}
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 30},
	{type = COMBAT_EARTHDAMAGE, percent = -30},
	{type = COMBAT_FIREDAMAGE, percent = -20},
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
	{type = "bleed", condition = false}
}

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType:register(monster)
