local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams

local poacherNotes = Action()
function poacherNotes.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getStorageValue(ThreatenedDreams.Mission01[1]) == 7
    and player:getStorageValue(ThreatenedDreams.Mission01.PoacherNotes) < 1 then
        player:addItem(25242, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found notes of a poacher.')
        player:setStorageValue(ThreatenedDreams.Mission01.PoacherNotes, 1)
    else
        player:sendCancelMessage("It is empty.")
    end

	return true
end

poacherNotes:aid(20002)
poacherNotes:register()

