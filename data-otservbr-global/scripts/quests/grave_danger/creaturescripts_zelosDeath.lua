local config = {
	centerPosition = Position(33443, 31545, 13),
	rangeX = 11,
	rangeY = 11,
}

local KingzelosDeath = CreatureEvent("zelosDeath")

function KingzelosDeath.onPrepareDeath(creature)
	local spectators = Game.getSpectators(config.centerPosition, false, false, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
	for _, specCreature in pairs(spectators) do
		if specCreature:isPlayer() then
			if specCreature:getStorageValue(Storage.Quest.U12_20.GraveDanger.Bosses.InquisitionOutfitReceived) == -1 then
				specCreature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations you received the Hand of the Inquisition Outfit.")
				specCreature:addOutfit(1244, 0)
				specCreature:addOutfit(1243, 0)
				specCreature:setStorageValue(Storage.Quest.U12_20.GraveDanger.Bosses.InquisitionOutfitReceived, 1)
			end
			specCreature:addAchievement("Inquisition's Hand")
		end
	end

	return true
end

KingzelosDeath:register()
