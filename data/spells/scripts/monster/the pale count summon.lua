local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BATS)

local area = createCombatArea(AREA_SQUARE1X1)
combat:setArea(area)

local maxsummons = 4

function onCastSpell(creature, var)
	creature:say("Out of the dark I call you, fiend in the night!", TALKTYPE_ORANGE_1)
	local summoncount = creature:getSummons()
	if #summoncount < 4 then
		for i = 1, maxsummons - #summoncount do
			local mid = Game.createMonster("Nightfiend", { x=creature:getPosition().x+math.random(-2, 2), y=creature:getPosition().y+math.random(-2, 2), z=creature:getPosition().z })
    		if not mid then
				return
			end
			mid:setMaster(creature)
		end
	end
	return combat:execute(creature, var)
end
