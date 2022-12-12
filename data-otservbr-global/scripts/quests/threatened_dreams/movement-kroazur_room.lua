local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local config = {
	[25029] = {
		bossName = 'Kroazur', -- boss name
		bossPos = Position(33591, 32305, 10), -- Boss Position
		centerPos = Position(33591, 32305, 10), -- Boss Position
		newPos = Position(33591, 32315, 10), -- Where to teleport player when entering the room
		exitPos = Position(33619, 32306, 9), -- Exit Position
		rangeX = 20, -- Range in X
		rangeY = 20, -- Range in Y
		time = 10, -- time in minutes to remove the player
		timer = ThreatenedDreams.Mission02.KroazurTimer, -- Timer to allow joing the room next time
		access = ThreatenedDreams.Mission02.KroazurAccess -- Quest level to access the room
	}
}

local kroazurRoom = MoveEvent()

function kroazurRoom.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local room = config[item.actionid]
	if not room then
		return
	end

	if player:getPosition() == Position(33591, 32321, 10) then
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(room.exitPos)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	if player:getStorageValue(room.access) < 1 then
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say('You don\'t have access to this room!', TALKTYPE_MONSTER_SAY)
		return true
	end

	if player:getStorageValue(room.timer) > os.time() then
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say('You have to wait to challenge this enemy again!', TALKTYPE_MONSTER_SAY)
		return true
	end

	if roomIsOccupied(room.bossPos, room.rangeX, room.rangeY) then
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say('Someone is fighting against the boss! You need wait awhile.', TALKTYPE_MONSTER_SAY)
		return true
	end

	clearRoom(room.bossPos, room.rangeX, room.rangeY, fromPosition)
	local monster = Game.createMonster(room.bossName, room.bossPos, true, true)
	if not monster then
		return true
	end

	position:sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(room.newPos)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:say('You have ten minutes to kill and loot this boss, else you will lose that chance and will be kicked out.', TALKTYPE_MONSTER_SAY)
	addEvent(clearBossRoom, 60 * room.time * 1000, player.uid, room.centerPos, room.rangeX, room.rangeY, room.exitPos)
	player:setStorageValue(room.timer, os.time() + 2 * 3600)
	return true
end

kroazurRoom:type("stepin")
kroazurRoom:aid(25029)
kroazurRoom:register()
