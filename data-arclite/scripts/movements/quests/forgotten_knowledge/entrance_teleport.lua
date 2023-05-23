local destination = {
	[25047] = {
		newPos = Position(32807, 31657, 8),
		storage = Storage.ForgottenKnowledge.AccessDeath,
		effect = CONST_ME_MORTAREA
	},
	[25048] = {
		newPos = Position(32325, 32089,7),
		storage = Storage.ForgottenKnowledge.AccessDeath,
		effect = CONST_ME_MORTAREA
	},
	[25051] = {
		newPos = Position(32786, 32820, 13),
		storage = Storage.ForgottenKnowledge.AccessViolet,
		effect = CONST_ME_PURPLEENERGY
	},
	[25052] = {
		newPos = Position(32328, 32089,7),
		storage = Storage.ForgottenKnowledge.AccessViolet,
		effect = CONST_ME_PURPLEENERGY
	},
	[25049] = {
		newPos = Position(32637, 32256, 7),
		storage = Storage.ForgottenKnowledge.AccessEarth,
		effect = CONST_ME_SMALLPLANTS
	},
	[25050] = {
		newPos = Position(32331, 32089, 7),
		storage = Storage.ForgottenKnowledge.AccessEarth,
		effect = CONST_ME_SMALLPLANTS
	},
	[25053] = {
		newPos = Position(33341, 31168, 7),
		storage = Storage.ForgottenKnowledge.AccessFire,
		effect = CONST_ME_FIREAREA
	},
	[25054] = {
		newPos = Position(32334, 32089,7),
		storage = Storage.ForgottenKnowledge.AccessFire,
		effect = CONST_ME_FIREAREA
	},
	[25057] = {
		newPos = Position(32207, 31036, 10),
		storage = Storage.ForgottenKnowledge.AccessIce,
		effect = CONST_ME_ICEATTACK
	},
	[25058] = {
		newPos = Position(32337, 32089,7),
		storage = Storage.ForgottenKnowledge.AccessIce,
		effect = CONST_ME_ICEATTACK
	},
	[25055] = {
		newPos = Position(32780, 32686, 14),
		storage = Storage.ForgottenKnowledge.AccessGolden,
		effect = CONST_ME_YELLOWENERGY
	},
	[25056] = {
		newPos = Position(32340, 32089, 7),
		storage = Storage.ForgottenKnowledge.AccessGolden,
		effect = CONST_ME_YELLOWENERGY
	},
	[10840] = {
		newPos = Position(32907, 32848, 13),
		storage = Storage.ForgottenKnowledge.AccessLast,
		effect = CONST_ME_ENERGYHIT
	},
	[10842] = {
		newPos = Position(32332, 32092, 7),
		storage = Storage.ForgottenKnowledge.AccessLast,
	effect = CONST_ME_ENERGYHIT}
}

local entranceTeleport = MoveEvent()

function entranceTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local teleport = destination[item.itemid]
	if not teleport then
		return
	end
	if item.itemid == 10840 then
		if player:getStorageValue(Storage.ForgottenKnowledge.AccessLast) < 1 then
			if player:getStorageValue(Storage.ForgottenKnowledge.LadyTenebrisKilled) >= 1
			and player:getStorageValue(Storage.ForgottenKnowledge.LloydKilled) >= 1
			and player:getStorageValue(Storage.ForgottenKnowledge.ThornKnightKilled) >= 1
			and player:getStorageValue(Storage.ForgottenKnowledge.DragonkingKilled) >= 1
			and player:getStorageValue(Storage.ForgottenKnowledge.HorrorKilled) >= 1
			and player:getStorageValue(Storage.ForgottenKnowledge.TimeGuardianKilled) >= 1 then
				player:setStorageValue(Storage.ForgottenKnowledge.AccessLast, 1)
			end
		end
	end
	if player:getStorageValue(teleport.storage) >= 1 then
		position:sendMagicEffect(teleport.effect)
		player:teleportTo(teleport.newPos)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	else
		if item.itemid == 10840 then
			player:teleportTo(fromPosition)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don\'t have the permission to use this portal.")
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
		local pos = position
		pos.y = pos.y + 2
		player:teleportTo(pos)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don\'t have the permission to use this portal.")
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		pos.y = pos.y - 2
		pos:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end


entranceTeleport:type("stepin")
entranceTeleport:aid(24873)
entranceTeleport:register()
