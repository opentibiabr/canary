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

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

shopModule:addBuyableItem({"broken compass"}, 29047, 10000)

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "monument") then
		npcHandler:say({
        "Well, a while ago powerful magic devices were used all around Tibia. These are chargeable compasses. There was but one problem: they offered the possibility to make people rich in a quite easy way. ...",
         "Therefore, these instruments were very coveted. People tried to get their hands on them at all costs. And so it happened what everybody feared - bloody battles forged ahead. ...",
         "To put an end to these cruel escalations, eventually all of the devices were collected and destroyed. The remains were buried {deep} in the earth."
     }, cid, false, true, 10)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, "deep") then
		npcHandler:say("As far as I know it is a place of helish heat with bloodthirsty monsters of all kinds.", cid)
		npcHandler.topic[cid] = 0
    elseif msgcontains(msg, "sarcophagus") then
		npcHandler:say("This sarcophagus seals the entrance to the caves down there. Only here you can get all the {materials} you need for a working compass of this kind. So no entrance here - no further magic compasses in Tibia. In theory.", cid)
		npcHandler.topic[cid] = 0
    elseif msgcontains(msg, "materials") then
        if player:getStorageValue(Storage.Quest.TheDreamCourts.AndrewDoor) ~= 1 then
            player:setStorageValue(Storage.Quest.TheDreamCourts.AndrewDoor, 1)
        end
		npcHandler:say({
         "Only in the cave down there you will find the materials you need to repair the compass. Now you know why the entrance is sealed. There's the seal, but I have a deal for you: ...",
         "I can repair the compass for you if you deliver what I need. Besides the broken compass you have to bring me the following materials: 50 blue glas plates, 15 green glas plates and 5 violet glas plates. ...",
         "They all can be found in this closed cave in front of you. I should have destroyed this seal key but things have changed. The entrance is opened now, go down and do what has to be done."}, cid, false, true, 10)
     npcHandler.topic[cid] = 2
    elseif msgcontains(msg, "down") then
		npcHandler:say("On first glance, this cave does not look very spectacular, but the things you find in there, are. You have to know that this is the only place where you can find the respective materials to build the {compass}.", cid)
     npcHandler.topic[cid] = 0
    elseif msgcontains(msg, "compass") then
		npcHandler:say("It was decided to collect all of the compasses, destroy them and throw them in the fiery {depths} of Tibia. I still have some of them here. I {sell} them for a low price if you want.", cid)
		npcHandler.topic[cid] = 0
    elseif msgcontains(msg, "depths") then
		npcHandler:say("As far as I know it is a place of helish heat with bloodthirsty monsters of all kinds.", cid)
		npcHandler.topic[cid] = 0
    elseif msgcontains(msg, "sell") then
		npcHandler:say("Would you like to buy a broken compass for 10.000 gold?", cid)
     npcHandler.topic[cid] = 1
    elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 1 then
        local message = "You have bought a compass"
        if not checkWeightAndBackpackRoom(player, 80, message) then
            npcHandler:say("You not have room or capacity to take it.", cid)
            return true
        end
        if player:getMoney() + player:getBankBalance() >= 5000 then
            player:removeMoneyNpc(5000)
            player:addItem(11219, 1)
        end
        npcHandler.topic[cid] = 0  
    end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "Hello, I am the warden of this {monument}. The {sarcophagus} in front of you was established to prevent people from going {down} there. But I {doubt} that this step is sufficient.")

npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")

npcHandler:addModule(FocusModule:new())
