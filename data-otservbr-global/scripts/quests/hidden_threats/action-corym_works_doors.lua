local perfectlyForgedKey = Action()

-- The Corym Works doors are registered in QuestDoorAction (door_quest.lua), and
-- loadLuaMapAction stamps each door with an actionid equal to its storage key.
-- Match against the same storage keys instead of unrelated literals so the
-- forged key actually unlocks the doors.
function perfectlyForgedKey.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local HiddenThreats = Storage.Quest.U11_50.HiddenThreats
	local actionid = target.actionid

	local doorStorage
	if actionid == HiddenThreats.CorymWorksDoor01 then
		doorStorage = HiddenThreats.CorymWorksDoor01
	elseif actionid == HiddenThreats.CorymWorksDoor02 then
		doorStorage = HiddenThreats.CorymWorksDoor02
	elseif actionid == HiddenThreats.CorymWorksDoor03 then
		doorStorage = HiddenThreats.CorymWorksDoor03
	else
		return false
	end

	if player:getStorageValue(doorStorage) < 0 then
		player:setStorageValue(doorStorage, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The forged key unlocks the door.")
	end
	return true
end

perfectlyForgedKey:id(27269)
perfectlyForgedKey:register()
