local dobleEXPSabado = GlobalEvent("dobleEXPSabado")

function dobleEXPSabado.onThink()
    if os.date("%A") ~= "Saturday" then
        return true
    end
    
    local players = Game.getPlayers()
    for _, player in ipairs(players) do
        if player:isPlayer() then
            local storageValue = player:getStorageValue(115608)
            local receivedValue = player:getStorageValue(115609)
            if storageValue == -1 and receivedValue == 0 then
                player:setStorageValue(115608, os.time() + 18000)
                player:setStorageValue(115609, 1)
                player:sendTextMessage(MESSAGE_INFO_DESCR, "You have received double EXP for 5 hours!")
            end
        end
    end
    
    return true
end

dobleEXPSabado:interval(10000)
dobleEXPSabado:register()


local dobleEXPDomingo = GlobalEvent("dobleEXPDomingo")

function dobleEXPDomingo.onThink()
	if os.date("%A") ~= "Sunday" then
        return true
    end
    
    local players = Game.getPlayers()
    for _, player in ipairs(players) do
        if player:isPlayer() then
            local storageValue = player:getStorageValue(115610)
            local receivedValue = player:getStorageValue(115611)
            if storageValue == -1 and receivedValue == 0 then
                player:setStorageValue(115610, os.time() + 18000)
                player:setStorageValue(115611, 1)
                player:sendTextMessage(MESSAGE_INFO_DESCR, "You have received double EXP for 5 hours!")
            end
        end
    end
    
    return true
end
dobleEXPDomingo:interval(10000)
dobleEXPDomingo:register()


local reseteoEXP = GlobalEvent("resetDoubleEXPNextWeekend")

function reseteoEXP.onThink()
	if os.date("%A") ~= "Monday" then
        return true
    end
    
    local players = Game.getPlayers()
    for _, player in ipairs(players) do
        if player:isPlayer() then
            local storageValue = player:getStorageValue(115608)
            local receivedValue = player:getStorageValue(115609)
			local storageValue1 = player:getStorageValue(115610)
            local receivedValue1 = player:getStorageValue(115611)
            if storageValue == 0 and receivedValue == 1 then
				player:setStorageValue(115608, -1)
				player:setStorageValue(115609, 0)
			elseif storageValue1 == 0 and receivedValue1 == 1 then
				player:setStorageValue(115610, -1)
				player:setStorageValue(115611, 0)
			end
            end
        end
    
    return true
end
reseteoEXP:interval(10000)
reseteoEXP:register()