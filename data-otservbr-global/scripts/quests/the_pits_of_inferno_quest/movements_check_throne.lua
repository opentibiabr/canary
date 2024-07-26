local setting = {
	[2090] = { storage = Storage.Quest.U7_9.ThePitsOfInferno.ThroneInfernatil, value = 1 },
	[2091] = { storage = Storage.Quest.U7_9.ThePitsOfInferno.ThroneTafariel, value = 1 },
	[2092] = { storage = Storage.Quest.U7_9.ThePitsOfInferno.ThroneVerminor, value = 1 },
	[2093] = { storage = Storage.Quest.U7_9.ThePitsOfInferno.ThroneApocalypse, value = 1 },
	[2094] = { storage = Storage.Quest.U7_9.ThePitsOfInferno.ThroneBazir, value = 1 },
	[2095] = { storage = Storage.Quest.U7_9.ThePitsOfInferno.ThroneAshfalor, value = 1 },
	[2096] = { storage = Storage.Quest.U7_9.ThePitsOfInferno.ThronePumin, value = 10 },
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
