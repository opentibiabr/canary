local function sendSleepEffect(position)
	position:sendMagicEffect(CONST_ME_SLEEP)
end

local barbarianHorn = Action()

function barbarianHorn.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 7140 and Tile(Position(32201, 31154, 7)):getItemById(7142) then
		player:say("You fill your horn with ale.", TALKTYPE_MONSTER_SAY)
		item:transform(7141)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif item.itemid == 7141 and Tile(Position(32253, 31049, 5)):getItemById(7174) then
		local targetItem = Tile(Position(32253, 31049, 5)):getItemById(7174)
		if targetItem then
			player:say("The bear is now unconscious.", TALKTYPE_MONSTER_SAY)
			targetItem:transform(7175)
			toPosition:sendMagicEffect(CONST_ME_STUN)
		end
	elseif item.itemid == 7175 then
		if player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline) == 4 then
			player:say("You hug the unconcious bear.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline, 5)
			player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.Mission02, 2) -- Questlog Barbarian Test Quest Barbarian Test 2: The Bear Hugging
			player:addAchievement("Bearhugger")
			item:transform(7174)
			toPosition:sendMagicEffect(CONST_ME_SLEEP)
		else
			player:say("You don't feel like hugging an unconcious bear.", TALKTYPE_MONSTER_SAY)
		end
	elseif item.itemid == 7174 then
		player:say("Grr.", TALKTYPE_MONSTER_SAY)
		player:say("The bear is not amused by the disturbance.", TALKTYPE_MONSTER_SAY)
		doAreaCombatHealth(player, COMBAT_PHYSICALDAMAGE, player:getPosition(), 0, -10, -30, CONST_ME_POFF)
	elseif item.itemid == 7176 then
		if player:getStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline) == 6 then
			if player:getCondition(CONDITION_DRUNK) then
				player:say("You hustle the mammoth. What a fun. *hicks*.", TALKTYPE_MONSTER_SAY)
				player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.Questline, 7)
				player:setStorageValue(Storage.Quest.U8_0.BarbarianTest.Mission03, 2) -- Questlog Barbarian Test Quest Barbarian Test 3: The Mammoth Pushing
				item:transform(7177)
				item:decay()
				addEvent(sendSleepEffect, 60 * 1000, toPosition)
				toPosition:sendMagicEffect(CONST_ME_SLEEP)
			else
				player:say("You are not drunk enought to hustle a mammoth.", TALKTYPE_MONSTER_SAY)
			end
		end
	end
	return true
end

barbarianHorn:id(7140, 7141, 7174, 7175, 7176)
barbarianHorn:register()
