local chayenneLever = Action()
function chayenneLever.onUse(cid, item, fromPosition, itemEx, toPosition)
	if item.itemid == 1945 then
		if getGlobalStorageValue(71543) <= os.time() then
			if getPlayerItemCount(cid, 16015) >= 1 then
			doTransformItem(getTileItemById({x = 33080, y = 32582, z = 3},1945).uid,1946)
			doRemoveItem(getTileItemById({x = 33075, y = 32591, z = 3}, 1498).uid, 1)
			setGlobalStorageValue(71543, os.time()+5*60)
			addEvent(Game.createItem, 60*1000, 1498, {x = 33075, y = 32591, z = 3})
		else
			doPlayerSendTextMessage(cid, 19, "You do not have the Chayenne's magical key.")
			end
		else
			doPlayerSendTextMessage(cid, 19, "You need to wait few minutes to use again.")
		end
	elseif item.itemid == 1946 then
		doTransformItem(getTileItemById({x = 33080, y = 32582, z = 3},1946).uid,1945)
	end
end

chayenneLever:aid(55021)
chayenneLever:register()