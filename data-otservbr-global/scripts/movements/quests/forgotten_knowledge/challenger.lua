local destination = {
	[1067] = {
		newPos = Position(32903, 31630, 14),
		backPos = Position(32915, 31639, 14),
		storage = Storage.ForgottenKnowledge.LadyTenebrisTimer
	},
	[1068] = {
		newPos = Position(32658, 32885, 14),
		backPos = Position(32678, 32888, 14),
		storage = Storage.ForgottenKnowledge.ThornKnightTimer
	},
	[1069] = {
		newPos = Position(33391, 31184, 10),
		backPos = Position(33407, 31172, 10),
		storage = Storage.ForgottenKnowledge.DragonkingTimer
	},
	[1070] = {
		newPos = Position(32302, 31095, 14),
		backPos = Position(32318, 31091, 14),
		storage = Storage.ForgottenKnowledge.HorrorTimer
	},
	[1071] = {
		newPos = Position(33026, 31663, 14),
		backPos = Position(32849, 32691, 15),
		storage = Storage.ForgottenKnowledge.TimeGuardianTimer
	},
	[1072] = {
		newPos = Position(32019, 32851, 14),
		backPos = Position(32035, 32859, 14),
		storage = Storage.ForgottenKnowledge.LastLoreTimer
	}
}

local challenger = MoveEvent()

function challenger.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local teleport = destination[item.uid]
	if not teleport then
		return
	end
	if player:getStorageValue(teleport.storage) <= os.time() then
		if item.uid == 24882 then
			if player:getStorageValue(Storage.ForgottenKnowledge.BabyDragon) < 1 then
				player:teleportTo(teleport.backPos)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You not have permission to use this teleport!")
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				return true
			end
		end
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(teleport.newPos)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	else
		player:teleportTo(teleport.backPos)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait to challenge this enemy again!")
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	return true
end

challenger:type("stepin")

for index, value in pairs(destination) do
	challenger:uid(index)
end

challenger:register()
