local wayout = MoveEvent()

function wayout.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.TheNewFrontier.Questline) == 1 then
		--Questlog, The New Frontier Quest "Mission 01: New Land"
		player:setStorageValue(Storage.TheNewFrontier.Mission01, 2)
		player:setStorageValue(Storage.TheNewFrontier.Questline, 2)
		player:say("You have found the passage through the mountains and can report about your success.",
			TALKTYPE_MONSTER_SAY)
	end
	return true
end

wayout:type("stepin")
wayout:aid(8000)
wayout:register()
