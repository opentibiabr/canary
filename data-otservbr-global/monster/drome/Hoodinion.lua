local mType = Game.createMonsterType("Hoodinion")
local monster = {}

monster.description = "Hoodinion"
monster.experience = 0
monster.outfit = {
	lookType = 1424,
}

monster.events = {
	"DromeMonsterDeath",
	"ExplodingCorpses",
	"TargetedExplodingCorpses",
}

monster.health = 800
monster.maxHealth = 800
monster.race = "undead"
monster.corpse = 36906
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	targetDistance = 4,
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

}

monster.attacks = {
    {name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -100},
	{name ="combat", interval = 1000, chance = 12, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -100, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true},
    {name ="combat", interval = 2000, chance = 12, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -100, range = 7, radius = 6, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICETORNADO, target = true},
    {name ="combat", interval = 3000, chance = 13, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -100, range = 7, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ANI_TARSALARROW, target = true},
    {name ="combat", interval = 3000, chance = 16, type = COMBAT_HOLYDAMAGE, minDamage = -100, maxDamage = -100, range = 7, radius = 6, effect = CONST_ME_HITBYFIRE, target = false}
}

monster.defenses = {
	defense = 110,
	armor = 110
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
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

local function applyDamageScalingCondition(creature)
    local dromeLevel = getDromeLevel(creature)
    local condition = Condition(CONDITION_ATTRIBUTES)
    local scaleFactor = 1 + (dromeLevel * 0.5)
    local scaledBuff = math.floor(100 * scaleFactor)

    condition:setParameter(CONDITION_PARAM_TICKS, -1)
    condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, scaledBuff)
    creature:addCondition(condition)
end

mType.onAppear = function(creature)
    applyDamageScalingCondition(creature)

    local creatureName = creature:getName()

    local dromeLevel = getDromeLevel(creature)
end

mType:register(monster)
