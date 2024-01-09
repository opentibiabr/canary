    local tplist = {

        [40980] = {name = "Bosses", level = 250, positions = {{x = 31848, y = 32212, z = 9}}, subareas = {}}
 
}

local firstid = 40980 -- Put your first action id used here
local lastid = 40980 -- Put your last action id used here

-- Config End
local teleports = MoveEvent()
function teleports.onStepIn(player, item, position, fromPosition)
    if not player:isPlayer() then
        return false
    end
 
    local tp = tplist[item.actionid]
    local quantity = table.getn(tp.positions)
 
    player:registerEvent("Teleport_Modal_Window")
 
    local title = "Teleport"
    local message = "List of ".. tp.name .." Spawns"
   
    local window = ModalWindow(item.actionid, title, message)
    window:addButton(100, "Go")
    window:addButton(101, "Cancel")
   
    for i = 1, quantity do
        if tp.subareas[i] == nil then
            window:addChoice(i,"".. tp.name .." ".. i .."")
        else
            window:addChoice(i,"".. tp.subareas[i] .."")
        end
    end
 
    window:setDefaultEnterButton(100)
    window:setDefaultEscapeButton(101)
 
    if tp and quantity < 2 then
        player:unregisterEvent("Teleport_Modal_Window")
     
        local levelReq = tp.level
        if levelReq > 0 and player:getLevel() < levelReq then
            doTeleportThing(player, fromPosition, false) 
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You do not have the required level of '.. tp.level ..'.')
            return true
        end
 
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Teleported to '.. tp.name ..'.')
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        player:teleportTo(tp.positions[1])
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    else
        window:sendToPlayer(player)
    end
    return true
end
for j = firstid, lastid do
    teleports:aid(j)
end
teleports:type("stepin")
teleports:register()
local modalTp = CreatureEvent("Teleport_Modal_Window")
modalTp:type("modalwindow")
function modalTp.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("Teleport_Modal_Window")
    if modalWindowId >= firstid and modalWindowId <= lastid then
        if buttonId == 100 then
         
            local levelReq = tplist[modalWindowId].level[choiceId]
            if levelReq > 0 and player:getLevel() < levelReq then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You do not have the required level of '.. levelReq ..'.')

                return true
            end
     
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            player:teleportTo(tplist[modalWindowId].positions[choiceId])
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            if tplist[modalWindowId].subareas[choiceId] == nil then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Teleported to '.. tplist[modalWindowId].name ..' '.. choiceId ..'.')
            else
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Teleported to '.. tplist[modalWindowId].subareas[choiceId] ..'.')
            end
        end
    end
    return true
end
modalTp:register()