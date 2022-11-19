local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams

local poacherBook = Action()
function poacherBook.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if (player:getStorageValue(ThreatenedDreams.Mission01[1]) == 2) then
        if (target.itemid == 12648 or target.itemid == 12649)then
            target:decay()
            item:remove(1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You are placing the book on the table, hopefully the poachers will discover it soon.')
            toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
            player:setStorageValue(ThreatenedDreams.Mission01[1], 3)
            return true
        end
    else
        player:sendCancelMessage("You are not on that mission.")
    end
end

poacherBook:id(25235)
poacherBook:register()
