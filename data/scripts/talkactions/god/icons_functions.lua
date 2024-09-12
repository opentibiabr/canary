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

function Player:sendNormalIcons(icons)
	local msg = NetworkMessage()
	msg:addByte(0xA2)
	msg:addU32(icons)
	msg:addByte(0)
	msg:sendToPlayer(self)
end

function Player:sendIconBakragore(specialIcon)
	local msg = NetworkMessage()
	msg:addByte(0xA3)
	msg:addU32(specialIcon)
	msg:addByte(0)
	msg:sendToPlayer(self)
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

	local split = param:split(",")
	local firstParam = split[1]:trim():lower()

	if firstParam == "special" and tonumber(split[2]) then
		local specialIcon = tonumber(split[2])
		player:sendIconBakragore(specialIcon)
	else
		local icons = convertIconsToBitValue(param)
		player:sendNormalIcons(icons)
	end

	return true
end

testIcons:separator(" ")
testIcons:setDescription("[Usage]: /testicon {icon1}, {icon2}, {icon3}, ... [Usage2]: /testicon special, {icon}")
testIcons:groupType("god")
testIcons:register()

local condition = Condition(CONDITION_BAKRAGORE, CONDITIONID_DEFAULT, 0, true)

local bakragoreIcon = TalkAction("/bakragoreicon")

function bakragoreIcon.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Icon number required.")
		logger.error("[addBakragoreIcon.onSay] - Icon number's required")
		return true
	end

	if param == "remove" then
		player:removeIconBakragore()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Removed all Bakragore icons.")
		return true
	end

	local numParam = tonumber(param)
	if numParam then
		if player:hasCondition(CONDITION_BAKRAGORE, numParam) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have the Bakragore icon.")
			return true
		end

		condition:setParameter(CONDITION_PARAM_SUBID, numParam)
		condition:setParameter(CONDITION_PARAM_TICKS, -1)
		player:addCondition(condition)

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Added Bakragore icon with ID: " .. numParam)
	end

	return true
end

bakragoreIcon:separator(" ")
bakragoreIcon:groupType("god")
bakragoreIcon:register()
