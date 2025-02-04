local mType = Game.createMonsterType("Murmillion")
local monster = {}

monster.description = "Murmillion"
monster.experience = 0
monster.outfit = {
    lookType = 1422,
}

monster.events = {
    "DromeMonsterDeath",
    "ExplodingCorpses",
    "TargetedExplodingCorpses",
}

monster.health = 800
monster.maxHealth = 800
monster.race = "undead"
monster.corpse = 36898
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

monster.voices = {}

monster.attacks = {
    {name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -500},
    {name = "combat", interval = 1000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -500, radius = 4, effect = CONST_ME_SLASH, target = false},
    {name = "combat", interval = 2500, chance = 13, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -550, range = 5, radius = 7, effect = CONST_ME_EXPLOSIONAREA, target = false},
    {name = "combat", interval = 2000, chance = 8, type = COMBAT_DEATHDAMAGE, minDamage = -100, maxDamage = -600, range = 7, length = 3, effect = CONST_ME_GROUNDSHAKER, target = false},
    { name = "root", interval = 3000, chance = 1, target = true }
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

mType:register(monster)
