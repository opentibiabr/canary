local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.ToothFairy) == 1 and player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.PresentsPlaced) < 3 then
		local pos = toPosition
		local bedStorage = nil
		if pos.x == 32391 and pos.y == 32220 and pos.z == 6 then
			bedStorage = Storage.Quest.U11_40.ThreatenedDreams.Mission04.BedThais
		elseif pos.x == 33001 and pos.y == 32060 and pos.z == 5 then
			bedStorage = Storage.Quest.U11_40.ThreatenedDreams.Mission04.BedVenore
		elseif pos.x == 32328 and pos.y == 31794 and pos.z == 6 then
			bedStorage = Storage.Quest.U11_40.ThreatenedDreams.Mission04.BedCarlin
		end

		if bedStorage then
			if player:getStorageValue(bedStorage) == 1 then
				player:say("You already placed a present here.", TALKTYPE_MONSTER_SAY)
				return false
			end
			player:setStorageValue(bedStorage, 1)
			player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.PresentsPlaced, player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.PresentsPlaced) + 1)
			player:removeItem(25302, 1)
			player:say("You carefully place a present on the bed and grab a milk tooth from under the pillow.", TALKTYPE_MONSTER_SAY)
			player:addItem(25303, 1)
			return true
		end
	end
	return false
end

action:id(25302)
action:register()
