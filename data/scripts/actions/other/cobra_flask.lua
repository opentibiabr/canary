local cobraFlask = Action()

function cobraFlask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if (item.itemid == 36132) and (target.itemid == 3007) then
		item:transform(36131)
		target:transform(3008)
		target:decay()
		return
	elseif (item.itemid == 36131) and ((target.itemid == 36119) or (target.itemid == 36120) or (target.itemid == 36121) or (target.itemid == 36122)) then 
		doSendMagicEffect(target:getPosition(), CONST_ME_GREENSMOKE)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You carefully pour just a tiny, little, finely dosed... and there goes the whole content of the bottle. Stand back!")
		item:transform(36132)
		setGlobalStorageValue(GlobalStorage.CobraBastionFlask, os.time() + 1800) -- 30 minutes
	end
	return
end

cobraFlask:id(36131, 36132)
cobraFlask:register()
