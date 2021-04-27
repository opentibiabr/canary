local cultsOfTibiaAnalyser = Action()
function cultsOfTibiaAnalyser.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local sqm = Position(33485, 32276, 10)

	if not player then
		return true
	end

	if not target:isItem() then
	return false
	end

	if target:isCreature() then
	return false
	end

	if player:getStorageValue(Storage.CultsOfTibia.Life.Mission) == 4 then
		if target:getPosition() == sqm or target:getPosition() == Position(sqm.x, sqm.y + 1, sqm.z)
			 or target:getPosition() == Position(sqm.x, sqm.y + 2, sqm.z) then
			player:setStorageValue(Storage.CultsOfTibia.Life.Mission, 5)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Well done! The water is analyzed.")
		end
	end
	return true
end

cultsOfTibiaAnalyser:id(28666)
cultsOfTibiaAnalyser:register()