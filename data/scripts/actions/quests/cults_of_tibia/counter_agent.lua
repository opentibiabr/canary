local config = {
	[1] = Position(33488, 32234, 10),
	[2] = Position(33488, 32235, 10),
	[3] = Position(33482, 32229, 10),
	[4] = Position(33483, 32228, 10),
	[5] = Position(33481, 32235, 10),
	[6] = Position(33482, 32234, 10),
	[7] = Position(33492, 32234, 10),
	[8] = Position(33491, 32227, 10),
	[9] = Position(33492, 32226, 10)

}

local cultsOfTibiaCounter = Action()
function cultsOfTibiaCounter.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local sqm = Position(33485, 32276, 10)
	local destino = Position(33487, 32230, 10)

	if not player then
		return true
	end

	if not target:isItem() then
	return false
	end

	if target:isCreature() then
	return false
	end

	if player:getStorageValue(Storage.CultsOfTibia.Life.Mission) == 6 then
		if target:getPosition() == sqm or target:getPosition() == Position(sqm.x, sqm.y + 1, sqm.z) or target:getPosition() == Position(sqm.x, sqm.y + 2, sqm.z) then
			player:teleportTo(destino)
			player:setStorageValue(Storage.CultsOfTibia.Life.Mission, 7)
			for i, position in pairs(config) do
				position:sendMagicEffect(CONST_ME_POFF)
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A sandstorm has destroyed almost all pillars. The effect of the counteragent worked different than expected.")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The sandstorm has not only destroyed the oasis, but also revealed some paving tiles and a lever.")
		end
	end
	return true
end

cultsOfTibiaCounter:id(28665)
cultsOfTibiaCounter:register()