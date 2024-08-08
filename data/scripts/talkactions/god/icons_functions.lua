
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

--[[

Usage (normal icons):
/testicon 1
/testicon 2
/testicon 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

Usage (special icons):
/testicon special, 1
/testicon special, 2
]]

local testIcons = TalkAction("/testicon")

function testIcons.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Icon required.")
		logger.error("[testIcons.onSay] - Icon number's required")
		return true
	end

	local numParam = tonumber(param)
	if numParam then
		function Player:sendNormalIcons()
			local msg = NetworkMessage()
			msg:addByte(0xA2)
			local icons = convertIconsToBitValue(param)
			msg:addU32(icons)
			msg:addByte(0)
			msg:sendToPlayer(self)
		end

		player:sendNormalIcons()
	end

	local split = param:split(",")
	local specialParam = split[1]:trim():lower()
	if specialParam == "special" then
		local specialIcon = tonumber(split[2])
		if specialIcon then
			player:sendIconBakragore(specialIcon)
		end
	end

	return true
end

testIcons:separator(" ")
testIcons:setDescription("[Usage]: /testicon {icon1}, {icon2}, {icon3}, ... [Usage2]: /testicon special, {icon}")
testIcons:groupType("god")
testIcons:register()
