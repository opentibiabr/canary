local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ROOTS)

local area = createCombatArea(AREA_WAVE11)
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
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()
