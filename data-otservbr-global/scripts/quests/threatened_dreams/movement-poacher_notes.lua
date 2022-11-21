local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams

local foundPoacherBody = MoveEvent()
function foundPoacherBody.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getStorageValue(ThreatenedDreams.Mission01[1]) == 6 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You discover a sleeping wolf and a gnawed skeleton in this tent. Could it be the one you are searching for?')
		player:setStorageValue(ThreatenedDreams.Mission01[1], 7)
	end
	return true
end

foundPoacherBody:position({x = 32949, y = 31811, z = 7})
foundPoacherBody:position({x = 32950, y = 31811, z = 7})
foundPoacherBody:position({x = 32951, y = 31811, z = 7})
foundPoacherBody:register()
