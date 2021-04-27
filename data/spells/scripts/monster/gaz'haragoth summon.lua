function onCastSpell(creature, var)
local t, spectator = Game.getSpectators(creature:getPosition(), false, false, 5, 5, 5, 5)
    local check = 0
    if #t ~= nil then
        for i = 1, #t do
		spectator = t[i]
            if spectator:getName() == "Minion Of Gaz'haragoth" then
               check = check + 1
            end
        end
    end
	local hp = (creature:getHealth()/creature:getMaxHealth())* 100
	if ((check < 2) and hp <= 95) or ((check < 4) and hp <= 75) or ((check < 6) and hp <= 55) or ((check < 10) and hp <= 35) then
		for j = 1, 5 do
			creature:say("Minions! Follow my call!", TALKTYPE_ORANGE_1)
		end
		for k = 1, 2 do
			local monster = Game.createMonster("minion of gaz'haragoth", creature:getPosition(), true, false)
			if not monster then
				return
			end
			creature:getPosition():sendMagicEffect(CONST_ME_SOUND_RED)
		end
		else
	end
return true
end
