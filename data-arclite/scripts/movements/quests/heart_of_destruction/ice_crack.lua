local config = {
	{position = {x = 32164, y = 31293, z = 6}, itemId = 1066},
	{position = {x = 32164, y = 31292, z = 6}, itemId = 6291},
	{position = {x = 32163, y = 31292, z = 6}, itemId = 6284},
	{position = {x = 32162, y = 31292, z = 6}, itemId = 6295},
	{position = {x = 32162, y = 31293, z = 6}, itemId = 6298},
	{position = {x = 32166, y = 31293, z = 6}, itemId = 6290},
	{position = {x = 32166, y = 31293, z = 6}, itemId = 6293},
	{position = {x = 32167, y = 31293, z = 6}, itemId = 6294},
	{position = {x = 32164, y = 31294, z = 6}, itemId = 6296},
	{position = {x = 32164, y = 31295, z = 6}, itemId = 6285},
	{position = {x = 32164, y = 31296, z = 6}, itemId = 6297},
	{position = {x = 32163, y = 31295, z = 6}, itemId = 6293},
	{position = {x = 32163, y = 31294, z = 6}, itemId = 6291},
	{position = {x = 32162, y = 31296, z = 6}, itemId = 6293},
	{position = {x = 32162, y = 31296, z = 6}, itemId = 6296},
	{position = {x = 32162, y = 31297, z = 6}, itemId = 6297},
	{position = {x = 32161, y = 31294, z = 6}, itemId = 6297},
	{position = {x = 32161, y = 31293, z = 6}, itemId = 6296}
}

local function removeIceCrack(position, itemId)
	local iceCrack = Tile(position):getItemById(itemId)
	if iceCrack then
		iceCrack:remove()
	end
end

local iceCrack = MoveEvent()

function iceCrack.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if Game.getStorageValue(GlobalStorage.IceCrack) ~= 1 then
		for a = 1, #config do
			Game.createItem(config[a].itemId, 1, config[a].position)
			addEvent(removeIceCrack, 5 * 60 * 1000, config[a].position, config[a].itemId)
		end
		Game.setStorageValue(GlobalStorage.IceCrack, 1)
		addEvent(Game.setStorageValue, 5 * 60 * 1000, GlobalStorage.IceCrack, 0)
	end
	return true
end

for b = 32161, 32167 do
	for c = 31292, 31297 do
		iceCrack:position({x = b, y = c, z = 6})
	end
end
iceCrack:register()
