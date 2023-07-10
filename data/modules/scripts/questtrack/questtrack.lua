function onRecvbyte(player, msg, byte)
	if byte == 0xD0 then
		local quests = {}
		local missions = msg:getByte()
		for i = 1, missions do
			quests[#quests + 1] = msg:getU16()
		end
		player:resetTrackedMissions(quests)
	end
end
