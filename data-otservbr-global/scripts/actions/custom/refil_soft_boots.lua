local refillSoftBoots = Action()

local config = {
	wormSoftId = 6530,
	newSoftId = 6529,
	value = 12000,
}

function refillSoftBoots.onUse(player, item, fromPosition, target, toPosition, isHotkey)
  
	if player:getItemCount(config.wormSoftId) >= 1 then
		if player:removeMoney(config.value) or player:removeMoneyBank(config.value) then
			player:removeItem(config.wormSoftId, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:addItem(config.newSoftId, 1) -- id new soft boots
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You charged a soft boots successfully.")
		else
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			player:sendCancelMessage("You do not have enough money!")
		end
	else
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendCancelMessage("You do not have worn soft boots!")
	end
	
	return true
end



refillSoftBoots:id(6530)
refillSoftBoots:register()