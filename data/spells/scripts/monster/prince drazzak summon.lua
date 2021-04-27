function onCastSpell(creature, var)
local t, spectator = Game.getSpectators(Position(33528, 32335, 12), false, false, 20, 20, 20, 20)
    local check = 0
    if #t ~= nil then
        for i = 1, #t do
		spectator = t[i]
            if spectator:getName() == "Demon" then
               check = check + 1
            end
        end
    end
	if (check < 1) then
		creature:say("CRUSH THEM ALL!", TALKTYPE_ORANGE_2)
		Game.createMonster("Demon", Position(33528, 32330, 12))
		Game.createMonster("Demon", Position(33523, 32338, 12))
		Game.createMonster("Demon", Position(33532, 32337, 12))
		else
	end
return true
end
