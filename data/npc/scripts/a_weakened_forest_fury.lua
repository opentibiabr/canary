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

-- Don't forget npcHandler = npcHandler in the parameters. It is required for all StdModule functions!
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = ' My name is now known only to the wind and it shall remain like this until I will return to my kin.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I was a guardian of this glade. I am the last one... everyone had to leave.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "This glade's time is growing short if nothing will be done soon."})
keywordHandler:addKeyword({'forest fury'}, StdModule.say, {npcHandler = npcHandler, text = "Take care, guardian."})
keywordHandler:addKeyword({'orclops'}, StdModule.say, {npcHandler = npcHandler, text = "Cruel beings. Large and monstrous, with a single eye, staring at their prey. "})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "distress") or msgcontains(msg, "mission") then
		npcHandler:say({
			"My pride is great but not greater than reason. I am not too proud to ask for help as this is a dark hour. ... ",
			"This glade has been desecrated. We kept it secret for centuries, yet evil has found a way to sully and destroy what was our most sacred. ...",
			"There is only one way to reinvigorate its spirits, a guardian must venture down there and bring life back into the forest. ... ",
			"Stolen {seeds} need to be wrested from the {intruders} and planted where the soil still hungers. ... ",
			"The purest {water} from the purest well needs to be brought there and poured and {birds} that give life need to be brought back to the inner sanctum of the glade. ...",
			"Will you be our guardian?"
		}, cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
			"Indeed, you will. Take one of these cages, which have been crafted generations ago to rob a creature of its freedom for that it may earn it again truthfully. Return the birds back to their home in the glade. ...",
			"You will find {phials} for water near this sacred well which will take you safely to the glade. No seeds are left, they are in the hands of the intruders now. Have faith in yourself, guardian."
			}, cid)
			player:setStorageValue(Storage.ForgottenKnowledge.BirdCage, 1)
			player:addItem(26480, 1)
		end
	elseif msgcontains(msg, "seeds") then
			if npcHandler.topic[cid] == 1 then
			npcHandler:say({
			"Seeds to give life to strong trees, blooming and proud. The {intruders} robbed us from them."
			}, cid)
		end
	elseif msgcontains(msg, "intruders") then
			if npcHandler.topic[cid] == 1 then
			npcHandler:say({
			"The intruders appeared in the blink of an eye. Out of thin air, as if they came from nowhere. They overrun the glade within ours and drove away what was remaining from us within the day."
			}, cid)
		end
	elseif msgcontains(msg, "water") then
			if npcHandler.topic[cid] == 1 then
			npcHandler:say({
			"The purest water flows through this well. For centuries we concealed it, for other beings to not lay their eyes on it."
			}, cid)
		end
	elseif msgcontains(msg, "birds") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				"Take care, guardian."
			}, cid)
		end
	elseif msgcontains(msg, "phials") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				"Phials for the purest water from our sacred well. They are finely crafted and very fragile. We keep a small supply up here around the well. Probably the only thing the intruders did not care for."
			}, cid)
		end
	end
	if msgcontains(msg, "cages") and player:getStorageValue(Storage.ForgottenKnowledge.BirdCage) == 1 then
		npcHandler:say({
			"Crafted generations ago to rob a creature of its freedom for that it may earn it again truthfully. You will need them if you plan on returning the birds to their rightful home in the glade. ... ",
			"Are you in need of another one? "
		}, cid)
		npcHandler.topic[cid] = 2
	end
	if msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say({
				"I already handed a cage to you. If you are in need of another one, you will have to return to me later."
			}, cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
