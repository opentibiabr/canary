local present = Action()

function present.onUse(cid, item, fromPosition, itemEx, toPosition)
	if(item.itemid == 12171) then
		if(itemEx.itemid == 12172) then
			if(getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03) == 1) then
			doRemoveItem(item.uid, 1)
			doRemoveItem(itemEx.uid, 1)
			doPlayerAddItem(cid, 12173, 1)
		   end
	      end
	end
	return true
end

present:id(12171)
present:register()
