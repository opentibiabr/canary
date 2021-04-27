local config = {
	bossName = "Ascending Ferumbras",
	summonName = "Rift Invader",
	bossPos = Position(33392, 31473, 14),
	centerRoom = Position(33392, 31473, 14), -- Center Room
	exitPosition = Position(33266, 31479, 14), -- Exit Position
	newPos = Position(33392, 31479, 14), -- Player Position on room
	playerPositions = {
		Position(33269, 31477, 14),
		Position(33269, 31478, 14),
		Position(33269, 31479, 14),
		Position(33269, 31480, 14),
		Position(33269, 31481, 14),
		Position(33270, 31477, 14),
		Position(33270, 31478, 14),
		Position(33270, 31479, 14),
		Position(33270, 31480, 14),
		Position(33270, 31481, 14),
		Position(33271, 31477, 14),
		Position(33271, 31478, 14),
		Position(33271, 31479, 14),
		Position(33271, 31480, 14),
		Position(33271, 31481, 14)
	},
	range = 20,
	time = 30, -- time in minutes to remove the player
}
local function clearFerumbrasRoom()
	local spectators = Game.getSpectators(config.bossPos, false, false, 20, 20, 20, 20)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(config.exitPosition)
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spectator:say('Time out! You were teleported out by strange forces.', TALKTYPE_MONSTER_SAY)
		elseif spectator:isMonster() then
			spectator:remove()
		end
	end
end

local ferumbrasAscendantLever = Action()
function ferumbrasAscendantLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33270, 31477, 14) then
			return true
		end

		for x = 33269, 33271 do
			for y = 31477, 31481 do
				local playerTile = Tile(Position(x, y, 14)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					if playerTile:getStorageValue(Storage.FerumbrasAscension.FerumbrasTimer) > os.time() then
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You or a member in your team have to wait 5 days to face Ferumbras again!")
						item:transform(9826)
						return true
					end
				end
			end
		end

		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There's someone fighting with Ferumbras.")
				return true
			end
		end

		local spectators = Game.getSpectators(config.bossPos, false, false, 15, 15, 15, 15)
		for i = 1, #spectators do
			local spectator = spectators[i]
			if spectator:isMonster() then
				spectator:remove()
			end
		end

		for x = 33269, 33271 do
			for y = 31477, 31481 do
				local playerTile = Tile(Position(x, y, 14)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPos)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.FerumbrasAscension.FerumbrasTimer, os.time() + 280 * 60 * 3600) -- 14 days
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have 30 minutes to kill and loot this boss. Otherwise you will lose that chance and will be kicked out.")
					addEvent(clearFerumbrasRoom, 60 * config.time * 1000, player:getId(), config.centerRoom, config.range, config.range, config.exitPosition)

					for b = 1,10 do
						local xrand = math.random(-10, 10)
						local yrand = math.random(-10, 10)
						local position = Position(33392 + xrand, 31473 + yrand, 14)
						if Game.createMonster("rift invader", position) then
						end
					end

					Game.createMonster(config.bossName, config.bossPos, true, true)
					item:transform(9826)
				end
			end
		end
	elseif item.itemid == 9826 then
		item:transform(9825)
		return true
	end
end

ferumbrasAscendantLever:uid(1021)
ferumbrasAscendantLever:register()