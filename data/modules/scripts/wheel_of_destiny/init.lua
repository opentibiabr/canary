function onRecvbyte(player, msg, byte)
	if not Wheel.enabled then
		return
	end

	Wheel.parsePacket(player, msg, byte)
end
