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
        if (player:getStorageValue(Storage.ThreatenedDreams.TroubledMission01) == 12) then
            npcHandler:say({
                "My sister Ikassis sent you? Blessed be her soul! Yes, it is true: I need help. Listen, I will tell you a secret but please don't break it. As you might already suspect I'm not really a swan but a fae. ...",
                "But other than many of my siblings I did not take over a swan's body. I'm a swan maiden and this is one of my two aspects. I can take the shape of a swan as well as that of a young maiden. ...",
                "But to do so I need a magical artefact: a cloak made of swan feathers. If I lose this cloak - or someone steals it from me - I'm stuck to the form of a swan and can't change shape anymore. And this is exactly what happened: ...",
                "A troll stalked me while I was bathing in the river and he stole my cloak. Now I am trapped in the form of a swan. Please, can you find the thief and bring back the cloak?"
            }, cid)
            npcHandler.topic[cid] = 1
        elseif (player:getStorageValue(Storage.ThreatenedDreams.TroubledMission01) == 15) then
            if player:getItemCount(28605) >= 5 then
                player:removeItem(28605, 5)
                player:setStorageValue(Storage.ThreatenedDreams.TroubledMission01, 16)
                npcHandler:say({
                    "This is everything that remained of my cloak? That's terrible! However, I guess I can put the feathers together again. Yes, that should be enough feathers. ...",
                    "Please give them to me so I can restore my cloak. But don't watch me! Swan maidens don't like to be observed. Nature's blessings, human being. I will tell Ikassis that you have been of great assistance."
                }, cid)
                npcHandler.topic[cid] = 0
            else 
                npcHandler:say("You need to deliver me like 5 feathers.", cid)
            end
        else
            npcHandler:say("You are not on that mission.", cid)
			npcHandler.topic[cid] = 0
        end
	elseif npcHandler.topic[cid] == 1 then
		if msgcontains(msg, "yes") then
            npcHandler:say({
                "Thank you, human being! I guess the thieving troll headed to the mountains east of here. As far as I know you can only reach these mountain tops by diving into a small cave. ...",
                "The connecting tunnels will lead you to a mountain where you may discover him. I heard a man named Jerom talking about this when he passed by this river. Perhaps he knows more about it."
            }, cid)
            player:setStorageValue(Storage.ThreatenedDreams.TroubledMission01, 13)
            npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "I salute you, mortal being.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())


