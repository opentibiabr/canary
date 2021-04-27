local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

if not UNDERCOVER_CONTACTED then
	UNDERCOVER_CONTACTED = {}
end

function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)			npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()							npcHandler:onThink()						end

function greetCallback(cid)
	local player = Player(cid)
	local status = player:getStorageValue(SPIKE_LOWER_UNDERCOVER_MAIN)

	if isInArray({-1, 3}, status) then
		return false
	end

	if not UNDERCOVER_CONTACTED[player:getGuid()] then
		UNDERCOVER_CONTACTED[player:getGuid()] = {}
	end

	if isInArray(UNDERCOVER_CONTACTED[player:getGuid()], Creature(getNpcCid()):getId()) then
		return false
	end

	player:setStorageValue(SPIKE_LOWER_UNDERCOVER_MAIN, status + 1)
	table.insert(UNDERCOVER_CONTACTED[player:getGuid()], Creature(getNpcCid()):getId())
	npcHandler:releaseFocus(cid)
	return npcHandler:say("Pssst! Keep it down! <gives you an elaborate report on monster activity>", cid)
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:addModule(FocusModule:new())
