local darkCorpse = Action()

function darkCorpse.onUse(player)
	if player:getStorageValue(Storage.DarkTrails.Mission14) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Quandon has been murdered! You should report to Sholley about it!.')
		player:setStorageValue(Storage.DarkTrails.Mission14, 2)
	elseif player:getStorageValue(Storage.DarkTrails.Mission14) == 2 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This is empty!')
	end
	return true
end

darkCorpse:uid(20001)
darkCorpse:register()
