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

local voices = {
	{text = "Deposit your money here in the safety of the Tibian Bank!"},
	{text = "Any questions about the functions of your bank account? Feel free to ask me for help!"}
}

local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.TheRookieGuard.Mission08) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome |PLAYERNAME|! Special newcomer offer, today only! {Deposit} some money - or {deposit ALL} of your money! - and get 50 gold for free!")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Welcome |PLAYERNAME|! Here, you can {deposit} or {withdraw} your money from your bank account and {change} gold. I can also explain the {functions} of your bank account to you.")
	end
	return true
end

-- Bank functions

-- Balance
keywordHandler:addKeyword({"balance"},
function(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if player:getBankBalance() >= 100000000 then
		npcHandler:say("I think you must be one of the richest inhabitants in the world! Your account balance is " .. player:getBankBalance() .. " gold.", cid)
	elseif player:getBankBalance() >= 10000000 then
		npcHandler:say("You have made ten millions and it still grows! Your account balance is " .. player:getBankBalance() .. " gold.", cid)
	elseif player:getBankBalance() >= 1000000 then
		npcHandler:say("Wow, you have reached the magic number of a million gp!!! Your account balance is " .. player:getBankBalance() .. " gold!", cid)
	elseif player:getBankBalance() >= 100000 then
		npcHandler:say("You certainly have made a pretty penny. Your account balance is " .. player:getBankBalance() .. " gold.", cid)
	else
		npcHandler:say("Your account balance is " .. player:getBankBalance() .. " gold.", cid)
	end
	return true
end,
{npcHandler = npcHandler}
)

-- Deposit
local function depositHandler(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if string.find(message, "%d+") then
		npcHandler.topic[cid] = tonumber(string.match(message, "%d+"))
	else
		npcHandler.topic[cid] = player:getMoney()
	end
	if npcHandler.topic[cid] <= 0 then
		npcHandler:say("You are joking, aren't you?", cid)
		return false
	elseif player:getMoney() < npcHandler.topic[cid] then
		npcHandler:say("You don't have enough gold.", cid)
		return false
	elseif player:getBankBalance() + npcHandler.topic[cid] <= 1000 then
		npcHandler:say("Want to deposit " .. npcHandler.topic[cid] .. " gold?", cid)
		return true
	else
		if player:getBankBalance() < 1000 then
			npcHandler.topic[cid] = 1000 - player:getBankBalance()
			npcHandler:say("Uh oh! I fear all that gold would exceed the limit of your Rookgaard bank account which are 1000 gold pieces. I can deposit " .. npcHandler.topic[cid] .. " gold though. Would you like that?", cid)
			return true
		else
			npcHandler:say("Uh oh! I fear all that gold would exceed the limit of your Rookgaard bank account which are 1000 gold pieces.", cid)
			return false
		end
	end
end

local depositAll = keywordHandler:addKeyword({"deposit all"}, depositHandler,  {npcHandler = npcHandler})
local deposit = keywordHandler:addKeyword({"deposit"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Please tell me how much gold you would like to deposit."
})

local depositAmount = deposit:addChildKeyword({"%d+"}, depositHandler, {npcHandler = npcHandler})

local depositConfirm = KeywordNode:new({"yes"},
function(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	local depositBonus = player:getStorageValue(Storage.TheRookieGuard.Mission08) == 1 and 50 or false
	if depositBonus and player:depositMoney(npcHandler.topic[cid]) then
		player:setStorageValue(Storage.TheRookieGuard.Mission08, 2)
		player:addMoney(depositBonus)
		player:depositMoney(depositBonus)
		npcHandler:say("Alright, we have added the amount of " .. (npcHandler.topic[cid] + depositBonus) .. " gold to your {balance} - that is the money you deposited plus a bonus of " .. depositBonus .. " gold. Thank you! You can {withdraw} your money anytime.", cid)
	elseif player:depositMoney(npcHandler.topic[cid]) then
		npcHandler:say("Alright, we have added the amount of " .. npcHandler.topic[cid] .. " gold to your balance. You can withdraw your money anytime.", cid)
	else
		npcHandler:say("You don't have enough gold.", cid)
	end
	npcHandler:resetNpc(cid)
	return true
end,
{npcHandler = npcHandler}
)

local depositDecline = KeywordNode:new({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "As you wish. Is there something else I can do for you?",
	reset = true
})

depositAmount:addChildKeywordNode(depositConfirm)
depositAll:addChildKeywordNode(depositConfirm)

depositAmount:addChildKeywordNode(depositDecline)
depositAll:addChildKeywordNode(depositDecline)

-- Withdraw
local withdraw = keywordHandler:addKeyword({"withdraw"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Please tell me how much gold you would like to withdraw."
})

local withdrawAmount = withdraw:addChildKeyword({"%d+"},
function(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	npcHandler.topic[cid] = tonumber(string.match(message, "%d+"))
	if npcHandler.topic[cid] <= 0 then
		npcHandler:say("Sure, you want nothing - you get nothing!", cid)
		return false
	elseif player:getBankBalance() >= npcHandler.topic[cid] then
		npcHandler:say("Are you sure you wish to withdraw " .. npcHandler.topic[cid] .. " gold from your bank account?", cid)
		return true
	else
		npcHandler:say("There is not enough gold on your account.", cid)
		return false
	end
end,
{npcHandler = npcHandler}
)

withdrawAmount:addChildKeyword({"yes"},
function(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if player:getFreeCapacity() >= getMoneyWeight(npcHandler.topic[cid]) then
		if player:withdrawMoney(npcHandler.topic[cid]) then
			npcHandler:say("Here you are, " .. npcHandler.topic[cid] .. " gold. Please let me know if there is something else I can do for you.", cid)
		else
			npcHandler:say("There is not enough gold on your account.", cid)
		end
	else
		npcHandler:say("Whoah, hold on, this is too heavy for you. I don't want you to drop it on the floor, maybe come back with a cart!", cid)
	end
	npcHandler:resetNpc(cid)
	return true
end,
{npcHandler = npcHandler}
)

withdrawAmount:addChildKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "The customer is king! Come back whenever you want if you wish to withdraw your money.",
	reset = true
})

-- Change gold
local changeGold = keywordHandler:addKeyword({"change gold"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "How many platinum coins would you like to get?"
})

local changeDecline = KeywordNode:new({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Well, can I help you with something else?",
	reset = true
})

local changeGoldAmount = changeGold:addChildKeyword({"%d+"},
function(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	npcHandler.topic[cid] = tonumber(string.match(message, "%d+"))
	if npcHandler.topic[cid] == 0 then
		npcHandler:say("Hmm, can I help you with something else?", cid)
		return false
	else
		npcHandler:say("So you want me to change " .. (npcHandler.topic[cid] * 100) .. " of your gold coins into " .. npcHandler.topic[cid] .. " platinum coins?", cid)
		return true
	end
end,
{npcHandler = npcHandler}
)

changeGoldAmount:addChildKeyword({"yes"},
function(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if player:removeItem(2148, npcHandler.topic[cid] * 100) then
		player:addItem(2152, npcHandler.topic[cid])
		npcHandler:say("Here you are.", cid)
	else
		npcHandler:say("Sorry, you don't have enough gold coins.", cid)
	end
	npcHandler:resetNpc(cid)
	return true
end,
{npcHandler = npcHandler}
)

changeGoldAmount:addChildKeywordNode(changeDecline)

-- Change platinum
local changePlatinum = keywordHandler:addKeyword({"change platinum"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Would you like to change your platinum coins into gold or crystal coins?"
})

local changePlatinumToGold = changePlatinum:addChildKeyword({"gold"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "How many platinum coins would you like to change into gold coins?"
})

local changePlatinumToGoldAmount = changePlatinumToGold:addChildKeyword({"%d+"},
function(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	npcHandler.topic[cid] = tonumber(string.match(message, "%d+"))
	if npcHandler.topic[cid] <= 0 then
		npcHandler:say("Well, can I help you with something else?", cid)
		return false
	else
		npcHandler:say("So you want me to change " .. npcHandler.topic[cid] .. " of your platinum coins into " .. (npcHandler.topic[cid] * 100) .. " gold coins for you?", cid)
		return true
	end
end,
{npcHandler = npcHandler}
)

changePlatinumToGoldAmount:addChildKeyword({"yes"},
function(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if player:getItemCount(2152) >= npcHandler.topic[cid] then
		if player:getFreeCapacity() >= (ItemType(2148):getWeight() * (npcHandler.topic[cid] * 100)) then
			player:removeItem(2152, npcHandler.topic[cid])
			player:addItem(2148, npcHandler.topic[cid] * 100)
			npcHandler:say("Here you are.", cid)
		else
			npcHandler:say("Whoah, hold on, this is too heavy for you. I don't want you to drop it on the floor, maybe come back with a cart!", cid)
		end
	else
		npcHandler:say("Sorry, you don't have enough platinum coins.", cid)
	end
	npcHandler:resetNpc(cid)
	return true
end,
{npcHandler = npcHandler}
)

changePlatinumToGoldAmount:addChildKeywordNode(changeDecline)

local changePlatinumToCrystal = changePlatinum:addChildKeyword({"crystal"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "How many crystal coins would you like to get?"
})

local changePlatinumToCrystalAmount = changePlatinumToCrystal:addChildKeyword({"%d+"},
function(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	npcHandler.topic[cid] = tonumber(string.match(message, "%d+"))
	if npcHandler.topic[cid] <= 0 then
		npcHandler:say("Well, can I help you with something else?", cid)
		return false
	else
		npcHandler:say("So you want me to change " .. (npcHandler.topic[cid] * 100) .. " of your platinum coins into " .. npcHandler.topic[cid] .. " crystal coins for you?", cid)
		return true
	end
end,
{npcHandler = npcHandler}
)

changePlatinumToCrystalAmount:addChildKeyword({"yes"},
function(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if player:removeItem(2152, npcHandler.topic[cid] * 100) then
		player:addItem(2160, npcHandler.topic[cid])
		npcHandler:say("Here you are.", cid)
	else
		npcHandler:say("Sorry, you don't have enough platinum coins.", cid)
	end
	npcHandler:resetNpc(cid)
	return true
end,
{npcHandler = npcHandler}
)

changePlatinumToCrystalAmount:addChildKeywordNode(changeDecline)

-- Change crystal
local changeCrystal = keywordHandler:addKeyword({"change crystal"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "How many crystal coins would you like to change into platinum coins?"
})

local changeCrystalAmount = changeCrystal:addChildKeyword({"%d+"},
function(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	npcHandler.topic[cid] = tonumber(string.match(message, "%d+"))
	if npcHandler.topic[cid] == 0 then
		npcHandler:say("Hmm, can I help you with something else?", cid)
		return false
	else
		npcHandler:say("So you want me to change " .. npcHandler.topic[cid] .. " of your crystal coins into " .. (npcHandler.topic[cid] * 100) .. " platinum coins?", cid)
		return true
	end
end,
{npcHandler = npcHandler}
)

changeCrystalAmount:addChildKeyword({"yes"},
function(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	
	if player:getItemCount(2160) >= npcHandler.topic[cid] then
		if player:getFreeCapacity() >= (ItemType(2152):getWeight() * (npcHandler.topic[cid] * 100)) then
			player:removeItem(2160, npcHandler.topic[cid])
			player:addItem(2152, npcHandler.topic[cid] * 100)
			npcHandler:say("Here you are.", cid)
		else
			npcHandler:say("Whoah, hold on, this is too heavy for you. I don't want you to drop it on the floor, maybe come back with a cart!", cid)
		end
	else
		npcHandler:say("Sorry, you don't have enough crystal coins.", cid)
	end
	npcHandler:resetNpc(cid)
	return true
end,
{npcHandler = npcHandler}
)

changeCrystalAmount:addChildKeywordNode(changeDecline)

keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "I'm Paulie."})
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "I'm still a bank clerk-in-training. They say I can work on the {mainland} of Tibia once I have proven myself!"})
keywordHandler:addKeyword({"mainland"}, StdModule.say, {npcHandler = npcHandler, text = "I'm looking forward to work on the mainland. The great Tibian cities are so much more interesting than this little village of {Rookgaard}."})
keywordHandler:addKeyword({"rookgaard"}, StdModule.say, {npcHandler = npcHandler, text = "What a godforsaken place! Well, at least there are no criminals robbing the bank which would be - me. <gulp>"})
keywordHandler:addKeyword({"trade"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, I don't trade. Ask the shop owners for a trade instead. I can only help you with your bank account."})
keywordHandler:addAliasKeyword({"offer"})
keywordHandler:addAliasKeyword({"buy"})
keywordHandler:addAliasKeyword({"sell"})
keywordHandler:addKeyword({"help"}, StdModule.say, {npcHandler = npcHandler, text = "Every Tibian has a bank account. You can {deposit} your gold in one bank and {withdraw} it from the same or any other Tibian bank. Ask me for your {balance} to learn how much money you've already saved. There are also {advanced} functions."})
keywordHandler:addKeyword({"quest"}, StdModule.say, {npcHandler = npcHandler, text = "Well, the greatest quest in life must be to amass tons of gold coins! Good luck with that!"})
keywordHandler:addKeyword({"king"}, StdModule.say, {npcHandler = npcHandler, text = "HAIL TO THE KING!"})

keywordHandler:addKeyword({"bank account"}, StdModule.say, {npcHandler = npcHandler, text = "You can {deposit} and {withdraw} money from your {bank account} here. I can also {change} money for you."})
keywordHandler:addAliasKeyword({"money"})
keywordHandler:addKeyword({"change"}, StdModule.say, {npcHandler = npcHandler, text = "There are three different coin types in Tibia: 100 gold coins equal 1 platinum coin, 100 platinum coins equal 1 crystal coin. For example, if you like to change 100 gold coins into 1 platinum coin, simply say '{change gold}' and then '1 platinum'."})
keywordHandler:addKeyword({"advanced"}, StdModule.say, {npcHandler = npcHandler, text = {"Once you are on the Tibian mainland, you can access new functions of your bank account, such as transferring money to other players safely, accessing your guild account or taking part in house auctions. ...", "Just ask any of my colleagues on the Mainland and they'll be happy to tell you all about the advanced functions of your bank account."}})
keywordHandler:addKeyword({"transfer"}, StdModule.say, {npcHandler = npcHandler, text = "I'm afraid this service is not available to you until you reach mainland."})

npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, and remember: entrusting us with your gold is the safest way of storing it!")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(VoiceModule:new(voices))
npcHandler:addModule(FocusModule:new())
