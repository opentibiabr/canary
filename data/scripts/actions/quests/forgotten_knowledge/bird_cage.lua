local forgottenKnowledgeBird = Action()
function forgottenKnowledgeBird.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 26480 then
		if target:getName():lower() ~= 'cave parrot' then
			return false
		end
		target:getPosition():sendMagicEffect(CONST_ME_POFF)
		target:remove()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The cave parrot may be tough but he somehow couldn\'t resist this particular birdcage. Or maybe it was you...')
		item:transform(26481)
		return true
	elseif item.itemid == 26481 then
		if player:getPosition() ~= Position(32737, 32117, 10) then
			return false
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You open the cage and let the cave parrot roam free!')
		item:transform(26480)
		if player:getStorageValue(Storage.ForgottenKnowledge.BirdCounter) < 0 then
			player:setStorageValue(Storage.ForgottenKnowledge.BirdCounter, 0)
		end
		player:setStorageValue(Storage.ForgottenKnowledge.BirdCounter, player:getStorageValue(Storage.ForgottenKnowledge.BirdCounter) + 1)
	end
	player:getPosition():sendMagicEffect(CONST_ME_HEARTS)
	return true
end

forgottenKnowledgeBird:id(26480,26481)
forgottenKnowledgeBird:register()