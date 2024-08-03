local familiar = Action()

function familiar.onUse(cid, item, fromPosition, itemEx, toPosition)

    local player = Player(cid)
	local vocation = player:getVocation():getId() 

    if vocation == 1 or vocation == 5 then

		-- Familiars sorcerrers
        player:addFamiliar(1367)

    elseif vocation == 2 or vocation == 6 then

        -- Familiars druids
        player:addFamiliar(1364)

    elseif vocation == 3 or vocation == 7 then

        -- Familiars paladins
        player:addFamiliar(1366)

    elseif vocation == 4 or vocation == 8 then

        -- Familiars knights
        player:addFamiliar(1365)

    end
	
    Item(item.uid):remove(1)
    player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
	player:sendTextMessage(MESSAGE_STATUS, "Voce recebeu um novo Familiar.")

    return true
end

familiar:id(35589, 35590, 35591, 35592)
familiar:register()
