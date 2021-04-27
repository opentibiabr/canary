local crystaldeepling = Action()
function crystaldeepling.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local posMonster = player:getPosition()
		if player:getStorageValue(Storage.DeeplingsWorldChange.Crystal) == 9 then
            		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Suddenly a guard jumps at you from behind!")
			Game.createMonster("Deepling Worker", posMonster)
			player:setStorageValue(Storage.DeeplingsWorldChange.Crystal, 10)
		elseif player:getStorageValue(Storage.DeeplingsWorldChange.Crystal) == 10 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Fail.")
			player:setStorageValue(Storage.DeeplingsWorldChange.Crystal, 11)
		elseif player:getStorageValue(Storage.DeeplingsWorldChange.Crystal) == 11 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Yeah.")
			player:addItem(15568, 1)
			player:setStorageValue(Storage.DeeplingsWorldChange.Crystal, 12)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Sorry.")
		end
    return true
end
crystaldeepling:aid(28572)
crystaldeepling:register()
