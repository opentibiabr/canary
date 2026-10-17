local default = {
	[1] = {
		itemPosition = Position(33618, 32546, 13),
		toPosition = Position(32723, 32270, 8),
		neededStorage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
		value = 2,
		blockedText = "Connect all three gateways to restore the circle of energy sustaining this nexus.",
	},
	[2] = {
		itemPosition = Position(32720, 32270, 8),
		toPosition = Position(33618, 32544, 13),
		neededStorage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
		value = 2,
		blockedText = "Connect all three gateways to restore the circle of energy sustaining this nexus.",
	},
	[3] = {
		itemPosition = Position(33619, 32526, 15),
		toPosition = Position(33619, 32528, 15),
		neededStorage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
		value = 2,
		msg = "You traverse the rubble with ease but more of it falls down behind you, essentially blocking your path once again.",
	},
}

local dreamScar = {
	[1] = {
		day = "Monday",
		bossName = "Alptramun",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.AlptramunTimer,
	},
	[2] = {
		day = "Tuesday",
		bossName = "Izcandar the Banished",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.IzcandarTimer,
	},
	[3] = {
		day = "Wednesday",
		bossName = "Malofur Mangrinder",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.MalofurTimer,
	},
	[4] = {
		day = "Thursday",
		bossName = "Maxxenius",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.MaxxeniusTimer,
	},
	[5] = {
		day = "Friday",
		bossName = "Izcandar the Banished",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.IzcandarTimer,
	},
	[6] = {
		day = "Saturday",
		bossName = "Plagueroot",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.PlagueRootTimer,
	},
	[7] = {
		day = "Sunday",
		bossName = "Maxxenius",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.MaxxeniusTimer,
	},
}

local permission = Storage.Quest.U12_00.TheDreamCourts.DreamScar.Permission

local movements_acessTeleports = MoveEvent()

function movements_acessTeleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()

	if not player then
		return true
	end

	local iPos = item:getPosition()
	local dreamScarTeleport = Position(32208, 32033, 13)
	local nightmareTeleport = Position(32211, 32081, 15)
	local destination = fromPosition
	local message
	local successMessage

	if iPos == nightmareTeleport then
		if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.BossCount) >= 5 then
			if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.NightmareTimer) > os.time() then
				message = "You have to wait to challenge The Nightmare Beast again!"
			else
				destination = Position(32211, 32075, 15)
			end
		else
			message = "You can not use this teleport yet."
		end
	elseif iPos == dreamScarTeleport then
		if player:getStorageValue(permission) >= 1 then
			for i = 1, #dreamScar do
				if os.date("%A") == dreamScar[i].day then
					if player:getStorageValue(dreamScar[i].storageTimer) > os.time() then
						message = "You have to wait to challenge " .. dreamScar[i].bossName .. " again!"
					else
						destination = Position(32208, 32026, 13)
					end
					break
				end
			end
		end
	else
		for _, k in pairs(default) do
			if k.itemPosition == iPos then
				if player:getStorageValue(k.neededStorage) >= k.value then
					destination = k.toPosition
					successMessage = k.msg
				else
					message = k.blockedText
				end
				break
			end
		end
	end

	if message then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
	end
	if not player:teleportTo(destination) then
		return false
	end
	if successMessage then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, successMessage)
	end
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	return true
end

movements_acessTeleports:aid(23103)
movements_acessTeleports:register()
