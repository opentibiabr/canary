local changeFamiliarOutfit = Action()

function changeFamiliarOutfit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
  
    local summons = player:getSummons()
    if summons and #summons > 0 then
        local summon = summons[1]
        local summonName = summon:getName()
        
        local lookType
        if summonName == "Sorcerer familiar" then 
            lookType = 1367 
        elseif summonName == "Druid familiar" then  
            lookType = 1364 
        elseif summonName == "Knight familiar" then  
            lookType = 1365 
        elseif summonName == "Paladin familiar" then  
            lookType = 1366 
        end
        
        if lookType then
            item:remove(1)
            summon:setOutfit({lookType = lookType})
            player:setStorageValue(35787, lookType)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Por favor, relogue para dar update no seu Summon!")
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você não possui um familiar válido.")
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você precisa invocar um summon primeiro!")
    end
    
    return true
end

changeFamiliarOutfit:id(23681)
changeFamiliarOutfit:register()

