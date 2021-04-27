-------------THIS SCRIPT WAS MADED BY VANKK AT 15TH DECEMBER 2016 AT 4 P.M (GMT - 3) -------------

local config = {
	[22606] = {
		targetId = 22636, -- Target ID.
		bossName = 'Zavarash', -- boss name
		keyPlayerPosition = Position(33608, 32394, 11), -- Where the player should be.
		newPosition = Position(33567, 32422, 12), -- Position to teleport
		bossPosition = Position(33565, 32418, 12), -- Boss Position
		centerPosition = Position(33567, 32422, 12), -- Center Room
		exitPosition = Position(33611, 32377, 11), -- Exit Position
		rangeX = 20, -- Range in X
		rangeY = 20, -- Range in Y
		time = 15, -- time in minutes to remove the player
	},
	[22605] = {
		targetId = 22634, -- Target ID.
		bossName = 'Horadron', -- boss name
		keyPlayerPosition = Position(33603, 32394, 11), -- Where the player should be.
		newPosition = Position(33607, 32421, 12), -- Position to teleport
		bossPosition = Position(33606, 32417, 12), -- Boss Position
		centerPosition = Position(33607, 32421, 12), -- Center Room
		exitPosition = Position(33611, 32377, 11), -- Exit Position
		rangeX = 20,
		rangeY = 20,
		time = 15, -- time in minutes to remove the player
	},
	[22604] = {
		targetId = 22638, -- Target ID.
		bossName = 'Terofar', -- boss name
		keyPlayerPosition = Position(33614, 32394, 11),  -- Where the player should be.
		newPosition = Position(33526, 32421, 12), -- Position to teleport
		bossPosition = Position(33524, 32418, 12), -- Boss Position
		centerPosition = Position(33526, 32421, 12), -- Center Room
		exitPosition = Position(33611, 32377, 11), -- Exit Position
		rangeX = 20,
		rangeY = 20,
		time = 15, -- time in minutes to remove the player
	}
}

local function roomIsOccupied(centerPosition, rangeX, rangeY)
	local spectators = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	if #spectators ~= 0 then
		return true
	end

	return false
end

function clearBossRoom(playerId, centerPosition, rangeX, rangeY, exitPosition)
	local spectators, spectator = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isPlayer() and spectator.uid == playerId then
			spectator:teleportTo(exitPosition)
			exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end

		if spectator:isMonster() then
			spectator:remove()
		end
	end
end

local keys = Action()

function keys.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tmpConfig = config[item.itemid]
	if not tmpConfig then
		return true
	end

	if target.itemid ~= tmpConfig.targetId then
		return true
	end

	local creature = Tile(tmpConfig.keyPlayerPosition):getTopCreature()
	if not creature or not creature:isPlayer() then
		return true
	end

	if roomIsOccupied(tmpConfig.centerPosition, tmpConfig.rangeX, tmpConfig.rangeY) then
		player:sendCancelMessage("There is someone in the room.")
		return true
	end

	local monster = Game.createMonster(tmpConfig.bossName, tmpConfig.bossPosition)
	if not monster then
		return true
	end

	-- Send message
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have entered an ancient demon prison cell!')
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have fifteen minutes to kill and loot this boss, else you will lose that chance.')

	-- Let's roll
	addEvent(clearBossRoom, 60 * tmpConfig.time * 1000, player:getId(), tmpConfig.centerPosition, tmpConfig.rangeX, tmpConfig.rangeY, tmpConfig.exitPosition)
	item:remove()
	player:teleportTo(tmpConfig.newPosition)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

keys:id(22604, 22605, 22606)
keys:register()
