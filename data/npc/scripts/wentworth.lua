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
	{text = "Waste not, want not!"},
	{text = "Don't burden yourself with too much cash - store it here!"},
	{text = "Don't take the money and run - deposit it and walk instead!"}
}

npcHandler:addModule(VoiceModule:new(voices))

local count = {}
local function greetCallback(cid)
	count[cid] = nil
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	--Help
	if msgcontains(msg, "bank account") then
		npcHandler:say(
			{
				"Every Adventurer has one. \z
					The big advantage is that you can access your money in every branch of the World Bank! ...",
				"Would you like to know more about the {basic} functions of your bank account, the {advanced} functions, \z
					or are you already bored, perhaps?"
			},
		cid, false, true, 10)
		npcHandler.topic[cid] = 0
		return true
	--Balance
	elseif msgcontains(msg, "balance") then
		npcHandler.topic[cid] = 0
		if player:getBankBalance() >= 100000000 then
			npcHandler:say("I think you must be one of the richest inhabitants in the world! \z
				Your account balance is " .. player:getBankBalance() .. " gold.", cid)
			return true
		elseif player:getBankBalance() >= 10000000 then
			npcHandler:say("You have made ten millions and it still grows! Your account balance is \z
				" .. player:getBankBalance() .. " gold.", cid)
			return true
		elseif player:getBankBalance() >= 1000000 then
			npcHandler:say("Wow, you have reached the magic number of a million gp!!! \z
				Your account balance is " .. player:getBankBalance() .. " gold!", cid)
			return true
		elseif player:getBankBalance() >= 100000 then
			npcHandler:say("You certainly have made a pretty penny. Your account balance is \z
				" .. player:getBankBalance() .. " gold.", cid)
			return true
		else
			npcHandler:say("Your account balance is " .. player:getBankBalance() .. " gold.", cid)
			return true
		end
	--Deposit
	elseif msgcontains(msg, "deposit") then
		count[cid] = player:getMoney()
		if count[cid] < 1 then
			npcHandler:say("You do not have enough gold.", cid)
			npcHandler.topic[cid] = 0
			return false
		elseif not isValidMoney(count[cid]) then
			npcHandler:say("Sorry, but you can't deposit that much.", cid)
			npcHandler.topic[cid] = 0
			return false
		end
		if msgcontains(msg, "all") then
			count[cid] = player:getMoney()
			npcHandler:say("Would you really like to deposit " .. count[cid] .. " gold?", cid)
			npcHandler.topic[cid] = 2
			return true
		else
			if string.match(msg,"%d+") then
				count[cid] = getMoneyCount(msg)
				if count[cid] < 1 then
					npcHandler:say("You do not have enough gold.", cid)
					npcHandler.topic[cid] = 0
					return false
				end
				npcHandler:say("Would you really like to deposit " .. count[cid] .. " gold?", cid)
				npcHandler.topic[cid] = 2
				return true
			else
				npcHandler:say("Please tell me how much gold it is you would like to deposit.", cid)
				npcHandler.topic[cid] = 1
				return true
			end
		end
	elseif npcHandler.topic[cid] == 1 then
		count[cid] = getMoneyCount(msg)
		if isValidMoney(count[cid]) then
			npcHandler:say("Would you really like to deposit " .. count[cid] .. " gold?", cid)
			npcHandler.topic[cid] = 2
			return true
		else
			npcHandler:say("You do not have enough gold.", cid)
			npcHandler.topic[cid] = 0
			return true
		end
	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, "yes") then
			if player:getLevel() == 8 then
				if count[cid] > 1000 or player:getBankBalance() >= 1000 then
					npcHandler:say("Sorry, but you can't deposit that much.", cid)
					npcHandler.topic[cid] = 0
					return false
				end
			elseif player:getLevel() > 9 then
				if count[cid] > 2000 or player:getBankBalance() >= 2000 then
					npcHandler:say("Sorry, but you can't deposit that much.", cid)
					npcHandler.topic[cid] = 0
					return false
				end
			end
			if player:depositMoney(count[cid]) then
				npcHandler:say("Alright, we have added the amount of " .. count[cid] .. " gold to your {balance}. \z
				You can {withdraw} your money anytime you want to.", cid)
			else
				npcHandler:say("You do not have enough gold.", cid)
			end
		elseif msgcontains(msg, "no") then
			npcHandler:say("As you wish. Is there something else I can do for you?", cid)
		end
		npcHandler.topic[cid] = 0
		return true
	--Withdraw
	elseif msgcontains(msg, "withdraw") then
		if string.match(msg,"%d+") then
			count[cid] = getMoneyCount(msg)
			if isValidMoney(count[cid]) then
				npcHandler:say("Are you sure you wish to withdraw " .. count[cid] .. " gold from your bank account?", cid)
				npcHandler.topic[cid] = 7
			else
				npcHandler:say("There is not enough gold on your account.", cid)
				npcHandler.topic[cid] = 0
			end
			return true
		else
			npcHandler:say("Please tell me how much gold you would like to withdraw.", cid)
			npcHandler.topic[cid] = 6
			return true
		end
	elseif npcHandler.topic[cid] == 6 then
		count[cid] = getMoneyCount(msg)
		if isValidMoney(count[cid]) then
			npcHandler:say("Are you sure you wish to withdraw " .. count[cid] .. " gold from your bank account?", cid)
			npcHandler.topic[cid] = 7
		else
			npcHandler:say("There is not enough gold on your account.", cid)
			npcHandler.topic[cid] = 0
		end
		return true
	elseif npcHandler.topic[cid] == 7 then
		if msgcontains(msg, "yes") then
			if player:getFreeCapacity() >= getMoneyWeight(count[cid]) then
				if not player:withdrawMoney(count[cid]) then
					npcHandler:say("There is not enough gold on your account.", cid)
				else
					npcHandler:say("Here you are, " .. count[cid] .. " gold. \z
						Please let me know if there is something else I can do for you.", cid)
				end
			else
				npcHandler:say("Whoah, hold on, you have no room in your inventory to carry all those coins. \z
					I don't want you to drop it on the floor, maybe come back with a cart!", cid)
			end
			npcHandler.topic[cid] = 0
		elseif msgcontains(msg, "no") then
			npcHandler:say("The customer is king! Come back anytime you want to if you wish to {withdraw} your money.", cid)
			npcHandler.topic[cid] = 0
		end
		return true
	--Money exchange
	elseif msgcontains(msg, "change gold") then
		npcHandler:say("How many platinum coins would you like to get?", cid)
		npcHandler.topic[cid] = 14
	elseif npcHandler.topic[cid] == 14 then
		if getMoneyCount(msg) < 1 then
			npcHandler:say("Sorry, you do not have enough gold coins.", cid)
			npcHandler.topic[cid] = 0
		else
			count[cid] = getMoneyCount(msg)
			npcHandler:say("So you would like me to change " .. count[cid] * 100 .. " of your gold \z
				coins into " .. count[cid] .. " platinum coins?", cid)
			npcHandler.topic[cid] = 15
		end
	elseif npcHandler.topic[cid] == 15 then
		if msgcontains(msg, "yes") then
			if player:removeItem(2148, count[cid] * 100) then
				player:addItem(2152, count[cid])
				npcHandler:say("Here you are.", cid)
			else
				npcHandler:say("Sorry, you do not have enough gold coins.", cid)
			end
		else
			npcHandler:say("Well, can I help you with something else?", cid)
		end
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, "change platinum") then
		npcHandler:say("Would you like to change your platinum coins into gold or crystal?", cid)
		npcHandler.topic[cid] = 16
	elseif npcHandler.topic[cid] == 16 then
		if msgcontains(msg, "gold") then
			npcHandler:say("How many platinum coins would you like to change into gold?", cid)
			npcHandler.topic[cid] = 17
		elseif msgcontains(msg, "crystal") then
			npcHandler:say("How many crystal coins would you like to get?", cid)
			npcHandler.topic[cid] = 19
		else
			npcHandler:say("Well, can I help you with something else?", cid)
			npcHandler.topic[cid] = 0
		end
	elseif npcHandler.topic[cid] == 17 then
		if getMoneyCount(msg) < 1 then
			npcHandler:say("Sorry, you do not have enough platinum coins.", cid)
			npcHandler.topic[cid] = 0
		else
			count[cid] = getMoneyCount(msg)
			npcHandler:say("So you would like me to change " .. count[cid] .. " of your platinum \z
				coins into " .. count[cid] * 100 .. " gold coins for you?", cid)
			npcHandler.topic[cid] = 18
		end
	elseif npcHandler.topic[cid] == 18 then
		if msgcontains(msg, "yes") then
			if player:removeItem(2152, count[cid]) then
				player:addItem(2148, count[cid] * 100)
				npcHandler:say("Here you are.", cid)
			else
				npcHandler:say("Sorry, you do not have enough platinum coins.", cid)
			end
		else
			npcHandler:say("Well, can I help you with something else?", cid)
		end
		npcHandler.topic[cid] = 0
	elseif npcHandler.topic[cid] == 19 then
		if getMoneyCount(msg) < 1 then
			npcHandler:say("Sorry, you do not have enough platinum coins.", cid)
			npcHandler.topic[cid] = 0
		else
			count[cid] = getMoneyCount(msg)
			npcHandler:say("So you would like me to change " .. count[cid] * 100 .. " of your platinum coins \z
				into " .. count[cid] .. " crystal coins for you?", cid)
			npcHandler.topic[cid] = 20
		end
	elseif npcHandler.topic[cid] == 20 then
		if msgcontains(msg, "yes") then
			if player:removeItem(2152, count[cid] * 100) then
				player:addItem(2160, count[cid])
				npcHandler:say("Here you are.", cid)
			else
				npcHandler:say("Sorry, you do not have enough platinum coins.", cid)
			end
		else
			npcHandler:say("Well, can I help you with something else?", cid)
		end
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, "change crystal") then
		npcHandler:say("How many crystal coins would you like to change into platinum?", cid)
		npcHandler.topic[cid] = 21
	elseif npcHandler.topic[cid] == 21 then
		if getMoneyCount(msg) < 1 then
			npcHandler:say("Sorry, you do not have enough crystal coins.", cid)
			npcHandler.topic[cid] = 0
		else
			count[cid] = getMoneyCount(msg)
			npcHandler:say("So you would like me to change " .. count[cid] .. " of your crystal coins \z
				into " .. count[cid] * 100 .. " platinum coins for you?", cid)
			npcHandler.topic[cid] = 22
		end
	elseif npcHandler.topic[cid] == 22 then
		if msgcontains(msg, "yes") then
			if player:removeItem(2160, count[cid])  then
				player:addItem(2152, count[cid] * 100)
				npcHandler:say("Here you are.", cid)
			else
				npcHandler:say("Sorry, you do not have enough crystal coins.", cid)
			end
		else
			npcHandler:say("Well, can I help you with something else?", cid)
		end
		npcHandler.topic[cid] = 0
	end
	return true
end

keywordHandler:addKeyword({"money"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "We can {change} money for you. You can also access your {bank account}."
	}
)
keywordHandler:addKeyword({"change"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "There are three different coin types in Tibia: 100 gold coins equal 1 platinum coin, \z
			100 platinum coins equal 1 crystal coin. \z
			So if you'd like to change 100 gold into 1 platinum, simply say '{change gold}' and then '1 platinum'."
	}
)
keywordHandler:addKeyword({"bank"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "We can {change} money for you. You can also access your {bank account}."
	}
)
keywordHandler:addKeyword({"advanced"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Your bank account will be used automatically when you want to {rent} a house or place an offer \z
			on an item on the {market}. Let me know if you want to know about how either one works."
	}
)
keywordHandler:addKeyword({"help"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You can check the {balance} of your bank account, {deposit} money or {withdraw} it. \z
			You can also {transfer} money to other characters, provided that they have a vocation."
	}
)
keywordHandler:addKeyword({"functions"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You can check the {balance} of your bank account, {deposit} money or {withdraw} it. \z
			You can also {transfer} money to other characters, provided that they have a vocation."
	}
)
keywordHandler:addKeyword({"basic"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You can check the {balance} of your bank account, {deposit} money or {withdraw} it. \z
			You can also {transfer} money to other characters, provided that they have a vocation."
	}
)
keywordHandler:addKeyword({"job"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I work in this bank. I can change money for you and help you with your bank account."
	}
)
keywordHandler:addKeyword({"transfer"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm afraid this service is not available to you until you reach the World mainland."
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Yes? What may I do for you, |PLAYERNAME|? Bank business, perhaps?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Have a nice day.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Have a nice day.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
