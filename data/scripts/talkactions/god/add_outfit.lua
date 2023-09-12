--[[
	/addoutfit playername, looktype
	make sure you’re adding a male outfit to a male character
	if you try to add a female outfit to a male character, it won’t work
]]

local printConsole = true

local addOutfit = TalkAction("/addoutfit")

function addOutfit.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	local name = split[1]

	local target = Player(name)
	if target then
		local lookType = tonumber(split[2])
		target:addOutfit(lookType)
		target:sendTextMessage(MESSAGE_ADMINISTRADOR, "" .. player:getName() .. " has been added a new outfit for you.")
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, "You have sucessfull added looktype " .. lookType .. " to the player " .. target:getName() .. ".")
		if printConsole then
			logger.info("[addOutfit.onSay] - Player: {} has been added looktype: {} to the player: {}", player:getName(), lookType, target:getName())
		end
		return true
	else
		player:sendCancelMessage("Player not found.")
		return true
	end
	return true
end

addOutfit:separator(" ")
addOutfit:groupType("god")
addOutfit:register()
