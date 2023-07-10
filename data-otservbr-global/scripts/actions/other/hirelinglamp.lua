local hirelingLamp = Action()

function hirelingLamp.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local spawnPosition = player:getPosition()
	local hireling_id = item:getCustomAttribute("Hireling")
	local house = spawnPosition and spawnPosition:getTile() and spawnPosition:getTile():getHouse() or nil
	if not house then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendTextMessage(MESSAGE_FAILURE, "You may use this only inside a house.")
		return false
	elseif house:getDoorIdByPosition(spawnPosition) then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendTextMessage(MESSAGE_FAILURE, "You cannot spawn a hireling on the door")
		return false
	elseif getHirelingByPosition(spawnPosition) then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendTextMessage(MESSAGE_FAILURE, "You cannot spawn another hireling here.")
		return false
	elseif house:getOwnerGuid() ~= player:getGuid() then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendTextMessage(MESSAGE_FAILURE, "You cannot spawn a hireling on another's person house.")
		return false
	end

	local hireling = getHirelingById(hireling_id)
	if not hireling then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There was an error creating the hireling and it has been deleted, please, contact server admin.")
		Spdlog.error(string.format("[hirelingLamp.onUse] Player '%s' is using hireling not exist in the database", player:getName(), hireling_id))
		Spdlog.error("Deleted the lamp")
		item:remove(1)
		return true
	end

	hireling:setPosition(spawnPosition)
	item:remove(1)
	hireling:spawn()
	spawnPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

hirelingLamp:id(HIRELING_LAMP)
hirelingLamp:register()
