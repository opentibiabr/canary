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
    if msgcontains(msg, "mission") then
        if (player:getStorageValue(Storage.ThreatenedDreams.TroubledMission01) == 6) then
            npcHandler:say({
                "I'm heartbroken, traveler. Some months ago, I was taking care of my three newborn whelps. They just opened their eyes and started exploring the wilderness as a hunter came by. ...",
                "He shot me and took my three puppies with him. I have no idea where he brought them or whether they are still alive. This uncertainty harrows me and thus I'm unable to find peace. Will you help me?"
            }, cid)
            npcHandler.topic[cid] = 1
        elseif (player:getStorageValue(Storage.ThreatenedDreams.TroubledMission01) == 10) then
            player:setStorageValue(Storage.ThreatenedDreams.TroubledMission01, 11)
            npcHandler:say("I guess I will stick around for a time to watch over the grave. After this final watch I will find peace, I can feel this. Thank you, human being. You redeemed me.", cid)
            npcHandler.topic[cid] = 0
        else
            npcHandler:say("You are not on that mission.", cid)
            npcHandler.topic[cid] = 0
        end
	elseif npcHandler.topic[cid] == 1 then
		if msgcontains(msg, "yes") then
			npcHandler:say({
				"I didn't dare hope for it! The man told something about selling my babies to the orcs so they could train them as war wolves. ...",
				"I guess he mentioned Ulderek's Rock. Please search for them and - be they alive or not - return and tell me what happened to them."
			}, cid)
			player:setStorageValue(Storage.ThreatenedDreams.TroubledMission01, 7)
            npcHandler.topic[cid] = 0
		elseif msgcontains(msg, "no") then
            npcHandler:say("Then not.", cid)
            npcHandler.topic[cid] = 0
		end
        npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "You are speaking the language of animals? I'm surprised. But I'm not in the right mood for a chat.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
