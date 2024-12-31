local gravediggerSacrifice = Action()
function gravediggerSacrifice.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission74) == 1 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission75) < 1 then
		local skullItem = Tile(Position(33015, 32418, 11)):getItemById(19160)
		if skullItem then
			skullItem:remove()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The scroll burns to dust. The magic stutters. Omrabas' soul flees to his old hideaway.")
			player:removeItem(18934, 1)
			player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission75, 1)
			Game.createMonster("Chicken", Position(33015, 32418, 11))
		end
	end
	return true
end

gravediggerSacrifice:id(18934)
gravediggerSacrifice:register()
