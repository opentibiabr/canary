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
	-- START TASK
	if msgcontains(msg, "food") then
		if player:getStorageValue(Storage.Oramond.MissionToTakeRoots) <= 0 then
			npcHandler:say({
				"Hey there, just to let you know - I am not a man of many words. I prefer 'deeds', you see? The poor of this city will not feed themselves. ...",
				"So in case you've got nothing better to do - and it sure looks that way judging by how long you\'re already loitering around in front of my nose - please help us. ...",
				"If you can find some of the nutritious, juicy {roots} in the outskirts of Rathleton, bring them here. We will gladly take bundles of five roots each, and hey - helping us, helps you in the long term, trust me."
			}, cid, false, true, 10)
			if player:getStorageValue(Storage.Oramond.QuestLine) <= 0 then
				player:setStorageValue(Storage.Oramond.QuestLine, 1)
			end
			player:setStorageValue(Storage.Oramond.MissionToTakeRoots, 1)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.Oramond.MissionToTakeRoots) == 1 then
			if player:getStorageValue(Storage.Oramond.HarvestedRootCount) < 5 then
				npcHandler:say("I am sorry, you didn't harvest enough roots. You need to harvest a bundle of at least five roots - and please try doing it yourself.", cid)
				npcHandler.topic[cid] = 0
			elseif player:getStorageValue(Storage.Oramond.HarvestedRootCount) >= 5 then
				npcHandler:say("Yes? You brought some juicy roots? How nice of you - that's one additional voice in the {magistrate} of {Rathleton} for you! ...", cid)
				npcHandler.topic[cid] = 1
			end
		end
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 1 then
		npcHandler:say("Spend it wisely, though, put in a word for the poor, will ye? Sure you will.", cid)
		player:setStorageValue(Storage.Oramond.VotingPoints,
			player:getStorageValue(Storage.Oramond.VotingPoints) + 1)

		player:setStorageValue(Storage.Oramond.HarvestedRootCount,
			player:getStorageValue(Storage.Oramond.HarvestedRootCount) - 5)
		player:removeItem(23662, 5)

		player:setStorageValue(Storage.Oramond.MissionToTakeRoots, 0)
		player:setStorageValue(Storage.Oramond.DoorBeggarKing, 1)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, "root") then
		npcHandler:say("They are nutritious, cost nothing and are good for the body hair. If you can bring us bundles of five juicy roots each - we will make it worth your while for the {magistrate}.", cid)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, "magistrate") then
		npcHandler:say("They act so important but it is us common people who keep things going. There is a lot you can do in this city to earn a right to vote in the magistrate, though. So keep an eye out for everyone who needs help.", cid)
	elseif msgcontains(msg, "rathleton") then
		npcHandler:say({
			"Don't be fooled, we have here masters and servants like everywhere else. The whole system is a scam to subdue the masses, to fool them about what is really happening. ...",
			"The system only ensures that the rich have a better control and the labourers are only used."
		}, cid, false, true, 10)
		npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Hey there! You don\'t happen to have some {food} on you, you\'re willing to share? Well, where are my manners, a warm welcome for now.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Take care out there!')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
