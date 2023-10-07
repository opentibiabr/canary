local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ROOTS)

local area = createCombatArea(AREA_SQUAREWAVE5)
combat:setArea(area)

local spell = Spell("instant")

local condition = Condition(CONDITION_ROOTED)
condition:setParameter(CONDITION_PARAM_TICKS, 3000)
combat:addCondition(condition)

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("root wave")
spell:words("###691")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needTarget(false)
spell:needDirection(true)
spell:register()
