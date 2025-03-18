local config = {
	[24839] = {
		toPosition = Position(33419, 32841, 11),
		backPosition = Position(33484, 32775, 12),
		boss = "Tarbaz",
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.TarbazTimer,
	},
	[24840] = {
		toPosition = Position(33452, 32356, 13),
		backPosition = Position(33432, 32330, 14),
		boss = "Ragiaz",
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.RagiazTimer,
	},
	[24841] = {
		toPosition = Position(33230, 31493, 13),
		backPosition = Position(33197, 31438, 13),
		boss = "Plagirath",
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.PlagirathTimer,
	},
	[24842] = {
		toPosition = Position(33380, 32454, 14),
		backPosition = Position(33399, 32402, 15),
		boss = "Razzagorn",
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.RazzagornTimer,
	},
	[24843] = {
		toPosition = Position(33680, 32736, 11),
		backPosition = Position(33664, 32682, 10),
		boss = "Zamulosh",
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.ZamuloshTimer,
	},
	[24844] = {
		toPosition = Position(33593, 32658, 14),
		backPosition = Position(33675, 32690, 13),
		boss = "Mazoran",
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.MazoranTimer,
	},
	[24845] = {
		toPosition = Position(33436, 32800, 13),
		backPosition = Position(33477, 32701, 14),
		boss = "Shulgrax",
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.ShulgraxTimer,
	},
	[24846] = {
		toPosition = Position(33270, 31474, 14),
		backPosition = Position(33324, 31374, 14),
		boss = "Ferumbras Mortal Shell",
		cooldownStorage = Storage.Quest.U10_90.FerumbrasAscension.FerumbrasMortalShellTimer,
	},
}

local seal = MoveEvent()

function seal.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local setting = config[item.actionid]
	if not setting then
		return true
	end

	local cooldownTime = player:getStorageValue(setting.cooldownStorage)
	if cooldownTime > os.time() then
		local remainingTime = cooldownTime - os.time()
		local days = math.floor(remainingTime / (24 * 3600))
		local hours = math.floor((remainingTime % (24 * 3600)) / 3600)
		local minutes = math.floor((remainingTime % 3600) / 60)
		player:teleportTo(setting.backPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait for time to pass for this boss again.")
		return true
	end

	if item.actionid == 24844 then -- Mazoran
		if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.Done) >= 4 then
			if player:canFightBoss(setting.boss) then
				player:teleportTo(setting.toPosition)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			else
				player:teleportTo(Position(33675, 32690, 13))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:say("You have to wait to challenge this enemy again!", TALKTYPE_MONSTER_SAY)
				return true
			end
		else
			local pos = position
			pos.y = pos.y + 2
			player:teleportTo(pos)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You not proven your worth. There is no escape for you here.")
			item:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	elseif item.actionid == 24845 then
		if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FlowerPuzzleTimer) >= 1 then
			if player:canFightBoss(setting.boss) then
				player:teleportTo(setting.toPosition)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			else
				player:teleportTo(Position(33477, 32701, 14))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:say("You have to wait to challenge this enemy again!", TALKTYPE_MONSTER_SAY)
				return true
			end
		else
			local pos = position
			pos.y = pos.y + 2
			player:teleportTo(pos)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You not proven your worth. There is no escape for you here.")
			item:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	elseif item.actionid == 24846 then -- Ferumbras Mortal Shell
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The portal leads you to the final challenge.")
	end

	player:teleportTo(setting.toPosition)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

seal:type("stepin")

for index, value in pairs(config) do
	seal:aid(index)
end

seal:register()
