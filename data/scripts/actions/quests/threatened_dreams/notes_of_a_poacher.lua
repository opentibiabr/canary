local notesPoacher = Action()
function notesPoacher.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if (player:getStorageValue(Storage.ThreatenedDreams.TroubledMission01) == 7) then
        player:addItem(28603, 1)
        player:setStorageValue(Storage.ThreatenedDreams.TroubledMission01, 8)
    else
        player:sendCancelMessage("You are not on that mission.")
    end

	return true
end

notesPoacher:aid(28600)
notesPoacher:register()
