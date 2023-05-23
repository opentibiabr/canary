local spell = Spell("instant")

function spell.onCastSpell(creature, var)
local t, spectator = Game.getSpectators(creature:getPosition(), false, false, 50, 50, 50, 50)
    local check = 0
    if #t ~= nil then
        for i = 1, #t do
		spectator = t[i]
            if spectator:getName() == "Egg" or spectator:getName() == "Spawn Of The Welter" then
               check = check + 1
            end
        end
    end
	if (check < 10) then
		creature:getPosition():sendMagicEffect(CONST_ME_GREEN_RINGS)
		Game.createMonster("Egg", creature:getPosition(), false, true)
		else
	end
return true
end

spell:name("the welter summon2")
spell:words("###338")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()