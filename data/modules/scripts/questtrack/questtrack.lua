function onRecvbyte(player, msg, byte)
	if byte == 0xD0 then
		local quests = {}
		local missions = msg:getByte()
		for i = 1, missions do
			local questId = msg:getU16()
			local questName = msg:getString()

			quests[#quests + 1] = {
				id = questId,
			}
		end
		
		player:resetTrackedMissions(quests)
	end
end
