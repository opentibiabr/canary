local gravediggerAmforas = Action()
function gravediggerAmforas.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission05) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission06) ~= 1 then
		local chances = math.random(30)
		if chances == 13 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission06,1)
			player:say("You've got an amazing heart!", TALKTYPE_MONSTER_SAY)
			player:getPosition():sendMagicEffect(CONST_ME_HEARTS)
			player:addItem(21394,1)
		else
			player:say("Keep it trying!", TALKTYPE_MONSTER_SAY)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	else
		player:say("You've already got your heart", TALKTYPE_MONSTER_SAY)
	end
	return true
end

gravediggerAmforas:aid(4630)
gravediggerAmforas:register()