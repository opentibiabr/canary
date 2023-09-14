local dodge_script = Action()
function dodge_script.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	
	local qntDodge = player:getDodgeLevel(player)
	local pPos = player:getPosition()
	local effect = 32
	local soma = qntDodge + 1
	
	if qntDodge == 100 then
		player:sendTextMessage(MESSAGE_STATUS, "Full Dodge!")
		pPos:sendMagicEffect(3)
	else
		player:setDodgeLevel(soma)
		pPos:sendMagicEffect(effect)
		item:remove(1)
	end
	
	
	return true
end
dodge_script:id(28918)
dodge_script:register()

