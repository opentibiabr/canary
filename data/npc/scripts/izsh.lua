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

	if msgcontains(msg, 'mission') then
		if Player(cid):getStorageValue(Storage.WrathoftheEmperor.Questline) == 33 then
			npcHandler:say('Oh yez, let me zee ze documentz. Here we go: zree cheztz filled wiz platinum, one houze, a zet of elite armor, and an unending mana cazket. Iz ziz correct?', cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, 'yes') and npcHandler.topic[cid] == 1 then
		npcHandler:say({
			'Fine, zo let\'z prozeed. You uzed forged documentz to enter our zity, killed zeveral guardz who enjoyed a quite excluzive and expenzive training, deztroyed rare magical devizez in ze pozzezzion of ze emperor. ...',
			'Ze good newz iz, your zree cheztz of platinum should be nearly enough to pay ze finez. Lucky you, ziz could have left you broke. ...',
			'Zere are alzo zertain noble familiez complaining about ze murder of zeveral of zeir beloved onez. ...',
			'I zink I can make a deal wiz ze noblez by zelling zem your property in ze zity. Your prezenze would ruin ze houze prizez zere anyway. ...',
			'Of courze zat will not zuffize to compenzate zeir grief, zo I guezz you\'ll have to part wiz zat elite armor, too. Zadly, prizez for armor are on an all time low right now. ...',
			'But luckily you ztill have zat mana cazket. Well, you had it. Now we have to zell it. ...',
			'But not all iz lozt my blank-zkinned vizitor. According to my calculationz, zere iz ztill a bit left. ...',
			'I zink we can zave you zome gold and zome treazurez, and you can keep one pieze of your elite armor at leazt. ...',
			'You will find your rewardz in one of ze old zupply zellarz. Beware of ze ratz zough. ...',
			'Ze rednezz of your faze and ze zound you make wiz your teez iz obviouzly a zign of gratitude of your zpeziez! I am flattered, but pleaze leave now az I have to attend to zome important buzinezz.'
		}, cid)
		Player(cid):setStorageValue(Storage.WrathoftheEmperor.Questline, 34)
		npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Greetingz zcalelezz being.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
