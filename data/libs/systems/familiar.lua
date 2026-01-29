FAMILIAR_ID = {
	[VOCATION.BASE_ID.SORCERER] = { id = 994, name = "Sorcerer familiar" },
	[VOCATION.BASE_ID.DRUID] = { id = 993, name = "Druid familiar" },
	[VOCATION.BASE_ID.PALADIN] = { id = 992, name = "Paladin familiar" },
	[VOCATION.BASE_ID.KNIGHT] = { id = 991, name = "Knight familiar" },
	[VOCATION.BASE_ID.MONK] = { id = 1818, name = "Monk familiar" },
}

FAMILIAR_TIMER = {
	[1] = { storage = Global.Storage.FamiliarSummonEvent10, countdown = 10, message = "10 seconds" },
	[2] = { storage = Global.Storage.FamiliarSummonEvent60, countdown = 60, message = "one minute" },
}

function SendMessageFunction(playerId, message)
	if Player(playerId) then
		Player(playerId):sendTextMessage(MESSAGE_LOOT, "Your summon will disappear in less than " .. message)
	end
end

function RemoveFamiliar(creatureId, playerId)
	local creature = Creature(creatureId)
	local player = Player(playerId)
	if not creature or not player then
		return true
	end
	creature:remove()
	for sendMessage = 1, #FAMILIAR_TIMER do
		player:setStorageValue(FAMILIAR_TIMER[sendMessage].storage, -1)
	end
end
