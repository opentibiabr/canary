local ferumbrasAscendantColorLevers = Action()
function ferumbrasAscendantColorLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FirstDoor) >= 1 then
		item:transform(item.itemid == 9125 and 9126 or 9125)
		return true
	end
	if item.actionid == 54381 then
		if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.ColorLever) < 1 then
			local rand = math.random(4)
			player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.ColorLever, rand)
			player:getPosition():sendMagicEffect(166 + rand)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You choose the colour of decay.")
		end
	elseif item.actionid == 54382 then
		if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.ColorLever) == 1 then
			player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FirstDoor, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You select the correct colour.")
			toPosition:sendMagicEffect(CONST_ME_POFF)
		end
	elseif item.actionid == 54383 then
		if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.ColorLever) == 3 then
			player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FirstDoor, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You select the correct colour.")
			toPosition:sendMagicEffect(CONST_ME_POFF)
		end
	elseif item.actionid == 54384 then
		if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.ColorLever) == 4 then
			player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FirstDoor, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You select the correct colour.")
			toPosition:sendMagicEffect(CONST_ME_POFF)
		end
	elseif item.actionid == 54385 then
		if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.ColorLever) == 2 then
			player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FirstDoor, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You select the correct colour.")
			toPosition:sendMagicEffect(CONST_ME_POFF)
		end
	end
	item:transform(item.itemid == 9125 and 9126 or 9125)
	return true
end

ferumbrasAscendantColorLevers:aid(54381, 54382, 54383, 54384, 54385)
ferumbrasAscendantColorLevers:register()
