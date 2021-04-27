local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_NONE)

local area = createCombatArea(AREA_SQUARE1X1)
combat:setArea(area)

local maxsummons = 5

function onCastSpell(creature, var)
	local summoncount = creature:getSummons()
	if #summoncount < 5 then
		for i = 1, maxsummons - #summoncount do
			creature:addHealth(500)
			creature:getPosition():sendMagicEffect(12)
			local mid = Game.createMonster("Chest Guard", { x=creature:getPosition().x+math.random(-2, 2), y=creature:getPosition().y+math.random(-2, 2), z=creature:getPosition().z })
    		if not mid then
				return
			end
			mid:say("FREEZE! LET ME SEE YOUR HANDS UP!", TALKTYPE_ORANGE_2)
		end
	end
return combat:execute(creature, var)
end
