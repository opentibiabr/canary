local function sendSleepEffect(position)
	position:sendMagicEffect(CONST_ME_SLEEP)
end

local barbarianHorn = Action()
function barbarianHorn.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid == 3110 and item.itemid == 7140 then
		player:say('You fill your horn with ale.', TALKTYPE_MONSTER_SAY)
		item:transform(7141)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif target.itemid == 7174 and item.itemid == 7141 then
		player:say('The bear is now unconcious.', TALKTYPE_MONSTER_SAY)
		item:transform(7140)
		target:transform(7175)
		toPosition:sendMagicEffect(CONST_ME_STUN)
	elseif item.itemid == 7175 then
		if player:getStorageValue(Storage.BarbarianTest.Questline) == 4 then
			player:say('You hug the unconcious bear.', TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.BarbarianTest.Questline, 5)
			player:setStorageValue(Storage.BarbarianTest.Mission02, 2) -- Questlog Barbarian Test Quest Barbarian Test 2: The Bear Hugging
			player:addAchievement('Bearhugger')
			item:transform(7174)
			toPosition:sendMagicEffect(CONST_ME_SLEEP)
		else
			player:say('You don\'t feel like hugging an unconcious bear.', TALKTYPE_MONSTER_SAY)
		end
	elseif item.itemid == 7174 then
		player:say('Grr.', TALKTYPE_MONSTER_SAY)
		player:say('The bear is not amused by the disturbance.', TALKTYPE_MONSTER_SAY)
		doAreaCombatHealth(player, COMBAT_PHYSICALDAMAGE, player:getPosition(), 0, -10, -30, CONST_ME_POFF)
	elseif item.itemid == 7176 then
		if player:getStorageValue(Storage.BarbarianTest.Questline) == 6 then
			if player:getCondition(CONDITION_DRUNK) then
				player:say('You hustle the mammoth. What a fun. *hicks*.', TALKTYPE_MONSTER_SAY)
				player:setStorageValue(Storage.BarbarianTest.Questline, 7)
				player:setStorageValue(Storage.BarbarianTest.Mission03, 2) -- Questlog Barbarian Test Quest Barbarian Test 3: The Mammoth Pushing
				item:transform(7177)
				item:decay()
				addEvent(sendSleepEffect, 60 * 1000, toPosition)
				toPosition:sendMagicEffect(CONST_ME_SLEEP)
			else
				player:say('You are not drunk enought to hustle a mammoth.', TALKTYPE_MONSTER_SAY)
			end
		end
	end
	return true
end

barbarianHorn:id(7140,7141,7174,7175,7176)
barbarianHorn:register()