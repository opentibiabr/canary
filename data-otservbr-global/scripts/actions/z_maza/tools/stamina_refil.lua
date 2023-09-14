local smallstaminarefill = Action()
function smallstaminarefill.onUse(player, item, ...)
    local stamina = player:getStamina()
	
	if player:getStorageValue(44794) >= os.time() then
		player:sendCancelMessage("You have a exaust.")
	return false
	end
	
    if stamina >= 2520 then
        player:sendCancelMessage("You have a full stamina.")
        return true
    end
	player:setStorageValue(44794, os.time() + 5)
    player:setStamina(math.min(2520, stamina + 1200))
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    player:sendCancelMessage("You have regenerate 20 hours of stamina.")
    item:remove(1)
    return true
end

smallstaminarefill:id(33893)
smallstaminarefill:register()