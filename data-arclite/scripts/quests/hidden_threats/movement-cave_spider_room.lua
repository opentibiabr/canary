local config = {
	bossName = 'Cave Spider', -- boss name
	bossPos = Position(33034, 32107, 12), -- Boss Position
	tarantulasPos = { -- Tarantulas Spawn
		Position(33029, 32103, 12),
		Position(33029, 32107, 12),
		Position(33029, 32111, 12)
	 },
	centerPos = Position(33031, 32107, 12), -- Boss Position
	newPos = Position(33023, 32106, 12), -- Where to teleport player when entering the room
	exitPos = Position(33056, 32004, 11), -- Exit Position
	rangeX = 20, -- Range in X
	rangeY = 10, -- Range in Y
	time = 5, -- time in minutes to remove the player
	access = Storage.Quest.U11_50.HiddenThreats.corymRescueMission -- Quest level to access the room
}

local caveSpiderRoom = MoveEvent()

function caveSpiderRoom.onStepIn(creature, item, position, fromPosition)
local player = creature:getPlayer()
if not player then
	return trued
end

local room = config
if not room then
	return true
end

if player:getStorageValue(room.access) ~= 9 then
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(room.exitPos)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

if roomIsOccupied(room.centerPos, room.rangeX, room.rangeY) then
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(room.exitPos)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

clearRoom(room.centerPos, room.rangeX, room.rangeY, fromPosition)
local monster = Game.createMonster(room.bossName, room.bossPos, true, true)
for i = 1, 3 do Game.createMonster("Tarantula", room.tarantulasPos[i], true, true) end
if not monster then
	return true
end

position:sendMagicEffect(CONST_ME_TELEPORT)
player:teleportTo(room.newPos)
player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
addEvent(clearBossRoom, 60 * room.time * 1000, player.uid, room.centerPos, room.rangeX, room.rangeY, room.exitPos)
player:setStorageValue(room.access, 10)
return true
end

caveSpiderRoom:position(Position(33040, 32081, 12),Position(33039, 32103, 12))
caveSpiderRoom:register()
