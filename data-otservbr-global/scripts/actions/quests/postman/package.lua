local postmanPackage = Action()
function postmanPackage.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 101 and target.itemid == 3221 then
		if player:getStorageValue(Storage.Postman.Mission09) == 2 then
			player:setStorageValue(Storage.Postman.Mission09, 3)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
			item:transform(2859)
		end
	end
	return true
end

postmanPackage:id(3217)
postmanPackage:register()