local ClientPackets = {
	Taskboard = 0x5F,
}

local ServerPackets = {
	Taskboard = 0x5B,
}

local OutboundWindow = {
	Bounty = 0x00,
	Weekly = 0x01,
	Shop = 0x02,
}

local ClientAction = {
	Bounty = 0x00,
	Weekly = 0x01,
	BountyDifficulty = 0x02,
	BountyReroll = 0x03,
	ClaimDailyReroll = 0x04,
	BountySelect = 0x05,
	BountyClaimReward = 0x06,
	TalismanUpgrade = 0x07,
	WeeklyDelivery = 0x08,
	WeeklyDifficulty = 0x09,
	Shop = 0x0A,
	ShopBuy = 0x0B,
	UnlockPreferenceSlot = 0x0C,
	ClearPreferred = 0x0D,
	ClearUnwanted = 0x0E,
	AssignPreferred = 0x0F,
	AssignUnwanted = 0x10,
}

local OneBytePayloadActions = {
	[ClientAction.BountyDifficulty] = true,
	[ClientAction.BountySelect] = true,
	[ClientAction.TalismanUpgrade] = true,
	[ClientAction.WeeklyDelivery] = true,
	[ClientAction.WeeklyDifficulty] = true,
}

local OneU16PayloadActions = {
	[ClientAction.ShopBuy] = true,
	[ClientAction.UnlockPreferenceSlot] = true,
	[ClientAction.ClearPreferred] = true,
	[ClientAction.ClearUnwanted] = true,
}

local TwoU16PayloadActions = {
	[ClientAction.AssignPreferred] = true,
	[ClientAction.AssignUnwanted] = true,
}

local BountyResponseActions = {
	[ClientAction.Bounty] = true,
	[ClientAction.BountyDifficulty] = true,
	[ClientAction.BountyReroll] = true,
	[ClientAction.ClaimDailyReroll] = true,
	[ClientAction.BountySelect] = true,
	[ClientAction.BountyClaimReward] = true,
	[ClientAction.TalismanUpgrade] = true,
	[ClientAction.UnlockPreferenceSlot] = true,
	[ClientAction.ClearPreferred] = true,
	[ClientAction.ClearUnwanted] = true,
	[ClientAction.AssignPreferred] = true,
	[ClientAction.AssignUnwanted] = true,
}

local WeeklyResponseActions = {
	[ClientAction.Weekly] = true,
	[ClientAction.WeeklyDelivery] = true,
	[ClientAction.WeeklyDifficulty] = true,
}

local ShopResponseActions = {
	[ClientAction.Shop] = true,
	[ClientAction.ShopBuy] = true,
}

-- Official-client packet shim for 15.25 Taskboard traffic.
-- This intentionally sends empty but structurally valid 0x5B windows. Full
-- task state, rewards, shop contents and Soulpit behavior should be added on
-- top of these byte writers instead of changing the packet contract.

local function readU8(msg)
	if msg:getUnreadBytes() < 1 then
		return nil
	end

	return msg:getByte()
end

local function readU16(msg)
	if msg:getUnreadBytes() < 2 then
		return nil
	end

	return msg:getU16()
end

local function consumeU8(msg)
	return readU8(msg) ~= nil
end

local function consumeU16(msg)
	return readU16(msg) ~= nil
end

local function addEmptyBountyTalismanLine(msg)
	msg:addU16(0)
	msg:addByte(0)
	msg:addU16(0)
end

local function sendBountyWindow(player)
	local msg = NetworkMessage()
	msg:addByte(ServerPackets.Taskboard)
	msg:addByte(OutboundWindow.Bounty)
	msg:addByte(0) -- bounty task count
	msg:addByte(0) -- daily rerolls
	msg:addByte(0) -- reroll state
	msg:addByte(0) -- current difficulty
	addEmptyBountyTalismanLine(msg)
	addEmptyBountyTalismanLine(msg)
	addEmptyBountyTalismanLine(msg)
	addEmptyBountyTalismanLine(msg)
	msg:addByte(0) -- preferred/unwanted slot count
	msg:sendToPlayer(player)
end

local function sendWeeklyWindow(player)
	local msg = NetworkMessage()
	msg:addByte(ServerPackets.Taskboard)
	msg:addByte(OutboundWindow.Weekly)
	msg:addU16(0) -- any creature required amount
	msg:addU16(0) -- any creature current amount
	msg:addByte(0) -- weekly kill task count
	msg:addByte(0) -- weekly item task count
	msg:addByte(0) -- current difficulty
	msg:addU32(0) -- kill experience reward
	msg:addU32(0) -- item delivery experience reward
	msg:addByte(0) -- completed kill tasks
	msg:addByte(0) -- completed item tasks
	msg:addByte(0) -- difficulty selection available
	msg:addByte(0) -- suggested difficulty
	msg:addU32(0) -- next reset timestamp
	msg:addByte(0) -- third weekly slot unlocked
	msg:addU32(0) -- task hunting points reward
	msg:addU32(0) -- soulseals reward tail for current official clients
	msg:sendToPlayer(player)
end

local function sendShopWindow(player)
	local msg = NetworkMessage()
	msg:addByte(ServerPackets.Taskboard)
	msg:addByte(OutboundWindow.Shop)
	msg:addByte(0) -- offer count
	msg:sendToPlayer(player)
end

local function sendWindow(player, window)
	if window == OutboundWindow.Weekly then
		sendWeeklyWindow(player)
	elseif window == OutboundWindow.Shop then
		sendShopWindow(player)
	else
		sendBountyWindow(player)
	end
end

local function consumeActionPayload(msg, action)
	if OneBytePayloadActions[action] then
		return consumeU8(msg)
	end

	if OneU16PayloadActions[action] then
		return consumeU16(msg)
	end

	if TwoU16PayloadActions[action] then
		return consumeU16(msg) and consumeU16(msg)
	end

	return true
end

function onRecvbyte(player, msg, byte)
	if byte ~= ClientPackets.Taskboard then
		return
	end

	local action = readU8(msg)
	if not action then
		logger.debug("[Taskboard] ignored malformed 0x5F packet from player='{}': missing action", player:getName())
		return
	end

	if not consumeActionPayload(msg, action) then
		logger.debug("[Taskboard] ignored malformed 0x5F packet from player='{}': incomplete action {}", player:getName(), action)
		return
	end

	local trailingBytes = msg:getUnreadBytes()
	if trailingBytes > 0 then
		logger.debug("[Taskboard] ignored malformed 0x5F packet from player='{}': action={} unexpected trailing bytes={}", player:getName(), action, trailingBytes)
		return
	end

	if BountyResponseActions[action] then
		sendWindow(player, OutboundWindow.Bounty)
	elseif WeeklyResponseActions[action] then
		sendWindow(player, OutboundWindow.Weekly)
	elseif ShopResponseActions[action] then
		sendWindow(player, OutboundWindow.Shop)
	else
		sendWindow(player, OutboundWindow.Bounty)
	end

	logger.debug("[Taskboard] player='{}' action={} handled by minimal official packet shim.", player:getName(), action)
end
