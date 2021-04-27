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

local choose = {}
local cancel = {}

local grizzlyAdamsConfig = {
	ranks = {
		huntsMan_rank = {
			-- SELL OFFERS
			{id=11214, buy=0, sell=50, name="antlers"},
			{id=10550, buy=0, sell=100, name="bloody pincers"},
			{id=11189, buy=0, sell=35, name="crab pincers"},
			{id=10574, buy=0, sell=55, name="cyclops toe"},
			{id=13303, buy=0, sell=550, name="cavebear skull"},
			{id=20098, buy=0, sell=150, name="cheesy figurine"},
			{id=12470, buy=0, sell=110, name="colourful feather"},
			{id=7398, buy=0, sell=500, name="cyclops trophy"},
			{id=11315, buy=0, sell=15000, name="draken trophy"},
			{id=13296, buy=0, sell=800, name="draptor scales"},
			{id=21311, buy=0, sell=115, name="elven hoof"},
			{id=10565, buy=0, sell=30, name="frosty ear of a troll"},
			{id=13304, buy=0, sell=950, name="giant crab pincer"},
			{id=12495, buy=0, sell=20, name="goblin ear"},
			{id=13301, buy=0, sell=400, name="hollow stampor hoof"},
			{id=11199, buy=0, sell=600, name="hydra head"},
			{id=11372, buy=0, sell=80, name="lancer beetle shell"},
			{id=11336, buy=0, sell=8000, name="lizard trophy"},
			{id=12445, buy=0, sell=280, name="mantassin tail"},
			{id=19741, buy=0, sell=65, name="marsh stalker beak"},
			{id=19742, buy=0, sell=50, name="marsh stalker feather"},
			{id=13302, buy=0, sell=250, name="maxilla"},
			{id=7401, buy=0, sell=500, name="minotaur trophy"},
			{id=10579, buy=0, sell=420, name="mutated bat ear"},
			{id=13026, buy=0, sell=750, name="panther head"},
			{id=13027, buy=0, sell=300, name="panther paw"},
			{id=12447, buy=0, sell=500, name="quara bone"},
			{id=12447, buy=0, sell=350, name="quara eye"},
			{id=12446, buy=0, sell=410, name="quara pincers"},
			{id=12443, buy=0, sell=140, name="quara tentacle"},
			{id=13159, buy=0, sell=50, name="rabbit's foot"},
			{id=21310, buy=0, sell=70, name="rorc feather"},
			{id=11228, buy=0, sell=400, name="sabretooth"},
			{id=11373, buy=0, sell=20, name="sandcrawler shell"},
			{id=10548, buy=0, sell=280, name="scarab pincers"},
			{id=13299, buy=0, sell=280, name="stampor horn"},
			{id=13300, buy=0, sell=150, name="stampor talons"},
			{id=11371, buy=0, sell=60, name="terramite legs"},
			{id=11369, buy=0, sell=170, name="terramite shell"},
			{id=11190, buy=0, sell=95, name="terrorbird beak"},
			-- BUY OFFERS
			{id=5907, buy=35000, sell=0, name="slingshot"}
		},

		bigGameHunter_rank = {
			{id=11161, buy=0, sell=6000, name="bonebeast trophy"},
			{id=7397, buy=0, sell=3000, name="deer trophy"},
			{id=7400, buy=0, sell=3000, name="lion trophy"},
			{id=7395, buy=0, sell=1000, name="orc trophy"},
			{id=7394, buy=0, sell=3000, name="wolf trophy"}
		},

		trophyHunter_rank = {
			-- SELL OFFERS
			{id=7396, buy=0, sell=20000, name="behemoth trophy"},
			{id=7393, buy=0, sell=40000, name="demon trophy"},
			{id=7399, buy=0, sell=10000, name="dragon lord trophy"},
			{id=11338, buy=0, sell=3000, name="disgusting trophy"},
			{id=24757, buy=0, sell=9000, name="werebadger trophy"},
			{id=24758, buy=0, sell=10000, name="wereboar trophy"},
			{id=24759, buy=0, sell=11000, name="werebear trophy"},
			{id=30941, buy=0, sell=9000, name="werefox trophy"},
			{id=39054, buy=0, sell=12000, name="werehyaena trophy"},
			-- BUY OFFERS
			{id=10518, buy=1000, sell=0, name="demon backpack"}
		},
	}
}

