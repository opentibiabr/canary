local poacherUse = Action()
function poacherUse.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if (player:getStorageValue(Storage.ThreatenedDreams.TroubledMission01) == 3) then
        if (target.itemid == 13805 or target.itemid == 13806)then
            target:decay()
            item:remove(1)
            player:say("You are placing the book on the table, hopefully the poachers will discover it soon.", TALKTYPE_ORANGE_1)
            toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
            player:setStorageValue(Storage.ThreatenedDreams.TroubledMission01, 4)
            return true
        end
    else
        player:sendCancelMessage("You are not on that mission.")
    end
end

poacherUse:id(28596)
poacherUse:register()