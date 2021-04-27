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
	if msgcontains(msg, "do for you") then
			npcHandler:say("I run the dog sled service from this city to {Nibelor}.", cid)
	elseif msgcontains(msg, "Nibelor") or msgcontains(msg, "passage") then
			npcHandler:say("Do you want to Nibelor?", cid)
			npcHandler.topic[cid] = 2
	elseif msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.BarbarianTest.Questline) >= 8 then -- if Barbarian Test absolved
			if player:getStorageValue(Storage.TheIceIslands.Questline) < 1 then
				npcHandler:say({
					"Well, one of the boys has run away. I think he got the scent of some beast. He's young and inexperienced so I can't blame the cub ...",
					"I would like you to see after him. He should be somewhere north west of the town. He is probably marking his territory so you should be able to find his trace. Are you willing to do that?"
				}, cid)
				npcHandler.topic[cid] = 1
			elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 2 then
				npcHandler:say("You are a friend of mine and the boys now. I tell you something. If you ever need to go to the isle of Nibelor, just ask me for a {passage}.", cid)
				player:setStorageValue(Storage.TheIceIslands.Questline, 3)
				player:setStorageValue(Storage.TheIceIslands.Mission01, 3) -- Questlog The Ice Islands Quest, Befriending the Musher
				npcHandler.topic[cid] = 0
			else
			npcHandler:say("I have now no mission for you.", cid)
			npcHandler.topic[cid] = 0
			end
		else
			npcHandler:say("Sorry but I only give missions to those who are considered a true Barbarian. ", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				"That's surprising. Take a piece of meat. If you find the boy, feed it to him. That will give him enough strength and incentive to return to his pack ...",
				"Talk to him by calling his name 'Sniffler' and tell him you got meat for him. After he has eaten the meat, return here to talk to me about your mission."
			}, cid)
			player:setStorageValue(Storage.TheIceIslands.Questline, 1)
			player:setStorageValue(Storage.TheIceIslands.Mission01, 1) -- Questlog The Ice Islands Quest, Befriending the Musher
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 2 then
			--if player:getStorageValue(Storage.TheIceIslands.Questline) >= 3 then
			player:teleportTo(Position(32325, 31049, 7))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler.topic[cid] = 0
			--else
			--npcHandler:say("Sorry, first time you have to do a mission for me.", cid)
			--npcHandler.topic[cid] = 0
			--end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
