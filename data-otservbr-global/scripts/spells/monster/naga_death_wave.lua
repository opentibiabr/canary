local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combat:setArea(createCombatArea(AREA_SQUAREWAVE5_NAGA, AREADIAGONAL_SQUAREWAVE5_NAGA))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("nagadeath")
spell:words("###488")
spell:blockWalls(true)
spell:needDirection(true)
spell:needLearn(true)
spell:register()