local setting = {
	{fromPos = Position(32718, 31628, 7), toPos = Position(32736, 31639, 7), townId = TOWNS_LIST.AB_DENDRIEL},
	{fromPos = Position(32356, 31775, 7), toPos = Position(32364, 31787, 7), townId = TOWNS_LIST.CARLIN},
	{fromPos = Position(32642, 31921, 11), toPos = Position(32656, 31929, 11), townId = TOWNS_LIST.KAZORDOON},
	{fromPos = Position(32364, 32231, 7), toPos = Position(32374, 32243, 7), townId = TOWNS_LIST.THAIS},
	{fromPos = Position(32953, 32072, 7), toPos = Position(32963, 32081, 7), townId = TOWNS_LIST.VENORE},
	{fromPos = Position(33188, 32844, 8), toPos = Position(33201, 32857, 8), townId = TOWNS_LIST.ANKRAHMUN},
	{fromPos = Position(33208, 31803, 8), toPos = Position(33225, 31819, 8), townId = TOWNS_LIST.EDRON},
	{fromPos = Position(33018, 31514, 11), toPos = Position(33032, 31531, 11), townId = TOWNS_LIST.FARMINE},
	{fromPos = Position(33210, 32450, 1), toPos = Position(33217, 32457, 1), townId = TOWNS_LIST.DARASHIA},
	{fromPos = Position(32313, 32818, 7), toPos = Position(32322, 32830, 7), townId = TOWNS_LIST.LIBERTY_BAY},
	{fromPos = Position(32590, 32740, 7), toPos = Position(32600, 32750, 7), townId = TOWNS_LIST.PORT_HOPE},
	{fromPos = Position(32207, 31127, 7), toPos = Position(32218, 31138, 7), townId = TOWNS_LIST.SVARGROND},
	{fromPos = Position(32785, 31274, 7), toPos = Position(32789, 31279, 7), townId = TOWNS_LIST.YALAHAR},
	{fromPos = Position(33442, 31312, 9), toPos = Position(33454, 31326, 9), townId = TOWNS_LIST.GRAY_BEACH},
	{fromPos = Position(33586, 31895, 6), toPos = Position(33603, 31903, 6), townId = TOWNS_LIST.RATHLETON},
	{fromPos = Position(33510, 32360, 6), toPos = Position(33516, 32366, 6), townId = TOWNS_LIST.ROSHAMUUL},
	{fromPos = Position(33916, 31474, 5), toPos = Position(33927, 31484, 5), townId = TOWNS_LIST.ISSAVI}
}

local adventurersStone = Action()

function adventurersStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local playerPos, isInTemple, temple, townId = player:getPosition(), false
	for i = 1, #setting do
		temple = setting[i]
		if isInRange(playerPos, temple.fromPos, temple.toPos) then
			if Tile(playerPos):hasFlag(TILESTATE_PROTECTIONZONE) then
				isInTemple, townId = true, temple.townId
				break
			end
		end
	end

	if not isInTemple then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Try to move more to the center of a temple to use the spiritual energy for a teleport.')
		return true
	end

	player:setStorageValue(Storage.AdventurersGuild.Stone, townId)
	playerPos:sendMagicEffect(CONST_ME_TELEPORT)

	local destination = Position(32210, 32300, 6)
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

adventurersStone:id(18559)
adventurersStone:register()