local items, data = {}
for i = 1, #grizzlyAdamsConfig.ranks.huntsMan_rank do
	data = grizzlyAdamsConfig.ranks.huntsMan_rank[i]
	items[data.id] = {id = data.id, buy = data.buy, sell = data.sell, name = ItemType(data.id):getName():lower()}
end
for i = 1, #grizzlyAdamsConfig.ranks.bigGameHunter_rank do
	data = grizzlyAdamsConfig.ranks.bigGameHunter_rank[i]
	items[data.id] = {id = data.id, buy = data.buy, sell = data.sell, name = ItemType(data.id):getName():lower()}
end
for i = 1, #grizzlyAdamsConfig.ranks.trophyHunter_rank do
	data = grizzlyAdamsConfig.ranks.trophyHunter_rank[i]
	items[data.id] = {id = data.id, buy = data.buy, sell = data.sell, name = ItemType(data.id):getName():lower()}
end

local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(JOIN_STOR) == -1 then
		npcHandler:setMessage(MESSAGE_GREET,
					"Hi there, do you want to to join the 'Paw and Fur - Hunting Elite'?")
	else
		npcHandler:setMessage(MESSAGE_GREET,
							"Welcome to the 'Paw and Fur - Hunting Elite' |PLAYERNAME|. "..
							"Feel free to do {tasks} for us.")
	end
	return true
end

local function joinTables(old, new)
	for k, v in pairs(new) do
		old[k] = v
	end
	return old
end

local function onBuy(cid, item, subType, amount, ignoreCap, inBackpacks)
	local player = Player(cid)
	if not ignoreCap and player:getFreeCapacity() < ItemType(items[item].id):getWeight(amount) then
		return player:sendTextMessage(MESSAGE_FAILURE, "You don't have enough cap.")
	end
	if items[item].buy then
		if player:removeMoneyNpc(amount * items[item].buy) then
			player:addItem(items[item].id, amount)
			return player:sendTextMessage(MESSAGE_TRADE,
						"Bought "..amount.."x "..items[item].name.." for "..items[item].buy * amount.." gold coins.")
		else
			return player:sendTextMessage(MESSAGE_FAILURE, "You don't have enough money.")
		end
	end
	return true
end

local function onSell(cid, item, subType, amount, ignoreCap, inBackpacks)
	local player = Player(cid)
	if items[item].sell then
		if player:removeItem(items[item].id, amount) then
			player:addMoney(items[item].sell * amount)
			return player:sendTextMessage(MESSAGE_TRADE,
						"Sold "..amount.."x "..items[item].name.." for "..items[item].sell * amount.." gold coins.")
		else
			return player:sendTextMessage(MESSAGE_TRADE, "You don't have the items you're trying to sell.")
		end
	end
	return true
end

