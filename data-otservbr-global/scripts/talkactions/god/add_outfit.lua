--[[
	/addoutfit playername, looktype
	make sure you’re adding a male outfit to a male character
	if you try to add a female outfit to a male character, it won’t work
]]

local printConsole = true

local addOutfit = TalkAction("/addoutfit")

function addOutfit.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	local split = param:split(",")
	local name = split[1]
	local lookType = tonumber(split[2])

	local target = Player(name)
	if target then
		target:addOutfit(lookType)
		target:sendTextMessage(MESSAGE_ADMINISTRADOR, "".. player:getName() .." has been added a new outfit for you.")
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, "You have sucessfull added looktype ".. lookType .. " to the player ".. target:getName() ..".")
		if printConsole then
			Spdlog.info(string.format("[addOutfit.onSay] - Player: %s has been added looktype: %s to the player: %s",
				player:getName(), lookType, target:getName()))
		end
		return true
	else
		player:sendCancelMessage("Player not found.")
		return true
	end
	return false
end

addOutfit:separator(" ")
addOutfit:register()
