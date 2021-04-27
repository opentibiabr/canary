local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLCLOUDS)
combat:setArea(createCombatArea(AREA_CIRCLE6X6))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local damage = math.random(52, 154)
	for _, target in ipairs(combat:getTargets(creature, var)) do
		creature:addDamageCondition(target, CONDITION_CURSED, DAMAGELIST_EXPONENTIAL_DAMAGE, damage)
	end
	return true
end

spell:name("blightwalker curse")
spell:words("###16")
spell:needTarget(false)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:register()
