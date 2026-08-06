local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({ lookTypeEx = 111 })
condition:setTicks(1000)
local barbarianMead = Action()
function barbarianMead.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local questline = player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline)
	local totalSips = player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.MeadTotalSips)
	if questline >= 3 then
		player:say("You already passed the test, no need to torture yourself anymore.", TALKTYPE_MONSTER_SAY)
	elseif questline == 2 and totalSips < 20 then
		if math.random(5) > 1 then
			player:say("The world seems to spin but you manage to stay on your feet.", TALKTYPE_MONSTER_SAY)
			local successSips = math.max(player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.MeadSuccessSips), 0) + 1
			player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.MeadSuccessSips, successSips)
			if successSips >= 10 then
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
		player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.MeadTotalSips, totalSips + 1)
	elseif (questline == 1 or questline == 2) and totalSips >= 20 then
		player:say("Ask Sven for another round.", TALKTYPE_MONSTER_SAY)
		player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline, 1)
		player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.Mission01, 1) -- Questlog Barbarian Test Quest Barbarian Test 1: Barbarian Booze
	end
	return true
end

barbarianMead:position({ x = 32201, y = 31154, z = 7 })
barbarianMead:register()
