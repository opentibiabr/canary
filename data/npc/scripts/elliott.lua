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

function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	-- Mission 3 start
	if msgcontains(msg, "abandoned sewers") then
		if player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) < 21 then
			npcHandler:say("You want to enter the abandoned sewers? That's rather dangerous and not a good idea, man. That part of the sewers was not sealed off for nothing, you know? ...", cid)
			npcHandler:say("But hey, it's your life, bro. So here's the deal. I'll let you into the abandoned sewers if you help me with our {mission}.", cid)
			npcHandler.topic[cid] = 0
			-- Mission 3 end
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 21 then
			npcHandler:say("Wow, you already did it, that's fast. I'm used to a more laid-back attitude from most people. It's a shame to risk losing you to some collapsing tunnels, but a deal is a deal. ...", cid)
			npcHandler:say("I hereby grant you the perMission to enter the abandoned part of the sewers. Take care, man! ...", cid)
			npcHandler:say("If you find something interesting, come back to talk about the {abandoned sewers}.", cid)
			player:setStorageValue(Storage.DarkTrails.Mission04, 1)
			player:setStorageValue(Storage.Oramond.DoorAbandonedSewer, 1)
			npcHandler.topic[cid] = 7
		elseif player:getStorageValue(Storage.DarkTrails.Mission05) == 1 then
			npcHandler:say("I'm glad to see you back alive and healthy. Did you find anything interesting that you want to {report}?", cid)
			npcHandler.topic[cid] = 7
		end
		-- Mission 3 start
	elseif msgcontains(msg, "mission") then
		if npcHandler.topic[cid] == 0 then
			npcHandler:say("The sewers need repair. You in?", cid)
			npcHandler.topic[cid] = 2
			-- Mission 3 end
		elseif player:getStorageValue(Storage.DarkTrails.Mission03) == 1 then
			npcHandler:say("Elliott's keeps calling it that. It's just another job! You fixed some broken pipes and stuff? Let me check, {ok}?", cid)
			npcHandler.topic[cid] = 3
		end
		-- Mission 3 start - sewer access
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say("Good. Broken pipe and generator pieces, there's smoke evading. That's how you recognise them. See how you can fix them using your hands. Need about, oh, twenty of them at least repaired. Report to me or Jacob", cid)
			player:setStorageValue(Storage.Oramond.DoorAbandonedSewer, 1)
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer, 0)
			npcHandler.topic[cid] = 0
		end
		-- Task: The Ancient Sewers
	elseif msgcontains(msg, "ok") then
		if npcHandler.topic[cid] == 3 then
			npcHandler:say("Good. Thanks, man. That's one vote you got for helping us with this.", cid)
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer, 21) --goto Mission 3 end
			npcHandler.topic[cid] = 0
		end
		-- Final Mission 5
	elseif msgcontains(msg, "report") then
		if player:getStorageValue(Storage.DarkTrails.Mission05) == 1 then
			if npcHandler.topic[cid] == 7 then
				npcHandler:say("A sacrificial site? Damn, sounds like some freakish cult or something. Just great. And this ancient structure you talked about that's not part of the sewers? You'd better see the local historian about that, man. ...", cid)
				npcHandler:say("He can make more sense of what you found there. His name is Barazbaz. He should be in the magistrate building.", cid)
				player:setStorageValue(Storage.DarkTrails.Mission06, 1) -- start Mission 6
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You already reported this Mission, go to the next.", cid)
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "<nods>")
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye!') -- Need revision

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
