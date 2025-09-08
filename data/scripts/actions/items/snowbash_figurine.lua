local snowbashFigurine = Action()

function snowbashFigurine.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getVocation():getBaseId() ~= VOCATION.BASE_ID.KNIGHT then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only knights can use this item.")
		return true
	end
	if player:getLevel() < 200 and not player:isPremium() then
		return true
	end
	if player:getFamiliarLooktype() == 0 then
		player:setFamiliarLooktype(1365) -- Snowbash looktype
	end
	if not player:hasFamiliar(1365) then
		player:addFamiliar(1365) -- Snowbash looktype
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have summoned a Snowbash.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have a Snowbash.")
	end
	item:remove(1)
	return true
end

snowbashFigurine:id(35589)
snowbashFigurine:register()
