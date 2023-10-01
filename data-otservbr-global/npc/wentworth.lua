local internalNpcName = "Wentworth"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 151,
	lookHead = 97,
	lookBody = 19,
	lookLegs = 124,
	lookFeet = 115,
	lookAddons = 1
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = "Waste not, want not!"},
	{text = "Don't burden yourself with too much cash - store it here!"},
	{text = "Don't take the money and run - deposit it and walk instead!"}
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local count = {}

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	count[playerId] = nil
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	--Help
	if MsgContains(message, "bank account") then
		npcHandler:say(
			{
				"Every Adventurer has one. \z
					The big advantage is that you can access your money in every branch of the World Bank! ...",
				"Would you like to know more about the {basic} functions of your bank account, the {advanced} functions, \z
					or are you already bored, perhaps?"
			},
		npc, creature, 10)
		npcHandler:setTopic(playerId, 0)
		return true
	--Balance
	elseif MsgContains(message, "balance") then
		npcHandler:setTopic(playerId, 0)
		if player:getBankBalance() >= 100000000 then
			npcHandler:say("I think you must be one of the richest inhabitants in the world! \z
				Your account balance is " .. player:getBankBalance() .. " gold.", npc, creature)
			return true
		elseif player:getBankBalance() >= 10000000 then
			npcHandler:say("You have made ten millions and it still grows! Your account balance is \z
				" .. player:getBankBalance() .. " gold.", npc, creature)
			return true
		elseif player:getBankBalance() >= 1000000 then
			npcHandler:say("Wow, you have reached the magic number of a million gp!!! \z
				Your account balance is " .. player:getBankBalance() .. " gold!", npc, creature)
			return true
		elseif player:getBankBalance() >= 100000 then
			npcHandler:say("You certainly have made a pretty penny. Your account balance is \z
				" .. player:getBankBalance() .. " gold.", npc, creature)
			return true
		else
			npcHandler:say("Your account balance is " .. player:getBankBalance() .. " gold.", npc, creature)
			return true
		end
	--Deposit
	elseif MsgContains(message, "deposit") then
		count[playerId] = player:getMoney()
		if count[playerId] < 1 then
			npcHandler:say("You do not have enough gold.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return false
		elseif not isValidMoney(count[playerId]) then
			npcHandler:say("Sorry, but you can't deposit that much.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return false
		end
		if MsgContains(message, "all") then
			count[playerId] = player:getMoney()
			npcHandler:say("Would you really like to deposit " .. count[playerId] .. " gold?", npc, creature)
			npcHandler:setTopic(playerId, 2)
			return true
		else
			if string.match(message,"%d+") then
				count[playerId] = getMoneyCount(message)
				if count[playerId] < 1 then
					npcHandler:say("You do not have enough gold.", npc, creature)
					npcHandler:setTopic(playerId, 0)
					return false
				end
				npcHandler:say("Would you really like to deposit " .. count[playerId] .. " gold?", npc, creature)
				npcHandler:setTopic(playerId, 2)
				return true
			else
				npcHandler:say("Please tell me how much gold it is you would like to deposit.", npc, creature)
				npcHandler:setTopic(playerId, 1)
				return true
			end
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		count[playerId] = getMoneyCount(message)
		if isValidMoney(count[playerId]) then
			npcHandler:say("Would you really like to deposit " .. count[playerId] .. " gold?", npc, creature)
			npcHandler:setTopic(playerId, 2)
			return true
		else
			npcHandler:say("You do not have enough gold.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return true
		end
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "yes") then
			if player:getLevel() == 8 then
				if count[playerId] > 1000 or player:getBankBalance() >= 1000 then
					npcHandler:say("Sorry, but you can't deposit that much.", npc, creature)
					npcHandler:setTopic(playerId, 0)
					return false
				end
			elseif player:getLevel() > 9 then
				if count[playerId] > 2000 or player:getBankBalance() >= 2000 then
					npcHandler:say("Sorry, but you can't deposit that much.", npc, creature)
					npcHandler:setTopic(playerId, 0)
					return false
				end
			end
			if player:depositMoney(count[playerId]) then
				npcHandler:say("Alright, we have added the amount of " .. count[playerId] .. " gold to your {balance}. \z
				You can {withdraw} your money anytime you want to.", npc, creature)
			else
				npcHandler:say("You do not have enough gold.", npc, creature)
			end
		elseif MsgContains(message, "no") then
			npcHandler:say("As you wish. Is there something else I can do for you?", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
		return true
	--Withdraw
	elseif MsgContains(message, "withdraw") then
		if string.match(message,"%d+") then
			count[playerId] = getMoneyCount(message)
			if isValidMoney(count[playerId]) then
				npcHandler:say("Are you sure you wish to withdraw " .. count[playerId] .. " gold from your bank account?", npc, creature)
				npcHandler:setTopic(playerId, 7)
			else
				npcHandler:say("There is not enough gold on your account.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
			return true
		else
			npcHandler:say("Please tell me how much gold you would like to withdraw.", npc, creature)
			npcHandler:setTopic(playerId, 6)
			return true
		end
	elseif npcHandler:getTopic(playerId) == 6 then
		count[playerId] = getMoneyCount(message)
		if isValidMoney(count[playerId]) then
			npcHandler:say("Are you sure you wish to withdraw " .. count[playerId] .. " gold from your bank account?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		else
			npcHandler:say("There is not enough gold on your account.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
		return true
	elseif npcHandler:getTopic(playerId) == 7 then
		if MsgContains(message, "yes") then
			if player:getFreeCapacity() >= getMoneyWeight(count[playerId]) then
				if not player:withdrawMoney(count[playerId]) then
					npcHandler:say("There is not enough gold on your account.", npc, creature)
				else
					npcHandler:say("Here you are, " .. count[playerId] .. " gold. \z
						Please let me know if there is something else I can do for you.", npc, creature)
				end
			else
				npcHandler:say("Whoah, hold on, you have no room in your inventory to carry all those coins. \z
					I don't want you to drop it on the floor, maybe come back with a cart!", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("The customer is king! Come back anytime you want to if you wish to {withdraw} your money.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
		return true
	--Money exchange
	elseif MsgContains(message, "change gold") then
		npcHandler:say("How many platinum coins would you like to get?", npc, creature)
		npcHandler:setTopic(playerId, 14)
	elseif npcHandler:getTopic(playerId) == 14 then
		if getMoneyCount(message) < 1 then
			npcHandler:say("Sorry, you do not have enough gold coins.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			count[playerId] = getMoneyCount(message)
			npcHandler:say("So you would like me to change " .. count[playerId] * 100 .. " of your gold \z
				coins into " .. count[playerId] .. " platinum coins?", npc, creature)
			npcHandler:setTopic(playerId, 15)
		end
	elseif npcHandler:getTopic(playerId) == 15 then
		if MsgContains(message, "yes") then
			if player:removeItem(3031, count[playerId] * 100) then
				player:addItem(3035, count[playerId])
				npcHandler:say("Here you are.", npc, creature)
			else
				npcHandler:say("Sorry, you do not have enough gold coins.", npc, creature)
			end
		else
			npcHandler:say("Well, can I help you with something else?", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "change platinum") then
		npcHandler:say("Would you like to change your platinum coins into gold or crystal?", npc, creature)
		npcHandler:setTopic(playerId, 16)
	elseif npcHandler:getTopic(playerId) == 16 then
		if MsgContains(message, "gold") then
			npcHandler:say("How many platinum coins would you like to change into gold?", npc, creature)
			npcHandler:setTopic(playerId, 17)
		elseif MsgContains(message, "crystal") then
			npcHandler:say("How many crystal coins would you like to get?", npc, creature)
			npcHandler:setTopic(playerId, 19)
		else
			npcHandler:say("Well, can I help you with something else?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 17 then
		if getMoneyCount(message) < 1 then
			npcHandler:say("Sorry, you do not have enough platinum coins.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			count[playerId] = getMoneyCount(message)
			npcHandler:say("So you would like me to change " .. count[playerId] .. " of your platinum \z
				coins into " .. count[playerId] * 100 .. " gold coins for you?", npc, creature)
			npcHandler:setTopic(playerId, 18)
		end
	elseif npcHandler:getTopic(playerId) == 18 then
		if MsgContains(message, "yes") then
			if player:removeItem(3035, count[playerId]) then
				player:addItem(3031, count[playerId] * 100)
				npcHandler:say("Here you are.", npc, creature)
			else
				npcHandler:say("Sorry, you do not have enough platinum coins.", npc, creature)
			end
		else
			npcHandler:say("Well, can I help you with something else?", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif npcHandler:getTopic(playerId) == 19 then
		if getMoneyCount(message) < 1 then
			npcHandler:say("Sorry, you do not have enough platinum coins.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			count[playerId] = getMoneyCount(message)
			npcHandler:say("So you would like me to change " .. count[playerId] * 100 .. " of your platinum coins \z
				into " .. count[playerId] .. " crystal coins for you?", npc, creature)
			npcHandler:setTopic(playerId, 20)
		end
	elseif npcHandler:getTopic(playerId) == 20 then
		if MsgContains(message, "yes") then
			if player:removeItem(3035, count[playerId] * 100) then
				player:addItem(3043, count[playerId])
				npcHandler:say("Here you are.", npc, creature)
			else
				npcHandler:say("Sorry, you do not have enough platinum coins.", npc, creature)
			end
		else
			npcHandler:say("Well, can I help you with something else?", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "change crystal") then
		npcHandler:say("How many crystal coins would you like to change into platinum?", npc, creature)
		npcHandler:setTopic(playerId, 21)
	elseif npcHandler:getTopic(playerId) == 21 then
		if getMoneyCount(message) < 1 then
			npcHandler:say("Sorry, you do not have enough crystal coins.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			count[playerId] = getMoneyCount(message)
			npcHandler:say("So you would like me to change " .. count[playerId] .. " of your crystal coins \z
				into " .. count[playerId] * 100 .. " platinum coins for you?", npc, creature)
			npcHandler:setTopic(playerId, 22)
		end
	elseif npcHandler:getTopic(playerId) == 22 then
		if MsgContains(message, "yes") then
			if player:removeItem(3043, count[playerId])  then
				player:addItem(3035, count[playerId] * 100)
				npcHandler:say("Here you are.", npc, creature)
			else
				npcHandler:say("Sorry, you do not have enough crystal coins.", npc, creature)
			end
		else
			npcHandler:say("Well, can I help you with something else?", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
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

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
