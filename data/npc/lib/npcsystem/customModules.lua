-- Custom Modules, created to help us in this datapack
local travelDiscounts = {
	['postman'] = {price = 10, storage = Storage.Postman.Rank, value = 3},
	['new frontier'] = {price = 50, storage = Storage.TheNewFrontier.Mission03, value = 1}
}

function StdModule.travelDiscount(player, discounts)
	local discountPrice, discount = 0
	if type(discounts) == 'string' then
		discount = travelDiscounts[discounts]
		if discount and player:getStorageValue(discount.storage) >= discount.value then
			return discount.price
		end
	else
		for i = 1, #discounts do
			discount = travelDiscounts[discounts[i]]
			if discount and player:getStorageValue(discount.storage) >= discount.value then
				discountPrice = discountPrice + discount.price
			end
		end
	end

	return discountPrice
end

function StdModule.kick(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel called without any npcHandler instance.")
	end

	if not npcHandler:isFocused(cid) then
		return false
	end

	npcHandler:releaseFocus(cid)
	npcHandler:say(parameters.text or "Off with you!", cid)

	local destination = parameters.destination
	if type(destination) == 'table' then
		destination = destination[math.random(#destination)]
	end

	Player(cid):teleportTo(destination, true)

	npcHandler:resetNpc(cid)
	return true
end

local GreetModule = {}
function GreetModule.greet(cid, message, keywords, parameters)
	if not parameters.npcHandler:isInRange(cid) then
		return true
	end

	if parameters.npcHandler:isFocused(cid) then
		return true
	end

	local parseInfo = { [TAG_PLAYERNAME] = Player(cid):getName() }
	parameters.npcHandler:say(parameters.npcHandler:parseMessage(parameters.text, parseInfo), cid, true)
	parameters.npcHandler:addFocus(cid)
	return true
end

function GreetModule.farewell(cid, message, keywords, parameters)
	if not parameters.npcHandler:isFocused(cid) then
		return false
	end

	local parseInfo = { [TAG_PLAYERNAME] = Player(cid):getName() }
	parameters.npcHandler:say(parameters.npcHandler:parseMessage(parameters.text, parseInfo), cid, true)
	parameters.npcHandler:resetNpc(cid)
	parameters.npcHandler:releaseFocus(cid)
	return true
end

-- Adds a keyword which acts as a greeting word
function KeywordHandler:addGreetKeyword(keys, parameters, condition, action)
	local keys = keys
	keys.callback = FocusModule.messageMatcherDefault
	return self:addKeyword(keys, GreetModule.greet, parameters, condition, action)
end

-- Adds a keyword which acts as a farewell word
function KeywordHandler:addFarewellKeyword(keys, parameters, condition, action)
	local keys = keys
	keys.callback = FocusModule.messageMatcherDefault
	return self:addKeyword(keys, GreetModule.farewell, parameters, condition, action)
end

-- Adds a keyword which acts as a spell word
function KeywordHandler:addSpellKeyword(keys, parameters)
	local keys = keys
	keys.callback = FocusModule.messageMatcherDefault

	local npcHandler, spellName, price, vocationId = parameters.npcHandler, parameters.spellName, parameters.price, parameters.vocation
	local spellKeyword = self:addKeyword(keys, StdModule.say, {npcHandler = npcHandler, text = string.format("Do you want to learn the spell '%s' for %s?", spellName, price > 0 and price .. ' gold' or 'free')},
		function(player)
			-- This will register for all client id vocations
			local vocationClientId = player:getVocation():getClientId()
			if type(vocationId) == 'table' then
				return table.contains(vocationId, vocationClientId)
			else
				return vocationId == vocationClientId
			end
		end
	)

	spellKeyword:addChildKeyword({'yes'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = spellName, level = parameters.level, price = price})
	spellKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Maybe next time.', reset = true})
end

local hints = {
	[-1] = 'If you don\'t know the meaning of an icon on the right side, move the mouse cursor on it and wait a moment.',
	[0] = 'Send private messages to other players by right-clicking on the player or the player\'s name and select \'Message to ....\'. You can also open a \'private message channel\' and type in the name of the player.',
	[1] = 'Use the shortcuts \'SHIFT\' to look, \'CTRL\' for use and \'ALT\' for attack when clicking on an object or player.',
	[2] = 'If you already know where you want to go, click on the automap and your character will walk there automatically if the location is reachable and not too far away.',
	[3] = 'To open or close skills, battle or VIP list, click on the corresponding button to the right.',
	[4] = '\'Capacity\' restricts the amount of things you can carry with you. It raises with each level.',
	[5] = 'Always have a look on your health bar. If you see that you do not regenerate health points anymore, eat something.',
	[6] = 'Always eat as much food as possible. This way, you\'ll regenerate health points for a longer period of time.',
	[7] = 'After you have killed a monster, you have 10 seconds in which the corpse is not moveable and no one else but you can loot it.',
	[8] = 'Be careful when you approach three or more monsters because you only can block the attacks of two. In such a situation even a few rats can do severe damage or even kill you.',
	[9] = 'There are many ways to gather food. Many creatures drop food but you can also pick blueberries or bake your own bread. If you have a fishing rod and worms in your inventory, you can also try to catch a fish.',
	[10] = {'Baking bread is rather complex. First of all you need a scythe to harvest wheat. Then you use the wheat with a millstone to get flour. ...', 'This can be be used on water to get dough, which can be used on an oven to bake bread. Use milk instead of water to get cake dough.'},
	[11] = 'Dying hurts! Better run away than risk your life. You are going to lose experience and skill points when you die.',
	[12] = 'When you switch to \'Offensive Fighting\', you deal out more damage but you also get hurt more easily.',
	[13] = 'When you are on low health and need to run away from a monster, switch to \'Defensive Fighting\' and the monster will hit you less severely.',
	[14] = 'Many creatures try to run away from you. Select \'Chase Opponent\' to follow them.',
	[15] = 'The deeper you enter a dungeon, the more dangerous it will be. Approach every dungeon with utmost care or an unexpected creature might kill you. This will result in losing experience and skill points.',
	[16] = 'Due to the perspective, some objects in Tibia are not located at the spot they seem to appear (ladders, windows, lamps). Try clicking on the floor tile the object would lie on.',
	[17] = 'If you want to trade an item with another player, right-click on the item and select \'Trade with ...\', then click on the player with whom you want to trade.',
	[18] = 'Stairs, ladders and dungeon entrances are marked as yellow dots on the automap.',
	[19] = 'You can get food by killing animals or monsters. You can also pick blueberries or bake your own bread. If you are too lazy or own too much money, you can also buy food.',
	[20] = 'Quest containers can be recognised easily. They don\'t open up regularly but display a message \'You have found ....\'. They can only be opened once.',
	[21] = 'Better run away than risk to die. You\'ll lose experience and skill points each time you die.',
	[22] = 'You can form a party by right-clicking on a player and selecting \'Invite to Party\'. The party leader can also enable \'Shared Experience\' by right-clicking on him- or herself.',
	[23] = 'You can assign spells, the use of items, or random text to \'hotkeys\'. You find them under \'Options\'.',
	[24] = 'You can also follow other players. Just right-click on the player and select \'Follow\'.',
	[25] = 'You can found a party with your friends by right-clicking on a player and selecting \'Invite to Party\'. If you are invited to a party, right-click on yourself and select \'Join Party\'.',
	[26] = 'Only found parties with people you trust. You can attack people in your party without getting a skull. This is helpful for training your skills, but can be abused to kill people without having to fear negative consequences.',
	[27] = 'The leader of a party has the option to distribute gathered experience among all players in the party. If you are the leader, right-click on yourself and select \'Enable Shared Experience\'.',
	[28] = 'There is nothing more I can tell you. If you are still in need of some {hints}, I can repeat them for you.'
}

function StdModule.rookgaardHints(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.say called without any npcHandler instance.")
	end

	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local hintId = player:getStorageValue(Storage.RookgaardHints)
	npcHandler:say(hints[hintId], cid)
	if hintId >= #hints then
		player:setStorageValue(Storage.RookgaardHints, -1)
	else
		player:setStorageValue(Storage.RookgaardHints, hintId + 1)
	end
	return true
end

-- VoiceModule
VoiceModule = {
	voices = nil,
	voiceCount = 0,
	lastVoice = 0,
	timeout = nil,
	chance = nil,
	npcHandler = nil
}

-- Creates a new instance of VoiceModule
function VoiceModule:new(voices, timeout, chance)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.voices = voices
	for i = 1, #obj.voices do
		local voice = obj.voices[i]
		if voice.yell then
			voice.yell = nil
			voice.talktype = TALKTYPE_YELL
		else
			voice.talktype = TALKTYPE_SAY
		end
	end

	obj.voiceCount = #voices
	obj.timeout = timeout or 10
	obj.chance = chance or 25
	return obj
end

function VoiceModule:init(handler)
	return true
end

function VoiceModule:callbackOnThink()
	if self.lastVoice < os.time() then
		self.lastVoice = os.time() + self.timeout
		if math.random(100) < self.chance  then
			local voice = self.voices[math.random(self.voiceCount)]
			Npc():say(voice.text, voice.talktype)
		end
	end
	return true
end

function Player.removeMoneyNpc(self, amount)

	if type(amount) == 'string' then
		amount = tonumber(amount)
	end

	local moneyCount = self:getMoney()
	local bankCount = self:getBankBalance()

	-- The player have all the money with him
	if amount <= moneyCount then
		-- Removes player inventory money
		self:removeMoney(amount)

		self:sendTextMessage(MESSAGE_TRADE, ("Paid %d gold from inventory."):format(amount))
		return true

	-- The player doens't have all the money with him
	elseif amount <= (moneyCount + bankCount) then

		-- Check if the player has some money
		if moneyCount ~= 0 then
			-- Removes player inventory money
			self:removeMoney(moneyCount)
			local remains = amount - moneyCount

			-- Removes player bank money
			self:setBankBalance(bankCount - remains)

			self:sendTextMessage(MESSAGE_TRADE, ("Paid %d from inventory and %d gold from bank account. Your account balance is now %d gold."):format(moneyCount, amount - moneyCount, self:getBankBalance()))
			return true

		else
			self:setBankBalance(bankCount - amount)
			self:sendTextMessage(MESSAGE_TRADE, ("Paid %d gold from bank account. Your account balance is now %d gold."):format(amount, self:getBankBalance()))
			return true
		end
	end

	return false
end

local function getPlayerMoney(cid)
	local player = Player(cid)
	if player then
		return player:getMoney() + player:getBankBalance()
	end
	return 0
end

local function doPlayerRemoveMoney(cid, amount)
	local player = Player(cid)
	if player then
		return player:removeMoneyNpc(amount)
	end
	return false
end
