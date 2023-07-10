local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local wayOut = MoveEvent()

function wayOut.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(TheNewFrontier.Questline) == 1 then
		player:setStorageValue(TheNewFrontier.Mission01, 2) -- Questlog, Quest "Mission 01: New Land"
		player:setStorageValue(TheNewFrontier.Questline, 2)
		player:say("You have found the passage through the mountains and can report about your success.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

wayOut:position(Position(33082, 31532, 7),Position(33082, 31533, 7))
wayOut:register()
