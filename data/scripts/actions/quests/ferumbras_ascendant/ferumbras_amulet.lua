local ferumbrasAscendantAmulet = Action()
function ferumbrasAscendantAmulet.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
	if amulet ~= item or amulet ~= item then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need to equip the amulet to try use it.')
		return true
	end
	if item.itemid == 25423 then
		if math.random(2) == 1 then
			player:addHealth(1000, true, true)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Magical sparks whirl around the amulet as you use it and you was healed.')
		else
			player:addMana(1000, true, true)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Magical sparks whirl around the amulet as you use it and you was restored.')
		end
		item:transform(25424)
		item:decay()
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return true
	elseif item.itemid == 25424 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You are tired of the last use of the amulet, you must wait for the recharge.')
	end
	return true
end

ferumbrasAscendantAmulet:id(25423,25424)
ferumbrasAscendantAmulet:register()