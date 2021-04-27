local destructionSummonDelay = false

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_NONE)

local area = createCombatArea(AREA_CIRCLE2X2)
combat:setArea(area)

local function removeDelay()
	destructionSummonDelay = false
end

function onCastSpell(creature, var)

	if destructionSummonDelay == false then
		if destructionSummon < 3 then
			Game.createMonster("Disruption", {x=creature:getPosition().x+math.random(-1, 1), y=creature:getPosition().y+math.random(-1, 1), z=creature:getPosition().z}, false, true)
			destructionSummon = destructionSummon + 1

			destructionSummonDelay = true
			addEvent(removeDelay, 15000)
		end
	end

	return combat:execute(creature, var)
end
