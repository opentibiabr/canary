local staminaRefill = Action()
function staminaRefill.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local stamina = player:getStamina()
	if stamina >= 2520 then
		player:sendCancelMessage("You have a full stamina.")
		return true
	end
	player:setStamina(math.min(2520, stamina + 12000))
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:sendCancelMessage("You have regenerate 2 hours of stamina.")
	item:remove(1)
	return true
end

staminaRefill:id(44740)
staminaRefill:register()
