local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams

local wolfFur = Action()
function wolfFur.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if target.itemid ~= 25237 then
        return false
    end

    if player:getStorageValue(ThreatenedDreams.Mission01[1]) == 8 then
        target:decay()
        item:remove(1)
        toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You place the whelp fur in the stone\'s mouth and thus lay it to rest.')
        player:setStorageValue(ThreatenedDreams.Mission01[1], 9)
    end
	return true
end

wolfFur:id(25238)
wolfFur:register()
