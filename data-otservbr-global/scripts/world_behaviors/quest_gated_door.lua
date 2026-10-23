local gatedDoor = WorldBehavior("quest.gated_door", 1)

function gatedDoor.onUse(context, player, item, fromPosition, target, toPosition, isHotkey)
	local requiredLevel = context:parameter("requiredLevel")
	local storageKey = context:parameter("storageKey")
	local requiredValue = context:parameter("requiredValue")
	if player:getLevel() < requiredLevel or player:getStorageValue(storageKey) < requiredValue then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, context:parameter("deniedMessage"))
		return false
	end

	local relation = context:relation("door")
	local doorObject = relation and relation:getObject()
	local door = doorObject and doorObject:getItem()
	if not door then
		return false
	end
	local openItemId = context:parameter("openDoorItemId")
	return door:transform(openItemId) == true and door:getId() == openItemId
end

gatedDoor:register()
