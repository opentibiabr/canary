local rottinWoodCorpse = Action()
function rottinWoodCorpse.onUse(cid, item, fromPosition, itemEx, toPosition, isHotkey)
	if(item.itemid == 13176) then
			if(getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03) == 5) and getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Corpse) < 4 then
			doCreatureSay(cid, "You take no more gold than you actually need and release the merchant who makes away the very second you remove the ropes.", TALKTYPE_ORANGE_1)
			doPlayerAddItem(cid, 2148, 100)
			doRemoveItem(item.uid, 1)
			setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Corpse, getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Corpse) + 1)
	      end
	end
	return true
end

rottinWoodCorpse:id(13176)
rottinWoodCorpse:register()