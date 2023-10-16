local heartDestructionDevourer = Action()
function heartDestructionDevourer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player:canFightBoss("World Devourer") then
		player:setBossCooldown("World Devourer", 0)
		player:sendTextMessage(19, "You access to World Devourer was released!")
		item:transform(23687)
	else
		player:sendTextMessage(19, "You access to World Devourer is already released!")
	end

	return true
end

heartDestructionDevourer:id(23686)
heartDestructionDevourer:register()
