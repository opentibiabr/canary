local removeFrags = Action()

function removeFrags.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not isInArray({ SKULL_RED, SKULL_BLACK }, player:getSkull()) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Esse Item remove RED SKULL ou BLACK SKULL!")
		return true
	end
	if not getTileInfo(player:getPosition()).protection then
		player:sendTextMessage(MESSAGE_TRADE, "You should be in PROTECTION ZONE.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	player:setSkull(0)
	player:setSkullTime(0)
	item:remove(1)
	removeFragsFromPlayer(player)
	return true
end

removeFrags:id(37338)
removeFrags:register()
