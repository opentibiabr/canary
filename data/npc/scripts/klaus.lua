local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
    npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
    npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
    npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
    npcHandler:onThink()
end

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    local player = Player(cid)
    if msgcontains(msg, 'mission') then
        if player:getStorageValue(Storage.TheShatteredIsles.RaysMission4) == 1 then
            npcHandler:say(
                'Hmm, you look like a seasoned seadog. Kill Captain Ray Striker, \
                bring me his lucky pillow as a proof and you are our hero!',
            cid)
            player:setStorageValue(Storage.TheShatteredIsles.RaysMission4, 2)
        elseif player:getStorageValue(Storage.TheShatteredIsles.RaysMission4) == 3 then
            npcHandler:say("Do you have Striker's pillow?", cid)
            npcHandler.topic[cid] = 1
        end
    elseif msgcontains(msg, 'yes') then
        if player:getStorageValue(Storage.TheShatteredIsles.RaysMission4) == 3 then
            if npcHandler.topic[cid] == 1 then
                if player:removeItem(11427, 1) then
                    npcHandler:say('You DID it!!! Incredible! Boys, lets have a PAAAAAARTY!!!!', cid)
                    player:setStorageValue(Storage.TheShatteredIsles.RaysMission4, 4)
                    npcHandler.topic[cid] = 0
                else
                    npcHandler:say('Come back when you have his lucky pillow.', cid)
                    npcHandler.topic[cid] = 0
                end
            end
        end
    end
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
