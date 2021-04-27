local ferumbrasAscendantLeverThird = Action()
function ferumbrasAscendantLeverThird.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Active) < 1 then
		return false
	end
	if item.itemid == 10029 then
		if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Done) < 3 then
			local spectators = Game.getSpectators(item:getPosition(), false, false, 9, 9, 6, 6)
			for i = 1, #spectators do
				if spectators[i]:isPlayer() then
					local spec = spectators[i]
					spec:teleportTo(Position(33646, 32654, 14))
					spec:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					spec:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Something clicked at same time a booming sound almost deafens you.")
				end
			end
			revertStorages()
			return true
		end
		if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Four) == 4 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A booming sound almost deafens you. From somewhere deep within you hear a whisper: 'Blood...'")
		end
		if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Four) == 5 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A booming sound almost deafens you. From somewhere deep within you hear a whisper: 'Grass...'")
		end
		if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Four) == 6 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A booming sound almost deafens you. From somewhere deep within you hear a whisper: 'Ice...'")
		end
		if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Done) >= 3 then
			Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Elements.Done, 4)
		end
		item:transform(10030)
	elseif item.itemid == 10030 then
		item:transform(10029)
	end
	return true
end

ferumbrasAscendantLeverThird:aid(53823)
ferumbrasAscendantLeverThird:register()