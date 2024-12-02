local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_STUN)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_NONE)

local condition = Condition(CONDITION_INTENSEHEX)
condition:setParameter(CONDITION_PARAM_TICKS, 3000)
combat:addCondition(condition)

local spell = Spell("instant")

local zone = Zone("soulpit")

function spell.onCastSpell(creature, var)
	if not zone:isInZone(creature:getPosition()) or creature:getForgeStack() ~= 40 then
		return true
	end

	return combat:execute(creature, var)
end

spell:name("soulpit intensehex")
spell:words("###940")
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()
