local ferumbrasAscendantHomeComing = Action()
function ferumbrasAscendantHomeComing.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local boots = player:getSlotItem(CONST_SLOT_FEET)
	if boots ~= item or boots ~= item then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need to equip the boot to try use it.')
		return true
	end
	if item.itemid == 25429 then
		if Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE) then
			item:transform(25430)
			item:decay()
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			player:teleportTo(Position(32121, 32708, 7))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Magical sparks whirl around the boots and suddenly you are somewhere else.')
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'If you want to wear this boots you need to stay in a protection zone.')
			return true
		end
	elseif item.itemid == 25430 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You are tired of the last use of the boots, you must wait for one hour to use it again.')
	end
	return true
end

ferumbrasAscendantHomeComing:id(25429,25430)
ferumbrasAscendantHomeComing:register()