local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLCLOUDS)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_DEATH)
combat:setArea(createCombatArea(AREA_SQUAREWAVE7))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local damage = math.random(154, 266)
	for _, target in ipairs(combat:getTargets(creature, var)) do
		creature:addDamageCondition(target, CONDITION_CURSED, DAMAGELIST_EXPONENTIAL_DAMAGE, damage)
	end
	return true
end

spell:name("undead dragon curse")
spell:words("###10")
spell:needTarget(false)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:needDirection(true)
spell:register()
