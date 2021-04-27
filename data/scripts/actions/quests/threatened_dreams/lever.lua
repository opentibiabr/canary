local setting = {
	timeToFightAgain = 20, -- In hour
	clearRoomTime = 60, -- In hour
	centerRoom = {x = 33617, y = 32562, z = 13},
	range = 10,
	exitPosition = {x = 33618, y = 32520, z = 15},
	storage = Storage.ThreatenedDreams.FacelessBaneTime,
	bossName = "faceless bane",
	bossPosition = {x = 33528, y = 32333, z = 12}
}

local playerPositions = {
	{fromPos = {x = 33638, y = 32562, z = 13}, toPos = {x = 33615, y = 32567, z = 13}},
	{fromPos = {x = 33639, y = 32362, z = 13}, toPos = {x = 33616, y = 32567, z = 13}},
	{fromPos = {x = 33640, y = 32362, z = 13}, toPos = {x = 33617, y = 32567, z = 13}},
	{fromPos = {x = 33641, y = 32362, z = 13}, toPos = {x = 33618, y = 32567, z = 13}},
	{fromPos = {x = 33642, y = 32362, z = 13}, toPos = {x = 33619, y = 32567, z = 13}}
}

local threatenedLever = Action()
function threatenedLever.onUse(player, item, fromPosition, target, toPosition, monster, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33638, 32562, 13) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need 5 players to fight with this boss.")
			item:transform(9826)
			return true
		end

		if roomIsOccupied(setting.centerRoom, setting.range, setting.range) then
			player:say("Someone is fighting against the boss! You need wait awhile.", TALKTYPE_MONSTER_SAY)
			return true
		end

		for i = 1, #playerPositions do
			local creature = Tile(playerPositions[i].fromPos):getTopCreature()
			if creature then
				if creature:getStorageValue(setting.storage) >= os.time() then
					creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have faced this boss in the last " .. setting.timeToFightAgain .. " hours.")
					return true
				end
				if creature:getStorageValue(setting.storage) < os.time() then
					creature:setStorageValue(setting.storage, os.time() + setting.timeToFightAgain * 60 * 60)
					creature:teleportTo(playerPositions[i].toPos)
					creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
		end
		-- One hour for clean the room
		addEvent(clearRoom, setting.clearRoomTime * 60 * 1000, setting.centerRoom, setting.range, setting.range, setting.exitPosition)
		Game.createMonster(setting.bossName, setting.bossPosition)
	end
	return true
end

threatenedLever:uid(1039)
threatenedLever:register()