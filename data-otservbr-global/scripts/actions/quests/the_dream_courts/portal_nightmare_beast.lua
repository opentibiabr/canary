local storagesTable = {
	{storage = Storage.Quest.U12_00.TheDreamCourts.PlaguerootKilled, bossName = "Plagueroot"},
	{storage = Storage.Quest.U12_00.TheDreamCourts.MalofurKilled, bossName = "Malofur Mangrinder"},
	{storage = Storage.Quest.U12_00.TheDreamCourts.MaxxeniusKilled, bossName = "Maxxenius"},
	{storage = Storage.Quest.U12_00.TheDreamCourts.AlptramunKilled, bossName = "Alptramun"},
	{storage = Storage.Quest.U12_00.TheDreamCourts.IzcandarKilled, bossName = "Izcandar The Banished"},
}

local portalNightmareBeast = MoveEvent()
function portalNightmareBeast.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getLevel() < 250 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need at least level 250 to enter.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end
	local text = ""
	for value in pairs(storagesTable) do
		if player:getStorageValue(storagesTable[value].storage) < 0 then
			text = text .. "\n" .. storagesTable[value].bossName
		end
	end
	if text == "" then
		return true
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You still need to defeat:" .. text)
		player:teleportTo(fromPosition, true)
		return false
	end
end

portalNightmareBeast:type("stepin")
portalNightmareBeast:position({x = 32211, y = 32081, z = 15})
portalNightmareBeast:register()