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
		if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 22 then
			npcHandler:say({
				"Ze rumour mill iz quite fazt. Ezpecially when zomeone unuzual az you enterz ze zity. Zoon zey will learn zat you have no reazon to be here and our raze will be buzted. ...",
				"Zo we have to ztrike fazt and quickly. You will have to eliminate zome high ranking key officialz. I zink killing four of zem should be enough. ...",
				"Ziz will dizrupt ze order in ze zity zignificantly zinze zo much dependz on bureaucracy and ze chain of command. Only chaoz and dizorganization will enable me to help you with ze next ztep in ze plan."
			}, cid)
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 23)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission05, 3) --Questlog, Wrath of the Emperor "Mission 05: New in Town"
			player:setStorageValue(Storage.WrathoftheEmperor.Mission06, 0) --Questlog, Wrath of the Emperor "Mission 06: The Office Job"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 23 and player:getStorageValue(Storage.WrathoftheEmperor.Mission06) == 4 then
			npcHandler:say({
				"Chaoz and panic are already zpreading. Your barbaric brutality iz frightening effectively. I could acquire a key zat we need to get you into ze palaze itzelf. But zere are ztill too many guardz and elite zquadz even for you to fight. ...",
				"I need you to enter ze zity and zlay at leazt zix noblez. Ze otherz will feel zreatened and call guardz to zemzelvez, and ze dragon kingz will accuze each ozer to be rezponzible for zlaying zeir pet noblez. ...",
				"Zat should enable uz to give you at leazt a chanze to attack ze palaze."
			}, cid)
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 24)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission07, 0) --Questlog, Wrath of the Emperor "Mission 07: A Noble Cause"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 24 and player:getStorageValue(Storage.WrathoftheEmperor.Mission07) == 6 then
			if npcHandler.topic[cid] ~= 1 then
				npcHandler:say({
					"Word of your deedz iz already zpreading like a wildfire. Zalamon'z plan to unleash zome murderouz beaztz in ze zity workz almozt too well. You are already becoming zome kind of legend with which motherz frighten zeir unruly hatchlingz. ...",
					"Your next {mizzion} will be a ztrike into ze heart of ze empire."
				}, cid)
				npcHandler.topic[cid] = 1
			else
				npcHandler:say({
					"Your eagernezz for killing and bloodshed iz frightening, but your next mizzion will zuit your tazte. Wiz ze zity in chaoz and defenzez diverted, ze ztage iz zet for our final ztrike. ...",
					"A large number of rebelz have arrived undercover in ze zity. Zey will attack ze palaze and zome loyal palaze guardz will let zem in. ...",
					"Meanwhile, you will take ze old ezcape tunnel zat leadz from ze abandoned bazement in ze norz of ze miniztry to a lift zat endz zomewhere in ze palaze. ...",
					"When everyzing workz according to ze plan, you will meet Zalamon zomewhere in the underground part of ze palaze."
				}, cid)
				player:setStorageValue(Storage.WrathoftheEmperor.Mission08, 1) --Questlog, Wrath of the Emperor "Mission 08: Uninvited Guests"
				player:setStorageValue(Storage.WrathoftheEmperor.Questline, 25)
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
