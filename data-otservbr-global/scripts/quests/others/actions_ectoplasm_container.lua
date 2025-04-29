local othersEctoplasm = Action()

function othersEctoplasm.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 4206 then
		if player:getStorageValue(Storage.Quest.U8_1.TibiaTales.IntoTheBonePit) ~= 1 then
			return false
		end

		player:setStorageValue(Storage.Quest.U8_1.TibiaTales.IntoTheBonePit, 2)
		item:transform(131)
		target:remove()
		toPosition:sendMagicEffect(CONST_ME_POFF)
	elseif target.itemid == 4094 then
		if player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheEctoplasm) == 45 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 45 then
			player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.TheEctoplasm, 46)
			player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 46)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			item:transform(4853)
			target:remove()
		end
	end
	return true
end

othersEctoplasm:id(4852)
othersEctoplasm:register()
