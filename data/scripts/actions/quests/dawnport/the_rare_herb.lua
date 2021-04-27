local theRareHerb = Action()

function theRareHerb.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local setting = ItemUnique[item.uid]
	if setting then
		if player:getStorageValue(Storage.Quest.Dawnport.TheRareHerb) == 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You harvested some of the herb's flower buds. Bring them Morris for a reward.")
			player:setStorageValue(Storage.Quest.Dawnport.TheRareHerb, 2)
		else
			return false
		end
	end
	return true
end

theRareHerb:uid(40027)
theRareHerb:register()
