local internalNpcName = "Frosty"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1159,
}

npcConfig.flags = {
	floorchange = false,
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
local talkState = {}
local rtnt = {}

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

local sleightInfo = {
	["bright percht sleigh"] = { cost = 0, items = { { 30192, 1 } }, mount = 133, storageID = Storage.Percht1 },
	["cold percht sleigh"] = { cost = 0, items = { { 30192, 1 } }, mount = 132, storageID = Storage.Percht2 },
	["dark percht sleigh"] = { cost = 0, items = { { 30192, 1 } }, mount = 134, storageID = Storage.Percht3 },
}

local monsterName = { "bright percht sleigh", "cold percht sleigh", "dark percht sleigh" }

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if sleightInfo[message] ~= nil then
		if getPlayerStorageValue(creature, sleightInfo[message].storageID) ~= -1 then
			npcHandler:say("You already have this sleigh!", npc, creature)
			npcHandler:resetNpc(player)
		else
			local itemsTable = sleightInfo[message].items
			local items_list = ""
			if table.maxn(itemsTable) > 0 then
				for i = 1, table.maxn(itemsTable) do
					local item = itemsTable[i]
					items_list = items_list .. item[2] .. " " .. ItemType(item[1]):getName()
					if i ~= table.maxn(itemsTable) then
						items_list = items_list .. ", "
					end
				end
			end
			local text = ""
			if sleightInfo[message].cost > 0 then
				text = sleightInfo[message].cost .. " gp"
			elseif table.maxn(sleightInfo[message].items) then
				text = items_list
			elseif (sleightInfo[message].cost > 0) and table.maxn(sleightInfo[message].items) then
				text = items_list .. " and " .. sleightInfo[message].cost .. " gp"
			end
			npcHandler:say("For a " .. message .. " you will need " .. text .. ". Do you have it with you?", npc, creature)
			rtnt[playerId] = message
			talkState[playerId] = sleightInfo[message].storageID
			return true
		end
	elseif message:lower() == "percht" then
		npcHandler:say("Nasty creatures especially their queen that sits frozzen on her throne beneath this island.", npc, creature)
	elseif MsgContains(message, "yes") then
		if talkState[playerId] >= Storage.Percht1 and talkState[playerId] <= Storage.Percht3 then
			local items_number = 0
			if table.maxn(sleightInfo[rtnt[playerId]].items) > 0 then
				for i = 1, table.maxn(sleightInfo[rtnt[playerId]].items) do
					local item = sleightInfo[rtnt[playerId]].items[i]
					if getPlayerItemCount(creature, item[1]) >= item[2] then
						items_number = items_number + 1
					end
				end
			end
			if player:removeMoneyBank(sleightInfo[rtnt[playerId]].cost) and (items_number == table.maxn(sleightInfo[rtnt[playerId]].items)) then
				if table.maxn(sleightInfo[rtnt[playerId]].items) > 0 then
					for i = 1, table.maxn(sleightInfo[rtnt[playerId]].items) do
						local item = sleightInfo[rtnt[playerId]].items[i]
						doPlayerRemoveItem(creature, item[1], item[2])
					end
				end
				doPlayerAddMount(creature, sleightInfo[rtnt[playerId]].mount)
				setPlayerStorageValue(creature, sleightInfo[rtnt[playerId]].storageID, 1)
				npcHandler:say("Here you are.", npc, creature)
			else
				npcHandler:say("You do not have needed items!", npc, creature)
			end
			rtnt[playerId] = nil
			talkState[playerId] = 0
			npcHandler:resetNpc(player)
			return true
		end
	elseif MsgContains(message, "mount") or MsgContains(message, "mounts") or MsgContains(message, "sleigh") or MsgContains(message, "sleighs") then
		npcHandler:say("I can give you one of the following sleighs: {" .. table.concat(monsterName, "}, {") .. "}.", npc, creature)
		rtnt[playerId] = nil
		talkState[playerId] = 0
		npcHandler:resetNpc(player)
		return true
	elseif MsgContains(message, "help") then
		npcHandler:say("Just tell me which {sleigh} you want to know more about.", npc, creature)
		rtnt[playerId] = nil
		talkState[playerId] = 0
		npcHandler:resetNpc(player)
		return true
	else
		if talkState[playerId] ~= nil then
			if talkState[playerId] > 0 then
				npcHandler:say("Come back when you get these items.", npc, creature)
				rtnt[playerId] = nil
				talkState[playerId] = 0
				npcHandler:resetNpc(player)
				return true
			end
		end
	end
	return true
end

keywordHandler:addKeyword({ "carrot" }, StdModule.say, { npcHandler = npcHandler, text = "What about 'no' do you not understand, hrm? You are more annoying than any {percht} around here! Not to mention those bothersome {bunnies} who try to graw away my nose!" })
keywordHandler:addKeyword({ "percht skull" }, StdModule.say, { npcHandler = npcHandler, text = "Well why didn't you say that rightaway, if you give me such a skull I can give you one of my {sleighs}." })
keywordHandler:addKeyword({ "bunnies" }, StdModule.say, { npcHandler = npcHandler, text = "Always trying to eat my nose!" })

npcHandler:setMessage(MESSAGE_GREET, "No, you can't have my nose! If you're in need of a {carrot}, go to the market or just dig up one! Or did you come to bring me a {percht skull}?")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
