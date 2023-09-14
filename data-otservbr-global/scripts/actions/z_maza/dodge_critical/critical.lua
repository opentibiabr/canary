local critical_script = Action()
function critical_script.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	
	local qntCrit = player:getCriticalLevel(player)
	local pPos = player:getPosition()
	local effect = 32
	local soma = qntCrit + 1
	
	if qntCrit == 100 then
		player:sendTextMessage(MESSAGE_STATUS, "Full Critical!")
		pPos:sendMagicEffect(3)
	else
		player:setCriticalLevel(soma)
		pPos:sendMagicEffect(effect)
		item:remove(1)
	end
	
	
	return true
end
critical_script:id(38639)
critical_script:register()
