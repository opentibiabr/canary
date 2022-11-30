local setting = {
	[2090] = {storage = Storage.PitsOfInferno.ThroneInfernatil, value = 1},
	[2091] = {storage = Storage.PitsOfInferno.ThroneTafariel, value = 1},
	[2092] = {storage = Storage.PitsOfInferno.ThroneVerminor, value = 1},
	[2093] = {storage = Storage.PitsOfInferno.ThroneApocalypse, value = 1},
	[2094] = {storage = Storage.PitsOfInferno.ThroneBazir, value = 1},
	[2095] = {storage = Storage.PitsOfInferno.ThroneAshfalor, value = 1},
	[2096] = {storage = Storage.PitsOfInferno.ThronePumin, value = 1}
}

local checkThrone = MoveEvent()

function checkThrone.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local thrones = setting[item.uid]
	if not thrones then
		return true
	end

	if player:getStorageValue(thrones.storage) ~= thrones.value then
		player:teleportTo(fromPosition, true)
		player:say("You've not absorbed energy from this throne.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

checkThrone:type("stepin")

for index, value in pairs(setting) do
	checkThrone:uid(index)
end

checkThrone:register()
