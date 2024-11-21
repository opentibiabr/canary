local ferumbrasAscendantManaKeg = Action()

function ferumbrasAscendantManaKeg.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 22769 then
		player:addItem("ultimate mana potion", 10)
		item:transform(22770)
		item:decay()
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Magical sparks whirl around the keg as you open the spigot and you fill ten empty vials with mana fluid.")
		return true
	elseif item.itemid == 22770 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are tired of the last use of the mana keg, rest your arms for a moment.")
	end
	return true
end

ferumbrasAscendantManaKeg:id(22769, 22770)
ferumbrasAscendantManaKeg:register()
