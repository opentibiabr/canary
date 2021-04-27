local barbarianMead = Action()
function barbarianMead.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.BarbarianTest.Questline) == 2 and player:getStorageValue(Storage.BarbarianTest.MeadTotalSips) <= 20 then
		if math.random(5) > 1 then
			player:say('The world seems to spin but you manage to stay on your feet.', TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.BarbarianTest.MeadSuccessSips, player:getStorageValue(Storage.BarbarianTest.MeadSuccessSips) + 1)
			if player:getStorageValue(Storage.BarbarianTest.MeadSuccessSips) == 9 then -- 9 sips here cause local player at start
				player:say('10 sips in a row. Yeah!', TALKTYPE_MONSTER_SAY)
				player:setStorageValue(Storage.BarbarianTest.Questline, 3)
				player:setStorageValue(Storage.BarbarianTest.Mission01, 3) -- Questlog Barbarian Test Quest Barbarian Test 1: Barbarian Booze
				return true
			end
		else
			player:say('The mead was too strong. You passed out for a moment.', TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.BarbarianTest.MeadSuccessSips, 0)
		end
		player:setStorageValue(Storage.BarbarianTest.MeadTotalSips, player:getStorageValue(Storage.BarbarianTest.MeadTotalSips) + 1)
	elseif player:getStorageValue(Storage.BarbarianTest.MeadTotalSips) > 20 then
		player:say('Ask Sven for another round.', TALKTYPE_MONSTER_SAY)
		player:setStorageValue(Storage.BarbarianTest.Questline, 1)
		player:setStorageValue(Storage.BarbarianTest.Mission01, 1) -- Questlog Barbarian Test Quest Barbarian Test 1: Barbarian Booze
	elseif player:getStorageValue(Storage.BarbarianTest.Questline) >= 3 then
		player:say('You already passed the test, no need to torture yourself anymore.', TALKTYPE_MONSTER_SAY)
	end
	return true
end

barbarianMead:uid(3110)
barbarianMead:register()