local function startTrade(cid, player)
	if player:getPawAndFurRank() >= 2 then
		local tradeItems = grizzlyAdamsConfig.ranks.huntsMan_rank
		if player:getPawAndFurRank() >= 4 then
			tradeItems = joinTables(tradeItems, grizzlyAdamsConfig.ranks.bigGameHunter_rank)
		end
		if player:getPawAndFurRank() >= 6 then
			tradeItems = joinTables(tradeItems, grizzlyAdamsConfig.ranks.trophyHunter_rank)
		end
		openShopWindow(cid, tradeItems, onBuy, onSell)
		return npcHandler:say("It's my offer.", cid)
	else
		return npcHandler:say("You don't have any rank.", cid)
	end
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	msg = msg:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)

	if msgcontains("trade", msg) then
		startTrade(cid, player)
	elseif (msgcontains("join", msg) or msgcontains("yes", msg))
			and npcHandler.topic[cid] == 0
			and player:getStorageValue(JOIN_STOR) ~= 1 then
		player:setStorageValue(JOIN_STOR, 1)
		npcHandler:say("Great! " ..
					"A warm welcome to our newest member: |PLAYERNAME|! " ..
					"Ask me for a {task} if you want to go on a hunt.", cid)
	elseif isInArray({"tasks", "task", "mission"}, msg:lower()) then
		if player:getStorageValue(JOIN_STOR) == -1 then
			return npcHandler:say("You'll have to {join}, to get any {tasks}.",cid)
		end

		local can = player:getTasks()

		if #can > 0 then
			local text = ""
			local sep = ", "
			table.sort(can, function(a, b) return a < b end)
			local t = 0
			local id
			for i = 1, #can do
				id = can[i]
				t = t + 1
				if t == #can - 1 then
					sep = " and "
				elseif t == #can then
					sep = "."
				end
				text = text .. "{" .. (tasks[id].name or tasks[id].raceName) .. "}" .. sep
			end
			npcHandler:say("The current task" ..
						(#can > 1 and "s" or "") .. " that you can choose " ..
						(#can > 1 and "are" or "is") .. " " .. text, cid)
			npcHandler.topic[cid] = 0
		else
			npcHandler:say("I don't have any task for you right now.", cid)
		end
	elseif msg ~= "" and player:canStartTask(msg) then
		if #player:getStartedTasks() >= tasksByPlayer then
			npcHandler:say("Sorry, but you already started " .. tasksByPlayer .. " tasks."..
						" ".."You can check their {status}, {cancel} or {report} a task.", cid)
			return true
		end
		local task = getTaskByName(msg)
		if task and player:getStorageValue(QUESTSTORAGE_BASE + task) > 0 then
			return false
		end
		npcHandler:say("In this task you must defeat " .. tasks[task].killsRequired .. " " .. tasks[task].raceName .. "."..
					" ".."Are you sure that you want to start this task?", cid)
		choose[cid] = task
		npcHandler.topic[cid] = 1
	elseif msg:lower() == "yes" and npcHandler.topic[cid] == 1 then
		player:setStorageValue(QUESTSTORAGE_BASE + choose[cid], 1)
		player:setStorageValue(KILLSSTORAGE_BASE + choose[cid], 0)
		npcHandler:say("Excellent! You can check the {status} of your task saying {report} to me."..
					" ".."Also you can {cancel} tasks to.", cid)
		choose[cid] = nil
		npcHandler.topic[cid] = 0
	elseif msgcontains("status", msg) then
		local started = player:getStartedTasks()
		if started and #started > 0 then
			local text = ""
			table.sort(started, (function(a, b) return (a < b) end))
			local t = 0
			local id
			for i = 1, #started do
				id = started[i]
				t = t + 1
				text = text .. "Task name: " .. tasks[id].raceName .. ". "..
					"Current kills: " .. player:getStorageValue(KILLSSTORAGE_BASE + id) .. ".\n"
			end
			npcHandler:say({"The status of your current tasks is:\n" .. text}, cid)
		else
			npcHandler:say("You haven't started any task yet.", cid)
		end
	elseif msgcontains("report", msg) then
		local started = player:getStartedTasks()
		local finishedAtLeastOne = false
		local finished = 0
		if started and #started > 0 then
			local id, reward
			for i = 1, #started do
				id = started[i]
				if player:getStorageValue(KILLSSTORAGE_BASE + id) >= tasks[id].killsRequired then
					for j = 1, #tasks[id].rewards do
						reward = tasks[id].rewards[j]
						local deny = false
						if reward.storage then
							if player:getStorageValue(reward.storage[1]) >= reward.storage[2] then
								deny = true
							end
						end
						if isInArray({REWARD_MONEY, "money"}, reward.type:lower()) and not deny then
							player:addMoney(reward.value[1])
						elseif isInArray({REWARD_EXP, "exp", "experience"}, reward.type:lower()) and not deny then
							player:addExperience(reward.value[1], true)
						elseif isInArray({REWARD_ACHIEVEMENT, "achievement", "ach"}, reward.type:lower()) and not deny then
							player:addAchievement(reward.value[1])
						elseif isInArray({REWARD_STORAGE, "storage", "stor"}, reward.type:lower()) and not deny then
							player:setStorageValue(reward.value[1], reward.value[2])
						elseif isInArray({REWARD_POINT, "points", "point"}, reward.type:lower()) and not deny then
							player:setStorageValue(POINTSSTORAGE, getPlayerTasksPoints(cid) + reward.value[1])
						elseif isInArray({REWARD_ITEM, "item", "items", "object"}, reward.type:lower()) and not deny then
							player:addItem(reward.value[1], reward.value[2])
						end

						if reward.storage then
							player:setStorageValue(reward.storage[1], reward.storage[2])
						end
					end

					player:setStorageValue(QUESTSTORAGE_BASE + id, (tasks[id].norepeatable and 2 or 0))
					player:setStorageValue(KILLSSTORAGE_BASE + id, -1)
					player:setStorageValue(REPEATSTORAGE_BASE + id, math.max(player:getStorageValue(REPEATSTORAGE_BASE + id), 0))
					player:setStorageValue(REPEATSTORAGE_BASE + id, player:getStorageValue(REPEATSTORAGE_BASE + id) + 1)
					finishedAtLeastOne = true
					finished = finished + 1
				end
			end
			if not finishedAtLeastOne then
				local started = player:getStartedTasks()
				if started and #started > 0 then
					local text = ""
					local sep = ", "
					table.sort(started, (function(a, b) return (a < b) end))
					local t = 0
					local id
					for i = 1, #started do
						id = started[i]
						t = t + 1
						if (t == #started - 1) then
							sep = " and "
						elseif (t == #started) then
							sep = "."
						end
						text = text .. "{" .. (tasks[id].name or tasks[id].raceName) .. "}" .. sep
					end
					npcHandler:say("The current task" .. (#started > 1 and "s" or "") ..
								" that you started " .. (#started > 1 and "are" or "is") .. " " .. text, cid)
				end
			else
				npcHandler:say("Awesome! "..
							"You finished "..(finished > 1 and "various" or "a").." task"..(finished > 1 and "s" or "").."."..
							"Talk to me again if you want to start a {task}.", cid)
			end
		else
			npcHandler:say("You haven't started any task yet.", cid)
		end
	elseif msg:lower() == "started" then
		local started = player:getStartedTasks()
		if started and #started > 0 then
			local text = ""
			local sep = ", "
			table.sort(started, (function(a, b) return (a < b) end))
			local t = 0
			local id
			for i = 1, #started do
				id = started[i]
				t = t + 1
				if t == #started - 1 then
					sep = " and "
				elseif t == #started then
					sep = "."
				end
				text = text .. "{" .. (tasks[id].name or tasks[id].raceName) .. "}" .. sep
			end

			npcHandler:say("The current task" .. (#started > 1 and "s" or "") .. " that you started" ..
				" " .. (#started > 1 and "are" or "is") .. " " .. text, cid)
		else
			npcHandler:say("You haven't started any task yet.", cid)
		end
	elseif msg:lower() == "cancel" then
		local started = player:getStartedTasks()
		local text = ""
		local sep = ", "
		table.sort(started, (function(a, b) return (a < b) end))
		local t = 0
		local id
		for i = 1, #started do
			id = started[i]
			t = t + 1
			if t == #started - 1 then
				sep = " or "
			elseif t == #started then
				sep = "?"
			end
			text = text .. "{" .. (tasks[id].name or tasks[id].raceName) .. "}" .. sep
		end
		if started and #started > 0 then
			npcHandler:say("Canceling a task will make the counter restart. " ..
						"Which of these tasks you want cancel?" .. (#started > 1 and "" or "") .. " " .. text, cid)
			npcHandler.topic[cid] = 2
		else
			npcHandler:say("You haven't started any task yet.", cid)
		end
	elseif ((getTaskByName(msg)) and
			(npcHandler.topic[cid] == 2) and
			(isInArray(getPlayerStartedTasks(cid), getTaskByName(msg)))) then
		local task = getTaskByName(msg)
		if player:getStorageValue(KILLSSTORAGE_BASE + task) > 0 then
			npcHandler:say("You currently killed " .. player:getStorageValue(KILLSSTORAGE_BASE + task) .. "/" ..
						tasks[task].killsRequired .. " " .. tasks[task].raceName .. "."..
						" ".."Canceling this task will restart the count."..
						" ".."Are you sure you want to cancel this task?", cid)
		else
			npcHandler:say("Are you sure you want to cancel this task?", cid)
		end
		npcHandler.topic[cid] = 3
		cancel[cid] = task
	elseif ((getTaskByName(msg)) and
			(npcHandler.topic[cid] == 1) and
			(isInArray(getPlayerStartedTasks(cid), getTaskByName(msg)))) then
		local task = getTaskByName(msg)
		if player:getStorageValue(KILLSSTORAGE_BASE + task) > 0 then
			npcHandler:say("You currently killed " ..
						player:getStorageValue(KILLSSTORAGE_BASE + task) .. "/" ..
						tasks[task].killsRequired .. " " ..
						tasks[task].raceName .. ".", cid)
		else
			npcHandler:say("You currently killed 0/" .. tasks[task].killsRequired .. " " .. tasks[task].raceName .. ".", cid)
		end
		npcHandler.topic[cid] = 0
	elseif msg:lower() == "yes" and npcHandler.topic[cid] == 3 then
		player:setStorageValue(QUESTSTORAGE_BASE + cancel[cid], -1)
		player:setStorageValue(KILLSSTORAGE_BASE + cancel[cid], -1)
		npcHandler:say("You have canceled the task " ..
					(tasks[cancel[cid]].name or tasks[cancel[cid]].raceName) .. ".", cid)
		npcHandler.topic[cid] = 0
	elseif isInArray({"points", "rank"}, msg:lower()) then
		npcHandler:say("At this time, you have " .. player:getPawAndFurPoints() .. " Paw & Fur points. You " ..
					(player:getPawAndFurRank() == 6 and "are an Elite Hunter" or
					player:getPawAndFurRank() == 5 and "are a Trophy Hunter" or
					player:getPawAndFurRank() == 4 and "are a Big Game Hunter" or
					player:getPawAndFurRank() == 3 and "are a Ranger" or
					player:getPawAndFurRank() == 2 and "are a Huntsman" or
					player:getPawAndFurRank() == 1 and "are a Member"  or
					"haven't been ranked yet") .. ".", cid)
		npcHandler.topic[cid] = 0
	elseif isInArray({"special task"}, msg:lower()) then
		if (player:getPawAndFurPoints() >= 70) then
			if ((player:getLevel() > 90) and
				(player:getStorageValue(Storage.KillingInTheNameOf.MissionTiquandasRevenge) == 1) and
				(player:getStorageValue(Storage.KillingInTheNameOf.TiquandasRevengeTeleport) ~= 0)) then
				npcHandler:say("You have already started the task. Go find Tiquandas Revenge and take revenge yourself!", cid)
			else
				npcHandler:say({"Have you heard about Tiquandas Revenge? " ..
							"It is said that the jungle itself is alive and takes revenge for all the bad things people have done to it." ..
							"...",
							"I myself believe that there is some truth in this clap trap." ..
							"Something 'real' which therefore must have a hideout somewhere." ..
							"Go find it and take revenge yourself!"}, cid)
				player:setStorageValue(Storage.KillingInTheNameOf.TiquandasRevengeTeleport, 1)
				player:setStorageValue(Storage.KillingInTheNameOf.MissionTiquandasRevenge, 1)
			end

			if ((player:getLevel() > 100) and
				(player:getStorageValue(Storage.KillingInTheNameOf.MissionDemodras) == 1) and
				(player:getStorageValue(Storage.KillingInTheNameOf.DemodrasTeleport) ~= 0)) then
				npcHandler:say("You have already started the special task. Find Demodras and kill it.", cid)
			else
				if ((player:getStorageValue(Storage.KillingInTheNameOf.MissionTiquandasRevenge) == 1) and
					(player:getStorageValue(Storage.KillingInTheNameOf.TiquandasRevengeTeleport) == 0)) then
					npcHandler:say("This task is a very dangerous one. I want you to look for Demodras' hideout. "..
								"It might be somewhere under the Plains of Havoc. Good luck, old chap.", cid)
					player:setStorageValue(Storage.KillingInTheNameOf.DemodrasTeleport, 1)
					player:setStorageValue(Storage.KillingInTheNameOf.MissionDemodras, 1)

				end
			end

			if (player:getStorageValue(Storage.KillingInTheNameOf.MissionDemodras) == 1 and
				player:getStorageValue(Storage.KillingInTheNameOf.DemodrasTeleport) == 0 and
				player:getStorageValue(Storage.KillingInTheNameOf.MissionTiquandasRevenge) == 1 and
				player:getStorageValue(Storage.KillingInTheNameOf.TiquandasRevengeTeleport) == 0) then
				npcHandler:say("You have already finished all special tasks.", cid)
			end
			npcHandler.topic[cid] = 0
		end
	end
end

npcHandler:setMessage(MESSAGE_FAREWELL, "Happy hunting, old chap!")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
