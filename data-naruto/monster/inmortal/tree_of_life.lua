-- Script de Healing
function onTargetCreature(creature, target)
	local min = 10000
	local max = 90000

	doTargetCombatHealth(0, target, COMBAT_HEALING, min, max, CONST_ME_NONE)
	return true
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setArea(createCombatArea(AREA_CIRCLE6X6))
combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("Heal Players")
spell:words("#####31235123")
spell:blockWalls(false)
spell:needLearn(true)
spell:needDirection(false)
spell:register()

-- Creación de Monster
local mType = Game.createMonsterType("Tree of Life")
local monster = {}

monster.description = "an ancient tree of life"
monster.experience = 0
monster.outfit = {
	lookTypeEx = 25405,
}

monster.health = 1000000
monster.maxHealth = 1000000
monster.race = "blood"
monster.corpse = 0
monster.speed = 0
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Be as useful as a tree! Give life to others; be shelter to everyone; grant fruits to all! Be good like a tree!", yell = false },
	{ text = "The tree of life for me is a symbol of abundance and eternal life!", yell = false },
	{ text = "Thanks for playing our OTServer!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 74230, maxCount = 10 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -10, effect = CONST_ME_DRAWBLOOD },
	{ name = "Heal Players", interval = 5000, chance = 100 },
}

monster.defenses = {
	defense = 5,
	armor = 8,
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 30000, maxDamage = 60000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -100 },
	{ type = COMBAT_EARTHDAMAGE, percent = -100 },
	{ type = COMBAT_FIREDAMAGE, percent = -100 },
	{ type = COMBAT_LIFEDRAIN, percent = -100 },
	{ type = COMBAT_MANADRAIN, percent = -100 },
	{ type = COMBAT_DROWNDAMAGE, percent = -100 },
	{ type = COMBAT_ICEDAMAGE, percent = -100 },
	{ type = COMBAT_HOLYDAMAGE, percent = -100 },
	{ type = COMBAT_DEATHDAMAGE, percent = -100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
