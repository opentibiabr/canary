local condition = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
condition:setParameter(CONDITION_PARAM_SUBID, 88888)
condition:setParameter(CONDITION_PARAM_TICKS, 30 * 1000)
condition:setParameter(CONDITION_PARAM_HEALTHGAIN, 0.01)
condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 30 * 1000)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if creature:getHealth() < creature:getMaxHealth() * 0.1 and not creature:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT, 88888) then
		creature:addCondition(condition)
		addEvent(function(cid)
			creature:addHealth(math.random(7500, 8000))
			creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			return true
		end, 10 * 1000, creature:getId())
	end
	return true
end

spell:name("glooth fairy healing")
spell:words("###384")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()