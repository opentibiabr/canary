local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({ lookTypeEx = 111 })
condition:setTicks(1000)
local barbarianMead = Action()
function barbarianMead.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline) == 2 and player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.MeadTotalSips) <= 20 then
		if math.random(5) > 1 then
			player:say("The world seems to spin but you manage to stay on your feet.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.MeadSuccessSips, player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.MeadSuccessSips) + 1)
			if player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.MeadSuccessSips) == 9 then -- 9 sips here cause local player at start
				player:say("10 sips in a row. Yeah!", TALKTYPE_MONSTER_SAY)
				player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline, 3)
				player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.Mission01, 3) -- Questlog Barbarian Test Quest Barbarian Test 1: Barbarian Booze
				return true
			end
		else
			player:say("The mead was too strong. You passed out for a moment.", TALKTYPE_MONSTER_SAY)
			player:addCondition(condition)
			player:getPosition():sendMagicEffect(CONST_ME_HITBYPOISON)
			player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.MeadSuccessSips, 0)
		end
		player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.MeadTotalSips, player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.MeadTotalSips) + 1)
	elseif player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.MeadTotalSips) > 20 then
		player:say("Ask Sven for another round.", TALKTYPE_MONSTER_SAY)
		player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline, 1)
		player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.Mission01, 1) -- Questlog Barbarian Test Quest Barbarian Test 1: Barbarian Booze
	elseif player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline) >= 3 then
		player:say("You already passed the test, no need to torture yourself anymore.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

barbarianMead:position({ x = 32201, y = 31154, z = 7 })
barbarianMead:register()
