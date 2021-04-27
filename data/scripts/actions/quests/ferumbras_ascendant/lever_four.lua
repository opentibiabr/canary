local ferumbrasAscendantLevelFour = Action()
function ferumbrasAscendantLevelFour.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Active) < 1 then
		return false
	end
	if item.itemid == 10029 then
		if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Done) < 4 then
			local spectators = Game.getSpectators(item:getPosition(), false, false, 9, 9, 6, 6)
			for i = 1, #spectators do
				if spectators[i]:isPlayer() then
					local spec = spectators[i]
					spec:teleportTo(Position(33646, 32654, 14))
					spec:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
			revertStorages()
			return true
		end
		if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Done) >= 4 then
			Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Done, 4)
		end
		item:transform(10030)
	elseif item.itemid == 10030 then
		item:transform(10029)
	end
	return true
end

ferumbrasAscendantLevelFour:aid(53824)
ferumbrasAscendantLevelFour:register()