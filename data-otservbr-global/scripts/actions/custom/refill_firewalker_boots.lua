local refillFirewalker = Action()

local config = {
	wormId = 9020,
	newId = 9019,
	value = 12000,
}

function refillFirewalker.onUse(player, item, fromPosition, target, toPosition, isHotkey)
  
	if player:getItemCount(config.wormId) >= 1 then
		if player:removeMoney(config.value) or player:removeMoneyBank(config.value) then
			player:removeItem(config.wormId, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:addItem(config.newId, 1) -- id new 
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You charged a firewalker boots successfully.")
		else
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			player:sendCancelMessage("You do not have enough money!")
		end
	else
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendCancelMessage("You do not have a worm firewalker boots!")
	end
	
	return true
end



refillFirewalker:id(9020)
refillFirewalker:register()