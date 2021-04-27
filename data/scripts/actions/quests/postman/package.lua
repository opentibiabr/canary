local postmanPackage = Action()
function postmanPackage.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 101 and target.itemid == 2334 then
		if player:getStorageValue(Storage.Postman.Mission09) == 2 then
			player:setStorageValue(Storage.Postman.Mission09, 3)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
			item:transform(1993)
		end
	end
	return true
end

postmanPackage:id(2330)
postmanPackage:register()