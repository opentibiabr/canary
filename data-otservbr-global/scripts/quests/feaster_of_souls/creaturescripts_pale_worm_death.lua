local config = {
	centerPosition = Position(33805, 31504, 14),
	rangeX = 11,
	rangeY = 11,
}

local event = CreatureEvent("paleWormDeath")

function event.onPrepareDeath(creature)
	local spectators = Game.getSpectators(config.centerPosition, false, false, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
	for _, specCreature in pairs(spectators) do
		if specCreature:isPlayer() then
			if specCreature:getStorageValue(Storage.Quest.U12_30.PoltergeistOutfits.Received) == -1 then
				specCreature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations you received the Poltergeist Outfit.")
				specCreature:addOutfit(1271, 0)
				specCreature:addOutfit(1270, 0)
				specCreature:setStorageValue(Storage.Quest.U12_30.PoltergeistOutfits.Received, 1)
			end
			specCreature:addAchievement("Beyonder")
		end
	end

	return true
end

event:register()
