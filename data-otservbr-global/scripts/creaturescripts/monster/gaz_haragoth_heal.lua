local condition = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
condition:setParameter(CONDITION_PARAM_SUBID, 88888)
condition:setParameter(CONDITION_PARAM_TICKS, 7 * 1000)
condition:setParameter(CONDITION_PARAM_HEALTHGAIN, 0.01)
condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 7 * 1000)

local gazHaragothHeal = CreatureEvent("GazHaragothHeal")
function gazHaragothHeal.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature then
		return true
	end
	local creatureName = creature:getName():lower() == "gaz'haragoth"
	if creatureName then
		if attacker then
			local hp = (creature:getHealth() / creature:getMaxHealth()) * 100
			if hp > 12.5 then
				return primaryDamage, primaryType, secondaryDamage, secondaryType
			end
			if hp <= 12.5 and not creature:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT, 88888) then
				if not creature then
					return true
				end
				creature:addCondition(condition)
				creature:say("Gaz'haragoth begins to draw on the nightmares to HEAL himself!", TALKTYPE_MONSTER_YELL)
				addEvent(function()
					if not creature then
						return true
					end
					creature:addHealth(300000)
					creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
					creature:say("Gaz'haragoth HEALS himself!", TALKTYPE_MONSTER_YELL)
					return true
				end, 7000, creature:getId())
			end
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

gazHaragothHeal:register()
