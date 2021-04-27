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

	-- Mission 1 - The Supply Thief
	if msgcontains(msg, "job") then
		if Player(cid):getStorageValue(Storage.DjinnWar.EfreetFaction.Mission01) == 2 then
			npcHandler:say("What do you think? I am the sheriff of Carlin.", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "water pipe") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				"Oh, there's a waterpipe in one of my cells? ...",
				"I guess my last {prisoner} forgot it there."
			}, cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, "prisoner") then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say({
				"My last prisoner? Hmm. ...", "I think he was some guy from Darama. Can't remember his name. ...",
				"He was here just for one night, because he got drunk and annoyed our citizens. ...",
				"Obviously he wasn't pleased with this place, because he headed for Thais the next day. ...",
				"Something tells me that he won't stay out of trouble for too long."
			}, cid)
			Player(cid):setStorageValue(Storage.DjinnWar.EfreetFaction.Mission01, 3)
			npcHandler.topic[cid] = 0
		end
	end
	-- Mission 1 - The Supply Thief
	return true
end

keywordHandler:addKeyword({'news'}, StdModule.say, {npcHandler = npcHandler, text = "No news are good news."})
keywordHandler:addKeyword({'queen'}, StdModule.say, {npcHandler = npcHandler, text = "HAIL TO QUEEN ELOISE!"})
keywordHandler:addKeyword({'leader'}, StdModule.say, {npcHandler = npcHandler, text = "HAIL TO QUEEN ELOISE!"})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = "Just fine."})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = "Would you like to buy the general key to the town?"})
keywordHandler:addKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = "Yeah, I bet you'd like to do that! HO, HO, HO!"})
keywordHandler:addKeyword({'army'}, StdModule.say, {npcHandler = npcHandler, text = "If they make trouble, I'll put them behind bars like all others."})
keywordHandler:addKeyword({'guard'}, StdModule.say, {npcHandler = npcHandler, text = "If they make trouble, I'll put them behind bars like all others."})
keywordHandler:addKeyword({'general'}, StdModule.say, {npcHandler = npcHandler, text = "The Bonecrusher family is ideally suited for military jobs."})
keywordHandler:addKeyword({'bonecrusher'}, StdModule.say, {npcHandler = npcHandler, text = "The Bonecrusher family is ideally suited for military jobs."})
keywordHandler:addKeyword({'enemies'}, StdModule.say, {npcHandler = npcHandler, text = "If you have a crime to report and clues, then do it, but don't waste my time."})
keywordHandler:addKeyword({'enemy'}, StdModule.say, {npcHandler = npcHandler, text = "If you have a crime to report and clues, then do it, but don't waste my time."})
keywordHandler:addKeyword({'criminal'}, StdModule.say, {npcHandler = npcHandler, text = "If you have a crime to report and clues, then do it, but don't waste my time."})
keywordHandler:addKeyword({'murderer'}, StdModule.say, {npcHandler = npcHandler, text = "If you have a crime to report and clues, then do it, but don't waste my time."})
keywordHandler:addKeyword({'castle'}, StdModule.say, {npcHandler = npcHandler, text = "The castle is one of the safest places in Carlin."})
keywordHandler:addKeyword({'subject'}, StdModule.say, {npcHandler = npcHandler, text = "Our people are fine and peaceful."})
keywordHandler:addKeyword({'tbi'}, StdModule.say, {npcHandler = npcHandler, text = "I bet they spy on us... not my business, however."})
keywordHandler:addKeyword({'todd'}, StdModule.say, {npcHandler = npcHandler, text = "I scared this bigmouth so much that he left the town by night. HO, HO, HO!"})
keywordHandler:addKeyword({'city'}, StdModule.say, {npcHandler = npcHandler, text = "The city is is a peaceful place, and it's up to me to keep it this way."})
keywordHandler:addKeyword({'hain'}, StdModule.say, {npcHandler = npcHandler, text = "He is the guy responsible to keep the sewers working. Someone has to do such kind of jobs. I can't handle all the garbage of the city myself."})
keywordHandler:addKeyword({'rowenna'}, StdModule.say, {npcHandler = npcHandler, text = "Rowenna is one of our local smiths. When you look for weapons, look for Rowenna."})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = "Rowenna is one of our local smiths. When you look for weapons, look for Rowenna."})
keywordHandler:addKeyword({'cornelia'}, StdModule.say, {npcHandler = npcHandler, text = "Cornelia is one of our local smiths. When you look for armor, look for Cornelia."})
keywordHandler:addKeyword({'armor'}, StdModule.say, {npcHandler = npcHandler, text = "Cornelia is one of our local smiths. When you look for armor, look for Cornelia."})
keywordHandler:addKeyword({'legola'}, StdModule.say, {npcHandler = npcHandler, text = "She has the sharpest eye in the region, I'd say."})
keywordHandler:addKeyword({'padreia'}, StdModule.say, {npcHandler = npcHandler, text = "Her peacefulness is sometimes near stupidity."})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = "I worship Banor of course."})
keywordHandler:addKeyword({'banor'}, StdModule.say, {npcHandler = npcHandler, text = "For me, he's the god of justice."})
keywordHandler:addKeyword({'zathroth'}, StdModule.say, {npcHandler = npcHandler, text = "His cult is forbidden in our town."})
keywordHandler:addKeyword({'brog'}, StdModule.say, {npcHandler = npcHandler, text = "Wouldn't wonder if some males worship him secretly. HO, HO, HO!"})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = "I deal more with the human mosters, you know? HO, HO, HO!"})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = "Would certainly make a good butterknife. HO, HO, HO!"})
keywordHandler:addKeyword({'rebellion'}, StdModule.say, {npcHandler = npcHandler, text = "The only thing that rebels here now and then is the stomach of a male after trying to make illegal alcohol. HO, HO, HO!"})
keywordHandler:addKeyword({'alcohol'}, StdModule.say, {npcHandler = npcHandler, text = "For obvious reasons it's forbidden in our city."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Howdy, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_FAREWELL, "LONG LIVE THE QUEEN!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "LONG LIVE THE QUEEN!")
npcHandler:addModule(FocusModule:new())
