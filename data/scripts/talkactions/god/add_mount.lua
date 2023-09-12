--[[
	/addmount playername, mount
]]

local printConsole = true

local addOutfit = TalkAction("/addmount")

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
		local mount = tonumber(split[2])
		target:addMount(mount)
		target:sendTextMessage(MESSAGE_ADMINISTRADOR, "" .. player:getName() .. " has been added a new mount for you.")
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, "You have sucessfull added mount " .. mount .. " to the player " .. target:getName() .. ".")
		if printConsole then
			logger.info("[addOutfit.onSay] - Player: {} has been added mount: {} to the player: {}", player:getName(), lookType, target:getName())
		end
		return true
	end
	player:sendCancelMessage("Player not found.")
	return true
end

addOutfit:separator(" ")
addOutfit:groupType("god")
addOutfit:register()
