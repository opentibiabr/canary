local gravediggerInscriptions = Action()
function gravediggerInscriptions.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission45) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission46) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission46, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The words seem to breathe, stangely. One word stays in your mind: bronze')
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission46) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission47) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission47, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The words seem to glow slightly. A name fixes in your mind: Takesha Antishu')
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission47) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission48) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission48, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The words seem to flutter. One word stays in your mind: floating')
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	end
	return true
end

gravediggerInscriptions:aid(4651,4652,4653)
gravediggerInscriptions:register()