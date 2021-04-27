local crystaldeepling = Action()
function crystaldeepling.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local posMonster = player:getPosition()
		if player:getStorageValue(Storage.DeeplingsWorldChange.Crystal) == 1 then
            		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Suddenly a guard jumps at you from behind!")
			Game.createMonster("Deepling Guard", posMonster)
			player:setStorageValue(Storage.DeeplingsWorldChange.Crystal, 2)
		elseif player:getStorageValue(Storage.DeeplingsWorldChange.Crystal) == 2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You gathered nothing more than some small chips of red gem.")
			player:setStorageValue(Storage.DeeplingsWorldChange.Crystal, 3)
		elseif player:getStorageValue(Storage.DeeplingsWorldChange.Crystal) == 3 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"With considerable effort you manage to knock a largely unscathed rough gem out of the rocks.")
			player:addItem(15565, 1)
			player:setStorageValue(Storage.DeeplingsWorldChange.Crystal, 4)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Sorry.")
		end
    return true
end
crystaldeepling:aid(28570)
crystaldeepling:register()
