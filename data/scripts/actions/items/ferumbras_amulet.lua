local ferumbrasAscendantAmulet = Action()

function ferumbrasAscendantAmulet.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
	if amulet ~= item then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to equip the amulet to try use it.")
		return true
	end

	if item.itemid == 22767 then
		if math.random(2) == 1 then
			player:addHealth(1000, true, true)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Magical sparks whirl around the amulet as you use it and you was healed.")
		else
			player:addMana(1000, true, true)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Magical sparks whirl around the amulet as you use it and you was restored.")
		end

		item:transform(22768)
		item:decay()
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif item.itemid == 22768 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are tired of the last use of the amulet, you must wait for the recharge.")
	end
	return true
end

ferumbrasAscendantAmulet:id(22767, 22768)
ferumbrasAscendantAmulet:register()
