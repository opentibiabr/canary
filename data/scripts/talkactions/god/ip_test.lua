local iptest = TalkAction("/iptest")

local function boolText(value)
	return value and "true" or "false"
end

function iptest.onSay(player, words, param)
	local ipAddress = player:getIpAddress()
	local ipString = player:getIpString()
	local ipFamily = player:getIpFamily()
	local isIPv4 = player:isIpV4()
	local isIPv6 = player:isIpV6()

	player:sendTextMessage(MESSAGE_HEALED, string.format("[IP TEST] Player: %s", player:getName()))
	player:sendTextMessage(MESSAGE_HEALED, string.format("[IP TEST] Current IP: %s", tostring(ipAddress)))
	player:sendTextMessage(MESSAGE_HEALED, string.format("[IP TEST] getIpString(): %s", ipString))
	player:sendTextMessage(MESSAGE_HEALED, string.format("[IP TEST] getIpFamily(): %s", tostring(ipFamily)))
	player:sendTextMessage(MESSAGE_HEALED, string.format("[IP TEST] isIpV4(): %s", boolText(isIPv4)))
	player:sendTextMessage(MESSAGE_HEALED, string.format("[IP TEST] isIpV6(): %s", boolText(isIPv6)))

	if isIPv4 then
		player:sendTextMessage(MESSAGE_HEALED, "[IP TEST] Active connection is IPv4.")
	elseif isIPv6 then
		player:sendTextMessage(MESSAGE_HEALED, "[IP TEST] Active connection is IPv6.")
	else
		player:sendTextMessage(MESSAGE_HEALED, "[IP TEST] Unknown IP family.")
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "IP test completed. Check the server log for details.")
	return true
end

iptest:separator(" ")
iptest:groupType("god")
iptest:register()
