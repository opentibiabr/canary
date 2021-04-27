local condition = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
condition:setParameter(CONDITION_PARAM_SUBID, 88888)
condition:setParameter(CONDITION_PARAM_TICKS, 5 * 1000)
condition:setParameter(CONDITION_PARAM_HEALTHGAIN, 0.01)
condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 5 * 1000)

function boom(cid)
	local creature = Creature(cid)
	if not creature then
		return
	end
	creature:say("OMRAFIR EXPLODES INTO FLAMES!", TALKTYPE_ORANGE_2)
	Game.setStorageValue(112416, Game.getStorageValue(112416) + 1)
	creature:getPosition():sendMagicEffect(CONST_ME_FIREATTACK)
	for i = 1, 9 do
		Game.createMonster("Hellfire Fighter", Position(33589 + math.random(-8,8), 32379 + math.random(-9,9), 12), true, true)
		creature:remove()
	end
	return true
end

local omrafirExplode = CreatureEvent("OmrafirExplode")
function omrafirExplode.onThink(creature)
	local hp = (creature:getHealth()/creature:getMaxHealth())*100
	local summons = creature:getSummons()
	if hp <= 50 and #summons < 4 and not creature:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT, 88888) and
				Game.getStorageValue(112416) < 2 then
		addEvent(boom, 10, creature:getId())
		addEvent(function(cid)
			Game.createMonster("Omrafir", Position(33586, 32379, 12), false, true)
		end, 30000, creature:getId())
	elseif hp <= 3 and not creature:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT, 88888) then
		addEvent(boom, 10, creature:getId())
		addEvent(function(cid)
			local summon = Game.createMonster("Omrafir2", Position(33586, 32379, 12), false, true)
			summon:say("OMRAFIR REFORMS HIMSELF WITH NEW STRENGTH!", TALKTYPE_ORANGE_2)
		end, 30000, creature:getId())
	end
	return true
end
omrafirExplode:register()
