local blueberryCupcake = Action()

function blueberryCupcake.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("blueberry-cupcake-cooldown") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	player:addMana(player:getMaxMana())
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your mana has been refilled.")
	player:say("Mmmm.", TALKTYPE_MONSTER_SAY)
	player:setExhaustion("blueberry-cupcake-cooldown", 10 * 60)
	item:remove(1)
	return true
end

blueberryCupcake:id(28484)
blueberryCupcake:register()
