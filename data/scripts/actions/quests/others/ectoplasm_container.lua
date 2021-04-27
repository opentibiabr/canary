local othersEctoplasm = Action()
function othersEctoplasm.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 4206 then
		if player:getStorageValue(Storage.TibiaTales.IntoTheBonePit) ~= 1 then
			return false
		end

		player:setStorageValue(Storage.TibiaTales.IntoTheBonePit, 2)
		item:transform(4864)
		target:remove()
		toPosition:sendMagicEffect(CONST_ME_POFF)
	elseif target.itemid == 3108 then
		if player:getStorageValue(Storage.ExplorerSociety.TheEctoplasm) == 45 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 45 then
			player:setStorageValue(Storage.ExplorerSociety.TheEctoplasm, 46)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 46)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			item:transform(8182)
			target:remove()
		end
	end
	return true
end

othersEctoplasm:id(4863)
othersEctoplasm:register()