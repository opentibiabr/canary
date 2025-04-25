local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SNOWBALL)
combat:setArea(createCombatArea(AREA_CIRCLE1X1))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("quararaidershoot")
spell:words("###raider_shoot")
spell:needLearn(true)
spell:needTarget(true)
spell:register()
