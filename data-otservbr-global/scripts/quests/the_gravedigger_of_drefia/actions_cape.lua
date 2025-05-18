local gravediggerCape = Action()
function gravediggerCape.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission59) == 1 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission60) < 1 then
		player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission60, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You now look like a Necromancer.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:removeItem(19148, 1)
	end
	return true
end

gravediggerCape:id(19148)
gravediggerCape:register()
