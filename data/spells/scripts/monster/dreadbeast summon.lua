local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GROUNDSHAKER)

local area = createCombatArea(AREA_SQUARE1X1)
combat:setArea(area)

function onCastSpell(creature, var)
local t, spectator = Game.getSpectators(creature:getPosition(), false, false, 50, 50, 50, 50)
    local check = 0
    if #t ~= nil then
        for i = 1, #t do
		spectator = t[i]
            if spectator:getName() == "Dreadbeast" then
               check = check + 1
            end
        end
    end
	if (check < 10) then
		local summon = Game.createMonster("Dreadbeast", creature:getPosition(), true, false)
		if summon then
		end
		summon:setMaster(creature)
		else
	end
return combat:execute(creature, var)
end
