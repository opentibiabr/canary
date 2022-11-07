local cobraFlask = Action()

function cobraFlask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if (item.itemid == 31297) and (target.itemid == 4188) then
		item:transform(31296)
		target:transform(4189)
		target:decay()
		return
	elseif (item.itemid == 31296) and ((target.itemid == 31284) or (target.itemid == 31285) or (target.itemid == 31286) or (target.itemid == 31287)) then 
		doSendMagicEffect(target:getPosition(), CONST_ME_GREENSMOKE)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You carefully pour just a tiny, little, finely dosed... and there goes the whole content of the bottle. Stand back!")
		item:transform(31297)
		setGlobalStorageValue(GlobalStorage.CobraBastionFlask, os.time() + 1800) -- 30 minutes
	end
	return
end

cobraFlask:id(31296, 31297)
cobraFlask:register()
