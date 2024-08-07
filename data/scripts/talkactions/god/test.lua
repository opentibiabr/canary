local testLog = TalkAction("/testlog")

function testLog.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Log level and message required.")
		logger.error("[testLog.onSay] - Log level and message not found")
		return true
	end

	local split = param:split(",")
	local logLevel = split[1]:trim():lower()
	local message = string.trimSpace(split[2])

	if message == "" then
		player:sendCancelMessage("Log message required.")
		return false
	end

	if logLevel == "info" then
		logger.info("[testLog] - {}", message)
	elseif logLevel == "warn" then
		logger.warn("[testLog] - {}", message)
	elseif logLevel == "error" then
		logger.error("[testLog] - {}", message)
	elseif logLevel == "debug" then
		logger.debug("[testLog] - {}", message)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid log level. Use 'info', 'warn', 'error' or 'debug'.")
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Logged message [" .. message .. "] at '" .. logLevel .. "' level.")
	return true
end

testLog:separator(" ")
testLog:groupType("god")
testLog:register()

local testIcons = TalkAction("/testicons")

local function convertIconsToBitValue(iconList)
	local bitObj = NewBit(0)
	for icon in string.gmatch(iconList, "%d+") do
		icon = tonumber(icon)
		if icon then
			local flag = bit.lshift(1, icon - 1)
			bitObj:updateFlag(flag)
		end
	end
	return bitObj:getNumber()
end

--[[Usage:
/testicons 1
/testicons 2
/testicons 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
]]
function testIcons.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Icon required.")
		logger.error("[testIcons.onSay] - Icon required")
		return true
	end

	function Player:sendIconsTest()
		local msg = NetworkMessage()
		msg:addByte(0xA2)
		local icons = convertIconsToBitValue(param)
		msg:addU32(icons)
		msg:addByte(0)
		msg:sendToPlayer(self)
	end

	player:sendIconsTest()
	return true
end

testIcons:separator(" ")
testIcons:setDescription("[Usage]: /seticons {icon1}, {icon2}, {icon3}, ...")
testIcons:groupType("god")
testIcons:register()
