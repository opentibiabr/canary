local inServiceYalaharWest = Action()
function inServiceYalaharWest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if(item.uid == 3081) then
		if(player:getStorageValue(Storage.InServiceofYalahar.Questline) >= 24) then
			if(item.itemid == 5288) then
				player:teleportTo(toPosition, true)
				item:transform(5289)
				player:setStorageValue(Storage.InServiceofYalahar.MrWestDoor, 1)
			end
		end
	elseif(item.uid == 3082) then
		if(player:getStorageValue(Storage.InServiceofYalahar.Questline) >= 24) then
			if(item.itemid == 6261) then
				player:teleportTo(toPosition, true)
				item:transform(6262)
				player:setStorageValue(Storage.InServiceofYalahar.MrWestDoor, 2)
			end
		end
	end
	return true
end

inServiceYalaharWest:uid(3081,3082)
inServiceYalaharWest:register()