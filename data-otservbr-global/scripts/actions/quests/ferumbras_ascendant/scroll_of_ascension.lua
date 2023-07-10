local ferumbrasAscendantScroll = Action()
function ferumbrasAscendantScroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local outfit = {lookType = 35}
	if item.itemid == 22771 then
		doSetCreatureOutfit(player, outfit, 30 * 1000)
		item:transform(22772)
		item:decay()
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Magical sparks whirl around the scroll as you read and then your appearance is changing.')
		return true
	elseif item.itemid == 22772 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You are tired of the last scroll reading, rest your eyes for a moment.')
	end
	return true
end

ferumbrasAscendantScroll:id(22771,22772)
ferumbrasAscendantScroll:register()