-- talkActions to help test deflect condition

local addDeflect = TalkAction("/adddeflect")

function addDeflect.onSay(player, words, param)
	local split = param:split(",")
	if #split ~= 4 then
		player:sendCancelMessage("Insufficient parameters. Usage: /adddeflect <playerName>, <source>, <conditionId>, <deflectChance>")
		return true
	end

	local playerName = split[1]:trimSpace()
	local targetPlayer = Player(playerName)
	if not targetPlayer then
		player:sendCancelMessage("Player " .. playerName .. " not found.")
		return true
	end

	local source = split[2]:trimSpace()

	local conditionId = split[3]:trimSpace()
	conditionId = tonumber(conditionId)
	if not conditionId then
		player:sendCancelMessage("<conditionId> must be a number.")
		return true
	end

	local deflectChance = split[4]:trimSpace()
	deflectChance = tonumber(deflectChance)
	if not deflectChance then
		player:sendCancelMessage("<deflectChance> must be a number.")
		return true
	end

	targetPlayer:addDeflectCondition(source, conditionId, deflectChance)
	return true
end

addDeflect:separator(" ")
addDeflect:groupType("god")
addDeflect:register()

local removeDeflect = TalkAction("/removedeflect")

function removeDeflect.onSay(player, words, param)
	local split = param:split(",")
	if #split ~= 4 then
		player:sendCancelMessage("Insufficient parameters. Usage: /removedeflect <playerName>, <source>, <conditionId>, <deflectChance>")
		return true
	end

	local playerName = split[1]:trimSpace()
	local targetPlayer = Player(playerName)
	if not targetPlayer then
		player:sendCancelMessage("Player " .. playerName .. " not found.")
		return true
	end

	local source = split[2]:trimSpace()

	local conditionId = split[3]:trimSpace()
	conditionId = tonumber(conditionId)
	if not conditionId then
		player:sendCancelMessage("<conditionId> must be a number.")
		return true
	end

	local deflectChance = split[4]:trimSpace()
	deflectChance = tonumber(deflectChance)
	if not deflectChance then
		player:sendCancelMessage("<deflectChance> must be a number.")
		return true
	end

	targetPlayer:removeDeflectCondition(source, conditionId, deflectChance)
	return true
end

removeDeflect:separator(" ")
removeDeflect:groupType("god")
removeDeflect:register()
