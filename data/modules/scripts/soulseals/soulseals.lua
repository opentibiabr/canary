local ClientPackets = {
	SoulSealsFightMonster = 0xBA,
}

local ServerPackets = {
	SoulSealsDialog = 0xBA,
}

-- Minimal official-client compatible bridge for 15.25 login/gameplay testing.
-- Keep the full Soul Seals model in protocol evidence before replacing this
-- empty dialog with real server data.

local function readU16(msg)
	if msg:getUnreadBytes() < 2 then
		return nil
	end

	return msg:getU16()
end

local function skipUnread(msg)
	local unreadBytes = msg:getUnreadBytes()
	if unreadBytes > 0 then
		msg:skipBytes(unreadBytes)
	end
end

local function sendSoulSealsDialog(player, raceIds)
	local msg = NetworkMessage()
	msg:addByte(ServerPackets.SoulSealsDialog)
	msg:addU16(#raceIds)
	for _, raceId in ipairs(raceIds) do
		msg:addU16(raceId)
	end
	msg:sendToPlayer(player)
end

function onRecvbyte(player, msg, byte)
	if byte ~= ClientPackets.SoulSealsFightMonster then
		return
	end

	local raceId = readU16(msg)
	if not raceId then
		logger.debug("[SoulSeals] ignored malformed 0xBA packet from player='{}': missing race id", player:getName())
		return
	end

	skipUnread(msg)
	sendSoulSealsDialog(player, {})
	logger.debug("[SoulSeals] player='{}' requested raceId={} with placeholder official payload.", player:getName(), raceId)
end
