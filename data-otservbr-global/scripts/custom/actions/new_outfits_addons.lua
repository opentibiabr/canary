
--- Fallen Angel Outfit

local fallenAngelOutfit = Action()

function fallenAngelOutfit.onUse(cid, item, fromPosition, itemEx, toPosition)
    local outfitId = 0

    if item.itemid == 23232 then
        local player = Player(cid)
        if player:getSex() == PLAYERSEX_FEMALE then
            outfitId = 1685 
        elseif player:getSex() == PLAYERSEX_MALE then
            outfitId = 1686 
        end

        if player:hasOutfit(outfitId) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have this outfit.")
        else
            player:addOutfit(outfitId)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received the Fallen Angel Outfit.")
            item:remove(1)
        end
    end
    return true
end

fallenAngelOutfit:id(23232)
fallenAngelOutfit:register()


--- Mirage Outfit

local mirageOutfit = Action()

function mirageOutfit.onUse(cid, item, fromPosition, itemEx, toPosition)
    local outfitId = 0

    if item.itemid == 23233 then
        local player = Player(cid)
        if player:getSex() == PLAYERSEX_FEMALE then
            outfitId = 1688 
        elseif player:getSex() == PLAYERSEX_MALE then
            outfitId = 1687 
        end

        if player:hasOutfit(outfitId) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have the Mirage base outfit.")
        else
            player:addOutfit(outfitId)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received the Mirage Outfit.")
            item:remove(1)
        end
    end
    return true
end

mirageOutfit:id(23233)
mirageOutfit:register()

--- Mirage Addon 1 

local mirageAddonOne = Action()

function mirageAddonOne.onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if item.itemid == 23244 then
        if player:hasOutfit(1685, 0) or player:hasOutfit(1686, 0) then
        if player:getSex() == PLAYERSEX_FEMALE then
            if player:hasOutfit(1688, 1) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have te first mirage addon.")
            else
                player:addOutfitAddon(1688, 1)
                item:remove(1)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received first addon of Mirage Outfit.")
            end
        elseif player:getSex() == PLAYERSEX_MALE then
            if player:hasOutfit(1687, 1) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have the first mirage addon.")
            else
                player:addOutfitAddon(1687, 1)
                item:remove(1)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received first addon of Mirage Outfit.")
            end
        end
        end
    end
    return true
end

mirageAddonOne:id(23244)
mirageAddonOne:register()


--- Mirage Addon 2

local mirageAddonOne = Action()

function mirageAddonOne.onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if item.itemid == 23242 then
        if player:hasOutfit(1685, 0) or player:hasOutfit(1686, 0) then
        if player:getSex() == PLAYERSEX_FEMALE then
            if player:hasOutfit(1688, 2) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have the second mirage addon.")
            else
                player:addOutfitAddon(1688, 2)
                item:remove(1)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received second addon of Mirage Outfit.")
            end
        elseif player:getSex() == PLAYERSEX_MALE then
            if player:hasOutfit(1687, 2) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have the second mirage addon.")
            else
                player:addOutfitAddon(1687, 2)
                item:remove(1)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received second addon of Mirage Outfit.")
            end
        end
        end
    end
    return true
end

mirageAddonOne:id(23242)
mirageAddonOne:register()


--- Rotten Blood Outfit

local rottenBloodOutfit = Action()

function rottenBloodOutfit.onUse(cid, item, fromPosition, itemEx, toPosition)
    local outfitId = 0

    if item.itemid == 23240 then
        local player = Player(cid)
        if player:getSex() == PLAYERSEX_FEMALE then
            outfitId = 1676 
        elseif player:getSex() == PLAYERSEX_MALE then
            outfitId = 1675 
        end

        if player:hasOutfit(outfitId) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have the rotten blood base outfit.")
        else
            player:addOutfit(outfitId)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received the Rotten Blood Outfit.")
            item:remove(1)
        end
    end
    return true
end

rottenBloodOutfit:id(23240)
rottenBloodOutfit:register()

--- Rotten Blood Addon One

local rottenBloodAddonOne = Action()

function rottenBloodAddonOne.onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if item.itemid == 23235 then
        if player:hasOutfit(1685, 0) or player:hasOutfit(1686, 0) then
        if player:getSex() == PLAYERSEX_FEMALE then
            if player:hasOutfit(1676, 1) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have te first rotten blood addon.")
            else
                player:addOutfitAddon(1676, 1)
                item:remove(1)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received first addon of rotten blood Outfit.")
            end
        elseif player:getSex() == PLAYERSEX_MALE then
            if player:hasOutfit(1675, 1) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have the first rotten blood addon.")
            else
                player:addOutfitAddon(1675, 1)
                item:remove(1)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received first addon of rotten blood Outfit.")
            end
        end
        end
    end
    return true
end

rottenBloodAddonOne:id(23235)
rottenBloodAddonOne:register()


--- Rotten Blood Addon 2

local rottenBloodAddonTwo = Action()

function rottenBloodAddonTwo.onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if item.itemid == 23243 then
        if player:hasOutfit(1685, 0) or player:hasOutfit(1686, 0) then
        if player:getSex() == PLAYERSEX_FEMALE then
            if player:hasOutfit(1676, 2) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have the second rotten blood addon.")
            else
                player:addOutfitAddon(1676, 2)
                item:remove(1)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received second addon of rotten blood Outfit.")
            end
        elseif player:getSex() == PLAYERSEX_MALE then
            if player:hasOutfit(1675, 2) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have the second rotten blood addon.")
            else
                player:addOutfitAddon(1675, 2)
                item:remove(1)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received second addon of rotten blood Outfit.")
            end
        end
        end
    end
    return true
end

rottenBloodAddonTwo:id(23243)
rottenBloodAddonTwo:register()


local rottenBloodMount = Action()

function rottenBloodMount.onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    
    -- Check if the item used is the one with id 11111
    if item.itemid == 23245 then
        -- Check if the player already has the mount
        if player:hasMount(217) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have rotten blood mount.")
        else
            player:addMount(217)
            item:remove(1)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have received the rotten blood mount.")
        end
    end
    return true
end

rottenBloodMount:id(23245)
rottenBloodMount:register()