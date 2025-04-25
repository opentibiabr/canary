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

local creatureIconQuests = {
	[0] = "None",
	[1] = "WhiteCross",
	[2] = "RedCross",
	[3] = "RedBall",
	[4] = "GreenBall",
	[5] = "RedGreenBall",
	[6] = "GreenShield",
	[7] = "YellowShield",
	[8] = "BlueShield",
	[9] = "PurpleShield",
	[10] = "RedShield",
	[11] = "Dove",
	[12] = "Energy",
	[13] = "Earth",
	[14] = "Water",
	[15] = "Fire",
	[16] = "Ice",
	[17] = "ArrowUp",
	[18] = "ArrowDown",
	[19] = "ExclamationMark",
	[20] = "QuestionMark",
	[21] = "CancelMark",
	[22] = "Hazard",
	[23] = "BrownSkull",
	[24] = "BloodDrop",
}

local creatureIconAction = TalkAction("/playericon")

function creatureIconAction.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Usage: /playericon {icon_id}, {quantity}, {direction (optional: up/down)}")
		return true
	end

	local split = param:split(",")
	local iconId = tonumber(split[1] and split[1]:trim())
	local count = tonumber(split[2] and split[2]:trim()) or 0
	local direction = (split[3] and split[3]:trim():lower()) or "down"

	local maxIconId = 0
	for id in pairs(creatureIconQuests) do
		if id > maxIconId then
			maxIconId = id
		end
	end

	if not iconId or not creatureIconQuests[iconId] then
		iconId = maxIconId
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid icon ID. Using maximum valid ID: " .. iconId .. " (" .. creatureIconQuests[iconId] .. ")")
	end

	if count <= 0 then
		player:sendCancelMessage("Invalid quantity. It must be greater than 0.")
		return true
	end

	if direction ~= "up" and direction ~= "down" then
		player:sendCancelMessage("Invalid direction. Use 'up' or 'down'.")
		return true
	end

	local iconName = creatureIconQuests[iconId]
	local key = "player-test-icon"
	local category = CreatureIconCategory_Quests

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Applied icon '%s' in %s mode with quantity: %d", iconName, direction, count))

	local function updateIcon(current, target, step)
		if not player or not player:isPlayer() then
			return
		end

		player:setIcon(key, category, iconId, current)

		if (step > 0 and current < target) or (step < 0 and current > target) then
			addEvent(function()
				updateIcon(current + step, target, step)
			end, 1000)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Icon countdown ended. Removing in 10 seconds...")
			addEvent(function()
				if player and player:isPlayer() then
					player:setIcon(key, category, 0, 0)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Icon removed.")
				end
			end, 10000)
		end
	end

	if direction == "down" then
		updateIcon(count, 0, -1)
	else
		updateIcon(0, count, 1)
	end

	return true
end

creatureIconAction:separator(" ")
creatureIconAction:setDescription("[Usage]: /playericon {icon_id}, {quantity}, {direction (up/down)}")
creatureIconAction:groupType("god")
creatureIconAction:register()
