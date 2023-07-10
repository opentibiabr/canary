local chayenneLever = Action()

function chayenneLever.onUse(player, item, fromPosition, itemEx, toPosition)
	if item.itemid == 2772 then
		if Game.getStorageValue(Storage.ChayenneKeyTime) > os.time() then
			player:sendTendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait few minutes to use again.")
			return true
		end

		if player:getItemCount(14682) < 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You do not have the Chayenne's magical key.")
			return true
		end

		local tile = Tile({x = 33075, y = 32591, z = 3})
		local item = tile:getItemById(2129)
		if item then
			item:remove(1)
		end
		Game.setStorageValue(Storage.ChayenneKeyTime, os.time() + 5 * 60)
		addEvent(Game.createItem, 60 * 1000, 2129, {x = 33075, y = 32591, z = 3})
		item:transform(2773)
	elseif item.itemid == 2773 then
		item:transform(2772)
	end
end

chayenneLever:aid(55021)
chayenneLever:register()
