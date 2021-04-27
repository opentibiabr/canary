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

function Player.getInquisitionGold(self)
    local v = {
        math.max(0, self:getStorageValue(ROSHAMUUL_MORTAR_THROWN))*100,
        math.max(0, self:getStorageValue(ROSHAMUUL_KILLED_FRAZZLEMAWS)),
        math.max(0, self:getStorageValue(ROSHAMUUL_KILLED_SILENCERS))
    }
    return v[1] + v[2] + v[3]
end

local function creatureSayCallback(cid, type, msg)
    local player = Player(cid)
    if not npcHandler:isFocused(cid) then
        return false
    end

    if msgcontains(msg, "mission") then
        npcHandler:say({
            "First, you will help us rebuilding this wretched {bridge} we cannot cross. We need mortar and there are several types of monsters who try to keep us away from it. ...",
            "Then there is this enormous wall in the distance. Once we crossed the bridge, we will have to breach this monument. As I see it, you are working for the Inquisition now, I will hear no objection. You may even earn our gratitude."
        }, cid)
        npcHandler.topic[cid] = 1
    elseif msgcontains(msg, "bridge") then
        if npcHandler.topic[cid] == 1 then
            npcHandler:say({
                "Our brother Mortis is constantly working on keeping the bridge intact. We tried some simple wood planks first but it didn't work out that... well. ...",
                "What we need is enough {mortar} to actually build a durable traverse. And we will need even more mortar to maintain it as it constantly gets attacked by vile critters."
            }, cid)
            npcHandler.topic[cid] = 2
        end
    elseif msgcontains(msg, "mortar") then
        if npcHandler.topic[cid] == 2 then
            npcHandler:say({
                "We scouted some caves beneath the island which hold plenty of chalk to mix some good mortar. The entrances are not very far from here in fact. ...",
                "However, the entrances are somewhat... twisted. The entrance we had mapped to a certain cave one day, would lead to a completely different cave on the next. ...",
                "And even when emerging from one of the caves you never know where you are since its exits are just as deceptive. ...",
                "Once you gathered some chalk, you should also find gravel on the island. If you have a pick and a bucket, you should be able to collect enough fine gravel to mix some mortar. ...",
                "Do not forget to bring some buckets, if you are in short supply, brother Maun will hand some out to you - for a fee of course."
            }, cid)
            npcHandler.topic[cid] = nil
        end
    end

    if msgcontains(msg, "gratitude") then
        npcHandler.topic[cid] = 3
        npcHandler:say("Oh, so you want a reward, hm? Well... let's see. What did you do for us - helping Mortis with his {repairs} and defended him?", cid)
    elseif msgcontains(msg, "repairs") then
        if npcHandler.topic[cid] == 3 then
            if player:getInquisitionGold() > 0 then
                npcHandler.topic[cid] = 4
                npcHandler:say({
                    "Alright, so you mixed and delivered ".. math.max(0, player:getStorageValue(ROSHAMUUL_MORTAR_THROWN)) .." mortar and ...",
                    "You killed ".. math.max(0, player:getStorageValue(ROSHAMUUL_KILLED_FRAZZLEMAWS)) .." frazzlemaws and ...",
                    "You also hunted ".. math.max(0, player:getStorageValue(ROSHAMUUL_KILLED_SILENCERS)) .." silencers. That would equal ".. player:getInquisitionGold() .." of inquisition gold - BUT we are currently short of this valuable metal so... do you want me to add this amount to my {books} for now or {trade} it for something else.",
                }, cid)
            else
                npcHandler.topic[cid] = nil
                npcHandler:say("Come back after you have done at least one of the tasks I talked you about.", cid)
            end
        end
    elseif npcHandler.topic[cid] == 4 then
        local v = math.max(0, player:getStorageValue(ROSHAMUUL_GOLD_RECORD))
        if msgcontains(msg, "book") or msgcontains(msg, "books") then
            npcHandler.topic[cid] = 5
            npcHandler:say({
                "Of course, let's see. Hm, your recent endeavours would earn you ".. player:getInquisitionGold() .." of righteous inquisition gold. You have earned ".. v .." of gold in total. ...",
                "Do you want me to add this amount to my books? This will reset your current records, too, however - so?",
            }, cid)
        end
    elseif npcHandler.topic[cid] == 5 then
        if msgcontains(msg, "yes") then
            npcHandler:say({
                "Good. Registered as... ".. player:getName() .."... with... about ".. player:getInquisitionGold() .." of righteously earned inquisition gold added. There. Thanks for your help! ..",
                "Good. Ask me any time in case you want to know your current {record}. If you have time, Remember you can also {trade} your earnings into some of these... probably far more valuable, ahem... cluster... things, yes.",
            }, cid)
            player:setStorageValue(ROSHAMUUL_GOLD_RECORD, player:getInquisitionGold())
            player:setStorageValue(ROSHAMUUL_MORTAR_THROWN, 0)
            player:setStorageValue(ROSHAMUUL_KILLED_FRAZZLEMAWS, 0)
            player:setStorageValue(ROSHAMUUL_KILLED_SILENCERS, 0)
            npcHandler.topic[cid] = nil
        end
    elseif msgcontains(msg, "record") then
        local v = player:getStorageValue(ROSHAMUUL_GOLD_RECORD)
        if v > 0 then
            npcHandler:say("You have ".. v .." inquisition gold registered in my book.", cid)
        else
            npcHandler:say("I do not see inquisition gold registered in my book from you.", cid)
        end
    elseif msgcontains(msg, "trade") then
        local v = player:getStorageValue(ROSHAMUUL_GOLD_RECORD)
        if v >= 100 then
            npcHandler.topic[cid] = 6
            npcHandler:say("Ah yes, you currently have ".. v .." of righteously earned inquisition gold in my book. 100 inquisition gold equals one cluster. How many clusters do you want in exchange?", cid)
        else
            npcHandler.topic[cid] = nil
            npcHandler:say("You do not seem to have enough inquisition gold yet to trade for clusters, as it's registered in my book.", cid)
        end
    elseif npcHandler.topic[cid] == 6 then
        local v = tonumber(msg)
        if (v == nil) or (v < 1) or (math.floor(v) ~= v) then
            return npcHandler:say("You should tell me a real number.", cid)
        end

        local max = math.floor(player:getStorageValue(ROSHAMUUL_GOLD_RECORD)/100)
        if v > max then
            return npcHandler:say("You do not have enough inquisition gold for that, so far you can ask for up to ".. max .." clusters.", cid)
        end

        player:addItem(22396, v)
        npcHandler.topic[cid] = nil
        player:setStorageValue(ROSHAMUUL_GOLD_RECORD, player:getStorageValue(ROSHAMUUL_GOLD_RECORD) - (v*100))
        npcHandler:say("There you are. Now I register ".. player:getStorageValue(ROSHAMUUL_GOLD_RECORD) .." inquisition gold of yours in my book.", cid)
    end

    if msgcontains(msg, "bucket") or msgcontains(msg, "supplies") then
        npcHandler:say("Head to brother Maun if you are in need of basic supplies. He will help you - for a small fee.", cid)
    elseif msgcontains(msg, "maun") then
        npcHandler:say("Brother Maun is a valuable member of the Inquisition. He will help you out with supplies. Provided you can actually compensate of course.", cid)
    end
    return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hm. Greetings.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Praise the gods, I bid you farewell.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
