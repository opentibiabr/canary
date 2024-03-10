local npcSpawns = {
	{ name = "Ghostly Wolf", spawnPeriod = LIGHT_STATE_SUNSET, despawnPeriod = LIGHT_STATE_SUNRISE, position = { x = 33332, y = 32052, z = 7 } },
	{ name = "Talila", spawnPeriod = LIGHT_STATE_SUNSET, despawnPeriod = LIGHT_STATE_SUNRISE, position = { x = 33504, y = 32222, z = 7 } },
	{ name = "Valindara", spawnPeriod = LIGHT_STATE_SUNRISE, despawnPeriod = LIGHT_STATE_SUNSET, position = { x = 33504, y = 32222, z = 7 } },
}

local spawnsNpcByTime = GlobalEvent("SpawnsNpcByTime")

function spawnsNpcByTime.onPeriodChange(period)
	for _, npcSpawn in ipairs(npcSpawns) do
		if npcSpawn.spawnPeriod == period then
			local spawnNpc = Game.createNpc(npcSpawn.name, npcSpawn.position)
			if spawnNpc then
				spawnNpc:setMasterPos(npcSpawn.position)
				spawnNpc:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		elseif npcSpawn.despawnPeriod == period then
			local despawnNpc = Npc(npcSpawn.name)
			if despawnNpc then
				despawnNpc:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				despawnNpc:remove()
			end
		end
	end
	return true
end

spawnsNpcByTime:register()
