local mossmasherFigurine = Action()

function mossmasherFigurine.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getVocation():getBaseId() ~= VOCATION.BASE_ID.DRUID then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only druids can use this item.")
		return true
	end
	if player:getLevel() < 200 and not player:isPremium() then
		return true
	end
	if player:getFamiliarLooktype() == 0 then
		player:setFamiliarLooktype(1364) -- Mossmasher looktype
	end
	if not player:hasFamiliar(1364) then
		player:addFamiliar(1364) -- Mossmasher looktype
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have summoned a Mossmasher.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have a Mossmasher.")
	end
	item:remove(1)
	return true
end

mossmasherFigurine:id(35591)
mossmasherFigurine:register()
