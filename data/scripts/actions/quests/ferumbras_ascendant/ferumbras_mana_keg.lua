local ferumbrasAscendantManaKeg = Action()
function ferumbrasAscendantManaKeg.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if item.itemid == 25425 then
		player:addItem('ultimate mana potion', 10)
		item:transform(25426)
		item:decay()
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Magical sparks whirl around the keg as you open the spigot and you fill ten empty vials with mana fluid.')
		return true
	elseif item.itemid == 25426 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You are tired of the last use of the mana keg, rest your arms for a moment.')
	end
	return true
end

ferumbrasAscendantManaKeg:id(25425,25426)
ferumbrasAscendantManaKeg:register()