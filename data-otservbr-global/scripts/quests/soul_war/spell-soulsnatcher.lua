local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HOLYDAMAGE)

combat:setArea(createCombatArea(CrossBeamArea3X2))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("soulsnatcher-lifedrain-beam")
spell:words("soulsnatcher-lifedrain-beam")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HOLYAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_HOLY)

spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("soulsnatcher-lifedrain-missile")
spell:words("soulsnatcher-lifedrain-missile")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needTarget(true)
spell:register()

-- Mana drain ball
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)

combat:setArea(createCombatArea(AREA_CIRCLE3X3))

spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("soulsnatcher-manadrain-ball")
spell:words("soulsnatcher-manadrain-ball")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
