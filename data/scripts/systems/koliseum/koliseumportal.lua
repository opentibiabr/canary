local actionVip = 39889

local tiletoken = MoveEvent()

function tiletoken.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    if item.actionid == actionVip then
	if not player:removeItem(14758, 1) then
		player:teleportTo(fromPosition)
        fromPosition:sendMagicEffect(CONST_ME_POFF)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need 1 Koliseum Ticket to access this area! You can get them in the "Store"!')
	return false
	end

        player:say('Removed 1 Koliseum Ticket', TALKTYPE_MONSTER_SAY)
        
    end

    return true
end

tiletoken:aid(actionVip)
tiletoken:register()