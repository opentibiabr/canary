local mission9TheDeepestCatacombTeleport = MoveEvent()

local amphoraStorages = {
	Storage.Quest.U7_6.TheApeCity.TheLargeAmphoras1,
	Storage.Quest.U7_6.TheApeCity.TheLargeAmphoras2,
	Storage.Quest.U7_6.TheApeCity.TheLargeAmphoras3,
	Storage.Quest.U7_6.TheApeCity.TheLargeAmphoras4,
}

local cooldownStorage = Storage.Quest.U7_6.TheApeCity.TheLargeAmphorasCooldown
local cooldownTime = 5 * 60
local accountQuestId = "the-ape-city"

function mission9TheDeepestCatacombTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.uid == 9257 then
		local hasCharacterAccess = player:getStorageValue(Storage.Quest.U7_6.TheApeCity.Questline) >= 17
		local hasAccountAccess = player:hasAccountQuestAccess(accountQuestId)

		if hasCharacterAccess then
			player:unlockAccountQuestAccess(accountQuestId)
		end

		if hasCharacterAccess or hasAccountAccess then
			player:teleportTo(Position(32749, 32536, 10))
			position:sendMagicEffect(CONST_ME_TELEPORT)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	elseif item.uid == 9258 then
		local cooldownStart = player:getStorageValue(cooldownStorage)
		if cooldownStart > 0 and (os.time() - cooldownStart) > cooldownTime then
			for _, storage in pairs(amphoraStorages) do
				player:setStorageValue(storage, 0)
			end
			player:setStorageValue(cooldownStorage, 0)
		end

		local allAmphorasBroken = true
		for _, storage in pairs(amphoraStorages) do
			if player:getStorageValue(storage) < 1 then
				allAmphorasBroken = false
				break
			end
		end

		if allAmphorasBroken then
			player:teleportTo(Position(32885, 32632, 11))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end

		player:teleportTo(fromPosition)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to break all 4 large amphoras to use this teleporter.")
		return true
	end

	player:teleportTo(fromPosition, true)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this area.")
	return true
end

mission9TheDeepestCatacombTeleport:type("stepin")
mission9TheDeepestCatacombTeleport:uid(9257, 9258)
mission9TheDeepestCatacombTeleport:register()
