local config = {
	[28574] = {storage = Storage.DeeplingsWorldChange.Crystal, value = 13, position = Position(33641, 31236, 11)},
	[28575] = {storage = Storage.DeeplingsWorldChange.Crystal, value = 13, position = Position(33421, 31255, 11)},
	[28576] = {storage = Storage.DeeplingsWorldChange.Crystal, value = 13, position = Position(33543, 31263, 11)}
}

local deeplingBosses = MoveEvent()

function deeplingBosses.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local setting = config[item.uid]
	if player:getStorageValue(setting.storage) == setting.value then
		player:teleportTo(setting.position)
		player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
		return true
	else
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
		return true
	end
end

for index, value in pairs(config) do
	deeplingBosses:uid(index)
end

deeplingBosses:register()
