local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
local talkState = {}
local rtnt = {}
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

keywordHandler:addKeyword({'carrot'}, StdModule.say, {npcHandler = npcHandler, text = "What about 'no' do you not understand, hrm? You are more annoying than any {percht} around here! Not to mention those bothersome {bunnies} who try to graw away my nose!"})
keywordHandler:addKeyword({'percht skull'}, StdModule.say, {npcHandler = npcHandler, text = "Well why didn't you say that rightaway, if you give me such a skull I can give you one of my {sleighs}."})
keywordHandler:addKeyword({'bunnies'}, StdModule.say, {npcHandler = npcHandler, text = "Always trying to eat my nose!"})

npcHandler:setMessage(MESSAGE_GREET, "No, you can't have my nose! If you're in need of a {carrot}, go to the market or just dig up one! Or did you come to bring me a {percht skull}?")


sleighinfo = {
['bright percht sleigh'] = {cost = 0, items = {{35051,1}}, mount = 133, storageID = Storage.Percht1},
['cold percht sleigh'] = {cost = 0, items = {{35051,1}}, mount = 132, storageID = Storage.Percht2},
['dark percht sleigh'] = {cost = 0, items = {{35051,1}}, mount = 134, storageID = Storage.Percht3},
}

local monsterName = {'bright percht sleigh', 'cold percht sleigh', 'dark percht sleigh'}

function creatureSayCallback(cid, type, msg)
local talkUser = cid
local player = Player(cid)

	if(not npcHandler:isFocused(cid)) then
		return false
	end

	if sleighinfo[msg] ~= nil then
		if (getPlayerStorageValue(cid, sleighinfo[msg].storageID) ~= -1) then
				npcHandler:say('You already have this sleigh!', cid)
				npcHandler:resetNpc()
		else
		local itemsTable = sleighinfo[msg].items
		local items_list = ''
			if table.maxn(itemsTable) > 0 then
				for i = 1, table.maxn(itemsTable) do
					local item = itemsTable[i]
					items_list = items_list .. item[2] .. ' ' .. ItemType(item[1]):getName()
					if i ~= table.maxn(itemsTable) then
						items_list = items_list .. ', '
					end
				end
			end
		local text = ''
			if (sleighinfo[msg].cost > 0) then
				text = sleighinfo[msg].cost .. ' gp'
			elseif table.maxn(sleighinfo[msg].items) then
				text = items_list
			elseif (sleighinfo[msg].cost > 0) and table.maxn(sleighinfo[msg].items) then
				text = items_list .. ' and ' .. sleighinfo[msg].cost .. ' gp'
			end
			npcHandler:say('For a ' .. msg .. ' you will need ' .. text .. '. Do you have it with you?', cid)
			rtnt[talkUser] = msg
			talkState[talkUser] = sleighinfo[msg].storageID
			return true
		end
	elseif msg:lower() == 'percht' then
		npcHandler:say('Nasty creatures especially their queen that sits frozzen on her throne beneath this island.', cid)
	elseif msgcontains(msg, "yes") then
		if (talkState[talkUser] >= Storage.Percht1 and talkState[talkUser] <= Storage.Percht3) then
			local items_number = 0
			if table.maxn(sleighinfo[rtnt[talkUser]].items) > 0 then
				for i = 1, table.maxn(sleighinfo[rtnt[talkUser]].items) do
					local item = sleighinfo[rtnt[talkUser]].items[i]
					if (getPlayerItemCount(cid,item[1]) >= item[2]) then
						items_number = items_number + 1
					end
				end
			end
			if(player:removeMoneyNpc(sleighinfo[rtnt[talkUser]].cost) and (items_number == table.maxn(sleighinfo[rtnt[talkUser]].items))) then
				if table.maxn(sleighinfo[rtnt[talkUser]].items) > 0 then
					for i = 1, table.maxn(sleighinfo[rtnt[talkUser]].items) do
						local item = sleighinfo[rtnt[talkUser]].items[i]
						doPlayerRemoveItem(cid,item[1],item[2])
					end
				end
				doPlayerAddMount(cid, sleighinfo[rtnt[talkUser]].mount)
				setPlayerStorageValue(cid,sleighinfo[rtnt[talkUser]].storageID,1)
				npcHandler:say('Here you are.', cid)
			else
				npcHandler:say('You do not have needed items!', cid)
			end
			rtnt[talkUser] = nil
			talkState[talkUser] = 0
			npcHandler:resetNpc()
			return true
		end
	elseif msgcontains(msg, "mount") or msgcontains(msg, "mounts") or msgcontains(msg, "sleigh") or msgcontains(msg, "sleighs") then
		npcHandler:say('I can give you one of the following sleighs: {' .. table.concat(monsterName, "}, {") .. '}.', cid)
		rtnt[talkUser] = nil
		talkState[talkUser] = 0
		npcHandler:resetNpc()
		return true
	elseif msgcontains(msg, "help") then
		npcHandler:say('Just tell me which {sleigh} you want to know more about.', cid)
		rtnt[talkUser] = nil
		talkState[talkUser] = 0
		npcHandler:resetNpc()
		return true
	else
		if talkState[talkUser] ~= nil then
			if talkState[talkUser] > 0 then
			npcHandler:say('Come back when you get these items.', cid)
			rtnt[talkUser] = nil
			talkState[talkUser] = 0
			npcHandler:resetNpc()
			return true
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
