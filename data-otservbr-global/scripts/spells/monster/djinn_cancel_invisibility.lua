local combat = Combat()
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_INVISIBLE)

local area = createCombatArea(AREA_CIRCLE3X3)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("djinn cancel invisibility")
spell:words("###47")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()