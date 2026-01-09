local sandscourgeFigurine = Action()

function sandscourgeFigurine.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getVocation():getBaseId() ~= VOCATION.BASE_ID.PALADIN then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only paladins can use this item.")
		return true
	end
	if player:getLevel() < 200 and not player:isPremium() then
		return true
	end
	if player:getFamiliarLooktype() == 0 then
		player:setFamiliarLooktype(1366) -- Sandscourge looktype
	end
	if not player:hasFamiliar(1366) then
		player:addFamiliar(1366) -- Sandscourge looktype
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have summoned a Sandscourge.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have a Sandscourge.")
	end
	item:remove(1)
	return true
end

sandscourgeFigurine:id(35590)
sandscourgeFigurine:register()
