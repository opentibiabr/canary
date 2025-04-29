local UniqueTable = {
	-- Tazhadur entrance
	[35001] = {
		storage = Storage.Quest.U11_02.TheFirstDragon.DragonCounter,
		value = 200,
		range = 10,
		newPos = { x = 32015, y = 32466, z = 8 },
		bossName = "Tazhadur",
		bossPos = { x = 32018, y = 32465, z = 8 },
	},
	-- Kalyassa entrance
	[35002] = {
		storage = Storage.Quest.U11_02.TheFirstDragon.ChestCounter,
		value = 4,
		range = 10,
		newPos = { x = 32078, y = 32456, z = 8 },
		bossName = "Kalyassa",
		bossPos = { x = 32079, y = 32459, z = 8 },
	},
	-- Zorvorax entrance
	[35003] = {
		storage = Storage.Quest.U11_02.TheFirstDragon.SecretsCounter,
		value = 3,
		range = 10,
		newPos = { x = 32008, y = 32396, z = 8 },
		bossName = "Zorvorax",
		bossPos = { x = 32015, y = 32396, z = 8 },
	},
	-- Gelidrazah entrance
	[35004] = {
		storage = Storage.Quest.U11_02.TheFirstDragon.GelidrazahAccess,
		value = 1,
		range = 10,
		newPos = { x = 32076, y = 32402, z = 8 },
		bossName = "Gelidrazah The Frozen",
		bossPos = { x = 32078, y = 32400, z = 8 },
	},
}

local entranceTeleport = MoveEvent()
function entranceTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local setting = UniqueTable[item.uid]
	if not setting then
		return true
	end

	if roomIsOccupied(setting.bossPos, false, setting.range, setting.range) then
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("Someone is fighting against the boss! You need wait a while.", TALKTYPE_MONSTER_SAY)
		return true
	end

	if not player:canFightBoss(setting.bossName) then
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You have to wait to challenge this enemy again!", TALKTYPE_MONSTER_SAY)
		return true
	end

	if player:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.Questline) < 1 or player:getStorageValue(setting.storage) < setting.value then
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You don't have permission to use this portal", TALKTYPE_MONSTER_SAY)
		return true
	end

	if player:getStorageValue(setting.storage) >= setting.value then
		local monster = Game.createMonster(setting.bossName, setting.bossPos, true, true)
		if not monster then
			return true
		end

		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(setting.newPos)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You have ten minutes to kill and loot this boss. Otherwise you will lose that chance and will be kicked out.", TALKTYPE_MONSTER_SAY)
		player:setBossCooldown(setting.bossName, os.time() + 2 * 3600)
		addEvent(clearBossRoom, 60 * 30 * 1000, player.uid, setting.bossPos, false, setting.range, setting.range, fromPosition)
		return true
	end
	return true
end

for index, value in pairs(UniqueTable) do
	entranceTeleport:uid(index)
end

entranceTeleport:register()
