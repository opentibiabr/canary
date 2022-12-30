local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_TELEPORT)

local area = createCombatArea(AREA_WAVE11)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("aftershock wave")
spell:words("###448")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()