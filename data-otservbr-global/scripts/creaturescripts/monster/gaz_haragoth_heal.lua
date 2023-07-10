local condition = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
condition:setParameter(CONDITION_PARAM_SUBID, 88888)
condition:setParameter(CONDITION_PARAM_TICKS, 7 * 1000)
condition:setParameter(CONDITION_PARAM_HEALTHGAIN, 0.01)
condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 7 * 1000)

local gazHaragothHeal = CreatureEvent("GazHaragothHeal")
function gazHaragothHeal.onThink(creature)
	local hp = (creature:getHealth()/creature:getMaxHealth())*100
	if (hp < 12.5 and not creature:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT, 88888)) then
		creature:addCondition(condition)
		creature:say("Gaz'haragoth begins to draw on the nightmares to HEAL himself!", TALKTYPE_ORANGE_2)
		addEvent(function(cid)
			local creature = Creature(cid)
			if not creature then
				return
			end
			creature:addHealth(300000)
			creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			creature:say("Gaz'haragoth HEALS himself!", TALKTYPE_ORANGE_2)
			return true
		end, 7000, creature:getId())
	end
end
gazHaragothHeal:register()
