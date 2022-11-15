local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_LIFEDRAIN)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)

local area = createCombatArea(AREA_WAVE11)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("big lifedrain wave")
spell:words("###424")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()