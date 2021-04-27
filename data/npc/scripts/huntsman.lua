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

	if msgcontains(msg, "huntsman") then
        npcHandler:say("I hunt game of all sorts to earn a living. I respect the {balance} of nature though and take only as much as I need.", cid)
        npcHandler.topic[cid] = 1
    elseif msgcontains(msg, "balance") then
        if npcHandler.topic[cid] == 1 then
            npcHandler:say({
                "To be honest, I don't care too much about that spiritual balance thing. Better talk to {Benevola} about such things. ...",
                "As a matter of fact though, if too many animals are killed, things might rapidly change for the worse. ...",
                "So it's only practical thinking to keep the balance in mind as long as I can afford it."
            }, cid)
            npcHandler.topic[cid] = 2
        end
	
	elseif msgcontains(msg, "benevola") then
        if npcHandler.topic[cid] == 2 then
            player:addMapMark(Position(32596, 31746, 7), MAPMARK_FLAG, "Benevola's Hut")
            npcHandler:say("She is a bit overly concerned about that nature and balance stuff but she has a good heart. She is living in the woods between Carlin and Ab'Dendriel. I'll mark her hut on your map.", cid)
            npcHandler.topic[cid] = 0
        end  

    elseif msgcontains(msg, "white deer") then
        npcHandler:say("The white deer are somewhat sacred to the elves. Though their fur and antlers are rumoured to earn a decent amount of {gold} on the market, it's probably not worth the trouble.", cid)
        npcHandler.topic[cid] = 3
        
    elseif msgcontains(msg, "gold") then
        if npcHandler.topic[cid] == 3 then
            npcHandler:say("Just between you and me, I heard a guy named {Cruleo} is offering some handsome cash for the trophies of a white deer.", cid)
            npcHandler.topic[cid] = 4 
        end    
    elseif msgcontains(msg, "cruleo") then
        if npcHandler.topic[cid] == 4 then           
            player:addMapMark(Position(32723, 31793, 7), MAPMARK_FLAG, "Cruleo's Hut")
            npcHandler:say("He has a house in the wilderness. Just between Ab'Dendriel and the orcland. I'll mark his hut on your map.", cid)
            npcHandler.topic[cid] = 0           
        end 
    end
    
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m just a simple {huntsman}.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I don\'t think telling a stranger your name is a smart thing to do.'})

npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye. Take care.")
npcHandler:setMessage(MESSAGE_FAREWELL, "I can still see you.")
npcHandler:setMessage(MESSAGE_GREET, "Howdy partner.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
