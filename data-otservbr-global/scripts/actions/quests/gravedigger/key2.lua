local gravediggerKey2 = Action()
function gravediggerKey2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4661 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission52) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission53) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission53, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "An invisible hand pulls you inside.")
		player:teleportTo(Position({x = 33011, y = 32392, z = 10}))
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission53) == 1 then --and player:getStorageValue(Storage.GravediggerOfDrefia.Mission55) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission55, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Get out of my room!")
		player:teleportTo(Position({x =  33008, y = 32392, z = 10}))
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

gravediggerKey2:id(21489)
gravediggerKey2:register()