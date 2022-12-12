local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PURPLEENERGY)

local area = createCombatArea(AREA_WAVE11)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("big energy purple wave2")
spell:words("###417")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()