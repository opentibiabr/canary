local exitDestination = {
	{x = 32360, y = 31781, z = 9},--Carlin
	{x = 32369, y = 32242, z = 6},--Thais
	{x = 32958, y = 32077, z = 5},--Venore
	{x = 32681, y = 31686, z = 2},--Ab'Dendriel
	{x = 32646, y = 31925, z = 11},--Kazodroon
	{x = 33230, y = 32392, z = 5},--Darashia
	{x = 33130, y = 32815, z = 4},--Ankrahmun
	{x = 33266, y = 31835, z = 9},--Edron
	{x = 32337, y = 32837, z = 8},--Liberty Bay
	{x = 32628, y = 32743, z = 4},--Port Hope
	{x = 32213, y = 31132, z = 8},--Svargrond
	{x = 32786, y = 31245, z = 5},--Yalahar
	{x = 33594, y = 31899, z = 4}--Oramond
}
local exitFlamesPos = {
	{x = 32191, y = 31419, z = 2},--ice
	{x = 32197, y = 31419, z = 2},
	{x = 32971, y = 32224, z = 7},--earth
	{x = 32977, y = 32224, z = 7},
	{x = 32971, y = 32228, z = 7},
	{x = 32977, y = 32228, z = 7},
	{x = 32914, y = 32337, z = 15},--fire
	{x = 32914, y = 32342, z = 15},
	{x = 32907, y = 32337, z = 15},
	{x = 32907, y = 32342, z = 15},
	{x = 33063, y = 32711, z = 5},--energy
	{x = 33063, y = 32716, z = 5},
	{x = 33059, y = 32717, z = 5}
}

local shrineExit = MoveEvent()

function shrineExit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	if player:getStorageValue(Storage.ShrineEntrance) >= 1 then
		player:teleportTo(Position(exitDestination[player:getStorageValue(Storage.ShrineEntrance)]))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	player:teleportTo(player:getTown():getTemplePosition())
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

for a = 1, #exitFlamesPos do
	shrineExit:position(exitFlamesPos[a])
end
shrineExit:register()
