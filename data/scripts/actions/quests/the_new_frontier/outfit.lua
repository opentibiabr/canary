local theNewFrontierOutfit = Action()
function theNewFrontierOutfit.onUse(player, item)
	if player:getStorageValue(Storage.TheNewFrontier.Questline) == 26 then
		player:addOutfit(335, 0)
		player:addOutfit(336, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have gained your new outfit and may leave the reward room now!")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already taken the outfit, ask about mission for Chrak.")
	end
	return true
end

theNewFrontierOutfit:aid(45440)
theNewFrontierOutfit:register()