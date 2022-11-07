function addPlayerEvent(callable, delay, playerId, ...)
	local player = Player(playerId)
	if not player then
		return false
	end

	addEvent(function(callable, playerId, ...)
		local player = Player(playerId)
		if player then
			pcall(callable, player, ...)
		end
	end, delay, callable, player.uid, ...)
end

--[[
function Player.updateFightModes(self)
	local msg = NetworkMessage()

	msg:addByte(0xA7)

	msg:addByte(self:getFightMode())
	msg:addByte(self:getChaseMode())
	msg:addByte(self:getSecureMode() and 1 or 0)
	msg:addByte(self:getPvpMode())

	msg:sendToPlayer(self)
end
]]
