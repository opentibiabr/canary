local portpos = Position({x = 32402, y = 32794, z = 9})

local hunterAll = Action()
function hunterAll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.OutfitQuest.HunterMusicSheet01) == 1 and player:getStorageValue(Storage.OutfitQuest.HunterMusicSheet02) == 1 and player:getStorageValue(Storage.OutfitQuest.HunterMusicSheet03) == 1 and player:getStorageValue(Storage.OutfitQuest.HunterMusicSheet04) == 1 then
		player:teleportTo(portpos, false)
		portpos:sendMagicEffect(CONST_ME_TELEPORT)
		toPosition:sendMagicEffect(CONST_ME_SOUND_YELLOW)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have not learned all the verses of the hymn")
		toPosition:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

hunterAll:aid(33216)
hunterAll:register()