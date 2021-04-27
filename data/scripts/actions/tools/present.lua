local present = Action()

function present.onUse(cid, item, fromPosition, itemEx, toPosition)
	if(item.itemid == 13158) then
		if(itemEx.itemid == 13159) then
			if(getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03) == 1) then
			doRemoveItem(item.uid, 1)
			doRemoveItem(itemEx.uid, 1)
			doPlayerAddItem(cid, 13160, 1)
		   end
	      end
	end
	return true
end

present:id(13158)
present:register()
