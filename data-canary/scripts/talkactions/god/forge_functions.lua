local dustFunctions = TalkAction("/adddusts")
function dustFunctions.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required.")
		-- Distro log
		Spdlog.error("[dustFunctions.onSay] - Player name param not found.")
		return false
	end

	local split = param:split(",")
	local name = split[1]
	local dustAmount = nil
	if split[2] then
		dustAmount = tonumber(split[2])
	end

	-- Check if player is online
	local targetPlayer = Player(name)
	if not targetPlayer then
		player:sendCancelMessage("Player ".. string.titleCase(name) .." is not online.")
		-- Distro log
		Spdlog.error("[dustFunctions.onSay] - Player ".. string.titleCase(name) .." is not online.")
		return false
	end

	-- Check if the dustAmount is valid
	if dustAmount <= 0 or dustAmount == nil then
		player:sendCancelMessage("Invalid dust count.")
		return false
	end

	-- Check dust level
	local finalDustAmount = targetPlayer:getForgeDusts() + dustAmount
	if finalDustAmount > targetPlayer:getForgeDustLevel() then
		dustAmount = targetPlayer:getForgeDustLevel() - targetPlayer:getForgeDusts()
	end

	targetPlayer:addForgeDusts(dustAmount)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Successful added ".. dustAmount .." \z
                           dusts for the ".. targetPlayer:getName() .." player.")
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "".. player:getName() .." added \z
	                             ".. dustAmount .." dusts to your character.")
	-- Distro log
	Spdlog.info("".. player:getName() .." added ".. dustAmount .." dusts to ".. targetPlayer:getName() .." player.")
	return true
end

dustFunctions:separator(" ")
dustFunctions:register()

local removeDusts = TalkAction("/removedusts")
function removeDusts.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required.")
		-- Distro log
		Spdlog.error("[removeDusts.onSay] - Player name param not found.")
		return false
	end

	local split = param:split(",")
	local name = split[1]
	local dustAmount = nil
	if split[2] then
		dustAmount = tonumber(split[2])
	end

	-- Check if player is online
	local targetPlayer = Player(name)
	if not targetPlayer then
		player:sendCancelMessage("Player ".. string.titleCase(name) .." is not online.")
		-- Distro log
		Spdlog.error("[removeDusts.onSay] - Player ".. string.titleCase(name) .." is not online.")
		return false
	end

	-- Check if the dustAmount is valid
	if dustAmount <= 0 or dustAmount == nil then
		player:sendCancelMessage("Invalid dust count.")
		return false
	end

	-- Check dust level
	finalDustAmount = targetPlayer:getForgeDusts() - dustAmount
	if finalDustAmount < 0 then
		dustAmount = targetPlayer:getForgeDusts()
	end

	targetPlayer:removeForgeDusts(dustAmount)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Successful removed ".. dustAmount .." \z
                           dusts for the ".. targetPlayer:getName() .." player.")
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "".. player:getName() .." removed \z
	                             ".. dustAmount .." dusts to your character.")
	-- Distro log
	Spdlog.info("".. player:getName() .." removed ".. dustAmount .." dusts to ".. targetPlayer:getName() .." player.")
	return true
end

removeDusts:separator(" ")
removeDusts:register()

local getDusts = TalkAction("/getdusts")
function getDusts.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required.")
		-- Distro log
		Spdlog.error("[getDusts.onSay] - Player name param not found.")
		return false
	end


	-- Check if player is online
	local split = param:split(",")
	local name = split[1]
	local targetPlayer = Player(name)
	if not targetPlayer then
		player:sendCancelMessage("Player ".. string.titleCase(name) .." is not online.")
		-- Distro log
		Spdlog.error("[getDusts.onSay] - Player ".. string.titleCase(name) .." is not online.")
		return false
	end

	local dustAmount
	dustAmount = targetPlayer:getForgeDusts()
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "".. targetPlayer:getName() .." has ".. dustAmount .." dusts.")
	-- Distro log
	Spdlog.info("".. targetPlayer:getName() .." has ".. dustAmount .." dusts.")
	return true
end

getDusts:separator(" ")
getDusts:register()

local setDusts = TalkAction("/setdusts")
function setDusts.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required.")
		-- Distro log
		Spdlog.error("[setDusts.onSay] - Player name param not found.")
		return false
	end

	local split = param:split(",")
	local name = split[1]
	local dustAmount = nil
	if split[2] then
		dustAmount = tonumber(split[2])
	end

	-- Check if player is online
	local targetPlayer = Player(name)
	if not targetPlayer then
		player:sendCancelMessage("Player ".. string.titleCase(name) .." is not online.")
		-- Distro log
		Spdlog.error("[setDusts.onSay] - Player ".. string.titleCase(name) .." is not online.")
		return false
	end

	-- Check if the dustAmount is valid
	if dustAmount <= 0 or dustAmount == nil then
		player:sendCancelMessage("Invalid dust count.")
		return false
	end

	-- Check dust level
	if dustAmount > targetPlayer:getForgeDustLevel() then
		dustAmount = targetPlayer:getForgeDustLevel()
	end

	targetPlayer:setForgeDusts(dustAmount)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Successful set ".. dustAmount .." \z
							dusts for the ".. targetPlayer:getName() .." player.")
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "".. player:getName() .." set \z
	                             ".. dustAmount .." dusts to your character.")
	-- Distro log
	Spdlog.info("".. player:getName() .." set ".. dustAmount .." dusts to ".. targetPlayer:getName() .." player.")
	return true
end

setDusts:separator(" ")
setDusts:register()

-- Goto fiendish monster
local gotoFiendish = TalkAction("/fiendish")

function gotoFiendish.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	local monster = Monster(ForgeMonster:pickFiendish())
	if monster then
		player:teleportTo(monster:getPosition())
	else
		player:sendCancelMessage("There are not fiendish monsters right now.")
	end
	return false
end

gotoFiendish:register()

-- Goto influenced monster
local gotoInfluenced = TalkAction("/influenced")

function gotoInfluenced.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	local monster = Monster(ForgeMonster:pickInfluenced())
	if monster then
		player:teleportTo(monster:getPosition())
	else
		player:sendCancelMessage("There are not influenced monsters right now.")
	end
	return false
end

gotoInfluenced:register()

-- Open forge window
local forge = TalkAction("/openforge")

function forge.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	return player:openForge()
end

forge:register()
