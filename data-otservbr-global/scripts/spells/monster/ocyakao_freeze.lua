	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)

	local condition = Condition(CONDITION_FREEZING)
	condition:setParameter(CONDITION_PARAM_DELAYED, 1)
	condition:addDamage(25, 8000, -8)
	combat:addCondition(condition)

	local area = createCombatArea(AREA_CIRCLE3X3)
	combat:setArea(area)
	combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("ocyakao freeze")
spell:words("###199")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()