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
		if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 2 then
			npcHandler:say("Mhm, what are you doing here. Who zent you? ", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 3 then
			npcHandler:say("Zo are you ready to get zomezing done?", cid)
			npcHandler.topic[cid] = 2
		elseif player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 5 then
			npcHandler:say("Zo? Did you find a way to reztore ze teleporter? ", cid)
			npcHandler.topic[cid] = 3
		end
	elseif msgcontains(msg, "zalamon") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				"I zee. Zalamon zent word of ze arrival of a zoftzkin quite zome time ago. Zat muzt be you zen. ... ",
				"Well, I exzpected zomeone more - imprezzive. However, we will zee how far you can get. You've got newz from ze zouz? ... ",
				"Hm, I underztand. ... ",
				"Oh you did. ... ",
				"I zee. Interezting. ... ",
				"You being here meanz we have eztablished connectionz to ze zouz. Finally. And you are going to help uz. Well, zere iz zertainly a lot for you to do. Zo better get ztarted. "
			}, cid)
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 3)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission01, 3) --Questlog, Wrath of the Emperor "Mission 01: Catering the Lions Den"
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say({
				"Alright. Well, az you might not be aware of it yet - we are on top of an old temple complex. It haz been abandoned and it haz crumbled over time. ...",
				"Ze teleporter over zere uzed to work juzt fine to get uz back to ze zouz. But it haz ztopped operating for quite zome time. ... ",
				"My men believe it iz a dizturbanze cauzed by ze corruption zat zpreadz everywhere. Zey are too zcared to go down zere. And zat'z where you come in. ... ",
				"Zere were meanz to activate teleporterz zomewhere in ze complex. But zinze you cannot reach all ze roomz, I guezz you will have to improvize. ... ",
				"Here iz ze key to ze entranze to ze complex. Figure zomezing out, reztore ze teleporter zo we can get back to ze plainz in ze zouz. "
			}, cid)
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 4)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission02, 1) --Questlog, Wrath of the Emperor "Mission 02: First Contact"
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then
			npcHandler:say({
				"You did it! Zere waz zome kind of zparkle and I zink it iz working again - oh pleaze feel free to try it, I uhm, I will wait here and be ready juzt in caze zomezing uhm happenz to you. ... ",
				"And if you head to Zalamon, be zure to inform him about our zituation. Food rationz are running low and we are ztill not well equipped. We need to eztablish a working zupply line. "
			}, cid)
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 6)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission02, 3) --Questlog, Wrath of the Emperor "Mission 02: First Contact"
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
