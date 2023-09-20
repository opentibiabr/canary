local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLUE_GHOST)

local condition = Condition(CONDITION_FEARED)
condition:setParameter(CONDITION_PARAM_TICKS, 3000)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if not creature then
		return
	end
	return combat:execute(creature, var)
end

spell:name("fear")
spell:words("###613")
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()
