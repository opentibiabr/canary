local bladesparkFigurine = Action()

function bladesparkFigurine.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getVocation():getBaseId() ~= VOCATION.BASE_ID.SORCERER then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only sorcerers can use this item.")
		return true
	end
	if player:getLevel() < 200 and not player:isPremium() then
		return true
	end
	if player:getFamiliarLooktype() == 0 then
		player:setFamiliarLooktype(1367) -- Bladespark looktype
	end
	if not player:hasFamiliar(1367) then
		player:addFamiliar(1367) -- Bladespark looktype
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have summoned a Bladespark.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have a Bladespark.")
	end
	item:remove(1)
	return true
end

bladesparkFigurine:id(35592)
bladesparkFigurine:register()
